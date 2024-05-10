Return-Path: <kvm+bounces-17187-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B328C8C2716
	for <lists+kvm@lfdr.de>; Fri, 10 May 2024 16:45:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 235842846C8
	for <lists+kvm@lfdr.de>; Fri, 10 May 2024 14:45:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 84E2217106B;
	Fri, 10 May 2024 14:45:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="T/R9ZiRD"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05DCB14B08C
	for <kvm@vger.kernel.org>; Fri, 10 May 2024 14:45:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715352317; cv=none; b=j+lHZt+Siw0Gm/JETsUY1qEvxCTx/m6L70NtbT6elqz5wGV7lS0vIGnXpOk6eHESgBahnQHV48RsGaffkxDrT7Oel/qCOzseeFdGjK5jvPsEKvq2IyLPwwEdqtmG1J7s1LSuwRN6HQSh1eMX8UDuqh0Rv01qUEHZ2/dQL2HUfkI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715352317; c=relaxed/simple;
	bh=kmj44PEzEs1Hc7RYAG2y6Omx6rTiyxtrlA8AzcCTcUs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=EYRmU3dDbftzAPBPDB46K8FvUa26stY/WCQ5rt9JSLNeCbvVboPtsjNEM2fVh21ZIj5dWBmNkQtXCz8pS620//hiCcN7U8uGT0mwZaoLv2f1CN6FxSedTGQfA06Dpbq5h0J8GUbkJeIrKHF033e3NsKRWHTNi7WNUjiBj3jCHJU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=T/R9ZiRD; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1715352315;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=V0JbujFYt/9SItNTEbEiczRuSL3qAb2lZe4U6XNdsCE=;
	b=T/R9ZiRD8cowlEvt6k45zjjee8Kz32Ig6uE04Hl+0adaxC7SEYVRZ9pHV6omzhdCLueWKJ
	5Tr5u9HyopoRvIY/YBvdMI54UffAINO2tR/Fc+LDtxVUeMwEVeCeOlaxa0G4xa1LHr/WpC
	VkRlaK5h061dzpV+hatkQdfPbrK6eH8=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-537-KPZS8ySEMJqTERihKi1k0Q-1; Fri, 10 May 2024 10:44:58 -0400
X-MC-Unique: KPZS8ySEMJqTERihKi1k0Q-1
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-34d9055c7e0so1252902f8f.3
        for <kvm@vger.kernel.org>; Fri, 10 May 2024 07:44:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715352297; x=1715957097;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=V0JbujFYt/9SItNTEbEiczRuSL3qAb2lZe4U6XNdsCE=;
        b=u8yWurAndqBjtZBwXpgiy6DNzcAOlimzZ96aKP3BWXGgBxT00Lpkxc4hw00ql9OAwM
         YKcusp5bpvxHux90fp6zBag4F60takMlHVS4AN4LluHy5Jso57pUElTX23ii5kliJqYj
         UzJ3Ue4djqV2q4nAZ2RCl2iy7YlMSOr9BI440dXsTBYb2Q0cHjgAO9wpkp1qVMWILiQ0
         Y+QuvZn08BkX/Ejh/FRhJA1U30n0uY9KS0r8JTlWP8WZAu284PlvSiOyJCTCT7UOVSWs
         mwj2rl0IYCz3GKyjDOiB1zyf/AXlDFUG+Vp+Yc+rj191Sr9vsrQ5Vq0+fGdbRxCUvHVI
         PmDA==
X-Forwarded-Encrypted: i=1; AJvYcCXsgPd1C2LGoM82Qicdd8GSkNNA7F1g8PBIXc4cfSODXepDErP7RO+dp5qR0q3ePiAB/EqsS+q1nNI0SkG6CpkJxDmw
X-Gm-Message-State: AOJu0YxVNs1mbr5VrB24jE582ySebTg58pelexMAh/wAlLSqCAceji7B
	Th+lOX3HkfqCHlF9MxnWj7J1kC0OPvzz3KhtDMMxrWqiPq+CubhHWOHHA/Uq4rq04KMS46jPO4u
	Q62Ag8fgd9dWcfOGaJz9kb9Mr5rYAkuMIQOqXdVZinNxBo7aZU+DZ540nsflHyR3nkire0sgyrE
	B4bkPFLcKZ+P+2NAyUDtMwFnNp
X-Received: by 2002:a05:6000:1003:b0:33e:7f5c:a75d with SMTP id ffacd0b85a97d-3504a96cca2mr1881552f8f.57.1715352297320;
        Fri, 10 May 2024 07:44:57 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEqPh3msW6mLhD5AYzc7IzmHoZiilZKRmz2o9qQNP3DbnrKVIBIgk/dOAj3od9jdxMGgdFJY8LFNOkvNb4LRmc=
