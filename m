Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B457961D9BC
	for <lists+kvm@lfdr.de>; Sat,  5 Nov 2022 12:39:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229789AbiKELjV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 5 Nov 2022 07:39:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229528AbiKELjT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 5 Nov 2022 07:39:19 -0400
Received: from eu-smtp-delivery-151.mimecast.com (eu-smtp-delivery-151.mimecast.com [185.58.86.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6096E286E8
        for <kvm@vger.kernel.org>; Sat,  5 Nov 2022 04:39:18 -0700 (PDT)
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-173-F1fWfsGqNdGbFLk2HJ1oPw-1; Sat, 05 Nov 2022 11:39:14 +0000
X-MC-Unique: F1fWfsGqNdGbFLk2HJ1oPw-1
Received: from AcuMS.Aculab.com (10.202.163.4) by AcuMS.aculab.com
 (10.202.163.4) with Microsoft SMTP Server (TLS) id 15.0.1497.42; Sat, 5 Nov
 2022 11:39:13 +0000
Received: from AcuMS.Aculab.com ([::1]) by AcuMS.aculab.com ([::1]) with mapi
 id 15.00.1497.042; Sat, 5 Nov 2022 11:39:13 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Borislav Petkov' <bp@alien8.de>,
        Kim Phillips <kim.phillips@amd.com>
CC:     "x86@kernel.org" <x86@kernel.org>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        Jonathan Corbet <corbet@lwn.net>,
        "Konrad Rzeszutek Wilk" <konrad.wilk@oracle.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        David Woodhouse <dwmw@amazon.co.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Juergen Gross <jgross@suse.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Tony Luck <tony.luck@intel.com>,
        Babu Moger <Babu.Moger@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 2/3] x86/speculation: Support Automatic IBRS
Thread-Topic: [PATCH 2/3] x86/speculation: Support Automatic IBRS
Thread-Index: AQHY8JfPISSI8KokdESl6NTz/MxgvK4wNJ8w
Date:   Sat, 5 Nov 2022 11:39:13 +0000
Message-ID: <49e01e4d819a4e3aa1ef13da6bc654e4@AcuMS.aculab.com>
References: <20221104213651.141057-1-kim.phillips@amd.com>
 <20221104213651.141057-3-kim.phillips@amd.com> <Y2WJjdY3wwQl9/q9@zn.tnic>
In-Reply-To: <Y2WJjdY3wwQl9/q9@zn.tnic>
Accept-Language: en-GB, en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: aculab.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

RnJvbTogQm9yaXNsYXYgUGV0a292DQo+IFNlbnQ6IDA0IE5vdmVtYmVyIDIwMjIgMjE6NTINCj4g
DQo+IE9uIEZyaSwgTm92IDA0LCAyMDIyIGF0IDA0OjM2OjUwUE0gLTA1MDAsIEtpbSBQaGlsbGlw
cyB3cm90ZToNCj4gPiAgLSBBbGxvdyBmb3Igc3BlY3RyZV92Mj1hdXRvaWJycyBpbiB0aGUga2Vy
bmVsIGNvbW1hbmQgbGluZSwNCj4gPiAgICByZXZlcnRpbmcgdG8gYXV0by1zZWxlY3Rpb24gaWYg
dGhlIGZlYXR1cmUgaXNuJ3QgYXZhaWxhYmxlLg0KPiANCj4gV2h5Pw0KPiANCj4gV2hhdCB0aGUg
d2hvbGUgbG9naWMgaGVyZSBzaG91bGQgZG8gaXMgZW5hYmxlIGF1dG9pYnJzIHdoZW4gZGV0ZWN0
ZWQNCj4gYXV0b21hdGljYWxseSwgd2l0aG91dCB0aGUgbmVlZCBmb3IgdGhlIHVzZXIgdG8gZXZl
biBzZWxlY3QgaXQgYXMgaXQgaXMNCj4gdGhlIHN1cGVyaW9yIG1pdGlnYXRpb24uDQoNClRoZSBv
bmx5IHVzZWZ1bCBvcHRpb24gaXMgdG8gYWxsb3cgYSBkaWZmZXJlbnQgb3B0aW9uIGJlDQpzZWxl
Y3RlZCBmb3IgY29kZSB0ZXN0aW5nLg0KU28gbWF5YmUgeW91IHdhbnQgYW4gb3B0aW9uIGZvciBj
b21wbGV0ZW5lc3MgLSBmb3Igd2hlbg0KYW4gJ2V2ZW4gYmV0dGVyJyBvcHRpb24gaXMgYXZhaWxh
YmxlLg0KDQoJRGF2aWQNCg0KLQ0KUmVnaXN0ZXJlZCBBZGRyZXNzIExha2VzaWRlLCBCcmFtbGV5
IFJvYWQsIE1vdW50IEZhcm0sIE1pbHRvbiBLZXluZXMsIE1LMSAxUFQsIFVLDQpSZWdpc3RyYXRp
b24gTm86IDEzOTczODYgKFdhbGVzKQ0K

