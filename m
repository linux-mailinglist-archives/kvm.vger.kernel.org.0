Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84B8F489ECA
	for <lists+kvm@lfdr.de>; Mon, 10 Jan 2022 19:08:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238734AbiAJSIY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Jan 2022 13:08:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238685AbiAJSIX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Jan 2022 13:08:23 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BEBFC06173F
        for <kvm@vger.kernel.org>; Mon, 10 Jan 2022 10:08:23 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id rj2-20020a17090b3e8200b001b1944bad25so1034951pjb.5
        for <kvm@vger.kernel.org>; Mon, 10 Jan 2022 10:08:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=bEqWx2EUK4iO92y0Z9oZ9LLOTSjHHk27dmkl9EHSOxM=;
        b=n1QthMAju7HsqRqlDkjGOhS5CgY8o+kpNOfOi2HjRs0KJ0pKap4c3KH3XXR7uzjuhB
         bcuLjCu/w9hDoiMGBIuqe/FoGWcb5COnCuhcQnLbOUtOriIwf1/J3k8C4PeYpKbpMsoV
         x4Zl6/wRCUdqEvGtyabSEIijoK4vi/kQHXJyBRaq+RHvLEzwz+AT7fEMLqQJTTVXvUzf
         fwwetNvaLrW05mywyIe2JazC2MrTfiQeo1vLP5qySrb9Q0Mvs4pSRNGdHt4A/fbp2WmK
         Aq4KqboM2bmVb6M7gRfHo/uKFzzZ8pZgGK9TK0vTTQosBiuoBEAv/0NEcQ+6WoIP1fEG
         rU2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=bEqWx2EUK4iO92y0Z9oZ9LLOTSjHHk27dmkl9EHSOxM=;
        b=hS1vmQLUGuOAG8Crv5gwLZVIV4UTI1X12Nu81Q8NqrR5zwwbfDylalmxyr6jXWqXYH
         Auffmk4Y2tnc9j8otd+v8r9lE2Y7yZUWPL7gTAeBO6Op3WNqsDCNEKEOXLoQuR5cp+SJ
         uxNJ2Ro06219Ul6w1vJd3W3gQXdEw+bXdrFSkZ7qzUgH1xENugDyW0zr2nAcBvUoz8f2
         2qD4smVX4Ns6I3ib9sY/LtaPz5/b/2BY0zMDqmhRo//MU9UDVx8KgS3dfJXQJJ+3vEye
         7qTNYaxJ+4XCfvyYNkRUKF2EtvRqIcQ17dxzGptFGZNoCPcsbZX/Lp7wUPjmV1rF6KtB
         Zang==
X-Gm-Message-State: AOAM532W923BMKtfHpNPLctK+5pAHF+KNnOpz8GC0OkKrOzEhuWGH29F
        d8hrE0pur3iKkMrDrxTHLZD60A==
X-Google-Smtp-Source: ABdhPJwTXDxNQf6cEnWuV3fWsQOzn+lb4IGaevHfNCKNvB2LncTW2WDfq/w7i4JlND87Tb7yNfUg8Q==
X-Received: by 2002:a63:a10a:: with SMTP id b10mr744108pgf.539.1641838102417;
        Mon, 10 Jan 2022 10:08:22 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id h19sm7965763pfh.112.2022.01.10.10.08.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Jan 2022 10:08:21 -0800 (PST)
Date:   Mon, 10 Jan 2022 18:08:17 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Shivam Kumar <shivam.kumar1@nutanix.com>
Cc:     pbonzini@redhat.com, kvm@vger.kernel.org, agraf@csgraf.de,
        Shaju Abraham <shaju.abraham@nutanix.com>,
        Manish Mishra <manish.mishra@nutanix.com>,
        Anurag Madnawat <anurag.madnawat@nutanix.com>
Subject: Re: [PATCH v2 1/1] KVM: Implement dirty quota-based throttling of
 vcpus
