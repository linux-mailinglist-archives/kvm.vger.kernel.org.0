Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2BEDC4BA6C4
	for <lists+kvm@lfdr.de>; Thu, 17 Feb 2022 18:11:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243598AbiBQRLW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Feb 2022 12:11:22 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:51192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237119AbiBQRLV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Feb 2022 12:11:21 -0500
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C4342166A7E
        for <kvm@vger.kernel.org>; Thu, 17 Feb 2022 09:11:06 -0800 (PST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8EB88113E;
        Thu, 17 Feb 2022 09:11:06 -0800 (PST)
Received: from [10.57.39.132] (unknown [10.57.39.132])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B02833F70D;
        Thu, 17 Feb 2022 09:11:05 -0800 (PST)
Message-ID: <9e3389dd-2d29-4eb8-60d6-f67724be1f4a@arm.com>
Date:   Thu, 17 Feb 2022 17:11:03 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.6.1
Subject: Re: [kvm-unit-tests PATCH] configure: arm: Fixes to build and run
 tests on Apple Silicon
Content-Language: en-GB
To:     Andrew Jones <drjones@redhat.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        pbonzini@redhat.com, thuth@redhat.com, jade.alglave@arm.com
References: <20220217102806.28749-1-nikos.nikoleris@arm.com>
 <20220217161022.krzj2g37natxrj6x@gator>
From:   Nikos Nikoleris <nikos.nikoleris@arm.com>
In-Reply-To: <20220217161022.krzj2g37natxrj6x@gator>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 17/02/2022 16:10, Andrew Jones wrote:
> On Thu, Feb 17, 2022 at 10:28:06AM +0000, Nikos Nikoleris wrote:
>> On MacOS:
>>
>> $> uname -m
>>
>> returns:
>>
>> arm64
>>
>> To unify how we handle the achitecture detection across different
>> systems, sed it to aarch64 which is what's typically reported on
> 
> Was "sed" a typo or a new verb for "sedding" stuff :-)

A much needed amendment to English  :)

> 
>> Linux.
>>
>> In addition, when HVF is the acceleration method on aarch64, make sure
>> we select the right processor when invoking qemu.
>>
>> Signed-off-by: Nikos Nikoleris <nikos.nikoleris@arm.com>
>> ---
>>   arm/run   | 3 +++
>>   configure | 2 +-
>>   2 files changed, 4 insertions(+), 1 deletion(-)
>>
>> diff --git a/arm/run b/arm/run
>> index 2153bd3..0629b69 100755
>> --- a/arm/run
>> +++ b/arm/run
>> @@ -27,6 +27,9 @@ if [ "$ACCEL" = "kvm" ]; then
>>   	if $qemu $M,\? 2>&1 | grep gic-version > /dev/null; then
>>   		M+=',gic-version=host'
>>   	fi
>> +fi
>> +
>> +if [ "$ACCEL" = "kvm" ] || [ "$ACCEL" = "hvf" ]; then
>>   	if [ "$HOST" = "aarch64" ] || [ "$HOST" = "arm" ]; then
>>   		processor="host"
>>   		if [ "$ARCH" = "arm" ] && [ "$HOST" = "aarch64" ]; then
>> diff --git a/configure b/configure
>> index 2d9c3e0..ff840c1 100755
>> --- a/configure
>> +++ b/configure
>> @@ -14,7 +14,7 @@ objcopy=objcopy
>>   objdump=objdump
>>   ar=ar
>>   addr2line=addr2line
>> -arch=$(uname -m | sed -e 's/i.86/i386/;s/arm.*/arm/;s/ppc64.*/ppc64/')
>> +arch=$(uname -m | sed -e 's/i.86/i386/;s/arm64/aarch64/;s/arm.*/arm/;s/ppc64.*/ppc64/')
>>   host=$arch
>>   cross_prefix=
>>   endian=""
>> -- 
>> 2.32.0 (Apple Git-132)
>>
> 
> So, with this, we've got kvm-unit-tests running on HVF now?
>  

Just a step to get everything up and running. Not all tests pass, but I 
haven't had the time to understand what's supported with HVF and what's not:

PASS selftest-setup (2 tests)
FAIL selftest-vectors-kernel (timeout; duration=90s)
PASS selftest-vectors-user (2 tests)
PASS selftest-smp (1 tests)
SKIP pci-test (KVM is needed, but not available on this host)
SKIP pmu-cycle-counter (0 tests)
SKIP pmu-event-introspection (0 tests)
SKIP pmu-event-counter-config (0 tests)
SKIP pmu-basic-event-count (0 tests)
SKIP pmu-mem-access (0 tests)
SKIP pmu-sw-incr (0 tests)
SKIP pmu-chained-counters (0 tests)
SKIP pmu-chained-sw-incr (0 tests)
SKIP pmu-chain-promotion (0 tests)
SKIP pmu-overflow-interrupt (0 tests)
PASS gicv2-ipi (3 tests)
PASS gicv2-mmio (17 tests, 1 skipped)
FAIL gicv2-mmio-up (17 tests, 2 unexpected failures)
FAIL gicv2-mmio-3p (17 tests, 3 unexpected failures)
FAIL gicv3-ipi
PASS gicv2-active (1 tests)
FAIL gicv3-active
PASS its-introspection (5 tests)
FAIL its-trigger
SKIP its-migration
SKIP its-pending-migration
SKIP its-migrate-unmapped-collection
PASS psci (4 tests)
FAIL timer (10 tests, 1 unexpected failures)
SKIP micro-bench (test marked as manual run only)
PASS cache (1 tests)
PASS debug-bp (6 tests)
SKIP debug-bp-migration
PASS debug-wp (8 tests)
SKIP debug-wp-migration
PASS debug-sstep (1 tests)
SKIP debug-sstep-migration

> Applied to arm/queue
> 
> https://gitlab.com/rhdrjones/kvm-unit-tests/-/commits/arm/queue
> 

Thanks for the review!

Nikos

> Thanks,
> drew
> 
