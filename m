Return-Path: <kvm+bounces-47276-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 7DEDCABF843
	for <lists+kvm@lfdr.de>; Wed, 21 May 2025 16:52:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 199E9188160C
	for <lists+kvm@lfdr.de>; Wed, 21 May 2025 14:51:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D331321CFFD;
	Wed, 21 May 2025 14:50:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="SsjAEio7"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D00B1EC01B
	for <kvm@vger.kernel.org>; Wed, 21 May 2025 14:50:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747839013; cv=none; b=bXw3XZRPqegKf6t6uXrzJvtamH7T0HbnSRP5a+z8GbymzzTnSNPJ8xMLCKpR7dWoOexKWV7UbfTDoT6XZWkAgUS6mrbAV9kaibN/zjyCTWAOlNGbHKFxB3Rc+PQK/MJm7oPimXHf6/7PyVSfV6+EMMKPEA9r0ieMldOJ5+3K6tg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747839013; c=relaxed/simple;
	bh=/sa/iTGfmiqRdvnhquMCQwrbH1y2c4RD535i7oNPve4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=eya5gyeZlytlXNI4I8JgIlfiyv+yhaQAm4tl4apotTCcduJmSblGvTz9SuiY/CDlVq4pA1KSVu2ipq7HwH36WwRgH/7bBZQEvx49pqopFyIae++Ac7Ii9qobm5aJw8ruC+gnhA+lw80ib5IXhlh/6aRbkizSdUFw0KxY8/l+W9Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=SsjAEio7; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-b2371b50cabso7050194a12.0
        for <kvm@vger.kernel.org>; Wed, 21 May 2025 07:50:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747839011; x=1748443811; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=88I2UWCvrWerlTNXLan8CkMZwVh1yIkpQvjTRWhOtIk=;
        b=SsjAEio7hPjghYtj8sI3OlbzHtNeOCOrX1e5rHwiIZGTnQDUgmHcUCXadczsjeIsm2
         eQ8toqcqVPBNZ/yrEKO+OSSFdgT5bvFQwk9GoHFs1Mu5wuLNqmKivFC/iT/EAl9VIz1X
         +jlCxYAaKsjKIL8O/awQdofGnTHzJcB4LoE2j5ucTH7HfmMhuEnOmfUimwlkiBuVK/M+
         FvyZLRtdiD0u13SjKoB1ocN2P8yo5e20rTOQEE/92i7sZ/lAi4y3r/wOhMDNtSGVFT7s
         vecUpsmjmkJpsvilgdwIrT0RUoUjyrCvoe1AdfjPRksl824CoSJwi1uoPAcIyjkFl0HA
         l/CQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747839011; x=1748443811;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=88I2UWCvrWerlTNXLan8CkMZwVh1yIkpQvjTRWhOtIk=;
        b=PlTuUa/WNHOzO3R+b2Zf22i+bcr3iMCSKwvZk1HARDjZ+3PnGjj/HVRixvyM+7HpB4
         ps8pKIbTpFZcbk2ljzXoGCvduoa4co7yJB2+h9CSvpVGYvek4/iCzvLetmZnWzV3ZD2w
         fRa48HJwXDUM9hQXC4cb2ur2hOXfAbUDhc9xdtrWnGa/wwWbR4LmV3VZQdyrx308D7Nb
         4RfpYDl/hTlbqof/Fbr3LC2MUhvuJQ6/zPqh+Az1riHDuQFzO+FdngbGuQdm3BaPno4X
         zhftum7xf4XjVdVADARVaTT3cTU3mqaQjLNSvyvniisxEve21tMCnK9r+W5f6YSbokQc
         1QPQ==
X-Forwarded-Encrypted: i=1; AJvYcCWgsvhG0lURCAl8Ib3Q7SxAFdJWWC933gAckjL3oPLsiHsqLBj+lBDMxQ+q1x3HuhnkBNU=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx2r8wbBIIxJ9x1NQLzjfNuoeFnJwZdaa15Dz4e+7c7P95C9f4B
	Vy0YeeomxhDc6Covd5CX6QyNh7zpd81fScUV5+pXh9CWGGMbVuqt7op7/gaUqRtS1w4FIuLy8rV
	MWbvswQ==
