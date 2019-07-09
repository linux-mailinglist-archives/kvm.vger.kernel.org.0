Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0AC3563501
	for <lists+kvm@lfdr.de>; Tue,  9 Jul 2019 13:36:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726149AbfGILgR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Jul 2019 07:36:17 -0400
Received: from merlin.infradead.org ([205.233.59.134]:37636 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726010AbfGILgR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 Jul 2019 07:36:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=YgDlKpLL6FoM72uVvrrMp8ibtwRuN9MgVyV7pwTQN3c=; b=GBiqo0TyUKJSuuY7YT2mSf4fg
        v3K5XpTW/zK4A35ndTEZ0RiTIekR9RxOQ3nwmmvj4yQ3EhWh25sAQLuYUjpPjj5pJ1M1Nuz+Eu/DV
        g5FA3lRH3aDZJCL6huP7BDAvSgoDG0/isxB1XP4V6dAuCzHdSftPD454vPbfLreJ8Uc59chyTzIZU
        6xufJaUaRfSx9IuhG6LNon/sVT6r7oNBtFuXzPPtM2ecWf21JvEU/Jniz6bybZGlqCi5fbO21UrRc
        BSdYmfRQo00AIA7AStFE7GPb3PLcycnj7y9edYURP7FLN6cVmuhelHc8GORFXboIdk0PM8BW2Jgcv
        rn5+t9iqQ==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=hirez.programming.kicks-ass.net)
        by merlin.infradead.org with esmtpsa (Exim 4.92 #3 (Red Hat Linux))
        id 1hkoPY-0006Ko-EK; Tue, 09 Jul 2019 11:35:52 +0000
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id A137E20120CB1; Tue,  9 Jul 2019 13:35:49 +0200 (CEST)
Date:   Tue, 9 Jul 2019 13:35:49 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Wei Wang <wei.w.wang@intel.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        pbonzini@redhat.com, ak@linux.intel.com, kan.liang@intel.com,
        mingo@redhat.com, rkrcmar@redhat.com, like.xu@intel.com,
        jannh@google.com, arei.gonglei@huawei.com, jmattson@google.com
Subject: Re: [PATCH v7 12/12] KVM/VMX/vPMU: support to report
 GLOBAL_STATUS_LBRS_FROZEN
Message-ID: <20190709113549.GU3402@hirez.programming.kicks-ass.net>
References: <1562548999-37095-1-git-send-email-wei.w.wang@intel.com>
 <1562548999-37095-13-git-send-email-wei.w.wang@intel.com>
 <20190708150909.GP3402@hirez.programming.kicks-ass.net>
 <5D2408D7.3000002@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5D2408D7.3000002@intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jul 09, 2019 at 11:24:07AM +0800, Wei Wang wrote:
> On 07/08/2019 11:09 PM, Peter Zijlstra wrote:
> > On Mon, Jul 08, 2019 at 09:23:19AM +0800, Wei Wang wrote:
> > > This patch enables the LBR related features in Arch v4 in advance,
> > > though the current vPMU only has v2 support. Other arch v4 related
> > > support will be enabled later in another series.
> > > 
> > > Arch v4 supports streamlined Freeze_LBR_on_PMI. According to the SDM,
> > > the LBR_FRZ bit is set to global status when debugctl.freeze_lbr_on_pmi
> > > has been set and a PMI is generated. The CTR_FRZ bit is set when
> > > debugctl.freeze_perfmon_on_pmi is set and a PMI is generated.
> > (that's still a misnomer; it is: freeze_perfmon_on_overflow)
> 
> OK. (but that was directly copied from the sdm 18.2.4.1)

Yeah, I know. But that name doesn't correctly describe what it actually
does. If it worked as named it would in fact be OK.

> > Why?
> > 
> > Who uses that v4 crud?
> 
> I saw the native perf driver has been updated to v4.

It's default disabled and I'm temped to simply remove it. See below.

> After the vPMU gets updated to v4, the guest perf would use that.
> 
> If you prefer to hold on this patch until vPMU v4 support,
> we could do that as well.
> 
> 
> > It's broken. It looses events between overflow
> > and PMI.
> 
> Do you mean it's a v4 hardware issue?

Yeah; although I'm not sure if its an implementation or specification
problem. But as it exists it is of very limited use.

Fundamentally our events (with exception of event groups) are
independent. Events should always count, except when the PMI is running
-- so as to not include the measurement overhead in the measurement
itself. But this (mis)feature stops the entire PMU as soon as a single
counter overflows, inhibiting all other counters from running (as they
should) until the PMI has happened and reset the state.

(Note that, strictly speaking, we even expect the overflowing counter to
continue counting until the PMI happens. Having an overflow should not
mean we loose events. A sampling and !sampling event should produce the
same event count.)

So even when there's only a single event (group) scheduled, it isn't
strictly right. And when there's multiple events scheduled it is
definitely wrong.

And while I understand the purpose of the current semantics; it makes a
single event group sample count more coherent, the fact that is looses
events just bugs me something fierce -- and as shown, it breaks tools.
