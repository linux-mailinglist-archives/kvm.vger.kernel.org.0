Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 093537B0EBA
	for <lists+kvm@lfdr.de>; Thu, 28 Sep 2023 00:02:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229672AbjI0WB7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Sep 2023 18:01:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbjI0WB7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 Sep 2023 18:01:59 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B107C136
        for <kvm@vger.kernel.org>; Wed, 27 Sep 2023 15:01:56 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-d815354ea7fso17908648276.1
        for <kvm@vger.kernel.org>; Wed, 27 Sep 2023 15:01:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1695852116; x=1696456916; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=6Tjhh5Z60sBXZkZCQa4W5opzjeZcwWV5KKmWVUroTRY=;
        b=3lxbvlq5yy5xoM8h/F6x/xEysK6niJ4xs//1f/77SyQA1p7eSBtx5G1/2qbHQE7Dme
         Ry/KBqQdnxlM+QMoFASaBCHaPb+Obw6BYl+rbPcC5eXoJzIgw7YCMGgqWD7kYeCuIICe
         TQgN2OeFpBTPRO7tRMUFRRmOPiTTIhoDoAyOK4eHElk+CzYHvI4SeZKM9BonqxhS1Jb6
         X6VsLse49UcWhUfqxgoDj3aaArMB3ANzCDal2lXBmY5VKgzOff9GxtHUlXC+XosE1qA3
         09pljx/N7hH+mSo+yzwtdDTEJ7e5DulrTDBy7O32w0RDBe09kfOLbCz5OBcV8sK+egQs
         +TJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695852116; x=1696456916;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6Tjhh5Z60sBXZkZCQa4W5opzjeZcwWV5KKmWVUroTRY=;
        b=ZaVAQZ1IYtl6E2QTig6+9sykcRcW4oVChVk1EQlms7xjbR0GVwmflf72Wez3IlcAjS
         SdJ/QOBzWFyqXUPvwC9nOuDBVe1dkutaWydzQsTp2xLIX9jJLTciBFFTLOAIXinzU9Jt
         DuzjiLZK3w/Dbg5kd9NTg3EPp9yXpuOjyhGb///kpHQZokPGuNbt9i4pyXtrD67Nh80d
         ZHUtolhMqzFjJijkU7ntFtgGIuESeZ3dTQBzGRq8C/2KL45uudz7Ma32IvghpDqBtERj
         5DyNtlsAdQ0cj5tEtKcE99iPUGYykVQ9EJmHL7Eb8KskcdRy13X/96Nvbr2ojOnCog4/
         8BQQ==
X-Gm-Message-State: AOJu0YwQI2hLnxMmRox+ot8F7ZnbDeWwYIti3VhR5Sw8U7TRhxLC8zz1
        np5IvlHAOXPzyRpAaB3GBtCm63u2LzQ=
X-Google-Smtp-Source: AGHT+IGAXp0/kXHF79ZNkKu7ySNzCT/ClnUoV1NMtkK+Uu+ADh+tss5Z+HUTwRF4ch9OjD6YLoXwLYU0QX8=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:1613:b0:d80:ff9:d19e with SMTP id
 bw19-20020a056902161300b00d800ff9d19emr50415ybb.9.1695852115824; Wed, 27 Sep
 2023 15:01:55 -0700 (PDT)
Date:   Wed, 27 Sep 2023 15:01:54 -0700
In-Reply-To: <SYYP282MB108686A73C0F896D90D246569DE5A@SYYP282MB1086.AUSP282.PROD.OUTLOOK.COM>
Mime-Version: 1.0
References: <SYYP282MB108686A73C0F896D90D246569DE5A@SYYP282MB1086.AUSP282.PROD.OUTLOOK.COM>
Message-ID: <ZRSmUnenmHPX9HOW@google.com>
Subject: Re: [PATCH] Add kvm_arch helper functions for guests' callchains
From:   Sean Christopherson <seanjc@google.com>
To:     Tianyi Liu <i.pear@outlook.com>
Cc:     pbonzini@redhat.com, kvm@vger.kernel.org
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

