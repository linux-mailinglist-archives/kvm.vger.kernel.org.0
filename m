Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DAA724F0EB
	for <lists+kvm@lfdr.de>; Mon, 24 Aug 2020 03:43:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727077AbgHXBf6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 23 Aug 2020 21:35:58 -0400
Received: from smtp-fw-2101.amazon.com ([72.21.196.25]:50797 "EHLO
        smtp-fw-2101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726988AbgHXBf5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 23 Aug 2020 21:35:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1598232956; x=1629768956;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=kBrYgvyE2N95vgWKj9lsORsmxJ2qAXwLoh4D75kx/hw=;
  b=Mb14sSwvEcFVwK/t3hF09J2MPdfuiEaqWrnVh5cNi2zKM9nMd/k7Vu53
   u0v/F79Nu9xx/RLYqY/GkTUvcKF+mDqpqqAmGnDDYjvT4y1QhNsYXLY3d
   FYIqYLuRx5uFstK8Yzq4UK5ow3/jfWSAdkA3pqCoG8Jjx1vNmL3ZJUEkX
   8=;
X-IronPort-AV: E=Sophos;i="5.76,346,1592870400"; 
   d="scan'208";a="49369476"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-1d-474bcd9f.us-east-1.amazon.com) ([10.43.8.2])
  by smtp-border-fw-out-2101.iad2.amazon.com with ESMTP; 24 Aug 2020 01:35:55 +0000
Received: from EX13MTAUWC002.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan3.iad.amazon.com [10.40.159.166])
        by email-inbound-relay-1d-474bcd9f.us-east-1.amazon.com (Postfix) with ESMTPS id C1660A1CB8;
        Mon, 24 Aug 2020 01:35:53 +0000 (UTC)
Received: from EX13D20UWC001.ant.amazon.com (10.43.162.244) by
 EX13MTAUWC002.ant.amazon.com (10.43.162.240) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 24 Aug 2020 01:35:52 +0000
Received: from vpn-10-85-88-4.fra53.corp.amazon.com (10.43.162.73) by
 EX13D20UWC001.ant.amazon.com (10.43.162.244) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 24 Aug 2020 01:35:50 +0000
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
From:   Alexander Graf <graf@amazon.com>
Message-ID: <cf256ff0-8336-06fc-b475-8ca00782c4ce@amazon.com>
Date:   Mon, 24 Aug 2020 03:35:48 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.1.1
MIME-Version: 1.0
In-Reply-To: <CALMp9eTUV9Z7hL_qtdKYvqYmm8wT1_oGaRLp55i3ttg1qLyecQ@mail.gmail.com>
Content-Language: en-US
X-Originating-IP: [10.43.162.73]
X-ClientProxiedBy: EX13D11UWB004.ant.amazon.com (10.43.161.90) To
 EX13D20UWC001.ant.amazon.com (10.43.162.244)
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: base64
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

