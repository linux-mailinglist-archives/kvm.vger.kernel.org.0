Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCF9A31404C
	for <lists+kvm@lfdr.de>; Mon,  8 Feb 2021 21:22:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236774AbhBHUVv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Feb 2021 15:21:51 -0500
Received: from smtp-fw-2101.amazon.com ([72.21.196.25]:4995 "EHLO
        smtp-fw-2101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236779AbhBHUVg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 Feb 2021 15:21:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.uk; i=@amazon.co.uk; q=dns/txt;
  s=amazon201209; t=1612815696; x=1644351696;
  h=from:to:cc:date:message-id:references:in-reply-to:
   content-id:mime-version:content-transfer-encoding:subject;
  bh=fgcIMRUI3QdGH+pY6oWx29TkvTBQmqKzczCE6mm7lm8=;
  b=Zr0rKljfA4xCMjs7gsd3rbmgC8egwvZFBOcHn04YxfJItXt2boxNwpGQ
   5yDYwOlisWpqSMNG2caeSwcf+TQl5J+deYqrw8Zeb5rIqUwUZxOioFEJr
   j6invn9Lld4D/o1bngd7P1QF171nDLhrSPxYqHhGepmhZHO7d790qvYD9
   E=;
X-IronPort-AV: E=Sophos;i="5.81,163,1610409600"; 
   d="scan'208";a="80547423"
Subject: Re: [PATCH] KVM: x86/xen: Use hva_t for holding hypercall page address
Thread-Topic: [PATCH] KVM: x86/xen: Use hva_t for holding hypercall page address
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-1a-807d4a99.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-2101.iad2.amazon.com with ESMTP; 08 Feb 2021 20:20:49 +0000
Received: from EX13MTAUEE001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-1a-807d4a99.us-east-1.amazon.com (Postfix) with ESMTPS id B93B7A1EC2;
        Mon,  8 Feb 2021 20:20:45 +0000 (UTC)
Received: from EX13D08UEB001.ant.amazon.com (10.43.60.245) by
 EX13MTAUEE001.ant.amazon.com (10.43.62.200) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 8 Feb 2021 20:20:44 +0000
Received: from EX13D08UEB001.ant.amazon.com (10.43.60.245) by
 EX13D08UEB001.ant.amazon.com (10.43.60.245) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 8 Feb 2021 20:20:44 +0000
Received: from EX13D08UEB001.ant.amazon.com ([10.43.60.245]) by
 EX13D08UEB001.ant.amazon.com ([10.43.60.245]) with mapi id 15.00.1497.010;
 Mon, 8 Feb 2021 20:20:44 +0000
From:   "Woodhouse, David" <dwmw@amazon.co.uk>
To:     "seanjc@google.com" <seanjc@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>
CC:     "jmattson@google.com" <jmattson@google.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "joao.m.martins@oracle.com" <joao.m.martins@oracle.com>,
        "wanpengli@tencent.com" <wanpengli@tencent.com>
Thread-Index: AQHW/lc3NGecPBTL0U6JCWHR2wKbO6pOsxMA
Date:   Mon, 8 Feb 2021 20:20:44 +0000
Message-ID: <303f907814d75e2f3bdec01564be745d312356d1.camel@amazon.co.uk>
References: <20210208201502.1239867-1-seanjc@google.com>
In-Reply-To: <20210208201502.1239867-1-seanjc@google.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.43.161.146]
Content-Type: text/plain; charset="utf-8"
Content-ID: <BF36EC6D65320C4A84FA7AA029B7800A@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gTW9uLCAyMDIxLTAyLTA4IGF0IDEyOjE1IC0wODAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBVc2UgaHZhX3QsIGEuay5hLiB1bnNpZ25lZCBsb25nLCBmb3IgdGhlIGxvY2FsIHZh
cmlhYmxlIHRoYXQgaG9sZHMgdGhlDQo+IGh5cGVyY2FsbCBwYWdlIGFkZHJlc3MuICBPbiAzMi1i
aXQgS1ZNLCBnY2MgY29tcGxhaW5zIGFib3V0IHVzaW5nIGEgdTY0DQo+IGR1ZSB0byB0aGUgaW1w
bGljaXQgY2FzdCBmcm9tIGEgNjQtYml0IHZhbHVlIHRvIGEgMzItYml0IHBvaW50ZXIuDQo+IA0K
PiAgIGFyY2gveDg2L2t2bS94ZW4uYzogSW4gZnVuY3Rpb24g4oCYa3ZtX3hlbl93cml0ZV9oeXBl
cmNhbGxfcGFnZeKAmToNCj4gICBhcmNoL3g4Ni9rdm0veGVuLmM6MzAwOjIyOiBlcnJvcjogY2Fz
dCB0byBwb2ludGVyIGZyb20gaW50ZWdlciBvZg0KPiAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgIGRpZmZlcmVudCBzaXplIFstV2Vycm9yPWludC10by1wb2ludGVyLWNhc3RdDQo+ICAgMzAw
IHwgICBwYWdlID0gbWVtZHVwX3VzZXIoKHU4IF9fdXNlciAqKWJsb2JfYWRkciwgUEFHRV9TSVpF
KTsNCg0KVGhhbmtzLg0KDQpBY2tlZC1ieTogRGF2aWQgV29vZGhvdXNlIDxkd213QGFtYXpvbi5j
by51az4NCg0KPiBDYzogSm9hbyBNYXJ0aW5zIDxqb2FvLm0ubWFydGluc0BvcmFjbGUuY29tPg0K
PiBDYzogRGF2aWQgV29vZGhvdXNlIDxkd213QGFtYXpvbi5jby51az4NCj4gRml4ZXM6IDIzMjAw
YjdhMzBkZSAoIktWTTogeDg2L3hlbjogaW50ZXJjZXB0IHhlbiBoeXBlcmNhbGxzIGlmIGVuYWJs
ZWQiKQ0KPiBTaWduZWQtb2ZmLWJ5OiBTZWFuIENocmlzdG9waGVyc29uIDxzZWFuamNAZ29vZ2xl
LmNvbT4NCj4gLS0tDQo+ICBhcmNoL3g4Ni9rdm0veGVuLmMgfCA4ICsrKysrKy0tDQo+ICAxIGZp
bGUgY2hhbmdlZCwgNiBpbnNlcnRpb25zKCspLCAyIGRlbGV0aW9ucygtKQ0KPiANCj4gZGlmZiAt
LWdpdCBhL2FyY2gveDg2L2t2bS94ZW4uYyBiL2FyY2gveDg2L2t2bS94ZW4uYw0KPiBpbmRleCAy
Y2VlMDM3NjQ1NWMuLmRlZGExYmE4YzE4YSAxMDA2NDQNCj4gLS0tIGEvYXJjaC94ODYva3ZtL3hl
bi5jDQo+ICsrKyBiL2FyY2gveDg2L2t2bS94ZW4uYw0KPiBAQCAtMjg2LDggKzI4NiwxMiBAQCBp
bnQga3ZtX3hlbl93cml0ZV9oeXBlcmNhbGxfcGFnZShzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUsIHU2
NCBkYXRhKQ0KPiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIHJldHVybiAxOw0KPiAg
ICAgICAgICAgICAgICAgfQ0KPiAgICAgICAgIH0gZWxzZSB7DQo+IC0gICAgICAgICAgICAgICB1
NjQgYmxvYl9hZGRyID0gbG0gPyBrdm0tPmFyY2gueGVuX2h2bV9jb25maWcuYmxvYl9hZGRyXzY0
DQo+IC0gICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgOiBrdm0tPmFyY2gueGVuX2h2
bV9jb25maWcuYmxvYl9hZGRyXzMyOw0KPiArICAgICAgICAgICAgICAgLyoNCj4gKyAgICAgICAg
ICAgICAgICAqIE5vdGUsIHRydW5jYXRpb24gaXMgYSBub24taXNzdWUgYXMgJ2xtJyBpcyBndWFy
YW50ZWVkIHRvIGJlDQo+ICsgICAgICAgICAgICAgICAgKiBmYWxzZSBmb3IgYSAzMi1iaXQga2Vy
bmVsLCBpLmUuIHdoZW4gaHZhX3QgaXMgb25seSA0IGJ5dGVzLg0KPiArICAgICAgICAgICAgICAg
ICovDQo+ICsgICAgICAgICAgICAgICBodmFfdCBibG9iX2FkZHIgPSBsbSA/IGt2bS0+YXJjaC54
ZW5faHZtX2NvbmZpZy5ibG9iX2FkZHJfNjQNCj4gKyAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgIDoga3ZtLT5hcmNoLnhlbl9odm1fY29uZmlnLmJsb2JfYWRkcl8zMjsNCj4gICAg
ICAgICAgICAgICAgIHU4IGJsb2Jfc2l6ZSA9IGxtID8ga3ZtLT5hcmNoLnhlbl9odm1fY29uZmln
LmJsb2Jfc2l6ZV82NA0KPiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgOiBrdm0t
PmFyY2gueGVuX2h2bV9jb25maWcuYmxvYl9zaXplXzMyOw0KPiAgICAgICAgICAgICAgICAgdTgg
KnBhZ2U7DQo+IC0tDQo+IDIuMzAuMC40NzguZzhhMGQxNzhjMDEtZ29vZw0KPiANCg0KCgoKQW1h
em9uIERldmVsb3BtZW50IENlbnRyZSAoTG9uZG9uKSBMdGQuIFJlZ2lzdGVyZWQgaW4gRW5nbGFu
ZCBhbmQgV2FsZXMgd2l0aCByZWdpc3RyYXRpb24gbnVtYmVyIDA0NTQzMjMyIHdpdGggaXRzIHJl
Z2lzdGVyZWQgb2ZmaWNlIGF0IDEgUHJpbmNpcGFsIFBsYWNlLCBXb3JzaGlwIFN0cmVldCwgTG9u
ZG9uIEVDMkEgMkZBLCBVbml0ZWQgS2luZ2RvbS4KCgo=

