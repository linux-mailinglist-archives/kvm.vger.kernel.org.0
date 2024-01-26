Return-Path: <kvm+bounces-7187-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6814B83E0F3
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 19:00:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 95C851C22A86
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 18:00:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C0477208A7;
	Fri, 26 Jan 2024 18:00:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cj/RRHmp"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 577831F604
	for <kvm@vger.kernel.org>; Fri, 26 Jan 2024 18:00:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706292012; cv=none; b=rTqtFJ95wIaldHkdT+6Hrwi0lsprsgNjkWwPBkvAjvpsZCTlOt8qrfQOvBn2ii+dxX5m8CJCkc2/GJIEgwjepyPwkqwXd6/njUu2guKh9eB3QhS6K3mioSPSTceJKlFzKmea9KCVxPmgZju//tyXAEnwYdR6D6UHJICTAAqNeqg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706292012; c=relaxed/simple;
	bh=blhWKjQVb0FikHjrih2xY0ervP8jTp1dtdRN6Cab5Us=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=USnAA/B/qy329OyTkalWzIDy2PRgcpm/YCrn5lLgI4omRuQ4YL+TpNrBygq6nA/bJy6zmoTXJsRx4/WSOakeBpg/xwEPidqUC9xM57yqOIXjcmBN9jxVDweFc7qf1+SvNO0CSxOqCXshfNv2HJKzRpeRJt5dEZrcTUeMB2MdBFY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=cj/RRHmp; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1706292009;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Pe5cAuD+r7l7BeM6JauqetJcjdzYv9yedKQx/BOkRTI=;
	b=cj/RRHmph1rih/51MpvvwwSsjgaDTE1fE2dYUVDJk4YUZXuMH3Ql8k2CM8sqK2nLUKwmsy
	eW88L+jewDsLLQ/K2Lp4vwQZGj+K5JLo7Boj7LM3PyFDjl72uUu8yv/JYRv97tRulpw7Jy
	KwEcuIUjwGzZq7XLs4gtBTlPTI4+6hI=
Received: from mail-ua1-f71.google.com (mail-ua1-f71.google.com
 [209.85.222.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-542-5f_Y0qCbOAyiaBUwk11l6w-1; Fri, 26 Jan 2024 13:00:07 -0500
X-MC-Unique: 5f_Y0qCbOAyiaBUwk11l6w-1
Received: by mail-ua1-f71.google.com with SMTP id a1e0cc1a2514c-7d2fda27b16so205363241.0
        for <kvm@vger.kernel.org>; Fri, 26 Jan 2024 10:00:06 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706292006; x=1706896806;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Pe5cAuD+r7l7BeM6JauqetJcjdzYv9yedKQx/BOkRTI=;
        b=CCQpaIpNFhF3/1XHKNN344tbBpeJci8DXrecSt0vU3TIl+0Ko+J3mwganQRHJd1NFV
         Y/YppDb86kl3EWW9IXB/QTGYEQ289elFzsxr8cMAHa6mgC9MhO9Z1uflpvC7r4Pxdm/S
         sz+F3qefV57M5eVtRKuL3kmRQXc7jNNt5v3x5XUrFexuwqEKAcaGOY/bCLtoqAmcrtxZ
         Y5BpsbIsHfJl4BmsqBf/s9W0XcAZAicsHdmEYgisZ37bJUFBG2gJUzKY6myYL+B4tNQ2
         JUBH21Kubp7fYRu5d9k/ieDGXrriGsTa4qDqhInS2S26SmpeeVSOGQ6cPPKNobw2IeID
         QFAA==
X-Gm-Message-State: AOJu0Yyy0ykYFXh2Qb33MFmiG5lbqB9CpwV2QBaVv0CDAPdxtbOiV2g8
	c3Y6RmlrPFSsmdYvO5UBybMdEFfvrUeUbZRES4J8PbSjGZOr6MWlehuli7na5zy9uLkEpsZiuei
	J/AlMJPKJBEw5zgQd4ZhOga4iPf1ebYFFGGEHu0k6mB+dIKzxXTcjxVbEVpLd60ICOl5B2xUJxK
	VyHEOmAf2BbRTTB8JlasRIwfId
X-Received: by 2002:a05:6122:4126:b0:4bd:5f13:1293 with SMTP id ce38-20020a056122412600b004bd5f131293mr161895vkb.24.1706292006202;
        Fri, 26 Jan 2024 10:00:06 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEs8NNV8GXT8UDGCEqs4Xs1royxAcYx30+Iiu+w3V2jR05bmGyDpTGlnwfAOA3z4i569k8jc+jA020qI93c/F0=
X-Received: by 2002:a05:6122:4126:b0:4bd:5f13:1293 with SMTP id
 ce38-20020a056122412600b004bd5f131293mr161881vkb.24.1706292005872; Fri, 26
 Jan 2024 10:00:05 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAAhSdy2rbMeTwwHU_dHwUQi3AQB1qGNf=ByvzG11D99ZOJ3djA@mail.gmail.com>
In-Reply-To: <CAAhSdy2rbMeTwwHU_dHwUQi3AQB1qGNf=ByvzG11D99ZOJ3djA@mail.gmail.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Fri, 26 Jan 2024 18:59:54 +0100
Message-ID: <CABgObfavYbr_L34jNTOf_GLKTZ0CjXyz_vkVO6jr6pQZ_pLWSA@mail.gmail.com>
Subject: Re: [GIT PULL] KVM/riscv changes for 6.8 part #2
To: Anup Patel <anup@brainfault.org>
Cc: Palmer Dabbelt <palmer@dabbelt.com>, Palmer Dabbelt <palmer@rivosinc.com>, 
	Andrew Jones <ajones@ventanamicro.com>, Atish Patra <atishp@atishpatra.org>, 
	Atish Patra <atishp@rivosinc.com>, KVM General <kvm@vger.kernel.org>, 
	"open list:KERNEL VIRTUAL MACHINE FOR RISC-V (KVM/riscv)" <kvm-riscv@lists.infradead.org>, 
	linux-riscv <linux-riscv@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jan 19, 2024 at 6:33=E2=80=AFAM Anup Patel <anup@brainfault.org> wr=
ote:
>
> Hi Paolo,
>
> We have the following additional KVM RISC-V changes for 6.8:
> 1) Zbc extension support for Guest/VM
> 2) Scalar crypto extensions support for Guest/VM
> 3) Vector crypto extensions support for Guest/VM
> 4) Zfh[min] extensions support for Guest/VM
> 5) Zihintntl extension support for Guest/VM
> 6) Zvfh[min] extensions support for Guest/VM
> 7) Zfa extension support for Guest/VM

