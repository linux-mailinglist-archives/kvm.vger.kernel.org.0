Return-Path: <kvm+bounces-66608-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 9A3EFCD874D
	for <lists+kvm@lfdr.de>; Tue, 23 Dec 2025 09:35:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id C99F83022185
	for <lists+kvm@lfdr.de>; Tue, 23 Dec 2025 08:35:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 09A6331E11C;
	Tue, 23 Dec 2025 08:35:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GUcYZIxg";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="OS2MK4Jo"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46C6031D744
	for <kvm@vger.kernel.org>; Tue, 23 Dec 2025 08:35:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766478949; cv=none; b=h0Hq7zqgGIf45Yiq1qawWmswnW6dhaCHoAdSpOBBI3dy5BuFHjBD8mygrFxCRPgluGi8IU/GE/nOtdp4H5NXRUpgh21GqdMtyQX2SKJXEpUBPHzIH0rz5GKGpSX/RGAV9KrS+bX4r6D6mrSi/xj9HNXmmpWAvnTC9rO/W+5hQ/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766478949; c=relaxed/simple;
	bh=7a+Nc5b2xqxt1m2XeVFdzgGvspB1Na0KnxEG+8JJkDk=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=BCw/hllnnA/KvhjRkEF3FtLHE9RWBVhcVp9kRqs8UV/MVsWaQAWqqdS2iKOxFFG+oxBg6ktCqlIk39ifSXr9N21tbYZuF2K37UARNvdtd+7+e8AVwwQgyyi0ZmzxRdgHzkAeg4+pJ+y0nsH5Og6FrZbuHUzxtz7rNqjaPa8wi48=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=GUcYZIxg; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=OS2MK4Jo; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1766478946;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=dTGDISk6QeQKlSCiHlwr4Zk2UK3K2WT7joVVUmlLEuA=;
	b=GUcYZIxgKZrRykpBZIJab7lCzH/mVK1A6KbCP8PzUTmie1LVSefVAS37Z9vyPu0njPF0Zy
	fnHkCPp46vazhpwCxa//RdfcLoug7l0jm9fCRssOhFDmiompr4jRKmgCRhU4WNFofXybEO
	FAGLhRlGE4HO7aYB6NlQi/ZqUMMx75Y=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-98-7fiBzBgRNqOBiC3kB343jQ-1; Tue, 23 Dec 2025 03:35:44 -0500
X-MC-Unique: 7fiBzBgRNqOBiC3kB343jQ-1
X-Mimecast-MFC-AGG-ID: 7fiBzBgRNqOBiC3kB343jQ_1766478943
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-47777158a85so54298885e9.3
        for <kvm@vger.kernel.org>; Tue, 23 Dec 2025 00:35:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1766478943; x=1767083743; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=dTGDISk6QeQKlSCiHlwr4Zk2UK3K2WT7joVVUmlLEuA=;
        b=OS2MK4Jo4Wo6m1mXN/T35sFoEca1Zys6n9QRkDPoAbFui8tMdcqikRqBUcEOwUlbeS
         xMADfMU7nsrRmaV/Te4ZJH0AxdcKQpd6zQJGUoLRcWD44562uMeffbsOskxB3442HPkK
         bbzkRgyl/T0xt+e+I5scOXrU108ZG3sViaRHxU3E5zQWyeFu8M6fDRDi5vCdkBIhakIk
         Ptgn+bhbxXY1xZLjym6S1HKZWp3/PX1Wr9i/n75bnTzJpfshWZaxRbcCvdE9zZJoD4Ft
         EZMPjSBCBPN0bCNAVPozLVywsII1/L/F9+z6o8y4intVjJPFdtWy3W+qvcvWXwyyFwBv
         XtPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766478943; x=1767083743;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=dTGDISk6QeQKlSCiHlwr4Zk2UK3K2WT7joVVUmlLEuA=;
        b=SOGQbgnvAF+slQH2dCS/Z5wEGWU0OnDyKMWEdO+cRv3+ac5Lzw5qprfeRZkk3Vkckt
         lAKcpqlt/NihnJsY1a7bpi9lHxkU2woLGM/AaSHCozsT3uoPSvsdZkprxqVH3R+dRL5z
         4eBrhmvVyl9kDrVPQxQPnxHAPOu8ph0JZZrczPDNllpEfLYki7h3hCi6Zfm0w//TuEe7
         0/xH6NiyvQFFY199C4FB4ikFtIMRAD/mv1X6+QgfBG4ikHZ9BCXWztD0+1VLsbAu5bLu
         qYFg3aRSnAECc6G92A3yn3WCYVbu9+8D28WrOkDAa7IgRaynyJ26zFEJkqiO87EUnJlX
         Y4aQ==
X-Forwarded-Encrypted: i=1; AJvYcCWowDgbhU0COmXYBggW9xd/EqD4OjqCSzHnIvOBaJyVr9476Dhoe9VMorQCnVrp/CBubdY=@vger.kernel.org
X-Gm-Message-State: AOJu0YwH+Y1hRvyD+PsT3Aq23TciCoWxW7TOSA3swbB0Qoqeqg5cZ3gf
	KZzfQyvojqGuJTQlOBpj4DVadUVurwUwnak3pbAY86HRW1s5AHcL+In7QqS/v+Hj23VWqrY/IKN
	PChAW1giwaNYaZsK7/Ik2xkOla75oq8UYlABljizMNurZoTGVdyf2YFdPbQtKaA==
