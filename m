Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 320F176D92E
	for <lists+kvm@lfdr.de>; Wed,  2 Aug 2023 23:07:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231452AbjHBVHl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Aug 2023 17:07:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229528AbjHBVHj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Aug 2023 17:07:39 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2A7C26B6
        for <kvm@vger.kernel.org>; Wed,  2 Aug 2023 14:07:38 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id d9443c01a7336-1bba5626342so2577445ad.2
        for <kvm@vger.kernel.org>; Wed, 02 Aug 2023 14:07:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1691010458; x=1691615258;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=rpEdXC5TOUTdj2CmYdlHtLcpKwS3TikTG092WQYJPfo=;
        b=wQxvCqlq5qq1C/WnDnCtU/Ka49WOCncwgxjNbzc5Mj5DIqQcEXPOrmzXIFGhayWslq
         DFdKb5Arm4B7qat6+I1Z5d/ZA5shgaDbBHo1tzLuVEKwJWUlFsU6YwkxHxAlCJGOmCBi
         36sN3ZeAr926MNng32r539FQCrvOmdKjUs6cVx4j8+48hrnk0XG4At1HeRKOLA3QNuU6
         L9yzlJKscg65fbpzy8vLJ8dLa73+xIyZya3t/FLb4P5cboPHRO1pNviUa2GLXRpCGzYE
         b1+e6sTAgJASd23xuLO8dGbHvV5g89gd7yticybNJvh3GxELV5a2kxKs25nRX7lTtAYO
         DsMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691010458; x=1691615258;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rpEdXC5TOUTdj2CmYdlHtLcpKwS3TikTG092WQYJPfo=;
        b=R+44jLPn9HUINmcHPc/WfIx7283UpGw+I+IJo85KTpYy3DnmB9ZFekYC0povuVHBmf
         0kWuH5nw/NfX4S2V5QmYM2MVaetSr/AyZKTUw9iKt/59daTMyCpDtaO5nEb28hpMXGZn
         /INNiBdO9SKEUlBKet254RXkQl+kfxNCVWrE1Z9/sJSl5sWGHYRm5rrsbjm5seA4kRk3
         zLL7iv2xoOmqdfT0acuSlAFR0bJCeSB60VmEU04gXT2q+byXuUvED0G4e0iJrwzEGK0R
         culOJPa4eOvTHEdCZlFFtS+bNQNAR219XejcK7NmA4RMhviKh2j6N4ZDuPDnR/DoprXD
         e2DA==
X-Gm-Message-State: ABy/qLYdozjSBnKfvM1u/FFCaC/gd69Z8BRPofUO1uoXB9O797XnqWNM
        ncwxfF668916zWx89LSBZPK4Sc1QlXg=
X-Google-Smtp-Source: APBJJlEa0LOcxSK0tv9tJImx2SQW3MxfL8fxwSoFnphEcyBWFcGY0zIdIPOjtXAsAFg9fCy28PPmDqCFj0Q=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:903:244c:b0:1bb:2081:7aa2 with SMTP id
 l12-20020a170903244c00b001bb20817aa2mr93411pls.9.1691010458021; Wed, 02 Aug
 2023 14:07:38 -0700 (PDT)
Date:   Wed, 2 Aug 2023 14:07:36 -0700
In-Reply-To: <20230728001606.2275586-3-mhal@rbox.co>
Mime-Version: 1.0
References: <20230728001606.2275586-1-mhal@rbox.co> <20230728001606.2275586-3-mhal@rbox.co>
Message-ID: <ZMrFmKRcsb84DaTY@google.com>
Subject: Re: [PATCH 2/2] KVM: selftests: Extend x86's sync_regs_test to check
 for races
From:   Sean Christopherson <seanjc@google.com>
To:     Michal Luczaj <mhal@rbox.co>
Cc:     pbonzini@redhat.com, kvm@vger.kernel.org, shuah@kernel.org
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jul 28, 2023, Michal Luczaj wrote:
> Attempt to modify vcpu->run->s.regs _after_ the sanity checks performed by
> KVM_CAP_SYNC_REGS's arch/x86/kvm/x86.c:sync_regs(). This could lead to some
> nonsensical vCPU states accompanied by kernel splats.
> 
> Signed-off-by: Michal Luczaj <mhal@rbox.co>
> ---
>  .../selftests/kvm/x86_64/sync_regs_test.c     | 124 ++++++++++++++++++
>  1 file changed, 124 insertions(+)
> 
> diff --git a/tools/testing/selftests/kvm/x86_64/sync_regs_test.c b/tools/testing/selftests/kvm/x86_64/sync_regs_test.c
> index 2da89fdc2471..feebc7d44c17 100644
> --- a/tools/testing/selftests/kvm/x86_64/sync_regs_test.c
> +++ b/tools/testing/selftests/kvm/x86_64/sync_regs_test.c
> @@ -15,12 +15,14 @@
>  #include <stdlib.h>
>  #include <string.h>
>  #include <sys/ioctl.h>
> +#include <pthread.h>
>  
>  #include "test_util.h"
>  #include "kvm_util.h"
>  #include "processor.h"
>  
>  #define UCALL_PIO_PORT ((uint16_t)0x1000)
> +#define TIMEOUT	2	/* seconds, roughly */