X-Received: by 2002:a05:6000:1003:b0:33e:7f5c:a75d with SMTP id
 ffacd0b85a97d-3504a96cca2mr1881542f8f.57.1715352296757; Fri, 10 May 2024
 07:44:56 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240508150240.225429-1-chenhuacai@loongson.cn>
In-Reply-To: <20240508150240.225429-1-chenhuacai@loongson.cn>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Fri, 10 May 2024 16:44:44 +0200
Message-ID: <CABgObfaivYUYZwmC9p2uwCWTC-hzJc4P_=rK0S244Hjx3X8kvg@mail.gmail.com>
Subject: Re: [GIT PULL] LoongArch KVM changes for v6.10
To: Huacai Chen <chenhuacai@loongson.cn>
Cc: Huacai Chen <chenhuacai@kernel.org>, Tianrui Zhao <zhaotianrui@loongson.cn>, 
	Bibo Mao <maobibo@loongson.cn>, kvm@vger.kernel.org, loongarch@lists.linux.dev, 
	linux-kernel@vger.kernel.org, Xuerui Wang <kernel@xen0n.name>, 
	Jiaxun Yang <jiaxun.yang@flygoat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, May 8, 2024 at 5:11=E2=80=AFPM Huacai Chen <chenhuacai@loongson.cn>=
 wrote:
>
> The following changes since commit dd5a440a31fae6e459c0d6271dddd628255053=
61:
>
>   Linux 6.9-rc7 (2024-05-05 14:06:01 -0700)
>
> are available in the Git repository at:
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/chenhuacai/linux-loongson=
.git tags/loongarch-kvm-6.10
>
> for you to fetch changes up to 7b7e584f90bf670d5c6f2b1fff884bf3b972cad4:
>
>   LoongArch: KVM: Add mmio trace events support (2024-05-06 22:00:47 +080=
0)

Pulled, thanks.

Paolo

> ----------------------------------------------------------------
> LoongArch KVM changes for v6.10
>
> 1. Add ParaVirt IPI support.
> 2. Add software breakpoint support.
> 3. Add mmio trace events support.
>
> ----------------------------------------------------------------
> Bibo Mao (8):
>       LoongArch/smp: Refine some ipi functions on LoongArch platform
>       LoongArch: KVM: Add hypercall instruction emulation
>       LoongArch: KVM: Add cpucfg area for kvm hypervisor
>       LoongArch: KVM: Add vcpu mapping from physical cpuid
>       LoongArch: KVM: Add PV IPI support on host side
>       LoongArch: KVM: Add PV IPI support on guest side
>       LoongArch: KVM: Add software breakpoint support
>       LoongArch: KVM: Add mmio trace events support
>
>  arch/loongarch/Kconfig                          |   9 ++
>  arch/loongarch/include/asm/Kbuild               |   1 -
>  arch/loongarch/include/asm/hardirq.h            |   6 +
>  arch/loongarch/include/asm/inst.h               |   2 +
>  arch/loongarch/include/asm/irq.h                |  11 +-
>  arch/loongarch/include/asm/kvm_host.h           |  33 +++++
>  arch/loongarch/include/asm/kvm_para.h           | 161 ++++++++++++++++++=
++++++
>  arch/loongarch/include/asm/kvm_vcpu.h           |  11 ++
>  arch/loongarch/include/asm/loongarch.h          |  12 ++
>  arch/loongarch/include/asm/paravirt.h           |  30 +++++
>  arch/loongarch/include/asm/paravirt_api_clock.h |   1 +
>  arch/loongarch/include/asm/smp.h                |  22 ++--
>  arch/loongarch/include/uapi/asm/kvm.h           |   4 +
>  arch/loongarch/kernel/Makefile                  |   1 +
>  arch/loongarch/kernel/irq.c                     |  24 +---
>  arch/loongarch/kernel/paravirt.c                | 151 ++++++++++++++++++=
++++
>  arch/loongarch/kernel/perf_event.c              |  14 +--
>  arch/loongarch/kernel/smp.c                     |  52 +++++---
>  arch/loongarch/kernel/time.c                    |  12 +-
>  arch/loongarch/kvm/exit.c                       | 151 ++++++++++++++++++=
+---
>  arch/loongarch/kvm/trace.h                      |  20 ++-
>  arch/loongarch/kvm/vcpu.c                       | 105 +++++++++++++++-
>  arch/loongarch/kvm/vm.c                         |  11 ++
>  23 files changed, 746 insertions(+), 98 deletions(-)
>  create mode 100644 arch/loongarch/include/asm/kvm_para.h
>  create mode 100644 arch/loongarch/include/asm/paravirt.h
>  create mode 100644 arch/loongarch/include/asm/paravirt_api_clock.h
>  create mode 100644 arch/loongarch/kernel/paravirt.c
>