X-Google-Smtp-Source: AGHT+IGvTRSPEQy4eaUK3h8Jgk3fg2fW5Wjpte99Q/OzIF+DOtl3A4V2FUnw8IfRYTpXYQZyjWKOE/ZnZi4=
X-Received: from pjbsb7.prod.google.com ([2002:a17:90b:50c7:b0:30e:6bb2:6855])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90a:c883:b0:2ff:53a4:74f0
 with SMTP id 98e67ed59e1d1-30e8323cdd7mr31951344a91.29.1747839011481; Wed, 21
 May 2025 07:50:11 -0700 (PDT)
Date: Wed, 21 May 2025 07:50:10 -0700
In-Reply-To: <aC0VlENyfE9ewuTF@x1.local>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250516213540.2546077-1-seanjc@google.com> <aCzUIsn1ZF2lEOJ-@x1.local>
 <aC0NMJIeqlgvq0yL@google.com> <aC0VlENyfE9ewuTF@x1.local>
Message-ID: <aC3oIjkivS2KqKZH@google.com>
Subject: Re: [PATCH v3 0/6]  KVM: Dirty ring fixes and cleanups
From: Sean Christopherson <seanjc@google.com>
To: Peter Xu <peterx@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Yan Zhao <yan.y.zhao@intel.com>, Maxim Levitsky <mlevitsk@redhat.com>, 
	Binbin Wu <binbin.wu@linux.intel.com>, James Houghton <jthoughton@google.com>, 
	Pankaj Gupta <pankaj.gupta@amd.com>
Content-Type: text/plain; charset="us-ascii"

On Tue, May 20, 2025, Peter Xu wrote:
> On Tue, May 20, 2025 at 04:16:00PM -0700, Sean Christopherson wrote:
> > On Tue, May 20, 2025, Peter Xu wrote:
> > > On Fri, May 16, 2025 at 02:35:34PM -0700, Sean Christopherson wrote:
> > > > Sean Christopherson (6):
> > > >   KVM: Bound the number of dirty ring entries in a single reset at
> > > >     INT_MAX
> > > >   KVM: Bail from the dirty ring reset flow if a signal is pending
> > > >   KVM: Conditionally reschedule when resetting the dirty ring
> > > >   KVM: Check for empty mask of harvested dirty ring entries in caller
> > > >   KVM: Use mask of harvested dirty ring entries to coalesce dirty ring
> > > >     resets
> > > >   KVM: Assert that slots_lock is held when resetting per-vCPU dirty
> > > >     rings
> > > 
> > > For the last one, I'd think it's majorly because of the memslot accesses
> > > (or CONFIG_LOCKDEP=y should yell already on resets?).  
> > 
> > No?  If KVM only needed to ensure stable memslot accesses, then SRCU would suffice.
> > It sounds like holding slots_lock may have been a somewhat unintentional,  but the
> > reason KVM can't switch to SRCU is that doing so would break ordering, not because
> > slots_lock is needed to protect the memslot accesses.
> 
> Hmm.. isn't what you said exactly means a "yes"? :)
> 
> I mean, I would still expect lockdep to report this ioctl if without the
> slots_lock, please correct me if it's not the case.

Yes, one of slots_lock or SRCU needs to be held.

> And if using RCU is not trivial (or not necessary either), so far the
> slots_lock is still required to make sure the memslot accesses are legal?

I don't follow this part.  The intent of the comment is to document why slots_lock
is required, which is exceptional because memslot access for readers are protected
by kvm->srcu.  The fact that slots_lock also protects memslots is notable only
because it makes acquiring kvm->srcu superfluous.  But grabbing kvm->srcu is still
safe/legal/ok:

