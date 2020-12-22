Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D4482E0E3E
	for <lists+kvm@lfdr.de>; Tue, 22 Dec 2020 19:34:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725975AbgLVSdh convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Tue, 22 Dec 2020 13:33:37 -0500
Received: from eu-smtp-delivery-151.mimecast.com ([207.82.80.151]:39114 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725783AbgLVSdg (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 22 Dec 2020 13:33:36 -0500
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-146-vieJhqoKNaGruMocbz4_3Q-1; Tue, 22 Dec 2020 18:31:54 +0000
X-MC-Unique: vieJhqoKNaGruMocbz4_3Q-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Tue, 22 Dec 2020 18:31:53 +0000
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Tue, 22 Dec 2020 18:31:53 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Sean Christopherson' <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "syzbot+e87846c48bf72bc85311@syzkaller.appspotmail.com" 
        <syzbot+e87846c48bf72bc85311@syzkaller.appspotmail.com>
Subject: RE: [PATCH] KVM: x86: fix shift out of bounds reported by UBSAN
Thread-Topic: [PATCH] KVM: x86: fix shift out of bounds reported by UBSAN
Thread-Index: AQHW2I5xB2shRGddbUGbA42w1f+MfqoDb1cg
Date:   Tue, 22 Dec 2020 18:31:53 +0000
Message-ID: <01b7c21e3a864c0cb89fd036ebe03ccf@AcuMS.aculab.com>
References: <20201222102132.1920018-1-pbonzini@redhat.com>
 <X+I3SFzLGhEZIzEa@google.com>
In-Reply-To: <X+I3SFzLGhEZIzEa@google.com>
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

From: Sean Christopherson
> Sent: 22 December 2020 18:13
> 
> On Tue, Dec 22, 2020, Paolo Bonzini wrote:
> > Since we know that e >= s, we can reassociate the left shift,
> > changing the shifted number from 1 to 2 in exchange for
> > decreasing the right hand side by 1.
> 
> I assume the edge case is that this ends up as `(1ULL << 64) - 1` and overflows
> SHL's max shift count of 63 when s=0 and e=63?  If so, that should be called
> out.  If it's something else entirely, then an explanation is definitely in
> order.
> 
> > Reported-by: syzbot+e87846c48bf72bc85311@syzkaller.appspotmail.com
> > Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> > ---
> >  arch/x86/kvm/mmu.h | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
> > index 9c4a9c8e43d9..581925e476d6 100644
> > --- a/arch/x86/kvm/mmu.h
> > +++ b/arch/x86/kvm/mmu.h
> > @@ -49,7 +49,7 @@ static inline u64 rsvd_bits(int s, int e)
> >  	if (e < s)
> >  		return 0;
> 
> Maybe add a commment?  Again assuming my guess about the edge case is on point.
> 
> 	/*
> 	 * Use 2ULL to incorporate the necessary +1 in the shift; adding +1 in
> 	 * the shift count will overflow SHL's max shift of 63 if s=0 and e=63.
> 	 */

A comment of the desired output value would be more use.
I think it is:
	return 'e-s' ones followed by 's' zeros without shifting by 64.

> > -	return ((1ULL << (e - s + 1)) - 1) << s;
> > +	return ((2ULL << (e - s)) - 1) << s;

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

