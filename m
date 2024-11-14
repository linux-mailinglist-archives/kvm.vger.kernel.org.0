Return-Path: <kvm+bounces-31904-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7819B9C9678
	for <lists+kvm@lfdr.de>; Fri, 15 Nov 2024 00:53:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 23F1D283804
	for <lists+kvm@lfdr.de>; Thu, 14 Nov 2024 23:53:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 16CB71B3930;
	Thu, 14 Nov 2024 23:53:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JP7UpWZy"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87D5E1AAE33
	for <kvm@vger.kernel.org>; Thu, 14 Nov 2024 23:53:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731628399; cv=none; b=PS4oXF0abZn2Pvp8DlAGY6Rus19L/uFKU90aTpw2zVy9B4uSTuaPgnZblEwfRwP+LW3Bqtk37iZ5gJxnRaioe6X+UW80rvGW3lGa4k0zZ10CYUA9ZrgTunw4k31a9OKGR0te+AU09oP5aTq5CBiLGHTmYp5u4fnd6Hm3AzQ7irU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731628399; c=relaxed/simple;
	bh=/ICuXM+GV6dBITrJIBgI7/tWym7FEU0Fxzozxfuppnc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=mj+LHu53KSYNxY71BYnKzq4CtQAZwRfX6AnMaFxi4LpChZwB6mTJq16KovAzbh/gCXlO6rcZSZdWx8ixPTrMQKjEAiinxYASbbtFS06Pp+Oq6h1guiUhFldWYg98id96P3AgffosERAsPY2vTlis8HanQP2eKNsrwtEWY8F/TLA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=JP7UpWZy; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1731628396;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rECe5FJajV/VYN0/GaapttFhgwn5vtFillXTURUY7NE=;
	b=JP7UpWZyY3ejQhYAFhMXLwzPlDp5DofigzwNX/TcSG3wDr8lAeOYALEMHzL+KDSGHfVHTt
	xlq1uduwiCEQk9hQMv32aruhpQXut3cZ4qVDlov7hAP4n7nIxvcNzKixFGcogo4XFT0Dh4
	VMv36IZrPCT42Yy1QoqOXNlND8gieMI=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-589-c1sIx0tPOL60iRiszw7b_g-1; Thu, 14 Nov 2024 18:53:15 -0500
X-MC-Unique: c1sIx0tPOL60iRiszw7b_g-1
X-Mimecast-MFC-AGG-ID: c1sIx0tPOL60iRiszw7b_g
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-37d56061a4cso665014f8f.2
        for <kvm@vger.kernel.org>; Thu, 14 Nov 2024 15:53:14 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731628394; x=1732233194;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rECe5FJajV/VYN0/GaapttFhgwn5vtFillXTURUY7NE=;
        b=t6/j0cNSKpchqJXMVojL4lu3y8hjC1fyrdx+TJxKzrrGKxc1Fgq+7BEGpLq5iSOURC
         gUPkBUNGM7iNQkOZWSO2AQTEqqzMN/2sfIPo2puy4oMWLjq5hdSBnXaj5Hfc7+sTyHyX
         txn66j9RNgljMO53d/BaHnJB5Q8n1yFow31xsTtOmtDqBzAIce7s1x7fjDgYS79kb0cz
         ktD+vbBWI3aYIhCGbfLI4LSACkzID1EEUue8T2ud4Q4+Uhj/CaspTyNPX2nSMEnbfMwF
         XUwe9lxlDHwaXTiy2kFg+JR3hQs4S7bqK+q42L+1hZWkCwOL5cCLNo0Grf3UmyQj3z+8
         g8jQ==
X-Forwarded-Encrypted: i=1; AJvYcCXvJVxI8pmM23p8cl3AArb1S/8N83tY8G8yczFDQbM0c9duD/qLsbkboUA3BVLCHyvSEZc=@vger.kernel.org
X-Gm-Message-State: AOJu0YybXxPAEAKFn2o3FRZr1umEyjTCnMGAA8xsK8pVfcLP6c4QAt0l
	rhiPL9p3xkPHz8r1lV/biysUKZBCTSn0ma94CkICqaygbxdRsoqvCx7pDCx6WSUme2h+smDO5Df
	Y2gshQgv2LWPi4Uixrs5urJ7QLjFUfm2L8er/e0Ady7xA6RiuytCyxxWv7RWckQXFtbu0+OnH6z
	wknsNLsJIu5Jx6xzvVgGIMVCBO
X-Received: by 2002:a05:6000:156b:b0:374:c17a:55b5 with SMTP id ffacd0b85a97d-38225907519mr413188f8f.14.1731628393808;
        Thu, 14 Nov 2024 15:53:13 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHKwOuvExVXPmSQhtLCT0FzFyo78jxZHYmPrEQdpvPU+torab91q63PrU3gZsTPFt//8kyo2JOBpOrw6eK7KKk=
X-Received: by 2002:a05:6000:156b:b0:374:c17a:55b5 with SMTP id
 ffacd0b85a97d-38225907519mr413177f8f.14.1731628393484; Thu, 14 Nov 2024
 15:53:13 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241114094128.2198306-1-chenhuacai@loongson.cn>
