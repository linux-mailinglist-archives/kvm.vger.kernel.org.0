Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FA9740BF80
	for <lists+kvm@lfdr.de>; Wed, 15 Sep 2021 07:55:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236485AbhIOF4r (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Sep 2021 01:56:47 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:55778 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230405AbhIOF4q (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 15 Sep 2021 01:56:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1631685327;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=1DwJ1KTIB7hUlgx6Gbyk1HsMO32BArQQYzWt/TxPxbA=;
        b=evz3Jt9u07hd6MWMzJ2/7f47N9wcSMPp2LgWQhn9mHorRYrC22ZTVvsqtoRcdF5A2jKVb/
        k78Fj8jo0WYE09TCEmB4zffPPNETDdqjwwLkDdnsZXNKqoUk64S/gPv5C6p7BB2DaH7QB2
        UcI2tw3uVT8Gt7941Apacv1qNNrwMN0=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-187-RgR_9FE8MLCNPgQOZsbZIg-1; Wed, 15 Sep 2021 01:55:26 -0400
X-MC-Unique: RgR_9FE8MLCNPgQOZsbZIg-1
Received: by mail-ed1-f72.google.com with SMTP id y10-20020a056402270a00b003c8adc4d40cso933410edd.15
        for <kvm@vger.kernel.org>; Tue, 14 Sep 2021 22:55:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=1DwJ1KTIB7hUlgx6Gbyk1HsMO32BArQQYzWt/TxPxbA=;
        b=DoNhtUBV67la92XL3nf/GPFEhasKjZuS1KG/yWo4A9YZvuHfnn4+2VIwp7MyT60cnG
         U7x6C7MjWRpYVY3NczCtIqpfhlqmvMp4lF90icjbXemJaY32QDtppDz8dHCJez6MVw9L
         SuLbP8bP6r0HBEbQQA1zM+9QRRbPOVv39XKILrBZXh8+OxbkbHv1yZCIHh4iIckTp1P5
         9F2zCyeUYD/MlpUIPWQ+VTpFB+IRfFaShunHnzLpXRM0X1ul0KA8vR3uC7ccYZxQcOM9
         1FuMdu0E2y7crWjOo+OlhHsRACGUzbLawojaoJieL246ImtWM+Rex+cUXr1lbkLYTIPd
         AGRA==
X-Gm-Message-State: AOAM5335Q00Hkmq2eUoUfYNZ2/7K56xjasLjEm4aYh75cusalGUCYenA
        3pZz91LAKmo2oQ1TQTr7DmfnmKAr4vm0Ld9jwd8PLbW/b6kww7OIEDpM2QPWgMZeFM0gaHXTQKo
        1NUbAtxcX4svN
X-Received: by 2002:a17:906:7b54:: with SMTP id n20mr22648235ejo.525.1631685324890;
        Tue, 14 Sep 2021 22:55:24 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzQnNewa/jHu06DPoH582l/z5Z2baVFnXYetWnCTZNqx//uBa4MP/NR9DVl2rwfSR6xCXaEnw==
X-Received: by 2002:a17:906:7b54:: with SMTP id n20mr22648222ejo.525.1631685324745;
        Tue, 14 Sep 2021 22:55:24 -0700 (PDT)
Received: from gator.home (cst2-174-132.cust.vodafone.cz. [31.30.174.132])
        by smtp.gmail.com with ESMTPSA id f30sm5681448ejl.78.2021.09.14.22.55.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Sep 2021 22:55:24 -0700 (PDT)
Date:   Wed, 15 Sep 2021 07:55:22 +0200
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
Subject: Re: [PATCH v7 10/15] KVM: arm64: selftests: Add guest support to get
 the vcpuid
Message-ID: <20210915055522.o3wnygwk6bpr4zrx@gator.home>
References: <20210914223114.435273-1-rananta@google.com>
 <20210914223114.435273-11-rananta@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210914223114.435273-11-rananta@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Sep 14, 2021 at 10:31:09PM +0000, Raghavendra Rao Ananta wrote:
> At times, such as when in the interrupt handler, the guest wants
> to get the vcpuid that it's running on to pull the per-cpu private
> data. As a result, introduce guest_get_vcpuid() that returns the
> vcpuid of the calling vcpu. The interface is architecture
> independent, but defined only for arm64 as of now.
> 
> Suggested-by: Reiji Watanabe <reijiw@google.com>
> Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> Reviewed-by: Ricardo Koller <ricarkol@google.com>
> Reviewed-by: Reiji Watanabe <reijiw@google.com>
> ---
>  tools/testing/selftests/kvm/include/kvm_util.h      | 2 ++
>  tools/testing/selftests/kvm/lib/aarch64/processor.c | 6 ++++++
>  2 files changed, 8 insertions(+)
> 
> diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
> index 010b59b13917..bcf05f5381ed 100644
> --- a/tools/testing/selftests/kvm/include/kvm_util.h
> +++ b/tools/testing/selftests/kvm/include/kvm_util.h
> @@ -400,4 +400,6 @@ uint64_t get_ucall(struct kvm_vm *vm, uint32_t vcpu_id, struct ucall *uc);
>  int vm_get_stats_fd(struct kvm_vm *vm);
>  int vcpu_get_stats_fd(struct kvm_vm *vm, uint32_t vcpuid);
>  
> +uint32_t guest_get_vcpuid(void);
> +
>  #endif /* SELFTEST_KVM_UTIL_H */
> diff --git a/tools/testing/selftests/kvm/lib/aarch64/processor.c b/tools/testing/selftests/kvm/lib/aarch64/processor.c
> index 34f6bd47661f..b4eeeafd2a70 100644
> --- a/tools/testing/selftests/kvm/lib/aarch64/processor.c
> +++ b/tools/testing/selftests/kvm/lib/aarch64/processor.c
> @@ -277,6 +277,7 @@ void aarch64_vcpu_setup(struct kvm_vm *vm, uint32_t vcpuid, struct kvm_vcpu_init
>  	set_reg(vm, vcpuid, KVM_ARM64_SYS_REG(SYS_TCR_EL1), tcr_el1);
>  	set_reg(vm, vcpuid, KVM_ARM64_SYS_REG(SYS_MAIR_EL1), DEFAULT_MAIR_EL1);
>  	set_reg(vm, vcpuid, KVM_ARM64_SYS_REG(SYS_TTBR0_EL1), vm->pgd);
> +	set_reg(vm, vcpuid, KVM_ARM64_SYS_REG(SYS_TPIDR_EL1), vcpuid);
>  }
>  
>  void vcpu_dump(FILE *stream, struct kvm_vm *vm, uint32_t vcpuid, uint8_t indent)
> @@ -426,3 +427,8 @@ void vm_install_exception_handler(struct kvm_vm *vm, int vector,
>  	assert(vector < VECTOR_NUM);
>  	handlers->exception_handlers[vector][0] = handler;
>  }
> +
> +uint32_t guest_get_vcpuid(void)
> +{
> +	return read_sysreg(tpidr_el1);
> +}
> -- 
> 2.33.0.309.g3052b89438-goog
>

Reviewed-by: Andrew Jones <drjones@redhat.com>

