Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF0421B7794
	for <lists+kvm@lfdr.de>; Fri, 24 Apr 2020 15:54:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726753AbgDXNyk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Apr 2020 09:54:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:49218 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726489AbgDXNyj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Apr 2020 09:54:39 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F3D7120700;
        Fri, 24 Apr 2020 13:54:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587736479;
        bh=YHmbAAC1M0cXqHHxzk+8ATQDnxZ0T4O5BOwo1BEPAQM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=2URQqHFfiNAjgfW72vk8AWVNifZj0NkcIiN2VudOxzZ1BsAaI/I25uZ3P7wQ12H2d
         J9T9weXJMkS5ixZs2Gm6fE0yMK7DMYGuT3vJYw0FKe+JmHLsVyWwEyMxzJXiWYo87w
         wFFGPVVQACTOXmnHEew0LvN4uwbaJZ68MTjuVdKY=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
        by disco-boy.misterjones.org with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1jRymr-0064sx-4W; Fri, 24 Apr 2020 14:54:37 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Fri, 24 Apr 2020 14:54:37 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Cc:     kvm@vger.kernel.org, Will Deacon <will@kernel.org>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Andre Przywara <andre.przywara@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>
Subject: Re: [PATCH kvmtool] vfio: fix multi-MSI vector handling
In-Reply-To: <20200424134024.12543-1-lorenzo.pieralisi@arm.com>
References: <20200424134024.12543-1-lorenzo.pieralisi@arm.com>
Message-ID: <dcae31aedd7286e5679ca570a1149f27@kernel.org>
X-Sender: maz@kernel.org
User-Agent: Roundcube Webmail/1.3.10
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: lorenzo.pieralisi@arm.com, kvm@vger.kernel.org, will@kernel.org, julien.thierry.kdev@gmail.com, jean-philippe@linaro.org, andre.przywara@arm.com, alexandru.elisei@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Lorenzo,

On 2020-04-24 14:40, Lorenzo Pieralisi wrote:
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
> Cc: Will Deacon <will@kernel.org>
> Cc: Julien Thierry <julien.thierry.kdev@gmail.com>
> ---
>  vfio/pci.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/vfio/pci.c b/vfio/pci.c
> index 76e24c1..b43e522 100644
> --- a/vfio/pci.c
> +++ b/vfio/pci.c
> @@ -434,6 +434,12 @@ static void vfio_pci_msi_cap_write(struct kvm
> *kvm, struct vfio_device *vdev,
> 
>  	for (i = 0; i < nr_vectors; i++) {
>  		entry = &pdev->msi.entries[i];
> +
> +		if (nr_vectors > 1) {
> +			msg.data &= ~(nr_vectors - 1);
> +			msg.data |= i;
> +		}
> +

This matches my own understanding of how MultiMSI works.
Small nit: you don't need to check the condition for the number
of vectors, as this expression is valid for any nr_vectors
that is a power of 2 (as required by the spec).

>  		entry->config.msg = msg;
>  		vfio_pci_update_msi_entry(kvm, vdev, entry);
>  	}

FWIW:

Acked-by: Marc Zyngier <maz@kernel.org>

         M.
-- 
Jazz is not dead. It just smells funny...
