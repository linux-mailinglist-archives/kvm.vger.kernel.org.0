Return-Path: <kvm+bounces-11324-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9A56D87563B
	for <lists+kvm@lfdr.de>; Thu,  7 Mar 2024 19:42:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 3B1EBB23AA2
	for <lists+kvm@lfdr.de>; Thu,  7 Mar 2024 18:42:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E6C8E134CDB;
	Thu,  7 Mar 2024 18:42:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="U9lj/t72"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9FB884A2B
	for <kvm@vger.kernel.org>; Thu,  7 Mar 2024 18:42:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709836965; cv=none; b=WRozmR/khrNsaWE2ozDlqzx7mhK99F1EEBj/EX3ESTB+aiEu1toL7MhJ1tXvWOrbPopljfTLbDp6VkCzxIUTacBTQfyzoXT2ynN7JEi41siMP633wYGJEB0eFCjRPPQ2GLShjiLKO4cgY+7iDrquO15RzoJDJnZr47KVDyDAZTk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709836965; c=relaxed/simple;
	bh=EeimF+vLq8VZDlxGUSEjxcLfcouohUEnOKJ+l11c0pU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=nXtYVpEoxBaggYaU9Y86lopm3WJfnNN01NvwofOuIuWEiYZgKJyG40g37fPrw7MFItWpvZh5nSwNVGFPSDycnWgBTzVDxnm3w8osSfnKS2/GWeHjwmD5t3f0IROIInji01AsCHq9YjslYKqP19ZthpbsXhbAsuMNJyaTmNdJFG8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=U9lj/t72; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-dcbfe1a42a4so2219299276.2
        for <kvm@vger.kernel.org>; Thu, 07 Mar 2024 10:42:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1709836962; x=1710441762; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=hFgmTdXht8RiRN/KVF8IUqEEHnA/cyS+egW6ftIJGn0=;
        b=U9lj/t72T2AscbZGYunKTiTtoluy7QmDC4E67NfoI2HJ/5WH4VTNf+sNEBLgYGYzv8
         pG5JQNioYFpKBf191wN4uFdq38tMeGrl4T3rp28sLCnKidKNxOxVZritrAYG1XBHySYg
         B5W95jy1x1Yn+M1FyC2XQRhl2KVXqw3cmNEnvNcfURU6JhVmgwQY3WmffrYOb/LPGZlv
         O1L11CRcCSb/Qj0N0RXKOzj7e/ZFVDHAAAOrtyrJ4QwZXZiAANnC6sq1e6Jb43b+h0Hr
         BQtAZx5KKpmiXWHxuti7uHxuTwjLgcMc24sVFcs1PdjMu1AYoCDdUYYGofF4LmyzjJ6X
         +qLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709836962; x=1710441762;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hFgmTdXht8RiRN/KVF8IUqEEHnA/cyS+egW6ftIJGn0=;
        b=q4jQQHEn6Pjw+XdF4j7qzDoB6NJ/5scWM7Pa3vmAaW1ZWzknAozmNr4C91vTtaN2f1
         R5Xv3U+OkQLK2RjG1h3VkAyUdet42YX0ElE1NT0p+YSkdFgL0iU6mkJITsmKVtZphtYI
         nyCeCq7d0I86aFdby4RK8gio8ZF5PTyV8VWK5p80z/AITCnT6lPpPplLaDbWUOh59Zlq
         VQZGfknJ/BiFJcdgr8fxqAqGBgzNAcF/HArdABpn7khCYFwpc+MiNntyraRvndGN9LGQ
         1TQO2RD/bRGTawMBC9UwM5xYsaTs55i2Q8jzLxg9vWoKlbqCrvub6DT+66Eg8HDsfBfZ
         EqGQ==
X-Forwarded-Encrypted: i=1; AJvYcCWozE46c8J59JsnRzJ2G9NayJoVvMWfbNflXfhhr/lH+/GWv0Mpne4xJ4RtCFNM8iQf1aJCNyW15Tvw+T1/k5tUzpXF
X-Gm-Message-State: AOJu0YzeD7Ny/5QYAwxdyb5hh/pWhX02YbKiyUB7UVBdlNbuUYw3+g7f
	XToQ+4Z4KxUDlozWFj1AsMlUqvPX5/B37rOeXbOYCpdSL5r+2S3aomiJ09lbYbjv2aZtLnKynjT
	rbg==
