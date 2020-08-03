Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39AA423A285
	for <lists+kvm@lfdr.de>; Mon,  3 Aug 2020 12:10:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726515AbgHCKIw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Aug 2020 06:08:52 -0400
Received: from smtp-fw-2101.amazon.com ([72.21.196.25]:63393 "EHLO
        smtp-fw-2101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726202AbgHCKIw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Aug 2020 06:08:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1596449331; x=1627985331;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=vrn+qlcGHgCOjUOiE/Yb8vwNQAJVWPm71o50JMrDurA=;
  b=I8bi0ID1gFEMoIlbpKmt7LXP2thj9czdqaj3v3J0Vzp0dwJaD1/++s/B
   KYLeBu0t8rPah4h+SkBwHsHEJ50Waa1tMocUHT1I+rhuTmURStwp2KSxO
   SkMRf4IsGRJGKZpuYt22CfC9SU+xZG+U2kjcKatjWBD6Fb7gM3f/YrKQn
   c=;
IronPort-SDR: sr1TlHIyxVtyjiI85vwYgOFjdjDnLRiMXt9wgQ2HkI9louFRD9HV22CAnigExTCK4A2sKEvaG+
 gPwgxJTuy6Rw==
X-IronPort-AV: E=Sophos;i="5.75,429,1589241600"; 
   d="scan'208";a="45539497"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-2c-1968f9fa.us-west-2.amazon.com) ([10.43.8.2])
  by smtp-border-fw-out-2101.iad2.amazon.com with ESMTP; 03 Aug 2020 10:08:47 +0000
Received: from EX13MTAUWC001.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan3.pdx.amazon.com [10.170.41.166])
        by email-inbound-relay-2c-1968f9fa.us-west-2.amazon.com (Postfix) with ESMTPS id EC936A22E5;
        Mon,  3 Aug 2020 10:08:45 +0000 (UTC)
Received: from EX13D20UWC001.ant.amazon.com (10.43.162.244) by
 EX13MTAUWC001.ant.amazon.com (10.43.162.135) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 3 Aug 2020 10:08:45 +0000
Received: from 38f9d3867b82.ant.amazon.com (10.43.161.71) by
 EX13D20UWC001.ant.amazon.com (10.43.162.244) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 3 Aug 2020 10:08:42 +0000
Subject: Re: [PATCH v3 1/3] KVM: x86: Deflect unknown MSR accesses to user
 space
To:     Jim Mattson <jmattson@google.com>
CC:     Paolo Bonzini <pbonzini@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>,
        KarimAllah Raslan <karahmed@amazon.de>,
        Aaron Lewis <aaronlewis@google.com>,
        kvm list <kvm@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
References: <20200731214947.16885-1-graf@amazon.com>
 <20200731214947.16885-2-graf@amazon.com>
 <CALMp9eQ4Cvh=071HcmFCHeLbSb0cxQaCr3SMmKYTFdkywMvoYQ@mail.gmail.com>
From:   Alexander Graf <graf@amazon.com>
Message-ID: <db209cc0-b878-0b5a-eb39-c58670f13a60@amazon.com>
Date:   Mon, 3 Aug 2020 12:08:40 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <CALMp9eQ4Cvh=071HcmFCHeLbSb0cxQaCr3SMmKYTFdkywMvoYQ@mail.gmail.com>
Content-Language: en-US
X-Originating-IP: [10.43.161.71]
X-ClientProxiedBy: EX13D40UWA001.ant.amazon.com (10.43.160.53) To
 EX13D20UWC001.ant.amazon.com (10.43.162.244)
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: base64
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

