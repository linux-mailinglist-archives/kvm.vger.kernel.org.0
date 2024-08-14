Return-Path: <kvm+bounces-24191-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 11D02952200
	for <lists+kvm@lfdr.de>; Wed, 14 Aug 2024 20:24:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8A0411F240BB
	for <lists+kvm@lfdr.de>; Wed, 14 Aug 2024 18:24:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B820B1BE840;
	Wed, 14 Aug 2024 18:23:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="jNX0DXbk"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 700421BD4EF
	for <kvm@vger.kernel.org>; Wed, 14 Aug 2024 18:23:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723659838; cv=none; b=XNYiKTwTbppN8tkl2HdUf/Khj8Af0HVVsP3k68lOYlgmSOMqWzKHBOpXMTg+gJfQtkVmzdM911p65aI15dMXDvSGmC28LtwVbufu2xbs1JSpapWGjCS3mTtQG9+5sA5Uu5/XkoKM2V4nxLn4BWCeZBF7vkrcethJ6B/gc4rTZdg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723659838; c=relaxed/simple;
	bh=KsQ4lkPBRIUashg/DvRScWF667QoH3bq70F3p8yfY1Q=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=TyNeNageHa5kyvLIRrAgIDfS1Z9G3aC6Q0crgXhDscGr0tNbAq/Zc5jr18xnSCa0hrQnoLEJKW6N+rf0Bn6w8csdFHvSObAamlAP2CU3k3nRg5wd4wL9cEknAhMpw3npDvLFPvVN33I/JwOdTRGCCnPJe1peN/vTqrn5/TR1pvU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=jNX0DXbk; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1723659835;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=imaWqo/6+j7NCYLfqm9y6/BHhB8DY04qFZybPwrTOKM=;
	b=jNX0DXbkIWKiqV/qqe/wzb9/7cjpm+e/9y7Da/bsJ2y52MWsUM+huFZU8AqKQFQ/XL4vsX
	1I2iH8pQ1qyb2G3us9hLAvnJMGoO46I3plMGzVdJcbVmPMbiMcRYxmKrCjO3jP3Kw5RrU5
	oNI07Ik9mJr5lPnhvq3lLEEVpe25SSM=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-44-YxNLZFwzOUC53s-hjmxamQ-1; Wed, 14 Aug 2024 14:23:53 -0400
X-MC-Unique: YxNLZFwzOUC53s-hjmxamQ-1
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-37187b43662so14733f8f.0
        for <kvm@vger.kernel.org>; Wed, 14 Aug 2024 11:23:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723659830; x=1724264630;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=imaWqo/6+j7NCYLfqm9y6/BHhB8DY04qFZybPwrTOKM=;
        b=JMggoSUtWTQeRrugaefteOZxDl+X+L85x8xAbTBk1Vi+MAZrfS0tR3DIo0yB1hPH2f
         Tt7TiHUBxMGxJkVXpYqpKFQ59FSAg7qeKKPmSmb8Za1dX+pqYr/E9wEvuQf9MDo5/hhF
         8E3P/xXdrwbzFo6r1UZynWSaoDImAlVkOjB2lepyAPawVDeVQcFW6gqBw3dfdGF9yBFi
         f1hCUeJDS+jXbeprCcB5gxk5bSGaLWr4zykKyCkoZ4E1ru9Av4djknuGHwPJd6bwrIDj
         JDgsY+G67PuP4d8dWdoKPz7dpr3LH/mkbesxlGfsbgZiCjs7W/nUCjM1aE9h5JC/XPcK
         uQRA==
X-Gm-Message-State: AOJu0Yw4vnLNQe+Tzw1MTyFL7ugl6MXKPVQF3GTrcdMfQIJcAAGt/M8O
	JrPao8suUYxuo73u2XQ3Ej/rK0O3UOZIZTho7kQcdIhHFpuLAlxfhpJfV6CCghj8r+IU9fTazqs
	39ldxUncNTtBXHDj0OKPVAoTzpZZqO2i2onoLIkHkddBaABa5+Q==
X-Received: by 2002:adf:e301:0:b0:367:434f:ca9a with SMTP id ffacd0b85a97d-37177653909mr2342643f8f.0.1723659830184;
        Wed, 14 Aug 2024 11:23:50 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHIapBRKbjBOIqv+CD0iYGqO5NfL8UesIUtDl5Ueiyq4szLZ088b6nVdpd2lpo8pDX6AklMCg==
X-Received: by 2002:adf:e301:0:b0:367:434f:ca9a with SMTP id ffacd0b85a97d-37177653909mr2342632f8f.0.1723659829620;
        Wed, 14 Aug 2024 11:23:49 -0700 (PDT)
