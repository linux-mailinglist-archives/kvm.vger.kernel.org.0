Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E0873AF01F
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2019 19:07:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387433AbfIJRHI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Sep 2019 13:07:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43912 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731510AbfIJRHI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Sep 2019 13:07:08 -0400
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com [209.85.221.70])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 77C0F89AC9
        for <kvm@vger.kernel.org>; Tue, 10 Sep 2019 17:07:07 +0000 (UTC)
Received: by mail-wr1-f70.google.com with SMTP id t16so9329839wro.3
        for <kvm@vger.kernel.org>; Tue, 10 Sep 2019 10:07:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=jS9SAbRa2McKy0qBG7wZ1CKPYnoi+vtu8q46fEjiV1s=;
        b=sp3wrV02wwC7HwvtriSwHXom52zwJhlFJdSGpj5mU1YctAMoWcrqkZXh/SLEjzG9dp
         N6c+1GfbPV2pDyasX35fx6FHi0bBKh3hfZiQkcZ+sPIZjr5lNYH5UsXu/KWdoZaSq5Uq
         6ZSZqSdqdB9CWjqfqUXCl8r4+d5TzQ5D08XxaVwGlKhd1JrDxzEMhDKKrmn8UKBBrggk
         Unus/hHUm3ne1vj5qw5ZtMHfSGOJo205JEtzpGCeHINxPY07yz6yhIWrJuFnMYd7yf6j
         Z6h6GqFO3n/65KOAxW4gnLQTvrndVLdMEqEoElSa1LSTXUwQTHJw+Kg9X6uzuy2av9xG
         FU6w==
X-Gm-Message-State: APjAAAXGrKvQQq8Sw3ihh8rxakkE03TxdxBmkRKybslzGYR5Qf+Zr6PU
        Z1a044uvTslDRHKkMZyWxvfHXvyiDZ+1m8HXlfLVlGCXPDLOuxKrTdi8TnMTuX3WNkB+e7r7C7c
        we/2xOWDz6mla
X-Received: by 2002:adf:ed42:: with SMTP id u2mr28596504wro.330.1568135226145;
        Tue, 10 Sep 2019 10:07:06 -0700 (PDT)
X-Google-Smtp-Source: APXvYqziHLD37hPpi8Qki2QYlvEgSFjyeyGPvCTLz7nrsvsi7uErSFmOiRs+uNH8d9gpxHppa9ahhA==
X-Received: by 2002:adf:ed42:: with SMTP id u2mr28596480wro.330.1568135225854;
        Tue, 10 Sep 2019 10:07:05 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:1435:25df:c911:3338? ([2001:b07:6468:f312:1435:25df:c911:3338])
        by smtp.gmail.com with ESMTPSA id w10sm235582wmi.2.2019.09.10.10.07.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Sep 2019 10:07:05 -0700 (PDT)
Subject: Re: [PATCH kvm-unit-tests] arm: prevent compiler from using unaligned
 accesses
To:     Andre Przywara <andre.przywara@arm.com>,
        Andrew Jones <drjones@redhat.com>
Cc:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        Alexandru Elisei <alexandru.elisei@arm.com>
References: <20190905171502.215183-1-andre.przywara@arm.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <cc8ca50b-1e66-1901-ad32-b4b196fb46bf@redhat.com>
Date:   Tue, 10 Sep 2019 19:07:04 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190905171502.215183-1-andre.przywara@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 05/09/19 19:15, Andre Przywara wrote:
> The ARM architecture requires all accesses to device memory to be
> naturally aligned[1][2]. Normal memory does not have this strict
> requirement, and in fact many systems do ignore unaligned accesses
> (by the means of clearing the A bit in SCTLR and accessing normal
> memory). So the default behaviour of GCC assumes that unaligned accesses
> are fine, at least if happening on the stack.
> 
> Now kvm-unit-tests runs some C code with the MMU off, which degrades the
> whole system memory to device memory. Now every unaligned access will
> fault, regardless of the A bit.
> In fact there is at least one place in lib/printf.c where GCC merges
> two consecutive char* accesses into one "strh" instruction, writing to
> a potentially unaligned address.
> This can be reproduced by configuring kvm-unit-tests for kvmtool, but
> running it on QEMU, which triggers an early printf that exercises this
> particular code path.
> 
> Add the -mstrict-align compiler option to the arm64 CFLAGS to fix this
> problem. Also add the respective -mno-unaligned-access flag for arm.
> 
> Thanks to Alexandru for helping debugging this.
> 
> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> 
> [1] ARMv8 ARM DDI 0487E.a, B2.5.2
> [2] ARMv7 ARM DDI 0406C.d, A3.2.1
> ---
>  arm/Makefile.arm   | 1 +
>  arm/Makefile.arm64 | 1 +
>  2 files changed, 2 insertions(+)
> 
> diff --git a/arm/Makefile.arm b/arm/Makefile.arm
> index a625267..43b4be1 100644
> --- a/arm/Makefile.arm
> +++ b/arm/Makefile.arm
> @@ -12,6 +12,7 @@ KEEP_FRAME_POINTER := y
>  
>  CFLAGS += $(machine)
>  CFLAGS += -mcpu=$(PROCESSOR)
> +CFLAGS += -mno-unaligned-access
>  
>  arch_LDFLAGS = -Ttext=40010000
>  
> diff --git a/arm/Makefile.arm64 b/arm/Makefile.arm64
> index 02c24e8..35de5ea 100644
> --- a/arm/Makefile.arm64
> +++ b/arm/Makefile.arm64
> @@ -7,6 +7,7 @@ bits = 64
>  ldarch = elf64-littleaarch64
>  
>  arch_LDFLAGS = -pie -n
> +CFLAGS += -mstrict-align
>  
>  define arch_elf_check =
>  	$(if $(shell ! $(OBJDUMP) -R $(1) >&/dev/null && echo "nok"),
> 

Queued, thanks.

Paolo
