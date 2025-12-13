Return-Path: <kvm+bounces-65915-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id C80F4CBA24C
	for <lists+kvm@lfdr.de>; Sat, 13 Dec 2025 02:02:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 999493019A45
	for <lists+kvm@lfdr.de>; Sat, 13 Dec 2025 01:01:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0B21323D2B2;
	Sat, 13 Dec 2025 01:01:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="p+B/KZcx"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8C16165F16
	for <kvm@vger.kernel.org>; Sat, 13 Dec 2025 01:01:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765587716; cv=none; b=CCaXrY2Yd2Dy3FzK40wDGAnZCSWQQVoSFpM/kOEly++C+7CKuLqKsws57296A0xXfIuWlON8S0eFO5eCUbFWoI3qxpdMRatRbdeQxWwvN7pa82UsevxOGLM3/YiHYrlfn4se5l3GIgWl1jkYd9zF7Xte3SmAcBBOcA0cnnGoqCg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765587716; c=relaxed/simple;
	bh=DDL1jfLW1hz4WUdMItB00xanr/nrgbg93FGLz6fdESY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=u2SlPtT1IYxY8rhntqoZQocMj9MK49E1dEbB+ufIUgHkGw/qQg1/UuT3gC4ttU2565BO4vc5eOPzdFvtwgqFK+Y0AJrdSK6Unj5DiAGqbdlIFpM3TC7Buzh+sPlk1BMZ87cmTc3aHGaum2zBDD4ZR3y0Cy7YgH8VuTzZpGFnaOQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=p+B/KZcx; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-7b8a12f0cb4so1982510b3a.3
        for <kvm@vger.kernel.org>; Fri, 12 Dec 2025 17:01:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1765587714; x=1766192514; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=qGmPxhRCLwLeoN0Jn2kJkVyLdCbAIGmH6gcp9ivIgYE=;
        b=p+B/KZcxbspSphnRMGyLDTi2rYiuwCpZYWv6iVlqim+0ooxCwh33cc+ywX//WIFA/Z
         s1MFgPD7wZfXSqQfLbkiwi1HzBNMjfziZZq7Onx0k8JNw8cp8yWZQjT/1h4mStwRGrGB
         Y8+62GwzjNOP1AweliXeDzTgB9DuvlDFJd1DfAEvyiMC50qD7nEGnZwjv0iBI3J7ezv4
         +BenYQrOYMuT1W+AeYAauEemQjYMMZ4UBI9UVGIosuIbQL7t2Pw9w+M+8tWb75voR+L4
         I1W1Kww712Q389g12EAjYmahXLOn9SLnK8nMkePLnl4pDdesifkPuZ6rGtPyLnYs1h4+
         egtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765587714; x=1766192514;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qGmPxhRCLwLeoN0Jn2kJkVyLdCbAIGmH6gcp9ivIgYE=;
        b=dHLY/oaQpszq4bItKHXvh/FnK0xZpZpWkE/WyZCJCxvZNLgWSZD3Gt90ux2NTxJBHD
         J9ye5Q4Kbuy00hqimBO2UOyTZtnZ0PKmxYIpFyVcHcHzMrKNlSG/Y3r4emtwaZS+k8JH
         cTxWumfRGMjem8d80I0PCAH19KkWpoxl8GtvPRPla9goqxzND6AnOmb+9fdG0L3N1ize
         UUGnDhzdM3JUanOzJ0bWRwYi1Q2+/RhHs4x2SobQdl8hgM/4msXYdFAIT6u4XyWMxfFz
         IfzYCpms0CRhX2zSPgl3EDl7+nBgx+ey5l+IfS5wJeonTuXn3uLUZTAcIw/IgWdcsrsM
         FACw==
X-Forwarded-Encrypted: i=1; AJvYcCXLRVpooKGMo99o88qA4Ex3rZr/0oqZq9JRs7bHOtFDOViMK5NyTIy002847S/gLlNZelY=@vger.kernel.org
X-Gm-Message-State: AOJu0YyL1rGb4ZaqA5O6GuLmslV67yvugd8puO9ckNbJyeeF0i0lC1eT
	Ycst7E1pBLJaePf48BhaQBPTnS+/Xjf9UdCeoACjNQ7n/TqreIqK7UZ50iZzG4+5VvP56PnMCU+
	yp6t+dw==
