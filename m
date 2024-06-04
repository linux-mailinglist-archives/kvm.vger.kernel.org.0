Return-Path: <kvm+bounces-18789-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A46488FB5D6
	for <lists+kvm@lfdr.de>; Tue,  4 Jun 2024 16:44:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B9FA6B28496
	for <lists+kvm@lfdr.de>; Tue,  4 Jun 2024 14:43:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 88C1E13CA9A;
	Tue,  4 Jun 2024 14:40:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="O2YHr8HI"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E55B2AEFE
	for <kvm@vger.kernel.org>; Tue,  4 Jun 2024 14:40:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717512028; cv=none; b=BJ5OHp8yqouIPmwrgOufrL4jMynxgxG6Pw3YCJFfXNH2IcNfUQiqeps9fgyIO2gpZbT/5etmkJABJ+q/cUscJL4hqoUKqP2V7uxFBjy+b0F7qT/OXpBOCrB/XQ8AuVCIlTMQ/Myfv9Mpver4ZZOIFND04UITxPqe0Ij/OlYWx6U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717512028; c=relaxed/simple;
	bh=eJmwqjsUKsWhtzK90nBzNbQq4qK7w/iW9NxVjBDr3gY=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=uMCOrtEODX10HMAGTvX807oE6SvkQMGX5BbBmhE2qusiJd+c7RBiGrZ49GxOyLVFvu8dWF1b1LfamAyJY5SQdq4wUGm9GkthoW5GABOAXhDmiwZOI0BTIAdRVyFv5W3GXqUVBvIipSFV91fxbbCG4UVqcqhuPlXBJv/tRc0keIE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=O2YHr8HI; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1717512026;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=MQJRjVOdwq/5l2ECcTuzOVGaF9yzfEN7cDYfkvzC2lY=;
	b=O2YHr8HIvaF3creCvdSI/z2bL6cOKd2KHgzSCF57AdP8uYEeL+WzZ6B0VfNo5k4f7wY/Od
	HrRHjki2VCYL2ZeSaTPLojNNuOoBB3Gp47CaRdm/rQjqlU+VOEP+p3ufpbjERj8RKMNsvz
	K15hgsphSvMkEKxohKQK+YDn7vBCbEE=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-661-d8JIO1LaNNKUB3OcwKF5oQ-1; Tue, 04 Jun 2024 10:40:23 -0400
X-MC-Unique: d8JIO1LaNNKUB3OcwKF5oQ-1
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-42135f6012fso24423545e9.3
        for <kvm@vger.kernel.org>; Tue, 04 Jun 2024 07:40:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717512022; x=1718116822;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=MQJRjVOdwq/5l2ECcTuzOVGaF9yzfEN7cDYfkvzC2lY=;
        b=NQVgi1o5q3u/B4WCtajOmRRK5DWgZU//qQEKOJZb96q3vwkwKZDK+q5ohzaM5pnwJB
         SZxZmTFDzkGOlskszzbAzzLRcNOESE6IIRF+HiYlLT+nA3g2AQ2kQCTo1n3J7OnbtVxt
         Gra78gL4qlZr5ZGzz2zuxETfJ8h0GmKGzMnNtMSargcxlUsABqzf0rVmjRDAEN7IjCct
         kDYILlDVm6cCMqmygf1Hy98km00IwnrsNVNrkylfePzMggtK09ladQHJEnaj9A3b4xWm
         zYVgQpT8pfHsNC52R1Iw5G8CuHhk92PCg3VjSVucRyF/Xoq5G1wnHRDtgJXw5Q0Ukt6K
         chzA==
X-Forwarded-Encrypted: i=1; AJvYcCVOPp4NNToUJg69/0DaEdjTFT54Xjp0SIAIAA8aTMWR2G7p+pdMfplaSsQlm0pljMK2JVUZweGdwY7gOfzJM+VzB39s
X-Gm-Message-State: AOJu0YwN2GskV4uDOcdTEH/RX13VXmO20wajszINvMr8OH5E8fS5H6Bv
	EdgaHy2SefItw5UxP7c9tBFj+fEbmoYC/NHjU4anylAb7RjL6UZZQqHjjG92+a7qjVQQfPSrvXo
	h5FzZ2TC6NOMAzSgxa2n7Jr03/AEu0O0IMjDPa9O0AWNdtC/b4Q==
