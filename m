Return-Path: <kvm+bounces-54822-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 91365B28940
	for <lists+kvm@lfdr.de>; Sat, 16 Aug 2025 02:29:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9C874AA7C79
	for <lists+kvm@lfdr.de>; Sat, 16 Aug 2025 00:29:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B119F2AF14;
	Sat, 16 Aug 2025 00:29:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="gu9KFsmq"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 782B9134AB
	for <kvm@vger.kernel.org>; Sat, 16 Aug 2025 00:29:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755304147; cv=none; b=QYv8ZbxXrJ2k7YmPR077cZVC+HDvVAx7Smhy9ZPBfvH6jICt6qjNtGxr9Epycj3I0kJ7+wzJPTd09JuNYwq06/IFwD42Mu79I8HSjD/4XEhary2Apbre4uPuttsmF8tm4FXw3TeK95EQLTJ00+KdlmUjlVuvugdrVuvDi+0XQS8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755304147; c=relaxed/simple;
	bh=g0Cu3J8XTDE1yhg9ki7r+o7qpEPzdSlYsQHzH5cUizI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=R8lAaCP3qPUNh77oSx65OhE9dT7n08wYOK1od1D6Y40OaL8BdWiTfpYPtJAQ+k9q3TxubHT/q17xISQVsObr6mHizMJy38l1qPF8MgQT1ICGvFsWiB+xrNnUfSmXkitC7CZAvSKmkWs+i2mN2cfYH2rTAdQrSP5ezQhPLXswoFc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=gu9KFsmq; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-76e2e5c4734so2256569b3a.0
        for <kvm@vger.kernel.org>; Fri, 15 Aug 2025 17:29:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755304146; x=1755908946; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=8khw5NzRPMCbgjnaVygqmiuP6udAw1TcY6aGWNQ0JPQ=;
        b=gu9KFsmq4hMf3AVw0/cOuBIu8sphUvzA/saVHUyfmwBNwpA08DNJWNrgo29wnuvj+S
         QoQJMsq4vmn29HtWCial8Bp0jApP8q0HbeF9JlA/7HuM9JDJgS0ckDWBB5aWXoWzAOCw
         sVr0c3XEbt8olhDm/frmd1oC2DtXfv52fA022alX+2+3a6FkM9vqq7gFbBrIESDq+kvl
         5cdBkFbJTYWHG/DkhPyGAdEiKunW0c/l7YzZ2Z4gGYWUZi4Kq6iApwqXCuwRsP0FOyVS
         XBURaPoPhsfgtCTLyzRoCQSD5VaJadC1UOh2JUf8JBHoG3+x51iDF+Nn/arDClpmq+JQ
         tTLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755304146; x=1755908946;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8khw5NzRPMCbgjnaVygqmiuP6udAw1TcY6aGWNQ0JPQ=;
        b=kCNWe4KxBHtuxpHtvTdVyeCN8vtKUWEgAfYfAiQNa0itmcD8bxEwzM4QeUKA7K6hUR
         80+is1z6379vdLMUpH/L96lN+IBJMOUzvrqVQ1vL40C90i0LfA0f6EpZK9V70+CsOcfO
         sJJgmscUzwBNLZvf1xpXncooE/5roE7na9H8H2SH6QveeNUeGNQdb+awELHUgX8sXHoW
         ohe22Z9fMeIm5hmbcCwv70nx0QGFpL7ieI2SJlwh4B+n5MkSrPcE8JDQynYE7a3qtAFM
         Uzf4wwejInT1qeVMEwWXJcM2AZ4iJ/Rvx4LLkx0tj0mkE0NugJ20GTOx2gwceB6vV0ZL
         D6hg==
X-Forwarded-Encrypted: i=1; AJvYcCW1x01IlAqEkNmDSY5SKUqzTZWLzkfaKxZiL7f4Sovkr9s5PbcT2RoMRGfh6mvMD781R68=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywdx/MEqaaiXMp18wW3Hla6d6oe2ZDoU9LU1sGa9zLtIs2Dv6ZT
	cgebwXReLxM+nrfdOBvBGrrwtvh2Bg4rTqpBRMTQ5TO3g/0xVfY1DA7hsihqTQsXrv1EgWSnZng
	cV310IQ==
