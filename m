Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24A041B4959
	for <lists+kvm@lfdr.de>; Wed, 22 Apr 2020 18:02:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726183AbgDVQCd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Apr 2020 12:02:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:60188 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726006AbgDVQCd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Apr 2020 12:02:33 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 931AC20774;
        Wed, 22 Apr 2020 16:02:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587571352;
        bh=c4mJd8byYus85ZsVq6dYD/xxB2BiJlruuIkokhIEKR8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Z+QMPPJzNk3+41X0OaGHcAW/KCZhzEDtlfz68Hfe63NKhA0eHmHvKOsKHRwfCgIhn
         gn/N+5nNLRqAEZp/A5UjMr1Og6z/8RGOdAETRurSvjNmLi7kluFG+OVW1K3eq2DMFC
         JRRCuddtCYva7c/zbgj10qJ6winkquJ56MFPFHLo=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
        by disco-boy.misterjones.org with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1jRHpW-005YSC-Rg; Wed, 22 Apr 2020 17:02:31 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Wed, 22 Apr 2020 17:02:30 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     James Morse <james.morse@arm.com>
Cc:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, Zenghui Yu <yuzenghui@huawei.com>,
        Eric Auger <eric.auger@redhat.com>,
        Andre Przywara <Andre.Przywara@arm.com>,
        Julien Grall <julien@xen.org>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: Re: [PATCH v2 4/6] KVM: arm: vgic-v2: Only use the virtual state when
 userspace accesses pending bits
In-Reply-To: <5aa2acf8-e775-325c-0340-fa000a4e3513@arm.com>
References: <20200417083319.3066217-1-maz@kernel.org>
 <20200417083319.3066217-5-maz@kernel.org>
 <4133d5f2-ed0e-9c4a-8a66-953fb6bf6e70@arm.com> <20200417134140.0a901749@why>
 <7b001ee4-0a8e-d79c-1be4-563dab4ca452@arm.com> <20200420110350.675a3393@why>
 <5aa2acf8-e775-325c-0340-fa000a4e3513@arm.com>
Message-ID: <299b5f1307cff29944e5f89e307b2015@kernel.org>
X-Sender: maz@kernel.org
User-Agent: Roundcube Webmail/1.3.10
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: james.morse@arm.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, yuzenghui@huawei.com, eric.auger@redhat.com, Andre.Przywara@arm.com, julien@xen.org, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi James,

On 2020-04-22 16:55, James Morse wrote:
> Hi Marc,
> 
> On 20/04/2020 11:03, Marc Zyngier wrote:
>> On Fri, 17 Apr 2020 17:48:34 +0100
>> James Morse <james.morse@arm.com> wrote:

[...]

>>> (but if user-space never actually does this, then we should do the 
>>> simplest thing)
> 
> Adding printk() to this combined patch and using 'loadvm' on the qemu
> console, I see Qemu
> writing '0xffffffff' into cpending to clear all 16 SGIs. I guess it is
> 'resetting' the
> in-kernel state to replace it with the state read from disk.
> 
> 
>> A third way would be to align on what GICv3 does, which is that 
>> ISPENDR
>> is used for both setting and clearing in one go. Given that the 
>> current
>> state it broken (and has been for some time now), I'm tempted to adopt
>> the same behaviour...
> 
>> What do you think?
> 
> I think Qemu is expecting the bank of cpending writes to clear
> whatever the kernel has
> stored, so that it can replay the new state. Ignoring the cpending
> writes means the kernel
> keeps an interrupt pending if nothing else in that 64bit group was
> set. Its not what Qemu
> expects, it looks like we'd get away with it, but I don't think we 
> should do it!
> 
> I think we should let user-space write to those WI registers, and
> clearing the SGIs should clear all sources of SGI...

I'd be happy with that. Let me rework the patch, and I'll post the 
series again
shortly.

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
