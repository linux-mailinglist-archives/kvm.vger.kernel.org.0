Return-Path: <kvm+bounces-31787-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 377819C7AAE
	for <lists+kvm@lfdr.de>; Wed, 13 Nov 2024 19:07:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BE39D1F27899
	for <lists+kvm@lfdr.de>; Wed, 13 Nov 2024 18:07:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 54402203712;
	Wed, 13 Nov 2024 18:07:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TFV0PBGy"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63F102022DC
	for <kvm@vger.kernel.org>; Wed, 13 Nov 2024 18:06:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731521221; cv=none; b=mRNe+o1R4x3INetxSF3Weoij0bvTAt4g6YdqIFBXnc4X8VZzzeVs1qKksiA8iKPtYUgcwCPXkluEGt91d5UaVJbdOJHa4oCI+IfusF3OhWRhOZsqssySSN7yRtwd/I6rt41FzzgBBhrXyiJhujYqBedXdRXQeKVHBqn/UZKhDF8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731521221; c=relaxed/simple;
	bh=/GuK59t3U4oKkx/l4VQtIVZCUGo46tDLii0qLHJB/cQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=dOYR6Gpz8GVD2itMqXtOuqzhX0TuxkLubwjX5YnqOntwll13c2wmL+btyWLwT5SgENy8G/gBnbCpifZm+wtjko2aa2TMagonLCbjRiEBlYkv8XDlVdh6V+Q/WXbVhK8k/GODULqO6Dr0lMS+sZ78w7plC22ZHP98I8WXw89ez4M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=TFV0PBGy; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1731521218;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=zHGil4zFWVB1dC6k5RpDLCueLmdtUVVuQDry9KYFhb8=;
	b=TFV0PBGyAAncQvsy8s01BAvWKdJXN5pf2QGZi9uhPqkORNOxe/D7Aq63KxYZlWLrLzmxY3
	d6+nhBQYsU66fJ4BwvQLmKS1e7QlQpgcjPVtoA56vT5jTaeXdG0nB0ZnzXg4GoKezYz4ml
	ztCoV+EGshUtv6Zy+Nh693fX4KRTJJk=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-615-W7QX7ZT3Nzm0Kh40uzUGKQ-1; Wed, 13 Nov 2024 13:06:57 -0500
X-MC-Unique: W7QX7ZT3Nzm0Kh40uzUGKQ-1
X-Mimecast-MFC-AGG-ID: W7QX7ZT3Nzm0Kh40uzUGKQ
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-4316e2dde9eso66096275e9.2
        for <kvm@vger.kernel.org>; Wed, 13 Nov 2024 10:06:56 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731521216; x=1732126016;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zHGil4zFWVB1dC6k5RpDLCueLmdtUVVuQDry9KYFhb8=;
        b=EWdfmbvFWg63l7DM+FggFhCE23j7X58ysANe5v91fnZBIBCEZAUiuMC2aNIEu7J18j
         WtCbQtbk++pgKiG5a0IGLmrHmN5745r8YDamoXCIaTDqkJtIrCYCVDE3IzXnrfIMsdY3
         rz4tLxVzAMes8T9ylBOZVAOKhXDfpHWkzJ59v7TmPsrwA5sLy3Wo8C/bV7XrqYztWk1a
         xneXywiEc4XR+uXq8dKiTH0pYbLIBN2x0jOjpQI1mhGvrnGzVQ1rwq+I7BuLqbCw7xc8
         r4+ohkHJGSjW8DFiMRXLRZorQMBTN6PslEZaUaZCvf/k1g5cFgvqGFiO4wg28V7Jxj10
         FJRg==
X-Forwarded-Encrypted: i=1; AJvYcCW+WxNdjxCEqBt3xoqH8xb+XAcMAb1xraQtfkB3XYegQ/1txNiBqbWVG0HQfalaNzLAJWc=@vger.kernel.org
X-Gm-Message-State: AOJu0YyfitLCbVi5AOb5BLNPt+LywPjH0e0ruqOF20l6b59vpv2PdZsb
	nojvsD1kYRQS0+fq9Q7i38e8rtV2yAZPzfKTO0xyxDZpCjPFen7eSefsf8izvzchqsJuZYK7QzE
	CY7cXGEId8FWV6wSL2edGtUNCU8VN0Q3iM/0G52sfk92vugXi8w==
