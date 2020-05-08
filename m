Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A30F1CAA6E
	for <lists+kvm@lfdr.de>; Fri,  8 May 2020 14:20:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726817AbgEHMU4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 May 2020 08:20:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:59688 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726627AbgEHMUz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 May 2020 08:20:55 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B22E2208D6;
        Fri,  8 May 2020 12:20:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588940454;
        bh=FW6rwatJpH3f9YqjBLgABYd8viojkg66m20HhLLxy+E=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=0iY3OCVhd9Xw00lEJKywiWeb5005YOoZLT2lUuSCBbm+9lHODalCeg/IODZ/a1+Mg
         VdZDi9cpYRFrP/8f2kldeQ6u6d5yguyICPpLXjUIH233W2dhLuEgJBMpgw4AB0G00e
         yYfq36Pcx5b+5NY7lMFIe1HBLT+u7dtIXRMCKMDA=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why)
        by disco-boy.misterjones.org with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1jX1zp-00Aacj-2D; Fri, 08 May 2020 13:20:53 +0100
Date:   Fri, 8 May 2020 13:20:51 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     James Morse <james.morse@arm.com>
Cc:     kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
        kvm@vger.kernel.org, Andre Przywara <andre.przywara@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Dave Martin <Dave.Martin@arm.com>,
        Jintack Lim <jintack@cs.columbia.edu>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        George Cherian <gcherian@marvell.com>,
        "Zengtao (B)" <prime.zeng@hisilicon.com>,
        Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: Re: [PATCH 09/26] KVM: arm64: vgic-v3: Take cpu_if pointer directly
 instead of vcpu
Message-ID: <20200508132051.490943f8@why>
In-Reply-To: <3174eaad-7d8d-0c52-d71c-afc6b991b636@arm.com>
References: <20200422120050.3693593-1-maz@kernel.org>
        <20200422120050.3693593-10-maz@kernel.org>
        <3174eaad-7d8d-0c52-d71c-afc6b991b636@arm.com>
Organization: Approximate
X-Mailer: Claws Mail 3.17.5 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: james.morse@arm.com, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, andre.przywara@arm.com, christoffer.dall@arm.com, Dave.Martin@arm.com, jintack@cs.columbia.edu, alexandru.elisei@arm.com, gcherian@marvell.com, prime.zeng@hisilicon.com, will@kernel.org, catalin.marinas@arm.com, mark.rutland@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 7 May 2020 17:26:06 +0100
James Morse <james.morse@arm.com> wrote:

Hi James,

> Hi Marc, Christoffer,
> 
> On 22/04/2020 13:00, Marc Zyngier wrote:
> > From: Christoffer Dall <christoffer.dall@arm.com>
> > 
> > If we move the used_lrs field to the version-specific cpu interface
> > structure, the following functions only operate on the struct
> > vgic_v3_cpu_if and not the full vcpu:
> > 
> >   __vgic_v3_save_state
> >   __vgic_v3_restore_state
> >   __vgic_v3_activate_traps
> >   __vgic_v3_deactivate_traps
> >   __vgic_v3_save_aprs
> >   __vgic_v3_restore_aprs
> > 
> > This is going to be very useful for nested virt,   
> 
> ... because you don't need to consider whether the vcpu is running in vEL2?

That's one of the reasons, as vEL2 is still EL1.

But things become really fun when you run a L2 guest, which is an EL1
guest from the PoV of the guest hypervisor (aka L1). At this stage
what you feed to the HW is not the state that could be populated by L0
for L1, but instead what L1 has created for L2 (with a bit of
additional repainting to adjust some of the interrupt numbers).

So we build a shadow cpu_if on the fly and pass it to the normal vgic
handling functions. I told you it was fun! ;-)

> > so move the used_lrs
> > field and change the prototypes and implementations of these functions to
> > take the cpu_if parameter directly.  
> 
> 
> > No functional change.  
> 
> Looks like no change!
> 
> Reviewed-by: James Morse <james.morse@arm.com>

Thanks!

	M.
-- 
Jazz is not dead. It just smells funny...
