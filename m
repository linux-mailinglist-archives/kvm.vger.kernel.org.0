Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1680E3B5CA7
	for <lists+kvm@lfdr.de>; Mon, 28 Jun 2021 12:44:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232781AbhF1KrR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Jun 2021 06:47:17 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:37708 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232773AbhF1KrL (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 28 Jun 2021 06:47:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624877085;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8ClWmNJunkduYZWOpWbHN9GQTktpYf3xp4ONsqAgRec=;
        b=buWnAqoOwOVR6zt5/m57RspFdujOUvDULSbJzVZYHjDBu4AQPyJMWXg6MtRuzHMILBjzDs
        hgeLcIcQ/FkknLc1WequdJ3o2sLno+2oaXktrBI3snwsLqo6broAZRtjaBMdvVmfFoN24B
        5oquk/vTkjQBamUBpOwUVZRIvSWEw68=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-112-JPVw_o13M5C00PCKkQ0AeA-1; Mon, 28 Jun 2021 06:44:44 -0400
X-MC-Unique: JPVw_o13M5C00PCKkQ0AeA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E5A4F19253C6;
        Mon, 28 Jun 2021 10:44:42 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.194.122])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B96A45C1CF;
        Mon, 28 Jun 2021 10:44:37 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Cathy Avery <cavery@redhat.com>,
        Emanuele Giuseppe Esposito <eesposit@redhat.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Michael Roth <mdroth@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/6] KVM: nSVM: Check that VM_HSAVE_PA MSR was set before VMRUN
Date:   Mon, 28 Jun 2021 12:44:21 +0200
Message-Id: <20210628104425.391276-3-vkuznets@redhat.com>
In-Reply-To: <20210628104425.391276-1-vkuznets@redhat.com>
References: <20210628104425.391276-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

APM states that "The address written to the VM_HSAVE_PA MSR, which holds
the address of the page used to save the host state on a VMRUN, must point
to a hypervisor-owned page. If this check fails, the WRMSR will fail with
a #GP(0) exception. Note that a value of 0 is not considered valid for the
VM_HSAVE_PA MSR and a VMRUN that is attempted while the HSAVE_PA is 0 will
fail with a #GP(0) exception."

svm_set_msr() already checks that the supplied address is valid, so only
check for '0' is missing. Add it to nested_svm_vmrun().

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/kvm/svm/nested.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 21d03e3a5dfd..1c6b0698b52e 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -618,6 +618,11 @@ int nested_svm_vmrun(struct kvm_vcpu *vcpu)
 	struct kvm_host_map map;
 	u64 vmcb12_gpa;
 
+	if (!svm->nested.hsave_msr) {
+		kvm_inject_gp(vcpu, 0);
+		return 1;
+	}
+
 	if (is_smm(vcpu)) {
 		kvm_queue_exception(vcpu, UD_VECTOR);
 		return 1;
-- 
2.31.1

