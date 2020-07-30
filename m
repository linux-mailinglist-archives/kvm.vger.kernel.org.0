Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0701233BE8
	for <lists+kvm@lfdr.de>; Fri, 31 Jul 2020 01:08:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730713AbgG3XIG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Jul 2020 19:08:06 -0400
Received: from smtp-fw-6002.amazon.com ([52.95.49.90]:15791 "EHLO
        smtp-fw-6002.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729995AbgG3XIF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Jul 2020 19:08:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1596150485; x=1627686485;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=ECxXYxjhOUgHxVld+NUy25OcuAuJbKhWy4PYHGYnfeA=;
  b=u3IuQOESI4VRxhN5cvJdaoEGI7/gDel5j2ZIkLUil1y1wCFpuYm+i8vi
   UOV9BGlGVXOo/CVyqFTfN89rnJi2zXCz7Czkv8HWxwH1J/f1ZDQKCYQKh
   NVsZU/ZaIzNyJdK6l+83NoV67w5sXY1qsaE3l/+1qPGzmRX4VOoSOGI5d
   c=;
IronPort-SDR: /3w+tIAc8jF63yOrk32vRrVgsIPL+3S7TybFjGshWokrpQlCtg5jeehokkYv6A1PelHZZQEhbK
 JRzDWH4KPY1Q==
X-IronPort-AV: E=Sophos;i="5.75,415,1589241600"; 
   d="scan'208";a="45163570"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-2a-69849ee2.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-6002.iad6.amazon.com with ESMTP; 30 Jul 2020 23:08:03 +0000
Received: from EX13MTAUWC001.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan2.pdx.amazon.com [10.170.41.162])
        by email-inbound-relay-2a-69849ee2.us-west-2.amazon.com (Postfix) with ESMTPS id 301CFA04B7;
        Thu, 30 Jul 2020 23:08:01 +0000 (UTC)
Received: from EX13D20UWC002.ant.amazon.com (10.43.162.163) by
 EX13MTAUWC001.ant.amazon.com (10.43.162.135) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Thu, 30 Jul 2020 23:08:00 +0000
Received: from 38f9d3867b82.ant.amazon.com (10.43.162.109) by
 EX13D20UWC002.ant.amazon.com (10.43.162.163) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Thu, 30 Jul 2020 23:07:57 +0000
Subject: Re: [PATCH v2 1/3] KVM: x86: Deflect unknown MSR accesses to user
 space
To:     Jim Mattson <jmattson@google.com>
CC:     Paolo Bonzini <pbonzini@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>,
        KarimAllah Raslan <karahmed@amazon.de>,
        kvm list <kvm@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Aaron Lewis <aaronlewis@google.com>
References: <20200729235929.379-1-graf@amazon.com>
 <20200729235929.379-2-graf@amazon.com>
 <CALMp9eRq3QUG64BwSGLbehFr8k-OLSM3phcw7mhuZ9hVk_N2-A@mail.gmail.com>
From:   Alexander Graf <graf@amazon.com>
Message-ID: <e7cbf218-fb01-2f30-6c5c-a4b6e441b5e4@amazon.com>
Date:   Fri, 31 Jul 2020 01:07:55 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CALMp9eRq3QUG64BwSGLbehFr8k-OLSM3phcw7mhuZ9hVk_N2-A@mail.gmail.com>
Content-Language: en-US
X-Originating-IP: [10.43.162.109]
X-ClientProxiedBy: EX13D04UWB003.ant.amazon.com (10.43.161.231) To
 EX13D20UWC002.ant.amazon.com (10.43.162.163)
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: base64
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

