Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9BA529D40C
	for <lists+kvm@lfdr.de>; Wed, 28 Oct 2020 22:48:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726200AbgJ1Vso (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Oct 2020 17:48:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:38176 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726133AbgJ1VmZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Oct 2020 17:42:25 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ABCE0247F8;
        Wed, 28 Oct 2020 20:24:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603916679;
        bh=UUOsZKN7KXk7cHfjExBsUtQIG2TwB07hlMnxPr/cS6I=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=iYmrlKDDxKu96zmq+Rr+6UMBZ4Z5Qf4kxsu4mfrhQOlKqhCTZLeY/QIppwXC310IC
         zIrHp6hEXp1SRINeXQBLbVRaVAB+iTWzMCtjNQgwowYXu9lLAGxRgjF7fRELzlrbdy
         U/ttQAO/n2NdjR44LppRDupZeVqfu1gRV4vRkdqQ=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94)
        (envelope-from <maz@kernel.org>)
        id 1kXrzp-0059jz-LS; Wed, 28 Oct 2020 20:24:37 +0000
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Date:   Wed, 28 Oct 2020 20:24:37 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     James Morse <james.morse@arm.com>
Cc:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Andrew Scull <ascull@google.com>,
        Will Deacon <will@kernel.org>,
        Quentin Perret <qperret@google.com>,
        David Brazdil <dbrazdil@google.com>, kernel-team@android.com
Subject: Re: [PATCH 08/11] KVM: arm64: Inject AArch32 exceptions from HYP
In-Reply-To: <3691596f-fb42-a6e0-8aca-5a1605219c23@arm.com>
References: <20201026133450.73304-1-maz@kernel.org>
 <20201026133450.73304-9-maz@kernel.org>
 <b4ef5e3e-a1a4-948f-bc9d-4bd297cb26a6@arm.com>
 <6b30a9c9d082aeabc6cb81aca97b5398@kernel.org>
 <3691596f-fb42-a6e0-8aca-5a1605219c23@arm.com>
User-Agent: Roundcube Webmail/1.4.9
Message-ID: <9c130c8e438f59ecd0072feea9addbcc@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: james.morse@arm.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, ascull@google.com, will@kernel.org, qperret@google.com, dbrazdil@google.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2020-10-28 19:20, James Morse wrote:
> Hi Marc,
> 
> On 27/10/2020 19:21, Marc Zyngier wrote:
>>>> +static inline u32 __vcpu_read_cp15(const struct kvm_vcpu *vcpu, int 
>>>> reg)
>>>> +{
>>>> +    return __vcpu_read_sys_reg(vcpu, reg / 2);
>>>> +}
> 
>>> Doesn't this re-implement the issue 3204be4109ad biased?
> 
>> I don't think it does. The issue existed when accessing the 32bit 
>> shadow,
>> and we had to pick which side of the 64bit register had our 32bit 
>> value.
>> Here, we directly access the 64bit file, which is safe.
> 
> Because its not accessing the copro union, and the two users are both
> straight forward aliases.
> 
> ...
> 
> What do I get if I call:
> | __vcpu_read_cp15(vcpu, c6_IFAR);
> 
> Won't this return the value of c6_DFAR instead as they live in the
> same 64 bit register.

Yes, that would break. Not in this bit of code though.

> 
> 
>> But thinking of it, we may as well change the call sites to directly
>> use the 64bit enum, rather than playing games
> 
> Great!

Yeah, and there is a bunch of ... crap around this aliasing.
Unfortunately, I just noticed that 32bit guests are borked in -rc1.
Debug time.

         M.
-- 
Jazz is not dead. It just smells funny...
