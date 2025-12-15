Return-Path: <kvm+bounces-66037-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 99FF8CBFD63
	for <lists+kvm@lfdr.de>; Mon, 15 Dec 2025 21:53:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 66C22302CB8A
	for <lists+kvm@lfdr.de>; Mon, 15 Dec 2025 20:51:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 40D323271F2;
	Mon, 15 Dec 2025 20:51:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="3W8SmAgC"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C253E327206
	for <kvm@vger.kernel.org>; Mon, 15 Dec 2025 20:51:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765831878; cv=none; b=raFkGOUdab+9C3rf0W4Qd+AxlyTH+rQzra+8YGp5FnesxyjQO6MbncykeY9IhSGqP3GIGQx8XcY9kbCxQiXQ7+XyDvwcnNbQALPkDMD+m2hY5A8XjlatD6EoLcEp20UR/U6CFSQi7jOubYv25ggU0/YsFC1o9jIDOkGZ7iwagCg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765831878; c=relaxed/simple;
	bh=zaps1TeHjaBkAE8awTJiGOXyRdvkkHFT776XDaFxrUw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=XNxQ2cKtD4fqlswLlcUXog4y3THMSvtBqU1dpoTqPnCRZXeiyotx6hqPTzmhmRE0xiFws16dYPnoDpHBf7b/xkrDK/M9RAVysiNFMOEGioFIgl52yWRJhqFA2h2tqQuleR7MFLehR3onWvSCN76AFON/XSTIIzPtcDWzkqLvpw4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=3W8SmAgC; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2a09845b7faso32419485ad.3
        for <kvm@vger.kernel.org>; Mon, 15 Dec 2025 12:51:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1765831876; x=1766436676; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=diLa2diH1nYHO1hxApInM0+dtX2xoLqMeU634WXxrfs=;
        b=3W8SmAgC0zko2U+GEvEOsmX/gPHbTOLTcI0KVHXhDy+0/VA7J12g31zmqvwoQSlXDI
         jz8RIZ8FlAMYH5qRjMQQekUqcPFStNcMBlDL7dKXYu4+mMH8CCsLpy5eMD/XsX3gn8ft
         K24pTF9g8Iie5JJUobwFJD7f6NIuAxLh2PcHkIqQRxnhiMmmw3KeN9v8UQq56Ff4HgKU
         ItCaT5DQIaueUgARq2HqcR1e0z/o05u/VCC/vSXKq+a1sN/t701YKRt/Gia2w/rwX5mx
         HzxrIxkmPPzp0cID7E2rmqvIOyG4FVH6MKwLR9GE0JPwfXMT1goEFd+DSZPgjhOPv0yp
         1GOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765831876; x=1766436676;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=diLa2diH1nYHO1hxApInM0+dtX2xoLqMeU634WXxrfs=;
        b=XKUMSXoUAlwwlQAgTH1kte7sZWk5jkKIekwOhy1E3tX+nu3UH9maJuKWRIivSaRSgF
         BuBAs5LY+bdW1834U1aJX7d34Wo1b5uRQLiHb66/AoFH2nFg9Q4nZQVj5WVdAhPxhY8n
         rW3iucpV7B2WRE5BREMbn7iHmRKT6dSigzds0XuXwy3ifYRrfuZOW0Hae0jbo4mrMo60
         xY0YbRRjiJZ/cokd25B9NmDl8HHgaFfpFBpqwnFmomDyQmTa/cxExPQqtJdfzxyvHKI/
         MDu4z7Zl+VJvsnzZVFhmcKKYR6OlRIqFOOVhnmL/6EQu0gzMRdBazQ1z3sd7VXY3NyL1
         xCQA==
X-Forwarded-Encrypted: i=1; AJvYcCXhPEj9QVQkvKWYUE+hLgEVy8S+qaVTjZXxuLEmaQUFgwXnN7Xe70lfwYgwce5LNJi7YhQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YyRSEvEw+4hjEtHBtVvPpIYeeF7suaf8Ff0sqd42A0ss/l1Co7g
	8TqvKYoMx0s+rjCQ4nEQ8lTJrl5Vv7AeMOf5l4FQXVG/CrlqOevgfffbEVd2t0qA4h8UdY9szdh
	1INrkUw==
