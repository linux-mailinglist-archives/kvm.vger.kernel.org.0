Return-Path: <kvm+bounces-47729-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B75BEAC444B
	for <lists+kvm@lfdr.de>; Mon, 26 May 2025 22:13:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EF544177394
	for <lists+kvm@lfdr.de>; Mon, 26 May 2025 20:13:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8266F23F439;
	Mon, 26 May 2025 20:13:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YvcVXe33"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB5AE23F294
	for <kvm@vger.kernel.org>; Mon, 26 May 2025 20:13:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748290397; cv=none; b=Fc+3lvJTBVpHFmfu+ZCw1rm551u5XR3mgGSmBGvjgiw6WKuR+v9hD6Gi8RM8XRuaagWZaae3n2yLYTLXSDKyF1i1x36K7EP/NdFGnoB74bmcmyuLQO8+AcP/xFyOyHXGkmWVoA86tsaA5P8HJQN8wYqwRvi/Yo+G24NdyQq5jtM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748290397; c=relaxed/simple;
	bh=udre1uGBOac6motS58as4+M/iSTXL1UBy24ANEE9bs4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=XSjg61HEpr/pfpf/Ts/zdclybqvfA3/G4BrQcuHh7mda1B9W/xmPH4lTVEUlr+pDgDUw2br5ha5KO7dK10IeCJH2rHG47hgmJBxTX6+87GjCmBQsXiuLBYPKShutUh8zTcCrdk0m3BjjhZI2Kd+3fiBYDoP9/9AEfYkCZJCsqHY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=YvcVXe33; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1748290394;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hM8pOHSOHM6og3y9wbI886KhOM4ZVpJTZ9nEg3CMFeQ=;
	b=YvcVXe33egBPVNlnLTlKyPXKK18anlMQq7uZnhVsYLFVTdpUjjGn7eFH/bjn292OfDkncQ
	Eseyos9q1prSegBMx42kOYj0OmTufItNtQtnDrhOyz+PVE4E01uj+SRIIrsKJMabqVrFKb
	R9sNptzi0ZcDyFhif3dws6yJ4SorhZc=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-588-uVs65y3dNxKZO67jn2hnFg-1; Mon, 26 May 2025 16:13:13 -0400
X-MC-Unique: uVs65y3dNxKZO67jn2hnFg-1
X-Mimecast-MFC-AGG-ID: uVs65y3dNxKZO67jn2hnFg_1748290392
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-445135eb689so16302695e9.2
        for <kvm@vger.kernel.org>; Mon, 26 May 2025 13:13:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748290392; x=1748895192;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hM8pOHSOHM6og3y9wbI886KhOM4ZVpJTZ9nEg3CMFeQ=;
        b=Dff6PDqDXhZccmLRpoPjmq/SPyA5tt6k+qB7FUM01FsCnYfVp8VPB0FYba5K7bAQEY
         KZrl1U9hnpqQ+Qc0mAe/uwaL0JWRJhTKUZ37jVYChVEObBZ8x7AWLN1oH/oK7Ty8mbQM
         gck6Thx3DlyG0HYwv3af3qQ45Krt6HbUYIpnwOozkhrvWga5jNOfJRPencML8zxJbcYS
         GOdK5+7IPIZRLIQyUhg6fSyWhfeUbtWTG2r+PXfjtqRscXDumS7WDpR9loxIihsw0eIP
         h+us/ry5gIUug0w6/WBFQdnz8X+LsKr2LzAKJO3KbpnvQXFS4llzD5vL1m5xJDxbEr6F
         nZXw==
X-Forwarded-Encrypted: i=1; AJvYcCWnMX7mFybUgB8q72C3HVmMRdnnqTyTK6AtwAunJ7Y1Y3v3ArUF1V88kFnnzL1lgnkeRZY=@vger.kernel.org
X-Gm-Message-State: AOJu0YwpVuws1JHO9S0Eq4yVGVDDpXnA/7iESuYB0yr24SZRa8cbcC+N
	KGNrNl9HvyrVPPN5Sm6C4ght21i1IvF9gpdGfn0VVAEQJgjQJkUssDpwD2P8lfvCWivJmhYL7lb
	eTDQUTKMqyv1EyxNKauX61Bx7VqIgl1E50btqpw3TuKn/2gNuclIvJioPl5uHYAytQTMEmptMn+
	GItBLKXcH7wWVIumSNp1mTntn7PteA
X-Gm-Gg: ASbGncsf7i+WGZJPXPpV4ohgia5ID6Xc96bcqf/Nx4P/6zEickNACULSpLPtWV37Xip
	LHodV/zPpZ/cwyIu7iPx/B8qUcUUBCjYc5AJ+DkdbhsH7yTAzcnXztHv68Z6CsucR6GA=
