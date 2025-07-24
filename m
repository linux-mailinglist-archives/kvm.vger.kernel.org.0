Return-Path: <kvm+bounces-53404-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 2E8C9B1126F
	for <lists+kvm@lfdr.de>; Thu, 24 Jul 2025 22:38:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 086541C85EB9
	for <lists+kvm@lfdr.de>; Thu, 24 Jul 2025 20:38:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3DE79285052;
	Thu, 24 Jul 2025 20:37:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="AEDgRHpi"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C0E9272E41
	for <kvm@vger.kernel.org>; Thu, 24 Jul 2025 20:37:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753389473; cv=none; b=QyTRjTLXPQV/3ohosiDBHWm8IOEwC6CbV8E2iioPEmq/YmDuJVOIOK5LBnhnyYkjZyAt77Tl71tZwgXE+3I3r5K3H6B+KB8uDCXza1tkFVUndVLMT1QwCz9PpoZX7jZDNXFtNgy0KuZmgUKieE4uEMpXu/csYgG1McGxYrgFd2k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753389473; c=relaxed/simple;
	bh=3iJhYIBCliLx6cvM/xxvbhRa/DzQUN/C5dE3qUgVnlI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=glcEqLX3mhjHSTB9Ewv/o4I6L8eNsG3E275Tv0XBSVSFTaM9mT6ozxUKwQz8g0ZWRIcW7LKs8Nxtej31i/Cqs1lhLvl5pxfFZ9v8DxoJZAzbmd8O0MozWn1DjTCVbFxq9yg16hs2RDDri83IB9ExMezPrU0d+R+kys8PSpfSg/c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=AEDgRHpi; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-3132c8437ffso2245107a91.1
        for <kvm@vger.kernel.org>; Thu, 24 Jul 2025 13:37:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753389471; x=1753994271; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=5BadAfBHN4AUhi6edketoROygiJlH6yDIJ6nBg0r11k=;
        b=AEDgRHpiZSiaa2R157mKgOMG31T0HVziN7qk7TufZp1bkvwwAIZbCP0d0D5jsLvp9R
         1Rp8+5y6zqe9Ojrkf5YbiN/D+oaD22iI2y0yeyHGCNOH1k5FL13YyKGiimEoPvlL+eIP
         MZ8cMaoWTsFKiKZfnWUO0nj1RdUVDhkaH5YNP5KhIkBKsPuUAZo1JWJfkNS7jU5UUZYL
         rQp3gYS81Q+guaCJUjVx95rwWqfl7j8VaAvQcQV6f/jazpC8e7bf3xFsY7z2bTvHUxZj
         o2RO/hczvkRGw8PqRTX/ejvruh6KlB4jAgM/qMEexe2TZN6AUU2aXlM5ozKI2hoTtbob
         l9bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753389471; x=1753994271;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5BadAfBHN4AUhi6edketoROygiJlH6yDIJ6nBg0r11k=;
        b=pRXehtziJTG9XqXYFmipkplb7H0Q0+19v6X7UhsHcyTE1u4yQuQ5LvyUGYdhBwSD4o
         7UOllujsh7Y0r0zLuJNpVeGIaKrasBrRaH2vxBTc6wWX8DOZS63Rd8D02OsJ0z4aGy90
         D0tEHIctvLA1wPdBYxiZsaeXPVCUQoRmcbzyMGjXPdVaOHMD0YcpaF7GFrzLRC/vSzz4
         mESEJMYSZik9146IdU+CAHQc7r0iPhgvWw936jc+mq8FSfVnDMPBmGHZ9qqTScNt6s9O
         xx6nBFS7FdnkvRzlwUQcG0P3ZN+l/KOTKkYZh1yNI7UIc2ng3ZgqJg5346WmfPZV21vA
         KHWA==
X-Forwarded-Encrypted: i=1; AJvYcCWi57XrECP0N8n+nwG9AjxHxiC22K4CmhRCbWt5a5zBX4KvmHKNfkKM9dCRlxWv8s4xuXc=@vger.kernel.org
X-Gm-Message-State: AOJu0YyQwFEr9dBw7A/Xuspuea4TBY2uWD/Qb7NPjTgBLj3SApv0C908
	jcd/CNrAQfTCzVcLD2AQVit6r5lRxDX4G6xUmFPX8Kp2PUnsZzysnH0OiABJNYXa4ZGoDMH/jug
	Ei9Z95w==
X-Google-Smtp-Source: AGHT+IHE6eAlwl7jscbkUzp5U5t1vNbnbqNXqGFHZeQed0+nu225pCuYGNqmuyqiKrC1WFWx4eys1B4+PuU=
X-Received: from pjyr5.prod.google.com ([2002:a17:90a:e185:b0:31c:2fe4:33be])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:5487:b0:311:f99e:7f4a
 with SMTP id 98e67ed59e1d1-31e507cddb3mr11188514a91.26.1753389470881; Thu, 24
 Jul 2025 13:37:50 -0700 (PDT)
Date: Thu, 24 Jul 2025 13:37:49 -0700
In-Reply-To: <20250714103441.496787279@infradead.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250714102011.758008629@infradead.org> <20250714103441.496787279@infradead.org>
Message-ID: <aIKZnSuTXn9thrf7@google.com>
Subject: Re: [PATCH v3 16/16] objtool: Validate kCFI calls
From: Sean Christopherson <seanjc@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: x86@kernel.org, kys@microsoft.com, haiyangz@microsoft.com, 
	wei.liu@kernel.org, decui@microsoft.com, tglx@linutronix.de, mingo@redhat.com, 
	bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com, pbonzini@redhat.com, 
	ardb@kernel.org, kees@kernel.org, Arnd Bergmann <arnd@arndb.de>, 
	gregkh@linuxfoundation.org, jpoimboe@kernel.org, linux-hyperv@vger.kernel.org, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org, linux-efi@vger.kernel.org, 
	samitolvanen@google.com, ojeda@kernel.org
Content-Type: text/plain; charset="us-ascii"

On Mon, Jul 14, 2025, Peter Zijlstra wrote:
> --- a/arch/x86/kvm/vmx/vmenter.S
> +++ b/arch/x86/kvm/vmx/vmenter.S
> @@ -361,6 +361,10 @@ SYM_FUNC_END(vmread_error_trampoline)
>  
>  .section .text, "ax"
>  
> +#ifndef CONFIG_X86_FRED
> +
>  SYM_FUNC_START(vmx_do_interrupt_irqoff)
>  	VMX_DO_EVENT_IRQOFF CALL_NOSPEC _ASM_ARG1
>  SYM_FUNC_END(vmx_do_interrupt_irqoff)
> +
> +#endif

This can go in the previous patch, "x86/fred: KVM: VMX: Always use FRED for IRQs
when CONFIG_X86_FRED=y".

