Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF80C72D3A2
	for <lists+kvm@lfdr.de>; Mon, 12 Jun 2023 23:54:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238032AbjFLVyW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Jun 2023 17:54:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238410AbjFLVyE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Jun 2023 17:54:04 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id AFA7318E
        for <kvm@vger.kernel.org>; Mon, 12 Jun 2023 14:54:01 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3ED791FB;
        Mon, 12 Jun 2023 14:54:46 -0700 (PDT)
Received: from [10.57.84.74] (unknown [10.57.84.74])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id BEBFE3F587;
        Mon, 12 Jun 2023 14:53:59 -0700 (PDT)
Message-ID: <de16e445-b119-d908-a4dc-c0d7cf942413@arm.com>
Date:   Mon, 12 Jun 2023 22:53:56 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.11.2
Subject: Re: [kvm-unit-tests PATCH v6 00/32] EFI and ACPI support for arm64
Content-Language: en-GB
To:     Nadav Amit <nadav.amit@gmail.com>
Cc:     Andrew Jones <andrew.jones@linux.dev>, kvm@vger.kernel.org,
        kvmarm@lists.linux.dev, Paolo Bonzini <pbonzini@redhat.com>,
        alexandru.elisei@arm.com, ricarkol@google.com, shahuang@redhat.com
References: <20230530160924.82158-1-nikos.nikoleris@arm.com>
 <CC2B570B-9EE0-4686-ADF3-82D1ECDD5D8A@gmail.com>
 <20230612-6e1f6fac1759f06309be3342@orel>
 <5fb09d21-437d-f83e-120f-8908a9b354c1@arm.com>
 <EE9170FC-8229-4D93-AD98-35394494CE61@gmail.com>
From:   Nikos Nikoleris <nikos.nikoleris@arm.com>
In-Reply-To: <EE9170FC-8229-4D93-AD98-35394494CE61@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/06/2023 16:59, Nadav Amit wrote:>
> Thanks. I am still struggling to run the tests on my environment. Why the
> heck frame-pointers are disabled on arm64? Perhaps I’ll send my patch to
> enable them (and add one on exception handling).
> 

I am afraid I don't know why it's omitted. It seems that x86 and arm 
keep it:

$> git grep KEEP_FRAME_POINTER
Makefile:frame-pointer-flag=-f$(if 
$(KEEP_FRAME_POINTER),no-,)omit-frame-pointer
arm/Makefile.arm:KEEP_FRAME_POINTER := y
x86/Makefile.common:KEEP_FRAME_POINTER := y

It should be straightforward to add it for an arm64 build with debugging 
enabled, perhaps along with your other patch.

> Anyhow, I was wondering, since it was not clearly mentioned in the
> cover-letter: which tests were run on what environment? Did they all pass
> or are there still some open issues?
> 
> [ I ask for my enabling efforts. Not blaming or anything. ]
> 
> Thanks again for the hard work, Nikos (and Andrew).
> 

With this series and Drew's patch "arch-run: Extend timeout when booting 
with UEFI", on a standard Ubuntu 22.04.2 LTS (gcc version 11.3.0 and 
QEMU emulator version 6.2.0), I get the following results:

$> ./run_tests.sh
PASS selftest-setup (2 tests)
PASS selftest-vectors-kernel (3 tests)
PASS selftest-vectors-user (2 tests)
PASS selftest-smp (1 tests)
PASS pci-test (1 tests)
PASS pmu-cycle-counter (2 tests)
PASS pmu-event-introspection (1 tests)
PASS pmu-event-counter-config (3 tests)
PASS pmu-basic-event-count (11 tests, 1 skipped)
PASS pmu-mem-access (3 tests, 1 skipped)
PASS pmu-sw-incr (5 tests, 1 skipped)
FAIL pmu-chained-counters (6 tests, 3 unexpected failures)
FAIL pmu-chained-sw-incr (2 tests, 2 unexpected failures)
FAIL pmu-chain-promotion (7 tests, 2 unexpected failures)
FAIL pmu-overflow-interrupt (7 tests, 2 unexpected failures, 1 skipped)
SKIP gicv2-ipi
SKIP gicv2-mmio
SKIP gicv2-mmio-up
SKIP gicv2-mmio-3p
PASS gicv3-ipi (3 tests)
SKIP gicv2-active
PASS gicv3-active (1 tests)
PASS its-introspection (5 tests)
PASS its-trigger (6 tests)
SKIP its-migration
SKIP its-pending-migration
SKIP its-migrate-unmapped-collection
PASS psci (5 tests, 1 skipped)
PASS timer (18 tests)
SKIP micro-bench (test marked as manual run only)
PASS cache (1 tests)
PASS debug-bp (6 tests)
SKIP debug-bp-migration
PASS debug-wp (8 tests)
SKIP debug-wp-migration
PASS debug-sstep (1 tests)
SKIP debug-sstep-migration

which is the same results I get when I build without --enable-efi, 
except for psci which requires ERRATA_6c7a5dce22b3=y to enable the 
cpu-on test. For this, I think we need to implement support for the 
ERRATA_* environmental variable.

Thanks,

Nikos
