Return-Path: <kvm+bounces-34649-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 81219A03431
	for <lists+kvm@lfdr.de>; Tue,  7 Jan 2025 01:53:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5DF2E163907
	for <lists+kvm@lfdr.de>; Tue,  7 Jan 2025 00:53:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B54026A33B;
	Tue,  7 Jan 2025 00:53:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WjYSN5f+"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B205F1CAA4
	for <kvm@vger.kernel.org>; Tue,  7 Jan 2025 00:53:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736211200; cv=none; b=f1Gut0tsoHY4mVw58HVejW+qcRq5iSIlagr/U4UcEEPG1ZEwB17XccebOFp45pmJwxWVngB6Ikz/dKwUOBZV0oXRUfcRkmS658tnO6zfLZioqWFUsBBGLK2K85rN4QDyOVZEEVP8sdq/oPBIx6EXS3e/do/n6euX4TWH9Q61UEg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736211200; c=relaxed/simple;
	bh=c3Gsli1t6Qs5m45O8lq5F4Uh3ZhkcWazXHBcYZPmIQg=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Ejeb7tfcS3t6RIqJdMjJ7APvI3xBjHX5QWbuWuIaW8RsF7DHkAGU+9vDkOuE9o2EDC6uJB8/FkcfIWFsCOZE9g7lwFaGvmDzJ9icCV/ldvjTKnthQeVRRsTomyKj6I+BHDf8jDeV/XcWuDOm7/6Zln7M8FWQTlKiM5uSFBTUCrE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=WjYSN5f+; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1736211195;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CtbBZcEWixSx8WxKTGxxVe9YGJddjHivheFuJ/OEl4U=;
	b=WjYSN5f+y7bmupS5LASENbcmq6uWr1zwhaNHqTOWPRjvciYxq+TP+VhRGI/rZf4sxTPp38
	4vU8OngTRcn88F4AKwhLReMNOQy8X17IxqM72466Rdcv4A+JVubJrk79nId6eRmSN4hk+L
	HcD3MhWH+JGk0SHXeLzbxpH/CgUp/GU=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-266-kUlRJl_aMkS6r9SrUZ-nIw-1; Mon, 06 Jan 2025 19:53:13 -0500
X-MC-Unique: kUlRJl_aMkS6r9SrUZ-nIw-1
X-Mimecast-MFC-AGG-ID: kUlRJl_aMkS6r9SrUZ-nIw
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-7b6ecd22efbso2965641785a.0
        for <kvm@vger.kernel.org>; Mon, 06 Jan 2025 16:53:13 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736211193; x=1736815993;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=CtbBZcEWixSx8WxKTGxxVe9YGJddjHivheFuJ/OEl4U=;
        b=mSe0SiACsUR0QnJd4U7z6S9RAQDL0u07wIlvhuV5MFvUjQdI01dzXEuabandGdiWbk
         YI3M1QE+U1VSMn7e3iyCVbSQssF74OSI1OfgT6JwUESK2pHgkLOgTd42wLW+cXpWwK6p
         j3Ey/AgPKJh6i/lz3OqxT13V7qcjHRAW/v9YvZiyl3V4H5EpJmjKTurttIy97nQP7L3l
         uOsmhu3jRQYAaq2F5tjK/zlXdtMgiU6ifxBCWoIu0/hEJ+dIGezsW8CWmSacWdvY0Aya
         7orbJR/gJx0mLbxEJUSHtbonJTdyJKRW0LiGmuU5J4ckKi+MkN6ip8XZHGo/bP0qIcsm
         1Hhw==
X-Forwarded-Encrypted: i=1; AJvYcCWBO5NIDTJqEdS4n16OkkbaoTmXKMcHLQ/Im5VBmABatTHHUDPeeQx+dd2al4m2LDDAbTk=@vger.kernel.org
X-Gm-Message-State: AOJu0YxCEr1lXosvjQz7kD0sG5U62sUX8I+nKscwK22EZogLTonQFmIw
	uYZc1JE+vJ1dhhtFbg/z2e0mvxN5WOvn/vsZxVmiTxkJey3fcROu5u+KKDKAq9e4xwe0NV2wgw3
	04peHmQGwc4mCo91xz6vAyx+3LZweWwrwIWt1H6uacyT6Xxqxrw==
X-Gm-Gg: ASbGncvm8JRhQdjHYEuGvXFd3sJggo4mNuThIGYV+hbnvTHVjX9FpBFk9MHy0TarHgJ
	Dgkkh4lmj/EwMZdL+ng1tGri25GYgp4rjdcRw122szrTGLTEG6NNLzlJrE3JLRazRnhAOIGe+dm
	TxSRYni36u7cLs7l2KO4dORkB/xsV5dY6OJab5pFAPgJWgFdwTp7RMUNCcu3CT0I4JEh1YG+a+P
	Uf+SZ51UJLap6vHkWtNMnjv5hsNhtAxz4KCu5TO12EBzYDwkL7ZKvCNWoT17LB+JUkr70bER00K
	qMSA9zkTp17txSADJN4wQK/3guEoYPtK16ZnDQmKt3rWBA==
X-Received: by 2002:a05:620a:4391:b0:7b1:5545:7104 with SMTP id af79cd13be357-7bb90248f5emr233294685a.2.1736211193458;
        Mon, 06 Jan 2025 16:53:13 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGH3zXukWoOxxE9GTC98eC7YuZVzhkxHUhqQrhYMYf+Tp1nGh3nJP16xZ6Vg5mME8zl35azTw==
