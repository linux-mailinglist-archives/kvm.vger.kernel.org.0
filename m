Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26EF9606C2A
	for <lists+kvm@lfdr.de>; Fri, 21 Oct 2022 01:45:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229692AbiJTXpG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Oct 2022 19:45:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229744AbiJTXpB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Oct 2022 19:45:01 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75833DCE8B
        for <kvm@vger.kernel.org>; Thu, 20 Oct 2022 16:44:56 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id p6so746872plr.7
        for <kvm@vger.kernel.org>; Thu, 20 Oct 2022 16:44:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=RST9JbLA3qIeIAOKKjTAca+tkObSnmtfZCXllg3hD7s=;
        b=F4m6Hs3AicksLZYwntxONKiEr0YQ0e8s71QnmMKCfv5i/2FnrIfKVVmSvBmM6sHt1y
         nIUIKhweZXUIMjPhGFw2ZXJ68phAdCJcgHckeON35DHLMvyrREaBB276CPIOb/QAkNj2
         P1YEC+VF1bRVlaBTjww95qBJNqlRPeBSIwXm4Pb0cYzVrWL/FplVxHj1tnUA0SBqIdNM
         uAb7rHsP+Cctz8NATRwK8vpPJ5r2+hYQCyumGycxvEbxadH6zev7AEkATqvfDubkSdCU
         kgONkqBkwKctVgTkHMOFlTafVGDXXvLCzf8lf1d38vfwtSixuHA42mC4Sg7ddoP6aaoj
         CEtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RST9JbLA3qIeIAOKKjTAca+tkObSnmtfZCXllg3hD7s=;
        b=MHZ9Lb4hscst84/DN8uVOuxKJilyQUX1T/VC1v5frlFDc3ZZxrMhVrroKe9bPYdhQp
         TfDgugtHZOUgGMdongbUqLShz3XT8V2Ib63ddO8ohND4sWnFg53RHLgd2Z13nIqh9l1i
         rcnZdwKEjAcEETTBah3sx+x86yiHuR5Qbp8RTvhmN1h+9c/QZV0a1VGmwaIedRGPp78h
         MgIfZCFnFzWbS4endwoedFmSaj6dqtR68oBrSDkJJEJsA2BLcBETTty67GFgmUzoSCnO
         CYmsyMsLVT0qAE9aWcZ+zph7YZpdE4kv1+NeRBzt6+sP0RPFvjY3XewzpiPp0+a/huJG
         3sbA==
X-Gm-Message-State: ACrzQf3FF+NlvT3AuETO6RGYUgLbIV7+HjvolTihKgdIqzu/o22Dt11k
        z8KyXABrz7tY99danpLgewrHmQ==
X-Google-Smtp-Source: AMsMyM5TapqTrthTwXQBaYtwsUhJdSJF3WfVhAC5yehZ4QLp42Nw4UgHPY7oTovIHuqu3VdbYtK0kQ==
X-Received: by 2002:a17:902:7598:b0:178:3f96:4ffc with SMTP id j24-20020a170902759800b001783f964ffcmr16967372pll.53.1666309495576;
        Thu, 20 Oct 2022 16:44:55 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id e3-20020a17090a684300b0020ad53b5883sm386794pjm.14.2022.10.20.16.44.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Oct 2022 16:44:55 -0700 (PDT)
Date:   Thu, 20 Oct 2022 23:44:51 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Gavin Shan <gshan@redhat.com>
Cc:     kvmarm@lists.linux.dev, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, peterx@redhat.com, maz@kernel.org,
        will@kernel.org, catalin.marinas@arm.com, bgardon@google.com,
        shuah@kernel.org, andrew.jones@linux.dev, dmatlack@google.com,
        pbonzini@redhat.com, zhenyzha@redhat.com, james.morse@arm.com,
        suzuki.poulose@arm.com, alexandru.elisei@arm.com,
        oliver.upton@linux.dev, shan.gavin@gmail.com
Subject: Re: [PATCH v6 3/8] KVM: Add support for using dirty ring in
 conjunction with bitmap
Message-ID: <Y1Hdc/UVta3A5kHM@google.com>
References: <20221011061447.131531-1-gshan@redhat.com>
 <20221011061447.131531-4-gshan@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221011061447.131531-4-gshan@redhat.com>
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

On Tue, Oct 11, 2022, Gavin Shan wrote:
> Some architectures (such as arm64) need to dirty memory outside of the
> context of a vCPU. Of course, this simply doesn't fit with the UAPI of
> KVM's per-vCPU dirty ring.

