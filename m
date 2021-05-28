Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A1E139414D
	for <lists+kvm@lfdr.de>; Fri, 28 May 2021 12:45:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236510AbhE1Kqm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 May 2021 06:46:42 -0400
Received: from smtp-fw-4101.amazon.com ([72.21.198.25]:1229 "EHLO
        smtp-fw-4101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236340AbhE1Kqi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 May 2021 06:46:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1622198704; x=1653734704;
  h=from:to:cc:date:message-id:references:in-reply-to:
   content-id:content-transfer-encoding:mime-version:subject;
  bh=d1ixl0gqB1ZbcIE+9UrcAvtqK1+3Va7ykWyTuawiaYY=;
  b=ipyXV8auOi8UPSIODEG8OHH0WEBLWNc4fm04a9v797D+hUGpEYj1FkFi
   W+zFVWWfEHdP40GMiaZFBhO+ek+8rDo6rRpGrc8EqDb3joAOTdy10QQHU
   IZSNNlQ9MPVXva6GtJ8Cth0fQJ1Zse3TNXjCvamwJa0AiTA9qznWzVI7B
   4=;
X-IronPort-AV: E=Sophos;i="5.83,229,1616457600"; 
   d="scan'208";a="110762336"
Subject: Re: [PATCH v4 09/11] KVM: X86: Add vendor callbacks for writing the TSC
 multiplier
Thread-Topic: [PATCH v4 09/11] KVM: X86: Add vendor callbacks for writing the TSC
 multiplier
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-1d-e69428c4.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-4101.iad4.amazon.com with ESMTP; 28 May 2021 10:44:57 +0000
Received: from EX13MTAUEE001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan3.iad.amazon.com [10.40.159.166])
        by email-inbound-relay-1d-e69428c4.us-east-1.amazon.com (Postfix) with ESMTPS id C3B84C070A;
        Fri, 28 May 2021 10:44:53 +0000 (UTC)
Received: from EX13D08UEB001.ant.amazon.com (10.43.60.245) by
 EX13MTAUEE001.ant.amazon.com (10.43.62.226) with Microsoft SMTP Server (TLS)
 id 15.0.1497.18; Fri, 28 May 2021 10:44:52 +0000
Received: from EX13D18EUA001.ant.amazon.com (10.43.165.58) by
 EX13D08UEB001.ant.amazon.com (10.43.60.245) with Microsoft SMTP Server (TLS)
 id 15.0.1497.18; Fri, 28 May 2021 10:44:52 +0000
Received: from EX13D18EUA001.ant.amazon.com ([10.43.165.58]) by
 EX13D18EUA001.ant.amazon.com ([10.43.165.58]) with mapi id 15.00.1497.018;
 Fri, 28 May 2021 10:44:51 +0000
From:   "Stamatis, Ilias" <ilstam@amazon.com>
To:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>
CC:     "jmattson@google.com" <jmattson@google.com>,
        "Woodhouse, David" <dwmw@amazon.co.uk>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "mtosatti@redhat.com" <mtosatti@redhat.com>,
        "zamsden@gmail.com" <zamsden@gmail.com>,
        "seanjc@google.com" <seanjc@google.com>,
        "mlevitsk@redhat.com" <mlevitsk@redhat.com>,
        "wanpengli@tencent.com" <wanpengli@tencent.com>
Thread-Index: AQHXUl+DVXrUInoPkUqUWhsxRdGR0qr3AMQAgABNL4CAAWobAA==
Date:   Fri, 28 May 2021 10:44:51 +0000
Message-ID: <6af2f61ff6a1a0dc83690bb39f4e3270174264f4.camel@amazon.com>
References: <20210526184418.28881-1-ilstam@amazon.com>
         <20210526184418.28881-10-ilstam@amazon.com>
         <faa225b3b7518feea7df0ee69d6bf386a04824dc.camel@amazon.com>
         <9e971115-5634-e64e-72b6-5e41c024c796@redhat.com>
