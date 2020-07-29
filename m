Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BFDB231BCC
	for <lists+kvm@lfdr.de>; Wed, 29 Jul 2020 11:07:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727910AbgG2JG7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Jul 2020 05:06:59 -0400
Received: from smtp-fw-6002.amazon.com ([52.95.49.90]:8736 "EHLO
        smtp-fw-6002.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726710AbgG2JG6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Jul 2020 05:06:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1596013617; x=1627549617;
  h=to:cc:references:from:message-id:date:mime-version:
   in-reply-to:content-transfer-encoding:subject;
  bh=7yNnNad4CykjTh0yKQ/0Vehn2KTjbwom4dEinlsDlgE=;
  b=H5WWA8fFBvBy8BU8jmAq5cPeE5MhTutQU3bdCTk2pQmfoTvb9DQwD8BY
   PvlWG3cM+2yh/thIhxIpA2OaQ85ZV1VjEW7C/SqMhOFUWfz6SmZlne9bq
   ig1F/3TJE/3Mr1d8BeSclrzrOnreUcsLDErmgcIr2JgrKEUcLjf2rm1AC
   s=;
IronPort-SDR: gWPHd0y+g7dqZ2QiG8gsjtapXzFrELuGEE7KQz4ZlCIP0Z9t0y1ix+Npu+pz4u4NZ5jqxxzrR5
 y8nP0ikaNO1g==
X-IronPort-AV: E=Sophos;i="5.75,409,1589241600"; 
   d="scan'208";a="44778053"
Subject: Re: [PATCH] KVM: x86: Deflect unknown MSR accesses to user space
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-1e-17c49630.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-6002.iad6.amazon.com with ESMTP; 29 Jul 2020 09:06:56 +0000
Received: from EX13MTAUWC001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan2.iad.amazon.com [10.40.159.162])
        by email-inbound-relay-1e-17c49630.us-east-1.amazon.com (Postfix) with ESMTPS id 5A4DAA23A6;
        Wed, 29 Jul 2020 09:06:52 +0000 (UTC)
Received: from EX13D20UWC002.ant.amazon.com (10.43.162.163) by
 EX13MTAUWC001.ant.amazon.com (10.43.162.135) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 29 Jul 2020 09:06:51 +0000
Received: from 38f9d3867b82.ant.amazon.com (10.43.160.65) by
 EX13D20UWC002.ant.amazon.com (10.43.162.163) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 29 Jul 2020 09:06:48 +0000
To:     Jim Mattson <jmattson@google.com>,
        Aaron Lewis <aaronlewis@google.com>
CC:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        "Joerg Roedel" <joro@8bytes.org>, kvm list <kvm@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
References: <20200728004446.932-1-graf@amazon.com>
 <87d04gm4ws.fsf@vitty.brq.redhat.com>
 <a1f30fc8-09f5-fe2f-39e2-136b881ed15a@amazon.com>
 <CALMp9eQ3OxhQZYiHPiebX=KyvjWQgxQEO-owjSoxgPKsOMRvjw@mail.gmail.com>
From:   Alexander Graf <graf@amazon.com>
Message-ID: <14035057-ea80-603b-0466-bb50767f9f7e@amazon.com>
Date:   Wed, 29 Jul 2020 11:06:46 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CALMp9eQ3OxhQZYiHPiebX=KyvjWQgxQEO-owjSoxgPKsOMRvjw@mail.gmail.com>
Content-Language: en-US
X-Originating-IP: [10.43.160.65]
X-ClientProxiedBy: EX13D37UWC002.ant.amazon.com (10.43.162.123) To
 EX13D20UWC002.ant.amazon.com (10.43.162.163)
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: base64
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

