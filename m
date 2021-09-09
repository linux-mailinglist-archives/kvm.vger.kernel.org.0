Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E8854045EB
	for <lists+kvm@lfdr.de>; Thu,  9 Sep 2021 09:04:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350631AbhIIHFq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Sep 2021 03:05:46 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:25579 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236180AbhIIHFm (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 9 Sep 2021 03:05:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1631171073;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=l2l5r4SBCHwEiq0ScaB4dWcgzj5hh1v8SYuZuO29rHo=;
        b=JQg0hWdqMt8c0gs+TnrlcGs0gllLgjO6JSIQPWcDvwCiTM8z8++8MhHxuwFsZL4nyzbz3v
        H5kEGid6hDG0Y6SJ2fc6uLMaemocY3SXm15++zCgIxkMQJR3LZztX9mMi3JeRIlawPFPYM
        lz71HHLc9PLq07nUYtg5iPn9CVM1MEg=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-374-PolZlBzMOriFXoPcw0j5DA-1; Thu, 09 Sep 2021 03:04:32 -0400
X-MC-Unique: PolZlBzMOriFXoPcw0j5DA-1
Received: by mail-ej1-f72.google.com with SMTP id ak17-20020a170906889100b005c5d1e5e707so316524ejc.16
        for <kvm@vger.kernel.org>; Thu, 09 Sep 2021 00:04:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=l2l5r4SBCHwEiq0ScaB4dWcgzj5hh1v8SYuZuO29rHo=;
        b=AFt8uVSGZ3Doprj+8NM/i3A9wtneQgKe3EI7ksKOamsnb/wpLzLcFihvFmCVEGjLjD
         EFOqNT8NKRmb5xSP4fCXa+7DVIPw2kBs9qoPs/Jsbr/8TgsdV2kuGC+IzkZdITd71gS8
         D/xZybvpStyPoVDEBl95tm4A5xeJT8XZX3TibE5icCNxGtZR6rFKMB8uxRBbY0uo6WK1
         cjCjQm0gzCoh93GPl5lgAw80Omm6E9Zp6GyIHuk1cL/j8f7+UxTP4Qx9NousmxMNMWxo
         4tzTbMJpP2wKlGHXWE1EAFMbcY7lOWCFiicY6KOrcScedkU4gaDgbD4NrB+X0EdRWniJ
         8XEw==
X-Gm-Message-State: AOAM532UzRsG0UHkKUrL5G81P+g4U73PNxqucEXyYD/uoplQN23N09ps
        mHAXwjxdtd4gQCpwWQYI1UQy3M+LQ0H8XcFLXNjT2s6bpGJcCzDMbPfocO0htBp1eP/fINrVnWM
        w2hmTj0u+fI0J
X-Received: by 2002:a17:906:7302:: with SMTP id di2mr1869672ejc.409.1631171070890;
        Thu, 09 Sep 2021 00:04:30 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxaTI3qYEno3ZJd14sTF6cADqRVW3Joo5jc8lsKG9esd951qp14KjQPeWPkFFvJv/w4BJzeLw==
X-Received: by 2002:a17:906:7302:: with SMTP id di2mr1869651ejc.409.1631171070762;
        Thu, 09 Sep 2021 00:04:30 -0700 (PDT)
Received: from gator (cst2-174-132.cust.vodafone.cz. [31.30.174.132])
        by smtp.gmail.com with ESMTPSA id cr9sm499745edb.17.2021.09.09.00.04.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Sep 2021 00:04:30 -0700 (PDT)
Date:   Thu, 9 Sep 2021 09:04:23 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Raghavendra Rao Ananta <rananta@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>, Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Oliver Upton <oupton@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v4 04/18] KVM: arm64: selftests: Introduce
 ARM64_SYS_KVM_REG
Message-ID: <20210909070423.5z4eg7wkmswpdi33@gator>
References: <20210909013818.1191270-1-rananta@google.com>
 <20210909013818.1191270-5-rananta@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210909013818.1191270-5-rananta@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 09, 2021 at 01:38:04AM +0000, Raghavendra Rao Ananta wrote:
> With the inclusion of sysreg.h, that brings in system register
> encodings, it would be redundant to re-define register encodings
> again in processor.h to use it with ARM64_SYS_REG for the KVM
> functions such as set_reg() or get_reg(). Hence, add helper macro,
> ARM64_SYS_KVM_REG, that converts SYS_* definitions in sysreg.h
> into ARM64_SYS_REG definitions.
> 
> Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> ---
>  .../selftests/kvm/include/aarch64/processor.h      | 14 ++++++++++++++
>  1 file changed, 14 insertions(+)
> 
> diff --git a/tools/testing/selftests/kvm/include/aarch64/processor.h b/tools/testing/selftests/kvm/include/aarch64/processor.h
> index bed4ffa70905..ac8b63f8aab7 100644
> --- a/tools/testing/selftests/kvm/include/aarch64/processor.h
> +++ b/tools/testing/selftests/kvm/include/aarch64/processor.h
> @@ -26,6 +26,20 @@
>  
>  #define ID_AA64DFR0_EL1         3, 0,  0, 5, 0
>  
> +/*
> + * ARM64_SYS_KVM_REG(sys_reg_id): Helper macro to convert
> + * SYS_* register definitions in sysreg.h to use in KVM
> + * calls such as get_reg() and set_reg().
> + */
> +#define ARM64_SYS_KVM_REG(sys_reg_id)			\
> +({							\
> +	ARM64_SYS_REG(sys_reg_Op0(sys_reg_id),		\
> +			sys_reg_Op1(sys_reg_id),	\
> +			sys_reg_CRn(sys_reg_id),	\
> +			sys_reg_CRm(sys_reg_id),	\
> +			sys_reg_Op2(sys_reg_id));	\
> +})


I don't think we need the ({ }), do we? Anyway,

Reviewed-by: Andrew Jones <drjones@redhat.com>

Thanks,
drew

> +
>  /*
>   * Default MAIR
>   *                  index   attribute
> -- 
> 2.33.0.153.gba50c8fa24-goog
> 

