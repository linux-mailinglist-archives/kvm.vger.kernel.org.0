Return-Path: <kvm+bounces-7889-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 77763847DA8
	for <lists+kvm@lfdr.de>; Sat,  3 Feb 2024 01:15:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9CB7F1C21970
	for <lists+kvm@lfdr.de>; Sat,  3 Feb 2024 00:15:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 54C4C10A18;
	Sat,  3 Feb 2024 00:13:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="m0ZcI6mv"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27A9A10782
	for <kvm@vger.kernel.org>; Sat,  3 Feb 2024 00:13:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706919207; cv=none; b=YKT0GL/DxRxru8ZBye3xInCd293sFka6ttUOwd4d+SYlisu+BwIHT585pIRpdOAe6Ci34hCsHcLS8jFygl56GxsGPNqSR0Pe8tByncR3yaEECCqBQKcrDhphAEJOOB1mqvSp2EO3N7AGxpvwXYFGPB3zNAFQtDtT8sShH6YIffc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706919207; c=relaxed/simple;
	bh=0UHnjpZa0/n5Wch+Vjh3VbZabsU3SfAQTGXXdQqFuNI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Nnsna1uG+K8MPCQj0Npt0Wlq2sRFbdx5CStavswxDUkXg6DkBVT+dbuyb5ath4HSBzOs/awE48xV7KRXMRhxYd/DVRsMFwL6QJHixdaK2iA+VwExqX5aGdihV/dZ7Nk0WVme6nWYmWvJmBoXqu2KCge94on+Qijo/z444h8/T/4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=m0ZcI6mv; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-1d97eb98e1cso6265735ad.2
        for <kvm@vger.kernel.org>; Fri, 02 Feb 2024 16:13:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1706919205; x=1707524005; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=UblZcdIbFFW166FC0SJ65RVKv7Yp//8SVMLiUJZhHNc=;
        b=m0ZcI6mvrHlUQFmb3ztP/G/TtsHgSQ+WvOutvtpTsvEQnsJOqv/X7A6XRvzHaD519w
         7CUUkPGKHh65Zb26rYu4oa3p8jnA2VQ3oGvpgplmGGI50yh+dh0Cze5oAqxPmK/pcDCp
         i86zGNWluErHezEEka48bl3WHghHxX57SdJpdU/nepyQbF4qzK7vBmOTHKo0F02u6si6
         J0WYWMjMJd0tKtWMey/IRPUGlwzEdF19XyRWajPdLmvAFGuy3gyEq/E7A/hJvJjsZWQL
         1bQD4yccVYP+91is715oWDVSKYSyxfQCwqODdXXkzrxR2HA6sppvZegc1B++1KTq71hr
         G9LQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706919205; x=1707524005;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UblZcdIbFFW166FC0SJ65RVKv7Yp//8SVMLiUJZhHNc=;
        b=FPS4Q0Cj7tbe/3ABp8INc8wr0n20o+oZKg4piEkzB1bgxoOXCTtqG8q4xGC7/k+Lbv
         NFleRadstvPwmPgAKku5wFvKjbPY1jYTDJ16RLHbFQMN1Wve/ZpN/ISeUqgDQ6vDuz/4
         Y8ub/fbA6sCtavfdoCJhKq2xMvKveomlM4fUjTlv+pMrDIGFYXq66e9yBUj12+iWC101
         Pjj2SXBwGRfhg+NvOANM8QBLSPoxv5hn5s9LmXp/COY3Ylt3E+uolNFvexQLBW5/YoI/
         FJOwfFIFreAY25NL05wk+JVe/2BN55Cj2Tao/zsX8kmm9nw92hBOo1o1Qo6PizNLm/kT
         FIfg==
X-Gm-Message-State: AOJu0Yzeg1OI0utYDY+zyK12dkmN10SXcQOnblJlx2rcPpIwPM77Mn0w
	7Zk0Nvo5zGV2EfJ1IovYqmsd26ODxbm5eikL1q4x/sNoFhJjdgwKjQno9yyvJObzG8lzVvSfKtu
	HpQ==
X-Google-Smtp-Source: AGHT+IEpA02eLXo5kivTLKOG0egFzivasL8l5/x4YkqvERVRNd7PfchGE4aayftMm/hGrKG0zH0YT9yO09A=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:c1cb:b0:1d9:8bb4:6c2b with SMTP id
 c11-20020a170902c1cb00b001d98bb46c2bmr27573plc.12.1706919205410; Fri, 02 Feb
 2024 16:13:25 -0800 (PST)
Date: Fri,  2 Feb 2024 16:11:35 -0800
In-Reply-To: <20231110022857.1273836-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231110022857.1273836-1-seanjc@google.com>
X-Mailer: git-send-email 2.43.0.594.gd9cf4e227d-goog
Message-ID: <170691189173.332407.7692729833772898167.b4-ty@google.com>
Subject: Re: [PATCH 00/10] KVM: x86/pmu: Optimize triggering of emulated events
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Konstantin Khorenko <khorenko@virtuozzo.com>, Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="utf-8"

On Thu, 09 Nov 2023 18:28:47 -0800, Sean Christopherson wrote:
> Optimize code used by, or which impacts, kvm_pmu_trigger_event() to try
> and make a dent in the overhead of emulating PMU events in software, which
> is quite noticeable due to it kicking in anytime the guest has a vPMU and
> KVM is skipping an instruction.
> 
> Note, Jim has a proposal/idea[*] (that I supported) to make
> kvm_pmu_trigger_event() even more performant.  I opted not to do that as
> it's a bit more invasive, and I started chewing on this not so much because
> I care _that_ much about performance, but because it irritates me that the
> PMU code makes things way harder than they need to be.
> 
> [...]

Applied to kvm-x86 pmu, thanks!

[01/10] KVM: x86/pmu: Zero out PMU metadata on AMD if PMU is disabled
        https://github.com/kvm-x86/linux/commit/f933b88e2015
[02/10] KVM: x86/pmu: Add common define to capture fixed counters offset
        https://github.com/kvm-x86/linux/commit/be6b067dae15
[03/10] KVM: x86/pmu: Move pmc_idx => pmc translation helper to common code
        https://github.com/kvm-x86/linux/commit/b31880ca2f41
[04/10] KVM: x86/pmu: Snapshot and clear reprogramming bitmap before reprogramming
        https://github.com/kvm-x86/linux/commit/004a0aa56ede
[05/10] KVM: x86/pmu: Add macros to iterate over all PMCs given a bitmap
        https://github.com/kvm-x86/linux/commit/e5a65d4f723a
[06/10] KVM: x86/pmu: Process only enabled PMCs when emulating events in software
        https://github.com/kvm-x86/linux/commit/d2b321ea9380
[07/10] KVM: x86/pmu: Snapshot event selectors that KVM emulates in software
        https://github.com/kvm-x86/linux/commit/f19063b1ca05
[08/10] KVM: x86/pmu: Expand the comment about what bits are check emulating events
        https://github.com/kvm-x86/linux/commit/afda2d7666f8
[09/10] KVM: x86/pmu: Check eventsel first when emulating (branch) insns retired
        https://github.com/kvm-x86/linux/commit/e35529fb4ac9
[10/10] KVM: x86/pmu: Avoid CPL lookup if PMC enabline for USER and KERNEL is the same
        https://github.com/kvm-x86/linux/commit/83bdfe04c968

--
https://github.com/kvm-x86/linux/tree/next

