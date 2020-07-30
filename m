Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 150FB2336A2
	for <lists+kvm@lfdr.de>; Thu, 30 Jul 2020 18:22:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729996AbgG3QWm convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Thu, 30 Jul 2020 12:22:42 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([207.82.80.151]:26148 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726275AbgG3QWm (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 30 Jul 2020 12:22:42 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-168-pSkYNQ8ZO5WTrpGnSW1Ncw-1; Thu, 30 Jul 2020 17:22:38 +0100
X-MC-Unique: pSkYNQ8ZO5WTrpGnSW1Ncw-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Thu, 30 Jul 2020 17:22:38 +0100
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Thu, 30 Jul 2020 17:22:38 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Joerg Roedel' <joro@8bytes.org>,
        Paolo Bonzini <pbonzini@redhat.com>
CC:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Borislav Petkov <bp@alien8.de>, Joerg Roedel <jroedel@suse.de>
Subject: RE: [PATCH v2 4/4] KVM: SVM: Use __packed shorthand
Thread-Topic: [PATCH v2 4/4] KVM: SVM: Use __packed shorthand
Thread-Index: AQHWZohC3H9k40HxxUaQvBycA7RPyakgTMJw
Date:   Thu, 30 Jul 2020 16:22:38 +0000
Message-ID: <230e4cc785ff49a38c028474dcfc9c36@AcuMS.aculab.com>
References: <20200730154340.14021-1-joro@8bytes.org>
 <20200730154340.14021-5-joro@8bytes.org>
In-Reply-To: <20200730154340.14021-5-joro@8bytes.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=C51A453 smtp.mailfrom=david.laight@aculab.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: aculab.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Joerg Roedel
> Sent: 30 July 2020 16:44
> 
> From: Borislav Petkov <bp@alien8.de>
> 
> Use the shorthand to make it more readable.
...
> diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
> index 8744817358bf..6b4b43f68f4b 100644
> --- a/arch/x86/include/asm/svm.h
> +++ b/arch/x86/include/asm/svm.h
> @@ -150,14 +150,14 @@ struct __attribute__ ((__packed__)) vmcb_control_area {
>  #define SVM_NESTED_CTL_NP_ENABLE	BIT(0)
>  #define SVM_NESTED_CTL_SEV_ENABLE	BIT(1)
> 
> -struct __attribute__ ((__packed__)) vmcb_seg {
> +struct vmcb_seg {
>  	u16 selector;
>  	u16 attrib;
>  	u32 limit;
>  	u64 base;
> -};
> +} __packed;

Why are they marked 'packed' at all?
The above has no holes.
So it would only need to be 'packed' if it might exist at
an unaligned address.
That only tends to happed for network messages and compatibility
with old hardware definitions.

While you might want an attribute for 'error if has holes'
if definitely isn't __packed.

For larger structures in can be worth adding a compile-time
assert that the structure is the size of the associated
hardware registers/structure.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

