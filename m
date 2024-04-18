Return-Path: <kvm+bounces-15166-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E6E128AA38D
	for <lists+kvm@lfdr.de>; Thu, 18 Apr 2024 21:58:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 869D71F248B2
	for <lists+kvm@lfdr.de>; Thu, 18 Apr 2024 19:58:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 328A9190699;
	Thu, 18 Apr 2024 19:53:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="YZ1pWEwS"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76DE8184125
	for <kvm@vger.kernel.org>; Thu, 18 Apr 2024 19:53:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713470011; cv=none; b=YS26UGixQeSwUJF5FCIW95EDB5VpfcOWlOpDOVEdzI2//maALTUPaBNeAtZhO4fU3GTu46MZ1/Us+UUZO0/HloP6b0q095156lel5HfjFClIX15+INjnxlgYfdvq6ZTA3GxGJl5CW8YCiXaX6GA816T5zfita+eFZulrIlM/mdo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713470011; c=relaxed/simple;
	bh=il+9bbj7Kl9RhDUwHRlD6PElXcZpj4hshubhhFULYxI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=be3qMrl4lLHPvYdlk+26n8rCmeUQdNiv65x25iEVeRGvizswKiko5HMBp4Bh8lET0qmSdDisaioQcUruMdOdvUFM7bqeWUZR3H/CsdzdAUJ7lEyph8rw6ObC+uIx3PTG9qC7PW5Oh4qmjoFJ/stncqJP4QoGGPbqMDMclYtU3Rs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=YZ1pWEwS; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-61ab173fe00so24923117b3.3
        for <kvm@vger.kernel.org>; Thu, 18 Apr 2024 12:53:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1713470008; x=1714074808; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=9Fwrx9M7PjHp4hPBDgNAvgC8cnKrAzhv9n1yaPxLSA8=;
        b=YZ1pWEwSwKfzg29f9CqfdwlDzesejVg5BnUVEIHZzcqRbanwhqMfZiiymZMMlSolTP
         yDUM8GypdJ86L4YlWlGhM3mKp/o8JN9UfuoNWuXVZh/peYJwZcFq7mlR6GTKMsrZaFyG
         mpNUhhYJgN8v+v7wKuGQUHCLjP+XANOb6wlBrWPglMl5rE13W7eO2ZFiFMWHB7fv+i0L
         CBHqkmzCUUqZ1ociyNy+YaP1rIT5swURz1a2JJtNfV8vJY+8BiCBSMSZ2+j7MgXwDlGM
         VNdnNStKxdzrd07anmf+8UtlCC+fS2TeftumhDxZuNeoF1+7D3tEP+fLPfFnqcKcqGcw
         MsiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713470008; x=1714074808;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9Fwrx9M7PjHp4hPBDgNAvgC8cnKrAzhv9n1yaPxLSA8=;
        b=VduMEKZ0dC6ng8uUBocp6nnptZa2dHOmiyabsr2bca5CeQL9GVmd2SZqj/8Ga2+S6q
         Ru89MKD6cdjgxzYgEvBCzaEwQpxabIU77bLXcNDjqG1ebstZYLDqisKA0V5DY81/MtpO
         rKTCKMuko3DvWvldR1IHi2aV6mOfYWFR8zqQyhQaWzLqIGfnlolR0OV+l7nQ+dWGmTvB
         HIhHEYR9jSr1/Lo/H/L4VQlrhcUIfeUwZXS5+YMJWLf85yixfyOdLF6lr3wa406tgC9m
         l2CerzG76Ns/9HNlvYUzxkBV1hQ1YjiESl4+JgwtsNELktiGLLZ0LJ1dbe9VoBD7ojjw
         gHDw==
X-Forwarded-Encrypted: i=1; AJvYcCXJo7oFu6Y8htCCZR3JsiKaQpS1n2eytgaYnKTmtH2C8umcdzEWTDAgn+Yv92DJ2X/40oqSEhPXFCqO7XVysePuyMTP
X-Gm-Message-State: AOJu0YxnlWo/SjSUz/GSgwbHFmuentS4LW6Yc0B9FzdyrZTrJSRXcQUZ
	k8kRBnvjwSfwaTvQpRZKHuzf6QED5ORT7ZzXhOnqZeNdGw5zTikWTD8P5qs2INyAjQqrIcuMWpz
	hEA==
X-Google-Smtp-Source: AGHT+IGGyn2/Eis9yr5uvFbHSsNr+5jpucEC9aioMrlcMqw+x+tJjikMNMKUFalz9faFMmsjcJGmE2MmVtI=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a0d:d9d3:0:b0:618:9044:4f8b with SMTP id
 b202-20020a0dd9d3000000b0061890444f8bmr785538ywe.7.1713470008510; Thu, 18 Apr
 2024 12:53:28 -0700 (PDT)