X-Google-Smtp-Source: AGHT+IE/RNDu+a2cs0dp6raYkmh1RRpUHHvTRn5A5p6zxc8xNj7162iBFmzt1JsA27Lu7GfQ343Eg2dFk0E=
X-Received: from pfbgu24.prod.google.com ([2002:a05:6a00:4e58:b0:76b:fb08:20e9])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:2e07:b0:76b:c557:b945
 with SMTP id d2e1a72fcca58-76e44895b8amr6032717b3a.24.1755304145769; Fri, 15
 Aug 2025 17:29:05 -0700 (PDT)
Date: Fri, 15 Aug 2025 17:29:04 -0700
In-Reply-To: <ed29e030-63f2-493f-af74-d1d0e1fb09e4@zhaoxin.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250811013558.332940-1-ewanhai-oc@zhaoxin.com>
 <aJtYlfuBSWhXS3dW@google.com> <ed29e030-63f2-493f-af74-d1d0e1fb09e4@zhaoxin.com>
Message-ID: <aJ_Q0Lu8qCqjHgTk@google.com>
Subject: Re: [PATCH] KVM: x86: expose CPUID 0xC000_0000 for Zhaoxin "Shanghai" vendor
From: Sean Christopherson <seanjc@google.com>
To: Ewan Hai <ewanhai-oc@zhaoxin.com>
Cc: pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, 
	dave.hansen@linux.intel.com, hpa@zytor.com, x86@kernel.org, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, ewanhai@zhaoxin.com, 
	cobechen@zhaoxin.com, leoliu@zhaoxin.com, lyleli@zhaoxin.com
Content-Type: text/plain; charset="us-ascii"

On Wed, Aug 13, 2025, Ewan Hai wrote:
> 
> 
> On 8/12/25 11:07, Sean Christopherson wrote:
> > On Sun, Aug 10, 2025, Ewan Hai wrote:
> > > rename the local constant CENTAUR_CPUID_SIGNATURE to ZHAOXIN_CPUID_SIGNATURE.
> > Why?  I'm not inclined to rename any of the Centaur references, as I don't see
> > any point in effectively rewriting history.  If we elect to rename things, then
> > it needs to be done in a separate patch, there needs to be proper justification,
> > and _all_ references should be converted, e.g. converting just this one macro
> > creates discrepancies even with cpuid.c, as there are multiple comments that
> > specifically talk about Centaur CPUID leaves.
> > 
> Okay, it seems I oversimplified the situation.
> 
> My initial thought was that, since there will no longer be separate handling for
> "Centaurhauls," nearly all new software and hardware features will be applied to
> both "Centaurhauls" and "  Shanghai  " vendors in parallel. This would gradually
> lead to more and more occurrences of if (vendor == centaur || vendor ==
> shanghai) in the kernel code. In that case, introducing an is_zhaoxin_vendor()
> helper could significantly reduce the number of repetitive if (xx || yy) checks.
> 
> However, it appears that this "duplication issue" is not a real concern for now.
> We can revisit it later when it becomes a practical problem.
> 
> For the current matter, there are two possible approaches. Which one do you
> prefer? Or, if you have other suggestions, please let me know and I will
> incorporate your recommendation into the v2 patch.
> 
> ## Version 1 ##
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -1820,7 +1820,8 @@ static int get_cpuid_func(struct kvm_cpuid_array *array, u32 func,
>         int r;
> 
>         if (func == CENTAUR_CPUID_SIGNATURE &&
> -           boot_cpu_data.x86_vendor != X86_VENDOR_CENTAUR)
> +           boot_cpu_data.x86_vendor != X86_VENDOR_CENTAUR &&
> +           boot_cpu_data.x86_vendor != X86_VENDOR_ZHAOXIN)
>                 return 0;
> 
>         r = do_cpuid_func(array, func, type);

This version, please.  As you note above, if we need to tweak things in the future
to dedup code, then I'm happy to do so.  But for now, I don't think KVM needs to
do anything more than add X86_VENDOR_ZHAOXIN to the set of compatible vendor.

