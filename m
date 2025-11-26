Return-Path: <kvm+bounces-64626-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9C806C88BF8
	for <lists+kvm@lfdr.de>; Wed, 26 Nov 2025 09:51:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 911973B57E1
	for <lists+kvm@lfdr.de>; Wed, 26 Nov 2025 08:50:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4B2E031A061;
	Wed, 26 Nov 2025 08:50:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="LCj+j8mp";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="qliaPH11"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFAB7315D57
	for <kvm@vger.kernel.org>; Wed, 26 Nov 2025 08:50:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764147022; cv=none; b=HGen7fV1ehHczO7DdaxPLTwCXPAJKVlSe63R4dFCWYucj1MPCf91eIQ1yTxn6GUf7aFzgUtTjHBWKPMkurWPd7hJsPp/hXmNF7rrgksACfvD40TDerGjrlIG7UabHh9SosIKmpe9Rko9OPqreHjZOAjDodw9X9uZAsEtnYJdJjg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764147022; c=relaxed/simple;
	bh=0D8N+8bPZFzRBd8PUJ9XFcz5Gv80p90k94ejgDpN4Ck=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=T5lodXIo9ZZHV+cW07Bjw/IDwqXIh3F9ShqKx/ggrl6TE/FyLPw3kNo0PK+xZWuYMJ8XLP9dIyIPzemN6a5V+TSjE2O/m8XFl3L+MlOzaaPmgC/nbFZLdvlhr/bnA9iPF3xxMJQ4vOAGvi7JbMw9hmbsqWvBWw41u0lO2yBZLi8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=LCj+j8mp; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=qliaPH11; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764147020;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QSGMvjz6N3eOL4IbV0aiD/MYwmvu0sbOSAvUS+CZKFM=;
	b=LCj+j8mpkl4JeZ9qxpozHcVzFMFsSLiW/IRKroKqi3skTBaII+60FHJlwB67vSeOvhV3Cc
	vuXX2kqvFleeWoViv8UIFBk5CGQKZeqMWDXStAKAitw4/lwu4vE+UCFcejR2UxbArlVXAB
	UgMNmrT/zW9FpPkgnZBWiwlKHaknCSM=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-649-mC8S1lYGN9CB3j6M8JZwqg-1; Wed, 26 Nov 2025 03:50:18 -0500
X-MC-Unique: mC8S1lYGN9CB3j6M8JZwqg-1
X-Mimecast-MFC-AGG-ID: mC8S1lYGN9CB3j6M8JZwqg_1764147017
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-429c521cf2aso4585469f8f.3
        for <kvm@vger.kernel.org>; Wed, 26 Nov 2025 00:50:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1764147017; x=1764751817; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QSGMvjz6N3eOL4IbV0aiD/MYwmvu0sbOSAvUS+CZKFM=;
        b=qliaPH11mbKDqTlReSmQnQocAjYPmGUPjUsYpWAgwHt02ymDuMtGeSsJxbcz9NDoDP
         Kkk9J07UmjZBkDmGxCPZVxblXW1EgJMcWkz0S9cULwR+t8oY9vgQ54qlVqabhi2dv+wM
         HPokl8FRTRYwrJ2a746ifGo08DjGiEQsTtrpGcAXEV4RE+fyLY9qyZJXIVKQ+xsRrMnG
         OZjc5AyG+Cgt6mq7+J4vimQ5k/Gw1ShzJzWoDhG8uQqD9E68s5+lTD9FxooCsBJLtWw4
         5bL22kyjT52mUdBfZZND+NjawFlcxvvXNOUxkeO+wImo+cL0M02Pq3PPIlR0UTsBxWFL
         MesA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764147017; x=1764751817;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=QSGMvjz6N3eOL4IbV0aiD/MYwmvu0sbOSAvUS+CZKFM=;
        b=O88Waq+yRww26vpzRyTHYDNwsIVklPaKr/++w/ocC4qgCvKoHP4a0FmeFhHiZz81gy
         NpChJza5pIADW2w0AMBfEegkRDpW83Eyp9ckEMDzlszkOGerWwVb80MnI+pPaEEiM7U0
         2ZTWLuxUJIgAVbGXRvYg88761LzCqJxI8HODzpSBlIwBfUQV3RvP+VsG41IG+xBARACs
         FVY6PUTCY92MjCF5WEUVOK7MFD0UYI997WGBDyo8zHsxIKBREiuBu5A93H2icqFgG9kl
         qtS2dXTBM6SNBRPNf6sr2LD6+lHXbac69XPxTMhiu6o+sPkXQFIpZ/LQ7W+UNzBzq9of
         0StA==
X-Gm-Message-State: AOJu0Yz2xRLWnEOaYU4E/NArlyM4A28ZugKErGxiMoGbKbtZmsH0T1Xi
	Rxzy/JxusVEmzfNmNxXDbRexmkEqcqkz340FTk76eKim/KlKSZFOzyrp/BGWSnMDSH9xFDR/foI
	4I+ELhQ3sm82pjb5Thwi2j8owa7VAaa3F4ltVoWazMywT15hECj4z9g19mcv95GOPtxfsC/9d4I
	Qm3zp8BL/LPXprQbkEyLmGW/N8WesM
X-Gm-Gg: ASbGncsNGYxNXr1RqNol3aFn+TEUb8atm5YA6F2mgXh6c0qpXBu9VthlxwADbX6kMCk
	/n7XUdqk6m+g5TREHievcgioG3KLDuls2ZIXzUm0LFilDU/2gdeys9CC+74ozgjGLVeV0v3MUUm
	aTbVR6o5BxMjDheGRZ2NFPIG22bM85uQ0uG5eiTqfBhErEu58RaVoDaRZ8gJi38rcWMqWYkvem6
	wFE8Tgj38oqO5DlRR+jqU6z63jwi1rAs+lSCgt7NJp6aRodDgipGZKdWQK6jzOq+iH/vb0=