X-Received: by 2002:a05:600c:1d20:b0:430:57e8:3c7e with SMTP id 5b1f17b1804b1-432b751ee6bmr205041175e9.28.1731521215883;
        Wed, 13 Nov 2024 10:06:55 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGtF/Bm2sFvD8NMykTFnHKS/2fM8FKDNzbG9+c53bHdp6YlEv9GFdeiwAoFxnPEJlyF5VVV5w==
X-Received: by 2002:a05:600c:1d20:b0:430:57e8:3c7e with SMTP id 5b1f17b1804b1-432b751ee6bmr205041015e9.28.1731521215539;
        Wed, 13 Nov 2024 10:06:55 -0800 (PST)
Received: from [192.168.10.47] ([151.49.84.243])
        by smtp.googlemail.com with ESMTPSA id 5b1f17b1804b1-432d5503c63sm31784555e9.26.2024.11.13.10.06.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 Nov 2024 10:06:55 -0800 (PST)
Message-ID: <02dcb7aa-f8d7-4044-93af-24b6d2e4c688@redhat.com>
Date: Wed, 13 Nov 2024 19:06:54 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] i386/kvm: Fix kvm_enable_x2apic link error in non-KVM
 builds
To: Phil Dennis-Jordan <phil@philjordan.eu>, qemu-devel@nongnu.org,
 kvm@vger.kernel.org, mtosatti@redhat.com
Cc: santosh.shukla@amd.com, suravee.suthikulpanit@amd.com
References: <20241113144923.41225-1-phil@philjordan.eu>
From: Paolo Bonzini <pbonzini@redhat.com>
Content-Language: en-US
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
In-Reply-To: <20241113144923.41225-1-phil@philjordan.eu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/13/24 15:49, Phil Dennis-Jordan wrote:
> It appears that existing call sites for the kvm_enable_x2apic()
> function rely on the compiler eliding the calls during optimisation
> when building with KVM disabled, or on platforms other than Linux,
> where that function is declared but not defined.
> 
> This fragile reliance recently broke down when commit b12cb38 added
> a new call site which apparently failed to be optimised away when
> building QEMU on macOS with clang, resulting in a link error.

That's weird, can you check the preprocessor output?  The definition
of kvm_irqchip_in_kernel() should be just "false" on macOS, in fact
even the area you're changing should be simplified like

diff --git a/target/i386/kvm/kvm_i386.h b/target/i386/kvm/kvm_i386.h
index 9de9c0d3038..7edb154a16e 100644
--- a/target/i386/kvm/kvm_i386.h
+++ b/target/i386/kvm/kvm_i386.h
@@ -13,8 +13,7 @@

  #include "sysemu/kvm.h"

-#ifdef CONFIG_KVM
-
+/* always false if !CONFIG_KVM */
  #define kvm_pit_in_kernel() \
      (kvm_irqchip_in_kernel() && !kvm_irqchip_is_split())
  #define kvm_pic_in_kernel()  \
@@ -22,14 +21,6 @@
  #define kvm_ioapic_in_kernel() \
      (kvm_irqchip_in_kernel() && !kvm_irqchip_is_split())

-#else
-
-#define kvm_pit_in_kernel()      0
-#define kvm_pic_in_kernel()      0
-#define kvm_ioapic_in_kernel()   0
-
-#endif  /* CONFIG_KVM */
-
  bool kvm_has_smm(void);
  bool kvm_enable_x2apic(void);

Paolo

> 
> Signed-off-by: Phil Dennis-Jordan <phil@philjordan.eu>
> ---
>   target/i386/kvm/kvm_i386.h | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/target/i386/kvm/kvm_i386.h b/target/i386/kvm/kvm_i386.h
> index 9de9c0d3038..7ce47388d90 100644
> --- a/target/i386/kvm/kvm_i386.h
> +++ b/target/i386/kvm/kvm_i386.h
> @@ -21,17 +21,18 @@
>       (kvm_irqchip_in_kernel() && !kvm_irqchip_is_split())
>   #define kvm_ioapic_in_kernel() \
>       (kvm_irqchip_in_kernel() && !kvm_irqchip_is_split())
> +bool kvm_enable_x2apic(void);
>   
>   #else
>   
>   #define kvm_pit_in_kernel()      0
>   #define kvm_pic_in_kernel()      0
>   #define kvm_ioapic_in_kernel()   0
> +#define kvm_enable_x2apic()      0
>   
>   #endif  /* CONFIG_KVM */
>   
>   bool kvm_has_smm(void);
> -bool kvm_enable_x2apic(void);
>   bool kvm_hv_vpindex_settable(void);
>   bool kvm_enable_hypercall(uint64_t enable_mask);
>   


