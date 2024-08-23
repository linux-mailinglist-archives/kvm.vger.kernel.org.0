Return-Path: <kvm+bounces-24971-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0B6CC95D9E8
	for <lists+kvm@lfdr.de>; Sat, 24 Aug 2024 01:54:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BA298282EEA
	for <lists+kvm@lfdr.de>; Fri, 23 Aug 2024 23:54:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 19B7D1C93B6;
	Fri, 23 Aug 2024 23:54:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="i887klcm"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CFDC19342B
	for <kvm@vger.kernel.org>; Fri, 23 Aug 2024 23:54:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724457263; cv=none; b=k4HjGO6IqfjSdcg1N8bObT/yT3wiK5pDR2PiyKNJNJ3qodgB37GvWxpfeKQwQABsfwmnQUF9kxNE+bcTEOkUdm1t3TF6mMW939xU9AHf1QH6D96Gz5uniDGUr2Tc4ncaQjHoUADX90G5qMXO3bscqzTBwsPgufp1j3c7JaP70wo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724457263; c=relaxed/simple;
	bh=2zSa10o7LNG1vNLJk1jasYFadD++k1aId/vFi4tZDQ8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=tKyLOK6yRKdhTfF4MNdHnCATCC+OZ7aV8djIqbZOe6ka+x4eJPDIqobc/NbJrH+cE9orYuwj9uhkXowCZdVnpZkJYXrPMGeILIMC0WURKMdyChVyqJmSVJZDexTuNKp6CNbbaR2m7FRsk499Rb+qgbyJy2Lzo9/WXagSp62lkrM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=i887klcm; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-7143597f279so1674545b3a.3
        for <kvm@vger.kernel.org>; Fri, 23 Aug 2024 16:54:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1724457261; x=1725062061; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=z+ptUWEVJ7vFwydKjKF6iodzYw//j/tCD766ZeTneZM=;
        b=i887klcmEqxTyKzVZtt7xDHT5DxUDmISobal65h382NxQaZtJvrfm5E2qSehnvAkU2
         ci58LJInFl9TLmBqs/cCT82FYASoiMND01qigDloKwaST03w6NlnVUqTuGQwCNh/9wPn
         p8mTxac5ExJptKdb+pWqkZfZ2rfS2b/2pzl9x0+U5CK7CBsDkKnwD1uFaDFB0eKvBR+j
         19lEQo+xIjW9DoDXsnIQDB8XGoZC2TY/y1SA+hMQKnGSVKL1Y6oz/It8s+boVmY4hU3k
         suA3AhG5b1lDX+ZVfC+EXJsu/CQ5EkRRxZZnMrMJoF/u3TgE/eFWior0xuFDJSj40upR
         nAHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724457261; x=1725062061;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=z+ptUWEVJ7vFwydKjKF6iodzYw//j/tCD766ZeTneZM=;
        b=CvqOzDYMc26U3pIgxnvjeTtN1efmXkU25sFR+GuWawdRGXEaao9jr/TC3m8vQmmohi
         r7C/bGQH3xPTUifYgmGNdSSwVE5A1Lb2mwHyw0/glCVX0cJqp9CzMwtt/x+XNsI3BoEA
         1j3xhEEMkuDoEyZ/m+YqUtoHEEUkxQmuBxsfyJEg7fb1oNNvgEeKDuS7+SSw5kVFKgrV
         NJHdYG+3Nmun8OZIMmLQWTwFgKbYxo1XlONVS5l6Z7gpxq1h4s+DJhxkV9tOttYTVYGW
         MfeWDe2kVv+ei4+B6t604FfiXx4dEFTga9RTX40UI10GHB/ei8SGJ4kyDUF9wkWgE7ZC
         wleQ==
X-Forwarded-Encrypted: i=1; AJvYcCUFRzvwNeoQ8TpfUcBlzNacei31IW+oRwH+FbGeS/kLcCc2gzjLPw99ZVMg7yDZE/vXlUI=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz2AG5Mkcy0W6qKGkLMC/aei5sSjMYAxnuW6ft4nADrYqw81QS9
	FCrgnoj5r69SSt+5Epl0G/B2dQ69515JyXYSUO1xhHeDvlsKDust3xsFfI9RNiyDDOZM83lQNaE
	AXQ==
X-Google-Smtp-Source: AGHT+IFo1aqBWPHTiEGCtBMtEX/KaZ2o0YhIZs7XzUPk/R5jri04Z31j+2gWfWJwdgQUbg1lPvlFbjxqxXM=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a62:ea14:0:b0:70d:fba:c52b with SMTP id
 d2e1a72fcca58-714458938bdmr12345b3a.3.1724457260956; Fri, 23 Aug 2024
 16:54:20 -0700 (PDT)
Date: Fri, 23 Aug 2024 16:47:49 -0700
In-Reply-To: <20240819062327.3269720-1-tao1.su@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240819062327.3269720-1-tao1.su@linux.intel.com>
X-Mailer: git-send-email 2.46.0.295.g3b9ea8a38a-goog
Message-ID: <172443888675.4129435.1647547075115629747.b4-ty@google.com>
Subject: Re: [PATCH v3] KVM: x86: Advertise AVX10.1 CPUID to userspace
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org, 
	Tao Su <tao1.su@linux.intel.com>
Cc: pbonzini@redhat.com, chao.gao@intel.com, xiaoyao.li@intel.com
Content-Type: text/plain; charset="utf-8"

On Mon, 19 Aug 2024 14:23:27 +0800, Tao Su wrote:
> Advertise AVX10.1 related CPUIDs, i.e. report AVX10 support bit via
> CPUID.(EAX=07H, ECX=01H):EDX[bit 19] and new CPUID leaf 0x24H so that
> guest OS and applications can query the AVX10.1 CPUIDs directly. Intel
> AVX10 represents the first major new vector ISA since the introduction of
> Intel AVX512, which will establish a common, converged vector instruction
> set across all Intel architectures[1].
> 
> [...]

Applied to kvm-x86 misc, with some minor tweaks to the changelog.  Thanks!

[1/1] KVM: x86: Advertise AVX10.1 CPUID to userspace
      https://github.com/kvm-x86/linux/commit/1c450ffef589

--
https://github.com/kvm-x86/linux/tree/next

