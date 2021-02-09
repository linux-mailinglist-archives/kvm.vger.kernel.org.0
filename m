Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CC5A314B30
	for <lists+kvm@lfdr.de>; Tue,  9 Feb 2021 10:12:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230247AbhBIJMU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Feb 2021 04:12:20 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:46304 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230469AbhBIJG1 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 9 Feb 2021 04:06:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612861494;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=oAORKjLJ673EprzL/i9GHggWNiC+j4DYLlPEDjDCXoA=;
        b=bq9Ru+eGvWGmKgc957yV70rG2ha7LCPqO7vabYs039ERQF9w2euNS1CLEtAPCmxyXr+K2o
        /aGDjRHelcIsI7jcbTilAI34RgzBW5vUmj97vXGs4ALk8bIGjcKQzEftOd0NHUx96/p4ts
        BswR6zFK13V6KzNpioyxxC+gGLTsdhI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-593-aUAASB9WNV2VnpmnMKCzVA-1; Tue, 09 Feb 2021 04:04:53 -0500
X-MC-Unique: aUAASB9WNV2VnpmnMKCzVA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CC98939397;
        Tue,  9 Feb 2021 09:04:51 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.195.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1372160C04;
        Tue,  9 Feb 2021 09:04:49 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH] KVM: x86: hyper-v: Fix erroneous 'current_vcpu' usage in kvm_hv_flush_tlb()
Date:   Tue,  9 Feb 2021 10:04:48 +0100
Message-Id: <20210209090448.378472-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Previously, we used to use 'current_vcpu' instead of 'vcpu' in
kvm_hv_flush_tlb() but this is no longer the case, it should clearly
be 'vcpu' here, a mistake was made during rebase.

Reported-by: Maxim Levitsky <mlevitsk@redhat.com>
Fixes: d210b1e5b685 ("KVM: x86: hyper-v: Always use to_hv_vcpu() accessor to get to 'struct kvm_vcpu_hv'"
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
The broken patch is only in kvm/queue atm, we may as well want
to squash the change.
---
 arch/x86/kvm/hyperv.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index 880ba3c678db..7d2dae92d638 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -1555,7 +1555,7 @@ static __always_inline unsigned long *sparse_set_to_vcpu_mask(
 static u64 kvm_hv_flush_tlb(struct kvm_vcpu *vcpu, u64 ingpa, u16 rep_cnt, bool ex)
 {
 	struct kvm *kvm = vcpu->kvm;
-	struct kvm_vcpu_hv *hv_vcpu = to_hv_vcpu(current_vcpu);
+	struct kvm_vcpu_hv *hv_vcpu = to_hv_vcpu(vcpu);
 	struct hv_tlb_flush_ex flush_ex;
 	struct hv_tlb_flush flush;
 	u64 vp_bitmap[KVM_HV_MAX_SPARSE_VCPU_SET_BITS];
-- 
2.29.2

