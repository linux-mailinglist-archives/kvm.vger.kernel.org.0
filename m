Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35D521BAA66
	for <lists+kvm@lfdr.de>; Mon, 27 Apr 2020 18:49:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726303AbgD0Qtv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Apr 2020 12:49:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:33828 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726248AbgD0Qtv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Apr 2020 12:49:51 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 07B742078E;
        Mon, 27 Apr 2020 16:49:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588006191;
        bh=jQ0KWWZhLYMByhegFoIiVPOZdGk0Lzl4q7rMMcBmaew=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=mOIirCPKrFvI4awGm7xtERC/1d+1IFdK9FBuJhvAwXVySQ6LtQOVV3941dL88nHln
         oPon4b0PTqtO0zEbbez/LxcvR5zQJZEss/YQkxoUjDL4VVdWlJ5sHqC5/9CyDhSBvL
         AY2QX+K9rJ4UMv2Vu2x1pstXgUgGx3aJduDVdEj8=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
        by disco-boy.misterjones.org with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1jT6x3-006mzt-Ds; Mon, 27 Apr 2020 17:49:49 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Date:   Mon, 27 Apr 2020 17:49:49 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     =?UTF-8?Q?Andr=C3=A9_Przywara?= <andre.przywara@arm.com>
Cc:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Will Deacon <will@kernel.org>,
        Ard Biesheuvel <ardb@kernel.org>,
        Alexandru Elisei <Alexandru.Elisei@arm.com>
Subject: Re: [PATCH][kvmtool] kvm: Request VM specific limits instead of
 system-wide ones
In-Reply-To: <c36c30b1-6017-9c75-e0e9-e643eb348641@arm.com>
References: <20200427141738.285217-1-maz@kernel.org>
 <c36c30b1-6017-9c75-e0e9-e643eb348641@arm.com>
Message-ID: <3886cae6b5e7e1fc9ab821f1d734036f@kernel.org>
X-Sender: maz@kernel.org
User-Agent: Roundcube Webmail/1.3.10
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: andre.przywara@arm.com, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, will@kernel.org, ardb@kernel.org, Alexandru.Elisei@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2020-04-27 16:37, André Przywara wrote:
> On 27/04/2020 15:17, Marc Zyngier wrote:
> Hi,
> 
>> On arm64, the maximum number of vcpus is constrained by the type
>> of interrupt controller that has been selected (GICv2 imposes a
>> limit of 8 vcpus, while GICv3 currently has a limit of 512).
>> 
>> It is thus important to request this limit on the VM file descriptor
>> rather than on the one that corresponds to /dev/kvm, as the latter
>> is likely to return something that doesn't take the constraints into
>> account.
> 
> That sounds reasonable, but I fail to find any distinction in the 
> kernel
> code. We don't make any difference between the VM or the system FD in
> the ioctl handler for those two extensions. For arm64 we always return
> max. 512 (max VCPUs on GICv3), and number of online host cores for the
> recommended value. For arm there was a distinction between GICv3 
> support
> compiled in or not, but otherwise the same constant values returned.
> Quickly tested on Juno and N1SDP, the ioctls return the same expected
> values, regardless of sys_fd vs vm_fd.
> 
> So what am I missing here? Is this for some older or even newer 
> kernels?

You're missing this:

https://lore.kernel.org/kvm/20200427141507.284985-1-maz@kernel.org/

which adds the missing bits to the kernel.

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
