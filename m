Return-Path: <kvm+bounces-14571-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AA4438A36B2
	for <lists+kvm@lfdr.de>; Fri, 12 Apr 2024 22:01:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 601B4288173
	for <lists+kvm@lfdr.de>; Fri, 12 Apr 2024 20:01:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 943491514CA;
	Fri, 12 Apr 2024 20:01:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Mkoge/un"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6177A15099F
	for <kvm@vger.kernel.org>; Fri, 12 Apr 2024 20:01:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712952072; cv=none; b=hZSxcaZQeixtyE9PKsvLkI9vwSrJo97LHKC52gCUDxiujLICOeKHs9juSQ5HZ4aINPLfIVN1WDw9UzTQ/huOTj+ivCSNQzh6ujwldicCf+BIr/HSAMLX3+rYZYYobCiD4Dv/tsQDUM0fJr2Ex74wfmSXSM73cJyvURJo3+kO8VQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712952072; c=relaxed/simple;
	bh=RfXvG4D+PiYBd0esVP31hKS0NIBIfOKR75Y5NNor1+Q=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=aZmE83IelTmm2nhcHO7NSZmfbPM3zbeC/mDSck0n+edCXWAtXCQdo/v0AXV1mTgAphADPLOvge0pYaQorioOLXrBhgpMG/QQh0H8AcrMyoj4QszFuIS6RxcWa63TBYcIR0l8CkuhxOK1w6BdEP//dfG/dzBmcK8nd21Gl2YaZig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Mkoge/un; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1712952070;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=cJXZRHmv8/e3DunpfzJ0mbDtlVWEoORc9ryXYI3O8bI=;
	b=Mkoge/unwha5EFexYgDz/91Oeynt5lHivIGHcGwqJgcRWGQ0DsUHg5r5KqNrV83yzKyWoZ
	6O/D8fvI6U6Ej7cOgcPLrVgMib/JWwKqzDbNFmiajuAKDIhZ1JhlceMfJmNcKjggdIjMHy
	WLxh4+xqu4hsMPAQcpsQOc2bG/bUJ7w=
