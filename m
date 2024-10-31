Return-Path: <kvm+bounces-30239-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D91919B83DD
	for <lists+kvm@lfdr.de>; Thu, 31 Oct 2024 20:58:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 175311C20D37
	for <lists+kvm@lfdr.de>; Thu, 31 Oct 2024 19:58:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6B97A1CC16E;
	Thu, 31 Oct 2024 19:57:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="SxN35wgT"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9526D1CBE86
	for <kvm@vger.kernel.org>; Thu, 31 Oct 2024 19:57:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730404665; cv=none; b=aerPKfhRahE9hc5BZVYfKsVc4IfxMJdX+XuzTIsegP6QvrMAsfQKKskHcfnfAUt81gLbPeNULsGkcXcD9SQ13mxP4SxlqCcjJJ3mUh/gMWea8GbwmLh3JGsWU9c5cjPe1pGXQC/4GFN/jzPaVaXzjh6XWHDa8/QmRcLPoME+kns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730404665; c=relaxed/simple;
	bh=2Fc19aNgpDR3mzGTVv4Got1Gf+r4HHpn3RgIuaZAF2g=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=FJIOWdnYcMO+b5343jBLsfPk2PdSieXOeJSBwVVU5+UcPu9obZK3ci8QffHBDx/8/x2rFyyY6vxLPwtf2iVbUD826zd1bcz0/cvmKidnB1JmBd6z9Oppi90aQlgChHZvQuzxbQWiOlAMAX9fEiGyC8uXZgbxDRDEc07Ak5sxfSQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=SxN35wgT; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-7edbbc3a9f2so1072600a12.1
        for <kvm@vger.kernel.org>; Thu, 31 Oct 2024 12:57:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1730404662; x=1731009462; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=r3F9Tm970l4i2U3QXrbYzHLxCe+D7csKpxz2qtmFNYg=;
        b=SxN35wgTI6NS20YXWP5iK0E8Tsd03KheAXwlbQf0XMyVS40H4fvYKiRPJeRgh93Xt/
         86ke/rTF963NMz/TOcXIo2OQJ8CGn+km0n8ul0/gUr0t8EOy5U1JADRS7NY1JocVeKb3
         4h6Z5YzLfl7x1o+WRPQD4GN6HkDLAEFakSw4Jj27BqkCOiTCdgUQTKm8W2yUoe87q/z/
         ZJkcqzpg9yGuP24aRS7Nzu6gDs5kadry1S+mxHPGomHdyW2AQx+f6z0Q9lL0BnRoReFd
         NcMyWlSI34kd7S95UY0z0ARR1wBQ4mj0CMRx6C8/U6oJh4YUhDvrzVWw7ZcqWW7xAfp/
         ZSIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730404662; x=1731009462;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=r3F9Tm970l4i2U3QXrbYzHLxCe+D7csKpxz2qtmFNYg=;
        b=xBd4UzsanwXreAT1Fc/8F+4qazfSuh/cA2Kfxbp7iaF+X84yjzvMehOw6iOb8MUDvi
         M08H1ZCuHePkhTa0Q8QrrhrSVfatqt3AudY2f03pCw9317uigPDL5xlYscv+4ZPVAOV+
         kMADqClZQmRGsvG+KkqqrtNctmpfqcn0NpWpGu65ZTN0++XGXXVcn7CgB3dSRdOxABPA
         t903osPPNv6rewr+95gR/y1gp6xgNvDSDS7zg9FP5HXnJwvJeTRelNahwd8YdcnrGNmE
         d5owF1qymnvxy4dUyJDkEXHXsm9+BmplJiuNcj/eRV0sn5eKjZz1TyLnFptuaAx0FzTr
         wXnw==
X-Gm-Message-State: AOJu0Ywe63nXdOsx2M7m0lU7AUipirStTtqxngkIZNiJpMj1gbM5TmoD
	lGksjERmdjQR2ftDUO3aqHyBMevZKsE6HBabAAl6a8LZpD4Ir9Rd/6Hglsgyo5mTt8/IIM3gK6W
	HBQ==
X-Google-Smtp-Source: AGHT+IHJeeAdS9rX0jZKNYaNs9beXWhUbrThmwMi/rJoQs4GPjqBRKiwtplnoDKJEyuaFFJpDVkqDduBv90=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a17:90b:2347:b0:2e2:eba1:a18e with SMTP id
 98e67ed59e1d1-2e8f11dc30cmr35626a91.5.1730404661753; Thu, 31 Oct 2024
 12:57:41 -0700 (PDT)
Date: Thu, 31 Oct 2024 12:51:54 -0700
In-Reply-To: <20241003234337.273364-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241003234337.273364-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.0.163.g1226f6d8fa-goog
Message-ID: <173039505052.1508646.12399325550980838662.b4-ty@google.com>
Subject: Re: [PATCH 00/11] KVM: selftests: AVX support + fixes
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Vitaly Kuznetsov <vkuznets@redhat.com>
Content-Type: text/plain; charset="utf-8"

On Thu, 03 Oct 2024 16:43:26 -0700, Sean Christopherson wrote:
> Enable CR4.OSXSAVE and XCR0.AVX by default when creating selftests vCPUs
> in order to play nice with compilers that have been configured to enable
> -march=x86-64-v3 by default.
> 
> While it would be easier to force v2 (or earlier), there are enough tests
> that want XCR0 configured that it will (hopefully) be a net postive to
> enable all XCR0 features by default.
> 
> [...]

Applied to kvm-x86 selftests, minus patch 1 which went into 6.12.  At some point
in the 6.13 cycle I'll send a revert for the "march" madness.

[01/11] KVM: selftests: Fix out-of-bounds reads in CPUID test's array lookups
        (no commit info)
[02/11] KVM: selftests: Precisely mask off dynamic fields in CPUID test
        https://github.com/kvm-x86/linux/commit/c0124e2e74a7
[03/11] KVM: selftests: Mask off OSPKE and OSXSAVE when comparing CPUID entries
        https://github.com/kvm-x86/linux/commit/01e2827157ef
[04/11] KVM: selftests: Rework OSXSAVE CR4=>CPUID test to play nice with AVX insns
        https://github.com/kvm-x86/linux/commit/cf50f01336d3
[05/11] KVM: selftests: Configure XCR0 to max supported value by default
        https://github.com/kvm-x86/linux/commit/331b8ddaebc1
[06/11] KVM: selftests: Verify XCR0 can be "downgraded" and "upgraded"
        https://github.com/kvm-x86/linux/commit/d87b459428c0
[07/11] KVM: selftests: Drop manual CR4.OSXSAVE enabling from CR4/CPUID sync test
        https://github.com/kvm-x86/linux/commit/86502f01b8b9
[08/11] KVM: selftests: Drop manual XCR0 configuration from AMX test
        https://github.com/kvm-x86/linux/commit/fd7b6d77fa6d
[09/11] KVM: selftests: Drop manual XCR0 configuration from state test
        https://github.com/kvm-x86/linux/commit/818646fea3ea
[10/11] KVM: selftests: Drop manual XCR0 configuration from SEV smoke test
        https://github.com/kvm-x86/linux/commit/ce22d24024ea
[11/11] KVM: selftests: Ensure KVM supports AVX for SEV-ES VMSA FPU test
        https://github.com/kvm-x86/linux/commit/08cc7ab1a6ca

--
https://github.com/kvm-x86/linux/tree/next