What is the point of using the dirty ring in this case?  KVM still burns a pile
of memory for the bitmap.  Is the benefit that userspace can get away with
scanning the bitmap fewer times, e.g. scan it once just before blackout under
the assumption that very few pages will dirty the bitmap?

Why not add a global ring to @kvm?  I assume thread safety is a problem, but the
memory overhead of the dirty_bitmap also seems like a fairly big problem.

> Introduce a new flavor of dirty ring that requires the use of both vCPU
> dirty rings and a dirty bitmap. The expectation is that for non-vCPU
> sources of dirty memory (such as the GIC ITS on arm64), KVM writes to
> the dirty bitmap. Userspace should scan the dirty bitmap before
> migrating the VM to the target.
> 
> Use an additional capability to advertize this behavior and require
> explicit opt-in to avoid breaking the existing dirty ring ABI. And yes,
> you can use this with your preferred flavor of DIRTY_RING[_ACQ_REL]. Do
> not allow userspace to enable dirty ring if it hasn't also enabled the
> ring && bitmap capability, as a VM is likely DOA without the pages
> marked in the bitmap.
> 
> Suggested-by: Marc Zyngier <maz@kernel.org>
> Suggested-by: Peter Xu <peterx@redhat.com>
> Co-developed-by: Oliver Upton <oliver.upton@linux.dev>

Co-developed-by needs Oliver's SoB.

>  #ifndef CONFIG_HAVE_KVM_DIRTY_RING
> +static inline bool kvm_dirty_ring_exclusive(struct kvm *kvm)

What about inverting the naming to better capture that this is about the dirty
bitmap, and less so about the dirty ring?  It's not obvious what "exclusive"
means, e.g. I saw this stub before reading the changelog and assumed it was
making a dirty ring exclusive to something.

Something like this?

bool kvm_use_dirty_bitmap(struct kvm *kvm)
{
	return !kvm->dirty_ring_size || kvm->dirty_ring_with_bitmap;
}