X-Received: by 2002:a05:6000:40da:b0:3a3:698a:973 with SMTP id ffacd0b85a97d-3a4cb49fa3bmr8695100f8f.59.1748290392169;
        Mon, 26 May 2025 13:13:12 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF0+AxXJPizTpP9QoO5IXtFAO01qqghm8BjYyQ+skkTbjCSgR/3ySaxc11xbULNV7xS2YBFBlH2xIjzip8xtKo=
X-Received: by 2002:a05:6000:40da:b0:3a3:698a:973 with SMTP id
 ffacd0b85a97d-3a4cb49fa3bmr8695090f8f.59.1748290391828; Mon, 26 May 2025
 13:13:11 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250522030628.1924833-1-chenhuacai@loongson.cn>
In-Reply-To: <20250522030628.1924833-1-chenhuacai@loongson.cn>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Mon, 26 May 2025 22:13:00 +0200
X-Gm-Features: AX0GCFvALzV40Zi8ewJWNPzDDkxsciCzCRalOrRxez99t8YObAZ1GdsLNkTkCX8
Message-ID: <CABgObfadeF0Er+M7Lv0kB0O1bugDk+_3jbwKU38Ju63YO7NZhQ@mail.gmail.com>
Subject: Re: [GIT PULL] LoongArch KVM changes for v6.16
To: Huacai Chen <chenhuacai@loongson.cn>
Cc: Huacai Chen <chenhuacai@kernel.org>, Tianrui Zhao <zhaotianrui@loongson.cn>, 
	Bibo Mao <maobibo@loongson.cn>, kvm@vger.kernel.org, loongarch@lists.linux.dev, 
	linux-kernel@vger.kernel.org, Xuerui Wang <kernel@xen0n.name>, 
	Jiaxun Yang <jiaxun.yang@flygoat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, May 22, 2025 at 5:07=E2=80=AFAM Huacai Chen <chenhuacai@loongson.cn=
> wrote:
>
> The following changes since commit a5806cd506af5a7c19bcd596e4708b5c464bfd=
21:
>
>   Linux 6.15-rc7 (2025-05-18 13:57:29 -0700)
>
> are available in the Git repository at:
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/chenhuacai/linux-loongson=
.git tags/loongarch-kvm-6.16
>
> for you to fetch changes up to a867688c8cbb1b83667a6665362d89e8c762e820:
>
>   KVM: selftests: Add supported test cases for LoongArch (2025-05-20 20:2=
0:26 +0800)

Pulled, thanks.

Paolo

> ----------------------------------------------------------------
> LoongArch KVM changes for v6.16
>
> 1. Don't flush tlb if HW PTW supported.
> 2. Add LoongArch KVM selftests support.
>
> ----------------------------------------------------------------
> Bibo Mao (7):
>       LoongArch: KVM: Add ecode parameter for exception handlers
>       LoongArch: KVM: Do not flush tlb if HW PTW supported
>       KVM: selftests: Add VM_MODE_P47V47_16K VM mode
>       KVM: selftests: Add KVM selftests header files for LoongArch
>       KVM: selftests: Add core KVM selftests support for LoongArch
>       KVM: selftests: Add ucall test support for LoongArch
>       KVM: selftests: Add supported test cases for LoongArch
>
>  MAINTAINERS                                        |   2 +
>  arch/loongarch/include/asm/kvm_host.h              |   2 +-
>  arch/loongarch/include/asm/kvm_vcpu.h              |   2 +-
>  arch/loongarch/kvm/exit.c                          |  37 +--
>  arch/loongarch/kvm/mmu.c                           |  15 +-
>  tools/testing/selftests/kvm/Makefile               |   2 +-
>  tools/testing/selftests/kvm/Makefile.kvm           |  17 +
>  tools/testing/selftests/kvm/include/kvm_util.h     |   6 +
>  .../kvm/include/loongarch/kvm_util_arch.h          |   7 +
>  .../selftests/kvm/include/loongarch/processor.h    | 141 +++++++++
>  .../selftests/kvm/include/loongarch/ucall.h        |  20 ++
>  tools/testing/selftests/kvm/lib/kvm_util.c         |   3 +
>  .../selftests/kvm/lib/loongarch/exception.S        |  59 ++++
>  .../selftests/kvm/lib/loongarch/processor.c        | 346 +++++++++++++++=
++++++
>  tools/testing/selftests/kvm/lib/loongarch/ucall.c  |  38 +++
>  .../testing/selftests/kvm/set_memory_region_test.c |   2 +-
>  16 files changed, 674 insertions(+), 25 deletions(-)
>  create mode 100644 tools/testing/selftests/kvm/include/loongarch/kvm_uti=
l_arch.h
>  create mode 100644 tools/testing/selftests/kvm/include/loongarch/process=
or.h
>  create mode 100644 tools/testing/selftests/kvm/include/loongarch/ucall.h
>  create mode 100644 tools/testing/selftests/kvm/lib/loongarch/exception.S
>  create mode 100644 tools/testing/selftests/kvm/lib/loongarch/processor.c
>  create mode 100644 tools/testing/selftests/kvm/lib/loongarch/ucall.c
>


