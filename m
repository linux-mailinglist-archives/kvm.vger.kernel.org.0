Return-Path: <kvm+bounces-47301-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 67C4AABFBDE
	for <lists+kvm@lfdr.de>; Wed, 21 May 2025 19:01:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1EB8F502519
	for <lists+kvm@lfdr.de>; Wed, 21 May 2025 17:01:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 84FDE28983E;
	Wed, 21 May 2025 16:59:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="PrDXzSNx"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D7BD289822
	for <kvm@vger.kernel.org>; Wed, 21 May 2025 16:59:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747846794; cv=none; b=Y4ewKGPn2wSHPdq6QDhYE/UvawzHjVvGW2m5jrvurvmq5W6TBLaXnBipZVMV+UkNdxjFmVd94IBthQRC/Cpu+BU06VDu3ZIYFz0ejAXtNrPip7lk4eqQDNaD7SQfjPJcJ/FTIUMWjyeSC3nOsqb0UyBXK4bNtrQYDloHLNgfWaY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747846794; c=relaxed/simple;
	bh=y0v3mpA4u0yZ8hVDzPt7b0GP7skmvPxgwdsGFyF72PA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=t35FxCs11EYnPU7l/qoisyRm7zs7BbiCwRUS+F1xlhk8ucyYIWDi+Z5QDF54yEbuCap15mP3LR9azsH46+EcRlbh/BxZOffKOVm8UC7uFz+fLdhiMuc/UL9XAVjNKvPA2DFdhqRP8HIm1Wc7It5uutwff4TB4Y1rIPGDlbtT2kc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=PrDXzSNx; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-30ec5cc994eso3553087a91.2
        for <kvm@vger.kernel.org>; Wed, 21 May 2025 09:59:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747846792; x=1748451592; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=nn5fm8k2Ml1brz+kg+Xc6EKFqD1WyZfu8AZFfGZAdFU=;
        b=PrDXzSNxPBQ2P0BVCmg25kUgoAJQ9K3vJ4AkgHzl99eMXAZzbPSamcxgoguTmzZ+Bw
         9/ygqaI4MGQERA6AkbgV7vmrgu6YEfwRp+8Xvbi2OYv7tsk3jq5IESyZd8kB9Vk8CLIQ
         Ik2VtHG/v9/yQG9Fc/ZQz3vvcoN0GEKWEfT/criEP15AwhyQzvOcCW54W7DAXsLY5ka4
         lV0uyGDueX6BVTSgDUBIyBY4J4l6IQovTp90aV92s8PUnBeo6sQQSAo/ZQZ0Ed6RU7/O
         45yWARheb/dCMuWjkMqEP7pcDcNTquL2VjmK3Tf9gU8iSM+9Hla6UqIoCUaKfnBwIbZG
         WfEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747846792; x=1748451592;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nn5fm8k2Ml1brz+kg+Xc6EKFqD1WyZfu8AZFfGZAdFU=;
        b=QCM0PxSHq8GMrgpP/AdYHCePJQm+pY1oaBo5JcfAWgOFHmRwzyc1FMBsWLoQB3d6Lf
         BQ5moyYDZJzCIdVwl/gI0/Fk2aWFIPlHA+UTI+uatmy1/lIzDtELiprqsjULts/88Ap9
         /6snjGf7MFOPLiCxVF+2P//blIzLgDY+RUeJXwvkHl0WYIH53yDsBiBxIGLCS/BCZMOk
         Btu57M3bYQhXao/ew0nudAksanDl2RubwRxH0qre5vOcj/ZIe8q2XpHknrVHX1/vvP9H
         zQvQ5PV11VOopcYuJR155EfjGDCqORTxN7lZwZghDghOjO5hhgAP178ptT5OTl0wQW2M
         JeiQ==
X-Forwarded-Encrypted: i=1; AJvYcCXTy+kkBWScRGGAvRhLanHM+bSfZFV3JU8xNzUaecF3O1KRRm3ZKorc237eEjDl0GgzW4c=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy1kVaVgVanI52QI9Qo9nspN3kI38/m14DQAyEAujYUGI2Rn2Jj
	WMQL8TAffkwwjqprFAU3gCF1DC9p3AweW+Fn7crsXycrLQhMpdZ6SJ3wTv1yBjTTTuveasIW1rt
	xuAP5gA==