X-Gm-Gg: AY/fxX5SUPXzdkjm0rjxNKvc69aBm+ChqaD89XnuARlqoGYpTi0L4Ewbrc6UVMZ+XeJ
	+GiroYpfybir94Z8w91FztG541kkb5+ejZ1vlrslakDUrLU5qsGzAM8FwzkWcCdEB9YSY6kjTmi
	8GKT5To0/q/yJ9ax+XJck8PWMOSHOwK7SBMneAYCB9/5Mn6vGxxKX3+WtySOJMM/bZPS2MBcyhu
	Sn9i4mu1C880PGcTcS32lZY98uWb7WiUWBt/oPmcRdsxW/IHktK7fHWADoZ/djUZ95EzQ+exM1W
	gHvit9FvFtThd3O/Hp9h9NZX/jcAQdi13e/NhxCjV334U7ROY2VGzlcy/df9LDjerpWA7+pusE+
	OW2X41b8WU/SrXiB26p5dK2dnq9gSSOJBdyuLb+wWKK/Q2Eztb2Kizd6Z5m6omHouvI36FN93Cc
	JbQKgJA7x813+Jkd8=
X-Received: by 2002:a05:600c:6388:b0:477:639d:bca2 with SMTP id 5b1f17b1804b1-47d1956ec01mr124313935e9.4.1766478942704;
        Tue, 23 Dec 2025 00:35:42 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHU/2FCNstXLh/zTogD8EvCdfHTEClCuHWaW8ikbuhwAKDAPrTQvGIrYRZ99rXPiE+KdlHUyg==
X-Received: by 2002:a05:600c:6388:b0:477:639d:bca2 with SMTP id 5b1f17b1804b1-47d1956ec01mr124313745e9.4.1766478942306;
        Tue, 23 Dec 2025 00:35:42 -0800 (PST)
Received: from [192.168.10.48] ([151.95.145.106])
        by smtp.googlemail.com with ESMTPSA id 5b1f17b1804b1-47be3963fc3sm116641265e9.0.2025.12.23.00.35.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 23 Dec 2025 00:35:41 -0800 (PST)
Message-ID: <f1c21e2a-486d-409c-bf7b-95492eae6624@redhat.com>
Date: Tue, 23 Dec 2025 09:35:40 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] virt/kvm: Replace unsafe shift check with
 __builtin_clzll()
To: Peng Hao <flyingpenghao@gmail.com>, kvm@vger.kernel.org
References: <20251223071724.50294-1-flyingpeng@tencent.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Content-Language: en-US
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
In-Reply-To: <20251223071724.50294-1-flyingpeng@tencent.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/23/25 08:17, Peng Hao wrote:
> The `(mask << x >> x) == mask` pattern to check for shift overflow is
> considered undefined behavior by modern compilers and can be optimized
> away incorrectly.

No, not for unsigned integers.

If anything, you could track clz(mask) in a variable, which should be
a tiny bit more efficient:

diff --git a/virt/kvm/dirty_ring.c b/virt/kvm/dirty_ring.c
index 02bc6b00d76c..30be665ec9b6 100644
--- a/virt/kvm/dirty_ring.c
+++ b/virt/kvm/dirty_ring.c
@@ -118,7 +118,8 @@ int kvm_dirty_ring_reset(struct kvm *kvm, struct kvm_dirty_ring *ring,
  	 * a sequence of gfns X, X-1, ... X-N-1 can be batched.
  	 */
  	u32 cur_slot, next_slot;
-	u64 cur_offset, next_offset;
+	u64 cur_offset, next_offset, min_offset;
+	int zeroes = 0;
  	unsigned long mask = 0;
  	struct kvm_dirty_gfn *entry;
  
@@ -164,16 +165,15 @@ int kvm_dirty_ring_reset(struct kvm *kvm, struct kvm_dirty_ring *ring,
  			if (next_slot == cur_slot) {
  				s64 delta = next_offset - cur_offset;
  
-				if (delta >= 0 && delta < BITS_PER_LONG) {
-					mask |= 1ull << delta;
-					continue;
-				}
-
-				/* Backwards visit, careful about overflows! */
-				if (delta > -BITS_PER_LONG && delta < 0 &&
-				(mask << -delta >> -delta) == mask) {
-					cur_offset = next_offset;
-					mask = (mask << -delta) | 1;
+				if (delta >= -zeroes && delta < BITS_PER_LONG) {
+					if (delta >= 0) {
+						mask |= 1ull << delta;
+						zeroes = BITS_PER_LONG - 1 - delta;
+					} else {
+						cur_offset = next_offset;
+						mask = (mask << -delta) | 1;
+						zeroes += delta;
+					}
  					continue;
  				}
  			}
@@ -192,6 +192,7 @@ int kvm_dirty_ring_reset(struct kvm *kvm, struct kvm_dirty_ring *ring,
  		cur_slot = next_slot;
  		cur_offset = next_offset;
  		mask = 1;
+		zeroes = BITS_PER_LONG - 1;
  	}
  
  	/*


>   				/* Backwards visit, careful about overflows! */
>   				if (delta > -BITS_PER_LONG && delta < 0 &&
> -				(mask << -delta >> -delta) == mask) {
> +				(unsigned long)-delta <= __builtin_clzll(mask)) {

As an aside, the first term of the && is "-delta < BITS_PER_LONG",
so it is redundant with the new term that you've added.

"delta < 0" can also be removed, since (unsigned long) -delta will be
very large for positive delta.  So you could have written this as
simply "if ((unsigned long)-delta <= __builtin_clzll(mask))".

Paolo