CgpPbiAyOC4wNy4yMCAxOToxMywgSmltIE1hdHRzb24gd3JvdGU6Cj4gQ0FVVElPTjogVGhpcyBl
bWFpbCBvcmlnaW5hdGVkIGZyb20gb3V0c2lkZSBvZiB0aGUgb3JnYW5pemF0aW9uLiBEbyBub3Qg
Y2xpY2sgbGlua3Mgb3Igb3BlbiBhdHRhY2htZW50cyB1bmxlc3MgeW91IGNhbiBjb25maXJtIHRo
ZSBzZW5kZXIgYW5kIGtub3cgdGhlIGNvbnRlbnQgaXMgc2FmZS4KPiAKPiAKPiAKPiBPbiBUdWUs
IEp1bCAyOCwgMjAyMCBhdCA1OjQxIEFNIEFsZXhhbmRlciBHcmFmIDxncmFmQGFtYXpvbi5jb20+
IHdyb3RlOgo+Pgo+Pgo+Pgo+PiBPbiAyOC4wNy4yMCAxMDoxNSwgVml0YWx5IEt1em5ldHNvdiB3
cm90ZToKPj4+Cj4+PiBBbGV4YW5kZXIgR3JhZiA8Z3JhZkBhbWF6b24uY29tPiB3cml0ZXM6Cj4+
Pgo+Pj4+IE1TUnMgYXJlIHdlaXJkLiBTb21lIG9mIHRoZW0gYXJlIG5vcm1hbCBjb250cm9sIHJl
Z2lzdGVycywgc3VjaCBhcyBFRkVSLgo+Pj4+IFNvbWUgaG93ZXZlciBhcmUgcmVnaXN0ZXJzIHRo
YXQgcmVhbGx5IGFyZSBtb2RlbCBzcGVjaWZpYywgbm90IHZlcnkKPj4+PiBpbnRlcmVzdGluZyB0
byB2aXJ0dWFsaXphdGlvbiB3b3JrbG9hZHMsIGFuZCBub3QgcGVyZm9ybWFuY2UgY3JpdGljYWwu
Cj4+Pj4gT3RoZXJzIGFnYWluIGFyZSByZWFsbHkganVzdCB3aW5kb3dzIGludG8gcGFja2FnZSBj
b25maWd1cmF0aW9uLgo+Pj4+Cj4+Pj4gT3V0IG9mIHRoZXNlIE1TUnMsIG9ubHkgdGhlIGZpcnN0
IGNhdGVnb3J5IGlzIG5lY2Vzc2FyeSB0byBpbXBsZW1lbnQgaW4KPj4+PiBrZXJuZWwgc3BhY2Uu
IFJhcmVseSBhY2Nlc3NlZCBNU1JzLCBNU1JzIHRoYXQgc2hvdWxkIGJlIGZpbmUgdHVuZXMgYWdh
aW5zdAo+Pj4+IGNlcnRhaW4gQ1BVIG1vZGVscyBhbmQgTVNScyB0aGF0IGNvbnRhaW4gaW5mb3Jt
YXRpb24gb24gdGhlIHBhY2thZ2UgbGV2ZWwKPj4+PiBhcmUgbXVjaCBiZXR0ZXIgc3VpdGVkIGZv
ciB1c2VyIHNwYWNlIHRvIHByb2Nlc3MuIEhvd2V2ZXIsIG92ZXIgdGltZSB3ZSBoYXZlCj4+Pj4g
YWNjdW11bGF0ZWQgYSBsb3Qgb2YgTVNScyB0aGF0IGFyZSBub3QgdGhlIGZpcnN0IGNhdGVnb3J5
LCBidXQgc3RpbGwgaGFuZGxlZAo+Pj4+IGJ5IGluLWtlcm5lbCBLVk0gY29kZS4KPj4+Pgo+Pj4+
IFRoaXMgcGF0Y2ggYWRkcyBhIGdlbmVyaWMgaW50ZXJmYWNlIHRvIGhhbmRsZSBXUk1TUiBhbmQg
UkRNU1IgZnJvbSB1c2VyCj4+Pj4gc3BhY2UuIFdpdGggdGhpcywgYW55IGZ1dHVyZSBNU1IgdGhh
dCBpcyBwYXJ0IG9mIHRoZSBsYXR0ZXIgY2F0ZWdvcmllcyBjYW4KPj4+PiBiZSBoYW5kbGVkIGlu
IHVzZXIgc3BhY2UuCj4gCj4gVGhpcyBzb3VuZHMgc2ltaWxhciB0byBQZXRlciBIb3JueWFjaydz
IFJGQyBmcm9tIDUgeWVhcnMgYWdvOgo+IGh0dHBzOi8vd3d3Lm1haWwtYXJjaGl2ZS5jb20va3Zt
QHZnZXIua2VybmVsLm9yZy9tc2cxMjQ0NDguaHRtbC4KClllYWgsIGxvb2tzIHZlcnkgc2ltaWxh
ci4gRG8geW91IGtub3cgdGhlIGhpc3Rvcnkgd2h5IGl0IG5ldmVyIGdvdCAKbWVyZ2VkPyBJIGNv
dWxkbid0IHNwb3QgYSBub24tUkZDIHZlcnNpb24gb2YgdGhpcyBvbiB0aGUgTUwuCgo+IAo+Pj4+
IEZ1cnRoZXJtb3JlLCBpdCBhbGxvd3MgdXMgdG8gcmVwbGFjZSB0aGUgZXhpc3RpbmcgImlnbm9y
ZV9tc3JzIiBsb2dpYyB3aXRoCj4+Pj4gc29tZXRoaW5nIHRoYXQgYXBwbGllcyBwZXItVk0gcmF0
aGVyIHRoYW4gb24gdGhlIGZ1bGwgc3lzdGVtLiBUaGF0IHdheSB5b3UKPj4+PiBjYW4gcnVuIHBy
b2R1Y3RpdmUgVk1zIGluIHBhcmFsbGVsIHRvIGV4cGVyaW1lbnRhbCBvbmVzIHdoZXJlIHlvdSBk
b24ndCBjYXJlCj4+Pj4gYWJvdXQgcHJvcGVyIE1TUiBoYW5kbGluZy4KPj4+Pgo+Pj4KPj4+IElu
IHRoZW9yeSwgd2UgY2FuIGdvIGZ1cnRoZXI6IHVzZXJzcGFjZSB3aWxsIGdpdmUgS1ZNIHRoZSBs
aXN0IG9mIE1TUnMKPj4+IGl0IGlzIGludGVyZXN0ZWQgaW4uIFRoaXMgbGlzdCBtYXkgZXZlbiBj
b250YWluIE1TUnMgd2hpY2ggYXJlIG5vcm1hbGx5Cj4+PiBoYW5kbGVkIGJ5IEtWTSwgaW4gdGhp
cyBjYXNlIHVzZXJzcGFjZSBnZXRzIGFuIG9wdGlvbiB0byBtYW5nbGUgS1ZNJ3MKPj4+IHJlcGx5
IChSRE1TUikgb3IgZG8gc29tZXRoaW5nIGV4dHJhIChXUk1TUikuIEknbSBub3Qgc3VyZSBpZiB0
aGVyZSBpcyBhCj4+PiByZWFsIG5lZWQgYmVoaW5kIHRoaXMsIGp1c3QgYW4gaWRlYS4KPj4+Cj4+
PiBUaGUgcHJvYmxlbSB3aXRoIHRoaXMgYXBwcm9hY2ggaXM6IGlmIGN1cnJlbnRseSBzb21lIE1T
UiBpcyBub3QKPj4+IGltcGxlbWVudGVkIGluIEtWTSB5b3Ugd2lsbCBnZXQgYW4gZXhpdC4gV2hl
biBsYXRlciBzb21lb25lIGNvbWVzIHdpdGggYQo+Pj4gcGF0Y2ggdG8gaW1wbGVtZW50IHRoaXMg
TVNSIHlvdXIgdXNlcnNwYWNlIGhhbmRsaW5nIHdpbGwgaW1tZWRpYXRlbHkgZ2V0Cj4+PiBicm9r
ZW4gc28gdGhlIGxpc3Qgb2Ygbm90IGltcGxlbWVudGVkIE1TUnMgZWZmZWN0aXZlbHkgYmVjb21l
cyBhbiBBUEkgOi0pCj4gCj4gSW5kZWVkLiBUaGlzIGlzIGEgbGVnaXRpbWF0ZSBjb25jZXJuLiBB
dCBHb29nbGUsIHdlIGhhdmUgZXhwZXJpZW5jZWQKPiB0aGlzIHByb2JsZW0gYWxyZWFkeSwgdXNp
bmcgUGV0ZXIgSG9ybnlhY2sncyBhcHByb2FjaC4gV2UgZW5kZWQgdXAKPiBjb21tZW50aW5nIG91
dCBzb21lIE1TUnMgZnJvbSBrdm0sIHdoaWNoIGlzIGxlc3MgdGhhbiBpZGVhbC4KClllYWggOigu
Cgo+IAo+PiBZZWFoLCBJJ20gbm90IHF1aXRlIHN1cmUgaG93IHRvIGRvIHRoaXMgd2l0aG91dCBi
bG9hdGluZyB0aGUga2VybmVsJ3MKPj4gbWVtb3J5IGZvb3RwcmludCB0b28gbXVjaCB0aG91Z2gu
Cj4+Cj4+IE9uZSBvcHRpb24gd291bGQgYmUgdG8gY3JlYXRlIGEgc2hhcmVkIGJpdG1hcCB3aXRo
IHVzZXIgc3BhY2UuIEJ1dCB0aGF0Cj4+IHdvdWxkIG5lZWQgdG8gYmUgc3BhcnNlIGFuZCBxdWl0
ZSBiaWcgdG8gYmUgYWJsZSB0byBhZGRyZXNzIGFsbCBvZgo+PiB0b2RheSdzIHBvc3NpYmxlIE1T
UiBpbmRleGVzLiBGcm9tIGEgcXVpY2sgZ2xpbXBzZSBhdCBMaW51eCdzIE1TUgo+PiBkZWZpbmVz
LCB0aGVyZSBhcmU6Cj4+Cj4+ICAgICAweDAwMDAwMDAwIC0gMHgwMDAwMTAwMCAoSW50ZWwpCj4+
ICAgICAweDAwMDAxMDAwIC0gMHgwMDAwMjAwMCAoVklBKQo+PiAgICAgMHg0MDAwMDAwMCAtIDB4
NTAwMDAwMDAgKFBWKQo+PiAgICAgMHhjMDAwMDAwMCAtIDB4YzAwMDMwMDAgKEFNRCkKPj4gICAg
IDB4YzAwMTAwMDAgLSAweGMwMDEyMDAwIChBTUQpCj4+ICAgICAweDgwODYwMDAwIC0gMHg4MDg3
MDAwMCAoVHJhbnNtZXRhKQo+Pgo+PiBBbm90aGVyIGlkZWEgd291bGQgYmUgdG8gdHVybiB0aGUg
bG9naWMgYXJvdW5kIGFuZCBpbXBsZW1lbnQgYW4KPj4gYWxsb3dsaXN0IGluIEtWTSB3aXRoIGFs
bCBvZiB0aGUgTVNScyB0aGF0IEtWTSBzaG91bGQgaGFuZGxlLiBJbiB0aGF0Cj4+IEFQSSB3ZSBj
b3VsZCBhc2sgZm9yIGFuIGFycmF5IG9mIEtWTSBzdXBwb3J0ZWQgTVNScyBpbnRvIHVzZXIgc3Bh
Y2UuCj4+IFVzZXIgc3BhY2UgY291bGQgdGhlbiBib3VuY2UgdGhhdCBhcnJheSBiYWNrIHRvIEtW
TSB0byBoYXZlIGFsbCBpbi1LVk0KPj4gc3VwcG9ydGVkIE1TUnMgaGFuZGxlZC4gT3IgaXQgY291
bGQgcmVtb3ZlIGVudHJpZXMgdGhhdCBpdCB3YW50cyB0bwo+PiBoYW5kbGUgb24gaXRzIG93bi4K
Pj4KPj4gS1ZNIGludGVybmFsbHkgY291bGQgdGhlbiBzYXZlIHRoZSBsaXN0IGFzIGEgZGVuc2Ug
Yml0bWFwLCB0cmFuc2xhdGluZwo+PiBldmVyeSBsaXN0IGVudHJ5IGludG8gaXRzIGNvcnJlc3Bv
bmRpbmcgYml0Lgo+Pgo+PiBXaGlsZSBpdCBkb2VzIGZlZWwgYSBiaXQgb3ZlcmVuZ2luZWVyZWQs
IGl0IHdvdWxkIHNvbHZlIHRoZSBwcm9ibGVtIHRoYXQKPj4gd2UncmUgdHVybmluZyBpbi1LVk0g
aGFuZGxlZCBNU1JzIGludG8gYW4gQUJJLgo+IAo+IEl0IHNlZW1zIHVubGlrZWx5IHRoYXQgdXNl
cnNwYWNlIGlzIGdvaW5nIHRvIGtub3cgd2hhdCB0byBkbyB3aXRoIGEKPiBsYXJnZSBudW1iZXIg
b2YgTVNScy4gSSBzdXNwZWN0IHRoYXQgYSBzbWFsbCBlbnVtZXJhdGVkIGxpc3Qgd2lsbAo+IHN1
ZmZpY2UuIEluIGZhY3QsICtBYXJvbiBMZXdpcyBpcyB3b3JraW5nIG9uIHVwc3RyZWFtaW5nIGEg
bG9jYWwKPiBHb29nbGUgcGF0Y2ggc2V0IHRoYXQgZG9lcyBqdXN0IHRoYXQuCgpJIHRlbmQgdG8g
ZGlzYWdyZWUgb24gdGhhdCBzZW50aW1lbnQuIE9uZSBvZiB0aGUgbW90aXZhdGlvbnMgYmVoaW5k
IHRoaXMgCnBhdGNoIGlzIHRvIHBvcHVsYXRlIGludmFsaWQgTVNSIGFjY2Vzc2VzIGludG8gdXNl
ciBzcGFjZSwgdG8gbW92ZSBsb2dpYyAKbGlrZSAiaWdub3JlX21zcnMiWzFdIGludG8gdXNlciBz
cGFjZS4gVGhpcyBpcyBub3QgdmVyeSB1c2VmdWwgZm9yIHRoZSAKY2xvdWQgdXNlIGNhc2UsIGJ1
dCBpdCBkb2VzIGNvbWUgaW4gaGFuZHkgd2hlbiB5b3Ugd2FudCB0byBoYXZlIFZNcyB0aGF0IApj
YW4gaGFuZGxlIHVuaW1wbGVtZW50ZWQgTVNScyBpbiBwYXJhbGxlbCB0byBvbmVzIHRoYXQgZG8g
bm90LgoKU28gd2hhdGV2ZXIgd2UgaW1wbGVtZW50LCBJIHdvdWxkIGlkZWFsbHkgd2FudCBhIG1l
Y2hhbmlzbSBhdCB0aGUgZW5kIG9mIAp0aGUgZGF5IHRoYXQgYWxsb3dzIG1lIHRvICJ0cmFwIHRo
ZSByZXN0IiBpbnRvIHVzZXIgc3BhY2UuCgoKQWxleAoKWzFdIApodHRwczovL2dpdC5rZXJuZWwu
b3JnL3B1Yi9zY20vbGludXgva2VybmVsL2dpdC90b3J2YWxkcy9saW51eC5naXQvdHJlZS9hcmNo
L3g4Ni9rdm0veDg2LmMjbjExNAoKCgpBbWF6b24gRGV2ZWxvcG1lbnQgQ2VudGVyIEdlcm1hbnkg
R21iSApLcmF1c2Vuc3RyLiAzOAoxMDExNyBCZXJsaW4KR2VzY2hhZWZ0c2Z1ZWhydW5nOiBDaHJp
c3RpYW4gU2NobGFlZ2VyLCBKb25hdGhhbiBXZWlzcwpFaW5nZXRyYWdlbiBhbSBBbXRzZ2VyaWNo
dCBDaGFybG90dGVuYnVyZyB1bnRlciBIUkIgMTQ5MTczIEIKU2l0ejogQmVybGluClVzdC1JRDog
REUgMjg5IDIzNyA4NzkKCgo=