X-Google-Smtp-Source: AGHT+IG6dBlWQxswmpzRlpBNWMeMsVzFwgqg9N/lMiD/6PEBD2Bv2fiNQRCTifMOfGMxFV8XX1aGvjOU8lY=
X-Received: from pjbsn4.prod.google.com ([2002:a17:90b:2e84:b0:2fc:aac:e580])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1dd1:b0:2ff:784b:ffe
 with SMTP id 98e67ed59e1d1-30e7d522171mr38492906a91.11.1747846792524; Wed, 21
 May 2025 09:59:52 -0700 (PDT)
Date: Wed, 21 May 2025 09:59:51 -0700
In-Reply-To: <aC0c4U6tsVif+M4H@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250512085735.564475-1-chao.gao@intel.com> <aCYLMY00dKbiIfsB@gmail.com>
 <ed3adddc-50a9-4538-9928-22dea0583e24@intel.com> <aC0c4U6tsVif+M4H@intel.com>
Message-ID: <aC4Gh0YMxFzNVws1@google.com>
Subject: Re: [PATCH v7 0/6] Introduce CET supervisor state support
From: Sean Christopherson <seanjc@google.com>
To: Chao Gao <chao.gao@intel.com>
Cc: Dave Hansen <dave.hansen@intel.com>, Ingo Molnar <mingo@kernel.org>, x86@kernel.org, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org, tglx@linutronix.de, 
	pbonzini@redhat.com, peterz@infradead.org, rick.p.edgecombe@intel.com, 
	weijiang.yang@intel.com, john.allen@amd.com, bp@alien8.de, 
	chang.seok.bae@intel.com, xin3.li@intel.com, 
	Aruna Ramakrishna <aruna.ramakrishna@oracle.com>, Dave Hansen <dave.hansen@linux.intel.com>, 
	Eric Biggers <ebiggers@google.com>, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, 
	Kees Cook <kees@kernel.org>, Maxim Levitsky <mlevitsk@redhat.com>, 
	Mitchell Levy <levymitchell0@gmail.com>, Nikolay Borisov <nik.borisov@suse.com>, 
	Oleg Nesterov <oleg@redhat.com>, Samuel Holland <samuel.holland@sifive.com>, 
	Sohil Mehta <sohil.mehta@intel.com>, Stanislav Spassov <stanspas@amazon.de>, 
	Uros Bizjak <ubizjak@gmail.com>, Vignesh Balasubramanian <vigbalas@amd.com>, Zhao Liu <zhao1.liu@intel.com>
Content-Type: text/plain; charset="us-ascii"

On Wed, May 21, 2025, Chao Gao wrote:
> On Fri, May 16, 2025 at 08:20:54AM -0700, Dave Hansen wrote:
> >On 5/15/25 08:41, Ingo Molnar wrote:
> >> * Chao Gao <chao.gao@intel.com> wrote:
> >>> I kindly request your consideration for merging this series. Most of 
> >>> patches have received Reviewed-by/Acked-by tags.
> >> I don't see anything objectionable in this series.
> >> 
> >> The upcoming v6.16 merge window is already quite crowded in terms of 
> >> FPU changes, so I think at this point we are looking at a v6.17 merge, 
> >> done shortly after v6.16-rc1 if everything goes well. Dave, what do you 
> >> think?
> >
> >It's getting into shape, but it has a slight shortage of reviews. For
> >now, it's an all-Intel patch even though I _thought_ AMD had this
> >feature too. It's also purely for KVM and has some suggested-by's from
> >Sean, but no KVM acks on it.
> >
> >Sean is not exactly the quiet type about things, but it always warms me
> >heart to see an acked-by accompanying a suggested-by because it
> >indicates that the suggestion was heard and implemented properly.
> 
> Hi Sean, John,
> 
> Based on Dave's feedback, could you please review this series and provide your
> reviewed-by/acked-by if appropriate?

The initialization of default features is a bit gnarly and I think can be improved
without too much fuss, but otherwise this looks good.

