Return-Path: <kvm+bounces-24897-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 453D695CDBC
	for <lists+kvm@lfdr.de>; Fri, 23 Aug 2024 15:27:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EDAC0282177
	for <lists+kvm@lfdr.de>; Fri, 23 Aug 2024 13:27:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8CAFD186E43;
	Fri, 23 Aug 2024 13:27:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="2rcjfzw5"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D566D18661A
	for <kvm@vger.kernel.org>; Fri, 23 Aug 2024 13:27:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724419647; cv=none; b=UwUtCq73pvbRAsxDhLdpziJ72+GUG2r/af/gTkHzT261kubRbhV1hl6OFT6YJcRViXbqod6+hSQUKhMfgItLcaip2VsbvLpSKzCrdzLQpks+BaoUCoLYbXk8jlUSV1L0iBz8tyyar8DNHvl5VykRzlhLCEATA3P+IiLkRkQSYy0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724419647; c=relaxed/simple;
	bh=gkV7L0xgIqdS75BR6FVfM70ki27PozW4gYl9NIpEHV8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=sI6bblptIuzRP56SMZV8QXcFrD/Ho49n3zNElfka1u2XoURJjKbUsmZcJpFOwMgZ49sD8FwbqBTFmDzUgS9vhIZ7XW1ooxNw3O5EMZtDuhpsZYl2XpG1+eAF7Owh8hYjwolZXEmNCV/10Q7y6YFluNO2vQJ9kPtNFc/IePQ/ZUQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=2rcjfzw5; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2d3e42ef85eso2239487a91.2
        for <kvm@vger.kernel.org>; Fri, 23 Aug 2024 06:27:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1724419645; x=1725024445; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=N8Ef0ixVq1Ssftzpz2CrTSL5ehMj86hkYQziGH0NMvY=;
        b=2rcjfzw54+/6U9eIBShqmiNCsswdc1w+bhHQNRivjaIiuURprDUGrUMuoTV7vEuWHc
         fOGnbJ/pioTBa7e+a4Q3TYc5LK2OmOUaMG0f84U0B42nmkUZfOXBx+1LTiIdwCC1aZg1
         PsT06QuDVrNnX63p2dkG6A/4p7zKEAxolE6l0sb/hYZmGZriHYmTEhEGHk9Ke1ubum+f
         XGSxG+Cg7aZDRkmRfD1idPE/Ff9KElELSsOy0ULwfvvlS7ZQpX7ggoGDDzhPSDVNihpx
         HVZDWkGlk1P19/TgaUs0RseQklFM3B/iTzTHvvBbSNQpYB+y7HH5YISlmerOFE/cWzhV
         wIkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724419645; x=1725024445;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=N8Ef0ixVq1Ssftzpz2CrTSL5ehMj86hkYQziGH0NMvY=;
        b=MnwRYlyPziM8ivukujDbkLJ59DXorRaLEs+Fmf0hHFB+OXGfogIsw2neUvZrHB7Iul
         Gq3/zmW8Y8Z7LpmOxuSvJOYAJS2rwQEkl4HrXk7mRaEsEjxnZM4Is99DYji4Ehj1k5FN
         p5mTvIVexpKuF9fKuhXl7aRO3YMpQpwG50127qtCP98ETOd2As0bCQfKtWY+jg+8+JTj
         QQnFXVEbCYHy07fu2BUX5HRbGgdhmk4V/vsgKiLdu55BHSAyHoa7wWUYJdnyWHAFsoHu
         WXL1QigGlgHqVrwIFwzZvo2NIwr67ZgEgJMHQCqIUXnrTQQWMAx9rcOyIi3MfZ/6NJ0K
         Kt+g==
X-Forwarded-Encrypted: i=1; AJvYcCUE1q+P7Zqd8cTAZMgcz7qZbIQHz3NIXhHO9SE/Y8UwgbK2jvWwPzYthuvBlZ7Bx4zB8RM=@vger.kernel.org
X-Gm-Message-State: AOJu0YzcankVucDdVE/awRYFdBp7WDg0lmMufJPMaYknupID5E+ORa28
	AV8OBgSlY5GmFYQwdRfndV+kXtfDI56c6wjFK4mvDLwzcG4hMEdefuVKgD+rg7Ww40QrPlU+vQ7
	2Iw==
