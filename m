Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 057B52487F1
	for <lists+kvm@lfdr.de>; Tue, 18 Aug 2020 16:41:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727118AbgHROlM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Aug 2020 10:41:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:50948 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726585AbgHROlF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Aug 2020 10:41:05 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 70C852083B;
        Tue, 18 Aug 2020 14:41:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597761663;
        bh=bJPOt4B5MgpMDT2n+zzNZ+rE9AaQj654FX1OxJw6sDk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=AOCKY6z/atNldeFw82NlnljvDaIkZ1FqC+aSBMu3yFXm9qvkAyP1Gs4olwzL0n+JN
         KtfqIK08IDgo0RkpYl8PMbUn6s3DUAhVyXc/EQOmH1F+zB4VF2sIxTbf7BWv2kFOUi
         VkiNd596tsEYNkhmbOs65QaPxRz3BbwlGWmAiHAI=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
        by disco-boy.misterjones.org with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1k82nN-003vcz-O3; Tue, 18 Aug 2020 15:41:01 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Tue, 18 Aug 2020 15:41:01 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     Keqian Zhu <zhukeqian1@huawei.com>
Cc:     linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        Steven Price <steven.price@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        wanghaibin.wang@huawei.com
Subject: Re: [RFC PATCH 0/5] KVM: arm64: Add pvtime LPT support
In-Reply-To: <20200817084110.2672-1-zhukeqian1@huawei.com>
References: <20200817084110.2672-1-zhukeqian1@huawei.com>
User-Agent: Roundcube Webmail/1.4.7
Message-ID: <8308f52e4c906cad710575724f9e3855@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: zhukeqian1@huawei.com, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, steven.price@arm.com, catalin.marinas@arm.com, will@kernel.org, james.morse@arm.com, suzuki.poulose@arm.com, wanghaibin.wang@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2020-08-17 09:41, Keqian Zhu wrote:
> Hi all,
> 
> This patch series picks up the LPT pvtime feature originally developed
> by Steven Price: https://patchwork.kernel.org/cover/10726499/
> 
> Backgroud:
> 
> There is demand for cross-platform migration, which means we have to
> solve different CPU features and arch counter frequency between hosts.
> This patch series can solve the latter problem.
> 
> About LPT:
> 
> This implements support for Live Physical Time (LPT) which provides the
> guest with a method to derive a stable counter of time during which the
> guest is executing even when the guest is being migrated between hosts
> with different physical counter frequencies.
> 
> Changes on Steven Price's work:
> 1. LPT structure: use symmatical semantics of scale multiplier, and use
>    fraction bits instead of "shift" to make everything clear.
> 2. Structure allocation: host kernel does not allocates the LPT 
> structure,
>    instead it is allocated by userspace through VM attributes. The 
> save/restore
>    functionality can be removed.
> 3. Since LPT structure just need update once for each guest run, add a 
> flag to
>    indicate the update status. This has two benifits: 1) avoid multiple 
> update
>    by each vCPUs. 2) If the update flag is not set, then return NOT 
> SUPPORT for
>    coressponding guest HVC call.
> 4. Add VM device attributes interface for userspace configuration.
> 5. Add a base LPT read/write layer to reduce code.
> 6. Support ptimer scaling.
> 7. Support timer event stream translation.
> 
> Things need concern:
> 1. https://developer.arm.com/docs/den0057/a needs update.

LPT was explicitly removed from the spec because it doesn't really
solve the problem, specially for the firmware: EFI knows
nothing about this, for example. How is it going to work?
Also, nobody was ever able to explain how this would work for
nested virt.

ARMv8.4 and ARMv8.6 have the feature set that is required to solve
this problem without adding more PV to the kernel.

         M.
-- 
Jazz is not dead. It just smells funny...
