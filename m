Return-Path: <kvm+bounces-44309-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C14F5A9C91C
	for <lists+kvm@lfdr.de>; Fri, 25 Apr 2025 14:42:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3A0909C4B2B
	for <lists+kvm@lfdr.de>; Fri, 25 Apr 2025 12:42:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CC27424C07D;
	Fri, 25 Apr 2025 12:42:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="C82zAQJL"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F50F4438B
	for <kvm@vger.kernel.org>; Fri, 25 Apr 2025 12:42:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745584941; cv=none; b=ThcRTbSNHiIvRv0zad87R3kLivQU9ISwvCYPPx5nLF7uLUmJBtSJZpEZfwd3ykqsJQFfU0QM9HYhoREDamHCf8EuEAyT7aGfdFqjOxHDa9dDvchAF9WRTMTpIOmAEFv7Ce3PbZ6qnD8QH629z7V/tg5xdKvVx+U/F36g62/UGq8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745584941; c=relaxed/simple;
	bh=bfB7dXcwZDXyy3nG5WKn0b6K8CEszTHMRwRMx8HWdBs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=RWmuh+g7iZ9xHzWwFeNOOAHeZT0El23azHJyOlRE6mPqkrwS2zApzodrHwiXX5493E4zgmulaRUgtHdOYaooy5CVoeVA52LMqFnZvxyvBKBWmX8+wL7UAj3PfrjBe4pJeERQzBrd5swNgjOizko7FWnewAbA1llTH6w0Y6o4fOg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=C82zAQJL; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1745584936;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=pXNNqoi19Ba69uwcAj3Kv/k/r4tm7gG4ENXbwT+pfM0=;
	b=C82zAQJLlfFuYwr+/1B+gl2cRuHWWbeSERoIW7pLHMA/zmwTQjHLI+nMFIJvvFFPqZb+yK
	n0+LrnwJhC7tPWbKA9QV20COa6HdZ4FGa77nflKBBDfAGtrXVLG8VnaGp3cxMhsr/PNdms
	lutCVOycmyMTzwOG5CKmJjqZWoDwbc4=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-534-unqmdB_NM_y37NbGioX1EA-1; Fri, 25 Apr 2025 08:42:15 -0400
X-MC-Unique: unqmdB_NM_y37NbGioX1EA-1
X-Mimecast-MFC-AGG-ID: unqmdB_NM_y37NbGioX1EA_1745584934
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-3978ef9a284so783981f8f.3
        for <kvm@vger.kernel.org>; Fri, 25 Apr 2025 05:42:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745584934; x=1746189734;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=pXNNqoi19Ba69uwcAj3Kv/k/r4tm7gG4ENXbwT+pfM0=;
        b=RaREGIaEbxluKUP9CEs3MMSbpJt4nUijVdO6m0nOyco8dWwAGS8B8xpp7+C+basb5W
         8aqFW2LlFoKttywLupYQUCHmZMYdP6kw3L3AJbBsXANHu15n4T+htqpxlF8MEVhjJZ4a
         SN6ouci36XQNvBqaIhHOG1DHRYZS2KhcHCa1x8Ptdru4rnDPmr65RvR888PnOwYi6he4
         YVgzIHlMfrRheXblam1VYEiLy09aghyOjS9vz5ng5WbAYdH021/oPAP6P8eopHanCCAZ
         Nhic3H9Uw3pHPmp/zG2xO7jClzdHRrrAfgivP7gmKoBO9/U/tvE0hNK/pAh129nxJhBa
         ykYg==
X-Forwarded-Encrypted: i=1; AJvYcCUxYiD5sWCExnd5KQ7l1xAwthnG21Iq16ouZDsfFrXqHnajDn5aZZFDU/zEtUyVnM7C9Hs=@vger.kernel.org
X-Gm-Message-State: AOJu0YyuVv2nvZV1PlNvESnJrbKrZrzzmgNMFg9ysOSJClqAT5Ze7HOE
	qhfA81ciqw1qCfSSO97j8Zb1s++qIT3iZt2pGo3dnvupWmvQwP2YI7yT+B0MLA4eK07/cG9oKpV
	E0tTmZnTLr0ScbfmH9A70FG78V1TSMnFJ7EA7mQoU1LocA3CYNw==
X-Gm-Gg: ASbGnctAdhlT+eAWoNoyD54XPsy0wSCv+4qQoVWcpwJZhSbxuLrhm15SXC7qTFfgiMd
	fxgz6/8/5w41Cdi80TuM703T8pGn/p0FM6wNaoNChsNBpxzvIRTl8pnHcskxSWi1vFv5AvUH6tu
	TJkzbGtVCyQbUlimN9j3IAxZJzzGVEz/QxPeq5GIqowqBAa2TZr4p7VKSVfjTGvk1rHkbiqVXrf
	QZ296VJFkqTu0KVCqpCbSYIVBMVyXEyrARcAYeHBbcHbXAesOVYrcEycjLQv4a6Qx1VnVcqDD45
	XpLhtHzIBA1zSXNzksxNjD91jkWT77u7xH6tYh1ND+6sD4mgPYCsb2UW1sC4yvzJg5LHr5CrxWL
	SW+Uz5vUl9tspAuZDE3AAMYYUeZv8wOv1pwxV
