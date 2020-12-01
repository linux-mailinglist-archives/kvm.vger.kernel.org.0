Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30CA82CA0BB
	for <lists+kvm@lfdr.de>; Tue,  1 Dec 2020 12:01:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730397AbgLAK7l (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Dec 2020 05:59:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:47504 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730234AbgLAK7k (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Dec 2020 05:59:40 -0500
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6AC6C20809;
        Tue,  1 Dec 2020 10:58:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606820339;
        bh=fjeXvv1+eOJ5uqv6M23051ubV3+oKlwmWBbroYxu4fw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Hh/ScutavvVCdCl58vcCojICg7CUUG5ERNrak0LxRYScrExjctS6PH40T0x1BYSkQ
         o0GVgS1ppX077mlPbIml6Z4xF2DkBGekEKRDTslWE0H8Vxa/nLK4wxF/oIEoyg+cHe
         z74rNevxrT0YthG8Hguh1Bjx2nwzVQpxpD8Pu6+A=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94)
        (envelope-from <maz@kernel.org>)
        id 1kk3N1-00F13G-9R; Tue, 01 Dec 2020 10:58:55 +0000
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Date:   Tue, 01 Dec 2020 10:58:54 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     luojiaxing <luojiaxing@huawei.com>
Cc:     Shenming Lu <lushenming@huawei.com>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Eric Auger <eric.auger@redhat.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Christoffer Dall <christoffer.dall@arm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Cornelia Huck <cohuck@redhat.com>, Neo Jia <cjia@nvidia.com>,
        wanghaibin.wang@huawei.com, yuzenghui@huawei.com
Subject: Re: [RFC PATCH v1 1/4] irqchip/gic-v4.1: Plumb get_irqchip_state VLPI
 callback
In-Reply-To: <316fe41d-f004-f004-4f31-6fe6e7ff64b7@huawei.com>
References: <20201123065410.1915-1-lushenming@huawei.com>
 <20201123065410.1915-2-lushenming@huawei.com>
 <869dbc36-c510-fd00-407a-b05e068537c8@huawei.com>
 <875z5p6ayp.wl-maz@kernel.org>
 <316fe41d-f004-f004-4f31-6fe6e7ff64b7@huawei.com>
User-Agent: Roundcube Webmail/1.4.9
Message-ID: <7f578fa825b946f74e9ebdee557d6804@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: luojiaxing@huawei.com, lushenming@huawei.com, james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, eric.auger@redhat.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, christoffer.dall@arm.com, alex.williamson@redhat.com, kwankhede@nvidia.com, cohuck@redhat.com, cjia@nvidia.com, wanghaibin.wang@huawei.com, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2020-12-01 09:38, luojiaxing wrote:
> On 2020/11/28 18:18, Marc Zyngier wrote:
>> On Sat, 28 Nov 2020 07:19:48 +0000,
>> luojiaxing <luojiaxing@huawei.com> wrote:

>>> How can you confirm that the interrupt pending status is the latest?
>>> Is it possible that the interrupt pending status is still cached in
>>> the GICR but not synchronized to the memory.
>> That's a consequence of the vPE having been unmapped:
>> 
>> "A VMAPP with {V,Alloc}=={0,1} cleans and invalidates any caching of
>> the Virtual Pending Table and Virtual Configuration Table associated
>> with the vPEID held in the GIC."
> 
> 
> Yes, in addition to that, if a vPE is scheduled out of the PE, the
> cache clearing and write-back to VPT are also performed, I think.

There is no such architectural requirement.

> However, I feel a litter confusing to read this comment at first , 
> because it is not only VMAPP that causes cache clearing.

I can't see anything else that guarantee that the caches are clean,
and that there is no possible write to the PE table.

> I don't know why VMAPP was mentioned here until I check the other two
> patches ("KVM: arm64: GICv4.1: Try to save hw pending state in
> save_pending_tables").
> 
> So I think may be it's better to add some background description here.

Well, relying on the standard irqchip state methods to peek at the
pending state isn't very reliable, as you could be temped to call into
this even when the VPE is mapped. Which is why I've suggested
a different implementation.

         M.
-- 
Jazz is not dead. It just smells funny...
