Return-Path: <kvm+bounces-41309-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C8B4BA65E4E
	for <lists+kvm@lfdr.de>; Mon, 17 Mar 2025 20:45:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 970A617DADF
	for <lists+kvm@lfdr.de>; Mon, 17 Mar 2025 19:44:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 54C251EB5CD;
	Mon, 17 Mar 2025 19:44:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="jWzyo4JG"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04DB71EB1A0
	for <kvm@vger.kernel.org>; Mon, 17 Mar 2025 19:44:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742240644; cv=none; b=XICbPcOf9Q1i18LdSb9rkC7O6tOZBkbbCMyFeYkd7UH2ilw9/ge2hrZS+nYyfOsikmVxCtX6xjN3mVXkd2UrYHfboqK0i1f7wofiIUkmDbY14x7TAIJH269CMkr70lPJACQnuULdYXkX0ecK8kkPROb7DJJJedJu23PLyLNfbYM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742240644; c=relaxed/simple;
	bh=a8vGscu3S40Os036mZXI+eElnD8bWcx+puivXuhMvTc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=OHqcxxMtjGpzMmLegkwhMlwe21VaBtCacVyVrcw25BkluOCBvNAmtQoVtNw9BFF2LRNiv63wXgzQbRc3GEDd4/y3/tQpHfc/PZ+fuGb7CsrOE/egy1d46Sp90AJCM85t78lP1oSIJjfzKGhfNJjAO4OryKLW5sMbDSHnvh43lB8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=jWzyo4JG; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2ff82dd6de0so3207993a91.0
        for <kvm@vger.kernel.org>; Mon, 17 Mar 2025 12:44:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1742240642; x=1742845442; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=na2cp2lUno+la+VBtxVAJtMeOi1hZL3/SfoDx822RBQ=;
        b=jWzyo4JGW621z/XMxkRi3LUZVD6g0ySDEe3jrvcO6JrevCmn2D5A1ObVGGCOvluYiM
         Ch1EOtyr58SGQ9PLaEj8v7+nzJLhIXuQFpdOJhJV5MeFqq1hIFI4c+UnVPoLS9JC+/BL
         DUT/5zwz9l58rFaykrcmGs1yZ9pana484EWs8qMcRHI29OnBZFqY633IiSD406VkLvxg
         lvYXVLtToFz9yA9IdqIx9xGDivuZimIRN+XQxp/V5P0C0MA4FXSnNZmPw/isDRpk3VDl
         4fYa1iDDaiJZrD+EZd1UrOpbNfnlhTVBONhTwqGOjJYgwVBAopTcM8tMtVOW5D7cgd7n
         17KQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742240642; x=1742845442;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=na2cp2lUno+la+VBtxVAJtMeOi1hZL3/SfoDx822RBQ=;
        b=NnJQpDlKV1MGi+0MSqgMoIfGCwHQ5EmiyYDKcN1ZqY2tZUoYUMxZ93MDvCASVnMpSt
         TYLss0QYtGzwczGgaKjgw32NZqDuCLyWL5GwInqAjh/zdP+NSK1KEhGEwmGLeq7irkRe
         qnOKaAgATBh3BN/OsrxJslXpBV4sHLcPxuEeiOrbRXg2lPxPTgGIj5s5Oi1DBgO7uVO+
         6gsJsgm/aMVH+ORAAUGc28syp9N8BhxPgFOqHSzHRUBDcG2xZivV+RGjjILBMJncOtz2
         Y8jQGN0FrLVfccYMyzrzfts4ymgdkI5b6KrgvlH9FPyi8rG3CvYrycvvpDg8LzNjTOVG
         co+w==
X-Forwarded-Encrypted: i=1; AJvYcCVL93syfS8VmgHjUq70Idhe1lYf05lNSYazXIr5Fs2CAMd2CCPtVua5dSz0AfOeKdwdoak=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxuu5u+Vs4ZTT1JJtxuG+kX993JxUkPeY6gM1nMdpnsUo4sJt9W
	0lrJu/yaRMloRmkC4P89zzvAELves6FrOQFB7zM536VXS0CVT33frp+jGGgJr4Hhy4RrvWTmh0W
	zOQ==
X-Google-Smtp-Source: AGHT+IH5k69qql42UsEmhrDthlQuj0cVkZFynZegT0/HbDDK/pk/lfiDnezEWJwaFGoWC3aaiGxu/DkRf1s=
X-Received: from pjj14.prod.google.com ([2002:a17:90b:554e:b0:2fc:d77:541])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2d4e:b0:2ea:aa56:499
 with SMTP id 98e67ed59e1d1-30151cb4c11mr15755968a91.1.1742240642242; Mon, 17
 Mar 2025 12:44:02 -0700 (PDT)
