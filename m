Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF557489C3A
	for <lists+kvm@lfdr.de>; Mon, 10 Jan 2022 16:31:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236210AbiAJPbF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Jan 2022 10:31:05 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:35982 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236214AbiAJPbE (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 10 Jan 2022 10:31:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1641828663;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hAsOCNUk4gJy3xfkTWxDnJ/ocn/Hng6/ay6Zh+ITS5o=;
        b=T2mc/62GSKP3ieXzS7WSKU9qed2WVgtysOHeLH2QntQeEe3cIm8DX1Cz8BMsmIyi+B6Pqd
        Uli2ZyTieTL/o/DJ7IReZkHIDbB3fVEpmM2/sTTZKEbcg3C6pakDYWthUiYvvPj2YeirE1
        szHxWDHaCu4bRY6Yp5hubNCKyUuY/FA=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-153-AlWCsdvfPi6HEHizxiKd9g-1; Mon, 10 Jan 2022 10:31:02 -0500
X-MC-Unique: AlWCsdvfPi6HEHizxiKd9g-1
Received: by mail-wm1-f69.google.com with SMTP id v23-20020a05600c215700b0034566adb612so2255180wml.0
        for <kvm@vger.kernel.org>; Mon, 10 Jan 2022 07:31:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:subject:to:cc:references:from
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-transfer-encoding:content-language;
        bh=hAsOCNUk4gJy3xfkTWxDnJ/ocn/Hng6/ay6Zh+ITS5o=;
        b=cH3jbqU0ykc58MCsU2apl2YQyLLmQpsFpV/QhD3/kMApvvBBHAlMRweEt8ABacxX1b
         Q+OZy6T1iDiIfLuAKTbNCxEUc1eA3RCIsVLdPRfACq/oK0M5Fh1VEbyn2Hc9azhJwDcl
         Kq5ulGZbr0VYl+RDV5YGIqk63PdnPvj0oG0pp3oW4KDefJ4z1V6zZLsLMdNGOi9t6Tl3
         jofdApM8oluY8AUM2tKKUznFBxIwATKAlyrRvskwU77QondF/f5MPgD9Wm7/U1zjGOLn
         WpUO5322QJOw3MEpPcm7IrurrVyPjQfAoItUsFS9OTnD9Y849Bnt8uZ5b1NZTWjYFL5C
         WgpA==
X-Gm-Message-State: AOAM530aWsKn/P6LP3CzKSDJxKuJvon74NVLbe4KJQqJy5W8w28WKe75
        JNykzbgGPr1Zy8ZoTidoQGYT+cuioojro7fDdfqqiSPNfqblXaEZrgm3KRiB3Fs0qH3X0WnqIKX
        JRY/rQiH9KIFV
X-Received: by 2002:a05:600c:34c4:: with SMTP id d4mr22837826wmq.53.1641828660521;
        Mon, 10 Jan 2022 07:31:00 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwZ5PbKWG2o82UtfdwF8YlHmCQ3IAN9akDTuLFh8hqRxJQpStKQ1peYtx8PsS1Wl2ACmE2rXQ==
X-Received: by 2002:a05:600c:34c4:: with SMTP id d4mr22837815wmq.53.1641828660301;
        Mon, 10 Jan 2022 07:31:00 -0800 (PST)
Received: from ?IPv6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id g5sm7517121wrd.100.2022.01.10.07.30.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 10 Jan 2022 07:30:59 -0800 (PST)
Reply-To: eric.auger@redhat.com
Subject: Re: [PATCH v4 3/6] hw/arm/virt: Honor highmem setting when computing
 the memory map
To:     Marc Zyngier <maz@kernel.org>, qemu-devel@nongnu.org
Cc:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        kernel-team@android.com, Andrew Jones <drjones@redhat.com>,
        Peter Maydell <peter.maydell@linaro.org>
References: <20220107163324.2491209-1-maz@kernel.org>
 <20220107163324.2491209-4-maz@kernel.org>
From:   Eric Auger <eric.auger@redhat.com>
Message-ID: <a72846d6-d559-9f12-154f-20c04821747e@redhat.com>
Date:   Mon, 10 Jan 2022 16:30:58 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20220107163324.2491209-4-maz@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

On 1/7/22 5:33 PM, Marc Zyngier wrote:
> Even when the VM is configured with highmem=off, the highest_gpa
> field includes devices that are above the 4GiB limit.
> Similarily, nothing seem to check that the memory is within
> the limit set by the highmem=off option.
>
> This leads to failures in virt_kvm_type() on systems that have
> a crippled IPA range, as the reported IPA space is larger than
> what it should be.
>
> Instead, honor the user-specified limit to only use the devices
> at the lowest end of the spectrum, and fail if we have memory
> crossing the 4GiB limit.
>
> Reviewed-by: Andrew Jones <drjones@redhat.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
Reviewed-by: Eric Auger <eric.auger@redhat.com>

Eric
> ---
>  hw/arm/virt.c | 10 +++++++---
>  1 file changed, 7 insertions(+), 3 deletions(-)
>
> diff --git a/hw/arm/virt.c b/hw/arm/virt.c
> index 4d1d629432..57c55e8a37 100644
> --- a/hw/arm/virt.c
> +++ b/hw/arm/virt.c
> @@ -1663,7 +1663,7 @@ static uint64_t virt_cpu_mp_affinity(VirtMachineState *vms, int idx)
>  static void virt_set_memmap(VirtMachineState *vms)
>  {
>      MachineState *ms = MACHINE(vms);
> -    hwaddr base, device_memory_base, device_memory_size;
> +    hwaddr base, device_memory_base, device_memory_size, memtop;
>      int i;
>  
>      vms->memmap = extended_memmap;
> @@ -1690,7 +1690,11 @@ static void virt_set_memmap(VirtMachineState *vms)
>      device_memory_size = ms->maxram_size - ms->ram_size + ms->ram_slots * GiB;
>  
>      /* Base address of the high IO region */
> -    base = device_memory_base + ROUND_UP(device_memory_size, GiB);
> +    memtop = base = device_memory_base + ROUND_UP(device_memory_size, GiB);
> +    if (!vms->highmem && memtop > 4 * GiB) {
> +        error_report("highmem=off, but memory crosses the 4GiB limit\n");
> +        exit(EXIT_FAILURE);
> +    }
>      if (base < device_memory_base) {
>          error_report("maxmem/slots too huge");
>          exit(EXIT_FAILURE);
> @@ -1707,7 +1711,7 @@ static void virt_set_memmap(VirtMachineState *vms)
>          vms->memmap[i].size = size;
>          base += size;
>      }
> -    vms->highest_gpa = base - 1;
> +    vms->highest_gpa = (vms->highmem ? base : memtop) - 1;
>      if (device_memory_size > 0) {
>          ms->device_memory = g_malloc0(sizeof(*ms->device_memory));
>          ms->device_memory->base = device_memory_base;

