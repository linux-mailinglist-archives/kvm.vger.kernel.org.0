Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 84E8D740E84
	for <lists+kvm@lfdr.de>; Wed, 28 Jun 2023 12:20:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230121AbjF1KUe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Jun 2023 06:20:34 -0400
Received: from foss.arm.com ([217.140.110.172]:53190 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231417AbjF1KSQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Jun 2023 06:18:16 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D2067113E;
        Wed, 28 Jun 2023 03:18:59 -0700 (PDT)
Received: from monolith.localdoman (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 4F5463F663;
        Wed, 28 Jun 2023 03:18:14 -0700 (PDT)
Date:   Wed, 28 Jun 2023 11:18:11 +0100
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     Eric Auger <eric.auger@redhat.com>
Cc:     eric.auger.pro@gmail.com, kvm@vger.kernel.org,
        kvmarm@lists.linux.dev, andrew.jones@linux.dev, maz@kernel.org,
        will@kernel.org, oliver.upton@linux.dev, ricarkol@google.com,
        reijiw@google.com, mark.rutland@arm.com
Subject: Re: [kvm-unit-tests PATCH v3 0/6] arm: pmu: Fix random failures of
 pmu-chain-promotion
Message-ID: <ZJwI45VTkf6TppBm@monolith.localdoman>
References: <20230619200401.1963751-1-eric.auger@redhat.com>
 <0aa48994-96b3-b5a1-e72b-961e6e892142@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0aa48994-96b3-b5a1-e72b-961e6e892142@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

On Wed, Jun 28, 2023 at 09:44:44AM +0200, Eric Auger wrote:
> Hi Alexandru, Drew,
> 
> On 6/19/23 22:03, Eric Auger wrote:
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
> > https://github.com/eauger/kut/tree/pmu-chain-promotion-fixes-v3
> >
> > History:
> >
> > v2 -> v3:
> > - took into account Alexandru's comments. See individual log
> >   files
> Gentle ping. Does this version match all your expectations?

The series are on my radar, I'll have a look this Friday.

Thanks,
Alex

> 
> Thanks
> 
> Eric
> >
> > v1 -> v2:
> > - Take into account Alexandru's & Mark's comments. Added some
> >   R-b's and T-b's.
> >
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
> >  arm/pmu.c         | 208 ++++++++++++++++++++++++++++++++--------------
> >  arm/unittests.cfg |   6 ++
> >  2 files changed, 153 insertions(+), 61 deletions(-)
> >
> 
