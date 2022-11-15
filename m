Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3FCA6629302
	for <lists+kvm@lfdr.de>; Tue, 15 Nov 2022 09:12:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232380AbiKOIME (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Nov 2022 03:12:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232569AbiKOILz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Nov 2022 03:11:55 -0500
Received: from out2.migadu.com (out2.migadu.com [188.165.223.204])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D114B6306
        for <kvm@vger.kernel.org>; Tue, 15 Nov 2022 00:11:53 -0800 (PST)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1668499911;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=HdmIUkOsbc0SLEpzSHddpL0douASw16AtuL4IcfFUoo=;
        b=BBwnfdAI0eZdISle4nnLDlwm8Zc61V0cqBkn6IdchhyEnm8dPLPmuaMZeIKAAziI7dNQs9
        /J4CA4EFUdsp4QYl8XXCIu+ancd0M/ug4s2FUwq3MqouKuUeHbK3ajyCP0NxTb06+wZ8p+
        ob0cVig2uyNbWuS1k5cMGkxtZTZm7zs=
From:   Guoqing Jiang <guoqing.jiang@linux.dev>
Subject: kvm-unit-tests: inconsistent test result between run_tests.sh and
 standalone test
To:     kvm@vger.kernel.org
Message-ID: <9bf9defb-1482-8f8a-7e8e-d07ab2f51852@linux.dev>
Date:   Tue, 15 Nov 2022 16:11:48 +0800
MIME-Version: 1.0
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

I find the two test results (pmu and intel_cet) are quite different, but 
other
test results are consistent.

gjiang@x1:~/source/kvm-unit-tests> ./run_tests.sh
...
*PASS pmu (142 tests)*
...
*FAIL intel_cet*
...

1. pmu standalone test
gjiang@x1:~/source/kvm-unit-tests/tests> ./pmu
BUILD_HEAD=73d9d850
timeout -k 1s --foreground 90s /usr/bin/qemu-system-x86_64 --no-reboot 
-nodefaults -device pc-testdev -device 
isa-debug-exit,iobase=0xf4,iosize=0x4 -vnc none -serial stdio -device 
pci-testdev -machine accel=kvm -kernel /tmp/tmp.Bai8UEIh2F -smp 1 -cpu 
max # -initrd /tmp/tmp.DFE9VFPOdp
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
PASS: core cycles-0
...
FAIL: llc misses-0
FAIL: llc misses-1
FAIL: llc misses-2
FAIL: llc misses-3
...
SUMMARY: 142 tests, 4 unexpected failures
*FAIL pmu (142 tests, 4 unexpected failures)

*And

gjiang@x1:~/source/kvm-unit-tests> ./x86-run ./x86/pmu.flat
/usr/bin/qemu-system-x86_64 --no-reboot -nodefaults -device pc-testdev 
-device isa-debug-exit,iobase=0xf4,iosize=0x4 -vnc none -serial stdio 
-device pci-testdev -machine accel=kvm -kernel ./x86/pmu.flat # -initrd 
/tmp/tmp.jiEHps3KLW
enabling apic
smp: waiting for 0 APs
paging enabled
cr0 = 80010011
cr3 = 1007000
cr4 = 20
*SKIP: No pmu is detected!**
**SUMMARY: 1 tests, 1 skipped*

**
2. intel_cet
gjiang@x1:~/source/kvm-unit-tests/tests> ./intel_cet
BUILD_HEAD=73d9d850
*skip intel_cet (test kernel not present)*

Then I am not sure which test result should be correct, standalone test
or run all tests. Or am I missed something fundamentally?

Thanks for your reply in advance.

Guoqing
