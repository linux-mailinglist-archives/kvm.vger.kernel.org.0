Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F1D17B0DC8
	for <lists+kvm@lfdr.de>; Wed, 27 Sep 2023 22:55:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230102AbjI0UzL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Sep 2023 16:55:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230093AbjI0Uy7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 Sep 2023 16:54:59 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B786210D9
        for <kvm@vger.kernel.org>; Wed, 27 Sep 2023 13:54:48 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id d9443c01a7336-1c456e605easo162482945ad.2
        for <kvm@vger.kernel.org>; Wed, 27 Sep 2023 13:54:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1695848088; x=1696452888; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ojApjJdra5G2e9VG7iCI1/QYu+pQelbcKUfyRfxvagM=;
        b=t8EqehXMh8Bxqh+7BVXB2x3pkGyMz0aqujzOxWBpTvLB8auz/8GYBhLUL6lTJD+JYb
         EPr9R2NgOFnQmAiM1LEkCqVhs0SK0R6drtM+PZMElBCgorZj+MQwU071/Orm60XkU3Cg
         HJ/nj+6LH13MuUaxgK0jP0KgnMWXQNGd3DNqEJwr2+HCzSTzKUPFprbHsohhTWiZEqRz
         rPAZQfG4BvET2Fm1L+yeSdkV5ZRYUs2qngcB3w6lawSPRYfu087ng/UKsvyjrx5oge1Y
         mNg9HtP0UDKjl+ToCaHnYGjbAR2jUm7/bDgjPPO9oWNoTxsANjwR3O1L26zXG/cVRaSR
         jZuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695848088; x=1696452888;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ojApjJdra5G2e9VG7iCI1/QYu+pQelbcKUfyRfxvagM=;
        b=kttklZcLa55C3hJPcDucbAAscX300fme1X/L+Noe85CGq6AjFD4ruo5RPjivi5Yded
         WupB/nhmf4ElSbp6FvN7/j/WMlfRJ/VsKbd/s9yE9nI+Y4C6871pkQbyAR43CzXSL+Wj
         8HOWd+GcTQms3pI4yePwZ2RVqVneTe58LXMzEIk28yPbARAAPYHheNxkCfsyjDgDAVYH
         UipcGPLbRvJFQK99JAx9nQSnb1bbEKPYSHEBYGqaDHzgCFVbAToreODtbE/NTYC+di6Y
         0lBuKfMYJRawQWi69vd4NQmjegmRszOn+LUn7Aj1huTdbeFSikQFZsH35hJ1u4IebOeJ
         /4DQ==
X-Gm-Message-State: AOJu0YxdpY/pNF98YLzUziZpBHg3fg1r3crkZGsSj9O0cBZ4ZfyZrin1
        iFwD9TMS44KTp9vajkwahPK0tiCdqWc=
X-Google-Smtp-Source: AGHT+IFj1EdT+JgGVa0wI51EvOhfb55LdAwkzQLPbe8TUXZIGLvgHWRpoJJlNYQvgrk8VKDZMzPRxZN9+I4=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:903:2452:b0:1bc:4c3d:eb08 with SMTP id
 l18-20020a170903245200b001bc4c3deb08mr39333pls.8.1695848088093; Wed, 27 Sep
 2023 13:54:48 -0700 (PDT)
Date:   Wed, 27 Sep 2023 13:54:46 -0700
In-Reply-To: <20230807065137.3408970-4-zhaotianrui@loongson.cn>
Mime-Version: 1.0
References: <20230807065137.3408970-1-zhaotianrui@loongson.cn> <20230807065137.3408970-4-zhaotianrui@loongson.cn>
Message-ID: <ZRSWlqS3zQBSLFVK@google.com>
Subject: Re: [PATCH v2 3/4] KVM: selftests: Add ucall test support for LoongArch
From:   Sean Christopherson <seanjc@google.com>
To:     Tianrui Zhao <zhaotianrui@loongson.cn>
Cc:     Shuah Khan <shuah@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Vishal Annapurve <vannapurve@google.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        WANG Xuerui <kernel@xen0n.name>, loongarch@lists.linux.dev,
        Peter Xu <peterx@redhat.com>,
        Vipin Sharma <vipinsh@google.com>, maobibo@loongson.cn
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Aug 07, 2023, Tianrui Zhao wrote:
> Add ucall test support for LoongArch. A ucall is a "hypercall to
> userspace".

Nit, can you explain why LoongArch uses MMIO to trigger ucall, and what alternatives
were considred (if any)?  The main reason for the ask is because we've tossed
around the idea of converting all architectures (except s390) to MMIO-based ucall
in order to reduce the number of "flavors" of ucall we have to worry about it.
If MMIO is the only reasonable choice for LoongArch, that's another reason to
double down on MMIO as the primary choice for ucall.

> Based-on: <20230803022138.2736430-1-zhaotianrui@loongson.cn>
> Signed-off-by: Tianrui Zhao <zhaotianrui@loongson.cn>
> ---
>  .../selftests/kvm/lib/loongarch/ucall.c       | 43 +++++++++++++++++++
>  1 file changed, 43 insertions(+)
>  create mode 100644 tools/testing/selftests/kvm/lib/loongarch/ucall.c
> 
> diff --git a/tools/testing/selftests/kvm/lib/loongarch/ucall.c b/tools/testing/selftests/kvm/lib/loongarch/ucall.c
> new file mode 100644
> index 000000000000..72868ddec313
> --- /dev/null
> +++ b/tools/testing/selftests/kvm/lib/loongarch/ucall.c
> @@ -0,0 +1,43 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * ucall support. A ucall is a "hypercall to userspace".
> + *
> + */
> +#include "kvm_util.h"
> +
> +/*
> + * ucall_exit_mmio_addr holds per-VM values (global data is duplicated by each
> + * VM), it must not be accessed from host code.
> + */
> +static vm_vaddr_t *ucall_exit_mmio_addr;
> +
> +void ucall_arch_init(struct kvm_vm *vm, vm_paddr_t mmio_gpa)
> +{
> +	vm_vaddr_t mmio_gva = vm_vaddr_unused_gap(vm, vm->page_size, KVM_UTIL_MIN_VADDR);
> +
> +	virt_map(vm, mmio_gva, mmio_gpa, 1);
> +
> +	vm->ucall_mmio_addr = mmio_gpa;
> +
> +	write_guest_global(vm, ucall_exit_mmio_addr, (vm_vaddr_t *)mmio_gva);
> +}
> +
> +void ucall_arch_do_ucall(vm_vaddr_t uc)
> +{
> +	WRITE_ONCE(*ucall_exit_mmio_addr, uc);

Another uber nit, you might want to put this in the header as a static inline to
avoid function calls.  I doubt it'll actually matter, but we've had enough weird,
hard-to-debug issues with ucall that minimizing the amount of generated code might
save some future pain.
