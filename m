Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B355737AD4E
	for <lists+kvm@lfdr.de>; Tue, 11 May 2021 19:45:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231454AbhEKRqN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 May 2021 13:46:13 -0400
Received: from smtp-fw-80006.amazon.com ([99.78.197.217]:6824 "EHLO
        smtp-fw-80006.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231329AbhEKRqL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 May 2021 13:46:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1620755105; x=1652291105;
  h=from:to:cc:date:message-id:references:in-reply-to:
   content-id:content-transfer-encoding:mime-version:subject;
  bh=SuhIQF7gweM02DTFAx4OWR4mEqPhWkbivsIo31l7TcY=;
  b=U0B5T8sjbYL/zVLeGpyfp3yW+0R2k6tKnUQhsAkeM1/j83W8HwujUyYz
   BK+kUaO+TAcvp32LuwCQh6s1X3BsF7v267NgWVzoRmKOnqMjLMGCD6c5T
   Ft/nu+mpnGOkQ6B6hNx0T18f9iQVw8hPAxbN+2MLny2fWhz+O6SOlm6SD
   0=;
X-IronPort-AV: E=Sophos;i="5.82,291,1613433600"; 
   d="scan'208";a="826166"
Subject: Re: [PATCH 6/8] KVM: VMX: Make vmx_write_l1_tsc_offset() work with nested
 TSC scaling
Thread-Topic: [PATCH 6/8] KVM: VMX: Make vmx_write_l1_tsc_offset() work with nested TSC
 scaling
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-1e-27fb8269.us-east-1.amazon.com) ([10.25.36.210])
  by smtp-border-fw-80006.pdx80.corp.amazon.com with ESMTP; 11 May 2021 17:44:57 +0000
Received: from EX13MTAUEE001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-1e-27fb8269.us-east-1.amazon.com (Postfix) with ESMTPS id 8BB94A1C23;
        Tue, 11 May 2021 17:44:53 +0000 (UTC)
Received: from EX13D08UEE004.ant.amazon.com (10.43.62.182) by
 EX13MTAUEE001.ant.amazon.com (10.43.62.226) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 11 May 2021 17:44:52 +0000
Received: from EX13D18EUA001.ant.amazon.com (10.43.165.58) by
 EX13D08UEE004.ant.amazon.com (10.43.62.182) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 11 May 2021 17:44:51 +0000
Received: from EX13D18EUA001.ant.amazon.com ([10.43.165.58]) by
 EX13D18EUA001.ant.amazon.com ([10.43.165.58]) with mapi id 15.00.1497.015;
 Tue, 11 May 2021 17:44:50 +0000
From:   "Stamatis, Ilias" <ilstam@amazon.com>
To:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "mlevitsk@redhat.com" <mlevitsk@redhat.com>,
        "ilstam@mailbox.org" <ilstam@mailbox.org>
CC:     "jmattson@google.com" <jmattson@google.com>,
        "Woodhouse, David" <dwmw@amazon.co.uk>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "mtosatti@redhat.com" <mtosatti@redhat.com>,
        "zamsden@gmail.com" <zamsden@gmail.com>,
        "seanjc@google.com" <seanjc@google.com>,
        "wanpengli@tencent.com" <wanpengli@tencent.com>
Thread-Index: AQHXQmO8SiBk4OMk60G+2dhJ+Mah0qrcw0EAgAAlhICAAVlOAIAAU9QA
Date:   Tue, 11 May 2021 17:44:50 +0000
Message-ID: <659ed5bcd9e4f43da17b6956603b21b9253eba77.camel@amazon.com>
References: <20210506103228.67864-1-ilstam@mailbox.org>
         <20210506103228.67864-7-ilstam@mailbox.org>
         <a83fa70e3111f9c9bcbc5204569d084229815b9a.camel@redhat.com>
         <9e0973a1adef19158e0c09a642b8c733556e272c.camel@amazon.com>
         <875fa1ff9a85ff601a05030eaa24a1db45a71f36.camel@redhat.com>
