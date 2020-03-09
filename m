Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 19F0E17E407
	for <lists+kvm@lfdr.de>; Mon,  9 Mar 2020 16:52:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727125AbgCIPwt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Mar 2020 11:52:49 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:56595 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727124AbgCIPwc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Mar 2020 11:52:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583769150;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3E4LIBi/eaTA+USlOTfstaQ+9ylrR99sJyL6v/S7Fzk=;
        b=RgnK5S4OCgxqO6Kh/A4QZ4z7op1FUFfSat1Ittg5vuPUPn9WUaANF97ml6bdntVLf5UsWH
        LchrrAkz48sR/zjiUOMfe7RT/RbCZrzwEHMYImHg4HZHlWx58XVekxaC2kezF2hcNVT0y/
        wmIGBBaSpnSldytrQmWCuRhlqRwHGQ0=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-304-7uG4iJMsNrSZhcnKuntN5Q-1; Mon, 09 Mar 2020 11:52:23 -0400
X-MC-Unique: 7uG4iJMsNrSZhcnKuntN5Q-1
Received: by mail-wr1-f72.google.com with SMTP id p11so5383391wrn.10
        for <kvm@vger.kernel.org>; Mon, 09 Mar 2020 08:52:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3E4LIBi/eaTA+USlOTfstaQ+9ylrR99sJyL6v/S7Fzk=;
        b=NWO2AWnUdmZvo1FflMDyWlNQBi7XbO8WyVQc2pkPK59ZknwHQiOT2/sjB62sksSMVP
         R3Ggy3RufWIN/bVYJ5FZmoWaqNl+PvrMcl9tnOcB30wHkayjsyeuwE4a9X+TjY4BrygW
         Vm4EIhFdjK+rxfHhIq7i4HMS9eG6oqDz6/1Oa36dWXrn78NcXO0TG/13Y9Ut5uP59Rpk
         ZZI1LSh1iNfDXmQ6079jIO1o7XTCZqBWMbfnO0ZcIskLsvdQ69ihM4icxQx9deMf9kpf
         CIR+CEPjwotuqOqSJzVnQXG9ASf2U0Orgm3t4jRuAmOtyKNCG42MMxPQ9mjzptoHR6/o
         HzAA==
X-Gm-Message-State: ANhLgQ3Wc7UKGviPXnhg7O9dJpPjp1r72lsTNd1sid+szZBHs0BaIJO9
        p8ThfScJMWg81WXGm+KsHs1DV01yJOTk9Vg4sdcpsjPDndxJ+PodQbwpHkE2uhi842wVrWZs8i3
        OusSexISJOHcf
X-Received: by 2002:a5d:5411:: with SMTP id g17mr20557077wrv.4.1583769142618;
        Mon, 09 Mar 2020 08:52:22 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vs9pNoq6eROQLSMnQjOi+/bC2QHYG7NKgj7y/VTWqWWzCnhRUMXrJkC1KQDPqK4jhMpsxv/EA==
X-Received: by 2002:a5d:5411:: with SMTP id g17mr20557054wrv.4.1583769142367;
        Mon, 09 Mar 2020 08:52:22 -0700 (PDT)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id q4sm17294521wro.56.2020.03.09.08.52.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Mar 2020 08:52:20 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Jim Mattson <jmattson@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Liran Alon <liran.alon@oracle.com>,
        Miaohe Lin <linmiaohe@huawei.com>
Subject: [PATCH 1/6] KVM: nVMX: avoid NULL pointer dereference with incorrect EVMCS GPAs
Date:   Mon,  9 Mar 2020 16:52:11 +0100
Message-Id: <20200309155216.204752-2-vkuznets@redhat.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200309155216.204752-1-vkuznets@redhat.com>
References: <20200309155216.204752-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When an EVMCS enabled L1 guest on KVM will tries doing enlightened VMEnter
with EVMCS GPA = 0 the host crashes because the

evmcs_gpa != vmx->nested.hv_evmcs_vmptr

condition in nested_vmx_handle_enlightened_vmptrld() will evaluate to
false (as nested.hv_evmcs_vmptr is zeroed after init). The crash will
happen on vmx->nested.hv_evmcs pointer dereference.

Another problematic EVMCS ptr value is '-1' but it only causes host crash
after nested_release_evmcs() invocation. The problem is exactly the same as
with '0', we mistakenly think that the EVMCS pointer hasn't changed and
thus nested.hv_evmcs_vmptr is valid.

Resolve the issue by adding an additional !vmx->nested.hv_evmcs
check to nested_vmx_handle_enlightened_vmptrld(), this way we will
always be trying kvm_vcpu_map() when nested.hv_evmcs is NULL
and this is supposed to catch all invalid EVMCS GPAs.

Also, initialize hv_evmcs_vmptr to '0' in nested_release_evmcs()
to be consistent with initialization where we don't currently
set hv_evmcs_vmptr to '-1'.

Cc: stable@vger.kernel.org
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/kvm/vmx/nested.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index e920d7834d73..9750e590c89d 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -224,7 +224,7 @@ static inline void nested_release_evmcs(struct kvm_vcpu *vcpu)
 		return;
 
 	kvm_vcpu_unmap(vcpu, &vmx->nested.hv_evmcs_map, true);
-	vmx->nested.hv_evmcs_vmptr = -1ull;
+	vmx->nested.hv_evmcs_vmptr = 0;
 	vmx->nested.hv_evmcs = NULL;
 }
 
@@ -1923,7 +1923,8 @@ static int nested_vmx_handle_enlightened_vmptrld(struct kvm_vcpu *vcpu,
 	if (!nested_enlightened_vmentry(vcpu, &evmcs_gpa))
 		return 1;
 
-	if (unlikely(evmcs_gpa != vmx->nested.hv_evmcs_vmptr)) {
+	if (unlikely(!vmx->nested.hv_evmcs ||
+		     evmcs_gpa != vmx->nested.hv_evmcs_vmptr)) {
 		if (!vmx->nested.hv_evmcs)
 			vmx->nested.current_vmptr = -1ull;
 
-- 
2.24.1

