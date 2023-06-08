Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1BFBC72853F
	for <lists+kvm@lfdr.de>; Thu,  8 Jun 2023 18:39:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234202AbjFHQjI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Jun 2023 12:39:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234010AbjFHQjD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Jun 2023 12:39:03 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2E444271D
        for <kvm@vger.kernel.org>; Thu,  8 Jun 2023 09:38:41 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9ADA6AB6;
        Thu,  8 Jun 2023 09:39:00 -0700 (PDT)
Received: from monolith.localdoman (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 3BE433F587;
        Thu,  8 Jun 2023 09:38:13 -0700 (PDT)
Date:   Thu, 8 Jun 2023 17:38:10 +0100
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     Andrew Jones <andrew.jones@linux.dev>
Cc:     Eric Auger <eric.auger@redhat.com>, eric.auger.pro@gmail.com,
        kvm@vger.kernel.org, kvmarm@lists.linux.dev, maz@kernel.org,
        will@kernel.org, oliver.upton@linux.dev, ricarkol@google.com,
        reijiw@google.com, mark.rutland@arm.com
Subject: Re: [kvm-unit-tests PATCH v2 0/6] arm: pmu: Fix random failures of
 pmu-chain-promotion
Message-ID: <ZIID8psAxNOoMSIM@monolith.localdoman>
References: <20230531201438.3881600-1-eric.auger@redhat.com>
 <20230607-a12c8e1d270b53e522756648@orel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230607-a12c8e1d270b53e522756648@orel>
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

On Wed, Jun 07, 2023 at 09:07:09PM +0200, Andrew Jones wrote:
> On Wed, May 31, 2023 at 10:14:32PM +0200, Eric Auger wrote:
> > On some HW (ThunderXv2), some random failures of
> > pmu-chain-promotion test can be observed.
> > 
> > pmu-chain-promotion is composed of several subtests
> > which run 2 mem_access loops. The initial value of
> > the counter is set so that no overflow is expected on
> > the first loop run and overflow is expected on the second.
> > However it is observed that sometimes we get an overflow
> > on the first run. It looks related to some variability of
> > the mem_acess count. This variability is observed on all
> > HW I have access to, with different span though. On
> > ThunderX2 HW it looks the margin that is currently taken
> > is too small and we regularly hit failure.
> > 
> > although the first goal of this series is to increase
> > the count/margin used in those tests, it also attempts
> > to improve the pmu-chain-promotion logs, add some barriers
> > in the mem-access loop, clarify the chain counter
> > enable/disable sequence.
> > 
> > A new 'pmu-mem-access-reliability' is also introduced to
> > detect issues with MEM_ACCESS event variability and make
> > the debug easier.
> > 
> > Obviously one can wonder if this variability is something normal
> > and does not hide any other bug. I hope this series will raise
> > additional discussions about this.
> > 
> > https://github.com/eauger/kut/tree/pmu-chain-promotion-fixes-v2
> > 
> > History:
> > v1 -> v2:
> > - Take into account Alexandru's & Mark's comments. Added some
> >   R-b's and T-b's.
> > 
> > Eric Auger (6):
> >   arm: pmu: pmu-chain-promotion: Improve debug messages
> >   arm: pmu: pmu-chain-promotion: Introduce defines for count and margin
> >     values
> >   arm: pmu: Add extra DSB barriers in the mem_access loop
> >   arm: pmu: Fix chain counter enable/disable sequences
> >   arm: pmu: Add pmu-mem-access-reliability test
> >   arm: pmu-chain-promotion: Increase the count and margin values
> > 
> >  arm/pmu.c         | 196 +++++++++++++++++++++++++++++++++-------------
> >  arm/unittests.cfg |   6 ++
> >  2 files changed, 148 insertions(+), 54 deletions(-)
> > 
> > -- 
> > 2.38.1
> >
> 
> Hi Eric,
> 
> I'm eager to merge this, but I'll give Alexandru some time to revisit it
> since he had comments on the last revision.

I've just come back from holiday, I'll have a look next week.

Thanks,
Alex

> 
> Thanks,
> drew
