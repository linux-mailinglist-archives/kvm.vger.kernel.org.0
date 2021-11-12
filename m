Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0633744DF54
	for <lists+kvm@lfdr.de>; Fri, 12 Nov 2021 01:51:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234630AbhKLAx7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Nov 2021 19:53:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234599AbhKLAx6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 Nov 2021 19:53:58 -0500
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1FD4C0613F5
        for <kvm@vger.kernel.org>; Thu, 11 Nov 2021 16:51:08 -0800 (PST)
Received: by mail-pl1-x636.google.com with SMTP id b11so7050273pld.12
        for <kvm@vger.kernel.org>; Thu, 11 Nov 2021 16:51:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=7VoEwbSPzrTyOh3w99mGEcK1Otv61yXE8VpDyQ7XU/Q=;
        b=aR0iTUNTxKf6faFpqVLtDxLZ+Z93VjgfuMSy8Y9h3wnwVUTL/oHfhEOsrg0V7yOdYT
         7fq8GTKIKG9OH6zETAjAXEzMtYxKZ4n8vzmgKUi//wtyVazuE6xgdlSVa2YM1WXEZK7o
         ckgTdbQk1CrwriNKigDb1ZxyhMDgLtfKnE3RIVuAKQjcg2mMhNzjvwVYycKmLb0GnSZ1
         GYcRaJBvetbHNGisq5tuHOigfRUZHZConfP9luv9GZtaibkXsyjw/cHwj8DSAwBW3aaZ
         7VyKPKnacS2ZdpG3N5SRXdGPcXpnFm1QD3uLEDYX71FQ35qKY9q+/DI/dPGPqFGBB6ib
         ajeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=7VoEwbSPzrTyOh3w99mGEcK1Otv61yXE8VpDyQ7XU/Q=;
        b=OJHirDhy1HHhU1kpb466AApamT50FQxabrFJq1nd5x+MKNww9S3tFz96vi1Wlo6hzE
         QcJ8ld8bJ6GMXr1sqiXTwoCysmbafq2spEflNCE52d29eHGhVaId5MKc/YSXNHv4xrow
         kFcp5yE/MWNmrTW4QiQ+oietryOsqnKTJ119ok9M9dCm2KPOYAjt5aPq8VWWHMb9BlrG
         mgSIIBinYRdCcWJrv3bv8FPE6x3F5AtnT/LVv1dJI1kwh1ubXfApxGw9LQWelTXdV+Q3
         I4v/AJmZVPAt79e/+cb13794KmlfKGEueAlkMsiZS8DP6PmlT21pfAb54J8rcRnBk9yE
         sHGQ==
X-Gm-Message-State: AOAM5308SQG8xH3iVhgOHhri2eKlJpaDdom0onsERijSpnhuGJkEizRU
        W4lZ2TtPZDKEQVcLhIwDQGwFgA==
X-Google-Smtp-Source: ABdhPJxC4jGH9js/28DTzQpRvZ4IBLyKiJDKoUfHaiXaxCscmtOSb6+KYszrts8CNNHGQNLMJ/jO0g==
X-Received: by 2002:a17:90a:c58f:: with SMTP id l15mr12870593pjt.168.1636678268099;
        Thu, 11 Nov 2021 16:51:08 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id s21sm4279773pfk.3.2021.11.11.16.51.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Nov 2021 16:51:07 -0800 (PST)
Date:   Fri, 12 Nov 2021 00:51:03 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>
Cc:     James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Atish Patra <atish.patra@wdc.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-mips@vger.kernel.org, kvm@vger.kernel.org,
        kvm-ppc@vger.kernel.org, kvm-riscv@lists.infradead.org,
        linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        Ben Gardon <bgardon@google.com>, Marc Zyngier <maz@kernel.org>,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        Anup Patel <anup.patel@wdc.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v5.5 26/30] KVM: Keep memslots in tree-based structures
 instead of array-based ones
Message-ID: <YY26dxv2kM3m2H7Z@google.com>
References: <20211104002531.1176691-1-seanjc@google.com>
 <20211104002531.1176691-27-seanjc@google.com>
 <5f5c80ce-9189-def3-9c50-d5a504925253@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5f5c80ce-9189-def3-9c50-d5a504925253@oracle.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Nov 12, 2021, Maciej S. Szmigiero wrote:
> On 04.11.2021 01:25, Sean Christopherson wrote:
> > -	/*
> > -	 * Remove the old memslot from the hash list and interval tree, copying
> > -	 * the node data would corrupt the structures.
> > -	 */
> > +	int as_id = kvm_memslots_get_as_id(old, new);
> > +	struct kvm_memslots *slots = kvm_get_inactive_memslots(kvm, as_id);
> > +	int idx = slots->node_idx;
> > +
> >   	if (old) {
> > -		hash_del(&old->id_node);
> > -		interval_tree_remove(&old->hva_node, &slots->hva_tree);
> > +		hash_del(&old->id_node[idx]);
> > +		interval_tree_remove(&old->hva_node[idx], &slots->hva_tree);
> > -		if (!new)
> > +		if ((long)old == atomic_long_read(&slots->last_used_slot))
> > +			atomic_long_set(&slots->last_used_slot, (long)new);
> 
> Open-coding cmpxchg() is way less readable than a direct call.

Doh, I meant to call this out and/or add a comment.

My objection to cmpxchg() is that it implies atomicity is required (the kernel's
version adds the lock), which is very much not the case.  So this isn't strictly
an open-coded version of cmpxchg().

> The open-coded version also compiles on x86 to multiple instructions with
> a branch, instead of just a single instruction.

Yeah.  The lock can't be contended, so that part of cmpxchg is a non-issue.  But
that's also why I don't love using cmpxchg.

I don't have a strong preference, I just got briefly confused by the atomicity part.

> > +static void kvm_invalidate_memslot(struct kvm *kvm,
> > +				   struct kvm_memory_slot *old,
> > +				   struct kvm_memory_slot *working_slot)
> > +{
> > +	/*
> > +	 * Mark the current slot INVALID.  As with all memslot modifications,
> > +	 * this must be done on an unreachable slot to avoid modifying the
> > +	 * current slot in the active tree.
> > +	 */
> > +	kvm_copy_memslot(working_slot, old);
> > +	working_slot->flags |= KVM_MEMSLOT_INVALID;
> > +	kvm_replace_memslot(kvm, old, working_slot);
> > +
> > +	/*
> > +	 * Activate the slot that is now marked INVALID, but don't propagate
> > +	 * the slot to the now inactive slots. The slot is either going to be
> > +	 * deleted or recreated as a new slot.
> > +	 */
> > +	kvm_swap_active_memslots(kvm, old->as_id);
> > +
> > +	/*
> > +	 * From this point no new shadow pages pointing to a deleted, or moved,
> > +	 * memslot will be created.  Validation of sp->gfn happens in:
> > +	 *	- gfn_to_hva (kvm_read_guest, gfn_to_pfn)
> > +	 *	- kvm_is_visible_gfn (mmu_check_root)
> > +	 */
> > +	kvm_arch_flush_shadow_memslot(kvm, old);
> 
> This should flush the currently active slot (that is, "working_slot",
> not "old") to not introduce a behavior change with respect to the existing
> code.
> 
> That's also what the previous version of this patch set did.

Eww.  I would much prefer to "fix" the existing code in a prep patch.  It shouldn't
matter, but arch code really should not get passed an INVALID slot.
