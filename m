Return-Path: <kvm+bounces-15988-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 4C8968B2CE0
	for <lists+kvm@lfdr.de>; Fri, 26 Apr 2024 00:15:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B6B5D1F21845
	for <lists+kvm@lfdr.de>; Thu, 25 Apr 2024 22:15:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0B2BF156878;
	Thu, 25 Apr 2024 22:07:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="w2+RgLzV"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFC44156675
	for <kvm@vger.kernel.org>; Thu, 25 Apr 2024 22:07:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714082875; cv=none; b=RYwpYkgdy5AP5rtA59qyekb1VKHxBASMse2DaIWoDiqFgjb37oaf5QdKBTg+arMuy2cryr1W9FLUZmR2tdDluNZJZiyG5DJyvBVCWYF5FE9eHCNTJx58DXcnPE9NNuvzwSKaThCtcE0+mLFp3SpUuLXvjpF4mkuqvCb1ZoYrczY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714082875; c=relaxed/simple;
	bh=yHfXIMv03TijJrxzRltTh+L+/RaAJ7o8DK/o081rRDM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=VfAbFsHPyaoRpYtZjYnA9jUPfk7Li6FV4Kd6uTmi4zz8vNTR0RTR6oahzm1GoVkIKJOQH7STi+x+NtgcZi9VVoAzuVY4KlMzgc9eFj/o8EW5ZfsP18N5UdXP5QH3uwBeB9m/ruq0zJHloGv8W7KIHG0M/veNlM6WtOJKxlzugVg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=w2+RgLzV; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-6183c4a6d18so27642887b3.3
        for <kvm@vger.kernel.org>; Thu, 25 Apr 2024 15:07:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1714082873; x=1714687673; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=SeFHCLRAwdC0S6CK8HCmHyQ/e6352LSCdSr5LB6Y830=;
        b=w2+RgLzVIjDt7TSW29y3nPPLlFTKoS0JpIR+l7q4R0DDDdrKLN1vMa7ZrlY+vuFSVZ
         CCLC9et7GMGlXaundaEhfJ18ogYa4OitSAKa41TThyiGcSkeH0w7Lrfw/iT3ITt80gLk
         4sc02JRLiuVa6RHttrhXXsc+AhA+d96PR6BzMJ14t8E1SksZ1vryCDq7hME8xJROuC6o
         vv0vZFvTziyToj2XV6CqrVbz3NzJV3OF/kDvMgfLXSLB9EBvbzITLICI8sc8dbCrxQZy
         iH3rLMxpvYZusZZIzU1dswXv4I6g/Oj0hzROrvqti9nJHXmqN46MzXluB+dl8pkBHHp4
         MKAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714082873; x=1714687673;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=SeFHCLRAwdC0S6CK8HCmHyQ/e6352LSCdSr5LB6Y830=;
        b=WQGjP4dQIRrgXdDzU6t3Bkq/oqoiv3yMhTRL/Rv1Meps528pSawa+OWzznZtvwpGhg
         nMVs4PZMpZMzFvbuEwwVzmu9k9Kps7Gddd2+p1Rk5BuTkLExVrnEj+rdPm2wyIpR8/Gy
         NJt63hkHL4GS8YoxyGjqXcOim3PAa7hDyyX08YUCZkCL94P79YeHz8WOpKEqXwWDAE9X
         CRIgtyRgoha17bFNBtHCuXbdpLfLz+z1ZCvnIdeb7TEP3w1f2WhtSleE6Qnv4GkWy56K
         tgj3XfuUO5IZN/O2/J+CVGTtNXkbLi+Iy3J8ww3zC4Gc25YfK413TDz96eKSEw78SjmR
         zxrg==
X-Forwarded-Encrypted: i=1; AJvYcCWf5En82nO1UUw+NhYHOvyIVjl9P0N1wETIhN4wr9clWsW6d5ZDQ45iFR9Nghzlk77uIqKnUF3bivySzcFgYCyw6xa4
X-Gm-Message-State: AOJu0YyCpQjf1AX9skAqxOb2D5ZIKy+xz8blPCPNOYHo4nLFcWUoT+ch
	cmLTX+C8Y6E69XWLhLzqkyhKRN+NFEKafzMQIn6faW8VMabr5b84U/HuGsdVzt+m9NCK7G3SGED
	+3A==
X-Google-Smtp-Source: AGHT+IED0VPU6WmHVt8MkeqgvlIYRueF66YCVEgBDh8iZX0L++pU6WiZLa3irJzaAv8SycAH1hY76XNklXU=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:7144:0:b0:61b:3b02:6901 with SMTP id
 m65-20020a817144000000b0061b3b026901mr167025ywc.9.1714082872737; Thu, 25 Apr
 2024 15:07:52 -0700 (PDT)
