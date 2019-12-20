Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 47E3C1281B7
	for <lists+kvm@lfdr.de>; Fri, 20 Dec 2019 18:55:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727473AbfLTRz3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Dec 2019 12:55:29 -0500
Received: from foss.arm.com ([217.140.110.172]:53762 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727421AbfLTRz2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Dec 2019 12:55:28 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 619A01FB;
        Fri, 20 Dec 2019 09:55:28 -0800 (PST)
Received: from lakrids.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 2D2C13F67D;
        Fri, 20 Dec 2019 09:55:27 -0800 (PST)
Date:   Fri, 20 Dec 2019 17:55:25 +0000
From:   Mark Rutland <mark.rutland@arm.com>
To:     Andrew Murray <andrew.murray@arm.com>
Cc:     Marc Zyngier <marc.zyngier@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Sudeep Holla <sudeep.holla@arm.com>,
        kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 00/18] arm64: KVM: add SPE profiling support
Message-ID: <20191220175524.GC25258@lakrids.cambridge.arm.com>
References: <20191220143025.33853-1-andrew.murray@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191220143025.33853-1-andrew.murray@arm.com>
User-Agent: Mutt/1.11.1+11 (2f07cb52) (2018-12-01)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Andrew,

On Fri, Dec 20, 2019 at 02:30:07PM +0000, Andrew Murray wrote:
> This series implements support for allowing KVM guests to use the Arm
> Statistical Profiling Extension (SPE).
> 
> It has been tested on a model to ensure that both host and guest can
> simultaneously use SPE with valid data. E.g.
> 
> $ perf record -e arm_spe/ts_enable=1,pa_enable=1,pct_enable=1/ \
>         dd if=/dev/zero of=/dev/null count=1000
> $ perf report --dump-raw-trace > spe_buf.txt

What happens if I run perf record on the VMM, or on the CPU(s) that the
VMM is running on? i.e.

$ perf record -e arm_spe/ts_enable=1,pa_enable=1,pct_enable=1/ \
        lkvm ${OPTIONS_FOR_GUEST_USING_SPE}

... or:

$ perf record -a -c 0 -e arm_spe/ts_enable=1,pa_enable=1,pct_enable=1/ \
        sleep 1000 &
$ taskset -c 0 lkvm ${OPTIONS_FOR_GUEST_USING_SPE} &

> As we save and restore the SPE context, the guest can access the SPE
> registers directly, thus in this version of the series we remove the
> trapping and emulation.
> 
> In the previous series of this support, when KVM SPE isn't supported
> (e.g. via CONFIG_KVM_ARM_SPE) we were able to return a value of 0 to
> all reads of the SPE registers - as we can no longer do this there isn't
> a mechanism to prevent the guest from using SPE - thus I'm keen for
> feedback on the best way of resolving this.

When not providing SPE to the guest, surely we should be trapping the
registers and injecting an UNDEF?

What happens today, without these patches?

> It appears necessary to pin the entire guest memory in order to provide
> guest SPE access - otherwise it is possible for the guest to receive
> Stage-2 faults.

AFAICT these patches do not implement this. I assume that's what you're
trying to point out here, but I just want to make sure that's explicit.

Maybe this is a reason to trap+emulate if there's something more
sensible that hyp can do if it sees a Stage-2 fault.

Thanks,
Mark.
