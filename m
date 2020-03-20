Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 13E7D18CD2D
	for <lists+kvm@lfdr.de>; Fri, 20 Mar 2020 12:46:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726986AbgCTLqE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Mar 2020 07:46:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:36950 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726806AbgCTLqD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Mar 2020 07:46:03 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F34B020732;
        Fri, 20 Mar 2020 11:46:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584704763;
        bh=HrKySj1MBtd+8/lD1DXHRMSp6ON+5Q7xA/4ZRnHjIP4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=was0UZ+X/2igmR+WLyQUlzJnfUkPZw0ttsPQgxhqOdbeUnSRpsDmMcwxqwh0A6noU
         PAUPGPqhb5vYy9BHfiAukTMzgXuu/42Y/3XYzO5tzzRDAtE9XCTDSjfnAhy45JEhbU
         V8QzeclgcQdDGMBgm8S/45DR7DI+C3925Xs2e5Nc=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
        by disco-boy.misterjones.org with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1jFG6D-00EEOQ-9X; Fri, 20 Mar 2020 11:46:01 +0000
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Fri, 20 Mar 2020 11:46:01 +0000
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
In-Reply-To: <8d7fdb7f-7a21-da22-52a2-51ee8ac9393f@huawei.com>
References: <20200304203330.4967-1-maz@kernel.org>
 <20200304203330.4967-24-maz@kernel.org>
 <4cb4c3d4-7b02-bb77-cd7a-c185346b6a2f@redhat.com>
 <45c282bddd43420024633943c1befac3@kernel.org>
 <e1a1e537-9f8e-5cfb-0132-f796e8bf06c9@huawei.com>
 <b63950513f519d9a04f9719f5aa6a2db@kernel.org>
 <8d7fdb7f-7a21-da22-52a2-51ee8ac9393f@huawei.com>
Message-ID: <40cbdf23c0f8bfc229400c14899ecbe0@kernel.org>
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

On 2020-03-20 11:35, Zenghui Yu wrote:
> Hi Marc,
> 
> On 2020/3/20 17:09, Marc Zyngier wrote:
>> Hi Zenghui,
>> 
>> On 2020-03-20 04:38, Zenghui Yu wrote:
>>> Hi Marc,
>>> 
>>> On 2020/3/19 23:21, Marc Zyngier wrote:
>>>> With GICv4.1, you can introspect the HW state for SGIs. You can also
>>>> look at the vLPI state by peeking at the virtual pending table, but
>>>> you'd need to unmap the VPE first,
>>> 
>>> Out of curiosity, could you please point me to the "unmap the VPE"
>>> requirement in the v4.1 spec? I'd like to have a look.
>> 
>> Sure. See IHI0069F, 5.3.19 (VMAPP GICv4.1), "Caching of virtual LPI 
>> data
>> structures", and the bit that says:
>> 
>> "A VMAPP with {V,Alloc}=={0,1} cleans and invalidates any caching of 
>> the
>> Virtual Pending Table and Virtual Configuration Table associated with 
>> the
>> vPEID held in the GIC"
>> 
>> which is what was crucially missing from the GICv4.0 spec (it doesn't 
>> say
>> when the GIC is done writing to memory).
> 
> OK. Thanks for the pointer!
> 
>> 
>> Side note: it'd be good to know what the rules are for your own GICv4
>> implementations, so that we can at least make sure the current code is 
>> safe.
> 
> As far as I know, there will be some clean and invalidate operations
> when v4.0 VPENDBASER.Valid gets programmed.

Interesting. The ideal behaviour would be that the VPT is up-to-date and
the caches clean when Valid is cleared (and once Dirty flips to 0).

> But not sure about behaviors
> on VMAPP (unmap), it may be a totally v4.1 stuff. I'll have a talk with
> our SOC team.

The VMAPP stuff is purely v4.1.

> But how can the current code be unsafe? Is anywhere in the current code
> will peek/poke the vpt (whilst GIC continues writing things into it)?

No. But on VM termination, the memory will be freed, and will eventually 
be
reallocated. If the GIC can still write to that memory after it has been
freed, you end-up with memory corruption... Which is why I'm curious of
what ensures that on your implementation.

I'd also like to know the same thing about the QC implementation, but
there's nobody left to find out...

Thanks,

          M.
-- 
Jazz is not dead. It just smells funny...