Date: Thu, 18 Apr 2024 12:53:26 -0700
In-Reply-To: <20240418141932.GA1855@willie-the-truck>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240405115815.3226315-1-pbonzini@redhat.com> <20240405115815.3226315-2-pbonzini@redhat.com>
 <20240412104408.GA27645@willie-the-truck> <86jzl2sovz.wl-maz@kernel.org>
 <ZhlLHtfeSHk9gRRO@google.com> <86h6g5si0m.wl-maz@kernel.org>
 <Zh1d94Pl6gneVoDd@google.com> <20240418141932.GA1855@willie-the-truck>
Message-ID: <ZiF6NgGYLSsPNEOg@google.com>
Subject: Re: [PATCH 1/4] KVM: delete .change_pte MMU notifier callback
From: Sean Christopherson <seanjc@google.com>
To: Will Deacon <will@kernel.org>
Cc: Marc Zyngier <maz@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org, 
	kvm@vger.kernel.org, Oliver Upton <oliver.upton@linux.dev>, 
	Tianrui Zhao <zhaotianrui@loongson.cn>, Bibo Mao <maobibo@loongson.cn>, 
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>, Nicholas Piggin <npiggin@gmail.com>, 
	Anup Patel <anup@brainfault.org>, Atish Patra <atishp@atishpatra.org>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@redhat.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	loongarch@lists.linux.dev, linux-mips@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org, 
	linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org, 
	linux-perf-users@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Thu, Apr 18, 2024, Will Deacon wrote:
