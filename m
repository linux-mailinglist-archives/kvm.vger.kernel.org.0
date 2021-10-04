Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3468042089D
	for <lists+kvm@lfdr.de>; Mon,  4 Oct 2021 11:44:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232431AbhJDJqZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Oct 2021 05:46:25 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:59538 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231962AbhJDJqY (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 4 Oct 2021 05:46:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633340675;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=SoUkTtOv9XP49TsrzDlI8hEqaw7q+N7J/SxBu7RAHCQ=;
        b=fHBHGlAQcH7HITOeeZSlw+Af8RP5uM/cjf3Wr82ThRUhaX6roe/OO4zVUFT3q4U9gjVfZ8
        uLFSbjKMy801VJu4JI9lwHfk1e5ULduBITt5HHWEprWmDnOoC7zAMWK0ve8aRpd0tEPwWR
        LtaCGYNqH3jl2HlmlYihGg2xAy86dzI=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-322-DzrBJ6JEPi2O7q1MOTmCDQ-1; Mon, 04 Oct 2021 05:44:34 -0400
X-MC-Unique: DzrBJ6JEPi2O7q1MOTmCDQ-1
Received: by mail-wr1-f70.google.com with SMTP id c2-20020adfa302000000b0015e4260febdso4426823wrb.20
        for <kvm@vger.kernel.org>; Mon, 04 Oct 2021 02:44:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=SoUkTtOv9XP49TsrzDlI8hEqaw7q+N7J/SxBu7RAHCQ=;
        b=QUrlg2S5KcyBJQQw95Obsbao1idZKAYqyTL0VOlY+jofqr6GPUoVZvRUnBMS7BMYpb
         QF4p2axY6sqvPuWeHy/dVIFePTOzW6akTdWVD/WZJi6PgGDaZfbKH9tQsbTsmz5syF/U
         XiHyFoPLa3fQfYxql21ztDV906/uy9AqSoXKzEaTTYnfOQeqse2Lw0wl/KazGNbDaFVU
         ZX9akABdcXZcded7I2ZTfht11xICYWtwZpTShHgyXruDFq4I+4cGKEWI188lBNZVmxlM
         EEot4VuJGEnh2A849VdMqZXLIUmMeyR8pTXNDrlJN4Ho9SnaWuxCByzHUCnVa8Twvh9U
         KiGg==
X-Gm-Message-State: AOAM531L92Z9drQBHe4My2T1K3y+L47MopXgPXRdTbDr5s0p2dxDnzL3
        +Rx6pxHMkOJYxhL/toUzu/zcjbcng4Bw5HJwUIOrl8qI/rFD0Dn9pN6yvSTK0Rsg7F7Ldn/m+Su
        VVyHHA+yLR1is
X-Received: by 2002:adf:9bc4:: with SMTP id e4mr13142421wrc.257.1633340673301;
        Mon, 04 Oct 2021 02:44:33 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy2LrCY7HSrjxs2GPwETmmHaFihgfaSnx78iosQ5U6+ikTJPgF0cMge7tL/mMpTCWF7VZGUEw==
X-Received: by 2002:adf:9bc4:: with SMTP id e4mr13142407wrc.257.1633340673145;
        Mon, 04 Oct 2021 02:44:33 -0700 (PDT)
Received: from gator (nat-pool-brq-u.redhat.com. [213.175.37.12])
        by smtp.gmail.com with ESMTPSA id n17sm6794152wrw.16.2021.10.04.02.44.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Oct 2021 02:44:32 -0700 (PDT)
Date:   Mon, 4 Oct 2021 11:44:31 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     qemu-devel@nongnu.org, Eric Auger <eric.auger@redhat.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        kernel-team@android.com
Subject: Re: [PATCH v2 3/5] hw/arm/virt: Honor highmem setting when computing
 the memory map
Message-ID: <20211004094431.2dewqj3hf2vjiil7@gator>
References: <20211003164605.3116450-1-maz@kernel.org>
 <20211003164605.3116450-4-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211003164605.3116450-4-maz@kernel.org>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Oct 03, 2021 at 05:46:03PM +0100, Marc Zyngier wrote:
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
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  hw/arm/virt.c | 9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)
> 
> diff --git a/hw/arm/virt.c b/hw/arm/virt.c
> index bcf58f677d..9d2abdbd5f 100644
> --- a/hw/arm/virt.c
> +++ b/hw/arm/virt.c
> @@ -1628,6 +1628,11 @@ static void virt_set_memmap(VirtMachineState *vms)
>          exit(EXIT_FAILURE);
>      }
>  
> +    if (!vms->highmem &&
> +        vms->memmap[VIRT_MEM].base + ms->maxram_size > 4 * GiB) {
> +        error_report("highmem=off, but memory crosses the 4GiB limit\n");
> +        exit(EXIT_FAILURE);
> +    }
>      /*
>       * We compute the base of the high IO region depending on the
>       * amount of initial and device memory. The device memory start/size
> @@ -1657,7 +1662,9 @@ static void virt_set_memmap(VirtMachineState *vms)
>          vms->memmap[i].size = size;
>          base += size;
>      }
> -    vms->highest_gpa = base - 1;
> +    vms->highest_gpa = (vms->highmem ?
> +                        base :
> +                        vms->memmap[VIRT_MEM].base + ms->maxram_size) - 1;
>      if (device_memory_size > 0) {
>          ms->device_memory = g_malloc0(sizeof(*ms->device_memory));
>          ms->device_memory->base = device_memory_base;
> -- 
> 2.30.2
>

Reviewed-by: Andrew Jones <drjones@redhat.com>

