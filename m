Return-Path: <kvm+bounces-47699-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 6DEA1AC3CFF
	for <lists+kvm@lfdr.de>; Mon, 26 May 2025 11:36:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 291091728D9
	for <lists+kvm@lfdr.de>; Mon, 26 May 2025 09:36:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3B62C1EF09D;
	Mon, 26 May 2025 09:36:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="CZTWACry"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68404136349
	for <kvm@vger.kernel.org>; Mon, 26 May 2025 09:36:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748252164; cv=none; b=aZNDehBAch6NLuJImvTjEUQnd9v8ZKPVF9BaUtBP10K7KAsRCRBGWj3EMX2dYnsvWsruAx05zhziV0B6uS9wVLD50WEquE0cD88YNOFP5ljAbXhgkXL17+QuKJE+CKaK9lZYWMYytZXw+W+mQJemwIPPOz3LS0dWON3H1Sr+I3U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748252164; c=relaxed/simple;
	bh=NpPGxhFb2ozkPaAbbpJeZm9PLRHE0s0HUmDWS53LwhY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=AOsXuQviE55DuVcjgEnDkK6gOxfxXPpSInP0iIrSfGYmHYMBy2ljO0irXXWxs2ueoeYQcvqdNPQGfyh1M9KgUYO7IAE2tMXWU38kVfVzq3XeIPbdLn1M3/dnTPWCozPLBW5+RDzkqucFflpk6GN156+FtCCcP6Srt2X1xtDMOOQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=CZTWACry; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-442e9c00bf4so13789175e9.3
        for <kvm@vger.kernel.org>; Mon, 26 May 2025 02:36:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1748252161; x=1748856961; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=HkENEDwTrOUlcFOPP9qwiQ9HYFQ61KmkI7052U8Azv8=;
        b=CZTWACryKVfFBp1wgfuiDDVbaM7pQKngh33KYFoKen/VLcd6Fgk0V8EBn04MRCyNoW
         cA8ejBIlnzrJLFNHM9NaDWXh/DxNhHcEmCmESAyspncDmI2pTyQUVe5kgyvSlUGLBmjT
         jH0rRtsMhJcUv8gmuIh6MIQxBCrx9+N70pDnnA2og+TLZZPdozccAkbI+Dhlefib8ych
         LeKFGqxI95yuki55XOSnCm1vlMeCx76JpT3ybiHiaRDwxwXm8SGmL8PTS575TxeVAagU
         JYpWGzdwFIebF7ikmAhEWt7Ocof5hEvGzG38FOJX+TdTTGuplXvTA64QpaNvb+scjV+Z
         puvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748252161; x=1748856961;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HkENEDwTrOUlcFOPP9qwiQ9HYFQ61KmkI7052U8Azv8=;
        b=bTEhoIE1g1wIn8opZRqZnNvrp0iTA7+3f0RSr5kivanUaGXmdyU4FxYCDTiyKNue/w
         A4+jg7WOssLtW+3Rwxpo3Fg6Wz9Ju8s8zwTJSQq5PJXFyL1bVz0BWlQduh5X7X1dUL/S
         kH0LCTVGcJxSN1b4f2g8Fy8EvgBxQg1bAGM1beaQf9I308aZ7ePKs8YdaoRIVFs7Dc57
         ojEYVqKBvXFPeZjwfOsDazFr7oxYb/n8Itg5tUWyDLYOpBMCCjfjfk2RJ+EAliiGEEyB
         3Xac8Gr0ol13Oh6YLlDs9a/6SeqEjUz88BjPqS9X63pGL4i71XPXTcofzzTTHYnxbD+W
         n6Pg==
X-Forwarded-Encrypted: i=1; AJvYcCVujFqjCL0OQrBJUBLFOg1JujtCAC7X1akK+GmTUzZxJfeQk0FWi3pEMFWiN+ghCLTRkCg=@vger.kernel.org
X-Gm-Message-State: AOJu0YzY0DYL7iKn82/nio93hxi9qCP51E4U5OzIScsgFhU9twx8r7+R
	ghbJeVxXRtfGdtPmvc5S7jCPjnpU5dkaK6nnWaxEKQPCLxhiL45KVOZqOfyCuGhxGpg=
