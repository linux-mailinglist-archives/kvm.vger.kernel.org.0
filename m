Return-Path: <kvm+bounces-15956-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 286D68B27F4
	for <lists+kvm@lfdr.de>; Thu, 25 Apr 2024 20:14:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DB3DC282566
	for <lists+kvm@lfdr.de>; Thu, 25 Apr 2024 18:14:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 89FC01514F8;
	Thu, 25 Apr 2024 18:14:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="TM46+MNp"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1238214F13A
	for <kvm@vger.kernel.org>; Thu, 25 Apr 2024 18:14:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714068869; cv=none; b=DgJV3Yzj1TL9qMNAHUMTEm4vbnB8lkXzlKFkHISuGOmA4tuiPS4i7CeBc0jSos9Ao7kbMUUWGAJ5E+YHiupBwII+0JxPnjrjhQ2Twaw/Ini71crCdoawlqXE3SibrMTfsYsfwzEngHXN2s4/SIa4vopf+1ynVjH8ROiEbIuuxvw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714068869; c=relaxed/simple;
	bh=4qtbHwEvCmU4KkXm39uticydjRyT5zPpSXFReESlu/k=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=C/ErCaDCBaE+u7pfOvUz8Gg6U0G8m39SW7gWLSkGT8qv3qE4p9OMKR15sWy5Oo6UiE+accCkeWIShNxsccI39fu9dYiwCn0TrITOjwnoO08l7LAvbsRYKzPeYExPlRSa/ZvpNxu7/ZZ41EFqaFJmZ0SZLqwNmkGG3JB2ofwoFqw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=TM46+MNp; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-6ef9edf9910so1749695b3a.1
        for <kvm@vger.kernel.org>; Thu, 25 Apr 2024 11:14:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1714068866; x=1714673666; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DHW/shiisjaeVIVVFJxFalhvGV979k2DmH/wFoxACZs=;
        b=TM46+MNpAnpXiVgLYvj4SsZmCpU9JzAHeNCY1OiaBDeCqK5vWveQ7mB+I7GfsEiF1H
         LIYIjrFuDttoMeaNe7Bu32xqkZvvLI2JmCtB4c1nQeX6kswdL8kNmlQYZ55Ejh63KbuA
         plEV7kCmmYuLqEmUv+6sueCNVe0aRLd7ot4ZqjvbmOduOPLeSsbL3t7bUfDfBnZWGl2g
         eog/eG0XaYLrR5WQODjt9pYdFaY53+UJi8hH7+IUbl9SWH5I24ebMuVEpOv0xv9Sgkm/
         rHbrmkZIoh793GiY6vAo7HHeg0NWhERdpAtOrtaQ3cuXk+Qs/BRk7AQXhq5+sHUubEah
         WCnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714068866; x=1714673666;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DHW/shiisjaeVIVVFJxFalhvGV979k2DmH/wFoxACZs=;
        b=SFCXM3o1N7Czb+R6V13wmCHOip42t0b3vHT27lxNtXolv2FeUiUIg34eZW2wCNs4an
         C7+szuce8Oi3N90bibV6D9GQ+1MjBMzIe3BwJgPe0Ukzgus4iO1pQBSwEB91fNxU00RT
         dRZOum5VR8LdBBCpVOi7OqNdmZIoXeRovRyKxTzgaMKZq4yahKQcoDaU/uS2LoECjhlV
         zBsm0M06Wu/1S8wzw3jTjRBr9W3c8P0IbRC8l4ahlBOZcmdEzzW3Tue4uYi9f/D3DIEw
         JANvcOKaW4AxsFUAQczX/Rhi8gSPPrGnsz/srgogw0JzgwkUYN49IHBxDcuM9fTQBfAk
         i65g==
X-Gm-Message-State: AOJu0YwFpTL+A0nYs+e16WJr768+yxOE9eG09yvGfJCviUUdk3K8M2Zw
	hYGf+qj4Zjiy733Avr14Syf1/KdvvNK252SfyXh+23XuKACJ4dQtesb8Vdye446cI6dF9UwbST8
	+8g==
