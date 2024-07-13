Return-Path: <kvm+bounces-21601-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id AD3C0930518
	for <lists+kvm@lfdr.de>; Sat, 13 Jul 2024 12:23:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 345F51F22439
	for <lists+kvm@lfdr.de>; Sat, 13 Jul 2024 10:23:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A4E4071B47;
	Sat, 13 Jul 2024 10:22:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PLu2mXGW"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CFA7629E4
	for <kvm@vger.kernel.org>; Sat, 13 Jul 2024 10:22:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720866159; cv=none; b=D8R6evsF9M9PDJfwrNDNqAD6daxKJwLe4JE+ABTkuQyMjhqSdo/Nke4ExJa7FC7WLb23zspNyUgmM387Mtg9a7xcpiV84+P0qChkFMTIPJwla4nCJz4LXxXFV+8mxBHvw6V970bglI2Y9jT7rs8GVwmjvMDRTV2KJd/MRVz49LQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720866159; c=relaxed/simple;
	bh=G/U3fGewOZgFhfr2yJF1paAyy6bz60rndJx9Gl9Cdv0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ElQNbGlbyXXv/Bkdfi9YriYhEzkKTS/gjy07H3pcMszb+PYSFF6KPnBln+QfrjciDkTLQkxWf5AtjwVeqeM44BNcAsz3MF0WEiPwAr3Ky7Drc8aItPlmrSLUE2GRzD6Hlrwt29Sj3RpakH+5J8l1quLNwOf64aJD71aK+IWCwdc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=PLu2mXGW; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1720866156;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=0IE5+zEZaEHAlbqQCA/nyw/RKQNu0JL5BeF1A1xiyv4=;
	b=PLu2mXGWdnjkSAb1ZRoBQcbAa9Mw+lh+DOjV04L255gw6svdtL5BrpqjIGrpRDtz7SuP/h
	gFP9qjtBD888J+zI53xDg0z36oJePhtYIsxIoqHYetfvumnZM4JPGyo1VyFseGrIYwZymf
	iIKGTYkvSaLRzuIbco9OYqWIXpdqpKU=
Received: from mail-lj1-f200.google.com (mail-lj1-f200.google.com
 [209.85.208.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-201-eR37fSU3P9Gg2R5rCUOVuA-1; Sat, 13 Jul 2024 06:22:33 -0400
X-MC-Unique: eR37fSU3P9Gg2R5rCUOVuA-1
Received: by mail-lj1-f200.google.com with SMTP id 38308e7fff4ca-2ee91e5be95so32452571fa.2
        for <kvm@vger.kernel.org>; Sat, 13 Jul 2024 03:22:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720866152; x=1721470952;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=0IE5+zEZaEHAlbqQCA/nyw/RKQNu0JL5BeF1A1xiyv4=;
        b=s1mQyjEIsxJlh2yBU4HJWAJ9bNpQRgeUxc6xbFA/BTKQ1r4iCcmBK2XxqB2jGBcWSY
         15D5HcG2/HxY4WCb0TM1bldHW9r4VNYhFH/Qjchid8pAk04liR0VUJqee2dHZIkhdjlB
         zZLyYuuHShxYkAIzgVJlEbVb2hxeWISIM45JVXWkb28f/6+CS1mXrjVvs86XAiT6JMQn
         UAkw6zOHI0J/4QSqGJSicRV5E3aZyalh2xQ1XqGqqxLZZLP5xY/Rd/NWo1WxP19BHUoW
         xNPiz9xdUyi61NhGOrARBX60SUhqqOtOaYFePxZQJ4AlnnusOdMJX8GuqKOuDDsTjzaE
         xbhA==
X-Forwarded-Encrypted: i=1; AJvYcCUR6jlWY5WbF5vjcMWnduGIW696qD1jvuZxQUyiivUgCVPCPDD94NiKXjzcJMG8F4ezjqHsOKtzVSTHUe2xujW7OWBp
X-Gm-Message-State: AOJu0Yyj5h9V39Rt0hwVJBFtwD7q5h6afHJAsRZuqQFvQw/X9EV40qfJ
	Hl+ryFSBfsp4cpJzmztNHYjxFHmldmgIVxGMQYJLbCgmEVup45O4tuSY/SVpaky0iskYR1+7/wf
	BGkyKCUmwx+GadJWquRmuKoShYC23XyNIujA1i2C42h8t9U7v4w==
X-Received: by 2002:a2e:a603:0:b0:2ee:9521:1443 with SMTP id 38308e7fff4ca-2eeb316b0a3mr106381171fa.35.1720866152214;
        Sat, 13 Jul 2024 03:22:32 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH7vvpnWwaVKMpGB+riYfC18de6PAMOaiBLRIWIG/7hx/butMAdcNiqMgXmgqH4ivpbWIeVCQ==
X-Received: by 2002:a2e:a603:0:b0:2ee:9521:1443 with SMTP id 38308e7fff4ca-2eeb316b0a3mr106381021fa.35.1720866151797;
        Sat, 13 Jul 2024 03:22:31 -0700 (PDT)
Received: from [192.168.10.47] ([151.95.101.29])
        by smtp.googlemail.com with ESMTPSA id 5b1f17b1804b1-427a5edb478sm15340875e9.33.2024.07.13.03.22.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 13 Jul 2024 03:22:30 -0700 (PDT)
Message-ID: <35aed712-d435-4660-a40a-ace7858218c4@redhat.com>
Date: Sat, 13 Jul 2024 12:22:29 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/2] Fix for a very old KVM bug in the segment cache
To: Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org
Cc: Dave Hansen <dave.hansen@linux.intel.com>,
 Thomas Gleixner <tglx@linutronix.de>, Borislav Petkov <bp@alien8.de>,
 x86@kernel.org, linux-kernel@vger.kernel.org,
 Sean Christopherson <seanjc@google.com>, Ingo Molnar <mingo@redhat.com>,
 "H. Peter Anvin" <hpa@zytor.com>
References: <20240713013856.1568501-1-mlevitsk@redhat.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Content-Language: en-US
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
In-Reply-To: <20240713013856.1568501-1-mlevitsk@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/13/24 03:38, Maxim Levitsky wrote:
> 1. Getting rid of the segment cache. I am not sure how much it helps
> these days - this code is very old.
> 
> 2. Using a read/write lock - IMHO the cleanest solution but might
> also affect performance.

A read/write lock would cause a deadlock between the writer and the 
sched_out callback, since they run on the same CPU.

I think the root cause of the issue is that clearing the cache should be 
done _after_ the writes (and should have a barrier() at the beginning, 
if only for cleanliness).  So your patch 1 should leave the clearing of 
vmx->segment_cache.bitmask where it was.

However, that would still leave an assumption: that it's okay that a 
sched_out during vmx_vcpu_reset() (or other functions that write segment 
data in the VMCS) accesses stale data, as long as the stale data is not 
used after vmx_vcpu_reset() returns.  Your patch is a safer approach, 
but maybe wrap preempt_disable()/preempt_enable() with

	vmx_invalidate_segment_cache_start() {
		preempt_disable();
	}
	vmx_invalidate_segment_cache_end() {
		vmx->segment_cache.bitmask = 0;
		preempt_enable();
	}

Paolo