Message-ID: <Ydx2EW6U3fpJoJF0@google.com>
References: <20211220055722.204341-1-shivam.kumar1@nutanix.com>
 <20211220055722.204341-2-shivam.kumar1@nutanix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211220055722.204341-2-shivam.kumar1@nutanix.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Dec 20, 2021, Shivam Kumar wrote:
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 9a2972fdae82..723f24909314 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -10042,6 +10042,11 @@ static inline bool kvm_vcpu_running(struct kvm_vcpu *vcpu)
>  		!vcpu->arch.apf.halted);
>  }
>  
> +static inline bool is_dirty_quota_full(struct kvm_vcpu *vcpu)
> +{
> +	return (vcpu->stat.generic.dirty_count >= vcpu->run->dirty_quota);
> +}
> +
>  static int vcpu_run(struct kvm_vcpu *vcpu)
>  {
>  	int r;
> @@ -10079,6 +10084,18 @@ static int vcpu_run(struct kvm_vcpu *vcpu)
>  				return r;
>  			vcpu->srcu_idx = srcu_read_lock(&kvm->srcu);
>  		}
> +
> +		/*
> +		 * Exit to userspace when dirty quota is full (if dirty quota
> +		 * throttling is enabled, i.e. dirty quota is non-zero).
> +		 */
> +		if (vcpu->run->dirty_quota > 0 && is_dirty_quota_full(vcpu)) {

Kernel style is to omit the "> 0" when checking for non-zero.  It matters here
because the "> 0" suggests dirty_quota can be negative, which it can't.

To allow userspace to modify dirty_quota on the fly, run->dirty_quota should be
READ_ONCE() with the result used for both the !0 and >= checks.  And then also
capture the effective dirty_quota in the exit union struct (free from a memory
perspective because the exit union is padded to 256 bytes).   That way if userspace
wants to modify the dirty_quota while the vCPU running it will get coherent data
even though the behavior is somewhat non-deterministic.

And then to simplify the code and also make this logic reusable for other
architectures, move it all into the helper and put the helper in kvm_host.h.

For other architectures, unless the arch maintainers explicitly don't want to
support this, I would prefer we enable at least arm64 right away to prevent this
from becoming a de facto x86-only feature.  s390 also appears to be easy to support.
I almost suggested moving the check to generic code, but then I looked at MIPS
and PPC and lost all hope :-/

> +			vcpu->run->exit_reason = KVM_EXIT_DIRTY_QUOTA_FULL;

"FULL" is a bit of a misnomer, there's nothing being filled.  REACHED is a better,
though not perfect because the quota can be exceeded if multiple pages are dirtied
in a single run.  Maybe just KVM_EXIT_DIRTY_QUOTA?

> +			vcpu->run->dqt.dirty_count = vcpu->stat.generic.dirty_count;
> +			r = 0;
> +			break;
> +		}

The dirty quota should be checked _before_ running the vCPU, otherwise KVM_RUN
with count >= quota will let the vCPU make forward progress and possibly dirty
more pages despite being over the quota.

