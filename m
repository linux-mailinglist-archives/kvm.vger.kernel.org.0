Return-Path: <kvm+bounces-39014-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 10B31A42984
	for <lists+kvm@lfdr.de>; Mon, 24 Feb 2025 18:26:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0C5D316E095
	for <lists+kvm@lfdr.de>; Mon, 24 Feb 2025 17:25:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DA5F926562E;
	Mon, 24 Feb 2025 17:24:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="rv0NWgtR"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 978B6264A68
	for <kvm@vger.kernel.org>; Mon, 24 Feb 2025 17:24:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740417889; cv=none; b=DVXSJH6l/cl65k6xpcWnF0hj1B7MN7T42vnTJLv85lpTih0KxoDbyGMf+ugpkbN3X78IKDVhbZLvfOpG8Mb6EFvjIoFnjMVI0ZtNIjBuFsSHto0+rzCFJlP6W0b6f1QyDhVGwkjDOhgeSZCO5+yPewhgK4mji6PB9DZBsavrGnw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740417889; c=relaxed/simple;
	bh=mxIkEFMa7Lh2eLDp32seXE4ThtxwLLswi19WgwUaLqE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=l/2S9CyrC30gQIugR64yc/J7ZJmX8OFT5btMVE5Pj1FPGpfChBYJptPI4zdUwWoDDbPViaTDvQmTJDqh6Gh0bMFb8BUrsyKU72l0gCuH+DQ6aF3gYnPa/zYbIaqePlnEkXFlMtBDFbfItlLHc87VULSbmmIYvbUjjI/PdVJIhp0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=rv0NWgtR; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2fbfa786a1aso15137331a91.3
        for <kvm@vger.kernel.org>; Mon, 24 Feb 2025 09:24:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1740417887; x=1741022687; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=1PdBfy1XyDty3YK21yWwN0BLsrQjynU6cB5mufmGWBQ=;
        b=rv0NWgtR3Bn7xIUmy/XZoTTo5AnbCrMcMFYUkrEgIbq0UPpIhEmusmjuAoF9kirGdR
         dVVCpQ/kvcC0VIwbEx+uFCWQH+XVVc4ggbMMTOxjp7Bzv1UyRcEK+PRFpv2KWaoqeKn+
         I/2j3Hp4pahqr3PfUmJSBJB7KEsf2AGwXZBUl8+/aGk5pKRGsBDBc7pGs8YaVXRDi+ul
         9bF1/LkiEA5YGSXHcb1BYBPIsy/irz4KTrNjWPc6eIbhhExZhRcuxAHlHcD2QrzTPWpJ
         POEo+j5VZyDTKWk7Ire8y/iSunGqb5NNXzgv3l+Qwq0HGPgeR++h0bi93H+I913vy7sn
         Rq5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740417887; x=1741022687;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1PdBfy1XyDty3YK21yWwN0BLsrQjynU6cB5mufmGWBQ=;
        b=OAF33Hiuq73fLZaa3c46f4cB0h0SQ8j//9xk4kGKNm5+xRfOv5/MfWyvukuS6BWU9x
         0aSPxra+8pxQTH1CKynZoXupemjmA2E4mSYOlimlYrdN6NqngqBJsiR+QzDr/tHZrsDG
         5GxK60/OkMib9ZMg9hgm7Yr3U/vsaoXJBXQZaad4Yiza0tD/RQRBeddUdxR1KV1zr9Ly
         Vb80wyxey30fWbW/sMdcyD2djlTek6JFb1A4czP7ueWujUQk9Mk7dqvAXTXP8rO0Qilc
         GV56ATv0HuGPkCnTrBocu7unJ+KHdBBNEgPrMlOrtXt+c8qQbmodAMD8w9HgxIAxYikF
         5jbA==
