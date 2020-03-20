Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D5ACF18C968
	for <lists+kvm@lfdr.de>; Fri, 20 Mar 2020 10:01:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726897AbgCTJBp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Mar 2020 05:01:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:59310 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726690AbgCTJBo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Mar 2020 05:01:44 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1E46520752;
        Fri, 20 Mar 2020 09:01:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584694903;
        bh=5GzmaNdbQWq4mwgMPIV3aDUnqAewqh/ptfOGOHCK+xw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=jYCIgVPLeSi75fxMO5TZ8B5x9GAI/akoG5C2R9NKp2C++xG9c/7L59CgHOC3bQ/KK
         kxFbkaBZ/58TE5YR3tosXwXXhILQr5LeIR5nykEBB/cPR+MxWI5ff+pta1Dvp7u55A
         a0/KdFglc2/CRpBetrGMRzDIrczZ3ze842l/MkGE=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
        by disco-boy.misterjones.org with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1jFDXA-00EBob-Vl; Fri, 20 Mar 2020 09:01:41 +0000
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Date:   Fri, 20 Mar 2020 09:01:40 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     Zenghui Yu <yuzenghui@huawei.com>
Cc:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Jason Cooper <jason@lakedaemon.net>,
        Robert Richter <rrichter@marvell.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Eric Auger <eric.auger@redhat.com>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: Re: [PATCH v5 20/23] KVM: arm64: GICv4.1: Plumb SGI implementation
 selection in the distributor
In-Reply-To: <1c9fdfc8-bdb2-88b6-4bdc-2b9254dfa55c@huawei.com>
References: <20200304203330.4967-1-maz@kernel.org>
 <20200304203330.4967-21-maz@kernel.org>
 <72832f51-bbde-8502-3e03-189ac20a0143@huawei.com>
 <4a06fae9c93e10351276d173747d17f4@kernel.org>
 <1c9fdfc8-bdb2-88b6-4bdc-2b9254dfa55c@huawei.com>
Message-ID: <256b58a9679412c96600217f316f424f@kernel.org>
X-Sender: maz@kernel.org
User-Agent: Roundcube Webmail/1.3.10
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: yuzenghui@huawei.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, lorenzo.pieralisi@arm.com, jason@lakedaemon.net, rrichter@marvell.com, tglx@linutronix.de, eric.auger@redhat.com, james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Zenghui,

On 2020-03-20 03:53, Zenghui Yu wrote:
> Hi Marc,
> 
> On 2020/3/19 20:10, Marc Zyngier wrote:
>>> But I wonder that should we use nassgireq to *only* keep track what
>>> the guest had written into the GICD_CTLR.nASSGIreq.  If not, we may
>>> lose the guest-request bit after migration among hosts with different
>>> has_gicv4_1 settings.
>> 
>> I'm unsure of what you're suggesting here. If userspace tries to set
>> GICD_CTLR.nASSGIreq on a non-4.1 host, this bit will not latch.
> 
> This is exactly what I *was* concerning about.
> 
>> Userspace can check that at restore time. Or we could fail the
>> userspace write, which is a bit odd (the bit is otherwise RES0).
>> 
>> Could you clarify your proposal?
> 
> Let's assume two hosts below. 'has_gicv4_1' is true on host-A while
> it is false on host-B because of lack of HW support or the kernel
> parameter "kvm-arm.vgic_v4_enable=0".
> 
> If we migrate guest through A->B->A, we may end-up lose the initial
> guest-request "nASSGIreq=1" and don't use direct vSGI delivery for
> this guest when it's migrated back to host-A.

My point above is that we shouldn't allow the A->B migration the first
place, and fail it as quickly as possible. We don't know what the guest
has observed in terms of GIC capability, and it may not have enabled the
new flavour of SGIs just yet.

> This can be "fixed" by keep track of what guest had written into
> nASSGIreq. And we need to evaluate the need for using direct vSGI
> for a specified guest by 'has_gicv4_1 && nassgireq'.

It feels odd. It means we have more state than the HW normally has.
I have an alternative proposal, see below.

> But if it's expected that "if userspace tries to set nASSGIreq on
> a non-4.1 host, this bit will not latch", then this shouldn't be
> a problem at all.

Well, that is the semantics of the RES0 bit. It applies from both
guest and userspace.

And actually, maybe we can handle that pretty cheaply. If userspace
tries to restore GICD_TYPER2 to a value that isn't what KVM can
offer, we just return an error. Exactly like we do for GICD_IIDR.
Hence the following patch:

diff --git a/virt/kvm/arm/vgic/vgic-mmio-v3.c 
b/virt/kvm/arm/vgic/vgic-mmio-v3.c
index 28b639fd1abc..e72dcc454247 100644
--- a/virt/kvm/arm/vgic/vgic-mmio-v3.c
+++ b/virt/kvm/arm/vgic/vgic-mmio-v3.c
@@ -156,6 +156,7 @@ static int vgic_mmio_uaccess_write_v3_misc(struct 
kvm_vcpu *vcpu,
  	struct vgic_dist *dist = &vcpu->kvm->arch.vgic;

  	switch (addr & 0x0c) {
+	case GICD_TYPER2:
  	case GICD_IIDR:
  		if (val != vgic_mmio_read_v3_misc(vcpu, addr, len))
  			return -EINVAL;

Being a RO register, writing something that isn't compatible with the
possible behaviour of the hypervisor will just return an error.

What do you think?

> Anyway this is not a big deal to me and I won't complain about it
> in the future ;-) Either way, for this patch:
> 
> Reviewed-by: Zenghui Yu <yuzenghui@huawei.com>

Thanks a lot!

         M.
-- 
Jazz is not dead. It just smells funny...
