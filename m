Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 509765FA8A1
	for <lists+kvm@lfdr.de>; Tue, 11 Oct 2022 01:29:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229936AbiJJX3S (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Oct 2022 19:29:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbiJJX3R (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Oct 2022 19:29:17 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E5A37EFC8
        for <kvm@vger.kernel.org>; Mon, 10 Oct 2022 16:29:01 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id x31-20020a17090a38a200b0020d2afec803so4540485pjb.2
        for <kvm@vger.kernel.org>; Mon, 10 Oct 2022 16:29:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=DFdl24bj60jQA+GF9S8qyRHZiobQFNi/5laDG/WmVgo=;
        b=CNQYCzVCByGV4xXchyNfy4SmfJyREmYaFURfKN9xShsaaBOET91bcd985fSXgOdYGz
         7KcY77sLhNTAHSNjSUXpwOZBZFJYsn3sKIFwFLOX6PlRtVvBx059M/wRB8UVE4l55CDr
         X13SFhzKhx+gkihW/0svInSoMQAx93a/qAuzmGCIkfphK8g0rRCpfeiPNtJivFogu9sD
         ehPasFJMddKV+cPGAU1YhEdJRkWR/JZEjyrkFit8pl/iTeEpJ8LmTnlY6smRU1ho/edw
         M2yidkz/ja3ps4gqQTrfgPfVJxXLeRNZoXYrPt2G8t7rAiCsTSrTFYhPAec98eMgqWtI
         sS4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DFdl24bj60jQA+GF9S8qyRHZiobQFNi/5laDG/WmVgo=;
        b=57uNg0b4PCQttXDnNHsrxWEL4dqzWebeo64ecMe4xrUSQtJLcV0ynQQfUUEGY5YDxK
         R4qSQDpxa9b+btJkISQMmk2xKmB2257CiEFMDDGUInFRO5TwTh8bqCX1YfifKooUYUnj
         Qa6gHRv85710KkFEBRDk8w1kfLIbAckrInu2LvzmeuBkvfnw4+O66rhqxNLGyXPE15fO
         AJfp+rwql6NwiE2QKEjOvEFJL5g6eFKzuHoB1EC6/gzLsX3ThhGn9z6zAFIEC1YBU3ol
         PGknvxk91unNXjgWBvHNmtsXFlMHknd+bajIfqvS4idghvLuF8NPASKWllLTjdtv5dCQ
         YICQ==
X-Gm-Message-State: ACrzQf1qqkBdkgt/iwdpRO+3huqCJhlSsXjTf3Upv5fvrD93oZUUwPwG
        HIT2FN1aawtRL1cm7hqX9UVM2g==
X-Google-Smtp-Source: AMsMyM69Xcw+0kP9oi15pCPknwctBhgdvCq2iSkZE5ceFzLE1r7PDa9yy06k4AXvYz6wljqFZ6+Qrg==
X-Received: by 2002:a17:90a:9381:b0:20a:79b7:766a with SMTP id q1-20020a17090a938100b0020a79b7766amr35074404pjo.33.1665444540873;
        Mon, 10 Oct 2022 16:29:00 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id f8-20020a170902ce8800b00178b77b7e71sm7227099plg.188.2022.10.10.16.29.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Oct 2022 16:29:00 -0700 (PDT)
Date:   Mon, 10 Oct 2022 23:28:56 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Michal Luczaj <mhal@rbox.co>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com
Subject: Re: [PATCH 8/8] KVM: x86: Fix NULL pointer dereference in
 kvm_xen_set_evtchn_fast()
Message-ID: <Y0SquPNxS5AOGcDP@google.com>
References: <YySujDJN2Wm3ivi/@google.com>
 <20220921020140.3240092-1-mhal@rbox.co>
 <20220921020140.3240092-9-mhal@rbox.co>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220921020140.3240092-9-mhal@rbox.co>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 21, 2022, Michal Luczaj wrote:
> There's a race between kvm_xen_set_evtchn_fast() and kvm_gpc_activate()
> resulting in a near-NULL pointer write.
> 
> 1. Deactivate shinfo cache:
> 
> kvm_xen_hvm_set_attr
> case KVM_XEN_ATTR_TYPE_SHARED_INFO
>  kvm_gpc_deactivate
>   kvm_gpc_unmap
>    gpc->valid = false
>    gpc->khva = NULL
>   gpc->active = false
> 
> Result: active = false, valid = false
> 
> 2. Cause cache refresh:
> 
> kvm_arch_vm_ioctl
> case KVM_XEN_HVM_EVTCHN_SEND
>  kvm_xen_hvm_evtchn_send
>   kvm_xen_set_evtchn
>    kvm_xen_set_evtchn_fast
>     kvm_gpc_check
>     return -EWOULDBLOCK because !gpc->valid
>    kvm_xen_set_evtchn_fast
>     return -EWOULDBLOCK
>    kvm_gpc_refresh
>     hva_to_pfn_retry
>      gpc->valid = true
>      gpc->khva = not NULL
> 
> Result: active = false, valid = true

This is the real bug.  KVM should not succesfully refresh an inactive cache.
It's not just the potential for NULL pointer deref, the cache also isn't on the
list of active caches, i.e. won't get mmu_notifier events, and so KVM could get
a use-after-free of userspace memory.

KVM_XEN_HVM_EVTCHN_SEND does check that the per-vCPU cache is active, but does so
outside of the gpc->lock.

Minus your race condition analysis, which I'll insert into the changelog (assuming
this works), I believe the proper fix is to check "active" during check and refresh.
Oof, and there are ordering bugs too.  Compile-tested patch below.

If this fixes things on your end (I'll properly test tomorrow too), I'll post a
v2 of the entire series.  There are some cleanups that can be done on top, e.g.
I think we should drop kvm_gpc_unmap() entirely until there's actually a user,
because it's not at all obvious that it's (a) necessary and (b) has desirable
behavior.

Note, the below patch applies after patch 1 of this series.  I don't know if anyone
will actually want to backport the fix, but it's not too hard to keep the backport
dependency to just patch 1.

--
From: Sean Christopherson <seanjc@google.com>
Date: Mon, 10 Oct 2022 13:06:13 -0700
Subject: [PATCH] KVM: Reject attempts to consume or refresh inactive
 gfn_to_pfn_cache

Reject kvm_gpc_check() and kvm_gpc_refresh() if the cache is inactive.
No checking the active flag during refresh is particular egregious, as
KVM can end up with a valid, inactive cache, which can lead to a variety
of use-after-free bugs, e.g. consuming a NULL kernel pointer or missing
an mmu_notifier invalidation due to the cache not being on the list of
gfns to invalidate.

Note, "active" needs to be set if and only if the cache is on the list
of caches, i.e. is reachable via mmu_notifier events.  If a relevant
mmu_notifier event occurs while the cache is "active" but not on the
list, KVM will not acquire the cache's lock and so will not serailize
the mmu_notifier event with active users and/or kvm_gpc_refresh().

A race between KVM_XEN_ATTR_TYPE_SHARED_INFO and KVM_XEN_HVM_EVTCHN_SEND
can be exploited to trigger the bug.

<will insert your awesome race analysis>

Reported-by: : Michal Luczaj <mhal@rbox.co>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 virt/kvm/pfncache.c | 36 ++++++++++++++++++++++++++++++------
 1 file changed, 30 insertions(+), 6 deletions(-)

diff --git a/virt/kvm/pfncache.c b/virt/kvm/pfncache.c
index b32ed4a7c900..dfc72aa88d71 100644
--- a/virt/kvm/pfncache.c
+++ b/virt/kvm/pfncache.c
@@ -81,6 +81,9 @@ bool kvm_gfn_to_pfn_cache_check(struct kvm *kvm, struct gfn_to_pfn_cache *gpc,
 {
 	struct kvm_memslots *slots = kvm_memslots(kvm);
 
+	if (!gpc->active)
+		return false;
+
 	if ((gpa & ~PAGE_MASK) + len > PAGE_SIZE)
 		return false;
 
@@ -240,8 +243,9 @@ int kvm_gfn_to_pfn_cache_refresh(struct kvm *kvm, struct gfn_to_pfn_cache *gpc,
 {
 	struct kvm_memslots *slots = kvm_memslots(kvm);
 	unsigned long page_offset = gpa & ~PAGE_MASK;
-	kvm_pfn_t old_pfn, new_pfn;
+	bool unmap_old = false;
 	unsigned long old_uhva;
+	kvm_pfn_t old_pfn;
 	void *old_khva;
 	int ret = 0;
 
@@ -261,6 +265,9 @@ int kvm_gfn_to_pfn_cache_refresh(struct kvm *kvm, struct gfn_to_pfn_cache *gpc,
 
 	write_lock_irq(&gpc->lock);
 
+	if (!gpc->active)
+		goto out_unlock;
+
 	old_pfn = gpc->pfn;
 	old_khva = gpc->khva - offset_in_page(gpc->khva);
 	old_uhva = gpc->uhva;
@@ -305,14 +312,15 @@ int kvm_gfn_to_pfn_cache_refresh(struct kvm *kvm, struct gfn_to_pfn_cache *gpc,
 		gpc->khva = NULL;
 	}
 
-	/* Snapshot the new pfn before dropping the lock! */
-	new_pfn = gpc->pfn;
+	/* Detect a pfn change before dropping the lock! */
+	unmap_old = (old_pfn != gpc->pfn);
 
+out_unlock:
 	write_unlock_irq(&gpc->lock);
 
 	mutex_unlock(&gpc->refresh_lock);
 
-	if (old_pfn != new_pfn)
+	if (unmap_old)
 		gpc_unmap_khva(kvm, old_pfn, old_khva);
 
 	return ret;
@@ -368,11 +376,19 @@ int kvm_gpc_activate(struct kvm *kvm, struct gfn_to_pfn_cache *gpc,
 		gpc->vcpu = vcpu;
 		gpc->usage = usage;
 		gpc->valid = false;
-		gpc->active = true;
 
 		spin_lock(&kvm->gpc_lock);
 		list_add(&gpc->list, &kvm->gpc_list);
 		spin_unlock(&kvm->gpc_lock);
+
+		/*
+		 * Activate the cache after adding it to the list, a concurrent
+		 * refresh must not establish a mapping until the cache is
+		 * reachable by mmu_notifier events.
+		 */
+		write_lock_irq(&gpc->lock);
+		gpc->active = true;
+		write_unlock_irq(&gpc->lock);
 	}
 	return kvm_gfn_to_pfn_cache_refresh(kvm, gpc, gpa, len);
 }
@@ -381,12 +397,20 @@ EXPORT_SYMBOL_GPL(kvm_gpc_activate);
 void kvm_gpc_deactivate(struct kvm *kvm, struct gfn_to_pfn_cache *gpc)
 {
 	if (gpc->active) {
+		/*
+		 * Deactivate the cache before removing it from the list, KVM
+		 * must stall mmu_notifier events until all users go away, i.e.
+		 * until gpc->lock is dropped and refresh is guaranteed to fail.
+		 */
+		write_lock_irq(&gpc->lock);
+		gpc->active = false;
+		write_unlock_irq(&gpc->lock);
+
 		spin_lock(&kvm->gpc_lock);
 		list_del(&gpc->list);
 		spin_unlock(&kvm->gpc_lock);
 
 		kvm_gfn_to_pfn_cache_unmap(kvm, gpc);
-		gpc->active = false;
 	}
 }
 EXPORT_SYMBOL_GPL(kvm_gpc_deactivate);

base-commit: 09e5b3d617d28e3011253370f827151cc6cba6ad
-- 

