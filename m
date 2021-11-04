Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A8AB444BF3
	for <lists+kvm@lfdr.de>; Thu,  4 Nov 2021 01:23:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232771AbhKDA03 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Nov 2021 20:26:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232259AbhKDA02 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Nov 2021 20:26:28 -0400
Received: from mail-io1-xd31.google.com (mail-io1-xd31.google.com [IPv6:2607:f8b0:4864:20::d31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43C0BC061714
        for <kvm@vger.kernel.org>; Wed,  3 Nov 2021 17:23:51 -0700 (PDT)
Received: by mail-io1-xd31.google.com with SMTP id p193so4973355iod.8
        for <kvm@vger.kernel.org>; Wed, 03 Nov 2021 17:23:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=GJHduIoLbm++PXo1EI9ctmGW1RwoyK72y3OY0VPBDcU=;
        b=jUR/GFvWK1GOvD7Tfxk3VIQLmqOGgFb5VaXQJqkZQpsZVHVN1VvJwhZ9ekdTub4o3Y
         /FoswRQyi2S84daaMTIAWZ+mbmA4/ahSy+DhuOt0Gs4dAsaoDjJsyaxFD1o/zDdXwMwr
         IQeiiLI//6cJ1aPm9ItJN8j7Y5V+O5EUei3K7AEOsdK7bAREGOclHn9V3b3D/qfWNdnQ
         46bl9OMMumnpjKt5V3ThiCfCTAjXlmBk6pMLd2s++zGNkoI7NOhithCH4bedvs+7gl1d
         odN7ejoM2KJDLUmOnsxjtAq0MYDaTBwDI81FkSVeYHBkWV87C4htjIKhLS0zCxoxGl1s
         jObg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=GJHduIoLbm++PXo1EI9ctmGW1RwoyK72y3OY0VPBDcU=;
        b=Ny9r8vcmId2GdY+xOCLnlM2U1IwHtEsGkKl/y7RsVdXLrGUe5Ex4nYIVkFNr6lC28G
         vIy6EW6fZElB9BOyP/m3TOl1WwudWqshPGs1h4QaxnGCC2Dge8oCXZkR9Zga2d7VMWML
         ZwQo09tRYgyvFdK/OGv4yr6+XxdAGEgrofYalEQg7unTtrybMA9fxaOOWUp+n7TQNXIL
         21pvpJbHYUz3aYkULLOwNqJni4B0i9FT+v7gVEybIgnE89o5wxwmt9CJxaSP+1G0dBwL
         JTHbb38YQjZmcx+Kyi/6TYczQ6iO9xtISst0jqMDIaeG4o6Y6wTebf/MedMyifKbqNOh
         CiKA==
X-Gm-Message-State: AOAM532Fl3xepVl9YZMiWuXo6K0IOHPO5THs7laivzRAMUpvTvpO43jQ
        JmdYO6+gTKTV2FC3lUQl26XS1A==
X-Google-Smtp-Source: ABdhPJyTGKht0zujMuYCiiB6MJx/sODaKaDOpIuVJQZerGrdP28hHl/7//HWQ2d2tD6/tKDFH4UFMQ==
X-Received: by 2002:a5d:954b:: with SMTP id a11mr33541647ios.99.1635985429851;
        Wed, 03 Nov 2021 17:23:49 -0700 (PDT)
Received: from google.com (194.225.68.34.bc.googleusercontent.com. [34.68.225.194])
        by smtp.gmail.com with ESMTPSA id s5sm1881667ilq.59.2021.11.03.17.23.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Nov 2021 17:23:49 -0700 (PDT)
Date:   Thu, 4 Nov 2021 00:23:45 +0000
From:   Oliver Upton <oupton@google.com>
To:     Raghavendra Rao Ananta <rananta@google.com>
Cc:     Marc Zyngier <maz@kernel.org>, Andrew Jones <drjones@redhat.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>, Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [RFC PATCH 6/8] tools: Import the firmware registers
Message-ID: <YYMoEYzBvEqN5MD7@google.com>
References: <20211102002203.1046069-1-rananta@google.com>
 <20211102002203.1046069-7-rananta@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211102002203.1046069-7-rananta@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Nov 02, 2021 at 12:22:01AM +0000, Raghavendra Rao Ananta wrote:
> Import the firmware definitions for the firmware registers,
> KVM_REG_ARM_STD, KVM_REG_ARM_STD_HYP, and KVM_REG_ARM_VENDOR_HYP.
> 
> Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> 
> ---
>  tools/arch/arm64/include/uapi/asm/kvm.h | 18 ++++++++++++++++++
>  1 file changed, 18 insertions(+)

Won't we have the latest UAPI headers available in usr/include/ at build
time?

--
Oliver

> diff --git a/tools/arch/arm64/include/uapi/asm/kvm.h b/tools/arch/arm64/include/uapi/asm/kvm.h
> index b3edde68bc3e..a1d0e8e69eed 100644
> --- a/tools/arch/arm64/include/uapi/asm/kvm.h
> +++ b/tools/arch/arm64/include/uapi/asm/kvm.h
> @@ -281,6 +281,24 @@ struct kvm_arm_copy_mte_tags {
>  #define KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_NOT_REQUIRED	3
>  #define KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_ENABLED     	(1U << 4)
>  
> +#define KVM_REG_ARM_STD			KVM_REG_ARM_FW_REG(3)
> +enum kvm_reg_arm_std_bmap {
> +	KVM_REG_ARM_STD_TRNG_V1_0,
> +	KVM_REG_ARM_STD_BMAP_MAX,
> +};
> +
> +#define KVM_REG_ARM_STD_HYP		KVM_REG_ARM_FW_REG(4)
> +enum kvm_reg_arm_std_hyp_bmap {
> +	KVM_REG_ARM_STD_HYP_PV_TIME_ST,
> +	KVM_REG_ARM_STD_HYP_BMAP_MAX,
> +};
> +
> +#define KVM_REG_ARM_VENDOR_HYP		KVM_REG_ARM_FW_REG(5)
> +enum kvm_reg_arm_vendor_hyp_bmap {
> +	KVM_REG_ARM_VENDOR_HYP_PTP,
> +	KVM_REG_ARM_VENDOR_HYP_BMAP_MAX,
> +};
> +
>  /* SVE registers */
>  #define KVM_REG_ARM64_SVE		(0x15 << KVM_REG_ARM_COPROC_SHIFT)
>  
> -- 
> 2.33.1.1089.g2158813163f-goog
> 
