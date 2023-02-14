Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B1E4695CBF
	for <lists+kvm@lfdr.de>; Tue, 14 Feb 2023 09:19:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231963AbjBNITZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Feb 2023 03:19:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231932AbjBNITY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Feb 2023 03:19:24 -0500
Received: from out-200.mta1.migadu.com (out-200.mta1.migadu.com [95.215.58.200])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0C61206BF
        for <kvm@vger.kernel.org>; Tue, 14 Feb 2023 00:19:22 -0800 (PST)
Date:   Tue, 14 Feb 2023 08:19:16 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1676362760;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=YJ9ng7jUtpZsYq/o76W2IyXahycqgRj/9OLxPM3i3H0=;
        b=QAUVK9N5CEVn8QixnnCxGubdm2JFXLNjoK8o1bILj64YKrzWc+wKi6DK+v2N2DLF07eXor
        DJseMCCXaHG+oU9/kIQwxp9NUnmrRgupyeGOBjotQ2F4LS/OWtHSn/bm3VJhntGpCBWNOd
        dl0IVDIOiVvg4wyPzcn0kmWURepULoc=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Raghavendra Rao Ananta <rananta@google.com>
Cc:     Oliver Upton <oupton@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Marc Zyngier <maz@kernel.org>,
        Ricardo Koller <ricarkol@google.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jing Zhang <jingzhangos@google.com>,
        Colton Lewis <coltonlewis@google.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH 00/13] Extend the vPMU selftest
Message-ID: <Y+tEBNBMDgRWK3hf@linux.dev>
References: <20230213180234.2885032-1-rananta@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230213180234.2885032-1-rananta@google.com>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Raghavendra,

On Mon, Feb 13, 2023 at 06:02:21PM +0000, Raghavendra Rao Ananta wrote:
> Hello,
> 
> This vPMU KVM selftest series is an extension to the selftests
> introduced by Reiji Watanabe in his series aims to limit the number
> of PMCs on vCPU from userspace [1].

Right off the bat, I'd much prefer it if the patches weren't posted this
way. Building on top of an in flight series requires that reviewers page
in the context from Reiji's selftest patch in another thread then read
what you have.

I imagine this happened organically because you two are developing in
parallel (which is great!), but at this point Reiji's kernel changes are
only tangientally related to the selftest. Given that, is it possible to
split the test + KVM changes into two distinct series that each of you
will own? That way it is possible to get the full picture from one email
thread alone.

> The idea behind this series is to expand the test coverage to include
> the tests that validates actions from userspace, such as allowing or
> denying certain events via KVM_ARM_VCPU_PMU_V3_FILTER attribute, KVM's
> guarding of the PMU attributes to count EL2/EL3 events, and formal KVM
> behavior that enables PMU emulation. The last part validates the guest
> expectations of the vPMU by setting up a stress test that force-migrates
> multiple vCPUs frequently across random pCPUs in the system, thus
> ensuring KVM's management of vCPU PMU contexts correctly.
> 
> Patch-1 renames the test file to be more generic.
> 
> Patch-2 refactors the existing tests for plugging-in the upcoming tests
> easily.

sidenote: if you wind up reposting the complete series these can just be
squashed into the original patch.

> Patch-3 and 4 add helper macros and functions respectively to interact
> with the cycle counter.
> 
> Patch-5 extends create_vpmu_vm() to accept an array of event filters
> as an argument that are to be applied to the VM.
> 
> Patch-6 tests the KVM_ARM_VCPU_PMU_V3_FILTER attribute by scripting
> various combinations of events that are to be allowed or denied to
> the guest and verifying guest's behavior.
> 
> Patch-7 adds test to validate KVM's handling of guest requests to count
> events in EL2/EL3.
> 
> Patch-8 introduces the vCPU migration stress testing by validating cycle
> counter and general purpose counter's behavior across vCPU migrations.
> 
> Patch-9, 10, and 11 expands the tests in patch-8 to validate
> overflow/IRQ functionality, chained events, and occupancy of all the PMU
> counters, respectively.
> 
> Patch-12 extends create_vpmu_vm() to create multiple vCPUs for the VM.
> 
> Patch-13 expands the stress tests for multiple vCPUs.
> 
> The series has been tested on hardwares with PMUv8p1 and PMUvp5.

-- 
Thanks,
Oliver
