Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD40A35DEC9
	for <lists+kvm@lfdr.de>; Tue, 13 Apr 2021 14:31:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345697AbhDMM17 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Apr 2021 08:27:59 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:46480 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1345619AbhDMM13 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 13 Apr 2021 08:27:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618316829;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nsDZCBTK6hj0udyAzJsfA8vs4YUhJm7ggbRLSSXn/5U=;
        b=CkBPKIp0mRDQLEwhX2hDlDcSgFnwzt0XrDT6sxXpDA+PikQVg3qhE6NUR1SMXfkuykIO79
        t9KpEA4B3qjFlc04w1gJEiSJQE/is5GTUJjfvqbl66mkhV6wR2IPGQV/HR1vNkFXHNoauA
        ytGP/R8adCNo1fG+SuzY9Jx19/kKNgs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-386-ou0UUlE0MteZq4qMdMTbnw-1; Tue, 13 Apr 2021 08:27:07 -0400
X-MC-Unique: ou0UUlE0MteZq4qMdMTbnw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5EBAB87A83B;
        Tue, 13 Apr 2021 12:27:06 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.195.75])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4753D60C04;
        Tue, 13 Apr 2021 12:27:01 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Siddharth Chandrasekaran <sidcha@amazon.de>,
        linux-kernel@vger.kernel.org, linux-hyperv@vger.kernel.org
Subject: [PATCH RFC 09/22] KVM: x86: hyper-v: Honor HV_MSR_SYNIC_AVAILABLE privilege bit
Date:   Tue, 13 Apr 2021 14:26:17 +0200
Message-Id: <20210413122630.975617-10-vkuznets@redhat.com>
In-Reply-To: <20210413122630.975617-1-vkuznets@redhat.com>
References: <20210413122630.975617-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

SynIC MSRs (HV_X64_MSR_SCONTROL, HV_X64_MSR_SVERSION, HV_X64_MSR_SIEFP,
HV_X64_MSR_SIMP, HV_X64_MSR_EOM, HV_X64_MSR_SINT0 ... HV_X64_MSR_SINT15)
are only available to guest when HV_MSR_SYNIC_AVAILABLE bit is exposed.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/kvm/hyperv.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index 48215ad72b6c..d85c441011c4 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -211,7 +211,9 @@ static int synic_set_msr(struct kvm_vcpu_hv_synic *synic,
 	struct kvm_vcpu *vcpu = hv_synic_to_vcpu(synic);
 	int ret;
 
-	if (!synic->active && !host)
+	if (unlikely(!host &&
+		     (!synic->active || !(to_hv_vcpu(vcpu)->cpuid_cache.features_eax &
+					  HV_MSR_SYNIC_AVAILABLE))))
 		return 1;
 
 	trace_kvm_hv_synic_set_msr(vcpu->vcpu_id, msr, data, host);
@@ -383,9 +385,12 @@ static int syndbg_get_msr(struct kvm_vcpu *vcpu, u32 msr, u64 *pdata, bool host)
 static int synic_get_msr(struct kvm_vcpu_hv_synic *synic, u32 msr, u64 *pdata,
 			 bool host)
 {
+	struct kvm_vcpu *vcpu = hv_synic_to_vcpu(synic);
 	int ret;
 
-	if (!synic->active && !host)
+	if (unlikely(!host &&
+		     (!synic->active || !(to_hv_vcpu(vcpu)->cpuid_cache.features_eax &
+					  HV_MSR_SYNIC_AVAILABLE))))
 		return 1;
 
 	ret = 0;
-- 
2.30.2

