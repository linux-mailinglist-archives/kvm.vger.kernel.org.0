Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9FE249DBE1
	for <lists+kvm@lfdr.de>; Thu, 27 Jan 2022 08:49:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237513AbiA0Ht2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Jan 2022 02:49:28 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:49780 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229949AbiA0Ht2 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 27 Jan 2022 02:49:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643269767;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=2M1Y5J7ea57QbWGURJTWHJUwASXNiDDATsh/06s16sw=;
        b=BaRzcKuPbXszwOEP0MKkG6XdCuFD5SL5fsXjJ5nC8v0KeTAWrFOyPljTl7O4FvN3dvTzQr
        2WHaGI4YMQtjgACefweQ80eu7hBbXYddO5j6QaN5CrTj+mNqg4TZGvEDq6XazxBhjRnOTA
        E5UtMy8Derw4Bukd8PYMiCjiEaWNBQk=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-310-z1whuhsGPceq69SG_Ui60w-1; Thu, 27 Jan 2022 02:49:26 -0500
X-MC-Unique: z1whuhsGPceq69SG_Ui60w-1
Received: by mail-ej1-f71.google.com with SMTP id rl11-20020a170907216b00b006b73a611c1aso913760ejb.22
        for <kvm@vger.kernel.org>; Wed, 26 Jan 2022 23:49:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=2M1Y5J7ea57QbWGURJTWHJUwASXNiDDATsh/06s16sw=;
        b=EeXEGMT6UC6b9cGnJe24yG+/GQEXGLUXHlIyDfeYuf61YV6d98wGq4sOliBDavrT3v
         zKBYNE5F//Q7PmCJwQoLT4Wt2nDI2oJ/f0RqtsKY15NGsJxz+1GjbE64GZSb94Sl5MQM
         1jGI6qMWuIdgj7tKUiEwI3KNxNzEnOhET4LQDFJvb8tYsTX47prNyG/zd6u/+gIJ/XMP
         EUUow6rCB9XQ4XrRSfp8WPDHI9A6WF3Sls90ZEsvIacnDmd6jReKAdpm/Fsc2E3aOHKw
         Z5XMPjGF627jmWQhybzPqJUV+V+ZtDIScAEDT+W/295NkXnpIVMW2yEhr+N5OhzevaJq
         5eYw==
X-Gm-Message-State: AOAM532W1Zby1jHPUXgWPFgDA2DbaEpLSeKVYapKxTav0HJweLSFpotY
        FBKWKu7Y76QhT0xh6rWJdeflDkv896YiUnk3sBD6nBmMVxfsw19QOKkh/rtwDDo+lO2vPlP7oRe
        lExqIz8+gmRjY
X-Received: by 2002:a17:906:ae8a:: with SMTP id md10mr2063863ejb.726.1643269765280;
        Wed, 26 Jan 2022 23:49:25 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxGpL/2ZnX3mqkVZZyZhokQnWV5oIL1rIszy/xyBe7GJ6tdoLJQ4LSjT//1ZdrpZ5AQtUJTRA==
X-Received: by 2002:a17:906:ae8a:: with SMTP id md10mr2063849ejb.726.1643269765087;
        Wed, 26 Jan 2022 23:49:25 -0800 (PST)
Received: from gator (cst2-173-70.cust.vodafone.cz. [31.30.173.70])
        by smtp.gmail.com with ESMTPSA id gu2sm8295149ejb.221.2022.01.26.23.49.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Jan 2022 23:49:24 -0800 (PST)
Date:   Thu, 27 Jan 2022 08:49:22 +0100
From:   Andrew Jones <drjones@redhat.com>
To:     Ricardo Koller <ricarkol@google.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, maz@kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>, oupton@google.com,
        reijiw@google.com
Subject: Re: [PATCH v2 4/5] kvm: selftests: aarch64: fix some vgic related
 comments
Message-ID: <20220127074922.6m53vckomn7lacog@gator>
References: <20220127030858.3269036-1-ricarkol@google.com>
 <20220127030858.3269036-5-ricarkol@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220127030858.3269036-5-ricarkol@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jan 26, 2022 at 07:08:57PM -0800, Ricardo Koller wrote:
> Fix the formatting of some comments and the wording of one of them (in
> gicv3_access_reg).
> 
> Signed-off-by: Ricardo Koller <ricarkol@google.com>
> Reported-by: Reiji Watanabe <reijiw@google.com>
> Cc: Andrew Jones <drjones@redhat.com>
> Reviewed-by: Andrew Jones <drjones@redhat.com>

I didn't give my r-b to this patch before, but you can keep it, because
here's another one

Reviewed-by: Andrew Jones <drjones@redhat.com>