CgpPbiAyMS4wOC4yMCAxOTo1OCwgSmltIE1hdHRzb24gd3JvdGU6Cj4gCj4gT24gVGh1LCBBdWcg
MjAsIDIwMjAgYXQgMzo1NSBQTSBKaW0gTWF0dHNvbiA8am1hdHRzb25AZ29vZ2xlLmNvbT4gd3Jv
dGU6Cj4+Cj4+IE9uIFRodSwgQXVnIDIwLCAyMDIwIGF0IDI6NTkgUE0gQWxleGFuZGVyIEdyYWYg
PGdyYWZAYW1hem9uLmNvbT4gd3JvdGU6Cj4+Cj4+PiBEbyB3ZSByZWFsbHkgbmVlZCB0byBkbyBh
bGwgb2YgdGhpcyBkYW5jZSBvZiBkaWZmZXJlbnRpYXRpbmcgaW4ga2VybmVsCj4+PiBzcGFjZSBi
ZXR3ZWVuIGFuIGV4aXQgdGhhdCdzIHRoZXJlIGJlY2F1c2UgdXNlciBzcGFjZSBhc2tlZCBmb3Ig
dGhlIGV4aXQKPj4+IGFuZCBhbiBNU1IgYWNjZXNzIHRoYXQgd291bGQganVzdCBnZW5lcmF0ZSBh
ICNHUD8KPj4+Cj4+PiBBdCB0aGUgZW5kIG9mIHRoZSBkYXksIHVzZXIgc3BhY2UgKmtub3dzKiB3
aGljaCBNU1JzIGl0IGFza2VkIHRvCj4+PiByZWNlaXZlLiBJdCBjYW4gZmlsdGVyIGZvciB0aGVt
IHN1cGVyIGVhc2lseS4KPj4KPj4gSWYgbm8gb25lIGVsc2UgaGFzIGFuIG9waW5pb24sIEkgY2Fu
IGxldCB0aGlzIGdvLiA6LSkKPj4KPj4gSG93ZXZlciwgdG8gbWFrZSB0aGUgcmlnaHQgZGVjaXNp
b24gaW4ga3ZtX2VtdWxhdGVfe3JkbXNyLHdybXNyfQo+PiAod2l0aG91dCB0aGUgdW5mb3J0dW5h
dGUgYmVmb3JlIGFuZCBhZnRlciBjaGVja3MgdGhhdCBBYXJvbiBhZGRlZCksCj4+IGt2bV97Z2V0
LHNldH1fbXNyIHNob3VsZCBhdCBsZWFzdCBkaXN0aW5ndWlzaCBiZXR3ZWVuICJwZXJtaXNzaW9u
Cj4+IGRlbmllZCIgYW5kICJyYWlzZSAjR1AsIiBzbyBJIGNhbiBwcm92aWRlIGEgZGVueSBsaXN0
IHdpdGhvdXQgYXNraW5nCj4+IGZvciB1c2Vyc3BhY2UgZXhpdHMgb24gI0dQLgo+IAo+IEFjdHVh
bGx5LCBJIHRoaW5rIHRoaXMgd2hvbGUgZGlzY3Vzc2lvbiBpcyBtb290LiBZb3Ugbm8gbG9uZ2Vy
IG5lZWQKPiB0aGUgZmlyc3QgaW9jdGwgKGFzayBmb3IgYSB1c2Vyc3BhY2UgZXhpdCBvbiAjR1Ap
LiBUaGUgYWxsb3cvZGVueSBsaXN0Cj4gaXMgc3VmZmljaWVudC4gTW9yZW92ZXIsIHRoZSBhbGxv
dy9kZW55IGxpc3QgY2hlY2tzIGNhbiBiZSBpbgo+IGt2bV9lbXVsYXRlX3tyZG1zcix3cm1zcn0g
YmVmb3JlIHRoZSBjYWxsIHRvIGt2bV97Z2V0LHNldH1fbXNyLCBzbyB3ZQo+IG5lZWRuJ3QgYmUg
Y29uY2VybmVkIHdpdGggZGlzdGluZ3Vpc2hhYmxlIGVycm9yIHZhbHVlcyBlaXRoZXIuCj4gCgpJ
IGFsc28gY2FyZSBhYm91dCBjYXNlcyB3aGVyZSBJIGFsbG93IGluLWtlcm5lbCBoYW5kbGluZywg
YnV0IGZvciAKd2hhdGV2ZXIgcmVhc29uIHRoZXJlIHN0aWxsIHdvdWxkIGJlIGEgI0dQIGluamVj
dGVkIGludG8gdGhlIGd1ZXN0LiBJIAp3YW50IHRvIHJlY29yZCB0aG9zZSBldmVudHMgYW5kIGJl
IGFibGUgdG8gbGF0ZXIgaGF2ZSBkYXRhIHRoYXQgdGVsbCBtZSAKd2h5IHNvbWV0aGluZyB3ZW50
IHdyb25nLgoKU28geWVzLCBmb3IgeW91ciB1c2UgY2FzZSB5b3UgZG8gbm90IGNhcmUgYWJvdXQg
dGhlIGRpc3RpbmN0aW9uIGJldHdlZW4gCiJkZW55IE1TUiBhY2Nlc3MiIGFuZCAicmVwb3J0IGlu
dmFsaWQgTVNSIGFjY2VzcyIuIEhvd2V2ZXIsIEkgZG8gY2FyZSA6KS4KCk15IHN0YW5jZSBvbiB0
aGlzIGlzIGFnYWluIHRoYXQgaXQncyB0cml2aWFsIHRvIGhhbmRsZSBhIGZldyBpbnZhbGlkIE1T
UiAKI0dQcyBmcm9tIHVzZXIgc3BhY2UgYW5kIGp1c3Qgbm90IHJlcG9ydCBhbnl0aGluZy4gSXQg
c2hvdWxkIGNvbWUgYXQgCmFsbW9zdCBuZWdsaWdpYmxlIHBlcmZvcm1hbmNlIGNvc3QsIG5vPwoK
QXMgZm9yIHlvdXIgYXJndW1lbnRhdGlvbiBhYm92ZSwgd2UgaGF2ZSBhIHNlY29uZCBjYWxsIGNo
YWluIGludG8gCmt2bV97Z2V0LHNldH1fbXNyIGZyb20gdGhlIHg4NiBlbXVsYXRvciB3aGljaCB5
b3UnZCBhbHNvIG5lZWQgdG8gY292ZXIuCgpPbmUgdGhpbmcgd2UgY291bGQgZG8gSSBndWVzcyBp
cyB0byBhZGQgYSBwYXJhbWV0ZXIgdG8gRU5BQkxFX0NBUCBvbiAKS1ZNX0NBUF9YODZfVVNFUl9T
UEFDRV9NU1Igc28gdGhhdCBpdCBvbmx5IGJvdW5jZXMgb24gY2VydGFpbiByZXR1cm4gCnZhbHVl
cywgc3VjaCBhcyAtRU5PRU5ULiBJIHN0aWxsIGZhaWwgdG8gc2VlIGNhc2VzIHdoZXJlIHRoYXQn
cyAKZ2VudWluZWx5IGJlbmVmaWNpYWwgdGhvdWdoLgoKCkFsZXgKCgoKQW1hem9uIERldmVsb3Bt
ZW50IENlbnRlciBHZXJtYW55IEdtYkgKS3JhdXNlbnN0ci4gMzgKMTAxMTcgQmVybGluCkdlc2No
YWVmdHNmdWVocnVuZzogQ2hyaXN0aWFuIFNjaGxhZWdlciwgSm9uYXRoYW4gV2Vpc3MKRWluZ2V0
cmFnZW4gYW0gQW10c2dlcmljaHQgQ2hhcmxvdHRlbmJ1cmcgdW50ZXIgSFJCIDE0OTE3MyBCClNp
dHo6IEJlcmxpbgpVc3QtSUQ6IERFIDI4OSAyMzcgODc5CgoK

