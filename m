Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1A2DDD9375
	for <lists+kvm@lfdr.de>; Wed, 16 Oct 2019 16:14:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393879AbfJPOOv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Oct 2019 10:14:51 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([207.82.80.151]:47894 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2393859AbfJPOOv (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 16 Oct 2019 10:14:51 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-42-n70HJVILM5a2mE4Rqq_eYQ-1; Wed, 16 Oct 2019 15:14:46 +0100
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Wed, 16 Oct 2019 15:14:45 +0100
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Wed, 16 Oct 2019 15:14:45 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Paolo Bonzini' <pbonzini@redhat.com>,
        Xiaoyao Li <xiaoyao.li@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>
CC:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        H Peter Anvin <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Dave Hansen" <dave.hansen@intel.com>,
        Radim Krcmar <rkrcmar@redhat.com>,
        Ashok Raj <ashok.raj@intel.com>,
        Tony Luck <tony.luck@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Sai Praneeth Prakhya <sai.praneeth.prakhya@intel.com>,
        Ravi V Shankar <ravi.v.shankar@intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        x86 <x86@kernel.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: RE: [PATCH v9 09/17] x86/split_lock: Handle #AC exception for split
 lock
Thread-Topic: [PATCH v9 09/17] x86/split_lock: Handle #AC exception for split
 lock
Thread-Index: AQHVhCstE/dfMnN6K0OvT2lXBD77H6ddTnvg
Date:   Wed, 16 Oct 2019 14:14:45 +0000
Message-ID: <053924e2d08b4744b9fd10337e83ab2d@AcuMS.aculab.com>
References: <1560897679-228028-1-git-send-email-fenghua.yu@intel.com>
 <1560897679-228028-10-git-send-email-fenghua.yu@intel.com>
 <alpine.DEB.2.21.1906262209590.32342@nanos.tec.linutronix.de>
 <20190626203637.GC245468@romley-ivt3.sc.intel.com>
 <alpine.DEB.2.21.1906262338220.32342@nanos.tec.linutronix.de>
 <20190925180931.GG31852@linux.intel.com>
 <3ec328dc-2763-9da5-28d6-e28970262c58@redhat.com>
 <alpine.DEB.2.21.1910161142560.2046@nanos.tec.linutronix.de>
 <57f40083-9063-5d41-f06d-fa1ae4c78ec6@redhat.com>
 <alpine.DEB.2.21.1910161244060.2046@nanos.tec.linutronix.de>
 <3a12810b-1196-b70a-aa2e-9fe17dc7341a@redhat.com>
 <b2c42a64-eb42-1f18-f609-42eec3faef18@intel.com>
 <d2fc3cbe-1506-94fc-73a4-8ed55dc9337d@redhat.com>
In-Reply-To: <d2fc3cbe-1506-94fc-73a4-8ed55dc9337d@redhat.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
X-MC-Unique: n70HJVILM5a2mE4Rqq_eYQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Rm9yIHRoZSBzbXQgY2FzZSwgY2FuIHlvdSBtYWtlICNBQyBlbmFibGUgYSBwcm9wZXJ0eSBvZiB0
aGUgcHJvY2Vzcz8NClRoZW4gZGlzYWJsZSBpdCBvbiB0aGUgY29yZSBpZiBlaXRoZXIgc210IHBy
b2Nlc3MgcmVxdWlyZXMgaXQgYmUgZGlzYWJsZWQ/DQoNClRoaXMgd291bGQgbWVhbiB0aGF0IGlz
IGEgJ21peGVkIGVudmlyb25tZW50JyBub3QgYWxsIHNwbGl0IGFjY2Vzc2VzDQp3b3VsZCBhY3R1
YWxseSBnZW5lcmF0ZSAjQUMgLSBidXQgZW5vdWdoIHdvdWxkIHRvIGRldGVjdCBicm9rZW4gY29k
ZQ0KdGhhdCBkb2Vzbid0IGhhdmUgI0FDIGV4cGxpY2l0bHkgZGlzYWJsZWQuDQoNCkknbSBub3Qg
c3VyZSB5b3UnZCB3YW50IGEgZ3Vlc3QgdG8gZmxpcCAjQUMgZW5hYmxlIGJhc2VkIG9uIHRoZSBw
cm9jZXNzDQppdCBpcyBzY2hlZHVsaW5nLCBidXQgaXQgbWlnaHQgd29yayBmb3IgdGhlIGJhc2Ug
bWV0YWwgc2NoZWR1bGVyLg0KDQoJRGF2aWQNCg0KLQ0KUmVnaXN0ZXJlZCBBZGRyZXNzIExha2Vz
aWRlLCBCcmFtbGV5IFJvYWQsIE1vdW50IEZhcm0sIE1pbHRvbiBLZXluZXMsIE1LMSAxUFQsIFVL
DQpSZWdpc3RyYXRpb24gTm86IDEzOTczODYgKFdhbGVzKQ0K

