Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82C833F471E
	for <lists+kvm@lfdr.de>; Mon, 23 Aug 2021 11:08:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230496AbhHWJIk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Aug 2021 05:08:40 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:26429 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229944AbhHWJIj (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 23 Aug 2021 05:08:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629709676;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=aISp5M1izx4NH4v0Hn06V3ODxv34YeYXayvZgVqi7XI=;
        b=VVC0xQ88CHPih/Hasxu6hGx0QckDyJoNwYwMGrvYnFDEy5DtbU3KQ7PeM1oJuW+GnzhcI1
        5IIBpbZ9sBPsSlyEE0iAteqBgUr3Cd9tblZCM9U/gBwGw6qdR2R1R8w3/IJBfonqCpMeGY
        zW5FCYvq3kvwQwR/VP9mBF0NzDoYzUg=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-586-eRzZ5eI9NV-DAxubZd9VSQ-1; Mon, 23 Aug 2021 05:07:55 -0400
X-MC-Unique: eRzZ5eI9NV-DAxubZd9VSQ-1
Received: by mail-ed1-f71.google.com with SMTP id l18-20020a0564021252b02903be7bdd65ccso8489447edw.12
        for <kvm@vger.kernel.org>; Mon, 23 Aug 2021 02:07:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=aISp5M1izx4NH4v0Hn06V3ODxv34YeYXayvZgVqi7XI=;
        b=jUzVXFDqymQc022Ug/Me13DIMKh5vAUndsmKtkCYxU94ICn+oTzCuELCZ1GG2jTsiH
         QXUnkB8VSeHKdKzJ1DFELFyItSIEJ8otjDRjhtJUR7hp7MZeCaeuf8Ymv16Qhqpbk2el
         B/kE0H6lzALHvli7szOjVpJU8O9wuhywJmPJJwBIJ1xTvYBxGAczGoehbePIBtVI24nI
         DyjvATUSCxnAfKfoD2xauy5zLMSMEJjhv/+ripQAwz9PQdcYOCO/byLYvS2RJX4mxjj+
         sKanxMqFomw7oB+Q2yl1KJw+NO97+Y5VchCaFvhL9k8gEtXVJDyeB19R5tfk4UlE5vio
         B3LA==
X-Gm-Message-State: AOAM532HGyWyaDQpQVF8wzf7cvFKyQ1W3UjYOdb5MScmMjcVE/7ur1oM
        /2Uj9R/NWLhIeLXPGu4h3Tr22f+s3v4fIaGibdhmdNAkf2025rV7egu4UNdfwYf7JjY5Lh/uEIl
        uB1P9PMQPVax2
X-Received: by 2002:a05:6402:1907:: with SMTP id e7mr8322339edz.201.1629709674295;
        Mon, 23 Aug 2021 02:07:54 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxB8djTuJSNghEDmXQfwZUrFrUJ+XhpXaA6T6sK1VZ2LMR5UNf4tuXRgxUvxp5oivYQUoq5rg==
X-Received: by 2002:a05:6402:1907:: with SMTP id e7mr8322319edz.201.1629709674115;
        Mon, 23 Aug 2021 02:07:54 -0700 (PDT)
Received: from gator.home (cst2-174-132.cust.vodafone.cz. [31.30.174.132])
        by smtp.gmail.com with ESMTPSA id ks20sm6977968ejb.101.2021.08.23.02.07.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Aug 2021 02:07:53 -0700 (PDT)
Date:   Mon, 23 Aug 2021 11:07:52 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     qemu-devel@nongnu.org, Eric Auger <eric.auger@redhat.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        kernel-team@android.com
Subject: Re: [PATCH 1/3] hw/arm/virt: KVM: Probe for KVM_CAP_ARM_VM_IPA_SIZE
 when creating scratch VM
Message-ID: <20210823090752.nanm4wttyefg3txh@gator.home>
References: <20210822144441.1290891-1-maz@kernel.org>
 <20210822144441.1290891-2-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210822144441.1290891-2-maz@kernel.org>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Aug 22, 2021 at 03:44:39PM +0100, Marc Zyngier wrote:
> Although we probe for the IPA limits imposed by KVM (and the hardware)
> when computing the memory map, we still use the old style '0' when
> creating a scratch VM in kvm_arm_create_scratch_host_vcpu().
> 
> On systems that are severely IPA challenged (such as the Apple M1),
> this results in a failure as KVM cannot use the default 40bit that
> '0' represents.
> 
> Instead, probe for the extension and use the reported IPA limit
> if available.
> 
> Cc: Andrew Jones <drjones@redhat.com>
> Cc: Eric Auger <eric.auger@redhat.com>
> Cc: Peter Maydell <peter.maydell@linaro.org>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  target/arm/kvm.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/target/arm/kvm.c b/target/arm/kvm.c
> index d8381ba224..cc3371a99b 100644
> --- a/target/arm/kvm.c
> +++ b/target/arm/kvm.c
> @@ -70,12 +70,17 @@ bool kvm_arm_create_scratch_host_vcpu(const uint32_t *cpus_to_try,
>                                        struct kvm_vcpu_init *init)
>  {
>      int ret = 0, kvmfd = -1, vmfd = -1, cpufd = -1;
> +    int max_vm_pa_size;
>  
>      kvmfd = qemu_open_old("/dev/kvm", O_RDWR);
>      if (kvmfd < 0) {
>          goto err;
>      }
> -    vmfd = ioctl(kvmfd, KVM_CREATE_VM, 0);
> +    max_vm_pa_size = ioctl(kvmfd, KVM_CHECK_EXTENSION, KVM_CAP_ARM_VM_IPA_SIZE);
> +    if (max_vm_pa_size < 0) {
> +        max_vm_pa_size = 0;
> +    }
> +    vmfd = ioctl(kvmfd, KVM_CREATE_VM, max_vm_pa_size);
>      if (vmfd < 0) {
>          goto err;
>      }
> -- 
> 2.30.2
>

Reviewed-by: Andrew Jones <drjones@redhat.com>