Date: Mon, 17 Mar 2025 12:43:53 -0700
In-Reply-To: <Z9hvwW2C-7_ivkPU@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250315025615.2367411-1-seanjc@google.com> <Z9hvwW2C-7_ivkPU@google.com>
Message-ID: <Z9h7eTs8i8TRRxqU@google.com>
Subject: Re: [PATCH] KVM: x86: Add a module param to control and enumerate
 device posted IRQs
From: Sean Christopherson <seanjc@google.com>
To: Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Mon, Mar 17, 2025, Yosry Ahmed wrote:
> On Fri, Mar 14, 2025 at 07:56:15PM -0700, Sean Christopherson wrote:
> > Add a module param to allow disabling device posted interrupts without
> > having to sacrifice all of APICv/AVIC, and to also effectively enumerate
> > to userspace whether or not KVM may be utilizing device posted IRQs.
> > Disabling device posted interrupts is very desirable for testing, and can
> > even be desirable for production environments, e.g. if the host kernel
> > wants to interpose on device interrupts.
> > 
> > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > ---
> >  arch/x86/include/asm/kvm_host.h | 1 +
> >  arch/x86/kvm/svm/avic.c         | 3 +--
> >  arch/x86/kvm/vmx/posted_intr.c  | 7 +++----
> >  arch/x86/kvm/x86.c              | 9 ++++++++-
> >  4 files changed, 13 insertions(+), 7 deletions(-)
> > 
> > diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> > index d881e7d276b1..bf11c5ee50cb 100644
> > --- a/arch/x86/include/asm/kvm_host.h
> > +++ b/arch/x86/include/asm/kvm_host.h
> > @@ -1922,6 +1922,7 @@ struct kvm_arch_async_pf {
> >  extern u32 __read_mostly kvm_nr_uret_msrs;
> >  extern bool __read_mostly allow_smaller_maxphyaddr;
> >  extern bool __read_mostly enable_apicv;
> > +extern bool __read_mostly enable_device_posted_irqs;
> >  extern struct kvm_x86_ops kvm_x86_ops;
> >  
> >  #define kvm_x86_call(func) static_call(kvm_x86_##func)
> > diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
> > index 65fd245a9953..e0f519565393 100644
> > --- a/arch/x86/kvm/svm/avic.c
> > +++ b/arch/x86/kvm/svm/avic.c
> > @@ -898,8 +898,7 @@ int avic_pi_update_irte(struct kvm *kvm, unsigned int host_irq,
> >  	struct kvm_irq_routing_table *irq_rt;
> >  	int idx, ret = 0;
> >  
> > -	if (!kvm_arch_has_assigned_device(kvm) ||
> > -	    !irq_remapping_cap(IRQ_POSTING_CAP))
> > +	if (!kvm_arch_has_assigned_device(kvm) || !enable_device_posted_irqs)
> 
> This function will now also be skipped if enable_apicv is false. Is this
> always the case here for some reason? Sorry if I missed something
> obvious.

Working as intended, though I failed to document it.  Hrm, but I wasn't expecting
this to be a functional change.  Oh, I know what happened.  I had originally
tacked this on to a big series to clean up the IRTE stuff (spoiler alert), and in
that series common code checked kvm_arch_has_irq_bypass() (which incorporates
enable_apicv) before calling pi_update_irte().

I'll prepend a patch or three to do minimal cleanup before introducing the new
module param.

> > @@ -9772,6 +9776,9 @@ int kvm_x86_vendor_init(struct kvm_x86_init_ops *ops)
> >  	if (r != 0)
> >  		goto out_mmu_exit;
> >  
> > +	enable_device_posted_irqs = enable_device_posted_irqs && enable_apicv &&
> > +				    irq_remapping_cap(IRQ_POSTING_CAP);
> 
> Maybe this is clearer:
> 
> 	enable_device_posted_irqs &= enable_avivc && irq_remapping_cap(IRQ_POSTING_CAP);

I don't have a strong opinion.  I went with the "self check" approach purely
because SVM does so for a few params, e.b.

	nrips = nrips && boot_cpu_has(X86_FEATURE_NRIPS);

Anyone else care either way?  If not, I'll go with Yosry's suggestion.