Pulled, thanks.

Paolo

> Please pull.
>
> Regards,
> Anup
>
> The following changes since commit 9d1694dc91ce7b80bc96d6d8eaf1a1eca668d8=
47:
>
>   Merge tag 'for-6.8/block-2024-01-18' of git://git.kernel.dk/linux
> (2024-01-18 18:22:40 -0800)
>
> are available in the Git repository at:
>
>   https://github.com/kvm-riscv/linux.git tags/kvm-riscv-6.8-2
>
> for you to fetch changes up to 4d0e8f9a361b3a1f7b67418c536b258323de734f:
>
>   KVM: riscv: selftests: Add Zfa extension to get-reg-list test
> (2024-01-19 09:20:19 +0530)
>
> ----------------------------------------------------------------
> KVM/riscv changes for 6.8 part #2
>
> - Zbc extension support for Guest/VM
> - Scalar crypto extensions support for Guest/VM
> - Vector crypto extensions support for Guest/VM
> - Zfh[min] extensions support for Guest/VM
> - Zihintntl extension support for Guest/VM
> - Zvfh[min] extensions support for Guest/VM
> - Zfa extension support for Guest/VM
>
> ----------------------------------------------------------------
> Anup Patel (14):
>       RISC-V: KVM: Allow Zbc extension for Guest/VM
>       KVM: riscv: selftests: Add Zbc extension to get-reg-list test
>       RISC-V: KVM: Allow scalar crypto extensions for Guest/VM
>       KVM: riscv: selftests: Add scaler crypto extensions to get-reg-list=
 test
>       RISC-V: KVM: Allow vector crypto extensions for Guest/VM
>       KVM: riscv: selftests: Add vector crypto extensions to get-reg-list=
 test
>       RISC-V: KVM: Allow Zfh[min] extensions for Guest/VM
>       KVM: riscv: selftests: Add Zfh[min] extensions to get-reg-list test
>       RISC-V: KVM: Allow Zihintntl extension for Guest/VM
>       KVM: riscv: selftests: Add Zihintntl extension to get-reg-list test
>       RISC-V: KVM: Allow Zvfh[min] extensions for Guest/VM
>       KVM: riscv: selftests: Add Zvfh[min] extensions to get-reg-list tes=
t
>       RISC-V: KVM: Allow Zfa extension for Guest/VM
>       KVM: riscv: selftests: Add Zfa extension to get-reg-list test
>
>  arch/riscv/include/uapi/asm/kvm.h                |  27 ++++++
>  arch/riscv/kvm/vcpu_onereg.c                     |  54 ++++++++++++
>  tools/testing/selftests/kvm/riscv/get-reg-list.c | 108 +++++++++++++++++=
++++++
>  3 files changed, 189 insertions(+)
>


