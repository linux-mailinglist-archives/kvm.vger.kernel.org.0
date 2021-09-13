Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4EB62409F0C
	for <lists+kvm@lfdr.de>; Mon, 13 Sep 2021 23:21:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242742AbhIMVXK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Sep 2021 17:23:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230426AbhIMVXK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Sep 2021 17:23:10 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAB41C061574
        for <kvm@vger.kernel.org>; Mon, 13 Sep 2021 14:21:53 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id lb1-20020a17090b4a4100b001993f863df2so1055792pjb.5
        for <kvm@vger.kernel.org>; Mon, 13 Sep 2021 14:21:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=fWNyNuWnfBEyX//B3PcmZaO6uYna7uC+39up3Pmvm+8=;
        b=VNbYPScpWdu/+9kJQYujI627m1cbPd5AK0q3W7rUtsjD+wQqf5uxTRUPkyNLcI+vsQ
         95ls9st99bgw1HEG0Lg2EnQtls8De5iWrAA1e8dA6kh+GcSy+cQi+FQaCdfsLKjo25sM
         vlVpDN7nfXWECP+z3ri6WMc3A2iYS3cqkW6Gppp2HlyhbcyOJVCH8kRBKwlxialjStqK
         9CR9Oo1Bmn654iRbxkf5vE6oPSYOMxNOKwU8ABELek1ptfDV3XlL6eDmnWRy3x8yD2ch
         2471SYHeslbj40c3FpwZTJgvANBUZxfrTM5K+vimM47ItTxkgOkK3Qd736c7HNwuu2vy
         gVWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=fWNyNuWnfBEyX//B3PcmZaO6uYna7uC+39up3Pmvm+8=;
        b=wdDaTFvuJYFsuGr1ghPieTYNugHd6BFx25CgKO51IM9oO8LFU/CRw9oby6wsyP/dUA
         u3lnnuvlE80V63fxozNJDUCPPtEo5x+co06oNRD5gODAviwQeDWvTTX3X6i5HIQds6Na
         xQJ+FyxddqSK1ix2noVfonUpnRkGlmWZRyRZwOUxLGOeEASPd9KSDSAN1ElTMg9Q3LrU
         03MIX5MYagF8g8OtUuorNy4cingD8LXdBLyH/rwFzlr8Rm8RWs9Tpnd6FOEZ4jkbjkm7
         BjaFbwUd4nPIJ5DtD9zSlr/b4/vQhhyFqZFFPuky/8sKn0Y5FuRYNSnwLwX5QQo3r78p
         itiA==
X-Gm-Message-State: AOAM531r58E+dYlgnYe1vail3Q0O8u9bZUAUI83rRZF7W93o+5JepJCK
        +yrcMed5FZ+71Yo6wFh8Ip1Dzg==
X-Google-Smtp-Source: ABdhPJwvIW9IiYxlpkcbkQt8tmAgik541eS8PeQM06VAFcAI9aAjBD1MujGdRq9Puie33WX2z1QICg==
X-Received: by 2002:a17:902:a710:b029:12b:9b9f:c461 with SMTP id w16-20020a170902a710b029012b9b9fc461mr12262098plq.59.1631568113182;
        Mon, 13 Sep 2021 14:21:53 -0700 (PDT)
Received: from google.com (150.12.83.34.bc.googleusercontent.com. [34.83.12.150])
        by smtp.gmail.com with ESMTPSA id h4sm9572790pgn.6.2021.09.13.14.21.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Sep 2021 14:21:52 -0700 (PDT)
Date:   Mon, 13 Sep 2021 14:21:49 -0700
From:   Ricardo Koller <ricarkol@google.com>
To:     Raghavendra Rao Ananta <rananta@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
        Andrew Jones <drjones@redhat.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>, Peter Shier <pshier@google.com>,
        Oliver Upton <oupton@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v5 09/14] KVM: arm64: selftests: Add guest support to get
 the vcpuid
Message-ID: <YT/A7YcsxxaBZTCn@google.com>
References: <20210913204930.130715-1-rananta@google.com>
 <20210913204930.130715-10-rananta@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210913204930.130715-10-rananta@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Sep 13, 2021 at 08:49:25PM +0000, Raghavendra Rao Ananta wrote:
> At times, such as when in the interrupt handler, the guest wants
> to get the vcpuid that it's running on to pull the per-cpu private
> data. As a result, introduce guest_get_vcpuid() that returns the
> vcpuid of the calling vcpu. The interface is architecture
> independent, but defined only for arm64 as of now.
> 
> Suggested-by: Reiji Watanabe <reijiw@google.com>
> Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
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
> -- 
> 2.33.0.309.g3052b89438-goog
>

Very nice!

Reviewed-by: Ricardo Koller <ricarkol@google.com>
