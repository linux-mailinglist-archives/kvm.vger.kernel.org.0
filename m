Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C99754B0258
	for <lists+kvm@lfdr.de>; Thu, 10 Feb 2022 02:32:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232733AbiBJBbp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Feb 2022 20:31:45 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:38536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232620AbiBJBbk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Feb 2022 20:31:40 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D921F25D0
        for <kvm@vger.kernel.org>; Wed,  9 Feb 2022 17:31:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description;
        bh=1qcdLnfj9OsEH3dcLdWFRjxr11eA1hrs7qlmndQN3IQ=; b=d3lZpqBCatZxI7wcxkN0DITmLt
        drTRgMWfUjueRhgupzNf8d2Jafjq1MxkVBdhQB7NkO0CbLuXJPZCrkRkWp1tfy6aOeah7EpUkCYTn
        7EaCeKyK1rWs8tfCxmJJANTb1iZsBBfpU5nrMSjCmyVeVDdSQISzRRlVrEt1XxN13wWQ0hYMhlwWj
        Z05b1v4i+xODfP4Ns0QqL0W/TCnCh6r4SXS3RJc1AB79dkoY5MHYla+ioYU+NkGSY/Ye8Phz3RiNB
        OR3xicMbROQc6ULQJH4ZlzNJNg7WM0tO2mtb5mDdyfy0TmsUdLph0E8oxZ4BOErFZF5KtiklrUh2s
        DSNpU/4Q==;
Received: from i7.infradead.org ([2001:8b0:10b:1:21e:67ff:fecb:7a92])
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nHxIy-008xl4-HR; Thu, 10 Feb 2022 00:27:24 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nHxIy-0019D3-2D; Thu, 10 Feb 2022 00:27:24 +0000
From:   David Woodhouse <dwmw2@infradead.org>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Joao Martins <joao.m.martins@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Metin Kaya <metikaya@amazon.co.uk>,
        Paul Durrant <pdurrant@amazon.co.uk>
Subject: [PATCH v0 05/15] KVM: x86/xen: Use gfn_to_pfn_cache for vcpu_time_info
Date:   Thu, 10 Feb 2022 00:27:11 +0000
Message-Id: <20220210002721.273608-6-dwmw2@infradead.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220210002721.273608-1-dwmw2@infradead.org>
References: <20220210002721.273608-1-dwmw2@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: David Woodhouse <dwmw2@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: David Woodhouse <dwmw@amazon.co.uk>

