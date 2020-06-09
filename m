Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7C601F3509
	for <lists+kvm@lfdr.de>; Tue,  9 Jun 2020 09:38:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726187AbgFIHiP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Jun 2020 03:38:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:44366 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726099AbgFIHiP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 Jun 2020 03:38:15 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F023F2074B;
        Tue,  9 Jun 2020 07:38:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591688295;
        bh=XX5d5KaAtphU/kZf+qt3bMEwCoOYeQG5XQlitoBuT0Q=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=FXRWngKX4+Iu3JVdr/H3JTL7xz8zVI8QGaVBS/zbkHU+9Y4uLj8Gd51PkCr0Nlvyh
         /Ufzaws0PeRTThPPgPdtdgDZN+xT/YYUv9EBxKghVg+4KsIr9ZH1Q+zYUEXd+MWHa2
         xFskecywmzejx7r+8aPwA/faRCckoRf+kzZ0BqN8=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
        by disco-boy.misterjones.org with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1jiYpp-001OCI-9n; Tue, 09 Jun 2020 08:38:13 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Tue, 09 Jun 2020 08:38:13 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     Mark Rutland <mark.rutland@arm.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        linux-arm-kernel@lists.infradead.org,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        kernel-team@android.com
Subject: Re: [PATCH 3/3] KVM: arm64: Enforce PtrAuth being disabled if not
 advertized
In-Reply-To: <20200604153900.GE75320@C02TD0UTHF1T.local>
References: <20200604133354.1279412-1-maz@kernel.org>
 <20200604133354.1279412-4-maz@kernel.org>
 <20200604153900.GE75320@C02TD0UTHF1T.local>
User-Agent: Roundcube Webmail/1.4.4
Message-ID: <8c340ebe6be5d9c866c24ad55ed0a841@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: mark.rutland@arm.com, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, will@kernel.org, catalin.marinas@arm.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Mark,

On 2020-06-04 16:39, Mark Rutland wrote:
> Hi Marc,
> 
> On Thu, Jun 04, 2020 at 02:33:54PM +0100, Marc Zyngier wrote:
>> Even if we don't expose PtrAuth to a guest, the guest can still
>> write to its SCTIRLE_1 register and set the En{I,D}{A,B} bits
>> and execute PtrAuth instructions from the NOP space. This has
>> the effect of trapping to EL2, and we currently inject an UNDEF.
> 
> I think it's worth noting that this is an ill-behaved guest, as those
> bits are RES0 when pointer authentication isn't implemented.
> 
> The rationale for RES0/RES1 bits is that new HW can rely on old SW
> programming them with the 0/1 as appropriate, and that old SW that does
> not do so may encounter behaviour which from its PoV is UNPREDICTABLE.
> The SW side of the contract is that you must program them as 0/1 unless
> you know they're allocated with a specific meaning.
> 
> With that in mind I think the current behaviour is legitimate: from the
> guest's PoV it's the same as there being a distinct extension which it
> is not aware of where the En{I,D}{A,B} bits means "trap some HINTs to
> EL1".
> 
> I don't think that we should attempt to work around broken software 
> here
> unless we absolutely have to, as it only adds complexity for no real
> gain.

Fair enough. I was worried of the behaviour difference between HW 
without
PtrAuth and a guest with HW not advertised. Ideally, they should have
the same behaviour, but the architecture feels a bit brittle here.

Anyway, I'll drop this patch, and hopefully no guest will play this
game (they'll know pretty quickly about the issue anyway).

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
