Return-Path: <kvm+bounces-28068-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 018929930BA
	for <lists+kvm@lfdr.de>; Mon,  7 Oct 2024 17:09:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9C4381F234AB
	for <lists+kvm@lfdr.de>; Mon,  7 Oct 2024 15:09:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CBF981D7E31;
	Mon,  7 Oct 2024 15:07:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="H9Dq41oI"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A0761DFF7
	for <kvm@vger.kernel.org>; Mon,  7 Oct 2024 15:07:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728313652; cv=none; b=RwBCJfOq9RctQ+leQTZ9jZyPj9G0668NFzxCjhRu4LcjGPDU64hnjMuYZ89USVqcAalAVlWSYQea1XgVmcjKioxnV7pghxYPsLPzIvQr/+2U9I++ZuNfWHPb7T39YziM6pQVDDN875SQAyezECkBLJREU9a4cn5TNf2KhiIgl6Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728313652; c=relaxed/simple;
	bh=CMjkN2SHTY7amr7CLge69sH5Fs5Wd/yIexgmuDkS/ag=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=iJJMBplXPthOZodT0hXmV/CjRjpisWOKzV+Hpgl8bIqFNxualagHwXZ5GjK7FToZidytsiwwP2K1JZRY7oBjKBeSJT+QGwsTMqP5fZQcq0UAWcwHq2ihrfByS0XItB+9u/YxuF0ALjFAXnY46z4d+LVYSpLtuLYi0MAvTSHytQs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=H9Dq41oI; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-206b912491eso48100925ad.0
        for <kvm@vger.kernel.org>; Mon, 07 Oct 2024 08:07:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1728313650; x=1728918450; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=yfDahLBAo/4OnEgZIq5ijm172H35wJWJ5vmSa1v7E30=;
        b=H9Dq41oI4r3cmrm5hqCB5coPRZFCh/cNiZO338JVOAQn7151Dq+vaScp9W1bTJqpWJ
         0K/n6Sq7bXEeGWsNUU39CZ9lpi+2g/WHtceZWxQVSx0GuoOBXLaFFHTxKBkQxw8Inj6C
         IIqeIEoeDwugipNE3UxU57VivH9W4mcZsoB1mnSwcRPePjseKJKV+WNZ1OS4aE/rnlYf
         BwaSVE5kcrE5H6h7ZTSK8j+qHWSnBhKaCzk4zfvwmOREEa6BcoBiZWVWzAidSn0fN6MG
         w4fyBF1jK3AE1IA1AGaRked/VO1GCVSBTJM+IKd5q+5Ghlpji5Geh3KTC/Io6wTbQm9I
         kMNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728313650; x=1728918450;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yfDahLBAo/4OnEgZIq5ijm172H35wJWJ5vmSa1v7E30=;
        b=AacKN4bUiPpZbhb7iufp6MA4lliqyad1YDEq7g8E18Ryg1jIe/byMFcP7BdJh/BeBK
         9rQG9Qv8T1cl388QP15+6Ut3Lmr89KQ3NH4VJ8+eDcYDpy4AKf19bryqXlku1CDlNeJW
         Af0V5sFiIsTLrjcOSoKsNCdgnA1n1YIvXih4RofDoBcQC31rtpPxQE+jvfDFOeObpCfj
         xT8lhI2Irbea/c6EAdkXB+HmUce8E4ZczihsrMSjMzNTuHzIAIE6BT/MHXbLAVCagE1m
         35DdFlkh9bwfX54RrEm39Xm02cjkPxSmHp1cVETBa7+B3i5Li5/F+oDa1kix9z90vn34
         7fNA==
X-Forwarded-Encrypted: i=1; AJvYcCUCaof1lL3pYZrdjMw7EG9w43ESWFfcspA0hMlRVHzP+d+6LpHXo0LgTWXGxk+5SjQNc/E=@vger.kernel.org
X-Gm-Message-State: AOJu0YwVUYuz8V+xnvbeFYNzWBtzwj8dIKeYyl7prHXdONGWU2KLhWMH
	QPQ1nrESff+mrEzT3w9NbYuDLVq0cJHSeaWnrV8LJc2V/0Ya/isugoqWSwuV2iMw5go+hJVzJW5
	P1Q==
X-Google-Smtp-Source: AGHT+IGZGeQzhhYh0+4F11B73SDuGkc3ScbkaQ93OWOqk2W9DcKliuRU+Lx9G00ON7I08zlPLwQB8+DshVQ=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a17:902:7885:b0:205:4fe5:8136 with SMTP id
 d9443c01a7336-20be195b2f0mr244345ad.3.1728313649721; Mon, 07 Oct 2024
 08:07:29 -0700 (PDT)
Date: Mon, 7 Oct 2024 08:07:28 -0700
In-Reply-To: <ZwAeJ1RtReFiRiNd@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241003230105.226476-1-pbonzini@redhat.com> <ZwAeJ1RtReFiRiNd@google.com>
Message-ID: <ZwP1kvgyIGIO_p0x@google.com>
Subject: Re: [PATCH] KVM: x86/mmu: fix KVM_X86_QUIRK_SLOT_ZAP_ALL for shadow MMU
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Fri, Oct 04, 2024, Sean Christopherson wrote:
> On Thu, Oct 03, 2024, Paolo Bonzini wrote:
> > +static void kvm_mmu_zap_memslot(struct kvm *kvm,
> > +				struct kvm_memory_slot *slot)
> >  {
> >  	struct kvm_gfn_range range = {
> >  		.slot = slot,
> > @@ -7064,11 +7096,11 @@ static void kvm_mmu_zap_memslot_leafs(struct kvm *kvm, struct kvm_memory_slot *s
> >  		.end = slot->base_gfn + slot->npages,
> >  		.may_block = true,
> >  	};
> > +	bool flush;
> >  
> >  	write_lock(&kvm->mmu_lock);
> > -	if (kvm_unmap_gfn_range(kvm, &range))
> > -		kvm_flush_remote_tlbs_memslot(kvm, slot);
> > -
> > +	flush = kvm_unmap_gfn_range(kvm, &range);
> 
> Aha!  Finally figured out why this was bugging me.  Using kvm_unmap_gfn_range()
> is subject to a race that would lead to UAF.  Huh.  And that could explain the
> old VFIO bug, though it seems unlikely that the race was being hit.
> 
>   KVM_SET_USER_MEMORY_REGION             vCPU
>                                          __kvm_faultin_pfn() /* resolve fault->pfn */
>   kvm_swap_active_memslots();
>   kvm_zap_gfn_range(APIC);

Copy+paste fail, this was supposed to be synchronize_srcu_expedited().

>   kvm_mmu_zap_memslot();
>                                         {read,write}_lock(&kvm->mmu_lock);
>                                         <install SPTE>
> 
> KVM's existing memslot deletion relies on the mmu_valid_gen check in is_obsolete_sp()
> to detect an obsolete root (and the KVM_REQ_MMU_FREE_OBSOLETE_ROOTS check to handle
> roots without a SP).
> 
> With this approach, roots aren't invalidated, and so a vCPU could install a SPTE
> using the to-be-delete memslot.

This is wrong, I managed to forget kvm->srcu is held for the entire duration of
KVM_RUN (except for the actual VM-Enter/VM-Exit code).  And the slot is retrieved
before the mmu_invalidate_seq snapshot is taken.