In-Reply-To: <875fa1ff9a85ff601a05030eaa24a1db45a71f36.camel@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.43.164.198]
Content-Type: text/plain; charset="utf-8"
Content-ID: <E7A3E2ACB3DE3F4DB5FE6DF3712DC3AE@amazon.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gVHVlLCAyMDIxLTA1LTExIGF0IDE1OjQ0ICswMzAwLCBNYXhpbSBMZXZpdHNreSB3cm90ZToN
Cj4gT24gTW9uLCAyMDIxLTA1LTEwIGF0IDE2OjA4ICswMDAwLCBTdGFtYXRpcywgSWxpYXMgd3Jv
dGU6DQo+ID4gT24gTW9uLCAyMDIxLTA1LTEwIGF0IDE2OjU0ICswMzAwLCBNYXhpbSBMZXZpdHNr
eSB3cm90ZToNCj4gPiA+IE9uIFRodSwgMjAyMS0wNS0wNiBhdCAxMDozMiArMDAwMCwgaWxzdGFt
QG1haWxib3gub3JnIHdyb3RlOg0KPiA+ID4gPiBGcm9tOiBJbGlhcyBTdGFtYXRpcyA8aWxzdGFt
QGFtYXpvbi5jb20+DQo+ID4gPiA+IA0KPiA+ID4gPiBDYWxjdWxhdGluZyB0aGUgY3VycmVudCBU
U0Mgb2Zmc2V0IGlzIGRvbmUgZGlmZmVyZW50bHkgd2hlbiBuZXN0ZWQgVFNDDQo+ID4gPiA+IHNj
YWxpbmcgaXMgdXNlZC4NCj4gPiA+ID4gDQo+ID4gPiA+IFNpZ25lZC1vZmYtYnk6IElsaWFzIFN0
YW1hdGlzIDxpbHN0YW1AYW1hem9uLmNvbT4NCj4gPiA+ID4gLS0tDQo+ID4gPiA+ICBhcmNoL3g4
Ni9rdm0vdm14L3ZteC5jIHwgMjYgKysrKysrKysrKysrKysrKysrKystLS0tLS0NCj4gPiA+ID4g
IDEgZmlsZSBjaGFuZ2VkLCAyMCBpbnNlcnRpb25zKCspLCA2IGRlbGV0aW9ucygtKQ0KPiA+ID4g
PiANCj4gPiA+ID4gZGlmZiAtLWdpdCBhL2FyY2gveDg2L2t2bS92bXgvdm14LmMgYi9hcmNoL3g4
Ni9rdm0vdm14L3ZteC5jDQo+ID4gPiA+IGluZGV4IDQ5MjQxNDIzYjg1NC4uZGY3ZGMwZTRjOTAz
IDEwMDY0NA0KPiA+ID4gPiAtLS0gYS9hcmNoL3g4Ni9rdm0vdm14L3ZteC5jDQo+ID4gPiA+ICsr
KyBiL2FyY2gveDg2L2t2bS92bXgvdm14LmMNCj4gPiA+ID4gQEAgLTE3OTcsMTAgKzE3OTcsMTYg
QEAgc3RhdGljIHZvaWQgc2V0dXBfbXNycyhzdHJ1Y3QgdmNwdV92bXggKnZteCkNCj4gPiA+ID4g
ICAgICAgICAgICAgICB2bXhfdXBkYXRlX21zcl9iaXRtYXAoJnZteC0+dmNwdSk7DQo+ID4gPiA+
ICB9DQo+ID4gPiA+IA0KPiA+ID4gPiAtc3RhdGljIHU2NCB2bXhfd3JpdGVfbDFfdHNjX29mZnNl
dChzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUsIHU2NCBvZmZzZXQpDQo+ID4gPiA+ICsvKg0KPiA+ID4g
PiArICogVGhpcyBmdW5jdGlvbiByZWNlaXZlcyB0aGUgcmVxdWVzdGVkIG9mZnNldCBmb3IgTDEg
YXMgYW4gYXJndW1lbnQgYnV0IGl0DQo+ID4gPiA+ICsgKiBhY3R1YWxseSB3cml0ZXMgdGhlICJj
dXJyZW50IiB0c2Mgb2Zmc2V0IHRvIHRoZSBWTUNTIGFuZCByZXR1cm5zIGl0LiBUaGUNCj4gPiA+
ID4gKyAqIGN1cnJlbnQgb2Zmc2V0IG1pZ2h0IGJlIGRpZmZlcmVudCBpbiBjYXNlIGFuIEwyIGd1
ZXN0IGlzIGN1cnJlbnRseSBydW5uaW5nDQo+ID4gPiA+ICsgKiBhbmQgaXRzIFZNQ1MwMiBpcyBs
b2FkZWQuDQo+ID4gPiA+ICsgKi8NCj4gPiA+IA0KPiA+ID4gKE5vdCByZWxhdGVkIHRvIHRoaXMg
cGF0Y2gpIEl0IG1pZ2h0IGJlIGEgZ29vZCBpZGVhIHRvIHJlbmFtZSB0aGlzIGNhbGxiYWNrDQo+
ID4gPiBpbnN0ZWFkIG9mIHRoaXMgY29tbWVudCwgYnV0IEkgYW0gbm90IHN1cmUgYWJvdXQgaXQu
DQo+ID4gPiANCj4gPiANCj4gPiBZZXMhIEkgd2FzIHBsYW5uaW5nIHRvIGRvIHRoaXMgb24gdjIg
YW55d2F5IGFzIHRoZSBuYW1lIG9mIHRoYXQgZnVuY3Rpb24NCj4gPiBpcyBjb21wbGV0ZWx5IG1p
c2xlYWRpbmcvd3JvbmcgSU1ITy4NCj4gPiANCj4gPiBJIHRoaW5rIHRoYXQgZXZlbiB0aGUgY29t
bWVudCBpbnNpZGUgaXQgdGhhdCBleHBsYWlucyB0aGF0IHdoZW4gTDENCj4gPiBkb2Vzbid0IHRy
YXAgV1JNU1IgdGhlbiBMMiBUU0Mgd3JpdGVzIG92ZXJ3cml0ZSBMMSdzIFRTQyBpcyBtaXNwbGFj
ZWQuDQo+ID4gSXQgc2hvdWxkIGdvIG9uZSBvciBtb3JlIGxldmVscyBhYm92ZSBJIGJlbGlldmUu
DQo+ID4gDQo+ID4gVGhpcyBmdW5jdGlvbiBzaW1wbHkNCj4gPiB1cGRhdGVzIHRoZSBUU0Mgb2Zm
c2V0IGluIHRoZSBjdXJyZW50IFZNQ1MgZGVwZW5kaW5nIG9uIHdoZXRoZXIgTDEgb3IgTDINCj4g
PiBpcyBleGVjdXRpbmcuDQo+ID4gDQo+ID4gPiA+ICtzdGF0aWMgdTY0IHZteF93cml0ZV9sMV90
c2Nfb2Zmc2V0KHN0cnVjdCBrdm1fdmNwdSAqdmNwdSwgdTY0IGwxX29mZnNldCkNCj4gPiA+ID4g
IHsNCj4gPiA+ID4gICAgICAgc3RydWN0IHZtY3MxMiAqdm1jczEyID0gZ2V0X3ZtY3MxMih2Y3B1
KTsNCj4gPiA+ID4gLSAgICAgdTY0IGdfdHNjX29mZnNldCA9IDA7DQo+ID4gPiA+ICsgICAgIHU2
NCBjdXJfb2Zmc2V0ID0gbDFfb2Zmc2V0Ow0KPiA+ID4gPiANCj4gPiA+ID4gICAgICAgLyoNCj4g
PiA+ID4gICAgICAgICogV2UncmUgaGVyZSBpZiBMMSBjaG9zZSBub3QgdG8gdHJhcCBXUk1TUiB0
byBUU0MuIEFjY29yZGluZw0KPiA+ID4gPiBAQCAtMTgwOSwxMSArMTgxNSwxOSBAQCBzdGF0aWMg
dTY0IHZteF93cml0ZV9sMV90c2Nfb2Zmc2V0KHN0cnVjdCBrdm1fdmNwdSAqdmNwdSwgdTY0IG9m
ZnNldCkNCj4gPiA+ID4gICAgICAgICogdG8gdGhlIG5ld2x5IHNldCBUU0MgdG8gZ2V0IEwyJ3Mg
VFNDLg0KPiA+ID4gPiAgICAgICAgKi8NCj4gPiA+ID4gICAgICAgaWYgKGlzX2d1ZXN0X21vZGUo
dmNwdSkgJiYNCj4gPiA+ID4gLSAgICAgICAgICh2bWNzMTItPmNwdV9iYXNlZF92bV9leGVjX2Nv
bnRyb2wgJiBDUFVfQkFTRURfVVNFX1RTQ19PRkZTRVRUSU5HKSkNCj4gPiA+ID4gLSAgICAgICAg
ICAgICBnX3RzY19vZmZzZXQgPSB2bWNzMTItPnRzY19vZmZzZXQ7DQo+ID4gPiA+ICsgICAgICAg
ICAodm1jczEyLT5jcHVfYmFzZWRfdm1fZXhlY19jb250cm9sICYgQ1BVX0JBU0VEX1VTRV9UU0Nf
T0ZGU0VUVElORykpIHsNCj4gPiA+ID4gKyAgICAgICAgICAgICBpZiAodm1jczEyLT5zZWNvbmRh
cnlfdm1fZXhlY19jb250cm9sICYgU0VDT05EQVJZX0VYRUNfVFNDX1NDQUxJTkcpIHsNCj4gPiA+
ID4gKyAgICAgICAgICAgICAgICAgICAgIGN1cl9vZmZzZXQgPSBrdm1fY29tcHV0ZV8wMl90c2Nf
b2Zmc2V0KA0KPiA+ID4gPiArICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIGwx
X29mZnNldCwNCj4gPiA+ID4gKyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICB2
bWNzMTItPnRzY19tdWx0aXBsaWVyLA0KPiA+ID4gPiArICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgIHZtY3MxMi0+dHNjX29mZnNldCk7DQo+ID4gPiA+ICsgICAgICAgICAgICAg
fSBlbHNlIHsNCj4gPiA+ID4gKyAgICAgICAgICAgICAgICAgICAgIGN1cl9vZmZzZXQgPSBsMV9v
ZmZzZXQgKyB2bWNzMTItPnRzY19vZmZzZXQ7DQo+ID4gPiA+ICsgICAgICAgICAgICAgfQ0KPiA+
ID4gPiArICAgICB9DQo+ID4gPiA+IA0KPiA+ID4gPiAtICAgICB2bWNzX3dyaXRlNjQoVFNDX09G
RlNFVCwgb2Zmc2V0ICsgZ190c2Nfb2Zmc2V0KTsNCj4gPiA+ID4gLSAgICAgcmV0dXJuIG9mZnNl
dCArIGdfdHNjX29mZnNldDsNCj4gPiA+ID4gKyAgICAgdm1jc193cml0ZTY0KFRTQ19PRkZTRVQs
IGN1cl9vZmZzZXQpOw0KPiA+ID4gPiArICAgICByZXR1cm4gY3VyX29mZnNldDsNCj4gPiA+ID4g
IH0NCj4gPiA+ID4gDQo+ID4gPiA+ICAvKg0KPiA+ID4gDQo+ID4gPiBUaGlzIGNvZGUgd291bGQg
YmUgaWRlYWwgdG8gbW92ZSB0byBjb21tb24gY29kZSBhcyBTVk0gd2lsbCBkbyBiYXNpY2FsbHkN
Cj4gPiA+IHRoZSBzYW1lIHRoaW5nLg0KPiA+ID4gRG9lc24ndCBoYXZlIHRvIGJlIGRvbmUgbm93
IHRob3VnaC4NCj4gPiA+IA0KPiA+IA0KPiA+IEhtbSwgaG93IGNhbiB3ZSBkbyB0aGUgZmVhdHVy
ZSBhdmFpbGFiaWxpdHkgY2hlY2tpbmcgaW4gY29tbW9uIGNvZGU/DQo+IA0KPiBXZSBjYW4gYWRk
IGEgdmVuZG9yIGNhbGxiYWNrIGZvciB0aGlzLg0KPiANCj4gSnVzdCBhIGZldyB0aG91Z2h0cyBh
Ym91dCBob3cgSSB0aGluayB3ZSBjYW4gaW1wbGVtZW50DQo+IHRoZSBuZXN0ZWQgVFNDIHNjYWxp
bmcgaW4gKG1vc3RseSkgY29tbW9uIGNvZGU6DQo+IA0KPiANCj4gQXNzdW1pbmcgdGhhdCB0aGUg
Y29tbW9uIGNvZGUga25vd3MgdGhhdDoNCj4gMS4gTmVzdGVkIGd1ZXN0IGlzIHJ1bm5pbmcgKGFs
cmVhZHkgdGhlIGNhc2UpDQo+IA0KPiAyLiBUaGUgZm9ybWF0IG9mIHRoZSBzY2FsaW5nIG11bHRp
cGxpZXIgaXMga25vd24NCj4gKHRoYW5rZnVsbHkgYm90aCBTVk0gYW5kIFZNWCB1c2UgZml4ZWQg
cG9pbnQgYmluYXJ5IG51bWJlci4NCj4gDQo+IFNWTSBpcyB1c2luZyA4LjMyIGZvcm1hdCBhbmQg
Vk1YIHVzaW5nIDE2LjQ4IGZvcm1hdC4NCj4gDQo+IFRoZSBjb21tb24gY29kZSBhbHJlYWR5IGtu
b3dzIHRoaXMgdmlhDQo+IGt2bV9tYXhfdHNjX3NjYWxpbmdfcmF0aW8va3ZtX3RzY19zY2FsaW5n
X3JhdGlvX2ZyYWNfYml0cy4NCj4gDQo+IDMuIHRoZSB2YWx1ZSBvZiBuZXN0ZWQgVFNDIHNjYWxp
bmcgbXVsdGlwbGllcg0KPiBpcyBrbm93biB0byB0aGUgY29tbW9uIGNvZGUuDQo+IA0KPiAoYSBj
YWxsYmFjayB0byBWTVgvU1ZNIGNvZGUgdG8gcXVlcnkgdGhlIFRTQyBzY2FsaW5nIHZhbHVlLA0K
PiBhbmQgaGF2ZSBpdCByZXR1cm4gMSB3aGVuIFRTQyBzY2FsaW5nIGlzIGRpc2FibGVkIHNob3Vs
ZCB3b3JrKQ0KPiANCg0KSSBzdXBwb3NlIHlvdSBtZWFuIHJldHVybiBrdm1fZGVmYXVsdF90c2Nf
c2NhbGluZ19yYXRpbw0KDQo+IA0KPiBUaGVuIHRoZSBjb21tb24gY29kZSBjYW4gZG8gdGhlIHdo
b2xlIHRoaW5nLCBhbmQgb25seQ0KPiBsZXQgdGhlIFNWTS9WTVggY29kZSB3cml0ZSB0aGUgYWN0
dWFsIG11bHRpcGxpZXIuDQo+IA0KPiBBcyBmYXIgYXMgSSBrbm93IG9uIHRoZSBTVk0sIHRoZSBU
U0Mgc2NhbGluZyB3b3JrcyBsaWtlIHRoYXQ6DQo+IA0KPiAxLiBTVk0gaGFzIGEgQ1BVSUQgYml0
IHRvIGluZGljYXRlIHRoYXQgdHNjIHNjYWxpbmcgaXMgc3VwcG9ydGVkLg0KPiAoWDg2X0ZFQVRV
UkVfVFNDUkFURU1TUikNCj4gDQo+IFdoZW4gdGhpcyBiaXQgaXMgc2V0LCBUU0Mgc2NhbGUgcmF0
aW8gaXMgdW5jb25kaXRpb25hbGx5IGVuYWJsZWQgKGJ1dA0KPiBjYW4gYmUganVzdCAxKSwgYW5k
IGl0IGlzIHNldCB2aWEgYSBzcGVjaWFsIE1TUiAoTVNSX0FNRDY0X1RTQ19SQVRJTykNCj4gcmF0
aGVyIHRoYW4gYSBmaWVsZCBpbiBWTUNCIChzb21lb25lIGF0IEFNRCBkaWQgY3V0IGNvcm5lcnMu
Li4pLg0KPiANCj4gSG93ZXZlciBzaW5jZSB0aGUgVFNDIHNjYWxpbmcgaXMgb25seSBlZmZlY3Rp
dmUgd2hlbiBhIGd1ZXN0IGlzIHJ1bm5pbmcsDQo+IHRoYXQgTVNSIGNhbiBiZSB0cmVhdGVkIGFs
bW9zdCBhcyBpZiBpdCB3YXMganVzdCBhbm90aGVyIFZNQ0IgZmllbGQuDQo+IA0KPiBUaGUgVFND
IHNjYWxlIHZhbHVlIGlzIDMyIGJpdCBmcmFjdGlvbiBhbmQgYW5vdGhlciA4IGJpdHMgdGhlIGlu
dGVnZXIgdmFsdWUNCj4gKGFzIG9wcG9zZWQgdG8gNDggYml0IGZyYWN0aW9uIG9uIFZNWCBhbmQg
MTYgYml0cyBpbnRlZ2VyIHZhbHVlKS4NCj4gDQo+IEkgZG9uJ3QgdGhpbmsgdGhhdCB0aGVyZSBh
cmUgYW55IG90aGVyIGRpZmZlcmVuY2VzLg0KPiANCj4gSSBzaG91bGQgYWxzbyBub3RlIHRoYXQg
SSBjYW4gZG8gYWxsIG9mIHRoZSBhYm92ZSBteXNlbGYgaWYNCj4gSSBlbmQgdXAgaW1wbGVtZW50
aW5nIHRoZSBuZXN0ZWQgVFNDIHNjYWxpbmcgb24gQU1EDQo+IHNvIEkgZG9uJ3Qgb2JqZWN0IG11
Y2ggdG8gdGhlIHdheSB0aGF0IHRoaXMgcGF0Y2ggc2VyaWVzIGlzIGRvbmUuDQo+IA0KDQpUaGF0
J3MgZmluZSwgSSB3aWxsIGFkZCB0aGUgY2FsbGJhY2tzIGFuZCBtb3ZlIGV2ZXJ5dGhpbmcgdG8g
Y29tbW9uIGNvZGUuIEFuZA0KdGhlbiB5b3UgY2FuIGZpbGwgdGhlIHN2bS1zcGVjaWZpYyBiaXRz
IGlmIHlvdSB3YW50Lg0KDQpUaGFua3MsDQpJbGlhcw0K