> @@ -3305,15 +3305,20 @@ void mark_page_dirty_in_slot(struct kvm *kvm,
>  	struct kvm_vcpu *vcpu = kvm_get_running_vcpu();
>  
>  #ifdef CONFIG_HAVE_KVM_DIRTY_RING
> -	if (WARN_ON_ONCE(!vcpu) || WARN_ON_ONCE(vcpu->kvm != kvm))
> +	if (WARN_ON_ONCE(vcpu && vcpu->kvm != kvm))
>  		return;
> +
> +#ifndef CONFIG_HAVE_KVM_DIRTY_RING_WITH_BITMAP
> +	if (WARN_ON_ONCE(!vcpu))

To cut down on the #ifdefs, this can be:

	if (WARN_ON_ONCE(!IS_ENABLED(CONFIG_HAVE_KVM_DIRTY_RING_WITH_BITMAP) && !vcpu)

though that's arguably even harder to read.  Blech.

> +		return;
> +#endif
>  #endif
>  
>  	if (memslot && kvm_slot_dirty_track_enabled(memslot)) {
>  		unsigned long rel_gfn = gfn - memslot->base_gfn;
>  		u32 slot = (memslot->as_id << 16) | memslot->id;
>  
> -		if (kvm->dirty_ring_size)
> +		if (vcpu && kvm->dirty_ring_size)
>  			kvm_dirty_ring_push(&vcpu->dirty_ring,
>  					    slot, rel_gfn);
>  		else
> @@ -4485,6 +4490,9 @@ static long kvm_vm_ioctl_check_extension_generic(struct kvm *kvm, long arg)
>  		return KVM_DIRTY_RING_MAX_ENTRIES * sizeof(struct kvm_dirty_gfn);
>  #else
>  		return 0;
> +#endif
> +#ifdef CONFIG_HAVE_KVM_DIRTY_RING_WITH_BITMAP
> +	case KVM_CAP_DIRTY_LOG_RING_WITH_BITMAP:
>  #endif
>  	case KVM_CAP_BINARY_STATS_FD:
>  	case KVM_CAP_SYSTEM_EVENT_DATA:
> @@ -4499,6 +4507,11 @@ static int kvm_vm_ioctl_enable_dirty_log_ring(struct kvm *kvm, u32 size)
>  {
>  	int r;
>  
> +#ifdef CONFIG_HAVE_KVM_DIRTY_RING_WITH_BITMAP
> +	if (!kvm->dirty_ring_with_bitmap)
> +		return -EINVAL;
> +#endif

This one at least is prettier with IS_ENABLED

	if (IS_ENABLED(CONFIG_HAVE_KVM_DIRTY_RING_WITH_BITMAP) &&
	    !kvm->dirty_ring_with_bitmap)
		return -EINVAL;

But dirty_ring_with_bitmap really shouldn't need to exist.  It's mandatory for
architectures that have HAVE_KVM_DIRTY_RING_WITH_BITMAP, and unsupported for
architectures that don't.  In other words, the API for enabling the dirty ring
is a bit ugly.

Rather than add KVM_CAP_DIRTY_LOG_RING_ACQ_REL, which hasn't been officially
released yet, and then KVM_CAP_DIRTY_LOG_ING_WITH_BITMAP on top, what about
usurping bits 63:32 of cap->args[0] for flags?  E.g.

Ideally we'd use cap->flags directly, but we screwed up with KVM_CAP_DIRTY_LOG_RING
and didn't require flags to be zero :-(

Actually, what's the point of allowing KVM_CAP_DIRTY_LOG_RING_ACQ_REL to be
enabled?  I get why KVM would enumerate this info, i.e. allowing checking, but I
don't seen any value in supporting a second method for enabling the dirty ring.

The acquire-release thing is irrelevant for x86, and no other architecture
supports the dirty ring until this series, i.e. there's no need for KVM to detect
that userspace has been updated to gain acquire-release semantics, because the
fact that userspace is enabling the dirty ring on arm64 means userspace has been
updated.

Same goes for the "with bitmap" capability.  There are no existing arm64 users,
so there's no risk of breaking existing userspace by suddenly shoving stuff into
the dirty bitmap.

KVM doesn't even get the enabling checks right, e.g. KVM_CAP_DIRTY_LOG_RING can be
enabled on architectures that select CONFIG_HAVE_KVM_DIRTY_RING_ACQ_REL but not
KVM_CAP_DIRTY_LOG_RING.  The reverse is true (ignoring that x86 selects both and
is the only arch that selects the TSO variant).

Ditto for KVM_CAP_DIRTY_LOG_RING_WITH_BITMAP...
> +
>  	if (!KVM_DIRTY_LOG_PAGE_OFFSET)
>  		return -EINVAL;
>  
> @@ -4588,6 +4601,9 @@ static int kvm_vm_ioctl_enable_cap_generic(struct kvm *kvm,
>  	case KVM_CAP_DIRTY_LOG_RING:
>  	case KVM_CAP_DIRTY_LOG_RING_ACQ_REL:
>  		return kvm_vm_ioctl_enable_dirty_log_ring(kvm, cap->args[0]);
> +	case KVM_CAP_DIRTY_LOG_RING_WITH_BITMAP:

... as this should return -EINVAL if CONFIG_HAVE_KVM_DIRTY_RING_WITH_BITMAP=n.

So rather than add a rather useless flag and increase KVM's API surface, why not
make the capabilities informational-only?

---
 include/linux/kvm_dirty_ring.h |  6 +++---
 include/linux/kvm_host.h       |  1 -
 virt/kvm/dirty_ring.c          |  5 +++--
 virt/kvm/kvm_main.c            | 20 ++++----------------
 4 files changed, 10 insertions(+), 22 deletions(-)

diff --git a/include/linux/kvm_dirty_ring.h b/include/linux/kvm_dirty_ring.h
index 23b2b466aa0f..f49db42bc26a 100644
--- a/include/linux/kvm_dirty_ring.h
+++ b/include/linux/kvm_dirty_ring.h
@@ -28,9 +28,9 @@ struct kvm_dirty_ring {
 };
 
 #ifndef CONFIG_HAVE_KVM_DIRTY_RING
-static inline bool kvm_dirty_ring_exclusive(struct kvm *kvm)
+static inline bool kvm_use_dirty_bitmap(struct kvm *kvm)
 {
-	return false;
+	return true;
 }
 
 /*
@@ -71,7 +71,7 @@ static inline void kvm_dirty_ring_free(struct kvm_dirty_ring *ring)
 
 #else /* CONFIG_HAVE_KVM_DIRTY_RING */
 
-bool kvm_dirty_ring_exclusive(struct kvm *kvm);
+bool kvm_use_dirty_bitmap(struct kvm *kvm);
 int kvm_cpu_dirty_log_size(void);
 u32 kvm_dirty_ring_get_rsvd_entries(void);
 int kvm_dirty_ring_alloc(struct kvm_dirty_ring *ring, int index, u32 size);
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index d06fbf3e5e95..eb7b1310146d 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -779,7 +779,6 @@ struct kvm {
 	pid_t userspace_pid;
 	unsigned int max_halt_poll_ns;
 	u32 dirty_ring_size;
-	bool dirty_ring_with_bitmap;
 	bool vm_bugged;
 	bool vm_dead;
 
diff --git a/virt/kvm/dirty_ring.c b/virt/kvm/dirty_ring.c
index 9cc60af291ef..53802513de79 100644
--- a/virt/kvm/dirty_ring.c
+++ b/virt/kvm/dirty_ring.c
@@ -11,9 +11,10 @@
 #include <trace/events/kvm.h>
 #include "kvm_mm.h"
 
-bool kvm_dirty_ring_exclusive(struct kvm *kvm)
+bool kvm_use_dirty_bitmap(struct kvm *kvm)
 {
-	return kvm->dirty_ring_size && !kvm->dirty_ring_with_bitmap;
+	return IS_ENABLED(CONFIG_HAVE_KVM_DIRTY_RING_WITH_BITMAP) ||
+	       !kvm->dirty_ring_size;
 }
 
 int __weak kvm_cpu_dirty_log_size(void)
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index dd52b8e42307..0e8aaac5a222 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1617,7 +1617,7 @@ static int kvm_prepare_memory_region(struct kvm *kvm,
 			new->dirty_bitmap = NULL;
 		else if (old && old->dirty_bitmap)
 			new->dirty_bitmap = old->dirty_bitmap;
-		else if (!kvm_dirty_ring_exclusive(kvm)) {
+		else if (kvm_use_dirty_bitmap(kvm)) {
 			r = kvm_alloc_dirty_bitmap(new);
 			if (r)
 				return r;
@@ -2060,8 +2060,7 @@ int kvm_get_dirty_log(struct kvm *kvm, struct kvm_dirty_log *log,
 	unsigned long n;
 	unsigned long any = 0;
 
-	/* Dirty ring tracking may be exclusive to dirty log tracking */
-	if (kvm_dirty_ring_exclusive(kvm))
+	if (!kvm_use_dirty_bitmap(kvm))
 		return -ENXIO;
 
 	*memslot = NULL;
@@ -2125,8 +2124,7 @@ static int kvm_get_dirty_log_protect(struct kvm *kvm, struct kvm_dirty_log *log)
 	unsigned long *dirty_bitmap_buffer;
 	bool flush;
 
-	/* Dirty ring tracking may be exclusive to dirty log tracking */
-	if (kvm_dirty_ring_exclusive(kvm))
+	if (!kvm_use_dirty_bitmap(kvm))
 		return -ENXIO;
 
 	as_id = log->slot >> 16;
@@ -2237,8 +2235,7 @@ static int kvm_clear_dirty_log_protect(struct kvm *kvm,
 	unsigned long *dirty_bitmap_buffer;
 	bool flush;
 
-	/* Dirty ring tracking may be exclusive to dirty log tracking */
-	if (kvm_dirty_ring_exclusive(kvm))
+	if (!kvm_use_dirty_bitmap(kvm))
 		return -ENXIO;
 
 	as_id = log->slot >> 16;
@@ -4505,11 +4502,6 @@ static int kvm_vm_ioctl_enable_dirty_log_ring(struct kvm *kvm, u32 size)
 {
 	int r;
 
-#ifdef CONFIG_HAVE_KVM_DIRTY_RING_WITH_BITMAP
-	if (!kvm->dirty_ring_with_bitmap)
-		return -EINVAL;
-#endif
-
 	if (!KVM_DIRTY_LOG_PAGE_OFFSET)
 		return -EINVAL;
 
@@ -4597,11 +4589,7 @@ static int kvm_vm_ioctl_enable_cap_generic(struct kvm *kvm,
 		return 0;
 	}
 	case KVM_CAP_DIRTY_LOG_RING:
-	case KVM_CAP_DIRTY_LOG_RING_ACQ_REL:
 		return kvm_vm_ioctl_enable_dirty_log_ring(kvm, cap->args[0]);
-	case KVM_CAP_DIRTY_LOG_RING_WITH_BITMAP:
-		kvm->dirty_ring_with_bitmap = true;
-		return 0;
 	default:
 		return kvm_vm_ioctl_enable_cap(kvm, cap);
 	}

base-commit: 4826e54f82ded9f54782f8e9d6bc36c7bae06c1f
-- 