Apologies for the belated feedback, I remember seeing this fly by and could have
sworn I responded, but obviously did not.

On Thu, Aug 31, 2023, Tianyi Liu wrote:
> Hi Sean and Paolo,
> 
> This patch serves as the foundation for enabling callchains for guests,
> (used by `perf kvm`). This functionality is useful for me, and I
> noticed it holds the top spot on the perf wiki TODO list [1], so I'd like
> to implement it. This patch introduces several arch-related kvm helper
> functions, which will be later used for guest stack frame profiling.
> This also contains the implementation for x86 platform, while arm64 will
> be implemented later.
> 
> This is part of a series of patches. Since these patches are spread across
> various modules like perf, kvm, arch/*, I plan to first submit some
> foundational patches and gradually submit the complete implementation.
> The full implementation can be found at [2], and it has been tested on
> an x86_64 machine.

Please post the whole thing, or at least enough to actually show the end-to-end
usage.  I suspect the main reason you heard crickets for almost two months is
that's there's nothing actionable to do with this.  This certainly can't be
applied as-is since there is no usage, and it's almost impossible to review
something when only a small sliver is visibible.

> Sean, I noticed you've previously done some refactoring on this code [3],
> do you think there are any issues with the way it was done?

I'd have to look at the whole thing, and to be honest I don't want to pull down
from github to do that.

> diff --git a/arch/x86/kvm/kvm_cache_regs.h b/arch/x86/kvm/kvm_cache_regs.h
> index 75eae9c4998a..c73acecc7ef9 100644
> --- a/arch/x86/kvm/kvm_cache_regs.h
> +++ b/arch/x86/kvm/kvm_cache_regs.h
> @@ -133,6 +133,11 @@ static inline void kvm_rsp_write(struct kvm_vcpu *vcpu, unsigned long val)
>  	kvm_register_write_raw(vcpu, VCPU_REGS_RSP, val);
>  }
>  
> +static inline unsigned long kvm_fp_read(struct kvm_vcpu *vcpu)
> +{
> +	return kvm_register_read_raw(vcpu, VCPU_REGS_RBP);
> +}
> +
>  static inline u64 kvm_pdptr_read(struct kvm_vcpu *vcpu, int index)
>  {
>  	might_sleep();  /* on svm */
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index c381770bcbf1..2fd3850b1673 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -12902,6 +12902,24 @@ unsigned long kvm_arch_vcpu_get_ip(struct kvm_vcpu *vcpu)
>  	return kvm_rip_read(vcpu);
>  }
>  
> +unsigned long kvm_arch_vcpu_get_fp(struct kvm_vcpu *vcpu)

Take this with a grain of salt this I can't see the big picture, but I recommend
spelling out frame_pointer.  At first glance I read this as "kvm_arch_vcpu_get_fpu()"
and was all kinds of confused.

This and kvm_arch_vcpu_is_64bit() can also be inlined functions.

> +{
> +	return kvm_fp_read(vcpu);

No need for a dedicated kvm_fp_read(), just open code the read of RBP here.

> +}
> +
> +bool kvm_arch_vcpu_read_virt(struct kvm_vcpu *vcpu, void *addr, void *dest, unsigned int length)

This should needn't an arch hook, though again I can't see the big picture.

> +{
> +	struct x86_exception e;
> +
> +	/* Return true on success */
> +	return kvm_read_guest_virt(vcpu, addr, dest, length, &e) == X86EMUL_CONTINUE;
> +}
> +
> +bool kvm_arch_vcpu_is_64bit(struct kvm_vcpu *vcpu)
> +{
> +	return is_64_bit_mode(vcpu);
> +}
> +
>  int kvm_arch_vcpu_should_kick(struct kvm_vcpu *vcpu)
>  {
>  	return kvm_vcpu_exiting_guest_mode(vcpu) == IN_GUEST_MODE;