I think it makes sense to make this a const in race_sync_regs(), that way its
usage is a bit more obvious.

>  struct ucall uc_none = {
>  	.cmd = UCALL_NONE,
> @@ -80,6 +82,124 @@ static void compare_vcpu_events(struct kvm_vcpu_events *left,
>  #define TEST_SYNC_FIELDS   (KVM_SYNC_X86_REGS|KVM_SYNC_X86_SREGS|KVM_SYNC_X86_EVENTS)
>  #define INVALID_SYNC_FIELD 0x80000000
>  
> +/*
> + * WARNING: CPU: 0 PID: 1115 at arch/x86/kvm/x86.c:10095 kvm_check_and_inject_events+0x220/0x500 [kvm]
> + *
> + * arch/x86/kvm/x86.c:kvm_check_and_inject_events():
> + * WARN_ON_ONCE(vcpu->arch.exception.injected &&
> + *		vcpu->arch.exception.pending);
> + */

For comments in selftests, describe what's happening without referencing KVM code,
things like this in particular will become stale sooner than later.  It's a-ok
(and encouraged) to put the WARNs and function references in changelogs though,
as those are explicitly tied to a specific time in history.

> +static void race_sync_regs(void *racer, bool poke_mmu)
> +{
> +	struct kvm_translation tr;
> +	struct kvm_vcpu *vcpu;
> +	struct kvm_run *run;
> +	struct kvm_vm *vm;
> +	pthread_t thread;
> +	time_t t;
> +
> +	vm = vm_create_with_one_vcpu(&vcpu, guest_code);
> +	run = vcpu->run;
> +
> +	run->kvm_valid_regs = KVM_SYNC_X86_SREGS;
> +	vcpu_run(vcpu);
> +	TEST_REQUIRE(run->s.regs.sregs.cr4 & X86_CR4_PAE);

This can be an assert, and should also check EFER.LME.  Jump-starting in long mode
is a property of selftests, i.e. not something that should ever randomly "fail".

> +	run->kvm_valid_regs = 0;
> +
> +	ASSERT_EQ(pthread_create(&thread, NULL, racer, (void *)run), 0);
> +
> +	for (t = time(NULL) + TIMEOUT; time(NULL) < t;) {
> +		__vcpu_run(vcpu);
> +
> +		if (poke_mmu) {

Rather than pass a boolean, I think it makes sense to do

		if (racer == race_sregs_cr4)

It's arguably just trading ugliness for subtlety, but IMO it's worth avoiding
the boolean.

> +			tr = (struct kvm_translation) { .linear_address = 0 };
> +			__vcpu_ioctl(vcpu, KVM_TRANSLATE, &tr);
> +		}
> +	}
> +
> +	ASSERT_EQ(pthread_cancel(thread), 0);
> +	ASSERT_EQ(pthread_join(thread, NULL), 0);
> +
> +	/*
> +	 * If kvm->bugged then we won't survive TEST_ASSERT(). Leak.
> +	 *
> +	 * kvm_vm_free()
> +	 *   __vm_mem_region_delete()
> +	 *     vm_ioctl(vm, KVM_SET_USER_MEMORY_REGION, &region->region)
> +	 *       _vm_ioctl(vm, cmd, #cmd, arg)
> +	 *         TEST_ASSERT(!ret, __KVM_IOCTL_ERROR(name, ret))
> +	 */

We want the assert, it makes failures explicit.  The signature is a bit unfortunate,
but the WARN in the kernel log should provide a big clue.

> +	if (!poke_mmu)
> +		kvm_vm_free(vm);
> +}
> +
>  int main(int argc, char *argv[])
>  {
>  	struct kvm_vcpu *vcpu;
> @@ -218,5 +338,9 @@ int main(int argc, char *argv[])
>  
>  	kvm_vm_free(vm);
>  
> +	race_sync_regs(race_sregs_cr4, true);
> +	race_sync_regs(race_events_exc, false);
> +	race_sync_regs(race_events_inj_pen, false);

I'll fix up all of the above when applying, and will also split this into three
patches, mostly so that each splat can be covered in a changelog, i.e. is tied
to its testcase.
