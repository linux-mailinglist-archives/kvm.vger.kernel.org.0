Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B03F845FECB
	for <lists+kvm@lfdr.de>; Sat, 27 Nov 2021 14:18:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354696AbhK0NVt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 27 Nov 2021 08:21:49 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:31714 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1354755AbhK0NTt (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sat, 27 Nov 2021 08:19:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1638018994;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=v0plHLVJ7YGhDTdr46oZg0IbiyPN69in2dl5FlOrseU=;
        b=BbQqYOnjuVyYoU0OZJz0S8HyetePrh1X0uqvdvRJFPlB0EiMhv3OCDzDV9SW3usi702D43
        OdCWUNJHo+64vpqnYp3DBKEH54wNtP9aNQoU/iing01MaQh605llXkkQAayMlT17VqKPNp
        lM9dvBdYJvvRQXel8U40WXGJAMdtCJQ=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-506-6F8DWc01NduM6e9pKuqqgg-1; Sat, 27 Nov 2021 08:16:33 -0500
X-MC-Unique: 6F8DWc01NduM6e9pKuqqgg-1
Received: by mail-ed1-f72.google.com with SMTP id c1-20020aa7c741000000b003e7bf1da4bcso9940527eds.21
        for <kvm@vger.kernel.org>; Sat, 27 Nov 2021 05:16:32 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=v0plHLVJ7YGhDTdr46oZg0IbiyPN69in2dl5FlOrseU=;
        b=mP1Q+1TI1X7kzbF5telEvUQY3LIDQDobFtwglRpfAw4GgawFXaQJCjC77lLHKvgBsp
         766z7ieL9iPtAywOPx1HR2WaMSwSg8M+lFkq1vC0KDu+dLCU3At/P5FkudIbuQkDcx5o
         J/pFMINGMMZ6sNg5EjYZhSzcyjLrf/kqByuKwZSU16BUkVPmQaI3yqKQeqlETAle4h6u
         xjgnMCzPSGkAJzRH6XTNYNNhe/rH48T1w3SW8FvuH4aQYyNbvyPjL09z68iijrlEpM8k
         7ofM1O0zZb7IY90ZcRf8hHh4zOigIuPJ989LUq8x+cgAOURgBfJWeNZk3RzeA67stn5N
         sjDg==
X-Gm-Message-State: AOAM530H/Q/TIr01gpJPIcSkd+VZMjU8NpeT8nRPS4IgRr54M/+tyFCo
        cu99Qw63YsuTH929zeZBb7Z4NnY59JM3hqRiOGnPVSw3Jmxhh+A/pjkFr0YriJ1ssUd3XSGwRRF
        AmusFusXfBpco
X-Received: by 2002:a05:6402:7d8:: with SMTP id u24mr56590377edy.215.1638018991836;
        Sat, 27 Nov 2021 05:16:31 -0800 (PST)
X-Google-Smtp-Source: ABdhPJw6vEbb+Kp1fF0UmX5GI6yeuYFqQIsquieDGtN50C1q4QYp2pxFO361DnTZ1l1WoWXZzKUvSg==
X-Received: by 2002:a05:6402:7d8:: with SMTP id u24mr56590351edy.215.1638018991687;
        Sat, 27 Nov 2021 05:16:31 -0800 (PST)
Received: from gator.home (cst2-173-70.cust.vodafone.cz. [31.30.173.70])
        by smtp.gmail.com with ESMTPSA id qa7sm4536940ejc.64.2021.11.27.05.16.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 27 Nov 2021 05:16:31 -0800 (PST)
Date:   Sat, 27 Nov 2021 14:16:28 +0100
From:   Andrew Jones <drjones@redhat.com>
To:     Raghavendra Rao Ananta <rananta@google.com>
Cc:     Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>, Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Oliver Upton <oupton@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [RFC PATCH v2 01/11] KVM: arm64: Factor out firmware register
 handling from psci.c
Message-ID: <20211127131628.iihianybqbeyjdbg@gator.home>
References: <20211113012234.1443009-1-rananta@google.com>
 <20211113012234.1443009-2-rananta@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211113012234.1443009-2-rananta@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Nov 13, 2021 at 01:22:24AM +0000, Raghavendra Rao Ananta wrote:
> Common hypercall firmware register handing is currently employed
> by psci.c. Since the upcoming patches add more of these registers,
> it's better to move the generic handling to hypercall.c for a
> cleaner presentation.
> 
> While we are at it, collect all the firmware registers under
> fw_reg_ids[] to help implement kvm_arm_get_fw_num_regs() and
> kvm_arm_copy_fw_reg_indices() in a generic way.
> 
> No functional change intended.
> 
> Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> ---
>  arch/arm64/kvm/guest.c       |   2 +-
>  arch/arm64/kvm/hypercalls.c  | 170 +++++++++++++++++++++++++++++++++++
>  arch/arm64/kvm/psci.c        | 166 ----------------------------------
>  include/kvm/arm_hypercalls.h |   7 ++
>  include/kvm/arm_psci.h       |   7 --
>  5 files changed, 178 insertions(+), 174 deletions(-)
> 
> diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
> index 5ce26bedf23c..625f97f7b304 100644
> --- a/arch/arm64/kvm/guest.c
> +++ b/arch/arm64/kvm/guest.c
> @@ -18,7 +18,7 @@
>  #include <linux/string.h>
>  #include <linux/vmalloc.h>
>  #include <linux/fs.h>
> -#include <kvm/arm_psci.h>
> +#include <kvm/arm_hypercalls.h>
>  #include <asm/cputype.h>
>  #include <linux/uaccess.h>
>  #include <asm/fpsimd.h>
> diff --git a/arch/arm64/kvm/hypercalls.c b/arch/arm64/kvm/hypercalls.c
> index 30da78f72b3b..9e136d91b470 100644
> --- a/arch/arm64/kvm/hypercalls.c
> +++ b/arch/arm64/kvm/hypercalls.c
> @@ -146,3 +146,173 @@ int kvm_hvc_call_handler(struct kvm_vcpu *vcpu)
>  	smccc_set_retval(vcpu, val[0], val[1], val[2], val[3]);
>  	return 1;
>  }
> +
> +static const u64 fw_reg_ids[] = {
> +	KVM_REG_ARM_PSCI_VERSION,
> +	KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_1,
> +	KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2,
> +};
> +
> +int kvm_arm_get_fw_num_regs(struct kvm_vcpu *vcpu)
> +{
> +	return ARRAY_SIZE(fw_reg_ids);
> +}
> +
> +int kvm_arm_copy_fw_reg_indices(struct kvm_vcpu *vcpu, u64 __user *uindices)
> +{
> +	int i;
> +
> +	for (i = 0; i < ARRAY_SIZE(fw_reg_ids); i++) {
> +		if (put_user(fw_reg_ids[i], uindices))

This is missing the ++ on uindices, so it just writes the same offset
three times.

> +			return -EFAULT;
> +	}
> +
> +	return 0;
> +}

I assume the rest of the patch is just a cut+paste move of code.

Thanks,
drew

