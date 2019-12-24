Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DA39D12A1D5
	for <lists+kvm@lfdr.de>; Tue, 24 Dec 2019 14:46:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726184AbfLXNqR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Dec 2019 08:46:17 -0500
Received: from inca-roads.misterjones.org ([213.251.177.50]:34561 "EHLO
        inca-roads.misterjones.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726124AbfLXNqR (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 24 Dec 2019 08:46:17 -0500
Received: from www-data by cheepnis.misterjones.org with local (Exim 4.80)
        (envelope-from <maz@kernel.org>)
        id 1ijkVo-0003p4-RU; Tue, 24 Dec 2019 14:46:12 +0100
To:     Andrew Murray <andrew.murray@arm.com>
Subject: Re: [PATCH v2 14/18] KVM: arm64: spe: Provide guest virtual  interrupts for SPE
X-PHP-Originating-Script: 0:main.inc
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Tue, 24 Dec 2019 13:46:12 +0000
From:   Marc Zyngier <maz@kernel.org>
Cc:     Marc Zyngier <marc.zyngier@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Sudeep Holla <sudeep.holla@arm.com>,
        <kvmarm@lists.cs.columbia.edu>,
        <linux-arm-kernel@lists.infradead.org>
In-Reply-To: <20191224133647.GO42593@e119886-lin.cambridge.arm.com>
References: <20191220143025.33853-1-andrew.murray@arm.com>
 <20191220143025.33853-15-andrew.murray@arm.com>
 <867e2oimw9.wl-maz@kernel.org>
 <20191224115031.GG42593@e119886-lin.cambridge.arm.com>
 <1f3fbff6c9db0f14c92a6e3fb800fa0f@www.loen.fr>
 <20191224130853.GN42593@e119886-lin.cambridge.arm.com>
 <a2b8846377b3f5884feeb9728b16f826@www.loen.fr>
 <20191224133647.GO42593@e119886-lin.cambridge.arm.com>
Message-ID: <ddd39371e1aa95747d42efdb55f73b51@www.loen.fr>
X-Sender: maz@kernel.org
User-Agent: Roundcube Webmail/0.7.2
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Rcpt-To: andrew.murray@arm.com, marc.zyngier@arm.com, catalin.marinas@arm.com, will.deacon@arm.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, sudeep.holla@arm.com, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on cheepnis.misterjones.org); SAEximRunCond expanded to false
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2019-12-24 13:36, Andrew Murray wrote:
> On Tue, Dec 24, 2019 at 01:22:46PM +0000, Marc Zyngier wrote:
>> On 2019-12-24 13:08, Andrew Murray wrote:

[...]

>> > This does feel like the pragmatic approach - a larger black hole 
>> in
>> > exchange
>> > for performance. I imagine the blackhole would be naturally 
>> reduced on
>> > machines with high workloads.
>>
>> Why? I don't see the relation between how busy the vcpu is and the 
>> size
>> of the blackhole. It is strictly a function of the frequency of 
>> exits.
>
> Indeed, my assumption being that the busier a system is the more
> interrupts, thus leading to more exits and so an increased frequency 
> of
> SPE interrupt evaluation and thus smaller black hole.

On a GICv4-enabled system, this isn't true anymore. My bet is that
people won't use SPE to optimize IO-oriented workloads, but more CPU
intensive workloads (that don't necessarily exit at all).

But never mind. Let's start with this approach, as it is simple and 
easy
to verify. If the black hole aspect becomes problematic, we know how
to reduce it (at the expense of entry/exit performance).

         M.
-- 
Jazz is not dead. It just smells funny...
