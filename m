Return-Path: <kvm+bounces-38213-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8E4B0A36A1A
	for <lists+kvm@lfdr.de>; Sat, 15 Feb 2025 01:51:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C93857A4FD6
	for <lists+kvm@lfdr.de>; Sat, 15 Feb 2025 00:50:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C22DF13A244;
	Sat, 15 Feb 2025 00:50:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="YdCgtBcd"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CD06EACE
	for <kvm@vger.kernel.org>; Sat, 15 Feb 2025 00:50:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739580653; cv=none; b=Ebc05OFxg0EdSxvoaS41Fd+1y8/MHGCqsf+S9pggHsDnPzjmnCs9oSsf9YZdzFKizzni5U5VlzemLulyizzMIoWrEinxtuu73JK6/U9cPAXheLKnSJP3HXoM9B2M578joGEneqEtoG2m1M6FHBQ18/Mhfq+MVe1g+lC6zZyUqJY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739580653; c=relaxed/simple;
	bh=dnqsjGiZaJAvA2XPJfChrA4I5XEs4RTsHpf3T/NjtVw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=g8PKYA4pTfgN9mg5BQ9L5EI+VlFFbZDjSHwcw1VIkWoTKoB85MeSr027OA0haDkTXVyKG/UZgPLcHu9ypKfo0o0vrip8D34x/ZlHZeG1TocLWIZmS2Y1WK9BQHmyDuAxoRSG502oXQXxq9v/3eI0YLXNjWgiZHtShoFWSlKzz7w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=YdCgtBcd; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2fc1e7efe00so4170650a91.2
        for <kvm@vger.kernel.org>; Fri, 14 Feb 2025 16:50:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1739580651; x=1740185451; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=eNDWUiDg7PKVgEWW032CIy+qBy8SxwYT5s4el7ajobg=;
        b=YdCgtBcdg4MpyYexrwccEQb5zZc72+E6AmKIxwak9t1/zXghXYDq0CcAy+o2ZC8Ye9
         ah2pYLKYZvCRnUgahQGNJfcSFc86uXVARABkpcJwLVGh0QYZMWwn/KTuCmTwJyYiatTg
         IE6ytuz47gDIytaLuMuaHPErX5K1UCSYnSCeSqGuqhaeAsYRofYNp61xQnluoBa8RI+n
         Ag2fR5CTeDl/SURC9wTor6tSRW+pB845PaDiUjRgGjb13+Cac6aA4MZi10/UucWt0PzJ
         DeGGyKESrJBx5V1QMcMcw8c5Z3118wQqBxJ41dlgi9SBtQVvTXuKD0NcGhEiBAl6stOy
         HEYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739580651; x=1740185451;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=eNDWUiDg7PKVgEWW032CIy+qBy8SxwYT5s4el7ajobg=;
        b=k86xUTIIBeWAXFKCnnGxwJ1PN5BsCxRBIeqMFJKsU4zZ/tnt8NIPTkCNViy10LCPyI
         3edfJgF/nKbxYcN4toj2QJ94fWh+hd39v/HfC6+hGcIuRMGU+yFuIQkLvMtKqPE+ep5q
         hAtj6FNcsK4kkKOLeGG1nJ7F7t2rm94ptlf3W48yr80vAF2tTFoKfyP8xD9FkJup3KBw
         2QPuaeHRnRpll+PnseiD9yxXi8cL8yqVE7iFKFmLaZdgT65UZ2Ynsv+zlye4b7bli2ek
         VC6zzuCWeCAGDF5TsRlx708vDAMbiYRCzL535iVvYMeSDcfKNJwEjmUgLJvj9oUCK1OO
         GzmA==
X-Gm-Message-State: AOJu0YyZCRaZ1bYMSt1q0Kg5o9Np6Mke40aka1uvR5kBEI+V9DzxCoAn
	JNa1jm+BRLbi9MpZ2Ko60IxUmaqP2GTSD8Kx7a60W//Yk6A2asEWQZpVMh+Ezup7ngQgPuPHqKQ
	3+A==
X-Google-Smtp-Source: AGHT+IH68vaesX+wCuzZ/Dzwbh6t1VdKpG8BDU9Do5mXpvHPYPUxmzFLhrxBSs5qoUoGVbO5uqxzI5orjH0=
X-Received: from pfbfi6.prod.google.com ([2002:a05:6a00:3986:b0:732:2df9:b513])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:1882:b0:730:957d:a80f
 with SMTP id d2e1a72fcca58-7326177625dmr2632490b3a.2.1739580651144; Fri, 14
 Feb 2025 16:50:51 -0800 (PST)
Date: Fri, 14 Feb 2025 16:50:10 -0800
In-Reply-To: <20250118003454.2619573-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250118003454.2619573-1-seanjc@google.com>
X-Mailer: git-send-email 2.48.1.601.g30ceb7b040-goog
Message-ID: <173958022426.1188943.17908180485363586320.b4-ty@google.com>
Subject: Re: [PATCH v2 0/4] KVM: x86: Hyper-V SEND_IPI fix and partial testcase
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Vitaly Kuznetsov <vkuznets@redhat.com>, 
	Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Dongjie Zou <zoudongjie@huawei.com>
Content-Type: text/plain; charset="utf-8"

On Fri, 17 Jan 2025 16:34:50 -0800, Sean Christopherson wrote:
> Fix a NULL pointer deref due to exposing Hyper-V enlightments to a guest
> without an in-kernel local APIC (found by syzkaller, highly unlikely to
> affect any "real" VMMs).  Expand the Hyper-V CPUID test to verify that KVM
> doesn't incorrectly advertise support.
> 
> v2
>  - Fix the stable@ email.  Hilariously, I was _this_ close to sending this
>    with stable@vger.kernel@kernel.org instead of stable@vger.kernel.org,
>    *after* I wrote this exact blurb about fat-fingering the email a second
>    time.  Thankfully, git send-email told me I was being stupid :-)
>  - Don't free the system-scoped CPUID entries object. [Vitaly]
>  - Collect reviews. [Vitaly]
> 
> [...]

Applied to kvm-x86 fixes, thanks!

[1/4] KVM: x86: Reject Hyper-V's SEND_IPI hypercalls if local APIC isn't in-kernel
      https://github.com/kvm-x86/linux/commit/a8de7f100bb5
[2/4] KVM: selftests: Mark test_hv_cpuid_e2big() static in Hyper-V CPUID test
      https://github.com/kvm-x86/linux/commit/0b6db0dc43ee
[3/4] KVM: selftests: Manage CPUID array in Hyper-V CPUID test's core helper
      https://github.com/kvm-x86/linux/commit/cd5a0c2f0fae
[4/4] KVM: selftests: Add CPUID tests for Hyper-V features that need in-kernel APIC
      https://github.com/kvm-x86/linux/commit/e36454461c5e

--
https://github.com/kvm-x86/linux/tree/next

