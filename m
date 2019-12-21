Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 44CF21288B1
	for <lists+kvm@lfdr.de>; Sat, 21 Dec 2019 11:48:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726339AbfLUKsT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 21 Dec 2019 05:48:19 -0500
Received: from inca-roads.misterjones.org ([213.251.177.50]:38416 "EHLO
        inca-roads.misterjones.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726144AbfLUKsT (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sat, 21 Dec 2019 05:48:19 -0500
Received: from www-data by cheepnis.misterjones.org with local (Exim 4.80)
        (envelope-from <maz@kernel.org>)
        id 1iicIy-00080I-IP; Sat, 21 Dec 2019 11:48:16 +0100
To:     Andrew Murray <andrew.murray@arm.com>
Subject: Re: [PATCH v2 00/18] arm64: KVM: add SPE profiling support
X-PHP-Originating-Script: 0:main.inc
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Sat, 21 Dec 2019 10:48:16 +0000
From:   Marc Zyngier <maz@kernel.org>
Cc:     Catalin Marinas <catalin.marinas@arm.com>,
        Mark Rutland <mark.rutland@arm.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Sudeep Holla <sudeep.holla@arm.com>,
        <kvmarm@lists.cs.columbia.edu>,
        <linux-arm-kernel@lists.infradead.org>, <will@kernel.org>
In-Reply-To: <20191220143025.33853-1-andrew.murray@arm.com>
References: <20191220143025.33853-1-andrew.murray@arm.com>
Message-ID: <f023f5529361cc1e2d799daa70f196c2@www.loen.fr>
X-Sender: maz@kernel.org
User-Agent: Roundcube Webmail/0.7.2
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Rcpt-To: andrew.murray@arm.com, catalin.marinas@arm.com, mark.rutland@arm.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, sudeep.holla@arm.com, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, will@kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on cheepnis.misterjones.org); SAEximRunCond expanded to false
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

[fixing email addresses]

Hi Andrew,

On 2019-12-20 14:30, Andrew Murray wrote:
> This series implements support for allowing KVM guests to use the Arm
> Statistical Profiling Extension (SPE).

Thanks for this. In future, please Cc me and Will on email addresses
we can actually read.

> It has been tested on a model to ensure that both host and guest can
> simultaneously use SPE with valid data. E.g.
>
> $ perf record -e arm_spe/ts_enable=1,pa_enable=1,pct_enable=1/ \
>         dd if=/dev/zero of=/dev/null count=1000
> $ perf report --dump-raw-trace > spe_buf.txt
>
> As we save and restore the SPE context, the guest can access the SPE
> registers directly, thus in this version of the series we remove the
> trapping and emulation.
>
> In the previous series of this support, when KVM SPE isn't supported
> (e.g. via CONFIG_KVM_ARM_SPE) we were able to return a value of 0 to
> all reads of the SPE registers - as we can no longer do this there 
> isn't
> a mechanism to prevent the guest from using SPE - thus I'm keen for
> feedback on the best way of resolving this.

Surely there is a way to conditionally trap SPE registers, right? You
should still be able to do this if SPE is not configured for a given
guest (as we do for other feature such as PtrAuth).

> It appears necessary to pin the entire guest memory in order to 
> provide
> guest SPE access - otherwise it is possible for the guest to receive
> Stage-2 faults.

Really? How can the guest receive a stage-2 fault? This doesn't fit 
what
I understand of the ARMv8 exception model. Or do you mean a SPE 
interrupt
describing a S2 fault?

And this is not just pinning the memory either. You have to ensure that
all S2 page tables are created ahead of SPE being able to DMA to guest
memory. This may have some impacts on the THP code...

I'll have a look at the actual series ASAP (but that's not very soon).

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