Received: from mail-lj1-f197.google.com (mail-lj1-f197.google.com
 [209.85.208.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-22-KrLX0LduODuSd4qfW4AIvA-1; Fri, 12 Apr 2024 16:01:08 -0400
X-MC-Unique: KrLX0LduODuSd4qfW4AIvA-1
Received: by mail-lj1-f197.google.com with SMTP id 38308e7fff4ca-2d880c1c295so12998151fa.2
        for <kvm@vger.kernel.org>; Fri, 12 Apr 2024 13:01:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712952066; x=1713556866;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=cJXZRHmv8/e3DunpfzJ0mbDtlVWEoORc9ryXYI3O8bI=;
        b=xMiXB+lzNwCGCIFVuxNC1rGi+LUJ4Rt88/yHgNN15n6jlXFqroFGp0Hu9Qwv3ZYCHS
         TRQlIRB3c+iaIRVpVAAOCd7DgyaU902yLFAmTyO959HXmcNfJZGU9N8Bgd0fuUb4NdnU
         71h5evE3/7Gn3aFEAlh0BxHTyYMQJV6yOJyWxPzpbUA7jpz0GU8nMUlZXLzQL+DIi31h
         REDZ7DIgNwvAgtVngxIX78yegkdPLLG3Pbkt+dqycGccUS2O62vj/B/SGh7EKWg18EV0
         VoM+nugkU8QB429i6VfA3Xz+xV0/0Jv0pjg0OvwPWwqgr8hx0QAmj+ixkTqvIkqZIZ/R
         2U8A==
X-Forwarded-Encrypted: i=1; AJvYcCVN8h1kshUHm3nTSqjLV0V/jOmjD+7LWSs587eMLnOATxQRcplyUINe5BxNqPoUjjKCG8QfQEwoHY6UOTWyfzH6cd00
X-Gm-Message-State: AOJu0Yy2rzCxnOj7Qi5ta2r8xulWeMryGKK0cZafprfo0TRsUeV3b9RV
	xsNyIrk1VZ8VNj+CicjRfu0uslrTwLl8wmzDEfhupg5+en3nyTPa16fbklJXzyaV9uwwGEKhhqg
	1Bm/2lQ9aEA0Q/EddWm9vO1zBXEfAPlC36/DykV7Z/sEseK9ovA==
X-Received: by 2002:a05:651c:2cf:b0:2d5:9bd4:4496 with SMTP id f15-20020a05651c02cf00b002d59bd44496mr2381527ljo.50.1712952066560;
        Fri, 12 Apr 2024 13:01:06 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH+1ZB86kc7lYTUaIgqoDegakDKAMCQ9kCvSW+1ih93sMlVewc37u5oJ4uI/kb1uzma3RPSWA==
X-Received: by 2002:a05:651c:2cf:b0:2d5:9bd4:4496 with SMTP id f15-20020a05651c02cf00b002d59bd44496mr2381503ljo.50.1712952066094;
        Fri, 12 Apr 2024 13:01:06 -0700 (PDT)
Received: from ?IPV6:2003:cb:c730:f600:afa2:4e8a:448a:9831? (p200300cbc730f600afa24e8a448a9831.dip0.t-ipconnect.de. [2003:cb:c730:f600:afa2:4e8a:448a:9831])
        by smtp.gmail.com with ESMTPSA id m38-20020a05600c3b2600b00417fdf4677asm2977868wms.14.2024.04.12.13.01.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Apr 2024 13:01:05 -0700 (PDT)
Message-ID: <5ed763c2-7e01-4c31-923c-ba62f0d0e993@redhat.com>
Date: Fri, 12 Apr 2024 22:01:03 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/4] KVM: delete .change_pte MMU notifier callback
To: Paolo Bonzini <pbonzini@redhat.com>, Peter Xu <peterx@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
 Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>,
 Tianrui Zhao <zhaotianrui@loongson.cn>, Bibo Mao <maobibo@loongson.cn>,
 Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
 Nicholas Piggin <npiggin@gmail.com>, Anup Patel <anup@brainfault.org>,
 Atish Patra <atishp@atishpatra.org>, Sean Christopherson
 <seanjc@google.com>, Andrew Morton <akpm@linux-foundation.org>,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
 loongarch@lists.linux.dev, linux-mips@vger.kernel.org,
 linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org,
 linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org,
 linux-perf-users@vger.kernel.org, Andrea Arcangeli <aarcange@redhat.com>
References: <20240405115815.3226315-1-pbonzini@redhat.com>
 <20240405115815.3226315-2-pbonzini@redhat.com> <ZhP3hDhe2Qwo9oCL@x1n>
 <CABgObfYwwXy9gQap-PJyOrVCcUr-VfK90AKNaRe0VO-G00G8SQ@mail.gmail.com>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <CABgObfYwwXy9gQap-PJyOrVCcUr-VfK90AKNaRe0VO-G00G8SQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 11.04.24 18:55, Paolo Bonzini wrote:
> On Mon, Apr 8, 2024 at 3:56 PM Peter Xu <peterx@redhat.com> wrote:
>> Paolo,
>>
>> I may miss a bunch of details here (as I still remember some change_pte
>> patches previously on the list..), however not sure whether we considered
>> enable it?  Asked because I remember Andrea used to have a custom tree
>> maintaining that part:
>>
>> https://github.com/aagit/aa/commit/c761078df7a77d13ddfaeebe56a0f4bc128b1968
> 
> The patch enables it only for KSM, so it would still require a bunch
> of cleanups, for example I also would still use set_pte_at() in all
> the places that are not KSM. This would at least fix the issue with
> the poor documentation of where to use set_pte_at_notify() vs
> set_pte_at().
> 
> With regard to the implementation, I like the idea of disabling the
> invalidation on the MMU notifier side, but I would rather have
> MMU_NOTIFIER_CHANGE_PTE as a separate field in the range instead of
> overloading the event field.
> 
>> Maybe it can't be enabled for some reason that I overlooked in the current
>> tree, or we just decided to not to?
> 
> I have just learnt about the patch, nobody had ever mentioned it even
> though it's almost 2 years old... It's a lot of code though and no one

I assume Andrea used it on his tree where he also has a version of 
"randprotect" (even included in that commit subject) to mitigate a KSM 
security issue that was reported by some security researchers [1] a 
while ago. From what I recall, the industry did not end up caring about 
that security issue that much.

IIUC, with "randprotect" we get a lot more R/O protection even when not 
de-duplicating a page -- thus the name. Likely, the reporter mentioned 
in the commit is a researcher that played with Andreas fix for the 
security issue. But I'm just speculating at this point :)

> has ever reported an issue for over 10 years, so I think it's easiest
> to just rip the code out.

Yes. Can always be readded in a possibly cleaner fashion (like you note 
above), when deemed necessary and we are willing to support it.

[1] https://gruss.cc/files/remote_dedup.pdf

-- 
Cheers,

David / dhildenb


