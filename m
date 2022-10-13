Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B6DE5FE409
	for <lists+kvm@lfdr.de>; Thu, 13 Oct 2022 23:14:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230212AbiJMVOr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Oct 2022 17:14:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230196AbiJMVNv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Oct 2022 17:13:51 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0914192D9C
        for <kvm@vger.kernel.org>; Thu, 13 Oct 2022 14:13:46 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id eb28-20020a056a004c9c00b0056326adf7a5so1772869pfb.8
        for <kvm@vger.kernel.org>; Thu, 13 Oct 2022 14:13:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=QVsgOUFdCeAu3kg4DIQmvroAjbUx1fEa2Um3hwmoUgQ=;
        b=LTIXi1l9TES5TaT4VN1PhRA/Sp0htqxITjUh2LwiHHHhS1vAVeurBK+Of1n6IZxM69
         L4Nbe+dg5FzuWzB3lq+rayvnEHGnqCFciuTsrPTzBETiYOzg2LzHtkfJCLEFj6sqDTBq
         eRUsFduZ8EgZcF1BezhkeJwv3+yf/rbtD9vfDFAnEhJ5lDNxphgMu8zs4B1tZhbwrOrV
         B5fBMuWM7TdtbXWncJJ7cWROJbonPqBFVtYOuOV46dJJUA357asOZiq1DB0p0GgwfryV
         TAKqD9e1zu1FhnZZeIcZYE4QJCVlpfmpOlt1WRmvfjR5PMC8q+lbpZPfU56wuZdyL8NZ
         0NDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=QVsgOUFdCeAu3kg4DIQmvroAjbUx1fEa2Um3hwmoUgQ=;
        b=wqfK+CwwTfa8hrTbwdF6u4bRZk3U8qyAdJbE8RVtW4lKPi+pZAEaswky4znJ9U1/Pw
         8gggzEaUwKior7LoMZfZdBxhRQepk9UApSH6GZ69lROBTwKvZ8LgWGMJwR15J0r6SWol
         LJmBAg/CVI+4mfvFGeg9tuimOFAFedCFtT2CN7FJeuyAM8qdyDcmW9ZL/0jR3Wa3b+mF
         0Sv7p+2+bIqcRkIyrNx8YXFOPZhXDkyyzHOXt5yiCIONhY+NZ3MP2wDYymTxj0DhfD5r
         60yXCvF3IUgGE3U5NLvBDvy69a13arsIONTsRhl2tMVBr6mW5l7XY7nQtbZ4pY+5GXIh
         5NxQ==
X-Gm-Message-State: ACrzQf37F98aAkGn3bjn9NFcfiK29n1xA8FK1zOzmuC9TXDl2y2R7n5n
        OffHWCG6tsCC50wTVh7AfH5uBa5HJEo=
X-Google-Smtp-Source: AMsMyM7ya5QkJAUOvJRMaQlxWenHfSVG5jIUMLPe32tgxDSiOUSY3UdXYPjFMx0rle3Is5aPNnIWN5u3eYE=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:114c:b0:528:2c7a:6302 with SMTP id
 b12-20020a056a00114c00b005282c7a6302mr1481255pfm.37.1665695580614; Thu, 13
 Oct 2022 14:13:00 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu, 13 Oct 2022 21:12:31 +0000
In-Reply-To: <20221013211234.1318131-1-seanjc@google.com>
Mime-Version: 1.0
References: <20221013211234.1318131-1-seanjc@google.com>
X-Mailer: git-send-email 2.38.0.413.g74048e4d9e-goog
Message-ID: <20221013211234.1318131-14-seanjc@google.com>
Subject: [PATCH v2 13/16] KVM: Drop @gpa from exported gfn=>pfn cache check()
 and refresh() helpers
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michal Luczaj <mhal@rbox.co>,
        David Woodhouse <dwmw2@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Drop the @gpa param from the exported check()+refresh() helpers and limit
changing the cache's GPA to the activate path.  All external users just
feed in gpc->gpa, i.e. this is a fancy nop.

