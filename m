Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B996D42558D
	for <lists+kvm@lfdr.de>; Thu,  7 Oct 2021 16:39:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242118AbhJGOkw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Oct 2021 10:40:52 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:49966 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233341AbhJGOku (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 7 Oct 2021 10:40:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633617536;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=NGm1yWS8geF2sO0H/4Ce/J+RgIXVQpoAvhPhIp+yNF0=;
        b=iY/EjFClUtHIbvmZ42U6+VdHEwF/PvLHqAepZ6uQnuVcBejROEMDJLAf6dHZi/L86tE5OZ
        cnNwN1gBkLPAgRVGG0CBnuaxsBEEpuxJ/qbKwujNBvVc7qVxTBFFEAsC4MepIWDcKU0iP2
        69dwGYMBH49pRLGprdLxoYeDYRfRaAw=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-564-3h8SW1FoPwWGFMFr7uuINw-1; Thu, 07 Oct 2021 10:38:55 -0400
X-MC-Unique: 3h8SW1FoPwWGFMFr7uuINw-1
Received: by mail-wr1-f70.google.com with SMTP id k16-20020a5d6290000000b00160753b430fso4896049wru.11
        for <kvm@vger.kernel.org>; Thu, 07 Oct 2021 07:38:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=NGm1yWS8geF2sO0H/4Ce/J+RgIXVQpoAvhPhIp+yNF0=;
        b=u41LK9X5mLFZhy4gCZGJZhxS3NHdRVdOIamj0hO17C+cUVldKtvsOuNPJvgA8G9J2k
         2It7GzxVaf/0tNfb/CsnK1lUP+7sEhzlK5TrDIGsnZror1IwdTt002ayiQXQvjTdzfub
         Ws1loNSswWykMnFHHtPRmh/XlIgLhohR+zHHXCRRpQNAuEBwXXC89/i3OLxCTE/IocRC
         D4naIUqX2vrQbX1aTA8hcKblh8Q/fgsKNAK+KDkUHKeyVyuCqgqkTAAwq9sd9f09Mrl/
         2OaDRaVuNwrwj9P33KmQ8pYF2rlMnFv0KV/faCbZG5DsiJUYItqCZ6rG93qEAgQMGVdW
         xYkQ==
X-Gm-Message-State: AOAM532o2gHsloiWv3Zh3IcwrVhkwzd58hcwnqsv8BDD8Vuuf4tnbW+K
        I50ti+b6uS9TXOoq0pZiykLsiRd7eMeVN7WdtFQtj5cGwzgM0Eoa7FztV7dJ+y2+ju4fQ/zsYWO
        iFvs0o91NSPEC
X-Received: by 2002:adf:bb09:: with SMTP id r9mr6004145wrg.238.1633617534446;
        Thu, 07 Oct 2021 07:38:54 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxO9BCo0zdcmxbDxAudW4jdTSomLkbbEHDoD+axd3gGY/vYr4NNhmBMpyQQvOrtL3YclzCczw==
X-Received: by 2002:adf:bb09:: with SMTP id r9mr6004113wrg.238.1633617534208;
        Thu, 07 Oct 2021 07:38:54 -0700 (PDT)
Received: from gator (nat-pool-brq-u.redhat.com. [213.175.37.12])
        by smtp.gmail.com with ESMTPSA id a2sm9231329wrv.15.2021.10.07.07.38.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 07:38:53 -0700 (PDT)
Date:   Thu, 7 Oct 2021 16:38:52 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org, will@kernel.org,
        qperret@google.com, dbrazdil@google.com,
        Steven Price <steven.price@arm.com>,
        Fuad Tabba <tabba@google.com>,
        Srivatsa Vaddagiri <vatsa@codeaurora.org>,
        Shanker R Donthineni <sdonthineni@nvidia.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        kernel-team@android.com
Subject: Re: [PATCH v2 10/16] KVM: arm64: Add some documentation for the MMIO
 guard feature
Message-ID: <20211007143852.pyae42sbovi4vk23@gator>
References: <20211004174849.2831548-1-maz@kernel.org>
 <20211004174849.2831548-11-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211004174849.2831548-11-maz@kernel.org>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 04, 2021 at 06:48:43PM +0100, Marc Zyngier wrote:
> Document the hypercalls user for the MMIO guard infrastructure.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  Documentation/virt/kvm/arm/index.rst      |  1 +
>  Documentation/virt/kvm/arm/mmio-guard.rst | 74 +++++++++++++++++++++++
>  2 files changed, 75 insertions(+)
>  create mode 100644 Documentation/virt/kvm/arm/mmio-guard.rst
> 
> diff --git a/Documentation/virt/kvm/arm/index.rst b/Documentation/virt/kvm/arm/index.rst
> index 78a9b670aafe..e77a0ee2e2d4 100644
> --- a/Documentation/virt/kvm/arm/index.rst
> +++ b/Documentation/virt/kvm/arm/index.rst
> @@ -11,3 +11,4 @@ ARM
>     psci
>     pvtime
>     ptp_kvm
> +   mmio-guard
> diff --git a/Documentation/virt/kvm/arm/mmio-guard.rst b/Documentation/virt/kvm/arm/mmio-guard.rst
> new file mode 100644
> index 000000000000..8b3c852c5d92
> --- /dev/null
> +++ b/Documentation/virt/kvm/arm/mmio-guard.rst
> @@ -0,0 +1,74 @@
> +.. SPDX-License-Identifier: GPL-2.0
> +
> +==============
> +KVM MMIO guard
> +==============
> +
> +KVM implements device emulation by handling translation faults to any
> +IPA range that is not contained in a memory slot. Such a translation
> +fault is in most cases passed on to userspace (or in rare cases to the
> +host kernel) with the address, size and possibly data of the access
> +for emulation.
> +
> +Should the guest exit with an address that is not one that corresponds
> +to an emulatable device, userspace may take measures that are not the
> +most graceful as far as the guest is concerned (such as terminating it
> +or delivering a fatal exception).
> +
> +There is also an element of trust: by forwarding the request to
> +userspace, the kernel assumes that the guest trusts userspace to do
> +the right thing.
> +
> +The KVM MMIO guard offers a way to mitigate this last point: a guest
> +can request that only certain regions of the IPA space are valid as
> +MMIO. Only these regions will be handled as an MMIO, and any other
> +will result in an exception being delivered to the guest.
> +
> +This relies on a set of hypercalls defined in the KVM-specific range,
> +using the HVC64 calling convention.
> +
> +* ARM_SMCCC_KVM_FUNC_MMIO_GUARD_INFO
> +
> +    ==============    ========    ================================
> +    Function ID:      (uint32)    0xC6000002
> +    Arguments:        none
> +    Return Values:    (int64)     NOT_SUPPORTED(-1) on error, or
> +                      (uint64)    Protection Granule (PG) size in
> +                                  bytes (r0)
> +    ==============    ========    ================================
> +
> +* ARM_SMCCC_KVM_FUNC_MMIO_GUARD_ENROLL
> +
> +    ==============    ========    ==============================
> +    Function ID:      (uint32)    0xC6000003
> +    Arguments:        none
> +    Return Values:    (int64)     NOT_SUPPORTED(-1) on error, or
> +                                  RET_SUCCESS(0) (r0)
> +    ==============    ========    ==============================
> +
> +* ARM_SMCCC_KVM_FUNC_MMIO_GUARD_MAP
> +
> +    ==============    ========    ====================================
> +    Function ID:      (uint32)    0xC6000004
> +    Arguments:        (uint64)    The base of the PG-sized IPA range
> +                                  that is allowed to be accessed as
> +                                  MMIO. Must be aligned to the PG size
> +                                  (r1)
> +                      (uint64)    Index in the MAIR_EL1 register
> +		                  providing the memory attribute that
> +				  is used by the guest (r2)
    ^^ some tabs got in here

> +    Return Values:    (int64)     NOT_SUPPORTED(-1) on error, or
> +                                  RET_SUCCESS(0) (r0)
> +    ==============    ========    ====================================
> +
> +* ARM_SMCCC_KVM_FUNC_MMIO_GUARD_UNMAP
> +
> +    ==============    ========    ======================================
> +    Function ID:      (uint32)    0xC6000005
> +    Arguments:        (uint64)    PG-sized IPA range aligned to the PG
> +                                  size which has been previously mapped.
> +                                  Must be aligned to the PG size and
> +                                  have been previously mapped (r1)
> +    Return Values:    (int64)     NOT_SUPPORTED(-1) on error, or
> +                                  RET_SUCCESS(0) (r0)
> +    ==============    ========    ======================================
> -- 
> 2.30.2
>

Otherwise,

Reviewed-by: Andrew Jones <drjones@redhat.com>

Thanks,
drew 

