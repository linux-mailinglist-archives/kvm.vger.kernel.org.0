Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66ACC3759A7
	for <lists+kvm@lfdr.de>; Thu,  6 May 2021 19:48:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236262AbhEFRtb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 May 2021 13:49:31 -0400
Received: from smtp-fw-9102.amazon.com ([207.171.184.29]:10338 "EHLO
        smtp-fw-9102.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236042AbhEFRt2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 May 2021 13:49:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1620323310; x=1651859310;
  h=from:to:cc:date:message-id:references:in-reply-to:
   content-id:content-transfer-encoding:mime-version:subject;
  bh=hjIFP8Th9zm4cQ0vMItVvNk0EEH3BVsWYq91C+wnqdA=;
  b=epk8DEXnn64AkK2hORmLK8rBUKms5iJ6Ld4PaL7P226JLZYUKH8oVGf+
   yiUO9V7JfDQc2jIIBYjc9hPwGFsQ/YU39pxsfkeQmLX5BWMwF8V4EVLqi
   ga6FykMYjG6aDvMPLZkUo5jvJmysuaUSdOCADmASwEVXWu+QUKPcgS4YB
   E=;
X-IronPort-AV: E=Sophos;i="5.82,278,1613433600"; 
   d="scan'208";a="133692844"
Subject: Re: [PATCH 0/8] KVM: VMX: Implement nested TSC scaling
Thread-Topic: [PATCH 0/8] KVM: VMX: Implement nested TSC scaling
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-2c-397e131e.us-west-2.amazon.com) ([10.25.36.210])
  by smtp-border-fw-9102.sea19.amazon.com with ESMTP; 06 May 2021 17:48:30 +0000
Received: from EX13MTAUEE001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-2c-397e131e.us-west-2.amazon.com (Postfix) with ESMTPS id 4813EA17F1;
        Thu,  6 May 2021 17:48:29 +0000 (UTC)
Received: from EX13D08UEB004.ant.amazon.com (10.43.60.142) by
 EX13MTAUEE001.ant.amazon.com (10.43.62.200) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Thu, 6 May 2021 17:48:27 +0000
Received: from EX13D18EUA001.ant.amazon.com (10.43.165.58) by
 EX13D08UEB004.ant.amazon.com (10.43.60.142) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Thu, 6 May 2021 17:48:27 +0000
Received: from EX13D18EUA001.ant.amazon.com ([10.43.165.58]) by
 EX13D18EUA001.ant.amazon.com ([10.43.165.58]) with mapi id 15.00.1497.015;
 Thu, 6 May 2021 17:48:26 +0000
From:   "Stamatis, Ilias" <ilstam@amazon.com>
To:     "jmattson@google.com" <jmattson@google.com>,
        "ilstam@mailbox.org" <ilstam@mailbox.org>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Woodhouse, David" <dwmw@amazon.co.uk>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "mtosatti@redhat.com" <mtosatti@redhat.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "zamsden@gmail.com" <zamsden@gmail.com>,
        "seanjc@google.com" <seanjc@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "wanpengli@tencent.com" <wanpengli@tencent.com>
Thread-Index: AQHXQmOvrYg/PUZgSkCUzBXC0MvHl6rWsk8AgAAI8QA=
Date:   Thu, 6 May 2021 17:48:26 +0000
Message-ID: <fccb8b01aadfb7e53f8711100bc10dc1c98c5cd5.camel@amazon.com>
References: <20210506103228.67864-1-ilstam@mailbox.org>
         <CALMp9eSNHf=vmqeer+ZkRa3NhJoLMbEO+OZJaG9qf+2+TQ2grA@mail.gmail.com>
