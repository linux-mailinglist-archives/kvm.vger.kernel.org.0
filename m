Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99BBB72E145
	for <lists+kvm@lfdr.de>; Tue, 13 Jun 2023 13:21:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239815AbjFMLV1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Jun 2023 07:21:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241946AbjFMLVS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Jun 2023 07:21:18 -0400
Received: from out-1.mta1.migadu.com (out-1.mta1.migadu.com [IPv6:2001:41d0:203:375::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F89498
        for <kvm@vger.kernel.org>; Tue, 13 Jun 2023 04:21:16 -0700 (PDT)
Date:   Tue, 13 Jun 2023 13:21:08 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1686655273;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4Hw2YLf0zHpJxsMibpOgFBzjb1iaq1HNcu4P352CxmU=;
        b=Jv0h6MoIlR2Qc49riYAbAbly01LxPiAnXJGg8iQuFVpUFf0a4487sSuQ0UXUtt8vGO5tRY
        YT9Nz6ugfjvOuFNea1RuxBoC63c7PkA12TH64T/1sgfFP6o9lfx4eiu3khuxS55AiDAnLB
        sOrEoUiCFXbLiZkv8qIYTCHSpbnPYaA=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Andrew Jones <andrew.jones@linux.dev>
To:     Nikos Nikoleris <nikos.nikoleris@arm.com>
Cc:     Nadav Amit <nadav.amit@gmail.com>, kvm@vger.kernel.org,
        kvmarm@lists.linux.dev, Paolo Bonzini <pbonzini@redhat.com>,
        alexandru.elisei@arm.com, ricarkol@google.com, shahuang@redhat.com
Subject: Re: [kvm-unit-tests PATCH v6 00/32] EFI and ACPI support for arm64
Message-ID: <20230613-6b1cb3080babea45f2542c49@orel>
References: <20230530160924.82158-1-nikos.nikoleris@arm.com>
 <CC2B570B-9EE0-4686-ADF3-82D1ECDD5D8A@gmail.com>
 <20230612-6e1f6fac1759f06309be3342@orel>
 <5fb09d21-437d-f83e-120f-8908a9b354c1@arm.com>
 <EE9170FC-8229-4D93-AD98-35394494CE61@gmail.com>
 <de16e445-b119-d908-a4dc-c0d7cf942413@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <de16e445-b119-d908-a4dc-c0d7cf942413@arm.com>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 12, 2023 at 10:53:56PM +0100, Nikos Nikoleris wrote:
> On 12/06/2023 16:59, Nadav Amit wrote:>
> > Thanks. I am still struggling to run the tests on my environment. Why the
> > heck frame-pointers are disabled on arm64? Perhaps I’ll send my patch to
> > enable them (and add one on exception handling).
> > 
> 
> I am afraid I don't know why it's omitted. It seems that x86 and arm keep
> it:

The support was first added to x86 and then I ported it to arm and gave
porting it to arm64 a small effort too, but it didn't work off the bat.
I wrote it down on my TODO, but it eventually fell off the bottom...

> 
> $> git grep KEEP_FRAME_POINTER
> Makefile:frame-pointer-flag=-f$(if
> $(KEEP_FRAME_POINTER),no-,)omit-frame-pointer
> arm/Makefile.arm:KEEP_FRAME_POINTER := y
> x86/Makefile.common:KEEP_FRAME_POINTER := y
> 
> It should be straightforward to add it for an arm64 build with debugging
> enabled, perhaps along with your other patch.
> 
> > Anyhow, I was wondering, since it was not clearly mentioned in the
> > cover-letter: which tests were run on what environment? Did they all pass
> > or are there still some open issues?
> > 
> > [ I ask for my enabling efforts. Not blaming or anything. ]
> > 
> > Thanks again for the hard work, Nikos (and Andrew).
> > 
> 
> With this series and Drew's patch "arch-run: Extend timeout when booting
> with UEFI", on a standard Ubuntu 22.04.2 LTS (gcc version 11.3.0 and QEMU
> emulator version 6.2.0), I get the following results:
> 
> $> ./run_tests.sh
> PASS selftest-setup (2 tests)
> PASS selftest-vectors-kernel (3 tests)
> PASS selftest-vectors-user (2 tests)
> PASS selftest-smp (1 tests)
> PASS pci-test (1 tests)
> PASS pmu-cycle-counter (2 tests)
> PASS pmu-event-introspection (1 tests)
> PASS pmu-event-counter-config (3 tests)
> PASS pmu-basic-event-count (11 tests, 1 skipped)
> PASS pmu-mem-access (3 tests, 1 skipped)
> PASS pmu-sw-incr (5 tests, 1 skipped)
> FAIL pmu-chained-counters (6 tests, 3 unexpected failures)
> FAIL pmu-chained-sw-incr (2 tests, 2 unexpected failures)
> FAIL pmu-chain-promotion (7 tests, 2 unexpected failures)
> FAIL pmu-overflow-interrupt (7 tests, 2 unexpected failures, 1 skipped)
> SKIP gicv2-ipi
> SKIP gicv2-mmio
> SKIP gicv2-mmio-up
> SKIP gicv2-mmio-3p
> PASS gicv3-ipi (3 tests)
> SKIP gicv2-active
> PASS gicv3-active (1 tests)
> PASS its-introspection (5 tests)
> PASS its-trigger (6 tests)
> SKIP its-migration
> SKIP its-pending-migration
> SKIP its-migrate-unmapped-collection
> PASS psci (5 tests, 1 skipped)
> PASS timer (18 tests)
> SKIP micro-bench (test marked as manual run only)
> PASS cache (1 tests)
> PASS debug-bp (6 tests)
> SKIP debug-bp-migration
> PASS debug-wp (8 tests)
> SKIP debug-wp-migration
> PASS debug-sstep (1 tests)
> SKIP debug-sstep-migration
> 
> which is the same results I get when I build without --enable-efi, except
> for psci which requires ERRATA_6c7a5dce22b3=y to enable the cpu-on test. For
> this, I think we need to implement support for the ERRATA_* environmental
> variable.
>

On Fedora 36 with qemu-system-aarch64-6.2.0-17.fc36.x86_64 I have

PASS selftest-setup (2 tests)
PASS selftest-vectors-kernel (3 tests)
PASS selftest-vectors-user (2 tests)
PASS selftest-smp (1 tests)
PASS pci-test (1 tests)
PASS pmu-cycle-counter (2 tests)
FAIL pmu-event-introspection (1 tests, 1 unexpected failures)
PASS pmu-event-counter-config (3 tests)
SKIP pmu-basic-event-count (2 tests, 2 skipped)
SKIP pmu-mem-access (2 tests, 2 skipped)
PASS pmu-sw-incr (5 tests, 1 skipped)
SKIP pmu-chained-counters (1 tests, 1 skipped)
SKIP pmu-chained-sw-incr (1 tests, 1 skipped)
SKIP pmu-chain-promotion (1 tests, 1 skipped)
SKIP pmu-overflow-interrupt (2 tests, 2 skipped)
PASS gicv2-ipi (3 tests)
PASS gicv2-mmio (17 tests, 1 skipped)
FAIL gicv2-mmio-up (17 tests, 2 unexpected failures)
FAIL gicv2-mmio-3p (17 tests, 3 unexpected failures)
PASS gicv3-ipi (3 tests)
PASS gicv2-active (1 tests)
PASS gicv3-active (1 tests)
PASS its-introspection (5 tests)
PASS its-trigger (6 tests)
PASS psci (5 tests, 1 skipped)
PASS timer (18 tests)
SKIP micro-bench (test marked as manual run only)
PASS cache (1 tests)
PASS debug-bp (6 tests)
PASS debug-wp (8 tests)
FAIL debug-sstep (1 tests, 1 unexpected failures)

I had to drop all the migration tests from unittests.cfg since they were
hanging. The debug-sstep test passes with a later QEMU. Skipping the
psci test is for the same reason Nikos points out above. I diffed the
logs and besides EFI tests having edk2 output, they matched. I get the
same results with ACPI as DT, other than pci-test being skipped. I also
ran a couple tests from u-boot with bootefi and they worked.

Thanks,
drew