X-Gm-Gg: ASbGncsdn83ZTBRgxksPHFZ2DK12XJ/QlbQh8QkLdZHzxS+cufz+WdP3Ei3VqITC5eX
	y2ST+fLDJBUUKPyqm88UqN+cvjKAMdXbCZOiAEs/YHGbpVJC+RrjUqJwT0dzYfjncmCNNTUwont
	aOrivl36rxIi8uo8T6ld8iRFclJbdjE5tizTeb1Zcc324kg4m3wK44sYcphgCfVX7eW7TNlJvU5
	MKhvgpoid/Yz3UflJqc/9YIepFTwm5lm4jqwVe8Ac1gmhDzmJXAdFtddzFcvx/gePIXgKuUZv7H
	9zPOR/TNkpyYkFf0DepERY8PVkQw0+qDNg++HXbVpeoFpDQImft1cd+eRVfj+3mfuJreMmu6RQ9
	ZxgRT+NtM0EIsgWNqCXHUitOq
X-Google-Smtp-Source: AGHT+IGKj/M2WcKFmwle9OkS5/LAr7IGfFBXu4u7qW1Da7kO2fKVjzchrg8JxR17GB8ljC9mQ1ktfw==
X-Received: by 2002:a05:600c:8112:b0:43d:47e:3205 with SMTP id 5b1f17b1804b1-44c935dd583mr65118765e9.11.1748252160731;
        Mon, 26 May 2025 02:36:00 -0700 (PDT)
Received: from [192.168.69.138] (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-447f23bfe80sm228185335e9.20.2025.05.26.02.35.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 26 May 2025 02:36:00 -0700 (PDT)
Message-ID: <dca6ed89-e704-44ce-b9f1-deb3c6dd8dc3@linaro.org>
Date: Mon, 26 May 2025 11:35:59 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 03/10] memory: Unify the definiton of
 ReplayRamPopulate() and ReplayRamDiscard()
To: Chenyi Qiang <chenyi.qiang@intel.com>,
 David Hildenbrand <david@redhat.com>, Alexey Kardashevskiy <aik@amd.com>,
 Peter Xu <peterx@redhat.com>, Gupta Pankaj <pankaj.gupta@amd.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Michael Roth <michael.roth@amd.com>
Cc: qemu-devel@nongnu.org, kvm@vger.kernel.org,
 Williams Dan J <dan.j.williams@intel.com>, Zhao Liu <zhao1.liu@intel.com>,
 Baolu Lu <baolu.lu@linux.intel.com>, Gao Chao <chao.gao@intel.com>,
 Xu Yilun <yilun.xu@intel.com>, Li Xiaoyao <xiaoyao.li@intel.com>
References: <20250520102856.132417-1-chenyi.qiang@intel.com>
 <20250520102856.132417-4-chenyi.qiang@intel.com>
Content-Language: en-US
From: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
In-Reply-To: <20250520102856.132417-4-chenyi.qiang@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Chenyi Qiang,

On 20/5/25 12:28, Chenyi Qiang wrote:
> Update ReplayRamDiscard() function to return the result and unify the
> ReplayRamPopulate() and ReplayRamDiscard() to ReplayRamDiscardState() at
> the same time due to their identical definitions. This unification
> simplifies related structures, such as VirtIOMEMReplayData, which makes
> it cleaner.
> 
> Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>
> ---
> Changes in v5:
>      - Rename ReplayRamStateChange to ReplayRamDiscardState (David)
>      - return data->fn(s, data->opaque) instead of 0 in
>        virtio_mem_rdm_replay_discarded_cb(). (Alexey)
> 
> Changes in v4:
>      - Modify the commit message. We won't use Replay() operation when
>        doing the attribute change like v3.
> 
> Changes in v3:
>      - Newly added.
> ---
>   hw/virtio/virtio-mem.c  | 21 ++++++++++-----------
>   include/system/memory.h | 36 +++++++++++++++++++-----------------
>   migration/ram.c         |  5 +++--
>   system/memory.c         | 12 ++++++------
>   4 files changed, 38 insertions(+), 36 deletions(-)


