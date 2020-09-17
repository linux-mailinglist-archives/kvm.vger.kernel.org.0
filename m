Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E5DC26D9A9
	for <lists+kvm@lfdr.de>; Thu, 17 Sep 2020 12:55:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726734AbgIQKyR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Sep 2020 06:54:17 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:27917 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726744AbgIQKyC (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 17 Sep 2020 06:54:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600340033;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=S8C7t3NQHq9z3BC6UetbrQdCqNK9g2Cj1ZoGxibjTb0=;
        b=MGufK8BbyTgAi4fdThDoSYNCmAfPV3bILAiknaux4saEwhERDubYiUWGm7DToorxI0vun2
        tdyGW3+zfu2ucvRNh9FsXvwhMk0g+q8+fIkqgDwSzEcKCCjh01rHgLcjiPua89c56cSfOR
        M2xXrvbF2B+IcPodPVpe7kgDwsrSsEo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-589-iHKfzHgYMma8RN14nP1alA-1; Thu, 17 Sep 2020 06:53:50 -0400
X-MC-Unique: iHKfzHgYMma8RN14nP1alA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BFC4518BE168;
        Thu, 17 Sep 2020 10:53:48 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.192.179])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id DBD5F1002D62;
        Thu, 17 Sep 2020 10:53:45 +0000 (UTC)
Date:   Thu, 17 Sep 2020 12:53:43 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     Alexandru Elisei <alexandru.elisei@arm.com>,
        Ying Fang <fangying1@huawei.com>, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, james.morse@arm.com,
        julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com,
        zhang.zhanghailiang@huawei.com, alex.chen@huawei.com
Subject: Re: [PATCH 2/2] kvm/arm: Add mp_affinity for arm vcpu
Message-ID: <20200917105343.de6z7ajccnx3zrld@kamzik.brq.redhat.com>
References: <20200917023033.1337-1-fangying1@huawei.com>
 <20200917023033.1337-3-fangying1@huawei.com>
 <7a924b0fb27505a0d8b00389fe2f02df@kernel.org>
 <20200917080429.jimidzdtdskwhbdx@kamzik.brq.redhat.com>
 <198c63d5e9e17ddb4c3848845891301c@kernel.org>
 <12a47a99-9857-b86d-6c45-39fdee08613e@arm.com>
 <b88c7988a00c25a9ae0fdd373ba45227@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <b88c7988a00c25a9ae0fdd373ba45227@kernel.org>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 17, 2020 at 11:01:39AM +0100, Marc Zyngier wrote:
> On 2020-09-17 10:47, Alexandru Elisei wrote:
> > Hi,
> > 
> > On 9/17/20 9:42 AM, Marc Zyngier wrote:
> > > On 2020-09-17 09:04, Andrew Jones wrote:
> > > > On Thu, Sep 17, 2020 at 08:47:42AM +0100, Marc Zyngier wrote:
> > > > > On 2020-09-17 03:30, Ying Fang wrote:
> > > > > > Allow userspace to set MPIDR using vcpu ioctl KVM_ARM_SET_MP_AFFINITY,
> > > > > > so that we can support cpu topology for arm.
> > > > > 
> > > > > MPIDR has *nothing* to do with CPU topology in the ARM architecture.
> > > > > I encourage you to have a look at the ARM ARM and find out how often
> > > > > the word "topology" is used in conjunction with the
> > > > > MPIDR_EL1 register.
> > > > > 
> > > > 
> > > > Hi Marc,
> > > > 
> > > > I mostly agree. However, the CPU topology descriptions use MPIDR to
> > > > identify PEs. If userspace wants to build topology descriptions then
> > > > it either needs to
> > > > 
> > > > 1) build them after instantiating all KVM VCPUs in order to query KVM
> > > >    for each MPIDR, or
> > > > 2) have a way to ask KVM for an MPIDR of given VCPU ID in advance
> > > >    (maybe just a scratch VCPU), or
> > > > 3) have control over the MPIDRs so it can choose them when it likes,
> > > >    use them for topology descriptions, and then instantiate KVM VCPUs
> > > >    with them.
> > > > 
> > > > I think (3) is the most robust approach, and it has the least
> > > > overhead.
> > > 
> > > I don't disagree with the goal, and not even with the choice of
> > > implementation (though I have huge reservations about its quality).
> > > 
> > > But the key word here is *userspace*. Only userspace has a notion of
> > > how MPIDR values map to the assumed topology. That's not something
> > > that KVM does nor should interpret (aside from the GIC-induced Aff0
> > > brain-damage). So talking of "topology" in a KVM kernel patch sends
> > > the wrong message, and that's all this remark was about.
> > 
> > There's also a patch queued for next which removes using MPIDR as a
> > source of
> > information about CPU topology [1]: "arm64: topology: Stop using MPIDR
> > for
> > topology information".
> > 
> > I'm not really sure how useful KVM fiddling with the guest MPIDR will be
> > going
> > forward, at least for a Linux guest.
> 
> I think these are two orthogonal things. There is value in setting MPIDR
> to something different as a way to replicate an existing system, for
> example. But deriving *any* sort of topology information from MPIDR isn't
> reliable at all, and is better expressed by firmware tables (and even
> that isn't great).
> 

Yes, this is my opinion as well and I'm glad to see the patch that
Alexandru pointed out, since it should stop the MPIDR abuse. Ying Fang
has also posted a QEMU series that populates DT and ACPI[*] to describe
CPU topology to the guest. The user controlled MPIDR is being proposed
in order to support that series.

[*] https://lists.gnu.org/archive/html/qemu-devel/2020-09/msg06027.html

Thanks,
drew

> As far as I am concerned, this patch fits in the "cosmetic" department.
> It's a "nice to have", but doesn't really solve much. Firmware tables
> and userspace placement of the vcpus are key.
> 
> Thanks,
> 
>         M.
> -- 
> Jazz is not dead. It just smells funny...
> 

