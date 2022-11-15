Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA2286293A1
	for <lists+kvm@lfdr.de>; Tue, 15 Nov 2022 09:54:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232603AbiKOIyF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Nov 2022 03:54:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232186AbiKOIyB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Nov 2022 03:54:01 -0500
Received: from out2.migadu.com (out2.migadu.com [188.165.223.204])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 278B91C90E
        for <kvm@vger.kernel.org>; Tue, 15 Nov 2022 00:53:59 -0800 (PST)
Subject: Re: kvm-unit-tests: inconsistent test result between run_tests.sh and
 standalone test
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1668502437;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0jmZfEfqknZQ5G9wn/l95roavF/JjB3CDIJNHYRA2UA=;
        b=PpHbweKMptLevnjItT7632l6mbdxHUIZpva+DieTHjfpHJuPHnX3FmNoQs5NmeIO9s1CQr
        +ei2IEzyGP2/ER0pAXrGM55pj3yVxTitdnh4Cx+/e6O3vOkibwf27U42SAe471LMsXKefw
        ecIkgb1j/b+wc/402PA+LU0HTc/4uH0=
To:     Andrew Jones <andrew.jones@linux.dev>
Cc:     kvm@vger.kernel.org
References: <9bf9defb-1482-8f8a-7e8e-d07ab2f51852@linux.dev>
 <20221115084246.qrussaswk2pvjkze@kamzik>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Guoqing Jiang <guoqing.jiang@linux.dev>
Message-ID: <ea13a5c3-2f84-8677-d098-e59075b7b03f@linux.dev>
Date:   Tue, 15 Nov 2022 16:53:55 +0800
MIME-Version: 1.0
In-Reply-To: <20221115084246.qrussaswk2pvjkze@kamzik>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

Thanks for the quick reply!

On 11/15/22 4:42 PM, Andrew Jones wrote:
> On Tue, Nov 15, 2022 at 04:11:48PM +0800, Guoqing Jiang wrote:
>> Hi,
>>
>> I find the two test results (pmu and intel_cet) are quite different, but
>> other
>> test results are consistent.
>>
>> gjiang@x1:~/source/kvm-unit-tests> ./run_tests.sh
>> ...
>> *PASS pmu (142 tests)*
>> ...
>> *FAIL intel_cet*
>> ...
>>
>> 1. pmu standalone test
>> gjiang@x1:~/source/kvm-unit-tests/tests> ./pmu
>> BUILD_HEAD=73d9d850
>> timeout -k 1s --foreground 90s /usr/bin/qemu-system-x86_64 --no-reboot
>> -nodefaults -device pc-testdev -device isa-debug-exit,iobase=0xf4,iosize=0x4
>> -vnc none -serial stdio -device pci-testdev -machine accel=kvm -kernel
>> /tmp/tmp.Bai8UEIh2F -smp 1 -cpu max # -initrd /tmp/tmp.DFE9VFPOdp
>> enabling apic
>> smp: waiting for 0 APs
>> paging enabled
>> cr0 = 80010011
>> cr3 = 1007000
>> cr4 = 20
>> PMU version:         2
>> GP counters:         4
>> GP counter width:    48
>> Mask length:         7
>> Fixed counters:      3
>> Fixed counter width: 48
>> PASS: core cycles-0
>> ...
>> FAIL: llc misses-0
>> FAIL: llc misses-1
>> FAIL: llc misses-2
>> FAIL: llc misses-3
>> ...
>> SUMMARY: 142 tests, 4 unexpected failures
>> *FAIL pmu (142 tests, 4 unexpected failures)
>>
>> *And
>>
>> gjiang@x1:~/source/kvm-unit-tests> ./x86-run ./x86/pmu.flat
>> /usr/bin/qemu-system-x86_64 --no-reboot -nodefaults -device pc-testdev
>> -device isa-debug-exit,iobase=0xf4,iosize=0x4 -vnc none -serial stdio
>> -device pci-testdev -machine accel=kvm -kernel ./x86/pmu.flat # -initrd
>> /tmp/tmp.jiEHps3KLW
>> enabling apic
>> smp: waiting for 0 APs
>> paging enabled
>> cr0 = 80010011
>> cr3 = 1007000
>> cr4 = 20
>> *SKIP: No pmu is detected!**
>> **SUMMARY: 1 tests, 1 skipped*
>>
> ./x86-run doesn't look at x86/unittests.cfg, which is where the pmu test
> states that it needs '-cpu max'. You either need to add it yourself, e.g.
> './x86-run ./x86/pmu.flat -cpu max' or use run_tests.sh, e.g.
> './run_tests.sh pmu'. standalone tests get their parameters from
> x86/unittests.cfg, which is why it's already using '-cpu max'.

Thanks for the tips. And I still see two different results, one is PASS
while another has failures.

gjiang@x1:~/source/kvm-unit-tests> ./run_tests.sh pmu
PASS pmu (142 tests)

gjiang@x1:~/source/kvm-unit-tests> ./x86-run ./x86/pmu.flat -cpu max
/usr/bin/qemu-system-x86_64 --no-reboot -nodefaults -device pc-testdev 
-device isa-debug-exit,iobase=0xf4,iosize=0x4 -vnc none -serial stdio 
-device pci-testdev -machine accel=kvm -kernel ./x86/pmu.flat -cpu max # 
-initrd /tmp/tmp.wBVHPW1XUr
enabling apic
smp: waiting for 0 APs
paging enabled
cr0 = 80010011
cr3 = 1007000
cr4 = 20
PMU version:         2
GP counters:         4
GP counter width:    48
Mask length:         7
Fixed counters:      3
Fixed counter width: 48
...
FAIL: llc misses-0
FAIL: llc misses-1
FAIL: llc misses-2
FAIL: llc misses-3
...
SUMMARY: 142 tests, 4 unexpected failures

> **
> 2. intel_cet
> gjiang@x1:~/source/kvm-unit-tests/tests> ./intel_cet
> BUILD_HEAD=73d9d850
> *skip intel_cet (test kernel not present)*
> This error looks like x86/cet.c wasn't built. Maybe do a 'make clean' and
> 'make standalone' again and watch that cet.c doesn't fail to compile.

Indeed, seems cet.c is not compiled since only cet.c exists even after run
'make clean' and 'make standalone', but tests/intel_cet is generated.

gjiang@x1:~/source/kvm-unit-tests> ls x86/cet.*
x86/cet.c

Thanks,
Guoqing
