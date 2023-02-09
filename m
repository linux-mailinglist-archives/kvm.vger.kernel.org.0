Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F1E968FE23
	for <lists+kvm@lfdr.de>; Thu,  9 Feb 2023 04:53:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232869AbjBIDxm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Feb 2023 22:53:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232887AbjBIDxY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Feb 2023 22:53:24 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 685482E825;
        Wed,  8 Feb 2023 19:53:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 01E70B8164F;
        Thu,  9 Feb 2023 03:53:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 991F1C433EF;
        Thu,  9 Feb 2023 03:53:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675914781;
        bh=PrK+3mMGT0AsXDJ9S99RyGu52aNIxwsaYCROU5Oo4OM=;
        h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
        b=qhTeIYtRUzal1VgLCF0nLl1VCLXJMoZ1czttTNyEQshUW9ZTpBNqcQZOZrmWZRlBz
         9m3c0DFkw+VdrXqVeHF9FNpRHcFnyPtSj1X8y9GpOk3Aooe48W20eWPdzR8AMUAWrp
         hgcLaM63vtuur07kSN0Ow5degZjwvUtYj4Eh8KcloqitPmZPnccfOjQmw+ijbbZ5PO
         T1xPCqKM4EmePKuAiPB/kAXyPA6BmqZEe4ZEe9LxtCUZ1ul1CxZexRDSG8tQDnKlfE
         0IPBYOL4351HH3rZgjXK8L3nb+LxlOFKmnRFewxeset+ai1TuXi0whpVZ3MUEKJ57d
         khvC2jyUkFTig==
Received: by paulmck-ThinkPad-P17-Gen-1.home (Postfix, from userid 1000)
        id 120E15C099C; Wed,  8 Feb 2023 19:53:00 -0800 (PST)
Date:   Wed, 8 Feb 2023 19:53:00 -0800
From:   "Paul E. McKenney" <paulmck@kernel.org>
To:     Usama Arif <usama.arif@bytedance.com>
Cc:     dwmw2@infradead.org, tglx@linutronix.de, kim.phillips@amd.com,
        arjan@linux.intel.com, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, hpa@zytor.com, x86@kernel.org,
        pbonzini@redhat.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, rcu@vger.kernel.org, mimoja@mimoja.de,
        hewenliang4@huawei.com, thomas.lendacky@amd.com, seanjc@google.com,
        pmenzel@molgen.mpg.de, fam.zheng@bytedance.com,
        punit.agrawal@bytedance.com, simon.evans@bytedance.com,
        liangma@liangbit.com
Subject: Re: [PATCH v7 0/9] Parallel CPU bringup for x86_64
Message-ID: <20230209035300.GA3216394@paulmck-ThinkPad-P17-Gen-1>
Reply-To: paulmck@kernel.org
References: <20230207230436.2690891-1-usama.arif@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230207230436.2690891-1-usama.arif@bytedance.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Feb 07, 2023 at 11:04:27PM +0000, Usama Arif wrote:
> Tested on v7, doing INIT/SIPI/SIPI in parallel brings down the time for
> smpboot from ~700ms to 100ms (85% improvement) on a server with 128 CPUs
> split across 2 NUMA nodes.
> 
> The major change over v6 is keeping parallel smp support enabled in AMD.
> APIC ID for parallel CPU bringup is now obtained from CPUID leaf 0x0B
> (for x2APIC mode) otherwise CPUID leaf 0x1 (8 bits).
> 
> The patch for reusing timer calibration for secondary CPUs is also removed
> from the series as its not part of parallel smp bringup and needs to be
> further thought about.

Running rcutorture on this got me the following NULL pointer dereference
on scenario TREE01:

------------------------------------------------------------------------

[   34.662066] smpboot: CPU 0 is now offline
[   34.674075] rcu: NOCB: Cannot CB-offload offline CPU 25
[   35.038003] rcu: De-offloading 5
[   35.112997] rcu: Offloading 12
[   35.716011] smpboot: Booting Node 0 Processor 0 APIC 0x0
[   35.762685] BUG: kernel NULL pointer dereference, address: 0000000000000001
[   35.764278] #PF: supervisor instruction fetch in kernel mode
[   35.765530] #PF: error_code(0x0010) - not-present page
[   35.766700] PGD 0 P4D 0
[   35.767278] Oops: 0010 [#1] PREEMPT SMP PTI
[   35.768223] CPU: 36 PID: 0 Comm: swapper/36 Not tainted 6.2.0-rc1-00206-g18a37610b632-dirty #3563
[   35.770201] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-1.16.0-0-gd239552ce722-prebuilt.qemu.org 04/01/2014

------------------------------------------------------------------------

Given an x86 system with KVM and qemu, this can be reproduced by running
the following from the top-level directory in the Linux-kernel source
tree:

	tools/testing/selftests/rcutorture/bin/kvm.sh --allcpus --configs "TREE01 TINY01" --trust-make

Out of 15 runs, 14 blew up just after the first attempt to bring CPU
0 back online.  The 15th run blew up just after the second attempt to
bring CPU 0 online, the first attempt having succeeded.

My guess is that the CONFIG_BOOTPARAM_HOTPLUG_CPU0=y Kconfig option is
tickling this bug.  This Kconfig option has been added to the TREE01
scenario in the -rcu tree's "dev" branch, which might mean that this test
would pass on mainline.  But CONFIG_BOOTPARAM_HOTPLUG_CPU0=y is not new,
only rcutorture's testing of it.

Thoughts?

							Thanx, Paul
