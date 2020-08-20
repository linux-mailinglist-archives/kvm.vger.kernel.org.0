Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB95C24C77E
	for <lists+kvm@lfdr.de>; Thu, 20 Aug 2020 23:59:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726919AbgHTV7c (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Aug 2020 17:59:32 -0400
Received: from smtp-fw-9101.amazon.com ([207.171.184.25]:18431 "EHLO
        smtp-fw-9101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726885AbgHTV7c (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Aug 2020 17:59:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1597960772; x=1629496772;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=wR+Ec21DmJ5np7/P5hhfLrqVPkWlLEHL6gGL2ZtJQJg=;
  b=H7VSPLpwdzPBdnUthDdOgKpTcelf+6lYOco1aYUZvrW09nqvRHe2nv/i
   PUFIiSvqhU8HmtlXOPd5jNv8nbv9zLMgTEpuEuMn1gg+GRidG6HOKocTa
   hUQRJGHo9MrNUZ1olnnfgaMpYc68hFlXHkG/5fJdqQ4crKnQL9qrpG/Eu
   E=;
X-IronPort-AV: E=Sophos;i="5.76,334,1592870400"; 
   d="scan'208";a="61402997"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-1a-e34f1ddc.us-east-1.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9101.sea19.amazon.com with ESMTP; 20 Aug 2020 21:59:29 +0000
Received: from EX13MTAUWC001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan3.iad.amazon.com [10.40.159.166])
        by email-inbound-relay-1a-e34f1ddc.us-east-1.amazon.com (Postfix) with ESMTPS id B2EEDA18BE;
        Thu, 20 Aug 2020 21:59:26 +0000 (UTC)
Received: from EX13D20UWC001.ant.amazon.com (10.43.162.244) by
 EX13MTAUWC001.ant.amazon.com (10.43.162.135) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Thu, 20 Aug 2020 21:59:26 +0000
Received: from 38f9d3867b82.ant.amazon.com (10.43.162.87) by
 EX13D20UWC001.ant.amazon.com (10.43.162.244) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Thu, 20 Aug 2020 21:59:24 +0000
Subject: Re: [PATCH v3 05/12] KVM: x86: Add support for exiting to userspace
 on rdmsr or wrmsr
To:     Jim Mattson <jmattson@google.com>,
        Aaron Lewis <aaronlewis@google.com>
CC:     Peter Shier <pshier@google.com>, Oliver Upton <oupton@google.com>,
        "kvm list" <kvm@vger.kernel.org>
References: <20200818211533.849501-1-aaronlewis@google.com>
 <20200818211533.849501-6-aaronlewis@google.com>
 <CALMp9eQoPcMRmt8EAfh9AFF8vskbkWogXc5o3m6-f8fX5RndwA@mail.gmail.com>
From:   Alexander Graf <graf@amazon.com>
Message-ID: <bd7c54ae-73d1-0200-fbe7-10c8df408f8b@amazon.com>
Date:   Thu, 20 Aug 2020 23:59:22 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <CALMp9eQoPcMRmt8EAfh9AFF8vskbkWogXc5o3m6-f8fX5RndwA@mail.gmail.com>
Content-Language: en-US
X-Originating-IP: [10.43.162.87]
X-ClientProxiedBy: EX13D48UWB002.ant.amazon.com (10.43.163.125) To
 EX13D20UWC001.ant.amazon.com (10.43.162.244)
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: base64
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

CgpPbiAyMC4wOC4yMCAyMDoxNywgSmltIE1hdHRzb24gd3JvdGU6Cj4gCj4gT24gVHVlLCBBdWcg
MTgsIDIwMjAgYXQgMjoxNiBQTSBBYXJvbiBMZXdpcyA8YWFyb25sZXdpc0Bnb29nbGUuY29tPiB3
cm90ZToKPj4KPj4gQWRkIHN1cHBvcnQgZm9yIGV4aXRpbmcgdG8gdXNlcnNwYWNlIG9uIGEgcmRt
c3Igb3Igd3Jtc3IgaW5zdHJ1Y3Rpb24gaWYKPj4gdGhlIE1TUiBiZWluZyByZWFkIGZyb20gb3Ig
d3JpdHRlbiB0byBpcyBpbiB0aGUgdXNlcl9leGl0X21zcnMgbGlzdC4KPj4KPj4gU2lnbmVkLW9m
Zi1ieTogQWFyb24gTGV3aXMgPGFhcm9ubGV3aXNAZ29vZ2xlLmNvbT4KPj4gLS0tCj4+Cj4+IHYy
IC0+IHYzCj4+Cj4+ICAgIC0gUmVmYWN0b3JlZCBjb21taXQgYmFzZWQgb24gQWxleGFuZGVyIEdy
YWYncyBjaGFuZ2VzIGluIHRoZSBmaXJzdCBjb21taXQKPj4gICAgICBpbiB0aGlzIHNlcmllcy4g
IENoYW5nZXMgbWFkZSB3ZXJlOgo+PiAgICAgICAgLSBVcGRhdGVkIG1lbWJlciAnaW5qZWN0X2dw
JyB0byAnZXJyb3InIGJhc2VkIG9uIHN0cnVjdCBtc3IgaW4ga3ZtX3J1bi4KPj4gICAgICAgIC0g
TW92ZSBmbGFnICd2Y3B1LT5rdm0tPmFyY2gudXNlcl9zcGFjZV9tc3JfZW5hYmxlZCcgb3V0IG9m
Cj4+ICAgICAgICAgIGt2bV9tc3JfdXNlcl9zcGFjZSgpIHRvIGFsbG93IGl0IHRvIHdvcmsgd2l0
aCBib3RoIG1ldGhvZHMgdGhhdCBib3VuY2UKPj4gICAgICAgICAgdG8gdXNlcnNwYWNlIChtc3Ig
bGlzdCBhbmQgI0dQIGZhbGxiYWNrKS4gIFVwZGF0ZWQgY2FsbGVyIGZ1bmN0aW9ucwo+PiAgICAg
ICAgICB0byBhY2NvdW50IGZvciB0aGlzIGNoYW5nZS4KPj4gICAgICAgIC0gdHJhY2Vfa3ZtX21z
ciBoYXMgYmVlbiBtb3ZlZCB1cCBhbmQgY29tYmluZSB3aXRoIGEgcHJldmlvdXMgY2FsbCBpbgo+
PiAgICAgICAgICBjb21wbGV0ZV9lbXVsYXRlZF9tc3IoKSBiYXNlZCBvbiB0aGUgc3VnZ2VzdGlv
biBtYWRlIGJ5IEFsZXhhbmRlcgo+PiAgICAgICAgICBHcmFmIDxncmFmQGFtYXpvbi5jb20+Lgo+
Pgo+PiAtLS0KPiAKPj4gQEAgLTE2NTMsOSArMTY2Myw2IEBAIHN0YXRpYyBpbnQga3ZtX21zcl91
c2VyX3NwYWNlKHN0cnVjdCBrdm1fdmNwdSAqdmNwdSwgdTMyIGluZGV4LAo+PiAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgdTMyIGV4aXRfcmVhc29uLCB1NjQgZGF0YSwKPj4gICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgIGludCAoKmNvbXBsZXRpb24pKHN0cnVjdCBrdm1fdmNw
dSAqdmNwdSkpCj4+ICAgewo+PiAtICAgICAgIGlmICghdmNwdS0+a3ZtLT5hcmNoLnVzZXJfc3Bh
Y2VfbXNyX2VuYWJsZWQpCj4+IC0gICAgICAgICAgICAgICByZXR1cm4gMDsKPj4gLQo+PiAgICAg
ICAgICB2Y3B1LT5ydW4tPmV4aXRfcmVhc29uID0gZXhpdF9yZWFzb247Cj4+ICAgICAgICAgIHZj
cHUtPnJ1bi0+bXNyLmVycm9yID0gMDsKPj4gICAgICAgICAgdmNwdS0+cnVuLT5tc3IucGFkWzBd
ID0gMDsKPj4gQEAgLTE2ODYsMTAgKzE2OTMsMTggQEAgaW50IGt2bV9lbXVsYXRlX3JkbXNyKHN0
cnVjdCBrdm1fdmNwdSAqdmNwdSkKPj4gICAgICAgICAgdTY0IGRhdGE7Cj4+ICAgICAgICAgIGlu
dCByOwo+Pgo+PiArICAgICAgIGlmIChrdm1fbXNyX3VzZXJfZXhpdCh2Y3B1LT5rdm0sIGVjeCkp
IHsKPj4gKyAgICAgICAgICAgICAgIGt2bV9nZXRfbXNyX3VzZXJfc3BhY2UodmNwdSwgZWN4KTsK
Pj4gKyAgICAgICAgICAgICAgIC8qIEJvdW5jZSB0byB1c2VyIHNwYWNlICovCj4+ICsgICAgICAg
ICAgICAgICByZXR1cm4gMDsKPj4gKyAgICAgICB9Cj4+ICsKPj4gKwo+PiAgICAgICAgICByID0g
a3ZtX2dldF9tc3IodmNwdSwgZWN4LCAmZGF0YSk7Cj4+Cj4+ICAgICAgICAgIC8qIE1TUiByZWFk
IGZhaWxlZD8gU2VlIGlmIHdlIHNob3VsZCBhc2sgdXNlciBzcGFjZSAqLwo+PiAtICAgICAgIGlm
IChyICYmIGt2bV9nZXRfbXNyX3VzZXJfc3BhY2UodmNwdSwgZWN4KSkgewo+PiArICAgICAgIGlm
IChyICYmIHZjcHUtPmt2bS0+YXJjaC51c2VyX3NwYWNlX21zcl9lbmFibGVkKSB7Cj4+ICsgICAg
ICAgICAgICAgICBrdm1fZ2V0X21zcl91c2VyX3NwYWNlKHZjcHUsIGVjeCk7Cj4+ICAgICAgICAg
ICAgICAgICAgLyogQm91bmNlIHRvIHVzZXIgc3BhY2UgKi8KPj4gICAgICAgICAgICAgICAgICBy
ZXR1cm4gMDsKPj4gICAgICAgICAgfQo+IAo+IFRoZSBiZWZvcmUgYW5kIGFmdGVyIGJvdW5jZSB0
byB1c2Vyc3BhY2UgaXMgdW5mb3J0dW5hdGUuIElmIHdlIGNhbgo+IGNvbnNvbGlkYXRlIHRoZSBh
bGxvdy9kZW55IGxpc3QgY2hlY2tzIGF0IHRoZSB0b3Agb2Yga3ZtX2dldF9tc3IoKSwKPiBhbmQg
d2UgY2FuIHRlbGwgd2h5IGt2bV9nZXRfbXNyKCkgZmFpbGVkIChlLmcuIC1FUEVSTT1kaXNhbGxv
d2VkLAo+IC1FTk9FTlQ9dW5rbm93biBNU1IsIC1FSU5WQUw9aWxsZWdhbCBhY2Nlc3MpLCB0aGVu
IHdlIGNhbiBlbGltaW5hdGUKPiB0aGUgZmlyc3QgYm91bmNlIHRvIHVzZXJzcGFjZSBhYm92ZS4g
LUVQRVJNIHdvdWxkIGFsd2F5cyBnbyB0bwo+IHVzZXJzcGFjZS4gLUVOT0VOVCB3b3VsZCBnbyB0
byB1c2Vyc3BhY2UgaWYgdXNlcnNwYWNlIGFza2VkIHRvIGhhbmRsZQo+IHVua25vd24gTVNScy4g
LUVJTlZBTCB3b3VsZCBnbyB0byB1c2Vyc3BhY2UgaWYgdXNlcnNwYWNlIGFza2VkIHRvCj4gaGFu
ZGxlIGFsbCAjR1BzLiAoWWVzOyBJJ2Qgc3RpbGwgbGlrZSB0byBiZSBhYmxlIHRvIGRpc3Rpbmd1
aXNoCj4gYmV0d2VlbiAidW5rbm93biBNU1IiIGFuZCAiaWxsZWdhbCB2YWx1ZS4iIE90aGVyd2lz
ZSwgaXQgc2VlbXMKPiBpbXBvc3NpYmxlIGZvciB1c2Vyc3BhY2UgdG8ga25vdyBob3cgdG8gcHJv
Y2VlZC4pCj4gCj4gKFlvdSBtYXkgYXNrLCAid2h5IHdvdWxkIHlvdSBnZXQgLUVJTlZBTCBvbiBh
IFJETVNSPyIgVGhpcyB3b3VsZCBiZQo+IHRoZSBjYXNlIGlmIHlvdSB0cmllZCB0byByZWFkIGEg
d3JpdGUtb25seSBNU1IsIGxpa2UgSUEzMl9GTFVTSF9DTUQuKQoKRG8gd2UgcmVhbGx5IG5lZWQg
dG8gZG8gYWxsIG9mIHRoaXMgZGFuY2Ugb2YgZGlmZmVyZW50aWF0aW5nIGluIGtlcm5lbCAKc3Bh
Y2UgYmV0d2VlbiBhbiBleGl0IHRoYXQncyB0aGVyZSBiZWNhdXNlIHVzZXIgc3BhY2UgYXNrZWQg
Zm9yIHRoZSBleGl0IAphbmQgYW4gTVNSIGFjY2VzcyB0aGF0IHdvdWxkIGp1c3QgZ2VuZXJhdGUg
YSAjR1A/CgpBdCB0aGUgZW5kIG9mIHRoZSBkYXksIHVzZXIgc3BhY2UgKmtub3dzKiB3aGljaCBN
U1JzIGl0IGFza2VkIHRvIApyZWNlaXZlLiBJdCBjYW4gZmlsdGVyIGZvciB0aGVtIHN1cGVyIGVh
c2lseS4KCgpBbGV4CgoKCkFtYXpvbiBEZXZlbG9wbWVudCBDZW50ZXIgR2VybWFueSBHbWJICkty
YXVzZW5zdHIuIDM4CjEwMTE3IEJlcmxpbgpHZXNjaGFlZnRzZnVlaHJ1bmc6IENocmlzdGlhbiBT
Y2hsYWVnZXIsIEpvbmF0aGFuIFdlaXNzCkVpbmdldHJhZ2VuIGFtIEFtdHNnZXJpY2h0IENoYXJs
b3R0ZW5idXJnIHVudGVyIEhSQiAxNDkxNzMgQgpTaXR6OiBCZXJsaW4KVXN0LUlEOiBERSAyODkg
MjM3IDg3OQoKCg==

