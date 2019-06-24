Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0EDD951005
	for <lists+kvm@lfdr.de>; Mon, 24 Jun 2019 17:12:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729946AbfFXPML convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Mon, 24 Jun 2019 11:12:11 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([146.101.78.151]:43070 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727957AbfFXPMK (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 24 Jun 2019 11:12:10 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-143-5aPUt60zN6uguMOtfab1og-1; Mon, 24 Jun 2019 16:12:06 +0100
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Mon, 24 Jun 2019 16:12:05 +0100
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Mon, 24 Jun 2019 16:12:05 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Fenghua Yu' <fenghua.yu@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        H Peter Anvin <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dave Hansen <dave.hansen@intel.com>,
        "Paolo Bonzini" <pbonzini@redhat.com>,
        Radim Krcmar <rkrcmar@redhat.com>,
        Christopherson Sean J <sean.j.christopherson@intel.com>,
        Ashok Raj <ashok.raj@intel.com>,
        Tony Luck <tony.luck@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        "Xiaoyao Li " <xiaoyao.li@intel.com>,
        "Sai Praneeth Prakhya" <sai.praneeth.prakhya@intel.com>,
        Ravi V Shankar <ravi.v.shankar@intel.com>
CC:     linux-kernel <linux-kernel@vger.kernel.org>, x86 <x86@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: RE: [PATCH v9 02/17] drivers/net/b44: Align pwol_mask to unsigned
 long for better performance
Thread-Topic: [PATCH v9 02/17] drivers/net/b44: Align pwol_mask to unsigned
 long for better performance
Thread-Index: AQHVJiiMr9gB8h3g0E+XfoKMzxMCiqaq8WpA
Date:   Mon, 24 Jun 2019 15:12:05 +0000
Message-ID: <fce80c42ba1949fd8d7924786bbf0ec8@AcuMS.aculab.com>
References: <1560897679-228028-1-git-send-email-fenghua.yu@intel.com>
 <1560897679-228028-3-git-send-email-fenghua.yu@intel.com>
In-Reply-To: <1560897679-228028-3-git-send-email-fenghua.yu@intel.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
X-MC-Unique: 5aPUt60zN6uguMOtfab1og-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Fenghua Yu
> Sent: 18 June 2019 23:41
> From: Peter Zijlstra <peterz@infradead.org>
> 
> A bit in pwol_mask is set in b44_magic_pattern() by atomic set_bit().
> But since pwol_mask is local and never exposed to concurrency, there is
> no need to set bit in pwol_mask atomically.
> 
> set_bit() sets the bit in a single unsigned long location. Because
> pwol_mask may not be aligned to unsigned long, the location may cross two
> cache lines. On x86, accessing two cache lines in locked instruction in
> set_bit() is called split locked access and can cause overall performance
> degradation.
> 
> So use non atomic __set_bit() to set pwol_mask bits. __set_bit() won't hit
> split lock issue on x86.
> 
> Signed-off-by: Peter Zijlstra <peterz@infradead.org>
> Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
> ---
>  drivers/net/ethernet/broadcom/b44.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/broadcom/b44.c b/drivers/net/ethernet/broadcom/b44.c
> index 97ab0dd25552..5738ab963dfb 100644
> --- a/drivers/net/ethernet/broadcom/b44.c
> +++ b/drivers/net/ethernet/broadcom/b44.c
> @@ -1520,7 +1520,7 @@ static int b44_magic_pattern(u8 *macaddr, u8 *ppattern, u8 *pmask, int offset)
> 
>  	memset(ppattern + offset, 0xff, magicsync);
>  	for (j = 0; j < magicsync; j++)
> -		set_bit(len++, (unsigned long *) pmask);
> +		__set_bit(len++, (unsigned long *)pmask);
> 
>  	for (j = 0; j < B44_MAX_PATTERNS; j++) {
>  		if ((B44_PATTERN_SIZE - len) >= ETH_ALEN)
> @@ -1532,7 +1532,7 @@ static int b44_magic_pattern(u8 *macaddr, u8 *ppattern, u8 *pmask, int offset)
>  		for (k = 0; k< ethaddr_bytes; k++) {
>  			ppattern[offset + magicsync +
>  				(j * ETH_ALEN) + k] = macaddr[k];
> -			set_bit(len++, (unsigned long *) pmask);
> +			__set_bit(len++, (unsigned long *)pmask);

Is this code expected to do anything sensible on BE systems?
Casting the bitmask[] argument to any of the set_bit() functions is dubious at best.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