Allowing users to change the GPA at check()+refresh() is dangerous as
those helpers explicitly allow concurrent calls, e.g. KVM could get into
a livelock scenario.  It's also unclear as to what the expected behavior
should be if multiple tasks attempt to refresh with different GPAs.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/x86.c       |  4 ++--
 arch/x86/kvm/xen.c       | 20 ++++++++++----------
 include/linux/kvm_host.h |  6 ++----
 virt/kvm/pfncache.c      | 16 +++++++++-------
 4 files changed, 23 insertions(+), 23 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index d370d06bb07a..2db8515d38dd 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3033,10 +3033,10 @@ static void kvm_setup_guest_pvclock(struct kvm_vcpu *v,
 	WARN_ON_ONCE(gpc->len != offset + sizeof(*guest_hv_clock));
 
 	read_lock_irqsave(&gpc->lock, flags);
-	while (!kvm_gpc_check(gpc, gpc->gpa)) {
+	while (!kvm_gpc_check(gpc)) {
 		read_unlock_irqrestore(&gpc->lock, flags);
 
-		if (kvm_gpc_refresh(gpc, gpc->gpa))
+		if (kvm_gpc_refresh(gpc))
 			return;
 
 		read_lock_irqsave(&gpc->lock, flags);
diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
index 920ba5ca3016..529d3f4c1b9d 100644
--- a/arch/x86/kvm/xen.c
+++ b/arch/x86/kvm/xen.c
@@ -211,14 +211,14 @@ void kvm_xen_update_runstate_guest(struct kvm_vcpu *v, int state)
 		return;
 
 	read_lock_irqsave(&gpc->lock, flags);
-	while (!kvm_gpc_check(gpc, gpc->gpa)) {
+	while (!kvm_gpc_check(gpc)) {
 		read_unlock_irqrestore(&gpc->lock, flags);
 
 		/* When invoked from kvm_sched_out() we cannot sleep */
 		if (state == RUNSTATE_runnable)
 			return;
 
-		if (kvm_gpc_refresh(gpc, gpc->gpa))
+		if (kvm_gpc_refresh(gpc))
 			return;
 
 		read_lock_irqsave(&gpc->lock, flags);
@@ -344,10 +344,10 @@ void kvm_xen_inject_pending_events(struct kvm_vcpu *v)
 	 * little more honest about it.
 	 */
 	read_lock_irqsave(&gpc->lock, flags);
-	while (!kvm_gpc_check(gpc, gpc->gpa)) {
+	while (!kvm_gpc_check(gpc)) {
 		read_unlock_irqrestore(&gpc->lock, flags);
 
-		if (kvm_gpc_refresh(gpc, gpc->gpa))
+		if (kvm_gpc_refresh(gpc))
 			return;
 
 		read_lock_irqsave(&gpc->lock, flags);
@@ -407,7 +407,7 @@ int __kvm_xen_has_interrupt(struct kvm_vcpu *v)
 		     sizeof_field(struct compat_vcpu_info, evtchn_upcall_pending));
 
 	read_lock_irqsave(&gpc->lock, flags);
-	while (!kvm_gpc_check(gpc, gpc->gpa)) {
+	while (!kvm_gpc_check(gpc)) {
 		read_unlock_irqrestore(&gpc->lock, flags);
 
 		/*
@@ -421,7 +421,7 @@ int __kvm_xen_has_interrupt(struct kvm_vcpu *v)
 		if (in_atomic() || !task_is_running(current))
 			return 1;
 
-		if (kvm_gpc_refresh(gpc, gpc->gpa)) {
+		if (kvm_gpc_refresh(gpc)) {
 			/*
 			 * If this failed, userspace has screwed up the
 			 * vcpu_info mapping. No interrupts for you.
@@ -947,7 +947,7 @@ static bool wait_pending_event(struct kvm_vcpu *vcpu, int nr_ports,
 
 	read_lock_irqsave(&gpc->lock, flags);
 	idx = srcu_read_lock(&kvm->srcu);
-	if (!kvm_gpc_check(gpc, gpc->gpa))
+	if (!kvm_gpc_check(gpc))
 		goto out_rcu;
 
 	ret = false;
@@ -1338,7 +1338,7 @@ int kvm_xen_set_evtchn_fast(struct kvm_xen_evtchn *xe, struct kvm *kvm)
 	idx = srcu_read_lock(&kvm->srcu);
 
 	read_lock_irqsave(&gpc->lock, flags);
-	if (!kvm_gpc_check(gpc, gpc->gpa))
+	if (!kvm_gpc_check(gpc))
 		goto out_rcu;
 
 	if (IS_ENABLED(CONFIG_64BIT) && kvm->arch.xen.long_mode) {
@@ -1372,7 +1372,7 @@ int kvm_xen_set_evtchn_fast(struct kvm_xen_evtchn *xe, struct kvm *kvm)
 		gpc = &vcpu->arch.xen.vcpu_info_cache;
 
 		read_lock_irqsave(&gpc->lock, flags);
-		if (!kvm_gpc_check(gpc, gpc->gpa)) {
+		if (!kvm_gpc_check(gpc)) {
 			/*
 			 * Could not access the vcpu_info. Set the bit in-kernel
 			 * and prod the vCPU to deliver it for itself.
@@ -1470,7 +1470,7 @@ static int kvm_xen_set_evtchn(struct kvm_xen_evtchn *xe, struct kvm *kvm)
 			break;
 
 		idx = srcu_read_lock(&kvm->srcu);
-		rc = kvm_gpc_refresh(gpc, gpc->gpa);
+		rc = kvm_gpc_refresh(gpc);
 		srcu_read_unlock(&kvm->srcu, idx);
 	} while(!rc);
 
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 22cf43389954..92cf0be21974 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1283,7 +1283,6 @@ int kvm_gpc_activate(struct gfn_to_pfn_cache *gpc, gpa_t gpa);
  * kvm_gpc_check - check validity of a gfn_to_pfn_cache.
  *
  * @gpc:	   struct gfn_to_pfn_cache object.
- * @gpa:	   current guest physical address to map.
  *
  * @return:	   %true if the cache is still valid and the address matches.
  *		   %false if the cache is not valid.
@@ -1295,13 +1294,12 @@ int kvm_gpc_activate(struct gfn_to_pfn_cache *gpc, gpa_t gpa);
  * Callers in IN_GUEST_MODE may do so without locking, although they should
  * still hold a read lock on kvm->scru for the memslot checks.
  */
-bool kvm_gpc_check(struct gfn_to_pfn_cache *gpc, gpa_t gpa);
+bool kvm_gpc_check(struct gfn_to_pfn_cache *gpc);
 
 /**
  * kvm_gpc_refresh - update a previously initialized cache.
  *
  * @gpc:	   struct gfn_to_pfn_cache object.
- * @gpa:	   updated guest physical address to map.
  *
  * @return:	   0 for success.
  *		   -EINVAL for a mapping which would cross a page boundary.
@@ -1313,7 +1311,7 @@ bool kvm_gpc_check(struct gfn_to_pfn_cache *gpc, gpa_t gpa);
  * still lock and check the cache status, as this function does not return
  * with the lock still held to permit access.
  */
-int kvm_gpc_refresh(struct gfn_to_pfn_cache *gpc, gpa_t gpa);
+int kvm_gpc_refresh(struct gfn_to_pfn_cache *gpc);
 
 /**
  * kvm_gpc_deactivate - deactivate and unlink a gfn_to_pfn_cache.
diff --git a/virt/kvm/pfncache.c b/virt/kvm/pfncache.c
index 2d5b417e50ac..f211c878788b 100644
--- a/virt/kvm/pfncache.c
+++ b/virt/kvm/pfncache.c
@@ -76,17 +76,14 @@ void gfn_to_pfn_cache_invalidate_start(struct kvm *kvm, unsigned long start,
 	}
 }
 
-bool kvm_gpc_check(struct gfn_to_pfn_cache *gpc, gpa_t gpa)
+bool kvm_gpc_check(struct gfn_to_pfn_cache *gpc)
 {
 	struct kvm_memslots *slots = kvm_memslots(gpc->kvm);
 
 	if (!gpc->active)
 		return false;
 
-	if ((gpa & ~PAGE_MASK) + gpc->len > PAGE_SIZE)
-		return false;
-
-	if (gpc->gpa != gpa || gpc->generation != slots->generation ||
+	if (gpc->generation != slots->generation ||
 	    kvm_is_error_hva(gpc->uhva))
 		return false;
 
@@ -237,7 +234,7 @@ static kvm_pfn_t hva_to_pfn_retry(struct gfn_to_pfn_cache *gpc)
 	return -EFAULT;
 }
 
-int kvm_gpc_refresh(struct gfn_to_pfn_cache *gpc, gpa_t gpa)
+static int __kvm_gpc_refresh(struct gfn_to_pfn_cache *gpc, gpa_t gpa)
 {
 	struct kvm_memslots *slots = kvm_memslots(gpc->kvm);
 	unsigned long page_offset = gpa & ~PAGE_MASK;
@@ -326,6 +323,11 @@ int kvm_gpc_refresh(struct gfn_to_pfn_cache *gpc, gpa_t gpa)
 
 	return ret;
 }
+
+int kvm_gpc_refresh(struct gfn_to_pfn_cache *gpc)
+{
+	return __kvm_gpc_refresh(gpc, gpc->gpa);
+}
 EXPORT_SYMBOL_GPL(kvm_gpc_refresh);
 
 void kvm_gpc_init(struct gfn_to_pfn_cache *gpc, struct kvm *kvm,
@@ -369,7 +371,7 @@ int kvm_gpc_activate(struct gfn_to_pfn_cache *gpc, gpa_t gpa)
 		gpc->active = true;
 		write_unlock_irq(&gpc->lock);
 	}
-	return kvm_gpc_refresh(gpc, gpa);
+	return __kvm_gpc_refresh(gpc, gpa);
 }
 EXPORT_SYMBOL_GPL(kvm_gpc_activate);
 
-- 
2.38.0.413.g74048e4d9e-goog