X-Google-Smtp-Source: AGHT+IEAIaa6GjaeMCS4TAxKH9WLPDUDdEha+hFl+ev2/L17coDhI1aC2M0Y5txm8jNusXgQGhlZwSml4BI=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:1004:b0:dc2:3441:897f with SMTP id
 w4-20020a056902100400b00dc23441897fmr4576367ybt.6.1709836962743; Thu, 07 Mar
 2024 10:42:42 -0800 (PST)
Date: Thu, 7 Mar 2024 10:42:41 -0800
In-Reply-To: <Zen8qGzVpaOB_vKa@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <CAAhSdy1rYFoYjCRWTPouiT=tiN26Z_v3Y36K2MyDrcCkRs1Luw@mail.gmail.com>
 <Zen8qGzVpaOB_vKa@google.com>
Message-ID: <ZeoKoUJlCZMiwPXB@google.com>
Subject: Re: [GIT PULL] KVM/riscv changes for 6.9
From: Sean Christopherson <seanjc@google.com>
To: Anup Patel <anup@brainfault.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Palmer Dabbelt <palmer@rivosinc.com>, Andrew Jones <ajones@ventanamicro.com>, 
	Atish Patra <atishp@atishpatra.org>, Atish Patra <atishp@rivosinc.com>, 
	KVM General <kvm@vger.kernel.org>, 
	"open list:KERNEL VIRTUAL MACHINE FOR RISC-V (KVM/riscv)" <kvm-riscv@lists.infradead.org>, 
	linux-riscv <linux-riscv@lists.infradead.org>
Content-Type: text/plain; charset="us-ascii"

On Thu, Mar 07, 2024, Sean Christopherson wrote:
> On Thu, Mar 07, 2024, Anup Patel wrote:
> > ----------------------------------------------------------------
> > KVM/riscv changes for 6.9
> > 
> > - Exception and interrupt handling for selftests
> > - Sstc (aka arch_timer) selftest
> > - Forward seed CSR access to KVM userspace
> > - Ztso extension support for Guest/VM
> > - Zacas extension support for Guest/VM
> > 
> > ----------------------------------------------------------------
> > Anup Patel (5):
> >       RISC-V: KVM: Forward SEED CSR access to user space
> >       RISC-V: KVM: Allow Ztso extension for Guest/VM
> >       KVM: riscv: selftests: Add Ztso extension to get-reg-list test
> >       RISC-V: KVM: Allow Zacas extension for Guest/VM
> >       KVM: riscv: selftests: Add Zacas extension to get-reg-list test
> > 
> > Haibo Xu (11):
> >       KVM: arm64: selftests: Data type cleanup for arch_timer test
> >       KVM: arm64: selftests: Enable tuning of error margin in arch_timer test
> >       KVM: arm64: selftests: Split arch_timer test code
> >       KVM: selftests: Add CONFIG_64BIT definition for the build
> >       tools: riscv: Add header file csr.h
> >       tools: riscv: Add header file vdso/processor.h
> >       KVM: riscv: selftests: Switch to use macro from csr.h
> >       KVM: riscv: selftests: Add exception handling support
> >       KVM: riscv: selftests: Add guest helper to get vcpu id
> 
> Uh, what's going on with this series?  Many of these were committed *yesterday*,
> but you sent a mail on February 12th[1] saying these were queued.  That's quite
> the lag.

...

> And again, this showing up _so_ late means it's unnecessarily difficult to clean
> things up.  Which is kinda the whole point of getting thing into linux-next, so
> that folks that weren't involved in the original patch/series can react if there
> is a hiccup/problem/oddity.

Case in point (I pinky-swear I didn't see the patch before sending the first mail):

https://lore.kernel.org/all/20240307081951.1954830-1-colin.i.king@gmail.com

