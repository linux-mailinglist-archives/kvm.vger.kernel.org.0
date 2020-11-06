Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D46B2A9382
	for <lists+kvm@lfdr.de>; Fri,  6 Nov 2020 10:57:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726621AbgKFJ5H (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Nov 2020 04:57:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:39046 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726075AbgKFJ5H (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Nov 2020 04:57:07 -0500
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E108B20B80;
        Fri,  6 Nov 2020 09:57:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604656627;
        bh=7k+t6D9+wpCTXBdefzDfDbiTH2zQDjta8PTrfd8tDa0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=nlvr1Tz1wWGJ1mgrgtClOUmilBn7fgUtvjxfmP49knvor83tz0AID5fpC/e10x3Na
         5fA2yUfgqMKrIMuoafHLqiXDsvLNB1rqknB1iEHYh3GssE78engknOQAV8JEHvx3WC
         50i3UEJibPtZ3FNpe3PTpWvSM0sYHc0xSF0MQUrY=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94)
        (envelope-from <maz@kernel.org>)
        id 1kayUS-00892a-Mm; Fri, 06 Nov 2020 09:57:04 +0000
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Fri, 06 Nov 2020 09:57:04 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     Will Deacon <will@kernel.org>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        linux-arm-kernel@lists.infradead.org,
        Peng Liang <liangpeng10@huawei.com>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        kernel-team@android.com
Subject: Re: [PATCH 1/3] KVM: arm64: Allow setting of ID_AA64PFR0_EL1.CSV2
 from userspace
In-Reply-To: <20201105224442.GD8842@willie-the-truck>
References: <20201103171445.271195-1-maz@kernel.org>
 <20201103171445.271195-2-maz@kernel.org>
 <20201105224442.GD8842@willie-the-truck>
User-Agent: Roundcube Webmail/1.4.9
Message-ID: <32241e9ee49133df4e9bcc6c8ebd7551@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: will@kernel.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, liangpeng10@huawei.com, james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2020-11-05 22:44, Will Deacon wrote:

>> +	if (csv2 > vcpu->kvm->arch.pfr0_csv2)
>> +		return -EINVAL;
>> +	vcpu->kvm->arch.pfr0_csv2 = csv2;
>> +
>> +	/* This is what we mean by invariant: you can't change it. */
>> +	if (val != read_id_reg(vcpu, rd, false))
>> +		return -EINVAL;
> 
> I think it's quite confusing to return -EINVAL in the case that we have
> actually updated arch.pfr0_csv2, as it's indistinguishable from the 
> case
> when csv2 was invalid and the field wasn't updated.

-EINVAL is the right error code here (you're setting an invalid value 
for
the whole register). The bug is that we have now changed CSV2 for 
everyone.

I'll have a look at fixing this, though it might involve some locking.

         M.
-- 
Jazz is not dead. It just smells funny...
