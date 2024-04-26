Return-Path: <kvm+bounces-16059-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 579AA8B3B68
	for <lists+kvm@lfdr.de>; Fri, 26 Apr 2024 17:28:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 858461C20E0F
	for <lists+kvm@lfdr.de>; Fri, 26 Apr 2024 15:28:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 00889149011;
	Fri, 26 Apr 2024 15:28:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="PJv+/VHk"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 004861DFFC
	for <kvm@vger.kernel.org>; Fri, 26 Apr 2024 15:28:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714145307; cv=none; b=irurl+h7RHnHVnOiijnrFo+0PJsD79Io8iN+MigcAX+C53xzl/xL1Y7/fkee7faYB2oTEYI/rPW8KtOEzVMzFhN3Z/L2oCAyuCJhpY8jpmQupFj8gm3jzCrHwrhjdsssfTJw9s31S+h1s8PHexRACVBS07/FztBtDzPXqjsqO5o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714145307; c=relaxed/simple;
	bh=4VyWsxlGEIu53oKuIILv9zWJlbPO/mHfes72GPHmjG4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=DmHfyN2dhMPMzmkiuCfwiS53vZ51oZ7QwE/PpOFGHxmjxMmLiF1evKI1D05L6UTRvO/Mejp7LXJM5jCmbkY0f2aDJ/zw6DHPYR0r2fJb2L0r2a+nIWnfgc45V1WXtcPLUh8rYbn4XOBT7Ww2B76n+zDiXyZJZGlYv1Wxkf3erws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=PJv+/VHk; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-1eb1471c7dbso5510995ad.1
        for <kvm@vger.kernel.org>; Fri, 26 Apr 2024 08:28:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1714145305; x=1714750105; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=D+UDqDG3emdl+nwdFJP3bYWMhdA98juEbDMYnX+rP1E=;
        b=PJv+/VHk4jnQZImQ0D+scqckc/10xbjLetAvmjZrZ0y+lZ+HZWkNuTMDdJB91clNTz
         ndj7QlYwg4o7ZQPXtDchSF2+0x5l113ZV7g5G9+w2k9YxjdM+XAJNiVMZSZWaXSAmcJa
         FaCPyn1IUfA6dPEPMbW65EXH3A2cMrrbkGIgFqbW2FQY037IVrwI6e2PxFs+NWl7Odt/
         DUO/W/MI8RNlcgmwITnLcJj54YmUPmkhOF8R4bZeBYRF6JDSrrFBa7tOfaH7parJZSN/
         ReR1JRA/KhuyOEr6NOthWdcKXp7vi5AIDcWPfYAvvnwYx/nMduieh4qHeVGqIZkcgSKS
         gCow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714145305; x=1714750105;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=D+UDqDG3emdl+nwdFJP3bYWMhdA98juEbDMYnX+rP1E=;
        b=OpLSnU7EV3n2OYSG/MUztLUZhGEPkbFHzY3F5wpffFdyjtMriqVp8k91iYct5Ik3Bb
         lcaPgm3ipPP18GcBcaC1B6VMKGM+L69gc8tRYXLQ/e8bTGMz8mFoGTOuPVkr+cmhEJj8
         BoXq9VOdVE/m99MP7pO/2lD4IWaueTlFR5J81yyGHFNuXbUn4gnugYWtwV64XDjkUPh7
         UrIaM42N/PYEiNPrQNKHzRkrFKusCLET5qo6SWYrSDcjW+NzHcC6FB8G3VQLZ15DhAio
         zvUAYMrzNblAsdO645P+JEX+wrCr7VHc1Twe2We2zl5+n7WD+1sHmGdzqb3GMPrNF5bI
         GQPw==
X-Forwarded-Encrypted: i=1; AJvYcCUY45qXKi4H/OpmEEracZT95FWep/HYzGoWRLl3LdTKbCU3cA/lULwV8LJpVVKbQDryvQhT7I/08EJXF0VYCDrIl4Qq
X-Gm-Message-State: AOJu0YxK24b56hHuqRHY6PqIKUWGMnaVg8eUDbc6jTOSg/J1nDHLSdEM
	R4At19LOHikQrNFlZSeTvrH++lJspPQ7sDIZ31ub27HM05xndSgKB8GnBcOVWbgulzZZsyxpKJY
	OSA==