In-Reply-To: <CALMp9eSNHf=vmqeer+ZkRa3NhJoLMbEO+OZJaG9qf+2+TQ2grA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.43.165.65]
Content-Type: text/plain; charset="utf-8"
Content-ID: <835FC84252A86D44B6FCA5C3D9324107@amazon.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gVGh1LCAyMDIxLTA1LTA2IGF0IDEwOjE2IC0wNzAwLCBKaW0gTWF0dHNvbiB3cm90ZToNCj4g
T24gVGh1LCBNYXkgNiwgMjAyMSBhdCAzOjM0IEFNIDxpbHN0YW1AbWFpbGJveC5vcmc+IHdyb3Rl
Og0KPiA+IA0KPiA+IEZyb206IElsaWFzIFN0YW1hdGlzIDxpbHN0YW1AYW1hem9uLmNvbT4NCj4g
PiANCj4gPiBLVk0gY3VycmVudGx5IHN1cHBvcnRzIGhhcmR3YXJlLWFzc2lzdGVkIFRTQyBzY2Fs
aW5nIGJ1dCBvbmx5IGZvciBMMQ0KPiA+IGFuZCBpdA0KPiA+IGRvZXNuJ3QgZXhwb3NlIHRoZSBm
ZWF0dXJlIHRvIG5lc3RlZCBndWVzdHMuIFRoaXMgcGF0Y2ggc2VyaWVzIGFkZHMNCj4gPiBzdXBw
b3J0IGZvcg0KPiA+IG5lc3RlZCBUU0Mgc2NhbGluZyBhbmQgYWxsb3dzIGJvdGggTDEgYW5kIEwy
IHRvIGJlIHNjYWxlZCB3aXRoDQo+ID4gZGlmZmVyZW50DQo+ID4gc2NhbGluZyBmYWN0b3JzLg0K
PiA+IA0KPiA+IFdoZW4gc2NhbGluZyBhbmQgb2Zmc2V0dGluZyBpcyBhcHBsaWVkLCB0aGUgVFND
IGZvciB0aGUgZ3Vlc3QgaXMNCj4gPiBjYWxjdWxhdGVkIGFzOg0KPiA+IA0KPiA+IChUU0MgKiBt
dWx0aXBsaWVyID4+IDQ4KSArIG9mZnNldA0KPiA+IA0KPiA+IFdpdGggbmVzdGVkIHNjYWxpbmcg
dGhlIHZhbHVlcyBpbiBWTUNTMDEgYW5kIFZNQ1MxMiBuZWVkIHRvIGJlDQo+ID4gbWVyZ2VkDQo+
ID4gdG9nZXRoZXIgYW5kIHN0b3JlZCBpbiBWTUNTMDIuDQo+ID4gDQo+ID4gVGhlIFZNQ1MwMiB2
YWx1ZXMgYXJlIGNhbGN1bGF0ZWQgYXMgZm9sbG93czoNCj4gPiANCj4gPiBvZmZzZXRfMDIgPSAo
KG9mZnNldF8wMSAqIG11bHRfMTIpID4+IDQ4KSArIG9mZnNldF8xMg0KPiA+IG11bHRfMDIgPSAo
bXVsdF8wMSAqIG11bHRfMTIpID4+IDQ4DQo+ID4gDQo+ID4gVGhlIGxhc3QgcGF0Y2ggb2YgdGhl
IHNlcmllcyBhZGRzIGEgS1ZNIHNlbGZ0ZXN0Lg0KPiANCj4gV2lsbCB5b3UgYmUgZG9pbmcgdGhl
IHNhbWUgZm9yIFNWTT8gVGhlIGxhc3QgdGltZSBJIHRyaWVkIHRvIGFkZCBhDQo+IG5lc3RlZCB2
aXJ0dWFsaXphdGlvbiBmZWF0dXJlIGZvciBJbnRlbCBvbmx5LCBQYW9sbyByYXBwZWQgbXkga251
Y2tsZXMNCj4gd2l0aCBhIHJ1bGVyLg0KDQpZZXMsIEkgY2FuIHRyeSBkbyB0aGlzLCBpZiBpdCdz
IG5vdCBtdWNoIG1vcmUgY29tcGxpY2F0ZWQsIG9uY2UgSSBnZXQNCmFjY2VzcyB0byBBTUQgaGFy
ZHdhcmUuIA0KDQpCdXQgSSBzdXBwb3NlIHRoaXMgc2VyaWVzIGlzIHN0YW5kYWxvbmUgYW5kIGNv
dWxkIGJlIG1lcmdlZCBzZXBhcmF0ZWx5Pw0KQnkgdGFraW5nIGEgcXVpY2sgbG9vayBpdCBzZWVt
cyB0aGF0IFNWTSBleHBvc2VzIGZhciBsZXNzIGZlYXR1cmVzIHRvDQpuZXN0ZWQgZ3Vlc3RzIHRo
YW4gVk1YIGRvZXMgYW55d2F5Lg0KDQpJbGlhcw0K