X-Google-Smtp-Source: AGHT+IHE5EcGnk8IXdZtyOff6mZZ63PsD7aMB2zzV5XGAgckt0XbMFHsOyJIBfcIZEyFT3yCJTGXNP4sex8=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:9286:b0:6ea:be7b:2eda with SMTP id
 jw6-20020a056a00928600b006eabe7b2edamr53555pfb.6.1714068866319; Thu, 25 Apr
 2024 11:14:26 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 25 Apr 2024 11:14:12 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.44.0.769.g3c40516874-goog
Message-ID: <20240425181422.3250947-1-seanjc@google.com>
Subject: [PATCH 00/10] KVM: x86: Clean up MSR access/failure handling
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Tom Lendacky <thomas.lendacky@amd.com>, Weijiang Yang <weijiang.yang@intel.com>
Content-Type: text/plain; charset="UTF-8"

Rework KVM's MSR access handling, and more specific the handling of failures,
to begin the march towards removing host_initiated exemptions for CPUID
checks, e.g. to eventually turn code like this:

		if (!msr_info->host_initiated &&
		    !guest_cpuid_has(vcpu, X86_FEATURE_XSAVES))
			return 1;

into

		if (!guest_cpuid_has(vcpu, X86_FEATURE_XSAVES))
			return KVM_MSR_RET_UNSUPPORTED;

For all intents and purposes, KVM already requires setting guest CPUID before
setting MSRs, as there are multiple MSR flows that simply cannot work if CPUID
isn't in place.

But because KVM's ABI is that userspace is allowed to save/restore MSRs that
are advertised to usersepace regardless of the vCPU CPUID model, KVM has ended
up with code like the above where KVM unconditionally allows host accesses.

The idea here is to funnel all MSR accesses through a single helper so that
KVM can make the "host_initiated" exception in a single location based on
KVM_MSR_RET_UNSUPPORTED, i.e. so that KVM doesn't need one-off checks for every
MSR, which is especially problematic for CET where a Venn diagram is needed to
map CET MSR existence to CPUID feature bits.

This series doesn't actually remove the existing host_initiated checks.  I
*really* wanted to do that here, but removing all the existing checks is
non-trivial and has a high chance of subtly breaking userspace.  I still want
to eventually get there, but it needs to be a slower, more thoughtful process.

For now, the goal is to allow new features to omit the host_initiated checks
without creating a weird userspace ABI, e.g to simplify the aforementioned CET
support.

Sean Christopherson (10):
  KVM: SVM: Disallow guest from changing userspace's MSR_AMD64_DE_CFG
    value
  KVM: x86: Move MSR_TYPE_{R,W,RW} values from VMX to x86, as enums
  KVM: x86: Rename KVM_MSR_RET_INVALID to KVM_MSR_RET_UNSUPPORTED
  KVM: x86: Refactor kvm_x86_ops.get_msr_feature() to avoid
    kvm_msr_entry
  KVM: x86: Rename get_msr_feature() APIs to get_feature_msr()
  KVM: x86: Refactor kvm_get_feature_msr() to avoid struct kvm_msr_entry
  KVM: x86: Funnel all fancy MSR return value handling into a common
    helper
  KVM: x86: Hoist x86.c's global msr_* variables up above
    kvm_do_msr_access()
  KVM: x86: Suppress failures on userspace access to advertised,
    unsupported MSRs
  KVM: x86: Suppress userspace access failures on unsupported,
    "emulated" MSRs

 arch/x86/include/asm/kvm-x86-ops.h |   2 +-
 arch/x86/include/asm/kvm_host.h    |   2 +-
 arch/x86/kvm/svm/svm.c             |  29 +-
 arch/x86/kvm/vmx/main.c            |   2 +-
 arch/x86/kvm/vmx/vmx.c             |   8 +-
 arch/x86/kvm/vmx/vmx.h             |   4 -
 arch/x86/kvm/vmx/x86_ops.h         |   2 +-
 arch/x86/kvm/x86.c                 | 513 ++++++++++++++---------------
 arch/x86/kvm/x86.h                 |  21 +-
 9 files changed, 294 insertions(+), 289 deletions(-)


base-commit: 7b076c6a308ec5bce9fc96e2935443ed228b9148
-- 
2.44.0.769.g3c40516874-goog


