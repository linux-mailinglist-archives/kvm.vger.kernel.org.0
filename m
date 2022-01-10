Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E1F0489C61
	for <lists+kvm@lfdr.de>; Mon, 10 Jan 2022 16:39:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233743AbiAJPjE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Jan 2022 10:39:04 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:34870 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236339AbiAJPjC (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 10 Jan 2022 10:39:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1641829141;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Vn/4MITr303eLI/9sy4vZE7T+80p2T43/HHj8bjumUI=;
        b=EqGkm6LolTRYNRUUKoBJba5S/+i6bDTVHKDUjkqPtJwboI8zoZmcDHOlTgo5GQaeh+l4rM
        DyOo3/t9DFr4FewRBfigZUBQGPhNmJyPJ5XrBkVsDKxsSzSmnMgGlh/MMu+9Told5Annlv
        zvPiqVs2KRLTSRTVOJr/fRzVvS0YC6s=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-360-PCWB1t_YP8SVSDojUlL_lg-1; Mon, 10 Jan 2022 10:39:00 -0500
X-MC-Unique: PCWB1t_YP8SVSDojUlL_lg-1
Received: by mail-wm1-f72.google.com with SMTP id n3-20020a05600c3b8300b00345c3fc40b0so9085494wms.3
        for <kvm@vger.kernel.org>; Mon, 10 Jan 2022 07:39:00 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:subject:to:cc:references:from
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-transfer-encoding:content-language;
        bh=Vn/4MITr303eLI/9sy4vZE7T+80p2T43/HHj8bjumUI=;
        b=iQ3O4821BD2xz+kUCdhw7VLx3JWDIMqmdKXjjcICbn1kf6juOw4DoTavkHa6GtvBB9
         5GUUqS0KGMq4VVACI0UAGxDFSDc6UZqL/44iNp7c26X3jRBPfa2GEVfb1TNoJw9CXQj/
         7sFD7wEQ8ehUsPV3gQOEaoH/6tmNgsqGF/7KDrax2WMu7zdBVQhC9r5dQI4jL/qLzdVe
         dAsTWt/Xu4SaDhD1lf0YhuVLGtT1W5UMWckAp7GDsveHCXKj3VVfnJl6I8lP+Du6RLmj
         MkJN2Q7rZed8ki/UwruUKFajnp+TP/l+YAbVkokfn+daCdi374JJNOKeGrAMTARi2D7c
         izcg==
X-Gm-Message-State: AOAM533VR0BwnCPNk89gApUozxEfTpxLbjyo21Yf0fBF0V0t9JCG6Iiv
        UOJHGJ0YqaNzDD4Jv4mXs7rXrXJ86tGIIXtG+BO7Uj0j6JfrQvsnysL8Fx0P/I062e1hCBni3h6
        XE4UtOA6WclQB
X-Received: by 2002:a5d:4609:: with SMTP id t9mr153681wrq.551.1641829138993;
        Mon, 10 Jan 2022 07:38:58 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwZifhrLZp+3rpsOY24CeNlWG+k7+BKtRIYq4bZWPG5Q97FLrRELUVOFGLaCLaT/fCtp/nCcw==
X-Received: by 2002:a5d:4609:: with SMTP id t9mr153665wrq.551.1641829138790;
        Mon, 10 Jan 2022 07:38:58 -0800 (PST)
Received: from ?IPv6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id n12sm7169407wmq.30.2022.01.10.07.38.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 10 Jan 2022 07:38:57 -0800 (PST)
Reply-To: eric.auger@redhat.com
Subject: Re: [PATCH v4 4/6] hw/arm/virt: Use the PA range to compute the
 memory map
To:     Marc Zyngier <maz@kernel.org>, qemu-devel@nongnu.org
Cc:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        kernel-team@android.com, Andrew Jones <drjones@redhat.com>,
        Peter Maydell <peter.maydell@linaro.org>
References: <20220107163324.2491209-1-maz@kernel.org>
 <20220107163324.2491209-5-maz@kernel.org>
From:   Eric Auger <eric.auger@redhat.com>
Message-ID: <d7f793ab-bf78-32fb-e793-54a034ffd5d8@redhat.com>
Date:   Mon, 10 Jan 2022 16:38:56 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20220107163324.2491209-5-maz@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

On 1/7/22 5:33 PM, Marc Zyngier wrote:
> The highmem attribute is nothing but another way to express the
> PA range of a VM. To support HW that has a smaller PA range then
> what QEMU assumes, pass this PA range to the virt_set_memmap()
> function, allowing it to correctly exclude highmem devices
> if they are outside of the PA range.
>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  hw/arm/virt.c | 53 ++++++++++++++++++++++++++++++++++++++++++++-------
>  1 file changed, 46 insertions(+), 7 deletions(-)
>
> diff --git a/hw/arm/virt.c b/hw/arm/virt.c
> index 57c55e8a37..db4b0636e1 100644
> --- a/hw/arm/virt.c
> +++ b/hw/arm/virt.c
> @@ -1660,7 +1660,7 @@ static uint64_t virt_cpu_mp_affinity(VirtMachineState *vms, int idx)
>      return arm_cpu_mp_affinity(idx, clustersz);
>  }
>  
> -static void virt_set_memmap(VirtMachineState *vms)
> +static void virt_set_memmap(VirtMachineState *vms, int pa_bits)
>  {
>      MachineState *ms = MACHINE(vms);
>      hwaddr base, device_memory_base, device_memory_size, memtop;
> @@ -1678,6 +1678,13 @@ static void virt_set_memmap(VirtMachineState *vms)
>          exit(EXIT_FAILURE);
>      }
>  
> +    /*
> +     * !highmem is exactly the same as limiting the PA space to 32bit,
> +     * irrespective of the underlying capabilities of the HW.
> +     */
> +    if (!vms->highmem)
> +	    pa_bits = 32;
you need {} according to the QEMU coding style. Welcome to a new shiny
world :-)
> +
>      /*
>       * We compute the base of the high IO region depending on the
>       * amount of initial and device memory. The device memory start/size
> @@ -1691,8 +1698,9 @@ static void virt_set_memmap(VirtMachineState *vms)
>  
>      /* Base address of the high IO region */
>      memtop = base = device_memory_base + ROUND_UP(device_memory_size, GiB);
> -    if (!vms->highmem && memtop > 4 * GiB) {
> -        error_report("highmem=off, but memory crosses the 4GiB limit\n");
> +    if (memtop > BIT_ULL(pa_bits)) {
> +	    error_report("Addressing limited to %d bits, but memory exceeds it by %llu bytes\n",
> +			 pa_bits, memtop - BIT_ULL(pa_bits));
>          exit(EXIT_FAILURE);
>      }
>      if (base < device_memory_base) {
> @@ -1711,7 +1719,13 @@ static void virt_set_memmap(VirtMachineState *vms)
>          vms->memmap[i].size = size;
>          base += size;
>      }
> -    vms->highest_gpa = (vms->highmem ? base : memtop) - 1;
> +
> +    /*
> +     * If base fits within pa_bits, all good. If it doesn't, limit it
> +     * to the end of RAM, which is guaranteed to fit within pa_bits.
> +     */
> +    vms->highest_gpa = (base <= BIT_ULL(pa_bits) ? base : memtop) - 1;
> +
>      if (device_memory_size > 0) {
>          ms->device_memory = g_malloc0(sizeof(*ms->device_memory));
>          ms->device_memory->base = device_memory_base;
> @@ -1902,12 +1916,38 @@ static void machvirt_init(MachineState *machine)
>      unsigned int smp_cpus = machine->smp.cpus;
>      unsigned int max_cpus = machine->smp.max_cpus;
Move the cpu_type check before?

    if (!cpu_type_valid(machine->cpu_type)) {
        error_report("mach-virt: CPU type %s not supported",
machine->cpu_type);
        exit(1);
    }
>  
> +    possible_cpus = mc->possible_cpu_arch_ids(machine);
> +
>      /*
>       * In accelerated mode, the memory map is computed earlier in kvm_type()
>       * to create a VM with the right number of IPA bits.
>       */
>      if (!vms->memmap) {
> -        virt_set_memmap(vms);
> +        Object *cpuobj;
> +        ARMCPU *armcpu;
> +        int pa_bits;
> +
> +        /*
> +         * Instanciate a temporary CPU object to find out about what
> +         * we are about to deal with. Once this is done, get rid of
> +         * the object.
> +         */
> +        cpuobj = object_new(possible_cpus->cpus[0].type);
> +        armcpu = ARM_CPU(cpuobj);
> +
> +        if (object_property_get_bool(cpuobj, "aarch64", NULL)) {
> +            pa_bits = arm_pamax(armcpu);
> +        } else if (arm_feature(&armcpu->env, ARM_FEATURE_LPAE)) {
> +            /* v7 with LPAE */
> +            pa_bits = 40;
> +        } else {
> +            /* Anything else */
> +            pa_bits = 32;
> +        }
> +
> +        object_unref(cpuobj);
> +
> +        virt_set_memmap(vms, pa_bits);
>      }
>  
>      /* We can probe only here because during property set
> @@ -1989,7 +2029,6 @@ static void machvirt_init(MachineState *machine)
>  
>      create_fdt(vms);
>  
> -    possible_cpus = mc->possible_cpu_arch_ids(machine);
>      assert(possible_cpus->len == max_cpus);
>      for (n = 0; n < possible_cpus->len; n++) {
>          Object *cpuobj;
> @@ -2646,7 +2685,7 @@ static int virt_kvm_type(MachineState *ms, const char *type_str)
>      max_vm_pa_size = kvm_arm_get_max_vm_ipa_size(ms, &fixed_ipa);
>  
>      /* we freeze the memory map to compute the highest gpa */
> -    virt_set_memmap(vms);
> +    virt_set_memmap(vms, max_vm_pa_size);
>  
>      requested_pa_size = 64 - clz64(vms->highest_gpa);
>  
Thanks

Eric

