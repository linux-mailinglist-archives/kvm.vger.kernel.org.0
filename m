Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7D4CA15FE92
	for <lists+kvm@lfdr.de>; Sat, 15 Feb 2020 14:17:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725974AbgBONA7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 15 Feb 2020 08:00:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:53224 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725965AbgBONA6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 15 Feb 2020 08:00:58 -0500
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3DDB12083B;
        Sat, 15 Feb 2020 13:00:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581771658;
        bh=IlVg+7WZjLz8i78gKlPFmvAGVxAOutix+9XWCG/zJNU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=OpqoOBzxtuhp34xWuSv1WvEvv+xj2BGRWrM9Oxrh4jTTuI7hPgtj60P1aF16NwBMA
         j8zwqPSkJSmIGMnY2aG5hU4Whc47ARjBQqr+XDDWVmfV/OnvA10nrt+WqSSlo0EUDQ
         hCEhxaaeR+IouzIhP5EaIGOv8YIsjwrsvR2M5xBg=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why)
        by disco-boy.misterjones.org with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1j2x44-005RoV-HQ; Sat, 15 Feb 2020 13:00:56 +0000
Date:   Sat, 15 Feb 2020 13:00:55 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Cc:     James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Robin Murphy <Robin.Murphy@arm.com>
Subject: Re: [PATCH 0/2] KVM: arm64: Filtering PMU events
Message-ID: <20200215130055.0995efe7@why>
In-Reply-To: <20200214183615.25498-1-maz@kernel.org>
References: <20200214183615.25498-1-maz@kernel.org>
Organization: Approximate
X-Mailer: Claws Mail 3.17.4 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, Robin.Murphy@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 14 Feb 2020 18:36:13 +0000
Marc Zyngier <maz@kernel.org> wrote:

> It is at times necessary to prevent a guest from being able to sample
> certain events if multiple CPUs share resources such as a cache level.
> In this case, it would be interesting if the VMM could simply prevent
> certain events from being counted instead of simply not exposing a PMU.
> 
> Given that most events are not architected, there is no easy way
> to designate which events shouldn't be counted other than specifying
> the raw event number.
> 
> Since I have no idea whether it is better to use an event whitelist
> or blacklist, the proposed API takes a cue from the x86 version and
> allows either allowing or denying counting of ranges of events.
> The event space being pretty large (16bits on ARMv8.1), the default
> policy is set by the first filter that gets installed (default deny if
> we first allow, default allow if we first deny).
> 
> The filter state is global to the guest, despite the PMU being per
> CPU. I'm not sure whether it would be worth it making it CPU-private.
> 
> Anyway, I'd be interesting in comments on how people would use this.
> I'll try to push a patch against kvmtool that implement this shortly
> (what I have currently is a harcoded set of hacks).

I now have a small extension to kvmtool allowing a --pmu-filter option
to be passed on the command line (see [1]).

I've also pushed out an update[2] to the kernel side of things, making
the filtering of the cycle counter consistent and documenting that
neither SW_INCR nor CHAIN could be filtered with this mechanism (but
this is of course up for discussion).

Thanks,

	M.

[1] https://git.kernel.org/pub/scm/linux/kernel/git/maz/kvmtool.git/commit/?h=pmu-filter
[2] https://git.kernel.org/pub/scm/linux/kernel/git/maz/arm-platforms.git/log/?h=kvm-arm64/pmu-event-filter

-- 
Jazz is not dead. It just smells funny...
