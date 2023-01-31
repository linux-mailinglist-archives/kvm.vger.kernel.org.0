Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A526682BD1
	for <lists+kvm@lfdr.de>; Tue, 31 Jan 2023 12:50:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231839AbjAaLuH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 Jan 2023 06:50:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230286AbjAaLuD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 31 Jan 2023 06:50:03 -0500
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8AD65125A0
        for <kvm@vger.kernel.org>; Tue, 31 Jan 2023 03:49:58 -0800 (PST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 679FF175A;
        Tue, 31 Jan 2023 03:50:40 -0800 (PST)
Received: from monolith.localdoman (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 80ACC3FA27;
        Tue, 31 Jan 2023 03:49:57 -0800 (PST)
Date:   Tue, 31 Jan 2023 11:49:50 +0000
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     Andrew Jones <andrew.jones@linux.dev>
Cc:     kvm@vger.kernel.org, kvmarm@lists.linux.dev
Subject: Re: [kvm-unit-tests PATCH v5 2/2] arm/psci: Add PSCI CPU_OFF test
 case
Message-ID: <Y9kAXuOfgHgMJEN+@monolith.localdoman>
References: <20230127175916.65389-1-alexandru.elisei@arm.com>
 <20230127175916.65389-3-alexandru.elisei@arm.com>
 <20230131065623.7jj4a2hp44vphw5t@orel>
 <Y9jk+MVEPYNC1heb@monolith.localdoman>
 <20230131104610.v3n2gxmime32ae3r@orel>
 <Y9j3D9Ft4mWSoK7G@monolith.localdoman>
 <20230131114549.jnvn7g3vk4r2fyt6@orel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230131114549.jnvn7g3vk4r2fyt6@orel>
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Drew,

On Tue, Jan 31, 2023 at 12:45:49PM +0100, Andrew Jones wrote:
> On Tue, Jan 31, 2023 at 11:16:22AM +0000, Alexandru Elisei wrote:
> ...
> > > > Does that make sense? Should I add a comment to make it clear why cpu-off
> > > > is skipped when cpu-on fails?
> > > 
> > > I missed that cpu_on_success was initialized to true. Seeing that now, I
> > > understand how the only time it's false is if the cpu-on test failed. When
> > > I thought it was initialized to false it had two ways to be false, failure
> > > or skip. I think it's a bit confusing to set a 'success' variable to true
> > > when the test is skipped. Also, we can relax the condition as to whether
> > > or not we try cpu-off by simply checking that all cpus, other than cpu0,
> > > are in idle. How about
> > > 
> > >  if (ERRATA(6c7a5dce22b3))
> > >      report(psci_cpu_on_test(), "cpu-on");
> > >  else
> > >      report_skip("Skipping unsafe cpu-on test. Set ERRATA_6c7a5dce22b3=y to enable.");
> > > 
> > >  assert(!cpu_idle(0));
> > 
> > cpu0 is the boot CPU, I don't see how cpu0 can execute this line of code
> > and be in idle at the same time.
> 
> That's why it's an assert and not an if, i.e. it should never happen. It
> could happen if things are messed up in the lib code, a previous test
> mucked with cpu_idle_mask, or a previous test idled cpu0 and manipulated
> another cpu into executing this line.
> 
> > Unless this is done for documenting
> > purposes, to explain why we compare the number of cpus in idle to nr_cpus
> > -1 below.
> 
> Exactly, and furthermore that we expect the missing cpu to be cpu0.
> 
> > But I still find it confusing, especially considering (almost)
> > the same assert is in smp.c:
> > 
> > void on_cpu_async(int cpu, void (*func)(void *data), void *data)
> > {
> > 	[..]
> >         assert_msg(cpu != 0 || cpu0_calls_idle, "Waiting on CPU0, which is unlikely to idle. "
> >                                                 "If this is intended set cpu0_calls_idle=1");
> > 
> > I know, it's a different scenario, but the point I'm trying to make is that
> > kvm-unit-tests really doesn't expect cpu0 to be in idle. I would prefer not
> > to have the assert here.
> 
> asserts are for things we assume, but also want to ensure, as other code
> depends on the assumptions. Please keep the assert. It doesn't hurt :-)

I'm keeping the assert then :)

Thanks,
Alex

> 
> Thanks,
> drew