> ---
>  tools/testing/selftests/kvm/aarch64/vgic_irq.c   | 12 ++++++++----
>  tools/testing/selftests/kvm/lib/aarch64/gic_v3.c | 10 ++++++----
>  tools/testing/selftests/kvm/lib/aarch64/vgic.c   |  3 ++-
>  3 files changed, 16 insertions(+), 9 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/aarch64/vgic_irq.c b/tools/testing/selftests/kvm/aarch64/vgic_irq.c
> index 0106fc464afe..f0230711fbe9 100644
> --- a/tools/testing/selftests/kvm/aarch64/vgic_irq.c
> +++ b/tools/testing/selftests/kvm/aarch64/vgic_irq.c
> @@ -306,7 +306,8 @@ static void guest_restore_active(struct test_args *args,
>  	uint32_t prio, intid, ap1r;
>  	int i;
>  
> -	/* Set the priorities of the first (KVM_NUM_PRIOS - 1) IRQs
> +	/*
> +	 * Set the priorities of the first (KVM_NUM_PRIOS - 1) IRQs
>  	 * in descending order, so intid+1 can preempt intid.
>  	 */
>  	for (i = 0, prio = (num - 1) * 8; i < num; i++, prio -= 8) {
> @@ -315,7 +316,8 @@ static void guest_restore_active(struct test_args *args,
>  		gic_set_priority(intid, prio);
>  	}
>  
> -	/* In a real migration, KVM would restore all GIC state before running
> +	/*
> +	 * In a real migration, KVM would restore all GIC state before running
>  	 * guest code.
>  	 */
>  	for (i = 0; i < num; i++) {
> @@ -503,7 +505,8 @@ static void guest_code(struct test_args *args)
>  		test_injection_failure(args, f);
>  	}
>  
> -	/* Restore the active state of IRQs. This would happen when live
> +	/*
> +	 * Restore the active state of IRQs. This would happen when live
>  	 * migrating IRQs in the middle of being handled.
>  	 */
>  	for_each_supported_activate_fn(args, set_active_fns, f)
> @@ -840,7 +843,8 @@ int main(int argc, char **argv)
>  		}
>  	}
>  
> -	/* If the user just specified nr_irqs and/or gic_version, then run all
> +	/*
> +	 * If the user just specified nr_irqs and/or gic_version, then run all
>  	 * combinations.
>  	 */
>  	if (default_args) {
> diff --git a/tools/testing/selftests/kvm/lib/aarch64/gic_v3.c b/tools/testing/selftests/kvm/lib/aarch64/gic_v3.c
> index e4945fe66620..263bf3ed8fd5 100644
> --- a/tools/testing/selftests/kvm/lib/aarch64/gic_v3.c
> +++ b/tools/testing/selftests/kvm/lib/aarch64/gic_v3.c
> @@ -19,7 +19,7 @@ struct gicv3_data {
>  	unsigned int nr_spis;
>  };
>  
> -#define sgi_base_from_redist(redist_base) 	(redist_base + SZ_64K)
> +#define sgi_base_from_redist(redist_base)	(redist_base + SZ_64K)
>  #define DIST_BIT				(1U << 31)
>  
>  enum gicv3_intid_range {
> @@ -105,7 +105,8 @@ static void gicv3_set_eoi_split(bool split)
>  {
>  	uint32_t val;
>  
> -	/* All other fields are read-only, so no need to read CTLR first. In
> +	/*
> +	 * All other fields are read-only, so no need to read CTLR first. In
>  	 * fact, the kernel does the same.
>  	 */
>  	val = split ? (1U << 1) : 0;
> @@ -160,8 +161,9 @@ static void gicv3_access_reg(uint32_t intid, uint64_t offset,
>  
>  	GUEST_ASSERT(bits_per_field <= reg_bits);
>  	GUEST_ASSERT(!write || *val < (1U << bits_per_field));
> -	/* Some registers like IROUTER are 64 bit long. Those are currently not
> -	 * supported by readl nor writel, so just asserting here until then.
> +	/*
> +	 * This function does not support 64 bit accesses. Just asserting here
> +	 * until we implement readq/writeq.
>  	 */
>  	GUEST_ASSERT(reg_bits == 32);
>  
> diff --git a/tools/testing/selftests/kvm/lib/aarch64/vgic.c b/tools/testing/selftests/kvm/lib/aarch64/vgic.c
> index b3a0fca0d780..79864b941617 100644
> --- a/tools/testing/selftests/kvm/lib/aarch64/vgic.c
> +++ b/tools/testing/selftests/kvm/lib/aarch64/vgic.c
> @@ -150,7 +150,8 @@ static void vgic_poke_irq(int gic_fd, uint32_t intid,
>  		attr += SZ_64K;
>  	}
>  
> -	/* All calls will succeed, even with invalid intid's, as long as the
> +	/*
> +	 * All calls will succeed, even with invalid intid's, as long as the
>  	 * addr part of the attr is within 32 bits (checked above). An invalid
>  	 * intid will just make the read/writes point to above the intended
>  	 * register space (i.e., ICPENDR after ISPENDR).
> -- 
> 2.35.0.rc0.227.g00780c9af4-goog
> 