> On Mon, Apr 15, 2024 at 10:03:51AM -0700, Sean Christopherson wrote:
> > On Sat, Apr 13, 2024, Marc Zyngier wrote:
> > > On Fri, 12 Apr 2024 15:54:22 +0100, Sean Christopherson <seanjc@google.com> wrote:
> > > > 
> > > > On Fri, Apr 12, 2024, Marc Zyngier wrote:
> > > > > On Fri, 12 Apr 2024 11:44:09 +0100, Will Deacon <will@kernel.org> wrote:
> > > > > > On Fri, Apr 05, 2024 at 07:58:12AM -0400, Paolo Bonzini wrote:
> > > > > > Also, if you're in the business of hacking the MMU notifier code, it
> > > > > > would be really great to change the .clear_flush_young() callback so
> > > > > > that the architecture could handle the TLB invalidation. At the moment,
> > > > > > the core KVM code invalidates the whole VMID courtesy of 'flush_on_ret'
> > > > > > being set by kvm_handle_hva_range(), whereas we could do a much
> > > > > > lighter-weight and targetted TLBI in the architecture page-table code
> > > > > > when we actually update the ptes for small ranges.
> > > > > 
> > > > > Indeed, and I was looking at this earlier this week as it has a pretty
> > > > > devastating effect with NV (it blows the shadow S2 for that VMID, with
> > > > > costly consequences).
> > > > > 
> > > > > In general, it feels like the TLB invalidation should stay with the
> > > > > code that deals with the page tables, as it has a pretty good idea of
> > > > > what needs to be invalidated and how -- specially on architectures
> > > > > that have a HW-broadcast facility like arm64.
> > > > 
> > > > Would this be roughly on par with an in-line flush on arm64?  The simpler, more
> > > > straightforward solution would be to let architectures override flush_on_ret,
> > > > but I would prefer something like the below as x86 can also utilize a range-based
> > > > flush when running as a nested hypervisor.
> > 
> > ...
> > 
> > > I think this works for us on HW that has range invalidation, which
> > > would already be a positive move.
> > > 
> > > For the lesser HW that isn't range capable, it also gives the
> > > opportunity to perform the iteration ourselves or go for the nuclear
> > > option if the range is larger than some arbitrary constant (though
> > > this is additional work).
> > > 
> > > But this still considers the whole range as being affected by
> > > range->handler(). It'd be interesting to try and see whether more
> > > precise tracking is (or isn't) generally beneficial.
> > 
> > I assume the idea would be to let arch code do single-page invalidations of
> > stage-2 entries for each gfn?
> 
> Right, as it's the only code which knows which ptes actually ended up
> being aged.
> 
> > Unless I'm having a brain fart, x86 can't make use of that functionality.  Intel
> > doesn't provide any way to do targeted invalidation of stage-2 mappings.  AMD
> > provides an instruction to do broadcast invalidations, but it takes a virtual
> > address, i.e. a stage-1 address.  I can't tell if it's a host virtual address or
> > a guest virtual address, but it's a moot point because KVM doen't have the guest
> > virtual address, and if it's a host virtual address, there would need to be valid
> > mappings in the host page tables for it to work, which KVM can't guarantee.
> 
> Ah, so it sounds like it would need to be an arch opt-in then.

Even if x86 (or some other arch code) could use the precise tracking, I think it
would make sense to have the behavior be arch specific.  Adding infrastructure
to get information from arch code, only to turn around and give it back to arch
code would be odd.

Unless arm64 can't do the invalidation immediately after aging the stage-2 PTE,
the best/easiest solution would be to let arm64 opt out of the common TLB flush
when a SPTE is made young.

With the range-based flushing bundled in, this?

---
 include/linux/kvm_host.h |  2 ++
 virt/kvm/kvm_main.c      | 40 +++++++++++++++++++++++++---------------
 2 files changed, 27 insertions(+), 15 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index afbc99264ffa..8fe5f5e16919 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -2010,6 +2010,8 @@ extern const struct kvm_stats_header kvm_vcpu_stats_header;
 extern const struct _kvm_stats_desc kvm_vcpu_stats_desc[];
 
 #ifdef CONFIG_KVM_GENERIC_MMU_NOTIFIER
+int kvm_arch_flush_tlb_if_young(void);
+
 static inline int mmu_invalidate_retry(struct kvm *kvm, unsigned long mmu_seq)
 {
 	if (unlikely(kvm->mmu_invalidate_in_progress))
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 38b498669ef9..5ebef8ef239c 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -595,6 +595,11 @@ static void kvm_null_fn(void)
 }
 #define IS_KVM_NULL_FN(fn) ((fn) == (void *)kvm_null_fn)
 
+int __weak kvm_arch_flush_tlb_if_young(void)
+{
+	return true;
+}
+
 /* Iterate over each memslot intersecting [start, last] (inclusive) range */
 #define kvm_for_each_memslot_in_hva_range(node, slots, start, last)	     \
 	for (node = interval_tree_iter_first(&slots->hva_tree, start, last); \
@@ -611,6 +616,7 @@ static __always_inline kvm_mn_ret_t __kvm_handle_hva_range(struct kvm *kvm,
 	struct kvm_gfn_range gfn_range;
 	struct kvm_memory_slot *slot;
 	struct kvm_memslots *slots;
+	bool need_flush = false;
 	int i, idx;
 
 	if (WARN_ON_ONCE(range->end <= range->start))
@@ -663,10 +669,22 @@ static __always_inline kvm_mn_ret_t __kvm_handle_hva_range(struct kvm *kvm,
 					break;
 			}
 			r.ret |= range->handler(kvm, &gfn_range);
+
+		       /*
+			* Use a precise gfn-based TLB flush when possible, as
+			* most mmu_notifier events affect a small-ish range.
+			* Fall back to a full TLB flush if the gfn-based flush
+			* fails, and don't bother trying the gfn-based flush
+			* if a full flush is already pending.
+			*/
+		       if (range->flush_on_ret && !need_flush && r.ret &&
+			   kvm_arch_flush_remote_tlbs_range(kvm, gfn_range.start,
+							    gfn_range.end - gfn_range.start + 1))
+			       need_flush = true;
 		}
 	}
 
-	if (range->flush_on_ret && r.ret)
+	if (need_flush)
 		kvm_flush_remote_tlbs(kvm);
 
 	if (r.found_memslot)
@@ -680,7 +698,8 @@ static __always_inline kvm_mn_ret_t __kvm_handle_hva_range(struct kvm *kvm,
 static __always_inline int kvm_handle_hva_range(struct mmu_notifier *mn,
 						unsigned long start,
 						unsigned long end,
-						gfn_handler_t handler)
+						gfn_handler_t handler,
+						bool flush_on_ret)
 {
 	struct kvm *kvm = mmu_notifier_to_kvm(mn);
 	const struct kvm_mmu_notifier_range range = {
@@ -688,7 +707,7 @@ static __always_inline int kvm_handle_hva_range(struct mmu_notifier *mn,
 		.end		= end,
 		.handler	= handler,
 		.on_lock	= (void *)kvm_null_fn,
-		.flush_on_ret	= true,
+		.flush_on_ret	= flush_on_ret,
 		.may_block	= false,
 	};
 
@@ -700,17 +719,7 @@ static __always_inline int kvm_handle_hva_range_no_flush(struct mmu_notifier *mn
 							 unsigned long end,
 							 gfn_handler_t handler)
 {
-	struct kvm *kvm = mmu_notifier_to_kvm(mn);
-	const struct kvm_mmu_notifier_range range = {
-		.start		= start,
-		.end		= end,
-		.handler	= handler,
-		.on_lock	= (void *)kvm_null_fn,
-		.flush_on_ret	= false,
-		.may_block	= false,
-	};
-
-	return __kvm_handle_hva_range(kvm, &range).ret;
+	return kvm_handle_hva_range(mn, start, end, handler, false);
 }
 
 void kvm_mmu_invalidate_begin(struct kvm *kvm)
@@ -876,7 +885,8 @@ static int kvm_mmu_notifier_clear_flush_young(struct mmu_notifier *mn,
 {
 	trace_kvm_age_hva(start, end);
 
-	return kvm_handle_hva_range(mn, start, end, kvm_age_gfn);
+	return kvm_handle_hva_range(mn, start, end, kvm_age_gfn,
+				    kvm_arch_flush_tlb_if_young());
 }
 
 static int kvm_mmu_notifier_clear_young(struct mmu_notifier *mn,

base-commit: eae53272c8ad4e7ed2bbb11bd0456eb5b0484f0c
-- 


