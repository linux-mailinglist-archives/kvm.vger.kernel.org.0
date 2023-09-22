Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A25DD7AB468
	for <lists+kvm@lfdr.de>; Fri, 22 Sep 2023 17:03:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232370AbjIVPAo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Sep 2023 11:00:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232174AbjIVPAg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Sep 2023 11:00:36 -0400
Received: from mail.xenproject.org (mail.xenproject.org [104.130.215.37])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 463C119A;
        Fri, 22 Sep 2023 08:00:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=xen.org;
        s=20200302mail; h=Content-Transfer-Encoding:MIME-Version:References:
        In-Reply-To:Message-Id:Date:Subject:Cc:To:From;
        bh=b9VmcvZpefxWPZmnCsAAti7ImeYt2ilYGEmGGgNIuv0=; b=F1SITcqAVVcWf92KC+INQChQmg
        ypFF0hxsBWV9ey7RrTX/+S5W7H19gxMFVYeENCmcxbYqO2c8/6FG1/4q204biGMauEsXKsJDy0Ktt
        sOgRCfHrtyBcN1FAkNvVhxKmigoTTfTII27s2A+pvOfwmAD5WDD8PYPcK4ypBNwuIk4o=;
Received: from xenbits.xenproject.org ([104.239.192.120])
        by mail.xenproject.org with esmtp (Exim 4.92)
        (envelope-from <paul@xen.org>)
        id 1qjhdo-00044d-4H; Fri, 22 Sep 2023 15:00:24 +0000
Received: from ec2-63-33-11-17.eu-west-1.compute.amazonaws.com ([63.33.11.17] helo=REM-PW02S00X.ant.amazon.com)
        by xenbits.xenproject.org with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <paul@xen.org>)
        id 1qjhdn-0005y2-SP; Fri, 22 Sep 2023 15:00:24 +0000
From:   Paul Durrant <paul@xen.org>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Paul Durrant <pdurrant@amazon.com>,
        David Woodhouse <dwmw@amazon.co.uk>,
        David Woodhouse <dwmw2@infradead.org>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org
Subject: [PATCH v5 02/10] KVM: pfncache: add a mark-dirty helper
Date:   Fri, 22 Sep 2023 15:00:01 +0000
Message-Id: <20230922150009.3319-3-paul@xen.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230922150009.3319-1-paul@xen.org>
References: <20230922150009.3319-1-paul@xen.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Paul Durrant <pdurrant@amazon.com>

At the moment pages are marked dirty by open-coded calls to
mark_page_dirty_in_slot(), directly deferefencing the gpa and memslot
from the cache. After a subsequent patch these may not always be set
so add a helper now so that caller will protected from the need to know
about this detail.

NOTE: Pages are now marked dirty while the cache lock is held. This is
      to ensure that gpa and memslot are mutually consistent.

Signed-off-by: Paul Durrant <pdurrant@amazon.com>
Reviewed-by: David Woodhouse <dwmw@amazon.co.uk>
---
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: x86@kernel.org
---
 arch/x86/kvm/x86.c       |  2 +-
 arch/x86/kvm/xen.c       | 13 ++++++-------
 include/linux/kvm_host.h |  7 +++++++
 virt/kvm/pfncache.c      |  6 ++++++
 4 files changed, 20 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 6c9c81e82e65..d669a8801265 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3137,7 +3137,7 @@ static void kvm_setup_guest_pvclock(struct kvm_vcpu *v,
 
 	guest_hv_clock->version = ++vcpu->hv_clock.version;
 
-	mark_page_dirty_in_slot(v->kvm, gpc->memslot, gpc->gpa >> PAGE_SHIFT);
+	kvm_gpc_mark_dirty(gpc);
 	read_unlock_irqrestore(&gpc->lock, flags);
 
 	trace_kvm_pvclock_update(v->vcpu_id, &vcpu->hv_clock);
diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
index 40edf4d1974c..33fddd29824b 100644
--- a/arch/x86/kvm/xen.c
+++ b/arch/x86/kvm/xen.c
@@ -430,14 +430,13 @@ static void kvm_xen_update_runstate_guest(struct kvm_vcpu *v, bool atomic)
 		smp_wmb();
 	}
 
-	if (user_len2)
+	if (user_len2) {
+		kvm_gpc_mark_dirty(gpc2);
 		read_unlock(&gpc2->lock);
+	}
 
+	kvm_gpc_mark_dirty(gpc1);
 	read_unlock_irqrestore(&gpc1->lock, flags);
-
-	mark_page_dirty_in_slot(v->kvm, gpc1->memslot, gpc1->gpa >> PAGE_SHIFT);
-	if (user_len2)
-		mark_page_dirty_in_slot(v->kvm, gpc2->memslot, gpc2->gpa >> PAGE_SHIFT);
 }
 
 void kvm_xen_update_runstate(struct kvm_vcpu *v, int state)
@@ -543,13 +542,13 @@ void kvm_xen_inject_pending_events(struct kvm_vcpu *v)
 			     : "0" (evtchn_pending_sel32));
 		WRITE_ONCE(vi->evtchn_upcall_pending, 1);
 	}
+
+	kvm_gpc_mark_dirty(gpc);
 	read_unlock_irqrestore(&gpc->lock, flags);
 
 	/* For the per-vCPU lapic vector, deliver it as MSI. */
 	if (v->arch.xen.upcall_vector)
 		kvm_xen_inject_vcpu_vector(v);
-
-	mark_page_dirty_in_slot(v->kvm, gpc->memslot, gpc->gpa >> PAGE_SHIFT);
 }
 
 int __kvm_xen_has_interrupt(struct kvm_vcpu *v)
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index fb6c6109fdca..c71e8fbccaaf 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1367,6 +1367,13 @@ int kvm_gpc_refresh(struct gfn_to_pfn_cache *gpc, unsigned long len);
  */
 void kvm_gpc_deactivate(struct gfn_to_pfn_cache *gpc);
 
+/**
+ * kvm_gpc_mark_dirty - mark a cached page as dirty.
+ *
+ * @gpc:	   struct gfn_to_pfn_cache object.
+ */
+void kvm_gpc_mark_dirty(struct gfn_to_pfn_cache *gpc);
+
 void kvm_sigset_activate(struct kvm_vcpu *vcpu);
 void kvm_sigset_deactivate(struct kvm_vcpu *vcpu);
 
diff --git a/virt/kvm/pfncache.c b/virt/kvm/pfncache.c
index 0f36acdf577f..b68ed7fa56a2 100644
--- a/virt/kvm/pfncache.c
+++ b/virt/kvm/pfncache.c
@@ -386,6 +386,12 @@ int kvm_gpc_activate(struct gfn_to_pfn_cache *gpc, gpa_t gpa, unsigned long len)
 }
 EXPORT_SYMBOL_GPL(kvm_gpc_activate);
 
+void kvm_gpc_mark_dirty(struct gfn_to_pfn_cache *gpc)
+{
+	mark_page_dirty_in_slot(gpc->kvm, gpc->memslot, gpc->gpa >> PAGE_SHIFT);
+}
+EXPORT_SYMBOL_GPL(kvm_gpc_mark_dirty);
+
 void kvm_gpc_deactivate(struct gfn_to_pfn_cache *gpc)
 {
 	struct kvm *kvm = gpc->kvm;
-- 
2.39.2