CgpPbiAwMS4wOC4yMCAwMTozNiwgSmltIE1hdHRzb24gd3JvdGU6Cj4gCj4gT24gRnJpLCBKdWwg
MzEsIDIwMjAgYXQgMjo1MCBQTSBBbGV4YW5kZXIgR3JhZiA8Z3JhZkBhbWF6b24uY29tPiB3cm90
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
ciBHcmFmIDxncmFmQGFtYXpvbi5jb20+Cj4+Cj4+IC0tLQo+Pgo+PiB2MSAtPiB2MjoKPj4KPj4g
ICAgLSBzL0VUUkFQX1RPX1VTRVJfU1BBQ0UvRU5PRU5UL2cKPj4gICAgLSBkZWZsZWN0IGFsbCAj
R1AgaW5qZWN0aW9uIGV2ZW50cyB0byB1c2VyIHNwYWNlLCBub3QganVzdCB1bmtub3duIE1TUnMu
Cj4+ICAgICAgVGhhdCB3YXMgd2UgY2FuIGFsc28gZGVmbGVjdCBhbGxvd2xpc3QgZXJyb3JzIGxh
dGVyCj4+ICAgIC0gZml4IGVtdWxhdG9yIGNhc2UKPj4KPj4gdjIgLT4gdjM6Cj4+Cj4+ICAgIC0g
cmV0dXJuIHIgaWYgciA9PSBYODZFTVVMX0lPX05FRURFRAo+PiAgICAtIHMvS1ZNX0VYSVRfUkRN
U1IvS1ZNX0VYSVRfWDg2X1JETVNSL2cKPj4gICAgLSBzL0tWTV9FWElUX1dSTVNSL0tWTV9FWElU
X1g4Nl9XUk1TUi9nCj4+ICAgIC0gVXNlIGNvbXBsZXRlX3VzZXJzcGFjZV9pbyBsb2dpYyBpbnN0
ZWFkIG9mIHJlcGx5IGZpZWxkCj4+ICAgIC0gU2ltcGxpZnkgdHJhcHBpbmcgY29kZQo+PiAtLS0K
Pj4gICBEb2N1bWVudGF0aW9uL3ZpcnQva3ZtL2FwaS5yc3QgIHwgIDYyICsrKysrKysrKysrKysr
KysrKysKPj4gICBhcmNoL3g4Ni9pbmNsdWRlL2FzbS9rdm1faG9zdC5oIHwgICA2ICsrCj4+ICAg
YXJjaC94ODYva3ZtL2VtdWxhdGUuYyAgICAgICAgICB8ICAxOCArKysrKy0KPj4gICBhcmNoL3g4
Ni9rdm0veDg2LmMgICAgICAgICAgICAgIHwgMTA2ICsrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKy0tCj4+ICAgaW5jbHVkZS90cmFjZS9ldmVudHMva3ZtLmggICAgICB8ICAgMiArLQo+PiAg
IGluY2x1ZGUvdWFwaS9saW51eC9rdm0uaCAgICAgICAgfCAgMTAgKysrCj4+ICAgNiBmaWxlcyBj
aGFuZ2VkLCAxOTcgaW5zZXJ0aW9ucygrKSwgNyBkZWxldGlvbnMoLSkKPj4KPj4gZGlmZiAtLWdp
dCBhL0RvY3VtZW50YXRpb24vdmlydC9rdm0vYXBpLnJzdCBiL0RvY3VtZW50YXRpb24vdmlydC9r
dm0vYXBpLnJzdAo+PiBpbmRleCAzMjA3ODhmODFhMDUuLjc5YzNlMmZkZmFlNCAxMDA2NDQKPj4g
LS0tIGEvRG9jdW1lbnRhdGlvbi92aXJ0L2t2bS9hcGkucnN0Cj4+ICsrKyBiL0RvY3VtZW50YXRp
b24vdmlydC9rdm0vYXBpLnJzdAo+IAo+IFRoZSBuZXcgZXhpdCByZWFzb25zIHNob3VsZCBwcm9i
YWJseSBiZSBtZW50aW9uZWQgaGVyZSAoYXJvdW5kIGxpbmUgNDg2Nik6Cj4gCj4gLi4gbm90ZTo6
Cj4gCj4gICAgICAgIEZvciBLVk1fRVhJVF9JTywgS1ZNX0VYSVRfTU1JTywgS1ZNX0VYSVRfT1NJ
LCBLVk1fRVhJVF9QQVBSIGFuZAo+ICAgICAgICBLVk1fRVhJVF9FUFIgdGhlIGNvcnJlc3BvbmRp
bmcKPiAKPiBvcGVyYXRpb25zIGFyZSBjb21wbGV0ZSAoYW5kIGd1ZXN0IHN0YXRlIGlzIGNvbnNp
c3RlbnQpIG9ubHkgYWZ0ZXIgdXNlcnNwYWNlCj4gaGFzIHJlLWVudGVyZWQgdGhlIGtlcm5lbCB3
aXRoIEtWTV9SVU4uICBUaGUga2VybmVsIHNpZGUgd2lsbCBmaXJzdCBmaW5pc2gKPiBpbmNvbXBs
ZXRlIG9wZXJhdGlvbnMgYW5kIHRoZW4gY2hlY2sgZm9yIHBlbmRpbmcgc2lnbmFscy4gIFVzZXJz
cGFjZQo+IGNhbiByZS1lbnRlciB0aGUgZ3Vlc3Qgd2l0aCBhbiB1bm1hc2tlZCBzaWduYWwgcGVu
ZGluZyB0byBjb21wbGV0ZQo+IHBlbmRpbmcgb3BlcmF0aW9ucy4KCkdyZWF0IGNhdGNoLCB0aGFu
a3MhIFVwZGF0ZWQgdG8gYWxzbyBpbmNsdWRlIHRoZSB0d28gbmV3IGV4aXQgcmVhc29ucy4KCj4g
Cj4gT3RoZXIgdGhhbiB0aGF0LCBteSByZW1haW5pbmcgY29tbWVudHMgYXJlIGFsbCBuaXRzLiBG
ZWVsIGZyZWUgdG8gaWdub3JlIHRoZW0uCj4gCj4+ICtzdGF0aWMgaW50IGt2bV9nZXRfbXNyX3Vz
ZXJfc3BhY2Uoc3RydWN0IGt2bV92Y3B1ICp2Y3B1LCB1MzIgaW5kZXgpCj4gCj4gUmV0dXJuIGJv
b2wgcmF0aGVyIHRoYW4gaW50PwoKSSdtIG5vdCBhIGJpZyBmYW4gb2YgYm9vbCByZXR1cm5pbmcg
QVBJcyB1bmxlc3MgdGhleSBoYXZlIGFuICJpcyIgaW4gCnRoZWlyIG5hbWUuIEluIHRoaXMgY2Fz
ZSwgdGhlIG1vc3QgcmVhZGFibGUgcGF0aCBmb3J3YXJkIHdvdWxkIHByb2JhYmx5IApiZSBhbiBl
bnVtOgoKZW51bSBrdm1fbXNyX3VzZXJfc3BhY2VfcmV0dmFsIHsKICAgICBLVk1fTVNSX0lOX0tF
Uk5FTCwKICAgICBLVk1fTVNSX0JPVU5DRV9UT19VU0VSX1NQQUNFLAp9OwoKYW5kIHRoZW4gdXNl
IHRoYXQgaW4gdGhlIGNoZWNrcy4gQnV0IHRoYXQgYWRkcyBhIGxvdCBvZiBib2lsZXIgcGxhdGUg
Zm9yIAphIGZ1bGx5IGludGVybmFsLCBvbmx5IGEgZmV3IGRvemVuIExPQyBiaWcgQVBJLiBJIGRv
bid0IHRoaW5rIGl0J3Mgd29ydGggaXQuCgo+IAo+PiArewo+PiArICAgICAgIGlmICghdmNwdS0+
a3ZtLT5hcmNoLnVzZXJfc3BhY2VfbXNyX2VuYWJsZWQpCj4+ICsgICAgICAgICAgICAgICByZXR1
cm4gMDsKPj4gKwo+PiArICAgICAgIHZjcHUtPnJ1bi0+ZXhpdF9yZWFzb24gPSBLVk1fRVhJVF9Y
ODZfUkRNU1I7Cj4+ICsgICAgICAgdmNwdS0+cnVuLT5tc3IuZXJyb3IgPSAwOwo+IAo+IFNob3Vs
ZCB3ZSBjbGVhciAncGFkJyBpbiBjYXNlIGFueW9uZSBjYW4gdGhpbmsgb2YgYSByZWFzb24gdG8g
dXNlIHRoaXMKPiBzcGFjZSB0byBleHRlbmQgdGhlIEFQSSBpbiB0aGUgZnV0dXJlPwoKSXQgY2Fu
J3QgaHVydCBJIGd1ZXNzLgoKPiAKPj4gKyAgICAgICB2Y3B1LT5ydW4tPm1zci5pbmRleCA9IGlu
ZGV4Owo+PiArICAgICAgIHZjcHUtPmFyY2gucGVuZGluZ191c2VyX21zciA9IHRydWU7Cj4+ICsg
ICAgICAgdmNwdS0+YXJjaC5jb21wbGV0ZV91c2Vyc3BhY2VfaW8gPSBjb21wbGV0ZV9lbXVsYXRl
ZF9yZG1zcjsKPiAKPiBjb21wbGV0ZV91c2Vyc3BhY2VfaW8gY291bGQgcGVyaGFwcyBiZSByZW5h
bWVkIHRvCj4gY29tcGxldGVfdXNlcnNwYWNlX2VtdWxhdGlvbiAoaW4gYSBzZXBhcmF0ZSBjb21t
aXQpLgoKSSB0aGluayB0aGUgY29tcGxpY2F0ZWQgcGFydCBvZiBjb21wbGV0ZV91c2Vyc3BhY2Vf
aW8gaXMgdG8ga25vdyBpdCAKZXhpc3RzIGFuZCB1bmRlcnN0YW5kIGhvdyBpdCB3b3Jrcy4gT25j
ZSB5b3UgZ3Jhc3AgdGhlc2UgdHdvIGJpdHMsIHRoZSAKbmFtZSBpcyBqdXN0IGFuIGFydGlmYWN0
IGFuZCBJTUhPIGVhc3kgZW5vdWdoIHRvIGFwcGx5ICJiZXlvbmQgSS9PIi4KCj4gCj4+ICsKPj4g
KyAgICAgICByZXR1cm4gMTsKPj4gK30KPj4gKwo+PiArc3RhdGljIGludCBrdm1fc2V0X21zcl91
c2VyX3NwYWNlKHN0cnVjdCBrdm1fdmNwdSAqdmNwdSwgdTMyIGluZGV4LCB1NjQgZGF0YSkKPiAK
PiBSZXR1cm4gYm9vbCByYXRoZXIgdGhhbiBpbnQ/CgpTYW1lIHJlcGxpZXMgYXMgYWJvdmUgOiku
IEkgZGlkIGdldCBmZWQgdXAgd2l0aCB0aGUgYW1vdW50IG9mIApkdXBsaWNhdGlvbiB0aG91Z2gg
YW5kIGNyZWF0ZWQgYSBnZW5lcmFsaXplZCBmdW5jdGlvbiBpbiB2NCB0aGF0IGdldHMgCmNhbGxl
ZCBieSBrdm1fZ2V0L3NldF9tc3JfdXNlcl9zcGFjZSgpIHRvIGVuc3VyZSB0aGF0IGFsbCBmaWVs
ZHMgYXJlIAphbHdheXMgc2V0LgoKPiAKPj4gK3sKPj4gKyAgICAgICBpZiAoIXZjcHUtPmt2bS0+
YXJjaC51c2VyX3NwYWNlX21zcl9lbmFibGVkKQo+PiArICAgICAgICAgICAgICAgcmV0dXJuIDA7
Cj4+ICsKPj4gKyAgICAgICB2Y3B1LT5ydW4tPmV4aXRfcmVhc29uID0gS1ZNX0VYSVRfWDg2X1dS
TVNSOwo+PiArICAgICAgIHZjcHUtPnJ1bi0+bXNyLmVycm9yID0gMDsKPiAKPiBTYW1lIHF1ZXN0
aW9uIGFib3V0ICdwYWQnIGFzIGFib3ZlLgo+IAo+PiArICAgICAgIHZjcHUtPnJ1bi0+bXNyLmlu
ZGV4ID0gaW5kZXg7Cj4+ICsgICAgICAgdmNwdS0+cnVuLT5tc3IuZGF0YSA9IGRhdGE7Cj4+ICsg
ICAgICAgdmNwdS0+YXJjaC5wZW5kaW5nX3VzZXJfbXNyID0gdHJ1ZTsKPj4gKyAgICAgICB2Y3B1
LT5hcmNoLmNvbXBsZXRlX3VzZXJzcGFjZV9pbyA9IGNvbXBsZXRlX2VtdWxhdGVkX3dybXNyOwo+
PiArCj4+ICsgICAgICAgcmV0dXJuIDE7Cj4+ICt9Cj4+ICsKPiAKPiBSZXZpZXdlZC1ieTogSmlt
IE1hdHRzb24gPGptYXR0c29uQGdvb2dsZS5jb20+CgpUaGFua3MgYSBidW5jaCBmb3IgdGhlIHJl
dmlldyA6KQoKCkFsZXgKCgoKQW1hem9uIERldmVsb3BtZW50IENlbnRlciBHZXJtYW55IEdtYkgK
S3JhdXNlbnN0ci4gMzgKMTAxMTcgQmVybGluCkdlc2NoYWVmdHNmdWVocnVuZzogQ2hyaXN0aWFu
IFNjaGxhZWdlciwgSm9uYXRoYW4gV2Vpc3MKRWluZ2V0cmFnZW4gYW0gQW10c2dlcmljaHQgQ2hh
cmxvdHRlbmJ1cmcgdW50ZXIgSFJCIDE0OTE3MyBCClNpdHo6IEJlcmxpbgpVc3QtSUQ6IERFIDI4
OSAyMzcgODc5CgoK