X-Received: by 2002:a5d:64c3:0:b0:42b:3825:2ac8 with SMTP id ffacd0b85a97d-42cc1d23eb5mr20744836f8f.59.1764147017224;
        Wed, 26 Nov 2025 00:50:17 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFUZOutXYCjhp3hN0BU3WZYTS1qmMp0/FR443m+ZOOvHuLUx/YoWgRDiNSel1NzvJqm4A6gtee87urIVBD2Hh0=
X-Received: by 2002:a5d:64c3:0:b0:42b:3825:2ac8 with SMTP id
 ffacd0b85a97d-42cc1d23eb5mr20744803f8f.59.1764147016770; Wed, 26 Nov 2025
 00:50:16 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251126014455.788131-1-seanjc@google.com> <20251126014455.788131-9-seanjc@google.com>
In-Reply-To: <20251126014455.788131-9-seanjc@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Wed, 26 Nov 2025 09:50:04 +0100
X-Gm-Features: AWmQ_bklP-TKN2WMfN5fXIFkOIxGk5hEJEc77LLgn4Qr84d_rx89sFW94U-5nRY
Message-ID: <CABgObfbvYC9mGL8x1JSQwmq7BT9j7gwf11nmHsumOumd4P0abg@mail.gmail.com>
Subject: Re: [GIT PULL] KVM: x86: VMX changes for 6.19
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 26, 2025 at 2:45=E2=80=AFAM Sean Christopherson <seanjc@google.=
com> wrote:
>
> The highlight is EPTP construction cleanup that's worthwhile on its own, =
but
> is also a step toward eliding the EPT flushes that KVM does on pCPU migra=
tion,
> which are especially costly when running nested:
>
> https://lore.kernel.org/all/aJKW9gTeyh0-pvcg@google.com
>
> The following changes since commit 3a8660878839faadb4f1a6dd72c3179c1df567=
87:
>
>   Linux 6.18-rc1 (2025-10-12 13:42:36 -0700)
>
> are available in the Git repository at:
>
>   https://github.com/kvm-x86/linux.git tags/kvm-x86-vmx-6.19
>
> for you to fetch changes up to dfd1572a64c90770a2bddfab9bbb69932217b1da:
>
>   KVM: VMX: Make loaded_vmcs_clear() static in vmx.c (2025-11-11 07:41:16=
 -0800)

Pulled; there was another minor conflict due to the introduction of
kvm_request_l1tf_flush_l1d().

Paolo

> ----------------------------------------------------------------
> KVM VMX changes for 6.19:
>
>  - Use the root role from kvm_mmu_page to construct EPTPs instead of the
>    current vCPU state, partly as worthwhile cleanup, but mostly to pave t=
he
>    way for tracking per-root TLB flushes so that KVM can elide EPT flushe=
s on
>    pCPU migration if KVM has flushed the root at least once.
>
>  - Add a few missing nested consistency checks.
>
>  - Rip out support for doing "early" consistency checks via hardware as t=
he
>    functionality hasn't been used in years and is no longer useful in gen=
eral,
>    and replace it with an off-by-default module param to detected missed
>    consistency checks (i.e. WARN if hardware finds a check that KVM does =
not).
>
>  - Fix a currently-benign bug where KVM would drop the guest's SPEC_CTRL[=
63:32]
>    on VM-Enter.
>
>  - Misc cleanups.
>
> ----------------------------------------------------------------
> Dmytro Maluka (1):
>       KVM: VMX: Remove stale vmx_set_dr6() declaration
>
> Sean Christopherson (10):
>       KVM: VMX: Hoist construct_eptp() "up" in vmx.c
>       KVM: nVMX: Hardcode dummy EPTP used for early nested consistency ch=
ecks
>       KVM: x86/mmu: Move "dummy root" helpers to spte.h
>       KVM: VMX: Use kvm_mmu_page role to construct EPTP, not current vCPU=
 state
>       KVM: nVMX: Add consistency check for TPR_THRESHOLD[31:4]!=3D0 witho=
ut VID
>       KVM: nVMX: Add consistency check for TSC_MULTIPLIER=3D0
>       KVM: nVMX: Stuff vmcs02.TSC_MULTIPLIER early on for nested early ch=
ecks
>       KVM: nVMX: Remove support for "early" consistency checks via hardwa=
re
>       KVM: nVMX: Add an off-by-default module param to WARN on missed con=
sistency checks
>       KVM: VMX: Make loaded_vmcs_clear() static in vmx.c
>
> Thorsten Blum (1):
>       KVM: TDX: Replace kmalloc + copy_from_user with memdup_user in tdx_=
td_init()
>
> Uros Bizjak (1):
>       KVM: VMX: Ensure guest's SPEC_CTRL[63:32] is loaded on VM-Enter
>
> Xin Li (1):
>       KVM: nVMX: Use vcpu instead of vmx->vcpu when vcpu is available
>
>  arch/x86/kvm/mmu/mmu_internal.h |  10 ---
>  arch/x86/kvm/mmu/spte.h         |  10 +++
>  arch/x86/kvm/vmx/nested.c       | 173 ++++++++++++++--------------------=
------
>  arch/x86/kvm/vmx/tdx.c          |  30 +++----
>  arch/x86/kvm/vmx/vmenter.S      |  20 +++--
>  arch/x86/kvm/vmx/vmx.c          |  59 +++++++++-----
>  arch/x86/kvm/vmx/vmx.h          |   2 -
>  arch/x86/kvm/vmx/x86_ops.h      |   1 -
>  8 files changed, 135 insertions(+), 170 deletions(-)
>


