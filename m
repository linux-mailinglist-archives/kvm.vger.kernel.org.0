Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D329B3130B0
	for <lists+kvm@lfdr.de>; Mon,  8 Feb 2021 12:23:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232908AbhBHLXj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Feb 2021 06:23:39 -0500
Received: from mga12.intel.com ([192.55.52.136]:58110 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232931AbhBHLUS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 Feb 2021 06:20:18 -0500
IronPort-SDR: v28so8VD+CsdnwJvpZX1iSJJdthJpyWWNK0iLJ+43IvwrbzBQroyRSkmDO8aTsZc91Y9iviZI5
 UCMMHF0Am4SQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9888"; a="160851215"
X-IronPort-AV: E=Sophos;i="5.81,161,1610438400"; 
   d="scan'208";a="160851215"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Feb 2021 03:18:27 -0800
IronPort-SDR: 05+wl6BZE4c/HyTfuNS+piVU3PmXPxCS6GwDZrhIjFZE2z11s/W85QIppL+HQ9ctTdZ3RJ6nE9
 l4esAJlqFs/w==
X-IronPort-AV: E=Sophos;i="5.81,161,1610438400"; 
   d="scan'208";a="395347722"
Received: from shaojieh-mobl.ccr.corp.intel.com (HELO localhost) ([10.249.172.136])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Feb 2021 03:18:24 -0800
Date:   Mon, 8 Feb 2021 19:18:22 +0800
From:   Yu Zhang <yu.c.zhang@linux.intel.com>
To:     Stephen Rothwell <sfr@canb.auug.org.au>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, KVM <kvm@vger.kernel.org>,
        Ben Gardon <bgardon@google.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: Re: linux-next: build failure after merge of the kvm tree
Message-ID: <20210208111822.b3bxehdnkcf3pzxg@linux.intel.com>
References: <20210208163308.26c3c1c4@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210208163308.26c3c1c4@canb.auug.org.au>
User-Agent: NeoMutt/20171215
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Thanks a lot for reporting this, Stephen. Just sent out a patch
to fix it in kvmgt.

B.R.
Yu

On Mon, Feb 08, 2021 at 04:33:08PM +1100, Stephen Rothwell wrote:
> Hi all,
> 
> After merging the kvm tree, today's linux-next build (x86_64 allmodconfig)
> failed like this:
> 
> drivers/gpu/drm/i915/gvt/kvmgt.c: In function 'kvmgt_page_track_add':
> drivers/gpu/drm/i915/gvt/kvmgt.c:1706:12: error: passing argument 1 of 'spin_lock' from incompatible pointer type [-Werror=incompatible-pointer-types]
>  1706 |  spin_lock(&kvm->mmu_lock);
>       |            ^~~~~~~~~~~~~~
>       |            |
>       |            rwlock_t *
> In file included from include/linux/wait.h:9,
>                  from include/linux/pid.h:6,
>                  from include/linux/sched.h:14,
>                  from include/linux/ratelimit.h:6,
>                  from include/linux/dev_printk.h:16,
>                  from include/linux/device.h:15,
>                  from drivers/gpu/drm/i915/gvt/kvmgt.c:32:
> include/linux/spinlock.h:352:51: note: expected 'spinlock_t *' {aka 'struct spinlock *'} but argument is of type 'rwlock_t *'
>   352 | static __always_inline void spin_lock(spinlock_t *lock)
>       |                                       ~~~~~~~~~~~~^~~~
> drivers/gpu/drm/i915/gvt/kvmgt.c:1715:14: error: passing argument 1 of 'spin_unlock' from incompatible pointer type [-Werror=incompatible-pointer-types]
>  1715 |  spin_unlock(&kvm->mmu_lock);
>       |              ^~~~~~~~~~~~~~
>       |              |
>       |              rwlock_t *
> In file included from include/linux/wait.h:9,
>                  from include/linux/pid.h:6,
>                  from include/linux/sched.h:14,
>                  from include/linux/ratelimit.h:6,
>                  from include/linux/dev_printk.h:16,
>                  from include/linux/device.h:15,
>                  from drivers/gpu/drm/i915/gvt/kvmgt.c:32:
> include/linux/spinlock.h:392:53: note: expected 'spinlock_t *' {aka 'struct spinlock *'} but argument is of type 'rwlock_t *'
>   392 | static __always_inline void spin_unlock(spinlock_t *lock)
>       |                                         ~~~~~~~~~~~~^~~~
> drivers/gpu/drm/i915/gvt/kvmgt.c: In function 'kvmgt_page_track_remove':
> drivers/gpu/drm/i915/gvt/kvmgt.c:1740:12: error: passing argument 1 of 'spin_lock' from incompatible pointer type [-Werror=incompatible-pointer-types]
>  1740 |  spin_lock(&kvm->mmu_lock);
>       |            ^~~~~~~~~~~~~~
>       |            |
>       |            rwlock_t *
> In file included from include/linux/wait.h:9,
>                  from include/linux/pid.h:6,
>                  from include/linux/sched.h:14,
>                  from include/linux/ratelimit.h:6,
>                  from include/linux/dev_printk.h:16,
>                  from include/linux/device.h:15,
>                  from drivers/gpu/drm/i915/gvt/kvmgt.c:32:
> include/linux/spinlock.h:352:51: note: expected 'spinlock_t *' {aka 'struct spinlock *'} but argument is of type 'rwlock_t *'
>   352 | static __always_inline void spin_lock(spinlock_t *lock)
>       |                                       ~~~~~~~~~~~~^~~~
> drivers/gpu/drm/i915/gvt/kvmgt.c:1749:14: error: passing argument 1 of 'spin_unlock' from incompatible pointer type [-Werror=incompatible-pointer-types]
>  1749 |  spin_unlock(&kvm->mmu_lock);
>       |              ^~~~~~~~~~~~~~
>       |              |
>       |              rwlock_t *
> In file included from include/linux/wait.h:9,
>                  from include/linux/pid.h:6,
>                  from include/linux/sched.h:14,
>                  from include/linux/ratelimit.h:6,
>                  from include/linux/dev_printk.h:16,
>                  from include/linux/device.h:15,
>                  from drivers/gpu/drm/i915/gvt/kvmgt.c:32:
> include/linux/spinlock.h:392:53: note: expected 'spinlock_t *' {aka 'struct spinlock *'} but argument is of type 'rwlock_t *'
>   392 | static __always_inline void spin_unlock(spinlock_t *lock)
>       |                                         ~~~~~~~~~~~~^~~~
> drivers/gpu/drm/i915/gvt/kvmgt.c: In function 'kvmgt_page_track_flush_slot':
> drivers/gpu/drm/i915/gvt/kvmgt.c:1775:12: error: passing argument 1 of 'spin_lock' from incompatible pointer type [-Werror=incompatible-pointer-types]
>  1775 |  spin_lock(&kvm->mmu_lock);
>       |            ^~~~~~~~~~~~~~
>       |            |
>       |            rwlock_t *
> In file included from include/linux/wait.h:9,
>                  from include/linux/pid.h:6,
>                  from include/linux/sched.h:14,
>                  from include/linux/ratelimit.h:6,
>                  from include/linux/dev_printk.h:16,
>                  from include/linux/device.h:15,
>                  from drivers/gpu/drm/i915/gvt/kvmgt.c:32:
> include/linux/spinlock.h:352:51: note: expected 'spinlock_t *' {aka 'struct spinlock *'} but argument is of type 'rwlock_t *'
>   352 | static __always_inline void spin_lock(spinlock_t *lock)
>       |                                       ~~~~~~~~~~~~^~~~
> drivers/gpu/drm/i915/gvt/kvmgt.c:1784:14: error: passing argument 1 of 'spin_unlock' from incompatible pointer type [-Werror=incompatible-pointer-types]
>  1784 |  spin_unlock(&kvm->mmu_lock);
>       |              ^~~~~~~~~~~~~~
>       |              |
>       |              rwlock_t *
> In file included from include/linux/wait.h:9,
>                  from include/linux/pid.h:6,
>                  from include/linux/sched.h:14,
>                  from include/linux/ratelimit.h:6,
>                  from include/linux/dev_printk.h:16,
>                  from include/linux/device.h:15,
>                  from drivers/gpu/drm/i915/gvt/kvmgt.c:32:
> include/linux/spinlock.h:392:53: note: expected 'spinlock_t *' {aka 'struct spinlock *'} but argument is of type 'rwlock_t *'
>   392 | static __always_inline void spin_unlock(spinlock_t *lock)
>       |                                         ~~~~~~~~~~~~^~~~
> cc1: all warnings being treated as errors
> 
> Caused by commit
> 
>   531810caa9f4 ("KVM: x86/mmu: Use an rwlock for the x86 MMU")
> 
> I have used the kvm tree from next-20210204 for today.
> 
> -- 
> Cheers,
> Stephen Rothwell