This switches the final pvclock to kvm_setup_pvclock_pfncache() and now
the old kvm_setup_pvclock_page() can be removed.

Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
---
 arch/x86/include/asm/kvm_host.h |  3 +-
 arch/x86/kvm/x86.c              | 63 ++-------------------------------
 arch/x86/kvm/xen.c              | 24 ++++++-------
 3 files changed, 13 insertions(+), 77 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 118c9ce8e821..1c63296d3951 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -601,9 +601,8 @@ struct kvm_vcpu_hv {
 struct kvm_vcpu_xen {
 	u64 hypercall_rip;
 	u32 current_runstate;
-	bool vcpu_time_info_set;
 	struct gfn_to_pfn_cache vcpu_info_cache;
-	struct gfn_to_hva_cache vcpu_time_info_cache;
+	struct gfn_to_pfn_cache vcpu_time_info_cache;
 	struct gfn_to_pfn_cache runstate_cache;
 	u64 last_steal;
 	u64 runstate_entry_time;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 268f64b70768..72c72a36bd4d 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2969,65 +2969,6 @@ static void kvm_setup_guest_pvclock(struct kvm_vcpu *v,
 	trace_kvm_pvclock_update(v->vcpu_id, &vcpu->hv_clock);
 }
 
-static void kvm_setup_pvclock_page(struct kvm_vcpu *v,
-				   struct gfn_to_hva_cache *cache,
-				   unsigned int offset)
-{
-	struct kvm_vcpu_arch *vcpu = &v->arch;
-	struct pvclock_vcpu_time_info guest_hv_clock;
-
-	if (unlikely(kvm_read_guest_offset_cached(v->kvm, cache,
-		&guest_hv_clock, offset, sizeof(guest_hv_clock))))
-		return;
-
-	/* This VCPU is paused, but it's legal for a guest to read another
-	 * VCPU's kvmclock, so we really have to follow the specification where
-	 * it says that version is odd if data is being modified, and even after
-	 * it is consistent.
-	 *
-	 * Version field updates must be kept separate.  This is because
-	 * kvm_write_guest_cached might use a "rep movs" instruction, and
-	 * writes within a string instruction are weakly ordered.  So there
-	 * are three writes overall.
-	 *
-	 * As a small optimization, only write the version field in the first
-	 * and third write.  The vcpu->pv_time cache is still valid, because the
-	 * version field is the first in the struct.
-	 */
-	BUILD_BUG_ON(offsetof(struct pvclock_vcpu_time_info, version) != 0);
-
-	if (guest_hv_clock.version & 1)
-		++guest_hv_clock.version;  /* first time write, random junk */
-
-	vcpu->hv_clock.version = guest_hv_clock.version + 1;
-	kvm_write_guest_offset_cached(v->kvm, cache,
-				      &vcpu->hv_clock, offset,
-				      sizeof(vcpu->hv_clock.version));
-
-	smp_wmb();
-
-	/* retain PVCLOCK_GUEST_STOPPED if set in guest copy */
-	vcpu->hv_clock.flags |= (guest_hv_clock.flags & PVCLOCK_GUEST_STOPPED);
-
-	if (vcpu->pvclock_set_guest_stopped_request) {
-		vcpu->hv_clock.flags |= PVCLOCK_GUEST_STOPPED;
-		vcpu->pvclock_set_guest_stopped_request = false;
-	}
-
-	trace_kvm_pvclock_update(v->vcpu_id, &vcpu->hv_clock);
-
-	kvm_write_guest_offset_cached(v->kvm, cache,
-				      &vcpu->hv_clock, offset,
-				      sizeof(vcpu->hv_clock));
-
-	smp_wmb();
-
-	vcpu->hv_clock.version++;
-	kvm_write_guest_offset_cached(v->kvm, cache,
-				     &vcpu->hv_clock, offset,
-				     sizeof(vcpu->hv_clock.version));
-}
-
 static int kvm_guest_time_update(struct kvm_vcpu *v)
 {
 	unsigned long flags, tgt_tsc_khz;
@@ -3119,8 +3060,8 @@ static int kvm_guest_time_update(struct kvm_vcpu *v)
 	if (vcpu->xen.vcpu_info_cache.active)
 		kvm_setup_guest_pvclock(v, &vcpu->xen.vcpu_info_cache,
 					offsetof(struct compat_vcpu_info, time));
-	if (vcpu->xen.vcpu_time_info_set)
-		kvm_setup_pvclock_page(v, &vcpu->xen.vcpu_time_info_cache, 0);
+	if (vcpu->xen.vcpu_time_info_cache.active)
+		kvm_setup_guest_pvclock(v, &vcpu->xen.vcpu_time_info_cache, 0);
 	if (!v->vcpu_idx)
 		kvm_hv_setup_tsc_page(v->kvm, &vcpu->hv_clock);
 	return 0;
diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
index 545c1d5c070e..d176d7e15c50 100644
--- a/arch/x86/kvm/xen.c
+++ b/arch/x86/kvm/xen.c
@@ -463,25 +463,19 @@ int kvm_xen_vcpu_set_attr(struct kvm_vcpu *vcpu, struct kvm_xen_vcpu_attr *data)
 
 	case KVM_XEN_VCPU_ATTR_TYPE_VCPU_TIME_INFO:
 		if (data->u.gpa == GPA_INVALID) {
-			vcpu->arch.xen.vcpu_time_info_set = false;
+			kvm_gfn_to_pfn_cache_destroy(vcpu->kvm,
+						     &vcpu->arch.xen.vcpu_time_info_cache);
 			r = 0;
 			break;
 		}
 
-		/* It must fit within a single page */
-		if ((data->u.gpa & ~PAGE_MASK) + sizeof(struct pvclock_vcpu_time_info) > PAGE_SIZE) {
-			r = -EINVAL;
-			break;
-		}
-
-		r = kvm_gfn_to_hva_cache_init(vcpu->kvm,
+		r = kvm_gfn_to_pfn_cache_init(vcpu->kvm,
 					      &vcpu->arch.xen.vcpu_time_info_cache,
-					      data->u.gpa,
-					      sizeof(struct pvclock_vcpu_time_info));
-		if (!r) {
-			vcpu->arch.xen.vcpu_time_info_set = true;
+					      NULL, false, true, data->u.gpa,
+					      sizeof(struct pvclock_vcpu_time_info),
+					      false);
+		if (!r)
 			kvm_make_request(KVM_REQ_CLOCK_UPDATE, vcpu);
-		}
 		break;
 
 	case KVM_XEN_VCPU_ATTR_TYPE_RUNSTATE_ADDR:
@@ -623,7 +617,7 @@ int kvm_xen_vcpu_get_attr(struct kvm_vcpu *vcpu, struct kvm_xen_vcpu_attr *data)
 		break;
 
 	case KVM_XEN_VCPU_ATTR_TYPE_VCPU_TIME_INFO:
-		if (vcpu->arch.xen.vcpu_time_info_set)
+		if (vcpu->arch.xen.vcpu_time_info_cache.active)
 			data->u.gpa = vcpu->arch.xen.vcpu_time_info_cache.gpa;
 		else
 			data->u.gpa = GPA_INVALID;
@@ -1068,4 +1062,6 @@ void kvm_xen_destroy_vcpu(struct kvm_vcpu *vcpu)
 				     &vcpu->arch.xen.runstate_cache);
 	kvm_gfn_to_pfn_cache_destroy(vcpu->kvm,
 				     &vcpu->arch.xen.vcpu_info_cache);
+	kvm_gfn_to_pfn_cache_destroy(vcpu->kvm,
+				     &vcpu->arch.xen.vcpu_time_info_cache);
 }
-- 
2.33.1

