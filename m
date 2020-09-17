Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7931226D844
	for <lists+kvm@lfdr.de>; Thu, 17 Sep 2020 12:01:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726423AbgIQKBp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Sep 2020 06:01:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:58084 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726200AbgIQKBm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Sep 2020 06:01:42 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9FB0920770;
        Thu, 17 Sep 2020 10:01:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600336901;
        bh=Xh8JuZm4voE70hSUqrNM4+HG+MZSDD3QHPaZ/il5TMU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=00iQ1HYXyByzkyIHcCOwnOd7Y4T4D/gWgeu6tORKXzRsQL8BecLyON1RF02dWjRlW
         XKBwCoFYyOvKpLXHIIy2s3o45cOoZtniBqVp720vyGWPjfux1IZYruxVydUwVmsfFm
         jbp/u3Qb+ht/jQH7T9+42RvAWop6JnjL534R2HMo=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
        by disco-boy.misterjones.org with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1kIqjT-00Cb1I-M3; Thu, 17 Sep 2020 11:01:39 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Date:   Thu, 17 Sep 2020 11:01:39 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     Andrew Jones <drjones@redhat.com>,
        Ying Fang <fangying1@huawei.com>, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, james.morse@arm.com,
        julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com,
        zhang.zhanghailiang@huawei.com, alex.chen@huawei.com
Subject: Re: [PATCH 2/2] kvm/arm: Add mp_affinity for arm vcpu
In-Reply-To: <12a47a99-9857-b86d-6c45-39fdee08613e@arm.com>
References: <20200917023033.1337-1-fangying1@huawei.com>
 <20200917023033.1337-3-fangying1@huawei.com>
 <7a924b0fb27505a0d8b00389fe2f02df@kernel.org>
 <20200917080429.jimidzdtdskwhbdx@kamzik.brq.redhat.com>
 <198c63d5e9e17ddb4c3848845891301c@kernel.org>
 <12a47a99-9857-b86d-6c45-39fdee08613e@arm.com>
User-Agent: Roundcube Webmail/1.4.8
Message-ID: <b88c7988a00c25a9ae0fdd373ba45227@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: alexandru.elisei@arm.com, drjones@redhat.com, fangying1@huawei.com, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, zhang.zhanghailiang@huawei.com, alex.chen@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2020-09-17 10:47, Alexandru Elisei wrote:
> Hi,
> 
> On 9/17/20 9:42 AM, Marc Zyngier wrote:
>> On 2020-09-17 09:04, Andrew Jones wrote:
>>> On Thu, Sep 17, 2020 at 08:47:42AM +0100, Marc Zyngier wrote:
>>>> On 2020-09-17 03:30, Ying Fang wrote:
>>>> > Allow userspace to set MPIDR using vcpu ioctl KVM_ARM_SET_MP_AFFINITY,
>>>> > so that we can support cpu topology for arm.
>>>> 
>>>> MPIDR has *nothing* to do with CPU topology in the ARM architecture.
>>>> I encourage you to have a look at the ARM ARM and find out how often
>>>> the word "topology" is used in conjunction with the MPIDR_EL1 
>>>> register.
>>>> 
>>> 
>>> Hi Marc,
>>> 
>>> I mostly agree. However, the CPU topology descriptions use MPIDR to
>>> identify PEs. If userspace wants to build topology descriptions then
>>> it either needs to
>>> 
>>> 1) build them after instantiating all KVM VCPUs in order to query KVM
>>>    for each MPIDR, or
>>> 2) have a way to ask KVM for an MPIDR of given VCPU ID in advance
>>>    (maybe just a scratch VCPU), or
>>> 3) have control over the MPIDRs so it can choose them when it likes,
>>>    use them for topology descriptions, and then instantiate KVM VCPUs
>>>    with them.
>>> 
>>> I think (3) is the most robust approach, and it has the least 
>>> overhead.
>> 
>> I don't disagree with the goal, and not even with the choice of
>> implementation (though I have huge reservations about its quality).
>> 
>> But the key word here is *userspace*. Only userspace has a notion of
>> how MPIDR values map to the assumed topology. That's not something
>> that KVM does nor should interpret (aside from the GIC-induced Aff0
>> brain-damage). So talking of "topology" in a KVM kernel patch sends
>> the wrong message, and that's all this remark was about.
> 
> There's also a patch queued for next which removes using MPIDR as a 
> source of
> information about CPU topology [1]: "arm64: topology: Stop using MPIDR 
> for
> topology information".
> 
> I'm not really sure how useful KVM fiddling with the guest MPIDR will 
> be going
> forward, at least for a Linux guest.

I think these are two orthogonal things. There is value in setting MPIDR
to something different as a way to replicate an existing system, for
example. But deriving *any* sort of topology information from MPIDR 
isn't
reliable at all, and is better expressed by firmware tables (and even
that isn't great).

As far as I am concerned, this patch fits in the "cosmetic" department.
It's a "nice to have", but doesn't really solve much. Firmware tables
and userspace placement of the vcpus are key.

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