X-Google-Smtp-Source: AGHT+IFTcExGSp78Md5O2JVDKo++NOAxmErlpynuBmA+4Cwked1rlT56jHlkz3eG6VCW8GjJtn72VI/oKOI=
X-Received: from pgtv2.prod.google.com ([2002:a63:b642:0:b0:bac:ef38:605c])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:7490:b0:35d:d477:a7db
 with SMTP id adf61e73a8af0-369afbff895mr3381877637.56.1765587713879; Fri, 12
 Dec 2025 17:01:53 -0800 (PST)
Date: Fri, 12 Dec 2025 17:01:52 -0800
In-Reply-To: <202512130717.aHH8rXSC-lkp@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251212135051.2155280-1-xiaoyao.li@intel.com> <202512130717.aHH8rXSC-lkp@intel.com>
Message-ID: <aTy7AG2y1OwIXfqs@google.com>
Subject: Re: [PATCH v2] KVM: x86: Don't read guest CR3 when doing async pf
 while the MMU is direct
From: Sean Christopherson <seanjc@google.com>
To: kernel test robot <lkp@intel.com>
Cc: Xiaoyao Li <xiaoyao.li@intel.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	oe-kbuild-all@lists.linux.dev, Rick Edgecombe <rick.p.edgecombe@intel.com>, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, farrah.chen@intel.com
Content-Type: text/plain; charset="us-ascii"

On Sat, Dec 13, 2025, kernel test robot wrote:
> Hi Xiaoyao,
> 
> kernel test robot noticed the following build warnings:
> 
> [auto build test WARNING on 7d0a66e4bb9081d75c82ec4957c50034cb0ea449]
> 
> url:    https://github.com/intel-lab-lkp/linux/commits/Xiaoyao-Li/KVM-x86-Don-t-read-guest-CR3-when-doing-async-pf-while-the-MMU-is-direct/20251212-220612
> base:   7d0a66e4bb9081d75c82ec4957c50034cb0ea449
> patch link:    https://lore.kernel.org/r/20251212135051.2155280-1-xiaoyao.li%40intel.com
> patch subject: [PATCH v2] KVM: x86: Don't read guest CR3 when doing async pf while the MMU is direct
> config: i386-buildonly-randconfig-002-20251213 (https://download.01.org/0day-ci/archive/20251213/202512130717.aHH8rXSC-lkp@intel.com/config)
> compiler: gcc-14 (Debian 14.2.0-19) 14.2.0
> reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251213/202512130717.aHH8rXSC-lkp@intel.com/reproduce)
> 
> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Closes: https://lore.kernel.org/oe-kbuild-all/202512130717.aHH8rXSC-lkp@intel.com/
> 
> All warnings (new ones prefixed by >>):
> 
>    In file included from include/linux/kvm_host.h:43,
>                     from arch/x86/kvm/irq.h:15,
>                     from arch/x86/kvm/mmu/mmu.c:19:
>    arch/x86/kvm/mmu/mmu.c: In function 'kvm_arch_setup_async_pf':
> >> include/linux/kvm_types.h:54:25: warning: conversion from 'long long unsigned int' to 'long unsigned int' changes value from '18446744073709551615' to '4294967295' [-Woverflow]
>       54 | #define INVALID_GPA     (~(gpa_t)0)
>          |                         ^
>    arch/x86/kvm/mmu/mmu.c:4525:28: note: in expansion of macro 'INVALID_GPA'
>     4525 |                 arch.cr3 = INVALID_GPA;
>          |                            ^~~~~~~~~~~

Well that's just annoying.  Can we kill 32-bit yet?  Anyways, just ignore this
(unless it causes my KVM_WERROR=1 builds to fail, in which case I'll just add an
explicit cast, but I think we can just ignore it).