X-Forwarded-Encrypted: i=1; AJvYcCUvv2Kc2MOLSXFQ3SGck62IZdbDQhAZuu/ZOTPizA785iwpHkms6sUERC2fak1l5snyKQs=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz2XTGPvZy9/TosvJiIU964zSUmIumaoWjAfDe2yjlNmkOSFugS
	teQJxMezEAjTuhFAlq/m7l2CuNxgQxoh1JX5cXwLEK2PSaUDC3oUDteIjjct52GkjfqHBHL41gc
	gnw==
X-Google-Smtp-Source: AGHT+IEoEh7BeRbfHIon+pkvpiqOG7jp2epNSiEMS5ipwtulGA0I813r9iCbN2uXL5IqoDCP9T+gBT/Vp9E=
X-Received: from pjbqx7.prod.google.com ([2002:a17:90b:3e47:b0:2d8:8340:8e46])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90a:da87:b0:2ea:b564:4b31
 with SMTP id 98e67ed59e1d1-2fce78c7871mr21525247a91.19.1740417886854; Mon, 24
 Feb 2025 09:24:46 -0800 (PST)
Date: Mon, 24 Feb 2025 09:23:49 -0800
In-Reply-To: <20240701073010.91417-1-binbin.wu@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240701073010.91417-1-binbin.wu@linux.intel.com>
X-Mailer: git-send-email 2.48.1.601.g30ceb7b040-goog
Message-ID: <174041750505.2351818.7785906527856475366.b4-ty@google.com>
Subject: Re: [kvm-unit-tests PATCH v7 0/5] x86: Add test cases for LAM
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org, 
	Binbin Wu <binbin.wu@linux.intel.com>
Cc: pbonzini@redhat.com, chao.gao@intel.com, robert.hu@linux.intel.com, 
	robert.hoo.linux@gmail.com
Content-Type: text/plain; charset="utf-8"

On Mon, 01 Jul 2024 15:30:05 +0800, Binbin Wu wrote:
> Intel Linear-address masking (LAM) [1], modifies the checking that is applied to
> *64-bit* linear addresses, allowing software to use of the untranslated address
> bits for metadata.
> 
> The patch series add test cases for KVM LAM:
> 
> Patch 1 moves struct invpcid_desc to header file for new test cases.
> Patch 2 makes change to allow setting of CR3 LAM bits in vmlaunch tests.
> Patch 3~5 add test cases for LAM supervisor mode and user mode, including:
> - For supervisor mode
>   CR4.LAM_SUP toggle
>   Memory/MMIO access with tagged pointer
>   INVLPG
>   INVPCID
>   INVVPID (also used to cover VMX instruction VMExit path)
> - For user mode
>   CR3 LAM bits toggle
>   Memory/MMIO access with tagged pointer
> 
> [...]

Applied to kvm-x86 next (and now pulled by Paolo), except for patch 1, as a
previous commit from a different series moved the INVPCID helpers to common code.

Note, I deliberately dropped the "packed" addition.  The storage size may be
implementation specific, but the layout is not.  If the compiler does something
bizarre, e.g. allocates 32 instead of 16 bytes for the union, INVPCID will still
work correctly as the CPU won't be aware that the compiler reserved 16 extra
bytes.

[1/5] x86: Move struct invpcid_desc to processor.h
      (no commit info)
[2/5] x86: Allow setting of CR3 LAM bits if LAM supported
      https://github.com/kvm-x86/kvm-unit-tests/commit/0a6b8b7d601a
[3/5] x86: Add test case for LAM_SUP
      https://github.com/kvm-x86/kvm-unit-tests/commit/14520f8e9709
[4/5] x86: Add test cases for LAM_{U48,U57}
      https://github.com/kvm-x86/kvm-unit-tests/commit/0164d7595c85
[5/5] x86: Add test case for INVVPID with LAM
      https://github.com/kvm-x86/kvm-unit-tests/commit/a33a3ac8db56

--
https://github.com/kvm-x86/kvm-unit-tests/tree/next

