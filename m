Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9AF6622B9EF
	for <lists+kvm@lfdr.de>; Fri, 24 Jul 2020 01:04:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727833AbgGWXEz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Jul 2020 19:04:55 -0400
Received: from smtp-fw-9102.amazon.com ([207.171.184.29]:29539 "EHLO
        smtp-fw-9102.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726833AbgGWXEy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Jul 2020 19:04:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazon201209;
  t=1595545494; x=1627081494;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=Oh+ogmc/TZuhxAnxxb6YKUirrCeSsjN12kP5BQhIWsQ=;
  b=mHEcJO4W8ptFk8hwAoN5u79eJXEcoIH3//qJOI75geuqOQHidi0LgqrS
   2o5uSRu9kU87t6qQ07bVWjpHdifigKtUz6lteBL/hxxwFaT5s5MEzxj/z
   30dAJuR6eAxKvqeVhkOHPIg1UxZRHefN+7ASj+EtYqkfQ4l+ZroRxozxl
   s=;
IronPort-SDR: FVx39MKBJlHtHaCBgRLXtkRO+PxGL83OjnX1sX954gFXGeY9H4BhtjzuZbeUyGkP0p3sCNNTBD
 ghnX+ak/hwTQ==
X-IronPort-AV: E=Sophos;i="5.75,388,1589241600"; 
   d="scan'208";a="62428285"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-2b-8cc5d68b.us-west-2.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9102.sea19.amazon.com with ESMTP; 23 Jul 2020 23:04:48 +0000
Received: from EX13MTAUWC001.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan3.pdx.amazon.com [10.170.41.166])
        by email-inbound-relay-2b-8cc5d68b.us-west-2.amazon.com (Postfix) with ESMTPS id 73454A2432;
        Thu, 23 Jul 2020 23:04:46 +0000 (UTC)
Received: from EX13D20UWC001.ant.amazon.com (10.43.162.244) by
 EX13MTAUWC001.ant.amazon.com (10.43.162.135) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Thu, 23 Jul 2020 23:04:45 +0000
Received: from 38f9d3867b82.ant.amazon.com (10.43.160.26) by
 EX13D20UWC001.ant.amazon.com (10.43.162.244) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Thu, 23 Jul 2020 23:04:40 +0000
Subject: Re: [PATCH v5 01/18] nitro_enclaves: Add ioctl interface definition
To:     "Paraschiv, Andra-Irina" <andraprs@amazon.com>,
        Greg KH <gregkh@linuxfoundation.org>
CC:     <linux-kernel@vger.kernel.org>,
        Anthony Liguori <aliguori@amazon.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Colm MacCarthaigh <colmmacc@amazon.com>,
        David Duncan <davdunc@amazon.com>,
        Bjoern Doebel <doebel@amazon.de>,
        David Woodhouse <dwmw@amazon.co.uk>,
        Frank van der Linden <fllinden@amazon.com>,
        Karen Noel <knoel@redhat.com>,
        Martin Pohlack <mpohlack@amazon.de>,
        Matt Wilson <msw@amazon.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Balbir Singh <sblbir@amazon.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Stewart Smith <trawets@amazon.com>,
        Uwe Dannowski <uwed@amazon.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>, <kvm@vger.kernel.org>,
        <ne-devel-upstream@amazon.com>, Alexander Graf <graf@amazon.com>
References: <20200715194540.45532-1-andraprs@amazon.com>
 <20200715194540.45532-2-andraprs@amazon.com>
 <20200721121225.GA1855212@kroah.com>
 <5dad638c-0ef3-9d16-818c-54e1556d8fc8@amazon.com>
 <20200722095759.GA2817347@kroah.com>
 <b952de82-94de-fc14-74d3-f13859fe19f0@amazon.com>
 <20200723105409.GC1949236@kroah.com>
 <dd99213b-3caf-4fc0-1bf5-314297e3d450@amazon.com>