X-Google-Smtp-Source: AGHT+IEKAOJy9LE0IASl5+cq5pyOm1jFXSWEx8qeF7jYZYv+R0oJ4OP+XQggJcMl7v+26T8Uy0nO92maOOc=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:903:41c2:b0:1e6:624c:f1b8 with SMTP id
 u2-20020a17090341c200b001e6624cf1b8mr815ple.0.1714145305134; Fri, 26 Apr 2024
 08:28:25 -0700 (PDT)
Date: Fri, 26 Apr 2024 08:28:23 -0700
In-Reply-To: <970c8891af05d0cb3ccb6eab2d67a7def3d45f74.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <e324ff5e47e07505648c0092a5370ac9ddd72f0b.1708933498.git.isaku.yamahata@intel.com>
 <2daf03ae-6b5a-44ae-806e-76d09fb5273b@linux.intel.com> <20240313171428.GK935089@ls.amr.corp.intel.com>
 <52bc2c174c06f94a44e3b8b455c0830be9965cdf.camel@intel.com>
 <1d1da229d4bd56acabafd2087a5fabca9f48c6fc.camel@intel.com>
 <20240319215015.GA1994522@ls.amr.corp.intel.com> <CA+EHjTxFZ3kzcMCeqgCv6+UsetAUUH4uSY_V02J1TqakM=HKKQ@mail.gmail.com>
 <970c8891af05d0cb3ccb6eab2d67a7def3d45f74.camel@intel.com>
Message-ID: <ZivIF9vjKcuGie3s@google.com>
Subject: Re: [PATCH v19 011/130] KVM: Add new members to struct kvm_gfn_range
 to operate on
From: Sean Christopherson <seanjc@google.com>
To: Rick P Edgecombe <rick.p.edgecombe@intel.com>
Cc: "tabba@google.com" <tabba@google.com>, Isaku Yamahata <isaku.yamahata@intel.com>, 
	Tina Zhang <tina.zhang@intel.com>, Kai Huang <kai.huang@intel.com>, 
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>, Bo2 Chen <chen.bo@intel.com>, 
	"sagis@google.com" <sagis@google.com>, 
	"isaku.yamahata@linux.intel.com" <isaku.yamahata@linux.intel.com>, 
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>, Erdem Aktas <erdemaktas@google.com>, 
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com" <pbonzini@redhat.com>, 
	Hang Yuan <hang.yuan@intel.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"

On Fri, Apr 26, 2024, Rick P Edgecombe wrote:
> On Fri, 2024-04-26 at 08:39 +0100, Fuad Tabba wrote:
> > > I'm fine with those names. Anyway, I'm fine with wither way, two bools or
> > > enum.
> > 
> > I don't have a strong opinion, but I'd brought it up in a previous
> > patch series. I think that having two bools to encode three states is
> > less intuitive and potentially more bug prone, more so than the naming
> > itself (i.e., _only):

Hmm, yeah, I buy that argument.  We could even harded further by poisoning '0'
to force KVM to explicitly.  Aha!  And maybe use a bitmap?

	enum {
		BUGGY_KVM_INVALIDATION		= 0,
		PROCESS_SHARED			= BIT(0),
		PROCESS_PRIVATE			= BIT(1),
		PROCESS_PRIVATE_AND_SHARED	= PROCESS_SHARED | PROCESS_PRIVATE,
	};

> > https://lore.kernel.org/all/ZUO1Giju0GkUdF0o@google.com/
> 
> Currently in our internal branch we switched to:
> exclude_private
> exclude_shared
> 
> It came together bettter in the code that uses it.

If the choice is between an enum and exclude_*, I would strongly prefer the enum.
Using exclude_* results in inverted polarity for the code that triggers invalidations.

> But I started to wonder if we actually really need exclude_shared. For TDX
> zapping private memory has to be done with more care, because it cannot be re-
> populated without guest coordination. But for shared memory if we are zapping a
> range that includes both private and shared memory, I don't think it should hurt
> to zap the shared memory.

Hell no, I am not risking taking on more baggage in KVM where userspace or some
other subsystem comes to rely on KVM spuriously zapping SPTEs in response to an
unrelated userspace action.  

