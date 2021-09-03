Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55E6A3FFBEB
	for <lists+kvm@lfdr.de>; Fri,  3 Sep 2021 10:25:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348229AbhICI0j (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Sep 2021 04:26:39 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:57929 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234700AbhICI0j (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 3 Sep 2021 04:26:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1630657539;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=784omy9+f5Am5nR2Vqkl2J0I13vidMEZa3qsfoNTT4c=;
        b=OoruEPaOqG+v63x8EC8z3lC03T5j2aFWlTDvLGYlbr4ex366xDZMXlubhUnYh5XyuQWffs
        Y/wxjSpkPLREc5gTW5gI4+e91NQi5qUDJ+Fe41PP4POfhYd7NlX8jG38EWpxvXotUAhgZl
        443VhpwTdii+vL+N+J7A28uGf9RdacI=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-232-dt5f1m4_NmKXeX_htMzIQg-1; Fri, 03 Sep 2021 04:25:38 -0400
X-MC-Unique: dt5f1m4_NmKXeX_htMzIQg-1
Received: by mail-ej1-f70.google.com with SMTP id ak17-20020a170906889100b005c5d1e5e707so2333856ejc.16
        for <kvm@vger.kernel.org>; Fri, 03 Sep 2021 01:25:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=784omy9+f5Am5nR2Vqkl2J0I13vidMEZa3qsfoNTT4c=;
        b=ICZVk2RCqaQWBzvBv+/Mv1yMUV4kb2ugu0O8Dp5YckAFowbcHR4EW1kiTkXYBLxVkh
         DgJ5h/ghh+AzuUf+3hZeI3Y/7eVTQSb2PWdopN3dXsNDCPumF56ZyVg4bKg8sKp2WvNH
         mH+D55SdoeZKCDkvfn2tiFYoLVUgJNWz/W9FwAXPOXdkdLnu6qML6AGXurN9n4+5k7Cx
         E40BWIwEKO5e13qEwgsA9/YvQ3qLZ4EX0asrjnEZoRItRmnkB7drQzezA6L541L+gshS
         MzGIhJSo1i/CISGFwUX5YJO2n4sIo9g2o0MgtS/GAYarOnMy9fKrheMZPXAKvfJECsbo
         to1w==
X-Gm-Message-State: AOAM531nrUuEtaMDcfW3e9DTnOT60Ivpsn2Gy9E5yQGySWPhrd8anDBl
        r0JcZ03MtuPHTJmy+1uR+xOnRCO++v/28bthBc97oKkn+o8HPzYGNFpY1cOfA+nhEpG3OaD1EPb
        oTTKIJi62UZHN
X-Received: by 2002:a17:906:fcda:: with SMTP id qx26mr2880455ejb.121.1630657536932;
        Fri, 03 Sep 2021 01:25:36 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzLYFAkqk2qzchrOeqo0XEuIjG+9suLbk+5wak6Qfy73DWOVulKVNgzSe4ifU3BL65WnsM8eg==
X-Received: by 2002:a17:906:fcda:: with SMTP id qx26mr2880426ejb.121.1630657536690;
        Fri, 03 Sep 2021 01:25:36 -0700 (PDT)
Received: from gator.home (cst2-174-132.cust.vodafone.cz. [31.30.174.132])
        by smtp.gmail.com with ESMTPSA id o19sm2450076edr.18.2021.09.03.01.25.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Sep 2021 01:25:36 -0700 (PDT)
Date:   Fri, 3 Sep 2021 10:25:34 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Raghavendra Rao Ananta <rananta@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        kvm@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
        Peter Shier <pshier@google.com>, linux-kernel@vger.kernel.org,
        Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v3 08/12] KVM: arm64: selftests: Add light-weight
 spinlock support
Message-ID: <20210903082534.jz3r2defqnrt2ee6@gator.home>
References: <20210901211412.4171835-1-rananta@google.com>
 <20210901211412.4171835-9-rananta@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210901211412.4171835-9-rananta@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 01, 2021 at 09:14:08PM +0000, Raghavendra Rao Ananta wrote:
> Add a simpler version of spinlock support for ARM64 for
> the guests to use.
> 
> The implementation is loosely based on the spinlock
> implementation in kvm-unit-tests.
> 
> Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> ---
>  tools/testing/selftests/kvm/Makefile          |  2 +-
>  .../selftests/kvm/include/aarch64/spinlock.h  | 13 +++++++++
>  .../selftests/kvm/lib/aarch64/spinlock.c      | 27 +++++++++++++++++++
>  3 files changed, 41 insertions(+), 1 deletion(-)
>  create mode 100644 tools/testing/selftests/kvm/include/aarch64/spinlock.h
>  create mode 100644 tools/testing/selftests/kvm/lib/aarch64/spinlock.c
> 
> diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
> index 5d05801ab816..61f0d376af99 100644
> --- a/tools/testing/selftests/kvm/Makefile
> +++ b/tools/testing/selftests/kvm/Makefile
> @@ -35,7 +35,7 @@ endif
>  
>  LIBKVM = lib/assert.c lib/elf.c lib/io.c lib/kvm_util.c lib/rbtree.c lib/sparsebit.c lib/test_util.c lib/guest_modes.c lib/perf_test_util.c
>  LIBKVM_x86_64 = lib/x86_64/apic.c lib/x86_64/processor.c lib/x86_64/vmx.c lib/x86_64/svm.c lib/x86_64/ucall.c lib/x86_64/handlers.S
> -LIBKVM_aarch64 = lib/aarch64/processor.c lib/aarch64/ucall.c lib/aarch64/handlers.S
> +LIBKVM_aarch64 = lib/aarch64/processor.c lib/aarch64/ucall.c lib/aarch64/handlers.S lib/aarch64/spinlock.c
>  LIBKVM_s390x = lib/s390x/processor.c lib/s390x/ucall.c lib/s390x/diag318_test_handler.c
>  
>  TEST_GEN_PROGS_x86_64 = x86_64/cr4_cpuid_sync_test
> diff --git a/tools/testing/selftests/kvm/include/aarch64/spinlock.h b/tools/testing/selftests/kvm/include/aarch64/spinlock.h
> new file mode 100644
> index 000000000000..cf0984106d14
> --- /dev/null
> +++ b/tools/testing/selftests/kvm/include/aarch64/spinlock.h
> @@ -0,0 +1,13 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +
> +#ifndef SELFTEST_KVM_ARM64_SPINLOCK_H
> +#define SELFTEST_KVM_ARM64_SPINLOCK_H
> +
> +struct spinlock {
> +	int v;
> +};
> +
> +extern void spin_lock(struct spinlock *lock);
> +extern void spin_unlock(struct spinlock *lock);
> +
> +#endif /* SELFTEST_KVM_ARM64_SPINLOCK_H */
> diff --git a/tools/testing/selftests/kvm/lib/aarch64/spinlock.c b/tools/testing/selftests/kvm/lib/aarch64/spinlock.c
> new file mode 100644
> index 000000000000..6d66a3dac237
> --- /dev/null
> +++ b/tools/testing/selftests/kvm/lib/aarch64/spinlock.c
> @@ -0,0 +1,27 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * ARM64 Spinlock support
> + */
> +#include <stdint.h>
> +
> +#include "spinlock.h"
> +
> +void spin_lock(struct spinlock *lock)
> +{
> +	uint32_t val, res;
> +
> +	asm volatile(
> +	"1:	ldaxr	%w0, [%2]\n"
> +	"	cbnz	%w0, 1b\n"
> +	"	mov	%w0, #1\n"
> +	"	stxr	%w1, %w0, [%2]\n"
> +	"	cbnz	%w1, 1b\n"
> +	: "=&r" (val), "=&r" (res)
> +	: "r" (&lock->v)
> +	: "memory");
> +}
> +
> +void spin_unlock(struct spinlock *lock)
> +{
> +	asm volatile("stlr wzr, [%0]\n"	: : "r" (&lock->v) : "memory");
> +}
> -- 

Reviewed-by: Andrew Jones <drjones@redhat.com>

It makes sense that the explicit barriers in kvm-unit-tests weren't also
inherited, because we already have the implicit barriers with these ld/st
instruction variants. (I suppose we could improve the kvm-unit-tests
implementation at some point.)

Thanks,
drew