> +
>  	}
>  
>  	srcu_read_unlock(&kvm->srcu, vcpu->srcu_idx);
> diff --git a/include/linux/kvm_types.h b/include/linux/kvm_types.h
> index 234eab059839..01f3726c0e09 100644
> --- a/include/linux/kvm_types.h
> +++ b/include/linux/kvm_types.h
> @@ -87,6 +87,11 @@ struct kvm_vcpu_stat_generic {
>  	u64 halt_poll_success_hist[HALT_POLL_HIST_COUNT];
>  	u64 halt_poll_fail_hist[HALT_POLL_HIST_COUNT];
>  	u64 halt_wait_hist[HALT_POLL_HIST_COUNT];
> +	/*
> +	 * Number of pages the vCPU has dirtied since its creation, while dirty
> +	 * logging is enabled.

This stat should count regardless of whether dirty logging is enabled.  First and
foremost, counting only while dirty logging is enabled creates funky semantics for
KVM_EXIT_DIRTY_QUOTA, e.g. a vCPU can take exits even though no memslots have dirty
logging enabled (due to past counts), and a vCPU can dirty enormous amounts of
memory without exiting due to the relevant memslot not being dirty logged.

Second, the stat could be useful for determining initial quotas or just for debugging.
There's the huge caveat that the counts may be misleading if there's nothing clearing
the dirty bits, but I suspect the info would still be helpful.

Speaking of caveats, this needs documentation in Documentation/virt/kvm/api.rst.
One thing that absolutely needs to be covered is that this quota is not a hard limit,
and that it is enforced opportunistically, e.g. with VMX's PML enabled, a vCPU can go
up to 511 (or 510? I hate math) counts over its quota.

> +	 */
> +	u64 dirty_count;

This doesn't say _what_ is dirty.  I'm not a fan of "count", it's redundant to
some extent (these are numerical stats after all) and "count" is often used for
a value that can be reset at arbitrary times, which isn't true in this case.

Maybe pages_dirtied?  With that, I think you can delete the above comment.

>  };
>  
>  #define KVM_STATS_NAME_SIZE	48
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index 1daa45268de2..632b29a22778 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -270,6 +270,7 @@ struct kvm_xen_exit {
>  #define KVM_EXIT_X86_BUS_LOCK     33
>  #define KVM_EXIT_XEN              34
>  #define KVM_EXIT_RISCV_SBI        35
> +#define KVM_EXIT_DIRTY_QUOTA_FULL 36
>  
>  /* For KVM_EXIT_INTERNAL_ERROR */
>  /* Emulate instruction failed. */
> @@ -307,6 +308,10 @@ struct kvm_run {
>  	__u64 psw_addr; /* psw lower half */
>  #endif
>  	union {
> +		/* KVM_EXIT_DIRTY_QUOTA_FULL */
> +		struct {
> +			__u64 dirty_count;
> +		} dqt;

"dqt" is a bit opaque.  I wouldn't worry too much about keeping the name short.
Having to avoid a collision with the standalone "dirty_quota" is annoying though.
Maybe dirty_quota_exit?

>  		/* KVM_EXIT_UNKNOWN */
>  		struct {
>  			__u64 hardware_exit_reason;
> @@ -508,6 +513,13 @@ struct kvm_run {
>  		struct kvm_sync_regs regs;
>  		char padding[SYNC_REGS_SIZE_BYTES];
>  	} s;
> +	/*
> +	 * Number of pages the vCPU is allowed to dirty (if dirty quota
> +	 * throttling is enabled).

The "(if dirty quota throttling is enabled)" is stale, this is the enable. 

> To dirty more, it needs to request more
> +	 * quota by exiting to userspace (with exit reason
> +	 * KVM_EXIT_DIRTY_QUOTA_FULL).

The blurb about "requesting" more quota is bizarre, the vCPU isn't requesting
anything, it's simply honoring a limit.  For this comment, I think it's better to
simply state the KVM behavior, and then use the documentation entry to describe
how userspace can react to the exit.  There are other subtleties that need to be
addressed, e.g. behavior with respect to clearing of dirty bits, so there should
be a natural segue into using the knob.  E.g. for this:

	/*
	 * Number of pages the vCPU is allowed to have dirtied over its entire
	 * liftime.  KVM_RUN exits with KVM_EXIT_DIRTY_QUOTA if the quota is
	 * reached/exceeded.
	 */


> +	 */
> +	__u64 dirty_quota;
>  };
>  
>  /* for KVM_REGISTER_COALESCED_MMIO / KVM_UNREGISTER_COALESCED_MMIO */
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 72c4e6b39389..f557d91459fb 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -3025,12 +3025,16 @@ void mark_page_dirty_in_slot(struct kvm *kvm,
>  	if (memslot && kvm_slot_dirty_track_enabled(memslot)) {
>  		unsigned long rel_gfn = gfn - memslot->base_gfn;
>  		u32 slot = (memslot->as_id << 16) | memslot->id;
> +		struct kvm_vcpu *vcpu = kvm_get_running_vcpu();
>  
>  		if (kvm->dirty_ring_size)
>  			kvm_dirty_ring_push(kvm_dirty_ring_get(kvm),
>  					    slot, rel_gfn);
>  		else
>  			set_bit_le(rel_gfn, memslot->dirty_bitmap);
> +
> +		if (!WARN_ON_ONCE(!vcpu))
> +			vcpu->stat.generic.dirty_count++;

This all becomes a lot simpler because of commit 2efd61a608b0 ("KVM: Warn if
mark_page_dirty() is called without an active vCPU").

Here's a modified patch with most of the feedback incorporated.

---
 arch/arm64/kvm/arm.c      |  4 ++++
 arch/s390/kvm/kvm-s390.c  |  4 ++++
 arch/x86/kvm/x86.c        |  4 ++++
 include/linux/kvm_host.h  | 14 ++++++++++++++
 include/linux/kvm_types.h |  1 +
 include/uapi/linux/kvm.h  | 12 ++++++++++++
 virt/kvm/kvm_main.c       |  7 ++++++-
 7 files changed, 45 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 868109cf96b4..c02a00237879 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -823,6 +823,10 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 	ret = 1;
 	run->exit_reason = KVM_EXIT_UNKNOWN;
 	while (ret > 0) {
+		ret = kvm_vcpu_check_dirty_quota(vcpu);
+		if (!ret)
+			break;
+
 		/*
 		 * Check conditions before entering the guest
 		 */
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 9c6d45d0d345..ab73a4bf6327 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -3995,6 +3995,10 @@ static int vcpu_pre_run(struct kvm_vcpu *vcpu)
 {
 	int rc, cpuflags;

+	rc = kvm_vcpu_check_dirty_quota(vcpu);
+	if (!rc)
+		return -EREMOTE;
+
 	/*
 	 * On s390 notifications for arriving pages will be delivered directly
 	 * to the guest but the house keeping for completed pfaults is
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index c194a8cbd25f..fe583efe91c0 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10119,6 +10119,10 @@ static int vcpu_run(struct kvm_vcpu *vcpu)
 	vcpu->arch.l1tf_flush_l1d = true;

 	for (;;) {
+		r = kvm_vcpu_check_dirty_quota(vcpu);
+		if (!r)
+			break;
+
 		if (kvm_vcpu_running(vcpu)) {
 			r = vcpu_enter_guest(vcpu);
 		} else {
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index f079820f52b5..7449b9748ddf 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -424,6 +424,20 @@ static inline int kvm_vcpu_exiting_guest_mode(struct kvm_vcpu *vcpu)
 	return cmpxchg(&vcpu->mode, IN_GUEST_MODE, EXITING_GUEST_MODE);
 }

+static inline int kvm_vcpu_check_dirty_quota(struct kvm_vcpu *vcpu)
+{
+	u64 dirty_quota = READ_ONCE(vcpu->run->dirty_quota);
+	struct kvm_run *run = vcpu->run;
+
+	if (!dirty_quota || (vcpu->stat.generic.pages_dirtied < dirty_quota))
+		return 1;
+
+	run->exit_reason = KVM_EXIT_DIRTY_QUOTA;
+	run->dirty_quota_exit.count = vcpu->stat.generic.pages_dirtied;
+	run->dirty_quota_exit.quota = dirty_quota;
+	return 0;
+}
+
 /*
  * Some of the bitops functions do not support too long bitmaps.
  * This number must be determined not to exceed such limits.
diff --git a/include/linux/kvm_types.h b/include/linux/kvm_types.h
index dceac12c1ce5..7f42486b0405 100644
--- a/include/linux/kvm_types.h
+++ b/include/linux/kvm_types.h
@@ -106,6 +106,7 @@ struct kvm_vcpu_stat_generic {
 	u64 halt_poll_fail_hist[HALT_POLL_HIST_COUNT];
 	u64 halt_wait_hist[HALT_POLL_HIST_COUNT];
 	u64 blocking;
+	u64 pages_dirtied;
 };

 #define KVM_STATS_NAME_SIZE	48
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index fbfd70d965c6..a7416c56ab37 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -270,6 +270,7 @@ struct kvm_xen_exit {
 #define KVM_EXIT_X86_BUS_LOCK     33
 #define KVM_EXIT_XEN              34
 #define KVM_EXIT_RISCV_SBI        35
+#define KVM_EXIT_DIRTY_QUOTA	  36

 /* For KVM_EXIT_INTERNAL_ERROR */
 /* Emulate instruction failed. */
@@ -487,6 +488,11 @@ struct kvm_run {
 			unsigned long args[6];
 			unsigned long ret[2];
 		} riscv_sbi;
+		/* KVM_EXIT_DIRTY_QUOTA */
+		struct {
+			__u64 count;
+			__u64 quota;
+		} dirty_quota_exit;
 		/* Fix the size of the union. */
 		char padding[256];
 	};
@@ -508,6 +514,12 @@ struct kvm_run {
 		struct kvm_sync_regs regs;
 		char padding[SYNC_REGS_SIZE_BYTES];
 	} s;
+	/*
+	 * Number of pages the vCPU is allowed to have dirtied over its entire
+	 * liftime.  KVM_RUN exits with KVM_EXIT_DIRTY_QUOTA if the quota is
+	 * reached/exceeded.
+	 */
+	__u64 dirty_quota;
 };

 /* for KVM_REGISTER_COALESCED_MMIO / KVM_UNREGISTER_COALESCED_MMIO */
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 168d0ab93c88..aa526b5b5518 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -3163,7 +3163,12 @@ void mark_page_dirty_in_slot(struct kvm *kvm,
 	if (WARN_ON_ONCE(!vcpu) || WARN_ON_ONCE(vcpu->kvm != kvm))
 		return;

-	if (memslot && kvm_slot_dirty_track_enabled(memslot)) {
+	if (!memslot)
+		return;
+
+	vcpu->stat.generic.pages_dirtied++;
+
+	if (kvm_slot_dirty_track_enabled(memslot)) {
 		unsigned long rel_gfn = gfn - memslot->base_gfn;
 		u32 slot = (memslot->as_id << 16) | memslot->id;

--

