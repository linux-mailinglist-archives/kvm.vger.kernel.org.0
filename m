Return-Path: <kvm+bounces-7027-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E4EF083CB7A
	for <lists+kvm@lfdr.de>; Thu, 25 Jan 2024 19:46:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5E5A21F269BB
	for <lists+kvm@lfdr.de>; Thu, 25 Jan 2024 18:46:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8FD981339A1;
	Thu, 25 Jan 2024 18:46:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Hj7ibSXs"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E569745F9
	for <kvm@vger.kernel.org>; Thu, 25 Jan 2024 18:46:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706208370; cv=none; b=B8Blc+jh7Ibg3d6gI9U5JMVMOt/BuuGXZ7Q2hCqjjnuwBbCcIJSP489kbOOLQ/a+hZsDaivEO5wc3By1uQvsqN3IkjWBGtdjfNfHaqXm2eyvwe7BRPdIlpnQ4NrGgSX8I8bBB0UtN0mHtJ1h5E3HDCdHduNk5MyCfLRna6mi+O8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706208370; c=relaxed/simple;
	bh=X8gtw+6sPhHFrX4EEUPQEk0b2Gu6tUcREsJdBh5ZwgE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=etN0u55jDY+PQuHMEVkVEGNCaGoIFVLqUK6gw2FMPEJJSR6+c/2RJR1XxZkh/VP5LRK0WChEIdcD9jqxAO2N0F/PluAix9EspJSAKuKvRfP3DJVkhHqtZgVSzLfmM4o72bLyAJuFCOtm7BddQSIfaWNa0377au4NOPqGLngVzvA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Hj7ibSXs; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1706208368;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=VWpmi7LO4VxYQxol3n4KhfY1ItMFl+LdRWqvj1coi1Y=;
	b=Hj7ibSXsOk0VkpPA/Wa9QkwzSPogiwmz+M0lYXgbitK+jor+WnIoxQA1K9wANz73aAz2zW
	MKYOqiIuPcqkzqtCghxirMMsn5Ff+c8IrfTWmxyVhfEO6AKfFk1RNcmB4yMqg83fFyDPih
	RTNLFigIevcjg7nIAkcte6W5QoRPsM8=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-253-ChCGdPO0OyWUmcEU9bRq0A-1; Thu, 25 Jan 2024 13:46:06 -0500
X-MC-Unique: ChCGdPO0OyWUmcEU9bRq0A-1
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-339274a4c86so2673952f8f.1
        for <kvm@vger.kernel.org>; Thu, 25 Jan 2024 10:46:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706208361; x=1706813161;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt:from
         :references:cc:to:content-language:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VWpmi7LO4VxYQxol3n4KhfY1ItMFl+LdRWqvj1coi1Y=;
        b=aT8rU73Eh3dBiBUyf0ZuTRjS133OGY/elwN/EhVYogsiwpegB3lqkQFQAmc/YKtmVT
         kpCEr74DKi5qWvCJlqIHeohQ6Z4NdLlU3CiGh2xmpUr3no6YJusqyyCHNOfw7i5t+K3H
         BjUWq+y/XaBlSSiDCfywaAc1O/ZqElAae7RKqP5vsqwPZ2sc0LAMSQxge/bWdkjdwHFP
         7DZU4p/V9O3E40cr8UCzf2IwbbqeABgs4ubhm6eEww/o60fIuje7ixH06rFUhb9KrhEx
         35Q5WvBeqSDVJRMWzty3ed7NfMwAfst4BAtL2Ny4z3x29LCoaas4Ujf75RWN43Cu9k9n
         dDQA==
X-Gm-Message-State: AOJu0YxySBno5ju3g12aPs2HLXyeug8tYsyAtvH8LDlAMjlFE7LYFZuk
	Uhr0ST5RWv4RhgwYViFyryO1TWYr75W9y2wH0F8HuZPT05mZr4oaYuLfv6N9oHk9rI5Y3pb+nY/
	IciGAiuprtY3Yb1ozh1YKhHVHhZEQjvjB7Aipo4IApu0RBy6tMA==
X-Received: by 2002:adf:eb0b:0:b0:33a:ccfe:e21a with SMTP id s11-20020adfeb0b000000b0033accfee21amr40884wrn.6.1706208361205;
        Thu, 25 Jan 2024 10:46:01 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHkom4+LjvtplnF2zJocjyN3nCHNgQT0cRMd8j+r8FryCXjaKLlmu1vMSMWu7tKSaqF+UKxdQ==
