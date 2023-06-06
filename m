Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76E947245A7
	for <lists+kvm@lfdr.de>; Tue,  6 Jun 2023 16:20:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234840AbjFFOUQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Jun 2023 10:20:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231883AbjFFOUO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Jun 2023 10:20:14 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A0F0910C8
        for <kvm@vger.kernel.org>; Tue,  6 Jun 2023 07:20:13 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D0B292F4;
        Tue,  6 Jun 2023 07:20:58 -0700 (PDT)
Received: from monolith.localdoman (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 6E8163F6C4;
        Tue,  6 Jun 2023 07:20:12 -0700 (PDT)
Date:   Tue, 6 Jun 2023 15:20:09 +0100
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     Nikos Nikoleris <nikos.nikoleris@arm.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.linux.dev,
        Andrew Jones <andrew.jones@linux.dev>
Subject: Re: [kvm-unit-tests] arm/arm64: psci_cpu_on_test failures with tcg
Message-ID: <ZH9AmQQ1pu0xnhpA@monolith.localdoman>
References: <100579b3-649b-a57c-8639-edc6b22c7646@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <100579b3-649b-a57c-8639-edc6b22c7646@arm.com>
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

On Wed, May 31, 2023 at 11:41:33AM +0100, Nikos Nikoleris wrote:
> Hi,
> 
> I noticed that in the latest master the psci_cpu_on_test fails randomly for
> both arm and arm64 with tcg.
> 
> If I do:
> 
> $> for i in `seq 1 100`; do ACCEL=tcg MAX_SMP=8 ./run_tests.sh psci; done |
> grep FAIL
> 
> About 10 of the 100 runs fail for the arm and arm64 builds of the test. I
> had a look and I am not sure I understand why. When I run the test with kvm,
> I don't get any failures. Does anyone have an idea what could be causing
> this?

My first thought was that the PSCI CPU_OFF patches were to blame. But I
tested with kvm-unit-tests built from commit 17b2373401c4 ("arm: Replace
MAX_SMP probe loop in favor of reading directly") (first patch before that
series) and I am getting the same error on some runs (15 out of 100 the
only time I bothered counting):

$ ACCEL=tcg MAX_SMP=8 ./run_tests.sh psci
FAIL psci (4 tests, 1 unexpected failures)

$ cat logs/psci.log
timeout -k 1s --foreground 90s /usr/bin/qemu-system-aarch64 -nodefaults -machine virt -accel tcg -cpu cortex-a57 -device virtio-serial-device -device virtconsole,chardev=ctd -chardev testdev,id=ctd -device pci-testdev -display none -serial stdio -kernel arm/psci.flat -smp 8 # -initrd /tmp/tmp.xbOEu4nmXR
INFO: psci: PSCI version 1.1
PASS: psci: invalid-function
PASS: psci: affinity-info-on
PASS: psci: affinity-info-off
INFO: psci: got 2 CPU_ON success
FAIL: psci: cpu-on
SUMMARY: 4 tests, 1 unexpected failures

with qemu version:

$ qemu-system-aarch64 --version
QEMU emulator version 8.0.2
Copyright (c) 2003-2022 Fabrice Bellard and the QEMU Project developers

Since it doesn't happen with KVM, I would perhaps try with older versions of
qemu, in case there's some sort of inter-thread synchronization hiccup like
there was with KVM. Failing that, you could try bisecting the issue in
kvm-unit-tests.

Thanks,
Alex

> 
> Thanks,
> 
> Nikos