diff --git a/virt/kvm/dirty_ring.c b/virt/kvm/dirty_ring.c
index 1ba02a06378c..6bf4f9e2f291 100644
--- a/virt/kvm/dirty_ring.c
+++ b/virt/kvm/dirty_ring.c
@@ -121,18 +121,26 @@ int kvm_dirty_ring_reset(struct kvm *kvm, struct kvm_dirty_ring *ring,
        u64 cur_offset, next_offset;
        unsigned long mask = 0;
        struct kvm_dirty_gfn *entry;
+       int idx;
 
        /*
         * Ensure concurrent calls to KVM_RESET_DIRTY_RINGS are serialized,
         * e.g. so that KVM fully resets all entries processed by a given call
-        * before returning to userspace.  Holding slots_lock also protects
-        * the various memslot accesses.
+        * before returning to userspace.
         */
        lockdep_assert_held(&kvm->slots_lock);
 
+       /*
+        * Holding slots_lock also protects the various memslot accesses, but
+        * acquiring kvm->srcu for read here is still safe, just unnecessary.
+        */
+       idx = srcu_read_lock(&kvm->srcu);
+
        while (likely((*nr_entries_reset) < INT_MAX)) {
-               if (signal_pending(current))
+               if (signal_pending(current)) {
+                       srcu_read_unlock(&kvm->srcu, idx);
                        return -EINTR;
+               }
 
                entry = &ring->dirty_gfns[ring->reset_index & (ring->size - 1)];
 
@@ -205,6 +213,8 @@ int kvm_dirty_ring_reset(struct kvm *kvm, struct kvm_dirty_ring *ring,
        if (mask)
                kvm_reset_dirty_gfn(kvm, cur_slot, cur_offset, mask);
 
+       srcu_read_unlock(&kvm->srcu, idx);
+
        /*
         * The request KVM_REQ_DIRTY_RING_SOFT_FULL will be cleared
         * by the VCPU thread next time when it enters the guest.
--

And unless there are other behaviors that are protected by slots_lock (which is
entirely possible), serializing the processing of each ring could be done via a
dedicated (for example only, the dedicated mutex could/should be per-vCPU, not
global).

This diff in particular shows why I ordered and phrased the comment the way I
did.  The blurb about protecting memslot accesses is purely a friendly reminder
to readers.  The sole reason for an assert and comment is to call out the need
for ordering.

diff --git a/virt/kvm/dirty_ring.c b/virt/kvm/dirty_ring.c
index 1ba02a06378c..92ac82b535fe 100644
--- a/virt/kvm/dirty_ring.c
+++ b/virt/kvm/dirty_ring.c
@@ -102,6 +102,8 @@ static inline bool kvm_dirty_gfn_harvested(struct kvm_dirty_gfn *gfn)
        return smp_load_acquire(&gfn->flags) & KVM_DIRTY_GFN_F_RESET;
 }
 
+static DEFINE_MUTEX(per_ring_lock);
+
 int kvm_dirty_ring_reset(struct kvm *kvm, struct kvm_dirty_ring *ring,
                         int *nr_entries_reset)
 {
@@ -121,18 +123,22 @@ int kvm_dirty_ring_reset(struct kvm *kvm, struct kvm_dirty_ring *ring,
        u64 cur_offset, next_offset;
        unsigned long mask = 0;
        struct kvm_dirty_gfn *entry;
+       int idx;
 
        /*
         * Ensure concurrent calls to KVM_RESET_DIRTY_RINGS are serialized,
         * e.g. so that KVM fully resets all entries processed by a given call
-        * before returning to userspace.  Holding slots_lock also protects
-        * the various memslot accesses.
+        * before returning to userspace.
         */
-       lockdep_assert_held(&kvm->slots_lock);
+       guard(mutex)(&per_ring_lock);
+
+       idx = srcu_read_lock(&kvm->srcu);
 
        while (likely((*nr_entries_reset) < INT_MAX)) {
-               if (signal_pending(current))
+               if (signal_pending(current)) {
+                       srcu_read_unlock(&kvm->srcu, idx);
                        return -EINTR;
+               }
 
                entry = &ring->dirty_gfns[ring->reset_index & (ring->size - 1)];
 
@@ -205,6 +211,8 @@ int kvm_dirty_ring_reset(struct kvm *kvm, struct kvm_dirty_ring *ring,
        if (mask)
                kvm_reset_dirty_gfn(kvm, cur_slot, cur_offset, mask);
 
+       srcu_read_unlock(&kvm->srcu, idx);
+
        /*
         * The request KVM_REQ_DIRTY_RING_SOFT_FULL will be cleared
         * by the VCPU thread next time when it enters the guest.
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 571688507204..45729a6f6451 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -4908,16 +4908,12 @@ static int kvm_vm_ioctl_reset_dirty_pages(struct kvm *kvm)
        if (!kvm->dirty_ring_size)
                return -EINVAL;
 
-       mutex_lock(&kvm->slots_lock);
-
        kvm_for_each_vcpu(i, vcpu, kvm) {
                r = kvm_dirty_ring_reset(vcpu->kvm, &vcpu->dirty_ring, &cleared);
                if (r)
                        break;
        }
 
-       mutex_unlock(&kvm->slots_lock);
-
        if (cleared)
                kvm_flush_remote_tlbs(kvm);
--