X-Received: by 2002:a05:600c:4fd4:b0:421:3700:5904 with SMTP id 5b1f17b1804b1-42137005aa9mr80876675e9.34.1717512022324;
        Tue, 04 Jun 2024 07:40:22 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFhHl78/jb8ifvt56t3EzBp1DUr7DSPO/bLiJJF5wo9dUKWodqn57aiBiHg2YL4ozPGtTw5Nw==
X-Received: by 2002:a05:600c:4fd4:b0:421:3700:5904 with SMTP id 5b1f17b1804b1-42137005aa9mr80876525e9.34.1717512021953;
        Tue, 04 Jun 2024 07:40:21 -0700 (PDT)
Received: from [192.168.0.4] (ip-109-43-178-97.web.vodafone.de. [109.43.178.97])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4214186ccdcsm47515985e9.16.2024.06.04.07.40.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Jun 2024 07:40:21 -0700 (PDT)
Message-ID: <49f8aadf-6e3f-4d2b-a32a-8ba941a3a2a1@redhat.com>
Date: Tue, 4 Jun 2024 16:40:20 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH kvm-unit-tests] realmode: load above stack
To: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
References: <20240604143507.1041901-1-pbonzini@redhat.com>
Content-Language: en-US
From: Thomas Huth <thuth@redhat.com>
Autocrypt: addr=thuth@redhat.com; keydata=
 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
In-Reply-To: <20240604143507.1041901-1-pbonzini@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 04/06/2024 16.35, Paolo Bonzini wrote:
> The bottom 32K of memory are generally reserved for use by the BIOS;
> for example, traditionally the boot loader is placed at 0x7C00 and
> the stack grows below that address.
> 
> It turns out that with some versions of clang, realmode.flat has
> become big enough that it overlaps the stack used by the multiboot
> option ROM loader.  The result is that a couple instructions are
> overwritten.  Typically one or two tests fail and that's it...
> 
> Move the code above the forbidden region, in real 90s style.
> 
> Reported-by: Thomas Huth <thuth@redhat.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>   x86/realmode.lds | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/x86/realmode.lds b/x86/realmode.lds
> index 0ed3063b..e4782a98 100644
> --- a/x86/realmode.lds
> +++ b/x86/realmode.lds
> @@ -1,6 +1,6 @@
>   SECTIONS
>   {
> -    . = 16K;
> +    . = 32K;
>       stext = .;
>       .text : { *(.init) *(.text) }
>       . = ALIGN(4K);

This fails for me with:

ld -m elf_i386 -nostdlib -o x86/realmode.elf \
       -T /home/thuth/devel/kvm-unit-tests/x86/realmode.lds x86/realmode.o
x86/realmode.o: in function `init_inregs':
/home/thuth/devel/kvm-unit-tests/x86/realmode.c:176:(.text+0x79): relocation 
truncated to fit: R_386_16 against `.bss'
/home/thuth/devel/kvm-unit-tests/x86/realmode.c:176:(.text+0x82): relocation 
truncated to fit: R_386_16 against `.bss'
/home/thuth/devel/kvm-unit-tests/x86/realmode.c:176:(.text+0x8b): relocation 
truncated to fit: R_386_16 against `.bss'
/home/thuth/devel/kvm-unit-tests/x86/realmode.c:176:(.text+0x94): relocation 
truncated to fit: R_386_16 against `.bss'
/home/thuth/devel/kvm-unit-tests/x86/realmode.c:176:(.text+0x9d): relocation 
truncated to fit: R_386_16 against `.bss'
/home/thuth/devel/kvm-unit-tests/x86/realmode.c:176:(.text+0xa6): relocation 
truncated to fit: R_386_16 against `.bss'
/home/thuth/devel/kvm-unit-tests/x86/realmode.c:176:(.text+0xaf): relocation 
truncated to fit: R_386_16 against `.bss'
/home/thuth/devel/kvm-unit-tests/x86/realmode.c:176:(.text+0xb8): relocation 
truncated to fit: R_386_16 against `.bss'
/home/thuth/devel/kvm-unit-tests/x86/realmode.c:176:(.text+0xc1): relocation 
truncated to fit: R_386_16 against `.bss'
/home/thuth/devel/kvm-unit-tests/x86/realmode.c:176:(.text+0xca): relocation 
truncated to fit: R_386_16 against `.bss'
/home/thuth/devel/kvm-unit-tests/x86/realmode.c:180:(.text+0xda): additional 
relocation overflows omitted from the output
make: *** [/home/thuth/devel/kvm-unit-tests/x86/Makefile.common:107: 
x86/realmode.elf] Error 1

  Thomas


