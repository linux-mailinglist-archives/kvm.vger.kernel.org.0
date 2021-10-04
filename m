Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE7A8420918
	for <lists+kvm@lfdr.de>; Mon,  4 Oct 2021 12:11:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231847AbhJDKNF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Oct 2021 06:13:05 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:40073 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229545AbhJDKNE (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 4 Oct 2021 06:13:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633342275;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=7vrwkiYNmH9gme5GZD+IE0TvO4gorlXeNfmKqQOUQ2A=;
        b=TR2WaA+qUVsOG0nnh6lPkR7gdKo1UqNrrlO8AHalFwGjF3/0vWctP6omRxeNXnKzmor7k6
        z1+ygRcHtgEiDTAo9PImbjk23z1FTH+6ptwhdIo5KGR+9dgUY5ql4Eem5usSUfTwkskoO/
        Ek8B85W5S3ijyXvHMOxw3pYiOHYw0vw=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-362-fZ-s9k6vNjmVHeeniQWBAw-1; Mon, 04 Oct 2021 06:11:13 -0400
X-MC-Unique: fZ-s9k6vNjmVHeeniQWBAw-1
Received: by mail-wr1-f72.google.com with SMTP id c2-20020adfa302000000b0015e4260febdso4450164wrb.20
        for <kvm@vger.kernel.org>; Mon, 04 Oct 2021 03:11:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=7vrwkiYNmH9gme5GZD+IE0TvO4gorlXeNfmKqQOUQ2A=;
        b=XdDLYVWIneRs/H73YnCLq9TdW4/5q44/dReSlUStEmCKKBmJqPoEYR7eJWoCBuoHX3
         QAt/TARu5Xyg5YT2EGBKoZSn8b+k7CIMLVGJJorWJfMMWHpuRcShlVbSRyqjdZgCANYR
         KT8uixuT3POoCb7kuQ4VWOUEjpWYQqafTUAx3fpKJc3jYqK91/RgV0/VihLcZ7xy4rMu
         fP1RNOe2TUpgz2ffSzX5FAZwRiWZCxjpOXOODLGAlIqHcGN/FSgE8TdUTSsk9hqC4Gzn
         5UtPGHSA0OaVicDenorypoxPf0iVC2s1Jbk7B6wjzcphzMhNcnPWlUS9J2Jv8SakqOpt
         6GWQ==
X-Gm-Message-State: AOAM5334yLL5IICXVGVGitng1MUJ8iCid1NR5cdvPOUGUuCY++dUb3Sq
        7d0OsZCbigfYHu/ta9xLLdJr68vlEiVv0NZHmSGfq3U68byff8aPd1d1gqRUHhydSpnJy/x1ets
        H3ENs81yXYNsu
X-Received: by 2002:adf:a30b:: with SMTP id c11mr12974074wrb.289.1633342272549;
        Mon, 04 Oct 2021 03:11:12 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzq2FZ3CpAT5XH1tlJ1e5mgY4TiPIO/pbY6WYKk/ugWs9aFSuDXGQ1ktJJSgRf+gzBqButoyw==
X-Received: by 2002:adf:a30b:: with SMTP id c11mr12974021wrb.289.1633342272059;
        Mon, 04 Oct 2021 03:11:12 -0700 (PDT)
Received: from gator (nat-pool-brq-u.redhat.com. [213.175.37.12])
        by smtp.gmail.com with ESMTPSA id t11sm13810480wrz.65.2021.10.04.03.11.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Oct 2021 03:11:11 -0700 (PDT)
Date:   Mon, 4 Oct 2021 12:11:10 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     qemu-devel@nongnu.org, Eric Auger <eric.auger@redhat.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        kernel-team@android.com
Subject: Re: [PATCH v2 4/5] hw/arm/virt: Use the PA range to compute the
 memory map
Message-ID: <20211004101110.imtfcufnrdwhneev@gator>
References: <20211003164605.3116450-1-maz@kernel.org>
 <20211003164605.3116450-5-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211003164605.3116450-5-maz@kernel.org>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Oct 03, 2021 at 05:46:04PM +0100, Marc Zyngier wrote:
> The highmem attribute is nothing but another way to express the
> PA range of a VM. To support HW that has a smaller PA range then
> what QEMU assumes, pass this PA range to the virt_set_memmap()
> function, allowing it to correctly exclude highmem devices
> if they are outside of the PA range.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  hw/arm/virt.c | 46 +++++++++++++++++++++++++++++++++++-----------
>  1 file changed, 35 insertions(+), 11 deletions(-)
> 
> diff --git a/hw/arm/virt.c b/hw/arm/virt.c
> index 9d2abdbd5f..a572e0c9d9 100644
> --- a/hw/arm/virt.c
> +++ b/hw/arm/virt.c
> @@ -1610,10 +1610,10 @@ static uint64_t virt_cpu_mp_affinity(VirtMachineState *vms, int idx)
>      return arm_cpu_mp_affinity(idx, clustersz);
>  }
>  
> -static void virt_set_memmap(VirtMachineState *vms)
> +static void virt_set_memmap(VirtMachineState *vms, int pa_bits)
>  {
>      MachineState *ms = MACHINE(vms);
> -    hwaddr base, device_memory_base, device_memory_size;
> +    hwaddr base, device_memory_base, device_memory_size, memtop;
>      int i;
>  
>      vms->memmap = extended_memmap;
> @@ -1628,9 +1628,12 @@ static void virt_set_memmap(VirtMachineState *vms)
>          exit(EXIT_FAILURE);
>      }
>  
> -    if (!vms->highmem &&
> -        vms->memmap[VIRT_MEM].base + ms->maxram_size > 4 * GiB) {
> -        error_report("highmem=off, but memory crosses the 4GiB limit\n");
> +    if (!vms->highmem)
> +	    pa_bits = 32;
> +
> +    if (vms->memmap[VIRT_MEM].base + ms->maxram_size > BIT_ULL(pa_bits)) {
> +	    error_report("Addressing limited to %d bits, but memory exceeds it by %llu bytes\n",
> +			 pa_bits, vms->memmap[VIRT_MEM].base + ms->maxram_size - BIT_ULL(pa_bits));
>          exit(EXIT_FAILURE);
>      }
>      /*
> @@ -1645,7 +1648,7 @@ static void virt_set_memmap(VirtMachineState *vms)
>      device_memory_size = ms->maxram_size - ms->ram_size + ms->ram_slots * GiB;
>  
>      /* Base address of the high IO region */
> -    base = device_memory_base + ROUND_UP(device_memory_size, GiB);
> +    memtop = base = device_memory_base + ROUND_UP(device_memory_size, GiB);
>      if (base < device_memory_base) {
>          error_report("maxmem/slots too huge");
>          exit(EXIT_FAILURE);
> @@ -1662,9 +1665,17 @@ static void virt_set_memmap(VirtMachineState *vms)
>          vms->memmap[i].size = size;
>          base += size;
>      }
> -    vms->highest_gpa = (vms->highmem ?
> -                        base :
> -                        vms->memmap[VIRT_MEM].base + ms->maxram_size) - 1;
> +
> +    /*
> +     * If base fits within pa_bits, all good. If it doesn't, limit it
> +     * to the end of RAM, which is guaranteed to fit within pa_bits.

We tested that

  vms->memmap[VIRT_MEM].base + ms->maxram_size

fits within pa_bits, but here we're setting highest_gpa to

  ROUND_UP(vms->memmap[VIRT_MEM].base + ms->ram_size, GiB) +
  ROUND_UP(ms->maxram_size - ms->ram_size + ms->ram_slots * GiB, GiB)

which will be larger. Shouldn't we test memtop instead to make this
guarantee?


> +     */
> +    if (base <= BIT_ULL(pa_bits)) {
> +        vms->highest_gpa = base -1;
> +    } else {
> +        vms->highest_gpa = memtop - 1;
> +    }
> +
>      if (device_memory_size > 0) {
>          ms->device_memory = g_malloc0(sizeof(*ms->device_memory));
>          ms->device_memory->base = device_memory_base;
> @@ -1860,7 +1871,20 @@ static void machvirt_init(MachineState *machine)
>       * to create a VM with the right number of IPA bits.
>       */
>      if (!vms->memmap) {
> -        virt_set_memmap(vms);
> +        ARMCPU *armcpu = ARM_CPU(first_cpu);


I think it's too early to use first_cpu here (although, I'll admit I'm
always confused as to what gets initialized when...) Assuming we need to
realize the cpus first, then we don't do that until a bit further down
in this function. I wonder if it's possible to delay this memmap setup
until after cpu realization. I see the memmap getting used prior when
calculating virt_max_cpus, but that looks like it needs to be updated
anyway to take highmem into account as to whether or not we should
consider the high gicv3 redist region in the calculation.

> +        int pa_bits;
> +
> +        if (object_property_get_bool(OBJECT(first_cpu), "aarch64", NULL)) {
> +            pa_bits = arm_pamax(armcpu);
> +        } else if (arm_feature(&armcpu->env, ARM_FEATURE_LPAE)) {
> +            /* v7 with LPAE */
> +            pa_bits = 40;
> +        } else {
> +            /* Anything else */
> +            pa_bits = 32;
> +        }
> +
> +        virt_set_memmap(vms, pa_bits);
>      }
>  
>      /* We can probe only here because during property set
> @@ -2596,7 +2620,7 @@ static int virt_kvm_type(MachineState *ms, const char *type_str)
>      max_vm_pa_size = kvm_arm_get_max_vm_ipa_size(ms, &fixed_ipa);
>  
>      /* we freeze the memory map to compute the highest gpa */
> -    virt_set_memmap(vms);
> +    virt_set_memmap(vms, max_vm_pa_size);
>  
>      requested_pa_size = 64 - clz64(vms->highest_gpa);
>  
> -- 
> 2.30.2
> 

Thanks,
drew

