Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35F1929EF29
	for <lists+kvm@lfdr.de>; Thu, 29 Oct 2020 16:05:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728049AbgJ2PFk convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Thu, 29 Oct 2020 11:05:40 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([207.82.80.151]:56380 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728027AbgJ2PFh (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 29 Oct 2020 11:05:37 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-56-P6lCnI4YNLSev_eoOtq5HQ-1; Thu, 29 Oct 2020 15:05:32 +0000
X-MC-Unique: P6lCnI4YNLSev_eoOtq5HQ-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Thu, 29 Oct 2020 15:05:31 +0000
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Thu, 29 Oct 2020 15:05:31 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Arnd Bergmann' <arnd@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "x86@kernel.org" <x86@kernel.org>
CC:     Arnd Bergmann <arnd@arndb.de>,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Vitaly Kuznetsov" <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        "Jim Mattson" <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "platform-driver-x86@vger.kernel.org" 
        <platform-driver-x86@vger.kernel.org>,
        "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>
Subject: RE: [PATCH] [v2] x86: apic: avoid -Wshadow warning in header
Thread-Topic: [PATCH] [v2] x86: apic: avoid -Wshadow warning in header
Thread-Index: AQHWrZenJpzBwTRfbE+Uihb7XQWTqKmurjkg
Date:   Thu, 29 Oct 2020 15:05:31 +0000
Message-ID: <38b11ed3fec64ebd82d6a92834a4bebe@AcuMS.aculab.com>
References: <20201028212417.3715575-1-arnd@kernel.org>
In-Reply-To: <20201028212417.3715575-1-arnd@kernel.org>
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

From: Arnd Bergmann
> Sent: 28 October 2020 21:21
> 
> From: Arnd Bergmann <arnd@arndb.de>
> 
> There are hundreds of warnings in a W=2 build about a local
> variable shadowing the global 'apic' definition:
> 
> arch/x86/kvm/lapic.h:149:65: warning: declaration of 'apic' shadows a global declaration [-Wshadow]
> 
> Avoid this by renaming the global 'apic' variable to the more descriptive
> 'x86_system_apic'. It was originally called 'genapic', but both that
> and the current 'apic' seem to be a little overly generic for a global
> variable.
> 
> Fixes: c48f14966cc4 ("KVM: inline kvm_apic_present() and kvm_lapic_enabled()")
> Fixes: c8d46cf06dc2 ("x86: rename 'genapic' to 'apic'")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
> v2: rename the global instead of the local variable in the header
...
> diff --git a/arch/x86/hyperv/hv_apic.c b/arch/x86/hyperv/hv_apic.c
> index 284e73661a18..33e2dc78ca11 100644
> --- a/arch/x86/hyperv/hv_apic.c
> +++ b/arch/x86/hyperv/hv_apic.c
> @@ -259,14 +259,14 @@ void __init hv_apic_init(void)
>  		/*
>  		 * Set the IPI entry points.
>  		 */
> -		orig_apic = *apic;
> -
> -		apic->send_IPI = hv_send_ipi;
> -		apic->send_IPI_mask = hv_send_ipi_mask;
> -		apic->send_IPI_mask_allbutself = hv_send_ipi_mask_allbutself;
> -		apic->send_IPI_allbutself = hv_send_ipi_allbutself;
> -		apic->send_IPI_all = hv_send_ipi_all;
> -		apic->send_IPI_self = hv_send_ipi_self;
> +		orig_apic = *x86_system_apic;
> +
> +		x86_system_apic->send_IPI = hv_send_ipi;
> +		x86_system_apic->send_IPI_mask = hv_send_ipi_mask;
> +		x86_system_apic->send_IPI_mask_allbutself = hv_send_ipi_mask_allbutself;
> +		x86_system_apic->send_IPI_allbutself = hv_send_ipi_allbutself;
> +		x86_system_apic->send_IPI_all = hv_send_ipi_all;
> +		x86_system_apic->send_IPI_self = hv_send_ipi_self;
>  	}
> 
>  	if (ms_hyperv.hints & HV_X64_APIC_ACCESS_RECOMMENDED) {
> @@ -285,10 +285,10 @@ void __init hv_apic_init(void)
>  		 */
>  		apic_set_eoi_write(hv_apic_eoi_write);
>  		if (!x2apic_enabled()) {
> -			apic->read      = hv_apic_read;
> -			apic->write     = hv_apic_write;
> -			apic->icr_write = hv_apic_icr_write;
> -			apic->icr_read  = hv_apic_icr_read;
> +			x86_system_apic->read      = hv_apic_read;
> +			x86_system_apic->write     = hv_apic_write;
> +			x86_system_apic->icr_write = hv_apic_icr_write;
> +			x86_system_apic->icr_read  = hv_apic_icr_read;
>  		}

For those two just add:
	struct apic *apic = x86_system_apic;
before all the assignments.
Less churn and much better code.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