> diff --git a/include/system/memory.h b/include/system/memory.h
> index 896948deb1..83b28551c4 100644
> --- a/include/system/memory.h
> +++ b/include/system/memory.h
> @@ -575,8 +575,8 @@ static inline void ram_discard_listener_init(RamDiscardListener *rdl,
>       rdl->double_discard_supported = double_discard_supported;
>   }
>   
> -typedef int (*ReplayRamPopulate)(MemoryRegionSection *section, void *opaque);
> -typedef void (*ReplayRamDiscard)(MemoryRegionSection *section, void *opaque);
> +typedef int (*ReplayRamDiscardState)(MemoryRegionSection *section,
> +                                     void *opaque);

While changing this prototype, please add a documentation comment.

>   /*
>    * RamDiscardManagerClass:
> @@ -650,36 +650,38 @@ struct RamDiscardManagerClass {
>       /**
>        * @replay_populated:
>        *
> -     * Call the #ReplayRamPopulate callback for all populated parts within the
> -     * #MemoryRegionSection via the #RamDiscardManager.
> +     * Call the #ReplayRamDiscardState callback for all populated parts within
> +     * the #MemoryRegionSection via the #RamDiscardManager.
>        *
>        * In case any call fails, no further calls are made.
>        *
>        * @rdm: the #RamDiscardManager
>        * @section: the #MemoryRegionSection
> -     * @replay_fn: the #ReplayRamPopulate callback
> +     * @replay_fn: the #ReplayRamDiscardState callback
>        * @opaque: pointer to forward to the callback
>        *
>        * Returns 0 on success, or a negative error if any notification failed.
>        */
>       int (*replay_populated)(const RamDiscardManager *rdm,
>                               MemoryRegionSection *section,
> -                            ReplayRamPopulate replay_fn, void *opaque);
> +                            ReplayRamDiscardState replay_fn, void *opaque);
>   
>       /**
>        * @replay_discarded:
>        *
> -     * Call the #ReplayRamDiscard callback for all discarded parts within the
> -     * #MemoryRegionSection via the #RamDiscardManager.
> +     * Call the #ReplayRamDiscardState callback for all discarded parts within
> +     * the #MemoryRegionSection via the #RamDiscardManager.
>        *
>        * @rdm: the #RamDiscardManager
>        * @section: the #MemoryRegionSection
> -     * @replay_fn: the #ReplayRamDiscard callback
> +     * @replay_fn: the #ReplayRamDiscardState callback
>        * @opaque: pointer to forward to the callback
> +     *
> +     * Returns 0 on success, or a negative error if any notification failed.
>        */
> -    void (*replay_discarded)(const RamDiscardManager *rdm,
> -                             MemoryRegionSection *section,
> -                             ReplayRamDiscard replay_fn, void *opaque);
> +    int (*replay_discarded)(const RamDiscardManager *rdm,
> +                            MemoryRegionSection *section,
> +                            ReplayRamDiscardState replay_fn, void *opaque);
>   
>       /**
>        * @register_listener:
> @@ -722,13 +724,13 @@ bool ram_discard_manager_is_populated(const RamDiscardManager *rdm,
>   
>   int ram_discard_manager_replay_populated(const RamDiscardManager *rdm,
>                                            MemoryRegionSection *section,
> -                                         ReplayRamPopulate replay_fn,
> +                                         ReplayRamDiscardState replay_fn,
>                                            void *opaque);
>   
> -void ram_discard_manager_replay_discarded(const RamDiscardManager *rdm,
> -                                          MemoryRegionSection *section,
> -                                          ReplayRamDiscard replay_fn,
> -                                          void *opaque);
> +int ram_discard_manager_replay_discarded(const RamDiscardManager *rdm,
> +                                         MemoryRegionSection *section,
> +                                         ReplayRamDiscardState replay_fn,
> +                                         void *opaque);

Similar for ram_discard_manager_replay_populated() and
ram_discard_manager_replay_discarded(), since you understood
what they do :)

Thanks!

Phil.