CgpPbiAzMS4wNy4yMCAwMDo0MiwgSmltIE1hdHRzb24gd3JvdGU6Cj4gCj4gT24gV2VkLCBKdWwg
MjksIDIwMjAgYXQgNDo1OSBQTSBBbGV4YW5kZXIgR3JhZiA8Z3JhZkBhbWF6b24uY29tPiB3cm90
ZToKPj4KPj4gTVNScyBhcmUgd2VpcmQuIFNvbWUgb2YgdGhlbSBhcmUgbm9ybWFsIGNvbnRyb2wg
cmVnaXN0ZXJzLCBzdWNoIGFzIEVGRVIuCj4+IFNvbWUgaG93ZXZlciBhcmUgcmVnaXN0ZXJzIHRo
YXQgcmVhbGx5IGFyZSBtb2RlbCBzcGVjaWZpYywgbm90IHZlcnkKPj4gaW50ZXJlc3RpbmcgdG8g
dmlydHVhbGl6YXRpb24gd29ya2xvYWRzLCBhbmQgbm90IHBlcmZvcm1hbmNlIGNyaXRpY2FsLgo+
PiBPdGhlcnMgYWdhaW4gYXJlIHJlYWxseSBqdXN0IHdpbmRvd3MgaW50byBwYWNrYWdlIGNvbmZp
Z3VyYXRpb24uCj4+Cj4+IE91dCBvZiB0aGVzZSBNU1JzLCBvbmx5IHRoZSBmaXJzdCBjYXRlZ29y
eSBpcyBuZWNlc3NhcnkgdG8gaW1wbGVtZW50IGluCj4+IGtlcm5lbCBzcGFjZS4gUmFyZWx5IGFj
Y2Vzc2VkIE1TUnMsIE1TUnMgdGhhdCBzaG91bGQgYmUgZmluZSB0dW5lcyBhZ2FpbnN0Cj4+IGNl
cnRhaW4gQ1BVIG1vZGVscyBhbmQgTVNScyB0aGF0IGNvbnRhaW4gaW5mb3JtYXRpb24gb24gdGhl
IHBhY2thZ2UgbGV2ZWwKPj4gYXJlIG11Y2ggYmV0dGVyIHN1aXRlZCBmb3IgdXNlciBzcGFjZSB0
byBwcm9jZXNzLiBIb3dldmVyLCBvdmVyIHRpbWUgd2UgaGF2ZQo+PiBhY2N1bXVsYXRlZCBhIGxv
dCBvZiBNU1JzIHRoYXQgYXJlIG5vdCB0aGUgZmlyc3QgY2F0ZWdvcnksIGJ1dCBzdGlsbCBoYW5k
bGVkCj4+IGJ5IGluLWtlcm5lbCBLVk0gY29kZS4KPj4KPj4gVGhpcyBwYXRjaCBhZGRzIGEgZ2Vu
ZXJpYyBpbnRlcmZhY2UgdG8gaGFuZGxlIFdSTVNSIGFuZCBSRE1TUiBmcm9tIHVzZXIKPj4gc3Bh
Y2UuIFdpdGggdGhpcywgYW55IGZ1dHVyZSBNU1IgdGhhdCBpcyBwYXJ0IG9mIHRoZSBsYXR0ZXIg
Y2F0ZWdvcmllcyBjYW4KPj4gYmUgaGFuZGxlZCBpbiB1c2VyIHNwYWNlLgo+Pgo+PiBGdXJ0aGVy
bW9yZSwgaXQgYWxsb3dzIHVzIHRvIHJlcGxhY2UgdGhlIGV4aXN0aW5nICJpZ25vcmVfbXNycyIg
bG9naWMgd2l0aAo+PiBzb21ldGhpbmcgdGhhdCBhcHBsaWVzIHBlci1WTSByYXRoZXIgdGhhbiBv
biB0aGUgZnVsbCBzeXN0ZW0uIFRoYXQgd2F5IHlvdQo+PiBjYW4gcnVuIHByb2R1Y3RpdmUgVk1z
IGluIHBhcmFsbGVsIHRvIGV4cGVyaW1lbnRhbCBvbmVzIHdoZXJlIHlvdSBkb24ndCBjYXJlCj4+
IGFib3V0IHByb3BlciBNU1IgaGFuZGxpbmcuCj4+Cj4+IFNpZ25lZC1vZmYtYnk6IEFsZXhhbmRl
ciBHcmFmIDxncmFmQGFtYXpvbi5jb20+Cj4gCj4gQ2FuIHdlIGp1c3QgZHJvcCBlbV93cm1zciBh
bmQgZW1fcmRtc3I/IFRoZSBpbi1rZXJuZWwgZW11bGF0b3IgaXMKPiBhbHJlYWR5IGluY29tcGxl
dGUsIGFuZCBJIGRvbid0IHRoaW5rIHRoZXJlIGlzIGV2ZXIgYSBnb29kIHJlYXNvbiBmb3IKPiBr
dm0gdG8gZW11bGF0ZSBSRE1TUiBvciBXUk1TUiBpZiB0aGUgVk0tZXhpdCB3YXMgZm9yIHNvbWUg
b3RoZXIgcmVhc29uCj4gKGFuZCB3ZSBzaG91bGRuJ3QgZW5kIHVwIGhlcmUgaWYgdGhlIFZNLWV4
aXQgd2FzIGZvciBSRE1TUiBvciBXUk1TUikuCj4gQW0gSSBtaXNzaW5nIHNvbWV0aGluZz8KCk9u
IGNlcnRhaW4gY29tYmluYXRpb25zIG9mIENQVXMgYW5kIGd1ZXN0IG1vZGVzLCBzdWNoIGFzIHJl
YWwgbW9kZSBvbiAKcHJlLU5laGFsZW0oPykgYXQgbGVhc3QsIHdlIGFyZSBydW5uaW5nIGFsbCBn
dWVzdCBjb2RlIHRocm91Z2ggdGhlIAplbXVsYXRvciBhbmQgdGh1cyBtYXkgZW5jb3VudGVyIGEg
UkRNU1Igb3IgV1JNU1IgaW5zdHJ1Y3Rpb24uIEkgKnRoaW5rKiAKd2UgYWxzbyBkbyBzbyBmb3Ig
YmlnIHJlYWwgbW9kZSBvbiBtb3JlIG1vZGVybiBDUFVzLCBidXQgSSdtIG5vdCAxMDAlIHN1cmUu
Cgo+IFlvdSBzZWVtIHRvIGJlIGFzc3VtaW5nIHRoYXQgdGhlIGluc3RydWN0aW9uIGF0IENTOklQ
IHdpbGwgc3RpbGwgYmUKPiBSRE1TUiAob3IgV1JNU1IpIGFmdGVyIHJldHVybmluZyBmcm9tIHVz
ZXJzcGFjZSwgYW5kIHdlIHdpbGwgY29tZQo+IHRocm91Z2gga3ZtX3tnZXQsc2V0fV9tc3JfdXNl
cl9zcGFjZSBhZ2FpbiBhdCB0aGUgbmV4dCBLVk1fUlVOLiBUaGF0Cj4gaXNuJ3QgbmVjZXNzYXJp
bHkgdGhlIGNhc2UsIGZvciBhIHZhcmlldHkgb2YgcmVhc29ucy4gSSB0aGluayB0aGUKCkRvIHlv
dSBoYXZlIGEgcGFydGljdWxhciBzaXR1YXRpb24gaW4gbWluZCB3aGVyZSB0aGF0IHdvdWxkIG5v
dCBiZSB0aGUgCmNhc2UgYW5kIHdoZXJlIHdlIHdvdWxkIHN0aWxsIHdhbnQgdG8gYWN0dWFsbHkg
Y29tcGxldGUgYW4gTVNSIG9wZXJhdGlvbiAKYWZ0ZXIgdGhlIGVudmlyb25tZW50IGNoYW5nZWQ/
Cgo+ICdjb21wbGV0aW9uJyBvZiB0aGUgdXNlcnNwYWNlIGluc3RydWN0aW9uIGVtdWxhdGlvbiBz
aG91bGQgYmUgZG9uZQo+IHdpdGggdGhlIGNvbXBsZXRlX3VzZXJzcGFjZV9pbyBbc2ljXSBtZWNo
YW5pc20gaW5zdGVhZC4KCkhtLCB0aGF0IHdvdWxkIGF2b2lkIGEgcm91bmR0cmlwIGludG8gZ3Vl
c3QgbW9kZSwgYnV0IGFkZCBhIGN5Y2xlIAp0aHJvdWdoIHRoZSBpbi1rZXJuZWwgZW11bGF0b3Iu
IEknbSBub3Qgc3VyZSB0aGF0J3MgYSBuZXQgd2luIHF1aXRlIHlldC4KCj4gCj4gSSdkIHJlYWxs
eSBsaWtlIHRvIHNlZSB0aGlzIG1lY2hhbmlzbSBhcHBseSBvbmx5IGluIHRoZSBjYXNlIG9mCj4g
aW52YWxpZC91bmtub3duIE1TUnMsIGFuZCBub3QgZm9yIGlsbGVnYWwgcmVhZHMvd3JpdGVzIGFz
IHdlbGwuCgpXaHk/IEFueSAjR1AgaW5kdWNpbmcgTVNSIGFjY2VzcyB3aWxsIGJlIG9uIHRoZSBz
bG93IHBhdGguIFdoYXQncyB0aGUgCnByb2JsZW0gaWYgeW91IGdldCBhIGZldyBtb3JlIG9mIHRo
ZW0gaW4gdXNlciBzcGFjZSB0aGF0IHlvdSBqdXN0IGJvdW5jZSAKYmFjayBhcyBmYWlsaW5nLCBz
byB0aGV5IGFjdHVhbGx5IGRvIGluamVjdCBhIGZhdWx0PwoKQWxleAoKCgpBbWF6b24gRGV2ZWxv
cG1lbnQgQ2VudGVyIEdlcm1hbnkgR21iSApLcmF1c2Vuc3RyLiAzOAoxMDExNyBCZXJsaW4KR2Vz
Y2hhZWZ0c2Z1ZWhydW5nOiBDaHJpc3RpYW4gU2NobGFlZ2VyLCBKb25hdGhhbiBXZWlzcwpFaW5n
ZXRyYWdlbiBhbSBBbXRzZ2VyaWNodCBDaGFybG90dGVuYnVyZyB1bnRlciBIUkIgMTQ5MTczIEIK
U2l0ejogQmVybGluClVzdC1JRDogREUgMjg5IDIzNyA4NzkKCgo=