X-Received: by 2002:a05:620a:4391:b0:7b1:5545:7104 with SMTP id af79cd13be357-7bb90248f5emr233291885a.2.1736211193119;
        Mon, 06 Jan 2025 16:53:13 -0800 (PST)
Received: from crwood-thinkpadp16vgen1.minnmso.csb (syn-050-074-019-099.biz.spectrum.com. [50.74.19.99])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7b9ac4cd95fsm1549579385a.103.2025.01.06.16.53.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Jan 2025 16:53:12 -0800 (PST)
Message-ID: <e7972ba881ed8c0ed8c82379c4e9a2e88cd94ceb.camel@redhat.com>
Subject: Re: [PATCH v2 3/5] powerpc: kvm: drop 32-bit booke
From: Crystal Wood <crwood@redhat.com>
To: Arnd Bergmann <arnd@kernel.org>, kvm@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, Thomas Bogendoerfer
 <tsbogend@alpha.franken.de>, Huacai Chen <chenhuacai@kernel.org>, Jiaxun
 Yang <jiaxun.yang@flygoat.com>, Michael Ellerman <mpe@ellerman.id.au>,
 Nicholas Piggin <npiggin@gmail.com>, Christophe Leroy
 <christophe.leroy@csgroup.eu>, Naveen N Rao <naveen@kernel.org>, Madhavan
 Srinivasan <maddy@linux.ibm.com>, Alexander Graf <graf@amazon.com>, Anup
 Patel <anup@brainfault.org>, Atish Patra <atishp@atishpatra.org>, Paul
 Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>,
 Albert Ou <aou@eecs.berkeley.edu>, Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Dave Hansen
 <dave.hansen@linux.intel.com>, x86@kernel.org, "H. Peter Anvin"
 <hpa@zytor.com>, Vitaly Kuznetsov <vkuznets@redhat.com>, David Woodhouse
 <dwmw2@infradead.org>, Paul Durrant <paul@xen.org>, Marc Zyngier
 <maz@kernel.org>,  "A. Wilcox" <AWilcox@Wilcox-Tech.com>,
 linux-kernel@vger.kernel.org, linux-mips@vger.kernel.org, 
 linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org, 
 linux-riscv@lists.infradead.org
Date: Mon, 06 Jan 2025 19:53:11 -0500
In-Reply-To: <20241221214223.3046298-4-arnd@kernel.org>
References: <20241221214223.3046298-1-arnd@kernel.org>
	 <20241221214223.3046298-4-arnd@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.4 (3.52.4-2.fc40) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Sat, 2024-12-21 at 22:42 +0100, Arnd Bergmann wrote:
> From: Arnd Bergmann <arnd@arndb.de>
>=20
> KVM on PowerPC BookE was introduced in 2008 and supported IBM 44x,
> Freescale e500v2 (32-bit mpc85xx, QuorIQ P1/P2), e500mc (32bit QorIQ
> P2/P3/P4), e5500 (64-bit QorIQ P5/T1) and e6500 (64-bit QorIQ T2/T4).
>=20
> Support for 44x was dropped in 2014 as it was seeing very little use,
> but e500v2 and e500mc are still supported as most of the code is shared
> with the 64-bit e5500/e6500 implementation.
>=20
> The last of those 32-bit chips were introduced in 2010 but not widely
> adopted when the following 64-bit PowerPC and Arm variants ended up
> being more successful.
>=20
> The 64-bit e5500/e6500 are still known to be used with KVM, but I could
> not find any evidence of continued use of the 32-bit ones, so drop
> discontinue those in order to simplify the implementation.
> The changes are purely mechanical, dropping all #ifdef checks for
> CONFIG_64BIT, CONFIG_KVM_E500V2, CONFIG_KVM_E500MC, CONFIG_KVM_BOOKE_HV,
> CONFIG_PPC_85xx, CONFIG_PPC_FPU, CONFIG_SPE and CONFIG_SPE_POSSIBLE,
> which are all known on e5500/e6500.
>=20
> Support for 64-bit hosts remains unchanged, for both 32-bit and
> 64-bit guests.
>=20
> Link: https://lore.kernel.org/lkml/Z1B1phcpbiYWLgCD@google.com/
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  arch/powerpc/include/asm/kvm_book3s_32.h    |  36 --
>  arch/powerpc/include/asm/kvm_booke.h        |   4 -
>  arch/powerpc/include/asm/kvm_booke_hv_asm.h |   2 -
>  arch/powerpc/kernel/head_85xx.S             |  14 -
>  arch/powerpc/kernel/head_booke.h            |  39 --
>  arch/powerpc/kvm/Kconfig                    |  22 +-
>  arch/powerpc/kvm/Makefile                   |  15 -
>  arch/powerpc/kvm/book3s_32_mmu_host.c       | 396 --------------

Why are book3s files removed by this patch?

> @@ -228,23 +176,16 @@ static inline void kvmppc_save_guest_altivec(struct=
 kvm_vcpu *vcpu)
>  static void kvmppc_vcpu_sync_debug(struct kvm_vcpu *vcpu)
>  {
>  	/* Synchronize guest's desire to get debug interrupts into shadow MSR *=
/
> -#ifndef CONFIG_KVM_BOOKE_HV
>  	vcpu->arch.shadow_msr &=3D ~MSR_DE;
>  	vcpu->arch.shadow_msr |=3D vcpu->arch.shared->msr & MSR_DE;
> -#endif

This is an ifndef... the contents should be removed.

-Crystal


