Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 716FF4DE469
	for <lists+kvm@lfdr.de>; Sat, 19 Mar 2022 00:03:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241462AbiCRXFO convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Fri, 18 Mar 2022 19:05:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238197AbiCRXFN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Mar 2022 19:05:13 -0400
Received: from eu-smtp-delivery-151.mimecast.com (eu-smtp-delivery-151.mimecast.com [185.58.85.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id DC40576285
        for <kvm@vger.kernel.org>; Fri, 18 Mar 2022 16:03:53 -0700 (PDT)
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-88-aKH-9UiwNei_YRJVTyN66w-1; Fri, 18 Mar 2022 23:03:51 +0000
X-MC-Unique: aKH-9UiwNei_YRJVTyN66w-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) with Microsoft SMTP
 Server (TLS) id 15.0.1497.32; Fri, 18 Mar 2022 23:03:50 +0000
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.033; Fri, 18 Mar 2022 23:03:50 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Peter Zijlstra' <peterz@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>
CC:     Maxim Levitsky <mlevitsk@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "seanjc@google.com" <seanjc@google.com>
Subject: RE: [PATCH v3 6/6] KVM: x86: allow defining return-0 static calls
Thread-Topic: [PATCH v3 6/6] KVM: x86: allow defining return-0 static calls
Thread-Index: AQHYOvJSJ6iVxlFZSEKme+GWeigJ56zFwTUA
Date:   Fri, 18 Mar 2022 23:03:50 +0000
Message-ID: <04a3d031624d4472aaf4cd20a0d3be47@AcuMS.aculab.com>
References: <20220217180831.288210-1-pbonzini@redhat.com>
 <20220217180831.288210-7-pbonzini@redhat.com>
 <3bbe3f8717cdf122f909a48e117dab6c09d8e0c8.camel@redhat.com>
 <1dc56110-5f1b-6140-937c-bf4a28ddbe87@redhat.com>
 <20220318172837.GQ8939@worktop.programming.kicks-ass.net>
 <20220318174732.GE14330@worktop.programming.kicks-ass.net>
 <20220318180225.GF14330@worktop.programming.kicks-ass.net>
In-Reply-To: <20220318180225.GF14330@worktop.programming.kicks-ass.net>
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
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Peter Zijlstra
> Sent: 18 March 2022 18:02
> 
> On Fri, Mar 18, 2022 at 06:47:32PM +0100, Peter Zijlstra wrote:
> > On Fri, Mar 18, 2022 at 06:28:37PM +0100, Peter Zijlstra wrote:
> > > > Related to this, I don't see anything in arch/x86/kernel/static_call.c that
> > > > limits this code to x86-64:
> > > >
> > > >                 if (func == &__static_call_return0) {
> > > >                         emulate = code;
> > > >                         code = &xor5rax;
> > > >                 }
> > > >
> > > >
> > > > On 32-bit, it will be patched as "dec ax; xor eax, eax" or something like
> > > > that.  Fortunately it doesn't corrupt any callee-save register but it is not
> > > > just a bit funky, it's also not a single instruction.
> > >
> > > Urggghh.. that's fairly yuck. So there's two options I suppose:
> > >
> > > 	0x66, 0x66, 0x66, 0x31, 0xc0
> >
> > Argh, that turns into: xorw %ax, %ax.
> >
> > Let me see if there's another option.
> 
> Amazingly:
> 
>   0x2e, 0x2e, 0x2e, 0x31, 0xc0
> 
> seems to actually work.. I've build and ran and decoded the below on
> 32bit and 64bit (arguably on the same 64bit host).

Not really amazing...
In 64bit mode all accesses to 32bit registers zero the
high bits.
So 'xor %eax,%eax' zeros all of %rax in 64bit mode.
So three segment override prefixes will extend it to 5 bytes.

Think I'd pick the FS or GS override (0x64 or 0x65).
Just in case someone decides that CS/DS/ES/SS prefix will
mean something else in 64bit mode.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