X-Received: by 2002:adf:eb0b:0:b0:33a:ccfe:e21a with SMTP id s11-20020adfeb0b000000b0033accfee21amr40850wrn.6.1706208360757;
        Thu, 25 Jan 2024 10:46:00 -0800 (PST)
Received: from ?IPV6:2003:cb:c70a:7600:9a0b:ceef:a304:b9a7? (p200300cbc70a76009a0bceefa304b9a7.dip0.t-ipconnect.de. [2003:cb:c70a:7600:9a0b:ceef:a304:b9a7])
        by smtp.gmail.com with ESMTPSA id e15-20020a5d530f000000b003391720fa51sm16351561wrv.60.2024.01.25.10.45.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 25 Jan 2024 10:46:00 -0800 (PST)
Message-ID: <bf428113-0db4-4304-bc28-7aecab604dcc@redhat.com>
Date: Thu, 25 Jan 2024 19:45:59 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 07/66] physmem: Introduce
 ram_block_discard_guest_memfd_range()
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
References: <20240125032328.2522472-1-xiaoyao.li@intel.com>
 <20240125032328.2522472-8-xiaoyao.li@intel.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <20240125032328.2522472-8-xiaoyao.li@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 25.01.24 04:22, Xiaoyao Li wrote:
> When memory page is converted from private to shared, the original
> private memory is back'ed by guest_memfd. Introduce
> ram_block_discard_guest_memfd_range() for discarding memory in
> guest_memfd.
> 
> Originally-from: Isaku Yamahata <isaku.yamahata@intel.com>
> Codeveloped-by: Xiaoyao Li <xiaoyao.li@intel.com>
> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
> ---
> Changes in in v4:
> - Drop ram_block_convert_range() and open code its implementation in the
>    next Patch.
> ---
>   include/exec/cpu-common.h |  2 ++
>   system/physmem.c          | 23 +++++++++++++++++++++++
>   2 files changed, 25 insertions(+)
> 
> diff --git a/include/exec/cpu-common.h b/include/exec/cpu-common.h
> index fef3138d29fc..05610efa8b4f 100644
> --- a/include/exec/cpu-common.h
> +++ b/include/exec/cpu-common.h
> @@ -175,6 +175,8 @@ typedef int (RAMBlockIterFunc)(RAMBlock *rb, void *opaque);
>   
>   int qemu_ram_foreach_block(RAMBlockIterFunc func, void *opaque);
>   int ram_block_discard_range(RAMBlock *rb, uint64_t start, size_t length);
> +int ram_block_discard_guest_memfd_range(RAMBlock *rb, uint64_t start,
> +                                        size_t length);
>   
>   #endif
>   
> diff --git a/system/physmem.c b/system/physmem.c
> index 4735b0462ed9..fc59470191ef 100644
> --- a/system/physmem.c
> +++ b/system/physmem.c
> @@ -3626,6 +3626,29 @@ err:
>       return ret;
>   }
>   
> +int ram_block_discard_guest_memfd_range(RAMBlock *rb, uint64_t start,
> +                                        size_t length)
> +{
> +    int ret = -1;
> +
> +#ifdef CONFIG_FALLOCATE_PUNCH_HOLE
> +    ret = fallocate(rb->guest_memfd, FALLOC_FL_PUNCH_HOLE | FALLOC_FL_KEEP_SIZE,
> +                    start, length);
> +
> +    if (ret) {
> +        ret = -errno;
> +        error_report("%s: Failed to fallocate %s:%" PRIx64 " +%zx (%d)",
> +                     __func__, rb->idstr, start, length, ret);
> +    }
> +#else
> +    ret = -ENOSYS;
> +    error_report("%s: fallocate not available %s:%" PRIx64 " +%zx (%d)",
> +                 __func__, rb->idstr, start, length, ret);
> +#endif
> +
> +    return ret;
> +}
> +
>   bool ramblock_is_pmem(RAMBlock *rb)
>   {
>       return rb->flags & RAM_PMEM;


Reviewed-by: David Hildenbrand <david@redhat.com>

-- 
Cheers,

David / dhildenb