In-Reply-To: <20241114094128.2198306-1-chenhuacai@loongson.cn>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Fri, 15 Nov 2024 00:53:00 +0100
Message-ID: <CABgObfbLYfAo=PGNPxEJXrttM575JeSV265madXmN2uuZEFqfQ@mail.gmail.com>
Subject: Re: [GIT PULL] LoongArch KVM changes for v6.13
To: Huacai Chen <chenhuacai@loongson.cn>
Cc: Huacai Chen <chenhuacai@kernel.org>, Tianrui Zhao <zhaotianrui@loongson.cn>, 
	Bibo Mao <maobibo@loongson.cn>, kvm@vger.kernel.org, loongarch@lists.linux.dev, 
	linux-kernel@vger.kernel.org, Xuerui Wang <kernel@xen0n.name>, 
	Jiaxun Yang <jiaxun.yang@flygoat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 14, 2024 at 10:50=E2=80=AFAM Huacai Chen <chenhuacai@loongson.c=
n> wrote:
>
> The following changes since commit 2d5404caa8c7bb5c4e0435f94b28834ae54566=
23:
>
>   Linux 6.12-rc7 (2024-11-10 14:19:35 -0800)
>
> are available in the Git repository at:
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/chenhuacai/linux-loongson=
.git tags/loongarch-kvm-6.13
>
> for you to fetch changes up to 9899b8201025d00b23aee143594a30c55cc4cc35:
>
>   irqchip/loongson-eiointc: Add virt extension support (2024-11-13 16:18:=
27 +0800)

Pulled, thanks.

Paolo

> ----------------------------------------------------------------
> LoongArch KVM changes for v6.13
>
> 1. Add iocsr and mmio bus simulation in kernel.
> 2. Add in-kernel interrupt controller emulation.
> 3. Add virt extension support for eiointc irqchip.
>
> ----------------------------------------------------------------
> Bibo Mao (1):
>       irqchip/loongson-eiointc: Add virt extension support
>
> Xianglai Li (11):
>       LoongArch: KVM: Add iocsr and mmio bus simulation in kernel
>       LoongArch: KVM: Add IPI device support
>       LoongArch: KVM: Add IPI read and write function
>       LoongArch: KVM: Add IPI user mode read and write function
>       LoongArch: KVM: Add EIOINTC device support
>       LoongArch: KVM: Add EIOINTC read and write functions
>       LoongArch: KVM: Add EIOINTC user mode read and write functions
>       LoongArch: KVM: Add PCHPIC device support
>       LoongArch: KVM: Add PCHPIC read and write functions
>       LoongArch: KVM: Add PCHPIC user mode read and write functions
>       LoongArch: KVM: Add irqfd support
>
>  Documentation/arch/loongarch/irq-chip-model.rst    |   64 ++
>  .../zh_CN/arch/loongarch/irq-chip-model.rst        |   55 ++
>  arch/loongarch/include/asm/irq.h                   |    1 +
>  arch/loongarch/include/asm/kvm_eiointc.h           |  123 +++
>  arch/loongarch/include/asm/kvm_host.h              |   18 +-
>  arch/loongarch/include/asm/kvm_ipi.h               |   45 +
>  arch/loongarch/include/asm/kvm_pch_pic.h           |   62 ++
>  arch/loongarch/include/uapi/asm/kvm.h              |   20 +
>  arch/loongarch/kvm/Kconfig                         |    5 +-
>  arch/loongarch/kvm/Makefile                        |    4 +
>  arch/loongarch/kvm/exit.c                          |   82 +-
>  arch/loongarch/kvm/intc/eiointc.c                  | 1027 ++++++++++++++=
++++++
>  arch/loongarch/kvm/intc/ipi.c                      |  475 +++++++++
>  arch/loongarch/kvm/intc/pch_pic.c                  |  519 ++++++++++
>  arch/loongarch/kvm/irqfd.c                         |   89 ++
>  arch/loongarch/kvm/main.c                          |   19 +-
>  arch/loongarch/kvm/vcpu.c                          |    3 +
>  arch/loongarch/kvm/vm.c                            |   21 +
>  drivers/irqchip/irq-loongson-eiointc.c             |  108 +-
>  include/linux/kvm_host.h                           |    1 +
>  include/trace/events/kvm.h                         |   35 +
>  include/uapi/linux/kvm.h                           |    8 +
>  22 files changed, 2735 insertions(+), 49 deletions(-)
>  create mode 100644 arch/loongarch/include/asm/kvm_eiointc.h
>  create mode 100644 arch/loongarch/include/asm/kvm_ipi.h
>  create mode 100644 arch/loongarch/include/asm/kvm_pch_pic.h
>  create mode 100644 arch/loongarch/kvm/intc/eiointc.c
>  create mode 100644 arch/loongarch/kvm/intc/ipi.c
>  create mode 100644 arch/loongarch/kvm/intc/pch_pic.c
>  create mode 100644 arch/loongarch/kvm/irqfd.c
>