X-Google-Smtp-Source: AGHT+IEzZfO+fuHrj0fYDVlO89QIfXwRZDOmuttI6MD7uqhT8MwWlZma1Qq3IQN8e5TlXvR8nSwA5lT5Hf0=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90b:1b51:b0:2cd:1e0d:a4c7 with SMTP id
 98e67ed59e1d1-2d646b8fa5dmr36595a91.1.1724419644812; Fri, 23 Aug 2024
 06:27:24 -0700 (PDT)
Date: Fri, 23 Aug 2024 06:27:23 -0700
In-Reply-To: <20240823121538.GA32110@willie-the-truck>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240802191617.312752-1-seanjc@google.com> <20240820154150.GA28750@willie-the-truck>
 <ZsS_OmxwFzrqDcfY@google.com> <20240820163213.GD28750@willie-the-truck>
 <ZsTM-Olv8aT2rql6@google.com> <20240823121538.GA32110@willie-the-truck>
Message-ID: <ZsiOO88d7O8lpQoV@google.com>
Subject: Re: [PATCH] KVM: Use precise range-based flush in mmu_notifier hooks
 when possible
From: Sean Christopherson <seanjc@google.com>
To: Will Deacon <will@kernel.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Marc Zyngier <maz@kernel.org>
Content-Type: text/plain; charset="us-ascii"

On Fri, Aug 23, 2024, Will Deacon wrote:
> On Tue, Aug 20, 2024 at 10:06:00AM -0700, Sean Christopherson wrote:
> > On Tue, Aug 20, 2024, Will Deacon wrote:
> > > On Tue, Aug 20, 2024 at 09:07:22AM -0700, Sean Christopherson wrote:
> > > > On Tue, Aug 20, 2024, Will Deacon wrote:
> > > > > handler could do the invalidation as part of its page-table walk (for
> > > > > example, it could use information about the page-table structure such
> > > > > as the level of the leaves to optimise the invalidation further), but
> > > > > this does at least avoid zapping the whole VMID on CPUs with range
> > > > > support.
> > > > > 
> > > > > My only slight concern is that, should clear_flush_young() be extended
> > > > > to operate on more than a single page-at-a-time in future, this will
> > > > > silently end up invalidating the entire VMID for each memslot unless we
> > > > > teach kvm_arch_flush_remote_tlbs_range() to return !0 in that case.
> > > > 
> > > > I'm not sure I follow the "entire VMID for each memslot" concern.  Are you
> > > > worried about kvm_arch_flush_remote_tlbs_range() failing and triggering a VM-wide
> > > > flush?
> > > 
> > > The arm64 implementation of kvm_arch_flush_remote_tlbs_range()
> > > unconditionally returns 0, so we could end up over-invalidating pretty
> > > badly if that doesn't change. It should be straightforward to fix, but
> > > I just wanted to point it out because it would be easy to miss too!
> > 
> > Sorry, I'm still not following.  0==success, and gfn_range.{start,end} is scoped
> > precisely to the overlap between the memslot and hva range.  Regardless of the
> > number of pages that are passed into clear_flush_young(), KVM should naturally
> > flush only the exact range being aged.  The only hiccup would be if the hva range
> > straddles multiple memslots, but if userspace creates multiple memslots for a
> > single vma, then that's a userspace problem.
> 
> Fair enough, but it's not a lot of effort to fix this (untested diff
> below) and if the code were to change in future so that
> __kvm_handle_hva_range() was more commonly used to span multiple
> memslots we probably wouldn't otherwise notice the silent
> over-invalidation for a while.
> 
> Will
> 
> --->8
> 
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index 6981b1bc0946..1e34127f79b0 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -175,6 +175,9 @@ int kvm_arch_flush_remote_tlbs(struct kvm *kvm)
>  int kvm_arch_flush_remote_tlbs_range(struct kvm *kvm,
>                                       gfn_t gfn, u64 nr_pages)
>  {
> +       if (!system_supports_tlb_range())
> +               return -EOPNOTSUPP;

Oooh, now your comments make a lot more sense.  I didn't catch on that range-based
flushing wasn't universally supported.

Agreed, not doing the above would be asinine.

> +
>         kvm_tlb_flush_vmid_range(&kvm->arch.mmu,
>                                 gfn << PAGE_SHIFT, nr_pages << PAGE_SHIFT);
>         return 0;
> 

