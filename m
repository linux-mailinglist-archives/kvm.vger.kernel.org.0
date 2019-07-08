Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 11EE3620D7
	for <lists+kvm@lfdr.de>; Mon,  8 Jul 2019 16:48:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730129AbfGHOsp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Jul 2019 10:48:45 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:34840 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728499AbfGHOsp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 Jul 2019 10:48:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=cANsFjm+JWIcsDzpCtNJFjF3hQ3nZakimH4VaLTVSxY=; b=AckAuQqa73H6/hQ1nzW6pLF1S
        O33B3m8zxunnN/ELUf0QDNNrY20PtnBQvHvkueJNBK3f1w2zTqEbe4Q18NaKGXfLwfWOotNaDnWiS
        Y3aXcbkuqjFkCFWW84s44hDJ5tE7fpIzqv3iAbYZYgNe6Ie2H/YgMlSyFnql7lufAlSy8Wiv18QS0
        TGnNaJo2h8x+HA+XBW6guVuXK9q3KG4O7a7z8axzddzN+5srKaJWUZ7MrpmMX4d3MOgUvDNrbirBZ
        oWXmZyqADUOBXWVyTNwZ1HURRQT2nVZDgIwvC/5KDvTeY/cWMOVCnCUlCkxtlGprWV0EaJKQ1uOZZ
        0qPKVHRXg==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=hirez.programming.kicks-ass.net)
        by bombadil.infradead.org with esmtpsa (Exim 4.92 #3 (Red Hat Linux))
        id 1hkUwT-0001tT-3s; Mon, 08 Jul 2019 14:48:33 +0000
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 6313520B31C22; Mon,  8 Jul 2019 16:48:31 +0200 (CEST)
Date:   Mon, 8 Jul 2019 16:48:31 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Wei Wang <wei.w.wang@intel.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        pbonzini@redhat.com, ak@linux.intel.com, kan.liang@intel.com,
        mingo@redhat.com, rkrcmar@redhat.com, like.xu@intel.com,
        jannh@google.com, arei.gonglei@huawei.com, jmattson@google.com
Subject: Re: [PATCH v7 08/12] KVM/x86/vPMU: Add APIs to support host
 save/restore the guest lbr stack
Message-ID: <20190708144831.GN3402@hirez.programming.kicks-ass.net>
References: <1562548999-37095-1-git-send-email-wei.w.wang@intel.com>
 <1562548999-37095-9-git-send-email-wei.w.wang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1562548999-37095-9-git-send-email-wei.w.wang@intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jul 08, 2019 at 09:23:15AM +0800, Wei Wang wrote:
> From: Like Xu <like.xu@intel.com>
> 
> This patch adds support to enable/disable the host side save/restore

This patch should be disqualified on Changelog alone...

  Documentation/process/submitting-patches.rst:instead of "[This patch] makes xyzzy do frotz" or "[I] changed xyzzy

> for the guest lbr stack on vCPU switching. To enable that, the host
> creates a perf event for the vCPU, and the event attributes are set
> to the user callstack mode lbr so that all the conditions are meet in
> the host perf subsystem to save the lbr stack on task switching.
> 
> The host side lbr perf event are created only for the purpose of saving
> and restoring the lbr stack. There is no need to enable the lbr
> functionality for this perf event, because the feature is essentially
> used in the vCPU. So perf_event_create is invoked with need_counter=false
> to get no counter assigned for the perf event.
> 
> The vcpu_lbr field is added to cpuc, to indicate if the lbr perf event is
> used by the vCPU only for context switching. When the perf subsystem
> handles this event (e.g. lbr enable or read lbr stack on PMI) and finds
> it's non-zero, it simply returns.

*WHY* does the host need to save/restore? Why not make VMENTER/VMEXIT do
this?

Many of these patches don't explain why things are done; that's a
problem.
