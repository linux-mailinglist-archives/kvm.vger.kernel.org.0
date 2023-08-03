Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E67176DCD5
	for <lists+kvm@lfdr.de>; Thu,  3 Aug 2023 02:44:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232493AbjHCAoY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Aug 2023 20:44:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232496AbjHCAoV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Aug 2023 20:44:21 -0400
Received: from mailtransmit04.runbox.com (mailtransmit04.runbox.com [IPv6:2a0c:5a00:149::25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D2602D4E
        for <kvm@vger.kernel.org>; Wed,  2 Aug 2023 17:44:18 -0700 (PDT)
Received: from mailtransmit02.runbox ([10.9.9.162] helo=aibo.runbox.com)
        by mailtransmit04.runbox.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <mhal@rbox.co>)
        id 1qRMRs-003G6h-Dv
        for kvm@vger.kernel.org; Thu, 03 Aug 2023 02:44:16 +0200
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=rbox.co;
        s=selector1; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
        References:Cc:To:Subject:MIME-Version:Date:Message-ID;
        bh=O1rkrqD2YzSaRaicnmqZ9+JZlv2ejsLptxTU+epbhQ0=; b=UkVqU6CfTICvoDqJSm7vbdd2YG
        bG5Vykq4SmgzwVxQA9sVR8TzMteMj1Kjmm03TvKclcCyE85KugmUgsBPs5ER7xcdbdsEVIjhx7Dp9
        kkiW9QTtEhWO0CFl+a8C/iff/tlS8D1TqSQ9RyVVxXT39mAsnxEtadS6Le+kRBUCk4ChCifeUhA+C
        RSSqlU23AMb38bJBjQuVU6gR19cY6S4st1fKl+QoxmjfpHBBG0JszrEPmdJdswpWia0qjX4WppIkf
        mc45P+g1ARyAhausscZrs3S982UnpwkAIyLwDuR0lRyrAepRNaEEYZ/X6WdA938/M5Z99J9+oeXLg
        xTfovzRw==;
Received: from [10.9.9.74] (helo=submission03.runbox)
        by mailtransmit02.runbox with esmtp (Exim 4.86_2)
        (envelope-from <mhal@rbox.co>)
        id 1qRMRs-0001aM-2H; Thu, 03 Aug 2023 02:44:16 +0200
Received: by submission03.runbox with esmtpsa  [Authenticated ID (604044)]  (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.90_1)
        id 1qRMRe-0001W0-Tr; Thu, 03 Aug 2023 02:44:03 +0200
Message-ID: <222888b6-0046-3351-ba2f-fe6ac863f73d@rbox.co>
Date:   Thu, 3 Aug 2023 02:44:01 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] KVM: selftests: Extend x86's sync_regs_test to check
 for races
Content-Language: pl-PL, en-GB
To:     Sean Christopherson <seanjc@google.com>
Cc:     pbonzini@redhat.com, kvm@vger.kernel.org, shuah@kernel.org
References: <20230728001606.2275586-1-mhal@rbox.co>
 <20230728001606.2275586-3-mhal@rbox.co> <ZMrFmKRcsb84DaTY@google.com>
From:   Michal Luczaj <mhal@rbox.co>
In-Reply-To: <ZMrFmKRcsb84DaTY@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/2/23 23:07, Sean Christopherson wrote:
> On Fri, Jul 28, 2023, Michal Luczaj wrote:
>> +#define TIMEOUT	2	/* seconds, roughly */
> 
> I think it makes sense to make this a const in race_sync_regs(), that way its
> usage is a bit more obvious.

Yeah, sure.

>> +/*
>> + * WARNING: CPU: 0 PID: 1115 at arch/x86/kvm/x86.c:10095 kvm_check_and_inject_events+0x220/0x500 [kvm]
>> + *
>> + * arch/x86/kvm/x86.c:kvm_check_and_inject_events():
>> + * WARN_ON_ONCE(vcpu->arch.exception.injected &&
>> + *		vcpu->arch.exception.pending);
>> + */
> 
> For comments in selftests, describe what's happening without referencing KVM code,
> things like this in particular will become stale sooner than later.  It's a-ok
> (and encouraged) to put the WARNs and function references in changelogs though,
> as those are explicitly tied to a specific time in history.

Right, I'll try to remember. Actually, those comments were notes for myself and
then I've just left them thinking they can't hurt. But I agree that wasn't the
best idea.

>> +static void race_sync_regs(void *racer, bool poke_mmu)
>> +{
>> +	struct kvm_translation tr;
>> +	struct kvm_vcpu *vcpu;
>> +	struct kvm_run *run;
>> +	struct kvm_vm *vm;
>> +	pthread_t thread;
>> +	time_t t;
>> +
>> +	vm = vm_create_with_one_vcpu(&vcpu, guest_code);
>> +	run = vcpu->run;
>> +
>> +	run->kvm_valid_regs = KVM_SYNC_X86_SREGS;
>> +	vcpu_run(vcpu);
>> +	TEST_REQUIRE(run->s.regs.sregs.cr4 & X86_CR4_PAE);
> 
> This can be an assert, and should also check EFER.LME.  Jump-starting in long mode
> is a property of selftests, i.e. not something that should ever randomly "fail".

Right, sorry for the misuse.

>> +	run->kvm_valid_regs = 0;
>> +
>> +	ASSERT_EQ(pthread_create(&thread, NULL, racer, (void *)run), 0);
>> +
>> +	for (t = time(NULL) + TIMEOUT; time(NULL) < t;) {
>> +		__vcpu_run(vcpu);
>> +
>> +		if (poke_mmu) {
> 
> Rather than pass a boolean, I think it makes sense to do
> 
> 		if (racer == race_sregs_cr4)
> 
> It's arguably just trading ugliness for subtlety, but IMO it's worth avoiding
> the boolean.

Ah, ok.

>> +	/*
>> +	 * If kvm->bugged then we won't survive TEST_ASSERT(). Leak.
>> +	 *
>> +	 * kvm_vm_free()
>> +	 *   __vm_mem_region_delete()
>> +	 *     vm_ioctl(vm, KVM_SET_USER_MEMORY_REGION, &region->region)
>> +	 *       _vm_ioctl(vm, cmd, #cmd, arg)
>> +	 *         TEST_ASSERT(!ret, __KVM_IOCTL_ERROR(name, ret))
>> +	 */
> 
> We want the assert, it makes failures explicit.  The signature is a bit unfortunate,
> but the WARN in the kernel log should provide a big clue.

Sure, I get it. And not that there is a way to check if VM is bugged/dead?

> I'll fix up all of the above when applying, and will also split this into three
> patches, mostly so that each splat can be covered in a changelog, i.e. is tied
> to its testcase.

Great, thank you for all the comments and fixes!

Michal

