Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FEBE298115
	for <lists+kvm@lfdr.de>; Sun, 25 Oct 2020 10:49:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1414945AbgJYJtI convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Sun, 25 Oct 2020 05:49:08 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([185.58.86.151]:51434 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1414937AbgJYJtI (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sun, 25 Oct 2020 05:49:08 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-79-APpQa5EwNZOHyfX3wdwU4Q-1; Sun, 25 Oct 2020 09:49:04 +0000
X-MC-Unique: APpQa5EwNZOHyfX3wdwU4Q-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Sun, 25 Oct 2020 09:49:03 +0000
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Sun, 25 Oct 2020 09:49:03 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     'David Woodhouse' <dwmw2@infradead.org>,
        "x86@kernel.org" <x86@kernel.org>
CC:     kvm <kvm@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "joro@8bytes.org" <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Paolo Bonzini <pbonzini@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "maz@misterjones.org" <maz@misterjones.org>,
        Dexuan Cui <decui@microsoft.com>
Subject: RE: [PATCH v3 17/35] x86/pci/xen: Use msi_msg shadow structs
Thread-Topic: [PATCH v3 17/35] x86/pci/xen: Use msi_msg shadow structs
Thread-Index: AQHWqk3aux8nicxw2kqi6TJIJCakiamoEtJw
Date:   Sun, 25 Oct 2020 09:49:03 +0000
Message-ID: <3e69326016524d97bcdea35d0765cc68@AcuMS.aculab.com>
References: <e6601ff691afb3266e365a91e8b221179daf22c2.camel@infradead.org>
 <20201024213535.443185-1-dwmw2@infradead.org>
 <20201024213535.443185-18-dwmw2@infradead.org>
In-Reply-To: <20201024213535.443185-18-dwmw2@infradead.org>
Accept-Language: en-GB, en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=C51A453 smtp.mailfrom=david.laight@aculab.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: aculab.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: David Woodhouse
> Sent: 24 October 2020 22:35
> 
> From: Thomas Gleixner <tglx@linutronix.de>
> 
> Use the msi_msg shadow structs and compose the message with named bitfields
> instead of the unreadable macro maze.
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
> ---
>  arch/x86/pci/xen.c | 26 +++++++++++---------------
>  1 file changed, 11 insertions(+), 15 deletions(-)
> 
> diff --git a/arch/x86/pci/xen.c b/arch/x86/pci/xen.c
> index c552cd2d0632..3d41a09c2c14 100644
> --- a/arch/x86/pci/xen.c
> +++ b/arch/x86/pci/xen.c
> @@ -152,7 +152,6 @@ static int acpi_register_gsi_xen(struct device *dev, u32 gsi,
> 
>  #if defined(CONFIG_PCI_MSI)
>  #include <linux/msi.h>
> -#include <asm/msidef.h>
> 
>  struct xen_pci_frontend_ops *xen_pci_frontend;
>  EXPORT_SYMBOL_GPL(xen_pci_frontend);
> @@ -210,23 +209,20 @@ static int xen_setup_msi_irqs(struct pci_dev *dev, int nvec, int type)
>  	return ret;
>  }
> 
> -#define XEN_PIRQ_MSI_DATA  (MSI_DATA_TRIGGER_EDGE | \
> -		MSI_DATA_LEVEL_ASSERT | (3 << 8) | MSI_DATA_VECTOR(0))
> -
>  static void xen_msi_compose_msg(struct pci_dev *pdev, unsigned int pirq,
>  		struct msi_msg *msg)
>  {
> -	/* We set vector == 0 to tell the hypervisor we don't care about it,
> -	 * but we want a pirq setup instead.
> -	 * We use the dest_id field to pass the pirq that we want. */
> -	msg->address_hi = MSI_ADDR_BASE_HI | MSI_ADDR_EXT_DEST_ID(pirq);
> -	msg->address_lo =
> -		MSI_ADDR_BASE_LO |
> -		MSI_ADDR_DEST_MODE_PHYSICAL |
> -		MSI_ADDR_REDIRECTION_CPU |
> -		MSI_ADDR_DEST_ID(pirq);
> -
> -	msg->data = XEN_PIRQ_MSI_DATA;
> +	/*
> +	 * We set vector == 0 to tell the hypervisor we don't care about
> +	 * it, but we want a pirq setup instead.  We use the dest_id fields
> +	 * to pass the pirq that we want.
> +	 */
> +	memset(msg, 0, sizeof(*msg));
> +	msg->address_hi = X86_MSI_BASE_ADDRESS_HIGH;
> +	msg->arch_addr_hi.destid_8_31 = pirq >> 8;
> +	msg->arch_addr_lo.destid_0_7 = pirq & 0xFF;
> +	msg->arch_addr_lo.base_address = X86_MSI_BASE_ADDRESS_LOW;
> +	msg->arch_data.delivery_mode = APIC_DELIVERY_MODE_EXTINT;
>  }

Just looking at a random one of these patches...

Does the compiler manage to optimise that reasonably?
Or does it generate a lot of shifts and masks as each
bitfield is set?

The code generation for bitfields is often a lot worse
that that for |= setting bits in a word.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

