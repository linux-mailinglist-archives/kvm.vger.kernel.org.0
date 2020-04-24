Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BAAF1B78B5
	for <lists+kvm@lfdr.de>; Fri, 24 Apr 2020 17:00:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727021AbgDXPA0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Apr 2020 11:00:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:42196 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726698AbgDXPAZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Apr 2020 11:00:25 -0400
Received: from willie-the-truck (236.31.169.217.in-addr.arpa [217.169.31.236])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4306220706;
        Fri, 24 Apr 2020 15:00:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587740425;
        bh=OsWlo+aiq+LUY5whok8YV+aTR/WLgh4DGS43BJyNgWA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=lV+iflbcdYHeV1mzww4HAbyJLIpDI4Zm/PiXkWQqJyDb0GMx0BV9uJz1w60myE/0/
         rDLuYA7aPc/3zJTmViiuMBlttPDq/l8DI2gggeKOoA1tm57hQcxrkVyjzY0qiYlZAf
         Ydeu5l/V5Q/SLBc88h9LzvtidW8D243kyws65e0Q=
Date:   Fri, 24 Apr 2020 16:00:21 +0100
From:   Will Deacon <will@kernel.org>
To:     Marc Zyngier <maz@kernel.org>
Cc:     Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>, kvm@vger.kernel.org,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Andre Przywara <andre.przywara@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>
Subject: Re: [PATCH kvmtool] vfio: fix multi-MSI vector handling
Message-ID: <20200424150020.GF21141@willie-the-truck>
References: <20200424134024.12543-1-lorenzo.pieralisi@arm.com>
 <dcae31aedd7286e5679ca570a1149f27@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dcae31aedd7286e5679ca570a1149f27@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Apr 24, 2020 at 02:54:37PM +0100, Marc Zyngier wrote:
> On 2020-04-24 14:40, Lorenzo Pieralisi wrote:
> > diff --git a/vfio/pci.c b/vfio/pci.c
> > index 76e24c1..b43e522 100644
> > --- a/vfio/pci.c
> > +++ b/vfio/pci.c
> > @@ -434,6 +434,12 @@ static void vfio_pci_msi_cap_write(struct kvm
> > *kvm, struct vfio_device *vdev,
> > 
> >  	for (i = 0; i < nr_vectors; i++) {
> >  		entry = &pdev->msi.entries[i];
> > +
> > +		if (nr_vectors > 1) {
> > +			msg.data &= ~(nr_vectors - 1);
> > +			msg.data |= i;
> > +		}
> > +
> 
> This matches my own understanding of how MultiMSI works.
> Small nit: you don't need to check the condition for the number
> of vectors, as this expression is valid for any nr_vectors
> that is a power of 2 (as required by the spec).
> 
> >  		entry->config.msg = msg;
> >  		vfio_pci_update_msi_entry(kvm, vdev, entry);
> >  	}
> 
> FWIW:
> 
> Acked-by: Marc Zyngier <maz@kernel.org>

Cheers guys. Lorenzo -- if you send a new version, I can pick it up straight
away.

Will
