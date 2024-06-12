Return-Path: <kvm+bounces-19377-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id CDE2F904853
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2024 03:22:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 584851F240EA
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2024 01:22:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AD5848820;
	Wed, 12 Jun 2024 01:21:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="dgokbjKk"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 804D8CA7A
	for <kvm@vger.kernel.org>; Wed, 12 Jun 2024 01:21:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718155303; cv=none; b=IjJVlTEuVtCm9ska/tf8IS8sh2/PmimpWvuiUlDDsbY9DP4psg5SpMuW0FAxjpZ02f8Hp87L03i8XOBZTgp+yUuVbfwdmiM4maRX5brCjo4pmEJ2YhHRVNwdNA7UhNkljm214B+7hryU2PM6y2+dUTOt1uv1+pS9tRHlrUgnJqk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718155303; c=relaxed/simple;
	bh=GlapdDKhTIPCCJP/VkWHjj68tVw41md0iGY6n3ryj0A=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=kovfQMQLJIAz9cb+r6qJ3kerMkNFy2a1XDn7Y8zMi1hJ8Ka4gsM1GJRgGc8EIPsTTBd2FUMFdh/gPAaM1xp3mL+uDhQwr2+A3Vh4vDMxQcFPsZuWG+bx8Zj7Dgai5PCNjasw+X8W0h9IYG7VZYPka8gpP+Bplx3WO7YNLlqs+gc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=dgokbjKk; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-dfa84f6a603so10520327276.3
        for <kvm@vger.kernel.org>; Tue, 11 Jun 2024 18:21:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1718155301; x=1718760101; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=949Sco2VRHaNtzMxd2fbftK/o32Oz5QH2yGUJXRf1kk=;
        b=dgokbjKkIQ6Lm4zfYBCgheAKFvMp2cLnqTVO4RDa32JkAVCYkW+wXDbg/xIIK9Flp5
         ZC0VClD+tip33nOL46K4kf3mCTVmJk7x92By8aNQH99Vt12YA5LEepjdsko4Yhi1VTnB
         fozhe5emdudhOBxMOPekPMXki4PNJW14b8uGaUV5ye61sD8sy7lj+4Q06s8w3eFBEgtN
         l/xPHdkhvpJBJ678NAFzjhfwUEET0SBg8PJ89OHUBvvpfo9AsYqzgnh7B2BFd/LtrgWL
         syJO9NGsNkWSlhOWMZ+5SVJBjr627DcCFRJMZmSIaFz1ver8aAwixET45MbJ1clDMWlN
         a/wQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718155301; x=1718760101;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=949Sco2VRHaNtzMxd2fbftK/o32Oz5QH2yGUJXRf1kk=;
        b=gTiTQvW/it1STaYH09Gr2lcXkPdzKi6wv2a53w+F3ifqJPipqEm4Hp1Mow2rbJPh5J
         SmFP2lefm63EQAB8O5k0V3ntbFC+1etSBRbRF7Z991T9lVYwOdrqNCoRgMBTq+HTpHEy
         QbEmuKhWLLWrXvsynJgsh+xlN03EIcD5letACKT2Oft7yDnl3REiahmt1bSSim5QimZp
         WZKEBpt6wurNGXtX92vtOh1Z63bINbcTMB/JZniObokL56N9VEReo6ERGTXBV651Xhcw
         LEX72yZqRDJY+MPZD9ICxsgHEzMEuBi2tUY7TiepkhGk5Dc+WMuX5djYpqdqvZEtjRfe
         Jo8g==
X-Forwarded-Encrypted: i=1; AJvYcCWgSW83SV0XrEi90kJj89XpWU82XBqXXzgsIoXywy+8hDmrcozB8UAJbA8N2RkWmPQ9wHWNCuxs+84DEt5YJMReL6Cb
X-Gm-Message-State: AOJu0Yy2ljBFsyWWDnL/LlSXJPWrEKwhY8FElmVCEhSgc3kYrNMVd02C
	o+rlwYd8INZHtD7LjuRPWVn5SCEkctFra8Vq+8zHkf3XjIpJ5RIg3POYmEUtdblSmCgaQRvYiz1
	rug==
X-Google-Smtp-Source: AGHT+IEV7dvCZCTRpJ744rvbmMY7/LY4nMjTd6+1Xr4TaQMCK/If60QDgbv1vmQQIQ6r1mtLOEulyXxkmDQ=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:c12:b0:dfb:210f:3ad2 with SMTP id
 3f1490d57ef6-dfe65f78d94mr29693276.2.1718155301449; Tue, 11 Jun 2024 18:21:41
 -0700 (PDT)
Date: Tue, 11 Jun 2024 18:18:36 -0700
In-Reply-To: <20240508132502.184428-1-julian.stecklina@cyberus-technology.de>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240508132502.184428-1-julian.stecklina@cyberus-technology.de>
X-Mailer: git-send-email 2.45.2.505.gda0bf45e8d-goog
Message-ID: <171814098169.327928.5071447429899645642.b4-ty@google.com>
Subject: Re: [PATCH] KVM: x86: add KVM_RUN_X86_GUEST_MODE kvm_run flag
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Jonathan Corbet <corbet@lwn.net>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Julian Stecklina <julian.stecklina@cyberus-technology.de>
Cc: Thomas Prescher <thomas.prescher@cyberus-technology.de>, kvm@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"

On Wed, 08 May 2024 15:25:01 +0200, Julian Stecklina wrote:
> When a vCPU is interrupted by a signal while running a nested guest,
> KVM will exit to userspace with L2 state. However, userspace has no
> way to know whether it sees L1 or L2 state (besides calling
> KVM_GET_STATS_FD, which does not have a stable ABI).
> 
> This causes multiple problems:
> 
> [...]

Applied to kvm-x86 misc.  Note, the capability got number 237, as 236 was
claimed by KVM_CAP_X86_APIC_BUS_CYCLES_NS.  The number might also change again,
e.g. if a different arch adds a capability and x86 loses the race.

Thanks!

[1/1] KVM: x86: add KVM_RUN_X86_GUEST_MODE kvm_run flag
      https://github.com/kvm-x86/linux/commit/85542adb65ec

--
https://github.com/kvm-x86/linux/tree/next

