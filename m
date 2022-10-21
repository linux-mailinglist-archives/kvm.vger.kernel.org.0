Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ECDCE607AF8
	for <lists+kvm@lfdr.de>; Fri, 21 Oct 2022 17:37:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230285AbiJUPgw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Oct 2022 11:36:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230464AbiJUPgZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Oct 2022 11:36:25 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A436326FF9B
        for <kvm@vger.kernel.org>; Fri, 21 Oct 2022 08:35:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1666366549;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=f++jtCVV3Bzf3njGlDjTrMlhnT3CSdLKyjbOGm7F9fM=;
        b=LxSL/y6nN8Wzd7PmmRPrguf0YTYhMt2noZaAWj07arlsq1dsOQyX7n1DkQihSszTtWTWAv
        r/bvfsgnmyiAFWoCfyNjlBRBqpdmDgus/uv+voZ2mr/Qd12kSS+gQrizrKmpTPptMyOLc5
        4ZtW/XQe14t7Y8Ne2by1SmGTanSv/1o=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-327-HMgcBH65MdyJWp0bpSCsXg-1; Fri, 21 Oct 2022 11:35:45 -0400
X-MC-Unique: HMgcBH65MdyJWp0bpSCsXg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 44D6C101AA4D;
        Fri, 21 Oct 2022 15:35:44 +0000 (UTC)
Received: from ovpn-192-65.brq.redhat.com (ovpn-192-65.brq.redhat.com [10.40.192.65])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1FD1A400EA8B;
        Fri, 21 Oct 2022 15:35:42 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Siddharth Chandrasekaran <sidcha@amazon.de>,
        Yuan Yao <yuan.yao@linux.intel.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v12 07/46] KVM: x86: Move clearing of TLB_FLUSH_CURRENT to kvm_vcpu_flush_tlb_all()
Date:   Fri, 21 Oct 2022 17:34:42 +0200
Message-Id: <20221021153521.1216911-8-vkuznets@redhat.com>
In-Reply-To: <20221021153521.1216911-1-vkuznets@redhat.com>
References: <20221021153521.1216911-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <seanjc@google.com>

Clear KVM_REQ_TLB_FLUSH_CURRENT in kvm_vcpu_flush_tlb_all() instead of in
its sole caller that processes KVM_REQ_TLB_FLUSH.  Regardless of why/when
kvm_vcpu_flush_tlb_all() is called, flushing "all" TLB entries also
flushes "current" TLB entries.

Ideally, there will never be another caller of kvm_vcpu_flush_tlb_all(),
and moving the handling "requires" extra work to document the ordering
requirement, but future Hyper-V paravirt TLB flushing support will add
similar logic for flush "guest" (Hyper-V can flush a subset of "guest"
entries).  And in the Hyper-V case, KVM needs to do more than just clear
the request, the queue of GPAs to flush also needs to purged, and doing
all only in the request path is undesirable as kvm_vcpu_flush_tlb_guest()
does have multiple callers (though it's unlikely KVM's paravirt TLB flush
will coincide with Hyper-V's paravirt TLB flush).

Move the logic even though it adds extra "work" so that KVM will be
consistent with how flush requests are processed when the Hyper-V support
lands.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/kvm/x86.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index f618187585b1..fdda5f447f87 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3396,6 +3396,9 @@ static void kvm_vcpu_flush_tlb_all(struct kvm_vcpu *vcpu)
 {
 	++vcpu->stat.tlb_flush;
 	static_call(kvm_x86_flush_tlb_all)(vcpu);
+
+	/* Flushing all ASIDs flushes the current ASID... */
+	kvm_clear_request(KVM_REQ_TLB_FLUSH_CURRENT, vcpu);
 }
 
 static void kvm_vcpu_flush_tlb_guest(struct kvm_vcpu *vcpu)
@@ -10477,12 +10480,15 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 			kvm_mmu_sync_roots(vcpu);
 		if (kvm_check_request(KVM_REQ_LOAD_MMU_PGD, vcpu))
 			kvm_mmu_load_pgd(vcpu);
-		if (kvm_check_request(KVM_REQ_TLB_FLUSH, vcpu)) {
+
+		/*
+		 * Note, the order matters here, as flushing "all" TLB entries
+		 * also flushes the "current" TLB entries, i.e. servicing the
+		 * flush "all" will clear any request to flush "current".
+		 */
+		if (kvm_check_request(KVM_REQ_TLB_FLUSH, vcpu))
 			kvm_vcpu_flush_tlb_all(vcpu);
 
-			/* Flushing all ASIDs flushes the current ASID... */
-			kvm_clear_request(KVM_REQ_TLB_FLUSH_CURRENT, vcpu);
-		}
 		kvm_service_local_tlb_flush_requests(vcpu);
 
 		if (kvm_check_request(KVM_REQ_REPORT_TPR_ACCESS, vcpu)) {
-- 
2.37.3

