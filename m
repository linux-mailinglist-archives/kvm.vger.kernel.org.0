Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F1B51C6CF4
	for <lists+kvm@lfdr.de>; Wed,  6 May 2020 11:30:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728941AbgEFJag (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 May 2020 05:30:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:33572 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728648AbgEFJag (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 May 2020 05:30:36 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3C8022073A;
        Wed,  6 May 2020 09:30:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588757433;
        bh=Fz1Pqdbpgc/bySY2VzRgx4entrNkwjB8l09H9tBKs+Q=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=A6AXkxkOxO9KqbRlc+m5bTrgAkj41jx0GT7sLL5hOC4ygkxzOEKUhn9deltnjF2SI
         ZkHf3lD/5cJAMJXWSEF0GBGdc4k2G0dD+DGGrEO3Zib+4Z9yE5J8wneTTJzkZm44Kw
         dygjsIJjIyP2cVfm2Y3xLSoEReD5OxHsOxUw0xLA=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why)
        by disco-boy.misterjones.org with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1jWGNr-009u8C-Ky; Wed, 06 May 2020 10:30:31 +0100
Date:   Wed, 6 May 2020 10:30:29 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     James Morse <james.morse@arm.com>
Cc:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
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
Subject: Re: [PATCH 03/26] KVM: arm64: Factor out stage 2 page table data
 from struct kvm
Message-ID: <20200506103029.4f6ca0d3@why>
In-Reply-To: <86o8r2tg83.wl-maz@kernel.org>
References: <20200422120050.3693593-1-maz@kernel.org>
        <20200422120050.3693593-4-maz@kernel.org>
        <660a6638-5ee0-54c5-4a9d-d0d9235553ad@arm.com>
        <86o8r2tg83.wl-maz@kernel.org>
Organization: Approximate
X-Mailer: Claws Mail 3.17.5 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: james.morse@arm.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, andre.przywara@arm.com, christoffer.dall@arm.com, Dave.Martin@arm.com, jintack@cs.columbia.edu, alexandru.elisei@arm.com, gcherian@marvell.com, prime.zeng@hisilicon.com, will@kernel.org, catalin.marinas@arm.com, mark.rutland@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 05 May 2020 18:59:56 +0100
Marc Zyngier <maz@kernel.org> wrote:

Hi James,

> > But accessing VTCR is why the stage2_dissolve_p?d() stuff still
> > needs the kvm pointer, hence the backreference... it might be neater
> > to push the vtcr properties into kvm_s2_mmu that way you could drop
> > the kvm backref, and only things that take vm-wide locks would need
> > the kvm pointer. But I don't think it matters.  
> 
> That's an interesting consideration. I'll have a look.

So I went back on forth on this (the joys of not sleeping), and decided
to keep the host's VTCR_EL2 where it is today (in the kvm structure).
Two reasons for this:

- This field is part of the host configuration. Moving it to the S2 MMU
  structure muddies the waters a bit once you start nesting, as this
  structure really describes an inner guest context. It has its own
  associated VTCR, which lives in the sysreg file, and it becomes a bit
  confusing to look at a kvm_s2_mmu structure in isolation and wonder
  whether this field is directly related to the PTs in this structure,
  or to something else.

- It duplicates state. If there is one thing I have learned over the
  past years, it is that you should keep a given state in one single
  place at all times. Granted, VTCR doesn't change over the lifetime of
  the guest, but still.

I guess the one thing that would push me to the other side of the
debate is if we can show that the amount of pointer chasing generated
by the mmu->kvm->vtcr dance is causing actual performance issues. So
far, I haven't measured such an impact.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