X-Received: by 2002:a5d:64a3:0:b0:39a:c467:a095 with SMTP id ffacd0b85a97d-3a074e1f72emr1656243f8f.24.1745584934397;
        Fri, 25 Apr 2025 05:42:14 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH0dQmSUnE83lfcUweDIFLTRC1sLPiRsqAP2bvMHN9DAFRKWHykYVNejLYQ7r8QtFrIL6ZU8A==
X-Received: by 2002:a5d:64a3:0:b0:39a:c467:a095 with SMTP id ffacd0b85a97d-3a074e1f72emr1656216f8f.24.1745584934001;
        Fri, 25 Apr 2025 05:42:14 -0700 (PDT)
Received: from ?IPV6:2003:cb:c70f:6900:6c56:80f8:c14:6d2a? (p200300cbc70f69006c5680f80c146d2a.dip0.t-ipconnect.de. [2003:cb:c70f:6900:6c56:80f8:c14:6d2a])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a073e5d264sm2295556f8f.95.2025.04.25.05.42.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 25 Apr 2025 05:42:13 -0700 (PDT)
Message-ID: <37cace3c-942e-457d-8a1a-fa37050428a7@redhat.com>
Date: Fri, 25 Apr 2025 14:42:12 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 03/13] memory: Unify the definiton of
 ReplayRamPopulate() and ReplayRamDiscard()
To: Chenyi Qiang <chenyi.qiang@intel.com>, Alexey Kardashevskiy
 <aik@amd.com>, Peter Xu <peterx@redhat.com>,
 Gupta Pankaj <pankaj.gupta@amd.com>, Paolo Bonzini <pbonzini@redhat.com>,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 Michael Roth <michael.roth@amd.com>
Cc: qemu-devel@nongnu.org, kvm@vger.kernel.org,
 Williams Dan J <dan.j.williams@intel.com>,
 Peng Chao P <chao.p.peng@intel.com>, Gao Chao <chao.gao@intel.com>,
 Xu Yilun <yilun.xu@intel.com>, Li Xiaoyao <xiaoyao.li@intel.com>
References: <20250407074939.18657-1-chenyi.qiang@intel.com>
 <20250407074939.18657-4-chenyi.qiang@intel.com>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <20250407074939.18657-4-chenyi.qiang@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 07.04.25 09:49, Chenyi Qiang wrote:
> Update ReplayRamDiscard() function to return the result and unify the
> ReplayRamPopulate() and ReplayRamDiscard() to ReplayStateChange() at
> the same time due to their identical definitions. This unification
> simplifies related structures, such as VirtIOMEMReplayData, which makes
> it more cleaner and maintainable.
> 
> Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>
> ---
> Changes in v4:
>      - Modify the commit message. We won't use Replay() operation when
>        doing the attribute change like v3.
> 
> Changes in v3:
>      - Newly added.
> ---

[...]

>   
> -typedef int (*ReplayRamPopulate)(MemoryRegionSection *section, void *opaque);
> -typedef void (*ReplayRamDiscard)(MemoryRegionSection *section, void *opaque);
> +typedef int (*ReplayStateChange)(MemoryRegionSection *section, void *opaque);
>   

But it's not a state change.

ReplayRamState maybe?

[...]
>   /*
> diff --git a/system/memory.c b/system/memory.c
> index 62d6b410f0..b5ab729e13 100644
> --- a/system/memory.c
> +++ b/system/memory.c
> @@ -2147,7 +2147,7 @@ bool ram_discard_manager_is_populated(const RamDiscardManager *rdm,
>   
>   int ram_discard_manager_replay_populated(const RamDiscardManager *rdm,
>                                            MemoryRegionSection *section,
> -                                         ReplayRamPopulate replay_fn,
> +                                         ReplayStateChange replay_fn,
>                                            void *opaque)
>   {
>       RamDiscardManagerClass *rdmc = RAM_DISCARD_MANAGER_GET_CLASS(rdm);
> @@ -2156,15 +2156,15 @@ int ram_discard_manager_replay_populated(const RamDiscardManager *rdm,
>       return rdmc->replay_populated(rdm, section, replay_fn, opaque);
>   }
>   
> -void ram_discard_manager_replay_discarded(const RamDiscardManager *rdm,
> -                                          MemoryRegionSection *section,
> -                                          ReplayRamDiscard replay_fn,
> -                                          void *opaque)
> +int ram_discard_manager_replay_discarded(const RamDiscardManager *rdm,
> +                                         MemoryRegionSection *section,
> +                                         ReplayStateChange replay_fn,
> +                                         void *opaque)
>   {
>       RamDiscardManagerClass *rdmc = RAM_DISCARD_MANAGER_GET_CLASS(rdm);
>   
>       g_assert(rdmc->replay_discarded);
> -    rdmc->replay_discarded(rdm, section, replay_fn, opaque);
> +    return rdmc->replay_discarded(rdm, section, replay_fn, opaque);
>   }

The idea was that ram_discard_manager_replay_discarded() would never be 
able to fail. But I don't think this really matters, because the 
function is provided by the caller, that can just always return 0 -- 
like we do in dirty_bitmap_clear_section() now.

So yeah, this looks fine to me, given that we don't call it a "state 
change" when we are merely replaying a selected state.

-- 
Cheers,

David / dhildenb


