Return-Path: <kvm+bounces-1841-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 01F467ECA43
	for <lists+kvm@lfdr.de>; Wed, 15 Nov 2023 19:10:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B09B92810B5
	for <lists+kvm@lfdr.de>; Wed, 15 Nov 2023 18:10:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 158722E629;
	Wed, 15 Nov 2023 18:10:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CuZ2nQJW"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDB09187
	for <kvm@vger.kernel.org>; Wed, 15 Nov 2023 10:10:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1700071841;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=G26Q+pxS8s09wKVuDjO+e992p0wNXwDweuDLtOZfdxk=;
	b=CuZ2nQJWjADNOp7KIOWA2rFI+/0HHi3cjO1FQHj/R774KSgjZcjwvJ6g8PqpMOnyiClhNs
	cG34oR7i8mADWFQNVBQjHLmd2GpXznBhXJCAabVzo3sf92+OvCiSat426h9ZFIg/RM/L9B
	ZDd1ouEi61lXj3YFdgVMZJxVnApfJJE=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-471-pIXOeJ7xMXKmN9az5uVtDQ-1; Wed, 15 Nov 2023 13:10:40 -0500
X-MC-Unique: pIXOeJ7xMXKmN9az5uVtDQ-1
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-4094158c899so44450245e9.3
        for <kvm@vger.kernel.org>; Wed, 15 Nov 2023 10:10:40 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700071839; x=1700676639;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt:from
         :references:cc:to:content-language:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=G26Q+pxS8s09wKVuDjO+e992p0wNXwDweuDLtOZfdxk=;
        b=HRp40a0dQuU685e5Ns/yQBeF8GjBRreS7nMa+QD1TYfzk/HUsirI+ZdY6sr1F8ROog
         vPo+7DhHbPBSWd/be3XXpPAhaATpQhMPIzzGyA+QLxWp3V8zeRxNkwCWEv/13JOa3EJi
         Zys1bnmpj2cg0Z+qwqARS4dm3ppaHIs2av/2qtrTn9icYTtL2/RIJH1ignOZyMBpTClG
         /OelleMQqlgNhdjFhcG/0636CmCmhCFAC1X5kvGivZ+UkIhB/P5kajTM5J8b0bbTloU6
         XSTLcn0jsiMNt58X7ziWrip535wsBi1GbhXChAGrMc0Z91cJZtRVCzdbm37hdAd0vJoQ
         K93w==
X-Gm-Message-State: AOJu0YxNE0C/NBIrGDaL7BAWNA+ytuMuV6EirjX2D8BIHzKzuN0fpucZ
	3Eg4HPkUdGWG0lKYDwmcu9Q0WJMmhxsTflnRgIFEpFd8SinOf81PMVzJ36DjLIAbozp0FSutUSY
	B7pUDv+QkPxGO
X-Received: by 2002:a05:600c:3b03:b0:406:535a:cfb4 with SMTP id m3-20020a05600c3b0300b00406535acfb4mr109790wms.1.1700071839470;
        Wed, 15 Nov 2023 10:10:39 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFWPLGqv1Trj9TK3Rp0EBXqDfHnOQRzyGK0LXlLgkXJDTjhmIk797XC/+D1Yny6LpnE9jdAcw==
X-Received: by 2002:a05:600c:3b03:b0:406:535a:cfb4 with SMTP id m3-20020a05600c3b0300b00406535acfb4mr109753wms.1.1700071839010;
        Wed, 15 Nov 2023 10:10:39 -0800 (PST)
Received: from ?IPV6:2003:cb:c706:ed00:59ee:f048:4ed9:62a6? (p200300cbc706ed0059eef0484ed962a6.dip0.t-ipconnect.de. [2003:cb:c706:ed00:59ee:f048:4ed9:62a6])
        by smtp.gmail.com with ESMTPSA id c15-20020a5d4f0f000000b0032db430fb9bsm11167394wru.68.2023.11.15.10.10.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Nov 2023 10:10:38 -0800 (PST)
