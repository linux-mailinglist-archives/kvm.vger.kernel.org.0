Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5ED216E7680
	for <lists+kvm@lfdr.de>; Wed, 19 Apr 2023 11:39:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231660AbjDSJje (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Apr 2023 05:39:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229833AbjDSJjc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Apr 2023 05:39:32 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 60B7A2103
        for <kvm@vger.kernel.org>; Wed, 19 Apr 2023 02:39:30 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id DCCF91042;
        Wed, 19 Apr 2023 02:40:13 -0700 (PDT)
Received: from monolith.localdoman (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 74C633F5A1;
        Wed, 19 Apr 2023 02:39:28 -0700 (PDT)
Date:   Wed, 19 Apr 2023 10:39:25 +0100
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     Eric Auger <eric.auger@redhat.com>
Cc:     Mark Rutland <mark.rutland@arm.com>,
        Andrew Jones <andrew.jones@linux.dev>,
        eric.auger.pro@gmail.com, kvm@vger.kernel.org,
        kvmarm@lists.linux.dev, maz@kernel.org, will@kernel.org,
        oliver.upton@linux.dev, ricarkol@google.com, reijiw@google.com
Subject: Re: [kvm-unit-tests PATCH 0/6] arm: pmu: Fix random failures of
 pmu-chain-promotion
Message-ID: <ZD-2zYGyAhM6q_9Q@monolith.localdoman>
References: <20230315110725.1215523-1-eric.auger@redhat.com>
 <968a026e-066e-deea-d02f-f64133295ff1@redhat.com>
 <xcd3kt23ffdq5qfziuyp2vgwv7ndkmh3acepbpqqhhrokv755e@wuiltddj2hj2>
 <ZDZwIFtH8V59fE4o@FVFF77S0Q05N>
 <6d6126af-4974-0655-e817-5c5c472d5a2f@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6d6126af-4974-0655-e817-5c5c472d5a2f@redhat.com>
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

On Wed, Apr 19, 2023 at 09:32:10AM +0200, Eric Auger wrote:
> Hi,
> 
> On 4/12/23 10:47, Mark Rutland wrote:
> > On Tue, Apr 04, 2023 at 02:47:47PM +0200, Andrew Jones wrote:
> >> On Tue, Apr 04, 2023 at 08:23:15AM +0200, Eric Auger wrote:
> >>> Hi,
> >>>
> >>> On 3/15/23 12:07, Eric Auger wrote:
> >>>> On some HW (ThunderXv2), some random failures of
> >>>> pmu-chain-promotion test can be observed.
> >>>>
> >>>> pmu-chain-promotion is composed of several subtests
> >>>> which run 2 mem_access loops. The initial value of
> >>>> the counter is set so that no overflow is expected on
> >>>> the first loop run and overflow is expected on the second.
> >>>> However it is observed that sometimes we get an overflow
> >>>> on the first run. It looks related to some variability of
> >>>> the mem_acess count. This variability is observed on all
> >>>> HW I have access to, with different span though. On
> >>>> ThunderX2 HW it looks the margin that is currently taken
> >>>> is too small and we regularly hit failure.
> >>>>
> >>>> although the first goal of this series is to increase
> >>>> the count/margin used in those tests, it also attempts
> >>>> to improve the pmu-chain-promotion logs, add some barriers
> >>>> in the mem-access loop, clarify the chain counter
> >>>> enable/disable sequence.
> >>>>
> >>>> A new 'pmu-memaccess-reliability' is also introduced to
> >>>> detect issues with MEM_ACCESS event variability and make
> >>>> the debug easier.
> > As a minor nit, 'pmu-mem-access-reliability' would be more consistent with
> > 'pmu-mem-access'. The lack of a dash in 'memaccess' tripped me up while I was
> > trying to run those two tests.
> 
> I can easily respin with that renaming. thanks for the feedback. Waiting
> a little bit more if somebody has any other comment.

Started reviewing the series last week, something came up and I had to stop
after the first patch (very nice improvement, by the way). I will finish
the review by the end of this week.

Thanks,
Alex

> 
> Eric
> >
> >>>> Obviously one can wonder if this variability is something normal
> >>>> and does not hide any other bug. I hope this series will raise
> >>>> additional discussions about this.
> >>>>
> >>>> https://github.com/eauger/kut/tree/pmu-chain-promotion-fixes-v1
> >>> Gentle ping.
> >> I'd be happy to take this, but I was hoping to see some r-b's and/or t-b's
> >> from some of the others.
> > I gave this a spin on my ThunderX2, and it seems to fix the intermittent
> > failures I was seeing.
> >
> > FWIW:
> >
> > Tested-by: Mark Rutland <mark.rutland@arm.com>
> >
> > Before (on commit 4ba7058c61e8922f9c8397cfa1095fac325f809b):
> >
> > Test results below.
> >
> > | [mark@gravadlaks:~/src/kvm-unit-tests]% TESTNAME=pmu-chain-promotion TIMEOUT=90s ACCEL= useapp qemu ./arm/run arm/pmu.flat -smp 1 -append 'pmu-chain-promotion'
> > | timeout -k 1s --foreground 90s /home/mark/.opt/apps/qemu/bin/qemu-system-aarch64 -nodefaults -machine virt,gic-version=host -accel kvm -cpu host -device virtio-serial-device -device virtconsole,chardev=ctd -chardev testdev,id=ctd -device pci-testdev -display none -serial stdio -kernel arm/pmu.flat -smp 1 -append pmu-chain-promotion # -initrd /tmp/tmp.nl1i6S0EIY
> > | INFO: PMU version: 0x4
> > | INFO: PMU implementer/ID code: 0(" ")/0
> > | INFO: Implements 6 event counters
> > | PASS: pmu: pmu-chain-promotion: 32-bit overflows: chain counter not counting if even counter is disabled
> > | PASS: pmu: pmu-chain-promotion: 32-bit overflows: odd counter did not increment on overflow if disabled
> > | INFO: pmu: pmu-chain-promotion: 32-bit overflows: MEM_ACCESS counter #0 has value 0x7
> > | INFO: pmu: pmu-chain-promotion: 32-bit overflows: CHAIN counter #1 has value 0x0
> > | INFO: pmu: pmu-chain-promotion: 32-bit overflows: overflow counter 0x1
> > | INFO: pmu: pmu-chain-promotion: 32-bit overflows: MEM_ACCESS counter #0 has value 0x4
> > | INFO: pmu: pmu-chain-promotion: 32-bit overflows: MEM_ACCESS counter #0 has value 0x1b
> > | PASS: pmu: pmu-chain-promotion: 32-bit overflows: should have triggered an overflow on #0
> > | FAIL: pmu: pmu-chain-promotion: 32-bit overflows: CHAIN counter #1 shouldn't have incremented
> > | INFO: pmu: pmu-chain-promotion: 32-bit overflows: counter #0 = 0xffffffdc, counter #1 = 0x0 overflow=0x0
> > | INFO: pmu: pmu-chain-promotion: 32-bit overflows: MEM_ACCESS counter #0 has value 0x4
> > | INFO: pmu: pmu-chain-promotion: 32-bit overflows: MEM_ACCESS counter #0 has value 0x1b
> > | FAIL: pmu: pmu-chain-promotion: 32-bit overflows: CHAIN counter enabled: CHAIN counter was incremented and overflow
> > | INFO: pmu: pmu-chain-promotion: 32-bit overflows: CHAIN counter #1 = 0x0, overflow=0x1
> > | INFO: pmu: pmu-chain-promotion: 32-bit overflows: MEM_ACCESS counter #0 has value 0x4
> > | INFO: pmu: pmu-chain-promotion: 32-bit overflows: MEM_ACCESS counter #0 has value 0x1b
> > | FAIL: pmu: pmu-chain-promotion: 32-bit overflows: 32b->64b: CHAIN counter incremented and overflow
> > | INFO: pmu: pmu-chain-promotion: 32-bit overflows: CHAIN counter #1 = 0x0, overflow=0x1
> > | INFO: pmu: pmu-chain-promotion: 32-bit overflows: counter #0=0xfffffff3, counter #1=0x0
> > | PASS: pmu: pmu-chain-promotion: 32-bit overflows: overflow is expected on counter 0
> > | INFO: pmu: pmu-chain-promotion: 32-bit overflows: counter #0=0xa, counter #1=0xf9 overflow=0x1
> > | SUMMARY: 7 tests, 3 unexpected failures
> >
> > After:
> >
> > | [mark@gravadlaks:~/src/kvm-unit-tests]% TESTNAME=pmu-chain-promotion TIMEOUT=90s ACCEL=kvm useapp qemu ./arm/run arm/pmu.flat -smp 1 -append 'pmu-chain-promotion'
> > | timeout -k 1s --foreground 90s /home/mark/.opt/apps/qemu/bin/qemu-system-aarch64 -nodefaults -machine virt,gic-version=host -accel kvm -cpu host -device virtio-serial-device -device virtconsole,chardev=ctd -chardev testdev,id=ctd -device pci-testdev -display none -serial stdio -kernel arm/pmu.flat -smp 1 -append pmu-chain-promotion # -initrd /tmp/tmp.pahLyg1F3s
> > | INFO: PMU version: 0x4
> > | INFO: PMU implementer/ID code: 0(" ")/0
> > | INFO: Implements 6 event counters
> > | INFO: pmu: pmu-chain-promotion: 32-bit overflows: subtest1: post #1=0x0 #0=0x0 overflow=0x0
> > | PASS: pmu: pmu-chain-promotion: 32-bit overflows: subtest1: chain counter not counting if even counter is disabled
> > | INFO: pmu: pmu-chain-promotion: 32-bit overflows: subtest2: post #1=0x0 #0=0xf3 overflow=0x1
> > | PASS: pmu: pmu-chain-promotion: 32-bit overflows: subtest2: odd counter did not increment on overflow if disabled
> > | INFO: pmu: pmu-chain-promotion: 32-bit overflows: subtest3: init #1=0x0 #0=0xfffffea1 overflow=0x0
> > | INFO: pmu: pmu-chain-promotion: 32-bit overflows: subtest3: After 1st loop #1=0x0 #0=0xffffffa0 overflow=0x0
> > | INFO: pmu: pmu-chain-promotion: 32-bit overflows: subtest3: After 2d loop #1=0x0 #0=0xc0 overflow=0x1
> > | PASS: pmu: pmu-chain-promotion: 32-bit overflows: subtest3: should have triggered an overflow on #0
> > | PASS: pmu: pmu-chain-promotion: 32-bit overflows: subtest3: CHAIN counter #1 shouldn't have incremented
> > | INFO: pmu: pmu-chain-promotion: 32-bit overflows: subtest4: init #1=0x0 #0=0xfffffea1 overflow=0x0
> > | INFO: pmu: pmu-chain-promotion: 32-bit overflows: subtest4: After 1st loop #1=0x0 #0=0xffffffb7 overflow=0x0
> > | INFO: pmu: pmu-chain-promotion: 32-bit overflows: subtest4: After 2d loop #1=0x1 #0=0xbc overflow=0x1
> > | PASS: pmu: pmu-chain-promotion: 32-bit overflows: subtest4: CHAIN counter enabled: CHAIN counter was incremented and overflow
> > | INFO: pmu: pmu-chain-promotion: 32-bit overflows: subtest5: init #1=0x0 #0=0xfffffea1 overflow=0x0
> > | INFO: pmu: pmu-chain-promotion: 32-bit overflows: subtest5: After 1st loop #1=0x22c #0=0xffffff9f overflow=0x0
> > | INFO: pmu: pmu-chain-promotion: 32-bit overflows: subtest5: After 2d loop #1=0x1 #0=0x9d overflow=0x1
> > | PASS: pmu: pmu-chain-promotion: 32-bit overflows: subtest5: 32b->64b: CHAIN counter incremented and overflow
> > | INFO: pmu: pmu-chain-promotion: 32-bit overflows: subtest6: init #1=0x0 #0=0xfffffea1 overflow=0x0
> > | INFO: pmu: pmu-chain-promotion: 32-bit overflows: subtest6: After 1st loop #1=0x0 #0=0xffffff9f overflow=0x0
> > | INFO: pmu: pmu-chain-promotion: 32-bit overflows: subtest6: After 2d loop #1=0x1f9 #0=0x9c overflow=0x1
> > | PASS: pmu: pmu-chain-promotion: 32-bit overflows: subtest6: overflow is expected on counter 0
> > | SUMMARY: 7 tests
> >
> > As a bonus, the mem-access and memaccess-reliability results:
> >
> > | [mark@gravadlaks:~/src/kvm-unit-tests]% TESTNAME=pmu-chain-promotion TIMEOUT=90s ACCEL=kvm useapp qemu ./arm/run arm/pmu.flat -smp 1 -append 'pmu-mem-access'     
> > | timeout -k 1s --foreground 90s /home/mark/.opt/apps/qemu/bin/qemu-system-aarch64 -nodefaults -machine virt,gic-version=host -accel kvm -cpu host -device virtio-serial-device -device virtconsole,chardev=ctd -chardev testdev,id=ctd -device pci-testdev -display none -serial stdio -kernel arm/pmu.flat -smp 1 -append pmu-mem-access # -initrd /tmp/tmp.84AeEp8Tiw
> > | INFO: PMU version: 0x4
> > | INFO: PMU implementer/ID code: 0(" ")/0
> > | INFO: Implements 6 event counters
> > | INFO: pmu: pmu-mem-access: 32-bit overflows: counter #0 is 0x15 (MEM_ACCESS)
> > | INFO: pmu: pmu-mem-access: 32-bit overflows: counter #1 is 0x15 (MEM_ACCESS)
> > | PASS: pmu: pmu-mem-access: 32-bit overflows: Ran 20 mem accesses
> > | PASS: pmu: pmu-mem-access: 32-bit overflows: Ran 20 mem accesses with expected overflows on both counters
> > | INFO: pmu: pmu-mem-access: 32-bit overflows: cnt#0=0x8 cnt#1=0x8 overflow=0x3
> > | SKIP: pmu: pmu-mem-access: 64-bit overflows: Skip test as 64 overflows need FEAT_PMUv3p5
> > | SUMMARY: 3 tests, 1 skipped
> > | [mark@gravadlaks:~/src/kvm-unit-tests]% TESTNAME=pmu-chain-promotion TIMEOUT=90s ACCEL=kvm useapp qemu ./arm/run arm/pmu.flat -smp 1 -append 'pmu-memaccess-reliability'
> > | timeout -k 1s --foreground 90s /home/mark/.opt/apps/qemu/bin/qemu-system-aarch64 -nodefaults -machine virt,gic-version=host -accel kvm -cpu host -device virtio-serial-device -device virtconsole,chardev=ctd -chardev testdev,id=ctd -device pci-testdev -display none -serial stdio -kernel arm/pmu.flat -smp 1 -append pmu-memaccess-reliability # -initrd /tmp/tmp.ZToqwencZR
> > | INFO: PMU version: 0x4
> > | INFO: PMU implementer/ID code: 0(" ")/0
> > | INFO: Implements 6 event counters
> > | INFO: pmu: pmu-memaccess-reliability: 32-bit overflows: overflow=0 min=251 max=283 COUNT=250 MARGIN=100
> > | PASS: pmu: pmu-memaccess-reliability: 32-bit overflows: memaccess is reliable
> > | SKIP: pmu: pmu-memaccess-reliability: 64-bit overflows: Skip test as 64 overflows need FEAT_PMUv3p5
> > | SUMMARY: 2 tests, 1 skipped
> >
> > Thanks,
> > Mark.
> >
> 
