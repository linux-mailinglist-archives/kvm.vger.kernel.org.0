Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 700BF25072D
	for <lists+kvm@lfdr.de>; Mon, 24 Aug 2020 20:09:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726632AbgHXSJZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Aug 2020 14:09:25 -0400
Received: from smtp-fw-9101.amazon.com ([207.171.184.25]:34201 "EHLO
        smtp-fw-9101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726336AbgHXSJY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Aug 2020 14:09:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1598292562; x=1629828562;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=LtlBrMnWW4Uz/mEU68MhqDmtkeF0KLXFD9TyIG9/7LQ=;
  b=derJKgQQP80UgJzYcj/el9WS1U0C3oknVJfg9+EWQDd/oWTv5jqXw4Ce
   SQ+CjVrd+p/mO40AxtUQrj8yr8r07fUTJddONXaXbWxjnkNrLGVt8WptJ
   RGTq+kt0yv/82r+t+3ZASL/JP9q90Ge2RXo5Ki5lud8ThZmb6QdypzQ+H
   U=;
X-IronPort-AV: E=Sophos;i="5.76,349,1592870400"; 
   d="scan'208";a="62296127"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-1d-2c665b5d.us-east-1.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9101.sea19.amazon.com with ESMTP; 24 Aug 2020 18:09:19 +0000
Received: from EX13MTAUWC001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan2.iad.amazon.com [10.40.159.162])
        by email-inbound-relay-1d-2c665b5d.us-east-1.amazon.com (Postfix) with ESMTPS id AF35AA209F;
        Mon, 24 Aug 2020 18:09:17 +0000 (UTC)
Received: from EX13D20UWC001.ant.amazon.com (10.43.162.244) by
 EX13MTAUWC001.ant.amazon.com (10.43.162.135) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 24 Aug 2020 18:09:17 +0000
Received: from Alexanders-MacBook-Air.local (10.43.161.34) by
 EX13D20UWC001.ant.amazon.com (10.43.162.244) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 24 Aug 2020 18:09:10 +0000
Subject: Re: [PATCH v3 05/12] KVM: x86: Add support for exiting to userspace
 on rdmsr or wrmsr
To:     Jim Mattson <jmattson@google.com>
CC:     Aaron Lewis <aaronlewis@google.com>,
        Peter Shier <pshier@google.com>,
        Oliver Upton <oupton@google.com>,
        kvm list <kvm@vger.kernel.org>
References: <20200818211533.849501-1-aaronlewis@google.com>
 <20200818211533.849501-6-aaronlewis@google.com>
 <CALMp9eQoPcMRmt8EAfh9AFF8vskbkWogXc5o3m6-f8fX5RndwA@mail.gmail.com>
 <bd7c54ae-73d1-0200-fbe7-10c8df408f8b@amazon.com>
 <CALMp9eSXS+b62C-kXjwPBeYF36ajYeGg2kBmsubz9s5V6C-83A@mail.gmail.com>
 <CALMp9eTUV9Z7hL_qtdKYvqYmm8wT1_oGaRLp55i3ttg1qLyecQ@mail.gmail.com>
 <cf256ff0-8336-06fc-b475-8ca00782c4ce@amazon.com>
 <CALMp9eQd4cmK2_2oEnTX7VUEA0N9gsEkdpKhLyWpQzWCQm4w-w@mail.gmail.com>
From:   Alexander Graf <graf@amazon.com>
Message-ID: <8851792a-d9f2-fe0c-33e7-cae7f3bb3919@amazon.com>
Date:   Mon, 24 Aug 2020 20:09:08 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.1.1
MIME-Version: 1.0
In-Reply-To: <CALMp9eQd4cmK2_2oEnTX7VUEA0N9gsEkdpKhLyWpQzWCQm4w-w@mail.gmail.com>
Content-Language: en-US
X-Originating-IP: [10.43.161.34]
X-ClientProxiedBy: EX13D06UWA004.ant.amazon.com (10.43.160.164) To
 EX13D20UWC001.ant.amazon.com (10.43.162.244)
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: base64
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

