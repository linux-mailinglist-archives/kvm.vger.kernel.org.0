Return-Path: <kvm+bounces-26271-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7384B97395B
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 16:06:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A62C61C250B4
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 14:06:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1ACFF195980;
	Tue, 10 Sep 2024 14:05:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Lf9Bu8Gq"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEBD91865E1
	for <kvm@vger.kernel.org>; Tue, 10 Sep 2024 14:05:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725977145; cv=none; b=j2KlmjPUNpfJ6rzJ5yAi+Bhmgq1spZV65fElP6bcdLlNek1zw4H6DJmT2yaY0DxyBwnJoOCimSEalrpgf0olUajx/5PJJTWHpwVZ4xknmNguoGRnA/k/kyRgyEtlIrwC4el14p7A09+ScTwFII+vkjkeWKr5cD69sgyMHPa4b0E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725977145; c=relaxed/simple;
	bh=t8ErVB8odQun7D6nqubwrwdq8/LVz3C4A6u9HDCxsy8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=VFCDPrOEksEtsLn2w7SNnVKWGZSoyXmAwjbJZ7PDIVIVWj9IuQfwSjkbdrKUdhCriAoNKRjEYG5wdgPIV2+CNZoms52qRS+XZLa4DTiVryHI7Zw0ED4FQvDYXO/Eg5MsOBLZRddrikbqwY1ygGxgTJjkkg2T1J8n0K2oOpajMjY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Lf9Bu8Gq; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2d8b4a23230so5821257a91.0
        for <kvm@vger.kernel.org>; Tue, 10 Sep 2024 07:05:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1725977143; x=1726581943; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=hXOmTeRY6PomLyhOcA86DkilxkGrIMLpe4RY7rDX+4M=;
        b=Lf9Bu8GqS63SHyJvJjvrM9mFaV9892up9U5SPwSAP9tlUMCEk3xH6e32iIPc8UR78L
         fYkJMSrDOtIp5uHca+vko3y1r4dcT8e1u284AVtfL4Sny0X/cfV5ghNBc1g8aomttv/Y
         fo98l3Cf3bt6RO8bOZh9/xlv7sEvb9bvr3LF/YGnGDAvvoKd8nLjV5rrB3+2x4lQ0Tbe
         LnJOoANZPA8cQV+IXQeJSNrTYi/y0B7Y2T/TRtCEpuAoLXFLqWFDP1YaboPHw/pwYKR5
         SGqyq6nD1X7LfF1EdWjb/3WBLp6oTxLkXpYC3QmZeAjqugMiQKDJY5s77qUBxNA7i9/R
         oAqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725977143; x=1726581943;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hXOmTeRY6PomLyhOcA86DkilxkGrIMLpe4RY7rDX+4M=;
        b=EF/FFGxIQSXBG6uBABHA0g6hFCr71MnGTIMhyOQkpUjryyuJ7jnuI/+lkr/+1GF42R
         7ulohJCTYpvdk0OqQY507O+gq2UeOpUotQuYPSZpUOqgXO6iBLRnk/hnjjfwwLH3EkWf
         iUK8ovdYPDB9UYI+RaRXPyLMq4pNGiEpZ2GgE6r8fAupwtbAFwMioFWY+7WT6tKXGvgn
         h1W4j+BYx9lbqc4sdcdY91xq1mcUcffG9VFRDGRQaEXX1ITrD4987cf/auzYDQj/9meS
         HsZH3lJotKldZpsFHiJB+5nkDnfuiHJ/oA2qgQBqYDPWKEufEMXqL8ticCaofIhug3G8
         dCDA==
X-Forwarded-Encrypted: i=1; AJvYcCVaaflD5zjydqqBCbdGuEMDwFIg+HLiWKGm+SZdrafvCgufYEuXotNDLVx9vEusiVC/AFI=@vger.kernel.org
X-Gm-Message-State: AOJu0YynXWf7jpzvxVJW6h9BNxxX8c2dWvuBeH5KJAjHtNkT73h+SkG/
	cMvYdhRKk4EYmoigswN5jmN1uAmwbvmSx7/F2MgIb2F5i4QQ/0vacgS+xVmoPlg73kngX+c56d3
	zpg==
X-Google-Smtp-Source: AGHT+IHY7Zm41nQugrtyi3XpGw9nez+eUwT1LK7XarrI7Y/zK4pfY2UZwEEv9rY2QWqJJ5NBxwihpUJRBhE=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90b:4a45:b0:2d8:8f24:bd8c with SMTP id
 98e67ed59e1d1-2dad4b8d9edmr308985a91.0.1725977143145; Tue, 10 Sep 2024
 07:05:43 -0700 (PDT)
Date: Tue, 10 Sep 2024 07:05:41 -0700
In-Reply-To: <b791a3f6-a5ab-4f7e-bb2a-d277b26ec2c4@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240904030751.117579-1-rick.p.edgecombe@intel.com>
 <20240904030751.117579-18-rick.p.edgecombe@intel.com> <b791a3f6-a5ab-4f7e-bb2a-d277b26ec2c4@redhat.com>
Message-ID: <ZuBSNS33_ck-w6-9@google.com>
Subject: Re: [PATCH 17/21] KVM: TDX: MTRR: implement get_mt_mask() for TDX
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Rick Edgecombe <rick.p.edgecombe@intel.com>, kvm@vger.kernel.org, kai.huang@intel.com, 
	dmatlack@google.com, isaku.yamahata@gmail.com, yan.y.zhao@intel.com, 
	nik.borisov@suse.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Tue, Sep 10, 2024, Paolo Bonzini wrote:
> On 9/4/24 05:07, Rick Edgecombe wrote:
> > From: Isaku Yamahata <isaku.yamahata@intel.com>
> > 
> > Although TDX supports only WB for private GPA, it's desirable to support
> > MTRR for shared GPA.  Always honor guest PAT for shared EPT as what's done
> > for normal VMs.
> > 
> > Suggested-by: Kai Huang <kai.huang@intel.com>
> > Co-developed-by: Yan Zhao <yan.y.zhao@intel.com>
> > Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
> > Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> > Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
> > ---
> > TDX MMU part 2 v1:
> >   - Align with latest vmx code in kvm/queue.
> >   - Updated patch log.
> >   - Dropped KVM_BUG_ON() in vt_get_mt_mask(). (Rick)
> 
> The only difference at this point is
> 
>         if (!static_cpu_has(X86_FEATURE_SELFSNOOP) &&
>             !kvm_arch_has_noncoherent_dma(vcpu->kvm))
>                 return (MTRR_TYPE_WRBACK << VMX_EPT_MT_EPTE_SHIFT) |
> VMX_EPT_IPAT_BIT;
> 
> 
> which should never be true.  I think this patch can simply be dropped.

And we can/should do what we've done for SEV, and make it a hard dependency to
enable TDX, e.g. similar to this:

	/*
	 * SEV must obviously be supported in hardware.  Sanity check that the
	 * CPU supports decode assists, which is mandatory for SEV guests to
	 * support instruction emulation.  Ditto for flushing by ASID, as SEV
	 * guests are bound to a single ASID, i.e. KVM can't rotate to a new
	 * ASID to effect a TLB flush.
	 */
	if (!boot_cpu_has(X86_FEATURE_SEV) ||
	    WARN_ON_ONCE(!boot_cpu_has(X86_FEATURE_DECODEASSISTS)) ||
	    WARN_ON_ONCE(!boot_cpu_has(X86_FEATURE_FLUSHBYASID)))
		goto out;

