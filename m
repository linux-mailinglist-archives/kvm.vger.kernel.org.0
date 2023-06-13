Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6038972EDBF
	for <lists+kvm@lfdr.de>; Tue, 13 Jun 2023 23:16:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236267AbjFMVQV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Jun 2023 17:16:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230471AbjFMVQU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Jun 2023 17:16:20 -0400
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CE7110FE
        for <kvm@vger.kernel.org>; Tue, 13 Jun 2023 14:16:19 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id d2e1a72fcca58-661fcfbafdaso3510771b3a.1
        for <kvm@vger.kernel.org>; Tue, 13 Jun 2023 14:16:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1686690978; x=1689282978;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=zoXsbeVfXLLEsjLQrLANrMHnuV7SIcBeWtBPaSlJE0U=;
        b=zQ7R5o0craf7u+8BFUd0XqKzaiFd07QQ12Eidv2oX82/8xpvNaNd5d3F1TCTk6N0Hu
         7fMAmHEwJDyPmDip2pmYEeWftlaTmP5dIu41ZGeOFz45S21m6tXwg30hbcF3thUzi676
         vzpD724q+62Lf8U9Gs9MKk4E/8JtwMR99WvwZB1LR98kFvEt6ayHb9QgvMry583OCgJV
         lblJoGrE/X04cAdDQliEfEc/u/0GX09ErJvgFy+LvpVV5l8d0IOk2DTITEBHELAeAkNh
         50M+uJ4OhYkQVSE9h6BW4mKFbmJK1/oUtMREUc0flhuMb3gVbi/lwRS/0faB5gRn/RtF
         ddZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686690978; x=1689282978;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zoXsbeVfXLLEsjLQrLANrMHnuV7SIcBeWtBPaSlJE0U=;
        b=LA9Gnhgxzx3gtqmI6BYu2JL9UPh2DWlWV1wrQ4/4L8rvQxwMsf7FhvKI6R7YiHIDv7
         LJoorC8uMCyFulTS+ROK9Xsiew5IX0OtkvrUrRSfMFSL4JVWduZQH2RSbENQ8QkCrSgk
         rl9C4kYuRrtVkCqQ5GPIaP+DLAyhxGj1KRlNAf+1w1nZb3eTvEW/hpiK0BOdhBzXNt7X
         +xRrnwjW0+Bsf1SLDua/pq1pLz76kDQU+VNYDU6czRy5beXjgnhJqS2kzUstzD+jPwnQ
         V2+kX6uV+adcKWZ36aPPa7eVVkd30Mgv/+o5tW4mexCMEM1vWkSrR7MUwhel3H67TINR
         KTNg==
X-Gm-Message-State: AC+VfDzuwvVHiriF20xa1Y31rLfwqtjAtkvRs2cdhJiz0on5R2C1kWxa
        P1D/HTqcIap6OfxhsTWMvo89xq/oJuE=
X-Google-Smtp-Source: ACHHUZ7p7HWyWa7uo6JIcTCl2qEWne7t8Z1pA5sTVB2E6o4i4fbc3cAgW8yVZwQOXwCLEQAIaBcF/pXVJrY=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:2d1d:b0:63a:ff2a:bf9f with SMTP id
 fa29-20020a056a002d1d00b0063aff2abf9fmr9201pfb.2.1686690978636; Tue, 13 Jun
 2023 14:16:18 -0700 (PDT)
Date:   Tue, 13 Jun 2023 14:16:16 -0700
In-Reply-To: <20230315101606.10636-1-wei.w.wang@intel.com>
Mime-Version: 1.0
References: <20230315101606.10636-1-wei.w.wang@intel.com>
Message-ID: <ZIjcoOaexz5YAyWT@google.com>
Subject: Re: [PATCH RESEND v2] KVM: move KVM_CAP_DEVICE_CTRL to the generic check
From:   Sean Christopherson <seanjc@google.com>
To:     Wei Wang <wei.w.wang@intel.com>
Cc:     pbonzini@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        Oliver Upton <oliver.upton@linux.dev>,
        Anup Patel <anup@brainfault.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org,
        linux-riscv@lists.infradead.org
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

+<everyone else>

Please use scripts/get_maintainer.pl to generate the To/Cc lists.  This may be
trivial, but it still needs eyeballs from the relevant maintainers.

