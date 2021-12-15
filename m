Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C310475108
	for <lists+kvm@lfdr.de>; Wed, 15 Dec 2021 03:40:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239241AbhLOCkG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Dec 2021 21:40:06 -0500
Received: from mga07.intel.com ([134.134.136.100]:26997 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229492AbhLOCkF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Dec 2021 21:40:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1639536005; x=1671072005;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=+WwfR9gaDazUmw+dOUYaohzBoa26XURTVZETStGgRG0=;
  b=ajvsf2NWFwDmScz6KuY4qEm1WyWF5kSUDAO/AJCiVCt9ixtbPBkK5XP0
   yG/FFL+t5JRIHI1raBEYA73UHNLXudr7mSrSGCWq/NmoG2iS8bx9FQLXo
   1ICCNEcqwZbUZs6BeVU0ku4gxT9ODfHoszjoKI2iN/Xhs+rutpBm3jD5f
   9Ijc4YOKJduf944QOx5H6OuF/ZrOsCC15/pQ7QoB7s4ExBqfNcx8LfpJN
   KT5QeAOrphUnCLxUirseJXWShY8gRWvA9sgwuTk+Z4aIqEThMKKEFe/Ge
   MwTDJBGlwHzt74O69MsuMm8bXuqV++SKSPDfZxVo00v7AR/Nb/I7BPrCA
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10198"; a="302508629"
X-IronPort-AV: E=Sophos;i="5.88,207,1635231600"; 
   d="scan'208";a="302508629"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Dec 2021 18:40:05 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,207,1635231600"; 
   d="scan'208";a="518563392"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga008.jf.intel.com with ESMTP; 14 Dec 2021 18:40:02 -0800
Received: from shsmsx603.ccr.corp.intel.com (10.109.6.143) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Tue, 14 Dec 2021 18:40:01 -0800
Received: from shsmsx601.ccr.corp.intel.com (10.109.6.141) by
 SHSMSX603.ccr.corp.intel.com (10.109.6.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Wed, 15 Dec 2021 10:39:59 +0800
Received: from shsmsx601.ccr.corp.intel.com ([10.109.6.141]) by
 SHSMSX601.ccr.corp.intel.com ([10.109.6.141]) with mapi id 15.01.2308.020;
 Wed, 15 Dec 2021 10:39:59 +0800
From:   "Wang, Wei W" <wei.w.wang@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        "Zhong, Yang" <yang.zhong@intel.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>
CC:     "seanjc@google.com" <seanjc@google.com>,
        "Nakajima, Jun" <jun.nakajima@intel.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "jing2.liu@linux.intel.com" <jing2.liu@linux.intel.com>,
        "Liu, Jing2" <jing2.liu@intel.com>,
        "Zeng, Guang" <guang.zeng@intel.com>
Subject: RE: [PATCH 16/19] kvm: x86: Introduce KVM_{G|S}ET_XSAVE2 ioctl
Thread-Topic: [PATCH 16/19] kvm: x86: Introduce KVM_{G|S}ET_XSAVE2 ioctl
Thread-Index: AQHX63yobhR7xaimuUSU4jknnLqQN6wraUsAgABf8YCABEZs0P//mZ4AgAHaVHD//4REgIAB1a7Q
Date:   Wed, 15 Dec 2021 02:39:59 +0000
Message-ID: <0c2dae4264ae4d3b87d023879c51833c@intel.com>
References: <20211208000359.2853257-1-yang.zhong@intel.com>
 <20211208000359.2853257-17-yang.zhong@intel.com>
 <d16aab21-0f81-f758-a61e-5919f223be78@redhat.com>
 <26ea7039-3186-c23f-daba-d039bb8d6f48@redhat.com>
 <86d3c3a5d61649079800a2038370365b@intel.com>
 <bdda79b5-79e4-22fd-9af8-ec6e87a412ab@redhat.com>
 <3ec6019a551249d6994063e56a448625@intel.com>
 <ba78d142-6a97-99dd-9d00-465f7d6aa712@redhat.com>
In-Reply-To: <ba78d142-6a97-99dd-9d00-465f7d6aa712@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.6.200.16
x-originating-ip: [10.239.127.36]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gVHVlc2RheSwgRGVjZW1iZXIgMTQsIDIwMjEgMjoxOSBQTSwgUGFvbG8gQm9uemluaSB3cm90
ZToNCj4gVG86IFdhbmcsIFdlaSBXIDx3ZWkudy53YW5nQGludGVsLmNvbT47IFpob25nLCBZYW5n
DQo+IDx5YW5nLnpob25nQGludGVsLmNvbT47IHg4NkBrZXJuZWwub3JnOyBrdm1Admdlci5rZXJu
ZWwub3JnOw0KPiBsaW51eC1rZXJuZWxAdmdlci5rZXJuZWwub3JnOyB0Z2x4QGxpbnV0cm9uaXgu
ZGU7IG1pbmdvQHJlZGhhdC5jb207DQo+IGJwQGFsaWVuOC5kZTsgZGF2ZS5oYW5zZW5AbGludXgu
aW50ZWwuY29tDQo+IENjOiBzZWFuamNAZ29vZ2xlLmNvbTsgTmFrYWppbWEsIEp1biA8anVuLm5h
a2FqaW1hQGludGVsLmNvbT47IFRpYW4sIEtldmluDQo+IDxrZXZpbi50aWFuQGludGVsLmNvbT47
IGppbmcyLmxpdUBsaW51eC5pbnRlbC5jb207IExpdSwgSmluZzINCj4gPGppbmcyLmxpdUBpbnRl
bC5jb20+OyBaZW5nLCBHdWFuZyA8Z3VhbmcuemVuZ0BpbnRlbC5jb20+DQo+IFN1YmplY3Q6IFJl
OiBbUEFUQ0ggMTYvMTldIGt2bTogeDg2OiBJbnRyb2R1Y2UgS1ZNX3tHfFN9RVRfWFNBVkUyIGlv
Y3RsDQo+IA0KPiBPbiAxMi8xNC8yMSAwNzowNiwgV2FuZywgV2VpIFcgd3JvdGU6DQo+ID4gT24g
TW9uZGF5LCBEZWNlbWJlciAxMywgMjAyMSA1OjI0IFBNLCBQYW9sbyBCb256aW5pIHdyb3RlOg0K
PiA+PiBUaGVyZSBpcyBubyBuZWVkIGZvciBzdHJ1Y3Qga3ZtX3hzYXZlMiwgYmVjYXVzZSB0aGVy
ZSBpcyBubyBuZWVkIGZvciBhDQo+ICJzaXplIg0KPiA+PiBhcmd1bWVudC4NCj4gPj4NCj4gPj4g
LSBLVk1fR0VUX1hTQVZFMiAqaXMqIG5lZWRlZCwgYW5kIGl0IGNhbiBleHBlY3QgYSBidWZmZXIg
YXMgYmlnIGFzDQo+ID4+IHRoZSByZXR1cm4gdmFsdWUgb2YgS1ZNX0NIRUNLX0VYVEVOU0lPTihL
Vk1fQ0FQX1hTQVZFMikNCj4gPg0KPiA+IFdoeSB3b3VsZCBLVk1fR0VUX1hTQVZFMiBzdGlsbCBi
ZSBuZWVkZWQgaW4gdGhpcyBjYXNlPw0KPiA+DQo+ID4gSSdtIHRoaW5raW5nIGl0IHdvdWxkIGFs
c28gYmUgcG9zc2libGUgdG8gcmV1c2UgS1ZNX0dFVF9YU0FWRToNCj4gPg0KPiA+IC0gSWYgdXNl
cnNwYWNlIGNhbGxzIHRvIEtWTV9DSEVDS19FWFRFTlNJT04oS1ZNX0NBUF9YU0FWRTIpLA0KPiA+
ICAgdGhlbiBLVk0ga25vd3MgdGhhdCB0aGUgdXNlcnNwYWNlIGlzIGEgbmV3IHZlcnNpb24gYW5k
IGl0IHdvcmtzIHdpdGgNCj4gbGFyZ2VyIHhzYXZlIGJ1ZmZlciB1c2luZyB0aGUgInNpemUiIHRo
YXQgaXQgcmV0dXJucyB2aWEgS1ZNX0NBUF9YU0FWRTIuDQo+ID4gICBTbyB3ZSBjYW4gYWRkIGEg
ZmxhZyAia3ZtLT54c2F2ZTJfZW5hYmxlZCIsIHdoaWNoIGdldHMgc2V0IHVwb24NCj4gdXNlcnNw
YWNlIGNoZWNrcyBLVk1fQ0FQX1hTQVZFMi4NCj4gDQo+IFlvdSBjYW4gdXNlIEtWTV9FTkFCTEVf
Q0FQKEtWTV9DQVBfWFNBVkUyKSBmb3IgdGhhdCwgeWVzLiAgSW4gdGhhdCBjYXNlDQo+IHlvdSBk
b24ndCBuZWVkIEtWTV9HRVRfWFNBVkUyLg0KDQpPbiBtb3JlIHRoaW5nIGhlcmUsIHdoYXQgc2l6
ZSBzaG91bGQgS1ZNX0NIRUNLX0VYVEVOU0lPTihLVk1fQ0FQX1hTQVZFMikgcmV0dXJuPw0KSWYg
dGhlIHNpemUgc3RpbGwgY29tZXMgZnJvbSB0aGUgZ3Vlc3QgQ1BVSUQoMHhkLCAwKTo6UkNYLCB3
b3VsZCBpdCBiZSBiZXR0ZXIgdG8ganVzdCByZXR1cm4gMT8NClRoaXMgcmVxdWlyZXMgdGhhdCB0
aGUgUUVNVSBDUFVJRCBpbmZvIGhhcyBiZWVuIHNldCB0byBLVk0gYmVmb3JlIGNoZWNraW5nIHRo
ZSBjYXAuDQpRRU1VIGFscmVhZHkgaGFzIHRoaXMgQ1BVSUQgaW5mbyB0byBnZXQgdGhlIHNpemUg
KHNlZW1zIG5vIG5lZWQgdG8gaW5xdWlyZSBLVk0gZm9yIGl0KS4NCg0KVGhhbmtzLA0KV2VpDQo=