CgpPbiAyNC4wOC4yMCAxOToyMywgSmltIE1hdHRzb24gd3JvdGU6Cj4gCj4gT24gU3VuLCBBdWcg
MjMsIDIwMjAgYXQgNjozNSBQTSBBbGV4YW5kZXIgR3JhZiA8Z3JhZkBhbWF6b24uY29tPiB3cm90
ZToKPj4KPj4KPj4KPj4gT24gMjEuMDguMjAgMTk6NTgsIEppbSBNYXR0c29uIHdyb3RlOgo+Pj4K
Pj4+IE9uIFRodSwgQXVnIDIwLCAyMDIwIGF0IDM6NTUgUE0gSmltIE1hdHRzb24gPGptYXR0c29u
QGdvb2dsZS5jb20+IHdyb3RlOgo+Pj4+Cj4+Pj4gT24gVGh1LCBBdWcgMjAsIDIwMjAgYXQgMjo1
OSBQTSBBbGV4YW5kZXIgR3JhZiA8Z3JhZkBhbWF6b24uY29tPiB3cm90ZToKPj4+Pgo+Pj4+PiBE
byB3ZSByZWFsbHkgbmVlZCB0byBkbyBhbGwgb2YgdGhpcyBkYW5jZSBvZiBkaWZmZXJlbnRpYXRp
bmcgaW4ga2VybmVsCj4+Pj4+IHNwYWNlIGJldHdlZW4gYW4gZXhpdCB0aGF0J3MgdGhlcmUgYmVj
YXVzZSB1c2VyIHNwYWNlIGFza2VkIGZvciB0aGUgZXhpdAo+Pj4+PiBhbmQgYW4gTVNSIGFjY2Vz
cyB0aGF0IHdvdWxkIGp1c3QgZ2VuZXJhdGUgYSAjR1A/Cj4+Pj4+Cj4+Pj4+IEF0IHRoZSBlbmQg
b2YgdGhlIGRheSwgdXNlciBzcGFjZSAqa25vd3MqIHdoaWNoIE1TUnMgaXQgYXNrZWQgdG8KPj4+
Pj4gcmVjZWl2ZS4gSXQgY2FuIGZpbHRlciBmb3IgdGhlbSBzdXBlciBlYXNpbHkuCj4+Pj4KPj4+
PiBJZiBubyBvbmUgZWxzZSBoYXMgYW4gb3BpbmlvbiwgSSBjYW4gbGV0IHRoaXMgZ28uIDotKQo+
Pj4+Cj4+Pj4gSG93ZXZlciwgdG8gbWFrZSB0aGUgcmlnaHQgZGVjaXNpb24gaW4ga3ZtX2VtdWxh
dGVfe3JkbXNyLHdybXNyfQo+Pj4+ICh3aXRob3V0IHRoZSB1bmZvcnR1bmF0ZSBiZWZvcmUgYW5k
IGFmdGVyIGNoZWNrcyB0aGF0IEFhcm9uIGFkZGVkKSwKPj4+PiBrdm1fe2dldCxzZXR9X21zciBz
aG91bGQgYXQgbGVhc3QgZGlzdGluZ3Vpc2ggYmV0d2VlbiAicGVybWlzc2lvbgo+Pj4+IGRlbmll
ZCIgYW5kICJyYWlzZSAjR1AsIiBzbyBJIGNhbiBwcm92aWRlIGEgZGVueSBsaXN0IHdpdGhvdXQg
YXNraW5nCj4+Pj4gZm9yIHVzZXJzcGFjZSBleGl0cyBvbiAjR1AuCj4+Pgo+Pj4gQWN0dWFsbHks
IEkgdGhpbmsgdGhpcyB3aG9sZSBkaXNjdXNzaW9uIGlzIG1vb3QuIFlvdSBubyBsb25nZXIgbmVl
ZAo+Pj4gdGhlIGZpcnN0IGlvY3RsIChhc2sgZm9yIGEgdXNlcnNwYWNlIGV4aXQgb24gI0dQKS4g
VGhlIGFsbG93L2RlbnkgbGlzdAo+Pj4gaXMgc3VmZmljaWVudC4gTW9yZW92ZXIsIHRoZSBhbGxv
dy9kZW55IGxpc3QgY2hlY2tzIGNhbiBiZSBpbgo+Pj4ga3ZtX2VtdWxhdGVfe3JkbXNyLHdybXNy
fSBiZWZvcmUgdGhlIGNhbGwgdG8ga3ZtX3tnZXQsc2V0fV9tc3IsIHNvIHdlCj4+PiBuZWVkbid0
IGJlIGNvbmNlcm5lZCB3aXRoIGRpc3Rpbmd1aXNoYWJsZSBlcnJvciB2YWx1ZXMgZWl0aGVyLgo+
Pj4KPj4KPj4gSSBhbHNvIGNhcmUgYWJvdXQgY2FzZXMgd2hlcmUgSSBhbGxvdyBpbi1rZXJuZWwg
aGFuZGxpbmcsIGJ1dCBmb3IKPj4gd2hhdGV2ZXIgcmVhc29uIHRoZXJlIHN0aWxsIHdvdWxkIGJl
IGEgI0dQIGluamVjdGVkIGludG8gdGhlIGd1ZXN0LiBJCj4+IHdhbnQgdG8gcmVjb3JkIHRob3Nl
IGV2ZW50cyBhbmQgYmUgYWJsZSB0byBsYXRlciBoYXZlIGRhdGEgdGhhdCB0ZWxsIG1lCj4+IHdo
eSBzb21ldGhpbmcgd2VudCB3cm9uZy4KPj4KPj4gU28geWVzLCBmb3IgeW91ciB1c2UgY2FzZSB5
b3UgZG8gbm90IGNhcmUgYWJvdXQgdGhlIGRpc3RpbmN0aW9uIGJldHdlZW4KPj4gImRlbnkgTVNS
IGFjY2VzcyIgYW5kICJyZXBvcnQgaW52YWxpZCBNU1IgYWNjZXNzIi4gSG93ZXZlciwgSSBkbyBj
YXJlIDopLgo+IAo+IEluIHRoYXQgY2FzZSwgSSdtIGdvaW5nIHRvIGNvbnRpbnVlIHRvIGhvbGQg
YSBoYXJkIGxpbmUgb24gdGhlCj4gZGlzdGluY3Rpb24gYmV0d2VlbiBhICNHUCBmb3IgYW4gaW52
YWxpZCBNU1IgYWNjZXNzIGFuZCB0aGUgI0dQIGZvciBhbgo+IHVua25vd24gTVNSLiBJZiwgZm9y
IGluc3RhbmNlLCB5b3Ugd2FudGVkIHRvIGltcGxlbWVudCBpZ25vcmVfbXNycyBpbgo+IHVzZXJz
cGFjZSwgYXMgeW91J3ZlIHByb3Bvc2VkIGluIHRoZSBwYXN0LCB0aGlzIHdvdWxkIGJlIGV4dHJl
bWVseQo+IGhlbHBmdWwuIFdpdGhvdXQgaXQsIHVzZXJzcGFjZSBnZXRzIGFuIGV4aXQgYmVjYXVz
ZSAoMSkgdGhlIE1TUiBhY2Nlc3MKPiBpc24ndCBpbiB0aGUgYWxsb3cgbGlzdCwgKDIpIHRoZSBN
U1IgYWNjZXNzIGlzIGludmFsaWQsIG9yICgzKSB0aGUgTVNSCj4gaXMgdW5rbm93biB0byBrdm0u
IEFzIHlvdSd2ZSBwb2ludGVkIG91dCwgaXQgaXMgZWFzeSBmb3IgdXNlcnNwYWNlIHRvCj4gZGlz
dGluZ3Vpc2ggKDEpIGZyb20gdGhlIG90aGVycywgc2luY2UgaXQgcHJvdmlkZWQgdGhlIGFsbG93
L2RlbnkgbGlzdAo+IGluIHRoZSBmaXJzdCBwbGFjZS4gQnV0IGhvdyBkbyB5b3UgZGlzdGluZ3Vp
c2ggKDIpIGZyb20gKDMpIHdpdGhvdXQKPiByZXBsaWNhdGluZyB0aGUgbG9naWMgaW4gdGhlIGtl
cm5lbD8KPiAKPj4gTXkgc3RhbmNlIG9uIHRoaXMgaXMgYWdhaW4gdGhhdCBpdCdzIHRyaXZpYWwg
dG8gaGFuZGxlIGEgZmV3IGludmFsaWQgTVNSCj4+ICNHUHMgZnJvbSB1c2VyIHNwYWNlIGFuZCBq
dXN0IG5vdCByZXBvcnQgYW55dGhpbmcuIEl0IHNob3VsZCBjb21lIGF0Cj4+IGFsbW9zdCBuZWds
aWdpYmxlIHBlcmZvcm1hbmNlIGNvc3QsIG5vPwo+IAo+IFllcywgdGhlIHBlcmZvcm1hbmNlIGNv
c3Qgc2hvdWxkIGJlIG5lZ2xpZ2libGUsIGJ1dCB3aGF0IGlzIHRoZSBwb2ludD8KPiBXZSdyZSB0
cnlpbmcgdG8gZGVzaWduIGEgZ29vZCBBUEkgaGVyZSwgYXJlbid0IHdlPwo+IAo+PiBBcyBmb3Ig
eW91ciBhcmd1bWVudGF0aW9uIGFib3ZlLCB3ZSBoYXZlIGEgc2Vjb25kIGNhbGwgY2hhaW4gaW50
bwo+PiBrdm1fe2dldCxzZXR9X21zciBmcm9tIHRoZSB4ODYgZW11bGF0b3Igd2hpY2ggeW91J2Qg
YWxzbyBuZWVkIHRvIGNvdmVyLgo+Pgo+PiBPbmUgdGhpbmcgd2UgY291bGQgZG8gSSBndWVzcyBp
cyB0byBhZGQgYSBwYXJhbWV0ZXIgdG8gRU5BQkxFX0NBUCBvbgo+PiBLVk1fQ0FQX1g4Nl9VU0VS
X1NQQUNFX01TUiBzbyB0aGF0IGl0IG9ubHkgYm91bmNlcyBvbiBjZXJ0YWluIHJldHVybgo+PiB2
YWx1ZXMsIHN1Y2ggYXMgLUVOT0VOVC4gSSBzdGlsbCBmYWlsIHRvIHNlZSBjYXNlcyB3aGVyZSB0
aGF0J3MKPj4gZ2VudWluZWx5IGJlbmVmaWNpYWwgdGhvdWdoLgo+IAo+IEknZCBsaWtlIHRvIHNl
ZSB0d28gY29tcGxldGVseSBpbmRlcGVuZGVudCBBUElzLCBzbyB0aGF0IEkgY2FuIGp1c3QKPiBy
ZXF1ZXN0IGEgYm91bmNlIG9uIC1FUEVSTSB0aHJvdWdoIGEgZGVueSBsaXN0LiAgSSB0aGluayBp
dCdzIHVzZWZ1bAoKV2hlcmUgd291bGQgdGhhdCBib3VuY2UgdG8/IFdoaWNoIHVzZXIgc3BhY2Ug
ZXZlbnQgZG9lcyB0aGF0IHRyaWdnZXI/IApZZXQgYW5vdGhlciBvbmU/IFdvdWxkbid0IDQgZXhp
dCByZWFzb25zIGp1c3QgZm9yIE1TUiB0cmFwcyBiZSBhIGJpdCAKbXVjaD8gOikKCj4gdG8gZGlz
dGluZ3Vpc2ggYmV0d2VlbiAtRU5PRU5UIGFuZCAtRUlOVkFMLCBidXQgSSBoYXZlIG5vIGlzc3Vl
cyB3aWgKPiBib3RoIGNhdXNpbmcgYW4gZXhpdCB0byB1c2Vyc3BhY2UsIGlmIHVzZXJzcGFjZSBo
YXMgcmVxdWVzdGVkIGV4aXRzIG9uCj4gTVNSICNHUHMuCgpTbyBpbWFnaW5lIHdlIHRvb2sgdGhl
IGZpcnN0IGFyZ3VtZW50IHRvIEVOQUJMRV9DQVAgYXMgZmlsdGVyOgoKICAgKDE8PDApIFJFUE9S
VF9FTk9FTlQKICAgKDE8PDEpIFJFUE9SVF9FSU5WQUwKICAgKDE8PDIpIFJFUE9SVF9FUEVSTQog
ICAoMTw8MzEpIFJFUE9SVF9BTlkKClRoZW4gd2UgYWxzbyBhZGQgdGhlIHJlYXNvbiB0byB0aGUg
a3ZtX3J1biBleGl0IHJlc3BvbnNlIGFuZCB1c2VyIHNwYWNlIApjYW4gZGlmZmVyZW50aWF0ZSBl
YXNpbHkgYmV0d2VlbiB0aGUgZGlmZmVyZW50IGV2ZW50cy4KCgpBbGV4CgoKCkFtYXpvbiBEZXZl
bG9wbWVudCBDZW50ZXIgR2VybWFueSBHbWJICktyYXVzZW5zdHIuIDM4CjEwMTE3IEJlcmxpbgpH
ZXNjaGFlZnRzZnVlaHJ1bmc6IENocmlzdGlhbiBTY2hsYWVnZXIsIEpvbmF0aGFuIFdlaXNzCkVp
bmdldHJhZ2VuIGFtIEFtdHNnZXJpY2h0IENoYXJsb3R0ZW5idXJnIHVudGVyIEhSQiAxNDkxNzMg
QgpTaXR6OiBCZXJsaW4KVXN0LUlEOiBERSAyODkgMjM3IDg3OQoKCg==

