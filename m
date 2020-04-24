Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 545CD1B7C55
	for <lists+kvm@lfdr.de>; Fri, 24 Apr 2020 19:03:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727796AbgDXRDv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Apr 2020 13:03:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:53892 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726793AbgDXRDu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Apr 2020 13:03:50 -0400
Received: from willie-the-truck (236.31.169.217.in-addr.arpa [217.169.31.236])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1F52420736;
        Fri, 24 Apr 2020 17:03:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587747830;
        bh=RP2I+oj7xQw3G+6b/rMgw15k476c4zW6ZA6SXkiqVwA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=wGGVzAyy2SPZkA7Q20SkCeSoDDqfHTmXf3wHlaEqz+MBfWb5wVmY06fLuVUPakgu0
         jzw0xZxM9u1YGo2HfSm7rvGi/gb+0gSeAh4e9n2xkAebUNxxlvL4YTJPqXkFLcGYVX
         DomknKLvT3iQqOniZAcwZXBMG1+NcMROrSFKaR2s=
Date:   Fri, 24 Apr 2020 18:03:46 +0100
From:   Will Deacon <will@kernel.org>
To:     Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Cc:     kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Andre Przywara <andre.przywara@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>
Subject: Re: [PATCH kvmtool v2] vfio: fix multi-MSI vector handling
Message-ID: <20200424170345.GI21141@willie-the-truck>
References: <20200424153119.16913-1-lorenzo.pieralisi@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200424153119.16913-1-lorenzo.pieralisi@arm.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Apr 24, 2020 at 04:31:19PM +0100, Lorenzo Pieralisi wrote:
> A PCI device with a MSI capability enabling Multiple MSI messages
> (through the Multiple Message Enable field in the Message Control
> register[6:4]) is expected to drive the Message Data lower bits (number
> determined by the number of selected vectors) to generate the
> corresponding MSI messages writes on the PCI bus.
> 
> Therefore, KVM expects the MSI data lower bits (a number of
> bits that depend on bits [6:4] of the Message Control
> register - which in turn control the number of vectors
> allocated) to be set-up by kvmtool while programming the
> MSI IRQ routing entries to make sure the MSI entries can
> actually be demultiplexed by KVM and IRQ routes set-up
> accordingly so that when an actual HW fires KVM can
> route it to the correct entry in the interrupt controller
> (and set-up a correct passthrough route for directly
> injected interrupt).
> 
> Current kvmtool code does not set-up Message data entries
> correctly for multi-MSI vectors - the data field is left
> as programmed in the MSI capability by the guest for all
> vector entries, triggering IRQs misrouting.
> 
> Fix it.
> 
> Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
> Acked-by: Marc Zyngier <maz@kernel.org>
> Cc: Will Deacon <will@kernel.org>
> Cc: Julien Thierry <julien.thierry.kdev@gmail.com>
> ---
> v1 -> v2:
> 	- Removed superfluous nr_vectors check
> 	- Added MarcZ ACK
> 	- Added comment

Thanks, pushed out now.

Will
