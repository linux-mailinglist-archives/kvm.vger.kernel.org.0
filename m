Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C50838F1A6
	for <lists+kvm@lfdr.de>; Mon, 24 May 2021 18:34:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233159AbhEXQgP convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Mon, 24 May 2021 12:36:15 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([185.58.85.151]:30302 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232118AbhEXQgO (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 24 May 2021 12:36:14 -0400
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-130-Su6f02UuPwmFID_yslxeDA-1; Mon, 24 May 2021 17:34:43 +0100
X-MC-Unique: Su6f02UuPwmFID_yslxeDA-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) with Microsoft SMTP
 Server (TLS) id 15.0.1497.2; Mon, 24 May 2021 17:34:39 +0100
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.015; Mon, 24 May 2021 17:34:39 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Mark Rutland' <mark.rutland@arm.com>,
        Christoph Hellwig <hch@infradead.org>
CC:     Joe Richey <joerichey94@gmail.com>,
        "trivial@kernel.org" <trivial@kernel.org>,
        Joe Richey <joerichey@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "x86@kernel.org" <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Zhangfei Gao <zhangfei.gao@linaro.org>,
        Zhou Wang <wangzhou1@hisilicon.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "linux-accelerators@lists.ozlabs.org" 
        <linux-accelerators@lists.ozlabs.org>
Subject: RE: [PATCH 0/6] Don't use BIT() macro in UAPI headers
Thread-Topic: [PATCH 0/6] Don't use BIT() macro in UAPI headers
Thread-Index: AQHXUJhmyhlvadTh4EyDNcSC3h2x96ry0v3w
Date:   Mon, 24 May 2021 16:34:39 +0000
Message-ID: <56cdb86fe8984a94b4a7a8073476d849@AcuMS.aculab.com>
References: <20210520104343.317119-1-joerichey94@gmail.com>
 <YKuSEnfEbjpOOgLS@infradead.org> <20210524122901.GH1040@C02TD0UTHF1T.local>
In-Reply-To: <20210524122901.GH1040@C02TD0UTHF1T.local>
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

From: Mark Rutland
> Sent: 24 May 2021 13:29
> 
> On Mon, May 24, 2021 at 12:46:26PM +0100, Christoph Hellwig wrote:
> > On Thu, May 20, 2021 at 03:43:37AM -0700, Joe Richey wrote:
> > > This patch series changes all UAPI uses of BIT() to just be open-coded.
> > > However, there really should be a check for this in checkpatch.pl
> > > Currently, the script actually _encourages_ users to use the BIT macro
> > > even if adding things to UAPI.
> >
> > Yes.  In fact it should warn about BIT() in general.  It is totally
> > pointless obsfucation that doesn't even save any typing at all.
> 
> That's not quite true; the point is that if you use BIT() consistently,
> then even when you refer to bits 32 to 63 you won't accidentally
> introduce shifts of more than the width of int, and the definition will
> work equally well for assembly and C, which isn't true if you use `1UL`
> in the definition.
> 
> With that in mind it's shorter and clearer than its functional
> equivalent:
> 
>   BIT(x)
>   (UL(1) << (x))
> 
> So IMO it's preferable to use BIT() generally, or _BITUL() in uapi
> headers.

And then, suddenly the compiler warns about truncation of the
high bits when ~BIT(x) is used to mask a 32bit value on 64bit systems.

Once the C standard committee had decided to change from K&R's
'sign preserving' integer promotions to 'value preserving'
you always lose somewhere.

Personally I prefer hex constants - I can't count bits at all.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

