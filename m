Return-Path: <kvm+bounces-57708-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id B0006B59353
	for <lists+kvm@lfdr.de>; Tue, 16 Sep 2025 12:21:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 013AD1B20979
	for <lists+kvm@lfdr.de>; Tue, 16 Sep 2025 10:22:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 06CE12FF669;
	Tue, 16 Sep 2025 10:21:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=grsecurity.net header.i=@grsecurity.net header.b="av5IdKxg"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qv1-f48.google.com (mail-qv1-f48.google.com [209.85.219.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 701E9283FD8
	for <kvm@vger.kernel.org>; Tue, 16 Sep 2025 10:21:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758018089; cv=none; b=N9yNzUULgfPS1mJIqXXruGy2lmsfZJ1GdlJrH+bv68YxpO4p88Z2YePhfV0YFty0uB8/Hys6ctpLkjYKTsp/465IJw5+km6p9U8+6rSI3Jnd8aIUq47QeQNqc3s7v8YufIXGGyG1XlorPSCL5+wzUoFDaPoQNzOQTqcRhMsRJkg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758018089; c=relaxed/simple;
	bh=8GbupdfdHZFAXVZfT9W4rpBh2ykOOUwdiLYawdhVcLE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qa92w0oHLtxtFKchNm0byv9YSYZLadPA0J2Ofu9axWUyzduFZPYPhmDJpdUFWZ1uP05g32/7lCtgnabMi7zlIfrjCVb+4c6Iuh9ydXE4LtlPhyWtCqY0hKKKDW8DY+1u7ky+MibAzwxz8eA25pwByiq4XmNlbOfKci8kSbg/EGM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=grsecurity.net; spf=pass smtp.mailfrom=opensrcsec.com; dkim=pass (2048-bit key) header.d=grsecurity.net header.i=@grsecurity.net header.b=av5IdKxg; arc=none smtp.client-ip=209.85.219.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=grsecurity.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=opensrcsec.com
Received: by mail-qv1-f48.google.com with SMTP id 6a1803df08f44-76b8fd4ba2cso32685706d6.3
        for <kvm@vger.kernel.org>; Tue, 16 Sep 2025 03:21:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=grsecurity.net; s=grsec; t=1758018086; x=1758622886; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=98U4VS702oJUILpBiZfUiqzv32ecu/XoZkApc58KOpU=;
        b=av5IdKxgmzkzpvT6NJp0P+Z9rhqW4NLBkiWOPFdSg9xkhL/bNrXkOC3DI23U6dovMw
         c47MGLEUKjb/OW1WHiD5cKYQDUjhLBhXmg13X/vF4XENkJVKZMWK+pqYiyyoYT4h9zQc
         +IRxNKBkvP7M46BjmyvDQwkxPwRJw+RWE4PWjGDf1bZzrRCelyKQ4CX1iivKaLi5WZPV
         H+h5ugyeUSX1v08fDhRue21diw9fRGk192f5U/BFKcW2G5rbeAm6zb1LnO43jZbj2+qK
         DAQNfr3idvYF2Gc/k/OzXvKaBUmL+NW+1r+4GEZ4ufBJRAzy7EBJXD7NuULSLL9TzxDV
         f3OQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758018086; x=1758622886;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=98U4VS702oJUILpBiZfUiqzv32ecu/XoZkApc58KOpU=;
        b=icb/oYyoG60dGiY65XVRXB/pAbyEYJrSpfA5KlzPCptQFsSp5s/lkvsKGxPwWlVsMB
         cn6uJBAJq4gcdmhBotnMkfNncFVfvMrZnhY1XVaPL8akQVqV5oeRj6XQbCFFfqfciT2x
         AGGhya91Ue8kywzmoHFHvKQO9FkqlmJQRtA0MsYY51/QESd6yregp4oieMNkDAA73YnD
         hvuWp/A2QGLfAfNtDntUUSrJFNZqaziVAkFm0hmZPhf1kDOcqiNq0s45A3QmjB4bs5px
         cXcCzfBVPvKkAc9v2wzZgMa07eadWVMWHyjwDFC6MjEgCu+S2qE42/CGX9XlSYJwgwj9
         D3Ow==
X-Forwarded-Encrypted: i=1; AJvYcCXF0hD5Fyg0SVRyRM0Cu/GaYtF+GWNRV48ffetWhzU2/k5lMrMFo/9i3nW/MgfJOSepez0=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw9VuQpbAxsWxTRTYChRI54PkpkYCjj5NF1qk5Km1z7BIgQ9LkG
	4vdm2mCT7osh4/JBBWZx6jNBhstVWNHUpXnv7JrsPROSGVgQcEh/6v9h8iYwzOaC4bM=
X-Gm-Gg: ASbGncuBF/0Ipf2fNTZIX5WE/H1VAVv8DBl2uOjcnIkrRD9WLDbvr6NOTAv3DRR00U4
	zwEwisVD/+l8sshFRk2KTH60M64spWlxs/tIQizwxHUFFSR2kc4/TWXke3lOVZeFR0CB6bK2i+G
	1HMAfXhBP5wriFxZedxZpm50NThM+gJe1jcONdkibqB71Mh4Fhwkk6iGpNpLmYQXGMOsy7cogh6
	3D0iMJ6vRI15Lcq22dUmylU1wrqLDdqj8SA5T7EzyKliwvz+nN9OHY5vLP3LgJ4x4lUb9FRGV5W
	hoGlrI5bI6FPTuLQNHZFCLZoYAMFsxnVTrtVvOksUfpgyyJH9DzzGwCiahf8rhRkRAxE+R0VDL+
	9sNvkvURtZwhtMlEfbdRzmva1hKKl6CXPgzBdxun2DHSa6dfipSMw/uGir7tbs/LWjlctXay7Q+
	nrdd4bKuqXQNpNXCwyJGszEzFr0ovgWV7ikyft/Fx1optxe6ZHW3cFNiubPQ==
X-Google-Smtp-Source: AGHT+IENM43bZzx3cnF4ZC4alf4RPNsjpIEsN7Lxz005TiI0GB71kI+8qiYLF6m796bxZOKF+C1ewg==
X-Received: by 2002:ad4:5942:0:b0:72a:2cf6:76b2 with SMTP id 6a1803df08f44-767c5fc2011mr221600256d6.67.1758018086181;
        Tue, 16 Sep 2025 03:21:26 -0700 (PDT)
Received: from ?IPV6:2003:fa:af00:da00:8e63:e663:d61a:1504? (p200300faaf00da008e63e663d61a1504.dip0.t-ipconnect.de. [2003:fa:af00:da00:8e63:e663:d61a:1504])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-77eaca7ede8sm42043546d6.26.2025.09.16.03.21.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 16 Sep 2025 03:21:25 -0700 (PDT)
Message-ID: <b54b2600-fe9d-44df-8a2a-4e8712d8ab09@grsecurity.net>
Date: Tue, 16 Sep 2025 12:21:23 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] x86/eventinj: Push SP to IRET frame
To: Chao Gao <chao.gao@intel.com>, kvm@vger.kernel.org
Cc: pbonzini@redhat.com, seanjc@google.com
References: <20250915144936.113996-1-chao.gao@intel.com>
 <20250915144936.113996-3-chao.gao@intel.com>
Content-Language: en-US, de-DE
From: Mathias Krause <minipli@grsecurity.net>
Autocrypt: addr=minipli@grsecurity.net; keydata=
 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
 RzDVkdgPJkL/NFTKZHo5foFXNi89kA==
In-Reply-To: <20250915144936.113996-3-chao.gao@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Am 15.09.25 um 16:49 schrieb Chao Gao:
> Push the current stack pointer (SP) to the IRET frame in do_iret() to
> ensure a valid stack after IRET execution, particularly in 64-bit mode.
> 
> Currently, do_iret() crafts an IRET frame with a zeroed SP. For 32-bit
> guests, SP is not popped during IRET due to no privilege change. so, the
> stack after IRET is still valid. But for 64-bit guests, IRET
> unconditionally pops RSP, restoring it to zero. This can cause a nested NMI
> to push its interrupt frame to the topmost page (0xffffffff_fffff000),
> which may be not mapped and cause triple fault [1].

Nice catch!

> 
> To fix this issue, push the current SP to the IRET frame, ensuring RSP is
> restored to a valid stack in 64-bit mode.
> 
> Reported-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Chao Gao <chao.gao@intel.com>
> Link: https://lore.kernel.org/kvm/aMahfvF1r39Xq6zK@intel.com/
> ---
>  x86/eventinj.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/x86/eventinj.c b/x86/eventinj.c
> index ec8a5ef1..63ebbaab 100644
> --- a/x86/eventinj.c
> +++ b/x86/eventinj.c
> @@ -153,6 +153,7 @@ asm("do_iret:"
>  	"mov 8(%esp), %edx \n\t"	// virt_stack
>  #endif
>  	"xchg %"R "dx, %"R "sp \n\t"	// point to new stack
> +	"push"W" %"R "sp \n\t"

We should also push SS, for consistency reasons. Not that it would
matter much for x64-64, but a NULL selector for SS still feels wrong.

>  	"pushf"W" \n\t"
>  	"mov %cs, %ecx \n\t"
>  	"push"W" %"R "cx \n\t"

The leading comment also needs an update and the 'extern bool
no_test_device' can be dropped as well, as fwcfg.h gets included by
eventinj.c.

So, maybe something like this on top?:

diff --git a/x86/eventinj.c b/x86/eventinj.c
index 63ebbaabda66..4e21f3915820 100644
--- a/x86/eventinj.c
+++ b/x86/eventinj.c
@@ -139,11 +139,8 @@ static void nested_nmi_iret_isr(struct ex_regs *r)

 extern void do_iret(ulong phys_stack, void *virt_stack);

-// Return to same privilege level won't pop SS or SP, so
+// Return to same privilege level won't pop SS or SP for i386 but x86-64, so
 // save it in RDX while we run on the nested stack
-
-extern bool no_test_device;
-
 asm("do_iret:"
 #ifdef __x86_64__
        "mov %rdi, %rax \n\t"           // phys_stack
@@ -153,7 +150,12 @@ asm("do_iret:"
        "mov 8(%esp), %edx \n\t"        // virt_stack
 #endif
        "xchg %"R "dx, %"R "sp \n\t"    // point to new stack
+#ifdef __x86_64__
+       // IRET in 64 bit mode unconditionally pops SS:xSP
+       "mov %ss, %ecx \n\t"
+       "push"W" %"R "cx \n\t"
        "push"W" %"R "sp \n\t"
+#endif
        "pushf"W" \n\t"
        "mov %cs, %ecx \n\t"
        "push"W" %"R "cx \n\t"

Thanks,
Mathias