In-Reply-To: <9e971115-5634-e64e-72b6-5e41c024c796@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.43.166.129]
Content-Type: text/plain; charset="utf-8"
Content-ID: <5F8BA38BC4DD5F468F0212CF1205EEC7@amazon.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gVGh1LCAyMDIxLTA1LTI3IGF0IDE1OjA4ICswMjAwLCBQYW9sbyBCb256aW5pIHdyb3RlOg0K
PiBPbiAyNy8wNS8yMSAxMDozMywgU3RhbWF0aXMsIElsaWFzIHdyb3RlOg0KPiA+ID4gICAjaWZk
ZWYgQ09ORklHX1g4Nl82NA0KPiA+ID4gQEAgLTEwNDQ0LDYgKzEwNDYxLDcgQEAgdm9pZCBrdm1f
YXJjaF92Y3B1X3Bvc3RjcmVhdGUoc3RydWN0IGt2bV92Y3B1ICp2Y3B1KQ0KPiA+ID4gICAgICAg
ICAgICAgIHJldHVybjsNCj4gPiA+ICAgICAgdmNwdV9sb2FkKHZjcHUpOw0KPiA+ID4gICAgICBr
dm1fc3luY2hyb25pemVfdHNjKHZjcHUsIDApOw0KPiA+ID4gKyAgICBrdm1fdmNwdV93cml0ZV90
c2NfbXVsdGlwbGllcih2Y3B1LCBrdm1fZGVmYXVsdF90c2Nfc2NhbGluZ19yYXRpbyk7DQo+ID4g
DQo+ID4gSG1tLCBJJ20gYWN0dWFsbHkgdGhpbmtpbmcgbm93IHRoYXQgdGhpcyBtaWdodCBub3Qg
YmUgY29ycmVjdC4gRm9yIGV4YW1wbGUgaW4NCj4gPiBjYXNlIHdlIGhvdHBsdWcgYSBuZXcgdkNQ
VSBidXQgdGhlIG90aGVyIHZDUFVzIGRvbid0IHVzZSB0aGUgZGVmYXVsdCByYXRpby4NCj4gDQo+
IEl0IGlzIGNvcnJlY3QsIHRoZSBUU0MgZnJlcXVlbmN5IGNhbiBiZSBzZXQgcGVyIENQVSAod2hp
Y2ggaXMgdXNlbGVzcw0KPiBleGNlcHQgcG9zc2libHkgZm9yIGRlYnVnZ2luZyBPUyB0aW1la2Vl
cGluZywgYnV0IHN0aWxsKS4gIFNvLCB0aGUNCj4gZGVmYXVsdCBrSHogYWZ0ZXIgaG90cGx1ZyBp
cyB0aGUgaG9zdCBmcmVxdWVuY3kuDQo+IA0KPiBJdCBkb2Vzbid0IHJlYWxseSBtYXR0ZXIgYmVj
YXVzZSBpdCBvbmx5IGFmZmVjdHMgdGhlIGZpeGVkIGRlbHRhIGJldHdlZW4NCj4gdGhlIGhvdHBs
dWdnZWQgQ1BVIGFuZCB0aGUgb3RoZXJzIGFzIHNvb24gYXMgdXNlcnNwYWNlIHNldHMgdGhlDQo+
IGZyZXF1ZW5jeSB0byB0aGUgY29ycmVjdCB2YWx1ZS4NCj4gDQo+IFBhb2xvDQo+IA0KDQpTbyB0
aGlzIHBhdGNoIGlzIHdyb25nIGFueXdheS4gDQoNCmt2bV9hcmNoX3ZjcHVfY3JlYXRlKCkgZG9l
cyBhIGt2bV9zZXRfdHNjX2toeih2Y3B1LCBtYXhfdHNjX2toeikgd2hlbg0KaW5pdGlhbGl6aW5n
IHRoZSB2Y3B1LiBUaGlzIHdvdWxkbid0IG5vcm1hbGx5IHJlc3VsdCBpbiBhIFZNV1JJVEUsIGJ1
dCBub3cNCihhZnRlciBhcHBseWluZyBwYXRjaCA5KSBpdCBkb2VzLiBUaGUgcHJvYmxlbSBpcyB0
aGF0IHRoaXMgd3JpdGUgbm93IGhhcHBlbnMgdG9vDQplYXJseSBhbmQgaXQgcmFpc2VzIGFuIGV4
Y2VwdGlvbi4gVG8gZml4IHRoaXMsIHRoYXQgbGluZSBuZWVkcyB0byBiZSBtb3ZlZCB0bw0Ka3Zt
X2FyY2hfdmNwdV9wb3N0Y3JlYXRlKCkgKGxpa2UgYWJvdmUpIGJ1dCBiZWZvcmUgY2FsbGluZw0K
a3ZtX3N5bmNocm9uaXplX3RzYyh2Y3B1LCAwKS4NCg0KSSB3aWxsIHJlLXN1Ym1pdCB0aGlzIHBh
dGNoIHdpdGggdGhlIGZpeC4NCg0KQmVzdCwNCklsaWFzDQoNCg0K