From:   Alexander Graf <graf@amazon.de>
Message-ID: <a085bf17-8f83-5946-0f79-97230616b4b3@amazon.de>
Date:   Fri, 24 Jul 2020 01:04:39 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <dd99213b-3caf-4fc0-1bf5-314297e3d450@amazon.com>
Content-Language: en-US
X-Originating-IP: [10.43.160.26]
X-ClientProxiedBy: EX13D37UWA002.ant.amazon.com (10.43.160.211) To
 EX13D20UWC001.ant.amazon.com (10.43.162.244)
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: base64
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

CgpPbiAyMy4wNy4yMCAyMDoyMSwgUGFyYXNjaGl2LCBBbmRyYS1JcmluYSB3cm90ZToKPiAKPiAK
PiBPbiAyMy8wNy8yMDIwIDEzOjU0LCBHcmVnIEtIIHdyb3RlOgo+PiBPbiBUaHUsIEp1bCAyMywg
MjAyMCBhdCAxMjoyMzo1NlBNICswMzAwLCBQYXJhc2NoaXYsIEFuZHJhLUlyaW5hIHdyb3RlOgo+
Pj4KPj4+IE9uIDIyLzA3LzIwMjAgMTI6NTcsIEdyZWcgS0ggd3JvdGU6Cj4+Pj4gT24gV2VkLCBK
dWwgMjIsIDIwMjAgYXQgMTE6Mjc6MjlBTSArMDMwMCwgUGFyYXNjaGl2LCBBbmRyYS1JcmluYSB3
cm90ZToKPj4+Pj4+PiArI2lmbmRlZiBfVUFQSV9MSU5VWF9OSVRST19FTkNMQVZFU19IXwo+Pj4+
Pj4+ICsjZGVmaW5lIF9VQVBJX0xJTlVYX05JVFJPX0VOQ0xBVkVTX0hfCj4+Pj4+Pj4gKwo+Pj4+
Pj4+ICsjaW5jbHVkZSA8bGludXgvdHlwZXMuaD4KPj4+Pj4+PiArCj4+Pj4+Pj4gKy8qIE5pdHJv
IEVuY2xhdmVzIChORSkgS2VybmVsIERyaXZlciBJbnRlcmZhY2UgKi8KPj4+Pj4+PiArCj4+Pj4+
Pj4gKyNkZWZpbmUgTkVfQVBJX1ZFUlNJT04gKDEpCj4+Pj4+PiBXaHkgZG8geW91IG5lZWQgdGhp
cyB2ZXJzaW9uP8KgIEl0IHNob3VsZG4ndCBiZSBuZWVkZWQsIHJpZ2h0Pwo+Pj4+PiBUaGUgdmVy
c2lvbiBpcyB1c2VkIGFzIGEgd2F5IGZvciB0aGUgdXNlciBzcGFjZSB0b29saW5nIHRvIHN5bmMg
b24gdGhlCj4+Pj4+IGZlYXR1cmVzIHNldCBwcm92aWRlZCBieSB0aGUgZHJpdmVyIGUuZy4gaW4g
Y2FzZSBhbiBvbGRlciB2ZXJzaW9uIAo+Pj4+PiBvZiB0aGUKPj4+Pj4gZHJpdmVyIGlzIGF2YWls
YWJsZSBvbiB0aGUgc3lzdGVtIGFuZCB0aGUgdXNlciBzcGFjZSB0b29saW5nIAo+Pj4+PiBleHBl
Y3RzIGEgc2V0Cj4+Pj4+IG9mIGZlYXR1cmVzIHRoYXQgaXMgbm90IGluY2x1ZGVkIGluIHRoYXQg
ZHJpdmVyIHZlcnNpb24uCj4+Pj4gVGhhdCBpcyBndWFyYW50ZWVkIHRvIGdldCBvdXQgb2Ygc3lu
YyBpbnN0YW50bHkgd2l0aCBkaWZmZXJlbnQgZGlzdHJvCj4+Pj4ga2VybmVscyBiYWNrcG9ydGlu
ZyByYW5kb20gdGhpbmdzLCBjb21iaW5lZCB3aXRoIHN0YWJsZSBrZXJuZWwgcGF0Y2gKPj4+PiB1
cGRhdGVzIGFuZCB0aGUgbGlrZS4KPj4+Pgo+Pj4+IEp1c3QgdXNlIHRoZSBub3JtYWwgYXBpIGlu
dGVyZmFjZXMgaW5zdGVhZCwgZG9uJ3QgdHJ5IHRvICJ2ZXJzaW9uIgo+Pj4+IGFueXRoaW5nLCBp
dCB3aWxsIG5vdCB3b3JrLCB0cnVzdCB1cyA6KQo+Pj4+Cj4+Pj4gSWYgYW4gaW9jdGwgcmV0dXJu
cyAtRU5PVFRZIHRoZW4gaGV5LCBpdCdzIG5vdCBwcmVzZW50IGFuZCB5b3VyCj4+Pj4gdXNlcnNw
YWNlIGNvZGUgY2FuIGhhbmRsZSBpdCB0aGF0IHdheS4KPj4+IENvcnJlY3QsIHRoZXJlIGNvdWxk
IGJlIGEgdmFyaWV0eSBvZiBrZXJuZWwgdmVyc2lvbnMgYW5kIHVzZXIgc3BhY2UgCj4+PiB0b29s
aW5nCj4+PiBlaXRoZXIgaW4gdGhlIG9yaWdpbmFsIGZvcm0sIGN1c3RvbWl6ZWQgb3Igd3JpdHRl
biBmcm9tIHNjcmF0Y2guIEFuZCAKPj4+IEVOT1RUWQo+Pj4gc2lnbmFscyBhbiBpb2N0bCBub3Qg
YXZhaWxhYmxlIG9yIGUuZy4gRUlOVkFMIChvciBjdXN0b20gZXJyb3IpIGlmIHRoZQo+Pj4gcGFy
YW1ldGVyIGZpZWxkIHZhbHVlIGlzIG5vdCB2YWxpZCB3aXRoaW4gYSBjZXJ0YWluIHZlcnNpb24u
IFdlIGhhdmUgCj4+PiB0aGVzZQo+Pj4gaW4gcGxhY2UsIHRoYXQncyBnb29kLiA6KQo+Pj4KPj4+
IEhvd2V2ZXIsIEkgd2FzIHRoaW5raW5nLCBmb3IgZXhhbXBsZSwgb2YgYW4gaW9jdGwgZmxvdyB1
c2FnZSB3aGVyZSBhIAo+Pj4gY2VydGFpbgo+Pj4gb3JkZXIgbmVlZHMgdG8gYmUgZm9sbG93ZWQg
ZS5nLiBjcmVhdGUgYSBWTSwgYWRkIHJlc291cmNlcyB0byBhIFZNLCAKPj4+IHN0YXJ0IGEKPj4+
IFZNLgo+Pj4KPj4+IExldCdzIHNheSwgZm9yIGFuIHVzZSBjYXNlIHdydCBuZXcgZmVhdHVyZXMs
IGlvY3RsIEEgKGNyZWF0ZSBhIFZNKSAKPj4+IHN1Y2NlZWRzLAo+Pj4gaW9jdGwgQiAoYWRkIG1l
bW9yeSB0byB0aGUgVk0pIHN1Y2NlZWRzLCBpb2N0bCBDIChhZGQgQ1BVIHRvIHRoZSBWTSkKPj4+
IHN1Y2NlZWRzIGFuZCBpb2N0bCBEIChhZGQgYW55IG90aGVyIHR5cGUgb2YgcmVzb3VyY2UgYmVm
b3JlIHN0YXJ0aW5nIAo+Pj4gdGhlIFZNKQo+Pj4gZmFpbHMgYmVjYXVzZSBpdCBpcyBub3Qgc3Vw
cG9ydGVkLgo+Pj4KPj4+IFdvdWxkIG5vdCBuZWVkIHRvIGNhbGwgaW9jdGwgQSB0byBDIGFuZCBn
byB0aHJvdWdoIHRoZWlyIHVuZGVybmVhdGggCj4+PiBsb2dpYyB0bwo+Pj4gcmVhbGl6ZSBpb2N0
bCBEIHN1cHBvcnQgaXMgbm90IHRoZXJlIGFuZCByb2xsYmFjayBhbGwgdGhlIGNoYW5nZXMgCj4+
PiBkb25lIHRpbGwKPj4+IHRoZW4gd2l0aGluIGlvY3RsIEEgdG8gQyBsb2dpYy4gT2YgY291cnNl
LCB0aGVyZSBjb3VsZCBiZSBpb2N0bCBBIAo+Pj4gZm9sbG93ZWQKPj4+IGJ5IGlvY3RsIEQsIGFu
ZCB3b3VsZCBuZWVkIHRvIHJvbGxiYWNrIGlvY3RsIEEgY2hhbmdlcywgYnV0IEkgc2hhcmVkIAo+
Pj4gYSBtb3JlCj4+PiBsZW5ndGh5IGNhbGwgY2hhaW4gdGhhdCBjYW4gYmUgYW4gb3B0aW9uIGFz
IHdlbGwuCj4+IEkgdGhpbmsgeW91IGFyZSBvdmVydGhpbmtpbmcgdGhpcy4KPj4KPj4gSWYgeW91
ciBpbnRlcmZhY2UgaXMgdGhpcyBjb21wbGV4LCB5b3UgaGF2ZSBtdWNoIGxhcmdlciBpc3N1ZXMg
YXMgeW91Cj4+IEFMV0FZUyBoYXZlIHRvIGJlIGFibGUgdG8gaGFuZGxlIGVycm9yIGNvbmRpdGlv
bnMgcHJvcGVybHksIGV2ZW4gaWYgdGhlCj4+IEFQSSBpcyAic3VwcG9ydGVkIi4KPiAKPiBUcnVl
LCB0aGUgZXJyb3IgcGF0aHMgbmVlZCB0byBoYW5kbGVkIGNvcnJlY3RseSBvbiB0aGUga2VybmVs
IGRyaXZlciBhbmQgCj4gb24gdGhlIHVzZXIgc3BhY2UgbG9naWMgc2lkZSwgaW5kZXBlbmRlbnQg
b2Ygc3VwcG9ydGVkIGZlYXR1cmVzIG9yIG5vdC4gCj4gQ2Fubm90IGFzc3VtZSB0aGF0IGFsbCBp
b2N0bCBjYWxsZXJzIGFyZSBiZWhhdmluZyBjb3JyZWN0bHkgb3IgdGhlcmUgYXJlIAo+IG5vIGVy
cm9ycyBpbiB0aGUgc3lzdGVtLgo+IAo+IFdoYXQgSSB3YW50ZWQgdG8gY292ZXIgd2l0aCB0aGF0
IGV4YW1wbGUgaXMgbW9yZSB0b3dhcmRzIHRoZSB1c2VyIHNwYWNlIAo+IGxvZ2ljIHVzaW5nIG5l
dyBmZWF0dXJlcywgZWl0aGVyIGVhcmx5IGV4aXRpbmcgYmVmb3JlIGV2ZW4gdHJ5aW5nIHRoZSAK
PiBpb2N0bCBjYWxsIGZsb3cgcGF0aCBvciBnb2luZyB0aHJvdWdoIHBhcnQgb2YgdGhlIGZsb3cg
dGlsbCBnZXR0aW5nIHRoZSAKPiBlcnJvciBlLmcuIEVOT1RUWSBmb3Igb25lIG9mIHRoZSBpb2N0
bCBjYWxscy4KCklmIHdlIG5lZWQgYW4gQVBJIHRvIHF1ZXJ5IGZvciBuZXcgZmVhdHVyZXMsIHdl
IGNhbiBhZGQgaXQgb25jZSB3ZSBhZGQgCm5ldyBmZWF0dXJlcywgbm8/IFRoZSBhYnNlbmNlIG9m
IHRoZSBxdWVyeSBBUEkgd2lsbCBpbmRpY2F0ZSB0aGF0IG5vIAphZGRpdGlvbmFsIGZlYXR1cmVz
IGFyZSBhdmFpbGFibGUuCgpTbyB5ZXMsIHNvcnJ5LCBvdmVyc2lnaHQgb24gbXkgc2lkZSA6KC4g
SSBhZ3JlZSB3aXRoIEdyZWc6IHRoZXJlIHJlYWxseSAKaXMgbm8gbmVlZCBmb3IgYSB2ZXJzaW9u
IHF1ZXJ5IEFQSSBhcyBvZiB0b2RheS4KCj4gCj4+Cj4+IFBlcmhhcHMgeW91ciBBUEkgaXMgc2hv
d2luZyB0byBiZSB0b28gY29tcGxleD8KPj4KPj4gQWxzbywgd2hlcmUgaXMgdGhlIHVzZXJzcGFj
ZSBjb2RlIGZvciBhbGwgb2YgdGhpcz/CoCBEaWQgSSBtaXNzIGEgbGluayB0bwo+PiBpdCBpbiB0
aGUgcGF0Y2hlcyBzb21ld2hlcmU/Cj4gCj4gTm9wZSwgeW91IGRpZG4ndCBtaXNzIGFueSByZWZl
cmVuY2VzIHRvIGl0LiBUaGUgY29kZWJhc2UgZm9yIHRoZSB1c2VyIAo+IHNwYWNlIGNvZGUgaXMg
bm90IHB1YmxpY2x5IGF2YWlsYWJsZSBmb3Igbm93LCBidXQgaXQgd2lsbCBiZSBhdmFpbGFibGUg
Cj4gb24gR2l0SHViIG9uY2UgdGhlIHdob2xlIHByb2plY3QgaXMgR0EuIEFuZCBJJ2xsIGluY2x1
ZGUgdGhlIHJlZnMsIG9uY2UgCj4gYXZhaWxhYmxlLCBpbiB0aGUgTkUga2VybmVsIGRyaXZlciBk
b2N1bWVudGF0aW9uLgoKUGF0Y2ggMTYvMTggY29udGFpbnMgYW4gZXhhbXBsZSB1c2VyIHNwYWNl
IHRvIGRyaXZlIHRoZSBpb2N0bCBpbnRlcmZhY2UuCgpUaGUgY29kZSBiYXNlIEFuZHJhIGlzIHJl
ZmVycmluZyB0byBhYm92ZSBpcyBnb2luZyB0byBiZSBhIG1vcmUgY29tcGxldGUgCmZyYW1ld29y
ayB0byBkcml2ZSBOaXRybyBFbmNsYXZlcyB0aGF0IGFsc28gY29uc3VtZXMgdGhpcyBrZXJuZWwg
QVBJLgoKCkFsZXgKCgoKQW1hem9uIERldmVsb3BtZW50IENlbnRlciBHZXJtYW55IEdtYkgKS3Jh
dXNlbnN0ci4gMzgKMTAxMTcgQmVybGluCkdlc2NoYWVmdHNmdWVocnVuZzogQ2hyaXN0aWFuIFNj
aGxhZWdlciwgSm9uYXRoYW4gV2Vpc3MKRWluZ2V0cmFnZW4gYW0gQW10c2dlcmljaHQgQ2hhcmxv
dHRlbmJ1cmcgdW50ZXIgSFJCIDE0OTE3MyBCClNpdHo6IEJlcmxpbgpVc3QtSUQ6IERFIDI4OSAy
MzcgODc5CgoK

