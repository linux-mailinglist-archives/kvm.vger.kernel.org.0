Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C82A1629373
	for <lists+kvm@lfdr.de>; Tue, 15 Nov 2022 09:43:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233032AbiKOIm7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Nov 2022 03:42:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232824AbiKOImw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Nov 2022 03:42:52 -0500
Received: from out0.migadu.com (out0.migadu.com [94.23.1.103])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 072AC14D1E
        for <kvm@vger.kernel.org>; Tue, 15 Nov 2022 00:42:49 -0800 (PST)
Date:   Tue, 15 Nov 2022 09:42:46 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1668501767;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YBBcuo+KUR8aFT+SIZH9QC1ODjrui+8wmX94IgWKXco=;
        b=bwrRXsCwTWwt3WKf57mSwXKtLNe/1VMzb2n9cNWMSdkT/2jNXjZqmcXsNvvlSHEcinurJ9
        os5PQ8ugOKlvi+ppcw7hiz3rkcyL0CRYHUtn7EcITJZDGF9hpVmBG/giQmZACuR8/YuBQs
        WbRvnXgXyp+7/jYelBuvhgtyqiWclao=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Andrew Jones <andrew.jones@linux.dev>
To:     Guoqing Jiang <guoqing.jiang@linux.dev>
Cc:     kvm@vger.kernel.org
Subject: Re: kvm-unit-tests: inconsistent test result between run_tests.sh
 and standalone test
Message-ID: <20221115084246.qrussaswk2pvjkze@kamzik>
References: <9bf9defb-1482-8f8a-7e8e-d07ab2f51852@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <9bf9defb-1482-8f8a-7e8e-d07ab2f51852@linux.dev>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Nov 15, 2022 at 04:11:48PM +0800, Guoqing Jiang wrote:
> Hi,
> 
> I find the two test results (pmu and intel_cet) are quite different, but
> other
> test results are consistent.
> 
> gjiang@x1:~/source/kvm-unit-tests> ./run_tests.sh
> ...
> *PASS pmu (142 tests)*
> ...
> *FAIL intel_cet*
> ...
> 
> 1. pmu standalone test
> gjiang@x1:~/source/kvm-unit-tests/tests> ./pmu
> BUILD_HEAD=73d9d850
> timeout -k 1s --foreground 90s /usr/bin/qemu-system-x86_64 --no-reboot
> -nodefaults -device pc-testdev -device isa-debug-exit,iobase=0xf4,iosize=0x4
> -vnc none -serial stdio -device pci-testdev -machine accel=kvm -kernel
> /tmp/tmp.Bai8UEIh2F -smp 1 -cpu max # -initrd /tmp/tmp.DFE9VFPOdp
> enabling apic
> smp: waiting for 0 APs
> paging enabled
> cr0 = 80010011
> cr3 = 1007000
> cr4 = 20
> PMU version:         2
> GP counters:         4
> GP counter width:    48
> Mask length:         7
> Fixed counters:      3
> Fixed counter width: 48
> PASS: core cycles-0
> ...
> FAIL: llc misses-0
> FAIL: llc misses-1
> FAIL: llc misses-2
> FAIL: llc misses-3
> ...
> SUMMARY: 142 tests, 4 unexpected failures
> *FAIL pmu (142 tests, 4 unexpected failures)
> 
> *And
> 
> gjiang@x1:~/source/kvm-unit-tests> ./x86-run ./x86/pmu.flat
> /usr/bin/qemu-system-x86_64 --no-reboot -nodefaults -device pc-testdev
> -device isa-debug-exit,iobase=0xf4,iosize=0x4 -vnc none -serial stdio
> -device pci-testdev -machine accel=kvm -kernel ./x86/pmu.flat # -initrd
> /tmp/tmp.jiEHps3KLW
> enabling apic
> smp: waiting for 0 APs
> paging enabled
> cr0 = 80010011
> cr3 = 1007000
> cr4 = 20
> *SKIP: No pmu is detected!**
> **SUMMARY: 1 tests, 1 skipped*
> 

./x86-run doesn't look at x86/unittests.cfg, which is where the pmu test
states that it needs '-cpu max'. You either need to add it yourself, e.g.
'./x86-run ./x86/pmu.flat -cpu max' or use run_tests.sh, e.g.
'./run_tests.sh pmu'. standalone tests get their parameters from
x86/unittests.cfg, which is why it's already using '-cpu max'.

> **
> 2. intel_cet
> gjiang@x1:~/source/kvm-unit-tests/tests> ./intel_cet
> BUILD_HEAD=73d9d850
> *skip intel_cet (test kernel not present)*

This error looks like x86/cet.c wasn't built. Maybe do a 'make clean' and
'make standalone' again and watch that cet.c doesn't fail to compile.

> 
> Then I am not sure which test result should be correct, standalone test
> or run all tests. Or am I missed something fundamentally?
> 
> Thanks for your reply in advance.

Thanks,
drew