Message-ID: <bc84fa4f-4866-4321-8f30-1388eed7e64f@redhat.com>
Date: Wed, 15 Nov 2023 19:10:37 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 03/70] RAMBlock/guest_memfd: Enable
 KVM_GUEST_MEMFD_ALLOW_HUGEPAGE
Content-Language: en-US
To: Xiaoyao Li <xiaoyao.li@intel.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Igor Mammedov <imammedo@redhat.com>, "Michael S . Tsirkin" <mst@redhat.com>,
 Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
 Richard Henderson <richard.henderson@linaro.org>,
 Peter Xu <peterx@redhat.com>, =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?=
 <philmd@linaro.org>, Cornelia Huck <cohuck@redhat.com>,
 =?UTF-8?Q?Daniel_P_=2E_Berrang=C3=A9?= <berrange@redhat.com>,
 Eric Blake <eblake@redhat.com>, Markus Armbruster <armbru@redhat.com>,
 Marcelo Tosatti <mtosatti@redhat.com>
Cc: qemu-devel@nongnu.org, kvm@vger.kernel.org,
 Michael Roth <michael.roth@amd.com>, Sean Christopherson
 <seanjc@google.com>, Claudio Fontana <cfontana@suse.de>,
 Gerd Hoffmann <kraxel@redhat.com>, Isaku Yamahata
 <isaku.yamahata@gmail.com>, Chenyi Qiang <chenyi.qiang@intel.com>
References: <20231115071519.2864957-1-xiaoyao.li@intel.com>
 <20231115071519.2864957-4-xiaoyao.li@intel.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <20231115071519.2864957-4-xiaoyao.li@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 15.11.23 08:14, Xiaoyao Li wrote:
> KVM allows KVM_GUEST_MEMFD_ALLOW_HUGEPAGE for guest memfd. When the
> flag is set, KVM tries to allocate memory with transparent hugeapge at
> first and falls back to non-hugepage on failure.
> 
> However, KVM defines one restriction that size must be hugepage size
> aligned when KVM_GUEST_MEMFD_ALLOW_HUGEPAGE is set.
> 
> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
> ---
> v3:
>   - New one in v3.
> ---
>   system/physmem.c | 38 ++++++++++++++++++++++++++++++++++++--
>   1 file changed, 36 insertions(+), 2 deletions(-)
> 
> diff --git a/system/physmem.c b/system/physmem.c
> index 0af2213cbd9c..c56b17e44df6 100644
> --- a/system/physmem.c
> +++ b/system/physmem.c
> @@ -1803,6 +1803,40 @@ static void dirty_memory_extend(ram_addr_t old_ram_size,
>       }
>   }
>   
> +#ifdef CONFIG_KVM
> +#define HPAGE_PMD_SIZE_PATH "/sys/kernel/mm/transparent_hugepage/hpage_pmd_size"
> +#define DEFAULT_PMD_SIZE (1ul << 21)
> +
> +static uint32_t get_thp_size(void)
> +{
> +    gchar *content = NULL;
> +    const char *endptr;
> +    static uint64_t thp_size = 0;
> +    uint64_t tmp;
> +
> +    if (thp_size != 0) {
> +        return thp_size;
> +    }
> +
> +    if (g_file_get_contents(HPAGE_PMD_SIZE_PATH, &content, NULL, NULL) &&
> +        !qemu_strtou64(content, &endptr, 0, &tmp) &&
> +        (!endptr || *endptr == '\n')) {
> +        /* Sanity-check the value and fallback to something reasonable. */
> +        if (!tmp || !is_power_of_2(tmp)) {
> +            warn_report("Read unsupported THP size: %" PRIx64, tmp);
> +        } else {
> +            thp_size = tmp;
> +        }
> +    }
> +
> +    if (!thp_size) {
> +        thp_size = DEFAULT_PMD_SIZE;
> +    }

... did you shamelessly copy that from hw/virtio/virtio-mem.c ? ;)

This should be factored out into a common helper.

-- 
Cheers,

David / dhildenb