Received: from [192.168.10.47] ([151.95.101.29])
        by smtp.googlemail.com with ESMTPSA id ffacd0b85a97d-36e4c36bb07sm13621970f8f.5.2024.08.14.11.23.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 14 Aug 2024 11:23:48 -0700 (PDT)
Message-ID: <e8db3e58-38de-47d4-ac6c-08408f9aaa10@redhat.com>
Date: Wed, 14 Aug 2024 20:23:46 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 0/8] KVM: Register cpuhp/syscore callbacks when
 enabling virt
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Chao Gao <chao.gao@intel.com>, Kai Huang <kai.huang@intel.com>,
 Marc Zyngier <Marc.Zyngier@arm.com>, Anup Patel <Anup.Patel@wdc.com>,
 Huacai Chen <chenhuacai@kernel.org>, Oliver Upton <oupton@google.com>
References: <20240608000639.3295768-1-seanjc@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Content-Language: en-US
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
In-Reply-To: <20240608000639.3295768-1-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/8/24 02:06, Sean Christopherson wrote:
> Register KVM's cpuhp and syscore callbacks when enabling virtualization in
> hardware, as the sole purpose of said callbacks is to disable and re-enable
> virtualization as needed.
> 
> The primary motivation for this series is to simplify dealing with enabling
> virtualization for Intel's TDX, which needs to enable virtualization
> when kvm-intel.ko is loaded, i.e. long before the first VM is created.  TDX
> doesn't _need_ to keep virtualization enabled, but doing so is much simpler
> for KVM (see patch 3).
> 
> That said, this is a nice cleanup on its own, assuming I haven't broken
> something.  By registering the callbacks on-demand, the callbacks themselves
> don't need to check kvm_usage_count, because their very existence implies a
> non-zero count.
> 
> The meat is in patch 1.  Patches 2 renames the helpers so that patch 3 is
> less awkward.  Patch 3 adds a module param to enable virtualization when KVM
> is loaded.  Patches 4-6 are tangentially related x86 cleanups to registers
> KVM's "emergency disable" callback on-demand, same as the syscore callbacks.
> 
> The suspend/resume and cphup paths still need to be fully tested, as do
> non-x86 architectures.

Also placed in kvm/queue, mostly as a reminder to myself, and added 
other maintainers for testing on ARM, RISC-V and LoongArch.  The changes 
from v3 to v4 should be mostly nits, documentation and organization of 
the series.

Thanks,

Paolo

> v3:
>   - Collect reviews/acks.
>   - Switch to kvm_usage_lock in a dedicated patch, Cc'd for stable@. [Chao]
>   - Enable virt at load by default. [Chao]
>   - Add comments to document how kvm_arch_{en,dis}able_virtualization() fit
>     into the overall flow. [Kai]
> 
> v2:
>   - https://lore.kernel.org/all/20240522022827.1690416-1-seanjc@google.com
>   - Use a dedicated mutex to avoid lock inversion issues between kvm_lock and
>     the cpuhp lock.
>   - Register emergency disable callbacks on-demand. [Kai]
>   - Drop an unintended s/junk/ign rename. [Kai]
>   - Decrement kvm_usage_count on failure. [Chao]
> 
> v1: https://lore.kernel.org/all/20240425233951.3344485-1-seanjc@google.com
> 
> Sean Christopherson (8):
>    KVM: Use dedicated mutex to protect kvm_usage_count to avoid deadlock
>    KVM: Register cpuhp and syscore callbacks when enabling hardware
>    KVM: Rename functions related to enabling virtualization hardware
>    KVM: Add a module param to allow enabling virtualization when KVM is
>      loaded
>    KVM: Add arch hooks for enabling/disabling virtualization
>    x86/reboot: Unconditionally define cpu_emergency_virt_cb typedef
>    KVM: x86: Register "emergency disable" callbacks when virt is enabled
>    KVM: Enable virtualization at load/initialization by default
> 
>   Documentation/virt/kvm/locking.rst |  19 ++-
>   arch/x86/include/asm/kvm_host.h    |   3 +
>   arch/x86/include/asm/reboot.h      |   2 +-
>   arch/x86/kvm/svm/svm.c             |   5 +-
>   arch/x86/kvm/vmx/main.c            |   2 +
>   arch/x86/kvm/vmx/vmx.c             |   6 +-
>   arch/x86/kvm/vmx/x86_ops.h         |   1 +
>   arch/x86/kvm/x86.c                 |  10 ++
>   include/linux/kvm_host.h           |  14 ++
>   virt/kvm/kvm_main.c                | 258 ++++++++++++++---------------
>   10 files changed, 175 insertions(+), 145 deletions(-)
> 
> 
> base-commit: af0903ab52ee6d6f0f63af67fa73d5eb00f79b9a


