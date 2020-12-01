Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47EC12CA08E
	for <lists+kvm@lfdr.de>; Tue,  1 Dec 2020 11:56:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730267AbgLAK4E (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Dec 2020 05:56:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:45812 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727356AbgLAK4E (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Dec 2020 05:56:04 -0500
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 476C520674;
        Tue,  1 Dec 2020 10:55:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606820123;
        bh=mA7gSISgii7mt8Pbmo+IU3yz1WqfVYYfTdx2GpQD6x8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=AmY/k2C0BgWr90iEzC9dOhMlvwuJyMxSKKvOTs1VvUrlAy5FcRM74f+6m7iye6s8a
         u7JH4S6EvxiyWFuZkHq3RXNdWQTqVTWjxFF15jlID19MkKnRDKMAwTsSFIhf/U7VWh
         zBGPix+9TnT884jIlOBG/koTtAr2TwI+lCAD5Zao=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94)
        (envelope-from <maz@kernel.org>)
        id 1kk3JZ-00F0yi-0p; Tue, 01 Dec 2020 10:55:21 +0000
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Tue, 01 Dec 2020 10:55:20 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     Shenming Lu <lushenming@huawei.com>
Cc:     James Morse <james.morse@arm.com>,
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
Subject: Re: [RFC PATCH v1 3/4] KVM: arm64: GICv4.1: Restore VLPI's pending
 state to physical side
In-Reply-To: <48c10467-30f3-9b5c-bbcb-533a51516dc5@huawei.com>
References: <20201123065410.1915-1-lushenming@huawei.com>
 <20201123065410.1915-4-lushenming@huawei.com>
 <5c724bb83730cdd5dcf7add9a812fa92@kernel.org>
 <b03edcf2-2950-572f-fd31-601d8d766c80@huawei.com>
 <2d2bcae4f871d239a1af50362f5c11a4@kernel.org>
 <49610291-cf57-ff78-d0ac-063af24efbb4@huawei.com>
 <48c10467-30f3-9b5c-bbcb-533a51516dc5@huawei.com>
User-Agent: Roundcube Webmail/1.4.9
Message-ID: <2ad38077300bdcaedd2e3b073cd36743@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: lushenming@huawei.com, james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, eric.auger@redhat.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, christoffer.dall@arm.com, alex.williamson@redhat.com, kwankhede@nvidia.com, cohuck@redhat.com, cjia@nvidia.com, wanghaibin.wang@huawei.com, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2020-11-30 07:23, Shenming Lu wrote:

Hi Shenming,

> We are pondering over this problem these days, but still don't get a
> good solution...
> Could you give us some advice on this?
> 
> Or could we move the restoring of the pending states (include the sync
> from guest RAM and the transfer to HW) to the GIC VM state change 
> handler,
> which is completely corresponding to save_pending_tables (more 
> symmetric?)
> and don't expose GICv4...

What is "the GIC VM state change handler"? Is that a QEMU thing?
We don't really have that concept in KVM, so I'd appreciate if you could
be a bit more explicit on this.

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
