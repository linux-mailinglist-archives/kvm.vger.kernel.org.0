Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 140DC40A709
	for <lists+kvm@lfdr.de>; Tue, 14 Sep 2021 09:03:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240444AbhINHFE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Sep 2021 03:05:04 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:46375 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240327AbhINHFD (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 14 Sep 2021 03:05:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1631603026;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=DtVBH46SHKoKIwsFmytf76PwR5kg53yG9EF+y3kvUPg=;
        b=DthXNV5cGt95UYpThJY7moAubnRqZpF90NWZdcn7y9BGDzviRbcqg55/5O6ouLxi27zrOf
        q8XgmCgxICqJ5j9iFnEe8CBLnyvYqQyoW7CNlC0sRbg9OQ57nQrVbl672zZrUfFxT3rDEw
        VN/wN2J7oVHzPy5Vxv9hc1ofR5cXiwg=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-48-HxuBtRueNeivo10rTc4w9Q-1; Tue, 14 Sep 2021 03:03:44 -0400
X-MC-Unique: HxuBtRueNeivo10rTc4w9Q-1
Received: by mail-ed1-f72.google.com with SMTP id w24-20020a056402071800b003cfc05329f8so6268031edx.19
        for <kvm@vger.kernel.org>; Tue, 14 Sep 2021 00:03:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=DtVBH46SHKoKIwsFmytf76PwR5kg53yG9EF+y3kvUPg=;
        b=0XJHcb77yna6vDRxxCShzZi+LKHYzXrlkxLOd81I5UJgAdR869VIf9tK6lVlgVKFDR
         HRP44kIj4UTGLpERYvyHKXZfZ+ZrlH/hVcnTDiFt8ZorJQgboo2VG8GXyv0o+jPrcZtR
         FTjesEnDX+fmGykR/aFAQIvyNeW80aP7nKC93qPH6OgEis+hsMZtaB/h3OwnyIIiHWmZ
         3bmnJOoP0DLfDN0v5QDPLdltmp9tbSJWr/SJMjZP+XheNSfHAlzfLU1Qovl5JaZrQr4g
         4IDfOE4zNaB1o4dr+wC5vyqn3mZvT+WSa9q4i0EKJX145bpvSh5SklvwOkIXma0IfFCr
         XYYA==
X-Gm-Message-State: AOAM531bd+HAwApFMR25DrVblQIgtP2yEbsF76ngg8EMOoHzWcBRFBBu
        0QnjbRlGp5dpdVshRP+NLx06VjlD5mq7k9c8pggWcvcqasNX3cT5vH86E6yTrZb8Ex8vAnvFL7D
        DdFBT+MAR/jHH
X-Received: by 2002:a05:6402:b51:: with SMTP id bx17mr3708315edb.193.1631603023666;
        Tue, 14 Sep 2021 00:03:43 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz0u6Qmz0LoEVgIkKptzeNa1oFg+cIIJwCsprxz814Q0ubDMMz/MEr05MP7ZdWlQt3KbrYwPQ==
X-Received: by 2002:a05:6402:b51:: with SMTP id bx17mr3708282edb.193.1631603023377;
        Tue, 14 Sep 2021 00:03:43 -0700 (PDT)
Received: from gator.home (cst2-174-132.cust.vodafone.cz. [31.30.174.132])
        by smtp.gmail.com with ESMTPSA id bq4sm4460079ejb.43.2021.09.14.00.03.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Sep 2021 00:03:42 -0700 (PDT)
Date:   Tue, 14 Sep 2021 09:03:40 +0200
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
Subject: Re: [PATCH v6 09/14] KVM: arm64: selftests: Add guest support to get
 the vcpuid
Message-ID: <20210914070340.u6fp5zo7pjpxdlga@gator.home>
References: <20210913230955.156323-1-rananta@google.com>
 <20210913230955.156323-10-rananta@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210913230955.156323-10-rananta@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Sep 13, 2021 at 11:09:50PM +0000, Raghavendra Rao Ananta wrote:
> At times, such as when in the interrupt handler, the guest wants
> to get the vcpuid that it's running on to pull the per-cpu private
> data. As a result, introduce guest_get_vcpuid() that returns the
> vcpuid of the calling vcpu. The interface is architecture
> independent, but defined only for arm64 as of now.
> 
> Suggested-by: Reiji Watanabe <reijiw@google.com>
> Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> Reviewed-by: Ricardo Koller <ricarkol@google.com>
> ---
>  tools/testing/selftests/kvm/include/kvm_util.h      | 2 ++
>  tools/testing/selftests/kvm/lib/aarch64/processor.c | 6 ++++++
>  2 files changed, 8 insertions(+)
> 
> diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
> index 010b59b13917..5770751a5735 100644
> --- a/tools/testing/selftests/kvm/include/kvm_util.h
> +++ b/tools/testing/selftests/kvm/include/kvm_util.h
> @@ -400,4 +400,6 @@ uint64_t get_ucall(struct kvm_vm *vm, uint32_t vcpu_id, struct ucall *uc);
>  int vm_get_stats_fd(struct kvm_vm *vm);
>  int vcpu_get_stats_fd(struct kvm_vm *vm, uint32_t vcpuid);
>  
> +int guest_get_vcpuid(void);
> +
>  #endif /* SELFTEST_KVM_UTIL_H */
> diff --git a/tools/testing/selftests/kvm/lib/aarch64/processor.c b/tools/testing/selftests/kvm/lib/aarch64/processor.c
> index db64ee206064..f1255f44dad0 100644
> --- a/tools/testing/selftests/kvm/lib/aarch64/processor.c
> +++ b/tools/testing/selftests/kvm/lib/aarch64/processor.c
> @@ -277,6 +277,7 @@ void aarch64_vcpu_setup(struct kvm_vm *vm, int vcpuid, struct kvm_vcpu_init *ini

x86's vcpu_setup strangely uses 'int' for vcpuid even though everywhere
else we use uint32_t. Unfortunately that strangeness got inherited by
aarch64 (my fault). We should change it to uint32_t here (as a separate
patch) and...

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
> +int guest_get_vcpuid(void)
> +{
> +	return read_sysreg(tpidr_el1);
> +}

...return uint32_t here.

Thanks,
drew