Date: Thu, 25 Apr 2024 15:07:51 -0700
In-Reply-To: <22821630a2616990e5899252da3f29691b9c9ea8.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <deb9ccacc4da04703086d7412b669806133be047.camel@intel.com>
 <ZiaWMpNm30DD1A-0@google.com> <3771fee103b2d279c415e950be10757726a7bd3b.camel@intel.com>
 <Zib76LqLfWg3QkwB@google.com> <6e83e89f145aee496c6421fc5a7248aae2d6f933.camel@intel.com>
 <d0563f077a7f86f90e72183cf3406337423f41fe.camel@intel.com>
 <ZifQiCBPVeld-p8Y@google.com> <61ec08765f0cd79f2d5ea1e2acf285ea9470b239.camel@intel.com>
 <ZiqGRErxDJ1FE8iA@google.com> <22821630a2616990e5899252da3f29691b9c9ea8.camel@intel.com>
Message-ID: <ZirUN9G-Y1VUSlDB@google.com>
Subject: Re: [PATCH v19 023/130] KVM: TDX: Initialize the TDX module when
 loading the KVM intel kernel module
From: Sean Christopherson <seanjc@google.com>
To: Kai Huang <kai.huang@intel.com>
Cc: Tina Zhang <tina.zhang@intel.com>, Hang Yuan <hang.yuan@intel.com>, 
	Bo2 Chen <chen.bo@intel.com>, "sagis@google.com" <sagis@google.com>, 
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Erdem Aktas <erdemaktas@google.com>, 
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com" <pbonzini@redhat.com>, 
	Isaku Yamahata <isaku.yamahata@intel.com>, 
	"isaku.yamahata@linux.intel.com" <isaku.yamahata@linux.intel.com>
Content-Type: text/plain; charset="us-ascii"

On Thu, Apr 25, 2024, Kai Huang wrote:
> On Thu, 2024-04-25 at 09:35 -0700, Sean Christopherson wrote:
> > On Tue, Apr 23, 2024, Kai Huang wrote:
> > > On Tue, 2024-04-23 at 08:15 -0700, Sean Christopherson wrote:
> > > > Presumably that approach relies on something blocking onlining CPUs when TDX is
> > > > active.  And if that's not the case, the proposed patches are buggy.
> > > 
> > > The current patch ([PATCH 023/130] KVM: TDX: Initialize the TDX module
> > > when loading the KVM intel kernel module) indeed is buggy, but I don't
> > > quite follow why we need to block onlining CPU  when TDX is active?
> > 
> > I was saying that based on my reading of the code, either (a) the code is buggy
> > or (b) something blocks onlining CPUs when TDX is active.  Sounds like the answer
> > is (a).
> 
> Yeah it's a).

...

> > > Being a module natually we will need to handle module init and exit.  But
> > > TDX cannot be disabled and re-enabled after initialization, so in general
> > > the vac.ko doesn't quite fit for TDX.
> > > 
> > > And I am not sure what's the fundamental difference between managing TDX
> > > module in a module vs in the core-kernel from KVM's perspective.
> > 
> > VAC isn't strictly necessary.  What I was saying is that it's not strictly
> > necessary for the core kernel to handle VMXON either.  I.e. it could be done in
> > something like VAC, or it could be done in the core kernel.
> 
> Right, but so far I cannot see any advantage of using a VAC module,
> perhaps I am missing something although.

Yeah, there's probably no big advantage.

> > The important thing is that they're handled by _one_ entity.  What we have today
> > is probably the worst setup; VMXON is handled by KVM, but TDX.SYS.LP.INIT is
> > handled by core kernel (sort of).
> 
> I cannot argue against this :-)
> 
> But from this point of view, I cannot see difference between tdx_enable()
> and tdx_cpu_enable(), because they both in core-kernel while depend on KVM
> to handle VMXON.

My comments were made under the assumption that the code was NOT buggy, i.e. if
KVM did NOT need to call tdx_cpu_enable() independent of tdx_enable().

That said, I do think it makes to have tdx_enable() call an private/inner version,
e.g. __tdx_cpu_enable(), and then have KVM call a public version.  Alternatively,
the kernel could register yet another cpuhp hook that runs after KVM's, i.e. does
TDX.SYS.LP.INIT after KVM has done VMXON (if TDX has been enabled).

> Or, do you prefer to we move VMXON to the core-kernel at this stage, i.e.,
> as a prepare work for KVM TDX? 

No, the amount of churn/work that would create is high, and TDX is already taking
on enough churn.

