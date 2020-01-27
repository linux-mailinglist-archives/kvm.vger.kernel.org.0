Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C178A14A04A
	for <lists+kvm@lfdr.de>; Mon, 27 Jan 2020 09:56:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728253AbgA0I4d (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Jan 2020 03:56:33 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:40393 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726769AbgA0I4d (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Jan 2020 03:56:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580115392;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=9tIpoiGmCkuvevXLPoa3fIc79sIzbVYkocp+dAFtMA4=;
        b=RQ9kSuiWX9T52aNtjA8G96T5T+qDGUDs07aJd/PkGRZ/xlFpnG+Ixd6ITfrTYkcLxvXer0
        MI3ZJXimxMkMTTS5rlWLcXanOhHhDxT7yApC2rKr3XWE4ozN6927RnlmnXJFFLAi1h1Wl7
        Bdey0Y8yAAUeTwBlrGTu821pmTPlRng=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-341-KvMFalNgPaaBvzy3yUBwXA-1; Mon, 27 Jan 2020 03:56:26 -0500
X-MC-Unique: KvMFalNgPaaBvzy3yUBwXA-1
Received: by mail-wm1-f72.google.com with SMTP id t16so1233144wmt.4
        for <kvm@vger.kernel.org>; Mon, 27 Jan 2020 00:56:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=9tIpoiGmCkuvevXLPoa3fIc79sIzbVYkocp+dAFtMA4=;
        b=LD8DF55JVry9wIjUA8X5E8/d6o0ihynfe4m0yM3ifM3kZmiRh6lfWLXYUe8GXqkhSi
         uizvMsKGbjQY67r8+eJeDl0Me8H2azMsDdBSmy/gQ9KORa/VVV80egaz2aZ2wg12SFjd
         mkbggbIKH3y8FR8w6R6OlimeL9kJs1Hl25VzXjLlfSdvYtIYCjkavJ6POMelUGrcXoG/
         3wYr/0a03sLCl8Xyg31KW/p6sY91HTE/fIs5Wd22pDeyUw//blWRE5/ATtGelYnDrACH
         pyYFYDZBBLHJaiK4Fh+nd478Q7QcShw0aIKYBLlsdYNlgC61Dl/CQAuiO0nvB13rtR6u
         ZEDQ==
X-Gm-Message-State: APjAAAXG1sXIGFzNsgW/LAGqXO5KVxgRtULsmXRvNWcTjd1VyXxrBvqi
        htK8D1cXrTZa/hoDI5X1dXDnauKbDa/hrpci8gWXQmw6HtXRN5KNPfcobeB9mql+xihVLvV/Mtk
        ZhDuOXW7nyzlO
X-Received: by 2002:adf:fa43:: with SMTP id y3mr20078539wrr.65.1580115385279;
        Mon, 27 Jan 2020 00:56:25 -0800 (PST)
X-Google-Smtp-Source: APXvYqwfWD3Za+5pEhMEVE+56LYHlHrEfSASb+WVAzjII+6SiMZWRYf0Md6ZspcLfH9Q2OmwQN3gXA==
X-Received: by 2002:adf:fa43:: with SMTP id y3mr20078506wrr.65.1580115384981;
        Mon, 27 Jan 2020 00:56:24 -0800 (PST)
Received: from vitty.brq.redhat.com ([195.39.4.224])
        by smtp.gmail.com with ESMTPSA id d23sm19860017wra.30.2020.01.27.00.56.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jan 2020 00:56:24 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Nick Desaulniers <nick.desaulniers@gmail.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        clang-built-linux@googlegroups.com, pbonzini@redhat.com,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de
Subject: Re: [PATCH] dynamically allocate struct cpumask
In-Reply-To: <20200127071602.11460-1-nick.desaulniers@gmail.com>
References: <20200127071602.11460-1-nick.desaulniers@gmail.com>
Date:   Mon, 27 Jan 2020 09:56:26 +0100
Message-ID: <871rrlnupx.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Nick Desaulniers <nick.desaulniers@gmail.com> writes:

> This helps avoid avoid a potentially large stack allocation.
>
> When building with:
> $ make CC=clang arch/x86/ CFLAGS=-Wframe-larger-than=1000
> The following warning is observed:
> arch/x86/kernel/kvm.c:494:13: warning: stack frame size of 1064 bytes in
> function 'kvm_send_ipi_mask_allbutself' [-Wframe-larger-than=]
> static void kvm_send_ipi_mask_allbutself(const struct cpumask *mask, int
> vector)
>             ^
> Debugging with:
> https://github.com/ClangBuiltLinux/frame-larger-than
> via:
> $ python3 frame_larger_than.py arch/x86/kernel/kvm.o \
>   kvm_send_ipi_mask_allbutself
> points to the stack allocated `struct cpumask newmask` in
> `kvm_send_ipi_mask_allbutself`. The size of a `struct cpumask` is
> potentially large, as it's CONFIG_NR_CPUS divided by BITS_PER_LONG for
> the target architecture. CONFIG_NR_CPUS for X86_64 can be as high as
> 8192, making a single instance of a `struct cpumask` 1024 B.
>
> Signed-off-by: Nick Desaulniers <nick.desaulniers@gmail.com>
> ---
>  arch/x86/kernel/kvm.c | 10 ++++++----
>  1 file changed, 6 insertions(+), 4 deletions(-)
>
> diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
> index 32ef1ee733b7..d41c0a0d62a2 100644
> --- a/arch/x86/kernel/kvm.c
> +++ b/arch/x86/kernel/kvm.c
> @@ -494,13 +494,15 @@ static void kvm_send_ipi_mask(const struct cpumask *mask, int vector)
>  static void kvm_send_ipi_mask_allbutself(const struct cpumask *mask, int vector)
>  {
>  	unsigned int this_cpu = smp_processor_id();
> -	struct cpumask new_mask;
> +	struct cpumask *new_mask;
>  	const struct cpumask *local_mask;
>  
> -	cpumask_copy(&new_mask, mask);
> -	cpumask_clear_cpu(this_cpu, &new_mask);
> -	local_mask = &new_mask;
> +	new_mask = kmalloc(sizeof(*new_mask), GFP_KERNEL);

You could've used alloc_cpumask_var() instead, however, I think that
memory allocation on this path is undesireable. We can always
pre-allocate 1 cpumask variable per cpu and use it every time, e.g. we
do this for Hyper-V.

> +	cpumask_copy(new_mask, mask);
> +	cpumask_clear_cpu(this_cpu, new_mask);
> +	local_mask = new_mask;
>  	__send_ipi_mask(local_mask, vector);
> +	kfree(new_mask);
>  }
>  
>  /*

-- 
Vitaly