X-Google-Smtp-Source: AGHT+IFj9l0wpoQNHT8Y7M3ukghgfENrMandrLnvXCYKSwFKGmEPwaSGu/PXYX1ywSffGQdonWO6tz0DtFk=
X-Received: from plrf15.prod.google.com ([2002:a17:902:ab8f:b0:2a0:ad03:ae6a])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:f651:b0:2a0:fe4a:d666
 with SMTP id d9443c01a7336-2a0fe5a2147mr48345575ad.10.1765831875917; Mon, 15
 Dec 2025 12:51:15 -0800 (PST)
Date: Mon, 15 Dec 2025 12:51:14 -0800
In-Reply-To: <2df1a0c0-31a6-45c9-a92e-abdbfddbd9b6@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251212135051.2155280-1-xiaoyao.li@intel.com>
 <202512130717.aHH8rXSC-lkp@intel.com> <aTy7AG2y1OwIXfqs@google.com> <2df1a0c0-31a6-45c9-a92e-abdbfddbd9b6@intel.com>
Message-ID: <aUB0wlJKtyyJTewL@google.com>
Subject: Re: [PATCH v2] KVM: x86: Don't read guest CR3 when doing async pf
 while the MMU is direct
From: Sean Christopherson <seanjc@google.com>
To: Xiaoyao Li <xiaoyao.li@intel.com>
Cc: kernel test robot <lkp@intel.com>, Paolo Bonzini <pbonzini@redhat.com>, oe-kbuild-all@lists.linux.dev, 
	Rick Edgecombe <rick.p.edgecombe@intel.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, farrah.chen@intel.com
Content-Type: text/plain; charset="us-ascii"

On Mon, Dec 15, 2025, Xiaoyao Li wrote:
> On 12/13/2025 9:01 AM, Sean Christopherson wrote:
> > On Sat, Dec 13, 2025, kernel test robot wrote:
> > > Hi Xiaoyao,
> > > 
> > > kernel test robot noticed the following build warnings:
> > > 
> > > [auto build test WARNING on 7d0a66e4bb9081d75c82ec4957c50034cb0ea449]
> > > 
> > > url:    https://github.com/intel-lab-lkp/linux/commits/Xiaoyao-Li/KVM-x86-Don-t-read-guest-CR3-when-doing-async-pf-while-the-MMU-is-direct/20251212-220612
> > > base:   7d0a66e4bb9081d75c82ec4957c50034cb0ea449
> > > patch link:    https://lore.kernel.org/r/20251212135051.2155280-1-xiaoyao.li%40intel.com
> > > patch subject: [PATCH v2] KVM: x86: Don't read guest CR3 when doing async pf while the MMU is direct
> > > config: i386-buildonly-randconfig-002-20251213 (https://download.01.org/0day-ci/archive/20251213/202512130717.aHH8rXSC-lkp@intel.com/config)
> > > compiler: gcc-14 (Debian 14.2.0-19) 14.2.0
> > > reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251213/202512130717.aHH8rXSC-lkp@intel.com/reproduce)
> > > 
> > > If you fix the issue in a separate patch/commit (i.e. not just a new version of
> > > the same patch/commit), kindly add following tags
> > > | Reported-by: kernel test robot <lkp@intel.com>
> > > | Closes: https://lore.kernel.org/oe-kbuild-all/202512130717.aHH8rXSC-lkp@intel.com/
> > > 
> > > All warnings (new ones prefixed by >>):
> > > 
> > >     In file included from include/linux/kvm_host.h:43,
> > >                      from arch/x86/kvm/irq.h:15,
> > >                      from arch/x86/kvm/mmu/mmu.c:19:
> > >     arch/x86/kvm/mmu/mmu.c: In function 'kvm_arch_setup_async_pf':
> > > > > include/linux/kvm_types.h:54:25: warning: conversion from 'long long unsigned int' to 'long unsigned int' changes value from '18446744073709551615' to '4294967295' [-Woverflow]
> > >        54 | #define INVALID_GPA     (~(gpa_t)0)
> > >           |                         ^
> > >     arch/x86/kvm/mmu/mmu.c:4525:28: note: in expansion of macro 'INVALID_GPA'
> > >      4525 |                 arch.cr3 = INVALID_GPA;
> > >           |                            ^~~~~~~~~~~
> > 
> > Well that's just annoying.  Can we kill 32-bit yet?  Anyways, just ignore this
> > (unless it causes my KVM_WERROR=1 builds to fail, in which case I'll just add an
> > explicit cast, but I think we can just ignore it).
> 
> If your KVM_WERROR=1 builds contain 32-bit config, I think it will fail. I
> think we do need to add the explicit cast.

Ya, you were right.

> You will handle it when applying, right? Thus no need for a v3.

Yep.

