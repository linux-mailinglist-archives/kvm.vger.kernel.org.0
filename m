Return-Path: <kvm+bounces-18825-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D08C98FC005
	for <lists+kvm@lfdr.de>; Wed,  5 Jun 2024 01:40:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0F8021C21A7F
	for <lists+kvm@lfdr.de>; Tue,  4 Jun 2024 23:40:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 855D014EC76;
	Tue,  4 Jun 2024 23:39:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="OrXAbudi"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62E8D14EC6F
	for <kvm@vger.kernel.org>; Tue,  4 Jun 2024 23:38:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717544340; cv=none; b=EHls2uA+Sp3JGS1STMTumZ3hLuLgp77UwHzPgJZ2HrvnfHmjcvAVlhYMZcG7GrFt6NYxm/YZ7NOLTMW86cCvgyavvhpEESKfJ7e3bEKcItx110X/o2WA0zdWOTFDWt5TZ96kC5Gu2ZMO7T8R2rja05iMd1uCKe5kOo5APP6VJx0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717544340; c=relaxed/simple;
	bh=RusASFhma6YK80SGBs5LHmKoNW4EdhIzbx1W+JwsWL0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=NFfbq9W1DOVCDDoV8TrjsselIGG1G6PunVAcwNYXTnzo27/xutWEMozQzjWl2CJA/eMcDheyxhLiJsCQ3lfqKh2PUFemfinFVyo0DAP3g0u/Iy9pMtBoFCiy8vU0OWXnQZh1+INp52CBrxbgXdMMe9crpd120zrZScObCfBFZLU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=OrXAbudi; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-62a08273919so25675257b3.1
        for <kvm@vger.kernel.org>; Tue, 04 Jun 2024 16:38:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1717544338; x=1718149138; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ZUvJNthG5Etp519IwCtLXFB/iTjp2rnBA/tiOcz0nSo=;
        b=OrXAbudic7oriFqbQP91OGF1VQlwaesIrtuxCIQ4XPUlneNVH7M3C3dLE1keGXP4Yd
         rQ9gaCR/K/0+uH7A+kvylDYk4eWviOmj/VtU5RcVKqHBGUoWNL39b1Bb2NZeEV3miuF4
         +7+yLL3DW7ig8NYsVudLkP0DjujVM7pZp8Kfu4Sog+XsPg1bBnMQLlkMd8HL6YkQQPKw
         xJeZJY0VBYAoVXKxN41bTUeJCzSFxIaHF51AxnJP4vgsNxSHi0G9dF8/TUe/cQJrBqcc
         FHBe1F18P9Rtz/LLej3q4AmwS35TX9J0NSAaIUcnMbjQVtvFTSt3YGy0F3PZo/EL3OLe
         WZgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717544338; x=1718149138;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZUvJNthG5Etp519IwCtLXFB/iTjp2rnBA/tiOcz0nSo=;
        b=j4toLs3UtNIRQAAHos89NHUVtbtlLChQSvcYI2zjaEMxHa/bWpS7A2AOBrcnApvjWP
         9+ctSluMZIV3IUfWr48Kft0rp7gt1F9AxED/fvt3IA/Je9Kq3R7Kv8/SMLcFmpy4szBK
         x2PpOYe1Zg84WR1nlpa/R9j/iTJu6N05Ta5VCKF7PMsUJMARxH95fox2zlhLVWG9J0wO
         4fUNc4qUFfErStqLrg2OiZHBoSB00fs8ZqT5Rk0gpFgFKrnG+gDIuXrruYJH4uzHOPNe
         /Ba2G+Tv6R/+3CXHmfbdFBYZa7pbiWWXfXTsKR1WA3skeEnprP48UMdxULQgU9Zat8+W
         QQ+A==
X-Forwarded-Encrypted: i=1; AJvYcCV7rzrDGyWoUKyjLLi4c7j6xM29cTc1rQ4jyDn7ljGy4CM/1RoTI8Jhvv3dkc/CZViZQVmUbbGMvyzVOzMAtiLjGvut
X-Gm-Message-State: AOJu0Yz1L1KFcvxP7dtscPErS5KE/c03obENpHpWg107ryucuDG9EJS9
	EHXcIFSFTirlet0xFHWBf62uoElLgyXxqGRu/buknqcTt3vG3kfaUfrVOl288+XWyh+1kcSC2Ap
	yMg==
X-Google-Smtp-Source: AGHT+IGftjt4bD1elZSc1NbW+UKVTrbQmDNQ5NXixE6FiB2KoBEAHIGgkpeZDCkOZiJX23uP25Lkq1/FzeE=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:690c:fd5:b0:627:e282:6631 with SMTP id
 00721157ae682-62cbb58c2aemr2425297b3.6.1717544337919; Tue, 04 Jun 2024
 16:38:57 -0700 (PDT)
Date: Tue,  4 Jun 2024 16:29:41 -0700
In-Reply-To: <5b0cda8a7456cda476b14fca36414a56f921dd52.1715398655.git.houwenlong.hwl@antgroup.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <5b0cda8a7456cda476b14fca36414a56f921dd52.1715398655.git.houwenlong.hwl@antgroup.com>
X-Mailer: git-send-email 2.45.1.288.g0e0cd299f1-goog
Message-ID: <171754371923.2780627.18224114204018565468.b4-ty@google.com>
Subject: Re: [PATCH v2] KVM: x86/mmu: Only allocate shadowed translation cache
 for sp->role.level <= KVM_MAX_HUGEPAGE_LEVEL
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org, 
	Hou Wenlong <houwenlong.hwl@antgroup.com>
Cc: Lai Jiangshan <jiangshan.ljs@antgroup.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"

On Sat, 11 May 2024 11:46:37 +0800, Hou Wenlong wrote:
> Only the indirect SP with sp->role.level <= KVM_MAX_HUGEPAGE_LEVEL might
> have leaf gptes, so allocation of shadowed translation cache is needed
> only for it. Then, it can use sp->shadowed_translation to determine
> whether to use the information in the shadowed translation cache or not.
> Also, extend the WARN in FNAME(sync_spte)() to ensure that this won't
> break shadow_mmu_get_sp_for_split().
> 
> [...]

Applied to kvm-x86 mmu, thanks!

[1/1] KVM: x86/mmu: Only allocate shadowed translation cache for sp->role.level <= KVM_MAX_HUGEPAGE_LEVEL
      https://github.com/kvm-x86/linux/commit/9ecc1c119b28

--
https://github.com/kvm-x86/linux/tree/next

