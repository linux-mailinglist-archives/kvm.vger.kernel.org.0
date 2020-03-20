Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 464D218C996
	for <lists+kvm@lfdr.de>; Fri, 20 Mar 2020 10:09:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726838AbgCTJJh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Mar 2020 05:09:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:34352 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726527AbgCTJJh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Mar 2020 05:09:37 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E871A20752;
        Fri, 20 Mar 2020 09:09:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584695377;
        bh=lKTpTlYWFEgvmkW6XkcldhhG5+woVU4cLcAGikERfqo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=wqxswQOYA6BABIMXoM2nOSVgWJ47cTHAzkq5NO+OYTws4zesQC/Bq4/lMrY5xYdT3
         LLMxbcIFzNwWU+tjzVGlaWY8W7/DyefzA7Y7u6Z+ryCAs80UEFGKtPql/c5ERxj9ZT
         Yf7rVSM+Zww6zuKaVgksoCp+gttl1NC23l6B3Fpc=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
        by disco-boy.misterjones.org with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1jFDep-00EBy9-8B; Fri, 20 Mar 2020 09:09:35 +0000
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Fri, 20 Mar 2020 09:09:35 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     Zenghui Yu <yuzenghui@huawei.com>
Cc:     Auger Eric <eric.auger@redhat.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Jason Cooper <jason@lakedaemon.net>,
        Robert Richter <rrichter@marvell.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: Re: [PATCH v5 23/23] KVM: arm64: GICv4.1: Expose HW-based SGIs in
 debugfs
In-Reply-To: <e1a1e537-9f8e-5cfb-0132-f796e8bf06c9@huawei.com>
References: <20200304203330.4967-1-maz@kernel.org>
 <20200304203330.4967-24-maz@kernel.org>
 <4cb4c3d4-7b02-bb77-cd7a-c185346b6a2f@redhat.com>
 <45c282bddd43420024633943c1befac3@kernel.org>
 <e1a1e537-9f8e-5cfb-0132-f796e8bf06c9@huawei.com>
Message-ID: <b63950513f519d9a04f9719f5aa6a2db@kernel.org>
X-Sender: maz@kernel.org
User-Agent: Roundcube Webmail/1.3.10
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: yuzenghui@huawei.com, eric.auger@redhat.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, lorenzo.pieralisi@arm.com, jason@lakedaemon.net, rrichter@marvell.com, tglx@linutronix.de, james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Zenghui,

On 2020-03-20 04:38, Zenghui Yu wrote:
> Hi Marc,
> 
> On 2020/3/19 23:21, Marc Zyngier wrote:
>> With GICv4.1, you can introspect the HW state for SGIs. You can also
>> look at the vLPI state by peeking at the virtual pending table, but
>> you'd need to unmap the VPE first,
> 
> Out of curiosity, could you please point me to the "unmap the VPE"
> requirement in the v4.1 spec? I'd like to have a look.

Sure. See IHI0069F, 5.3.19 (VMAPP GICv4.1), "Caching of virtual LPI data
structures", and the bit that says:

"A VMAPP with {V,Alloc}=={0,1} cleans and invalidates any caching of the
Virtual Pending Table and Virtual Configuration Table associated with 
the
vPEID held in the GIC"

which is what was crucially missing from the GICv4.0 spec (it doesn't 
say
when the GIC is done writing to memory).

Side note: it'd be good to know what the rules are for your own GICv4
implementations, so that we can at least make sure the current code is 
safe.

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