On Wed, Mar 15, 2023, Wei Wang wrote:
> KVM_CAP_DEVICE_CTRL allows userspace to check if the kvm_device
> framework (e.g. KVM_CREATE_DEVICE) is supported by KVM. Move
> KVM_CAP_DEVICE_CTRL to the generic check for the two reasons:
> 1) it already supports arch agnostic usages (i.e. KVM_DEV_TYPE_VFIO).
> For example, userspace VFIO implementation may needs to create
> KVM_DEV_TYPE_VFIO on x86, riscv, or arm etc. It is simpler to have it
> checked at the generic code than at each arch's code.
> 2) KVM_CREATE_DEVICE has been added to the generic code.
> 
> Link: https://lore.kernel.org/all/20221215115207.14784-1-wei.w.wang@intel.com
> Signed-off-by: Wei Wang <wei.w.wang@intel.com>
> Reviewed-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/arm64/kvm/arm.c       | 1 -
>  arch/powerpc/kvm/powerpc.c | 1 -
>  arch/riscv/kvm/vm.c        | 1 -
>  arch/s390/kvm/kvm-s390.c   | 1 -
>  virt/kvm/kvm_main.c        | 1 +
>  5 files changed, 1 insertion(+), 4 deletions(-)
> 
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index 3bd732eaf087..96329e675771 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -202,7 +202,6 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>  		r = vgic_present;
>  		break;
>  	case KVM_CAP_IOEVENTFD:
> -	case KVM_CAP_DEVICE_CTRL:
>  	case KVM_CAP_USER_MEMORY:
>  	case KVM_CAP_SYNC_MMU:
>  	case KVM_CAP_DESTROY_MEMORY_REGION_WORKS:
> diff --git a/arch/powerpc/kvm/powerpc.c b/arch/powerpc/kvm/powerpc.c
> index 4c5405fc5538..185efed23896 100644
> --- a/arch/powerpc/kvm/powerpc.c
> +++ b/arch/powerpc/kvm/powerpc.c
> @@ -526,7 +526,6 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>  	case KVM_CAP_ENABLE_CAP:
>  	case KVM_CAP_ONE_REG:
>  	case KVM_CAP_IOEVENTFD:
> -	case KVM_CAP_DEVICE_CTRL:
>  	case KVM_CAP_IMMEDIATE_EXIT:
>  	case KVM_CAP_SET_GUEST_DEBUG:
>  		r = 1;
> diff --git a/arch/riscv/kvm/vm.c b/arch/riscv/kvm/vm.c
> index 65a964d7e70d..6efe93b282e1 100644
> --- a/arch/riscv/kvm/vm.c
> +++ b/arch/riscv/kvm/vm.c
> @@ -57,7 +57,6 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>  
>  	switch (ext) {
>  	case KVM_CAP_IOEVENTFD:
> -	case KVM_CAP_DEVICE_CTRL:
>  	case KVM_CAP_USER_MEMORY:
>  	case KVM_CAP_SYNC_MMU:
>  	case KVM_CAP_DESTROY_MEMORY_REGION_WORKS:
> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
> index 39b36562c043..7b097b5253ca 100644
> --- a/arch/s390/kvm/kvm-s390.c
> +++ b/arch/s390/kvm/kvm-s390.c
> @@ -556,7 +556,6 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>  	case KVM_CAP_ENABLE_CAP:
>  	case KVM_CAP_S390_CSS_SUPPORT:
>  	case KVM_CAP_IOEVENTFD:
> -	case KVM_CAP_DEVICE_CTRL:
>  	case KVM_CAP_S390_IRQCHIP:
>  	case KVM_CAP_VM_ATTRIBUTES:
>  	case KVM_CAP_MP_STATE:
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index d255964ec331..71cc63640173 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -4523,6 +4523,7 @@ static long kvm_vm_ioctl_check_extension_generic(struct kvm *kvm, long arg)
>  #endif
>  	case KVM_CAP_BINARY_STATS_FD:
>  	case KVM_CAP_SYSTEM_EVENT_DATA:
> +	case KVM_CAP_DEVICE_CTRL:
>  		return 1;
>  	default:
>  		break;
> -- 
> 2.27.0
> 
