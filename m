Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3973522B593
	for <lists+kvm@lfdr.de>; Thu, 23 Jul 2020 20:22:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727085AbgGWSWV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Jul 2020 14:22:21 -0400
Received: from smtp-fw-6001.amazon.com ([52.95.48.154]:23171 "EHLO
        smtp-fw-6001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726666AbgGWSWV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Jul 2020 14:22:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1595528540; x=1627064540;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=OqsVKyONHBgrXDgQg9OKR7QshZHpcXMCyDkfKOGw2qs=;
  b=QEdUwYr4uFUywQQlLRwQbU5tB6MJ7QFB47jENzGK1+CoElAjPq98UPWQ
   +tJGHU83l0plkSxbBAIVkb5wb5g0Hbo+b0dnRs2UGaCqz4EcuwNESMw4V
   1uhf6J6NsyY6uuzxe/xWbGtTuneMjg2MKMzJD/6OgCNTg30uVQVWtu8bM
   M=;
IronPort-SDR: WRqLE31tF1s7PT+TAApABwKfYGwIflBjDpx1h+HGZ9TpUC4bd7g4cZmkxOs/EvtVoNjoS4MupM
 6l4rRH1aiKlA==
X-IronPort-AV: E=Sophos;i="5.75,387,1589241600"; 
   d="scan'208";a="45066285"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-2b-81e76b79.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-6001.iad6.amazon.com with ESMTP; 23 Jul 2020 18:22:18 +0000
Received: from EX13MTAUEA002.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan3.pdx.amazon.com [10.170.41.166])
        by email-inbound-relay-2b-81e76b79.us-west-2.amazon.com (Postfix) with ESMTPS id 5338AA1FD1;
        Thu, 23 Jul 2020 18:22:16 +0000 (UTC)
Received: from EX13D16EUB003.ant.amazon.com (10.43.166.99) by
 EX13MTAUEA002.ant.amazon.com (10.43.61.77) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Thu, 23 Jul 2020 18:22:15 +0000
Received: from 38f9d34ed3b1.ant.amazon.com (10.43.161.146) by
 EX13D16EUB003.ant.amazon.com (10.43.166.99) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Thu, 23 Jul 2020 18:22:04 +0000
Subject: Re: [PATCH v5 01/18] nitro_enclaves: Add ioctl interface definition
To:     Greg KH <gregkh@linuxfoundation.org>
CC:     <linux-kernel@vger.kernel.org>,
        Anthony Liguori <aliguori@amazon.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Colm MacCarthaigh <colmmacc@amazon.com>,
        David Duncan <davdunc@amazon.com>,
        Bjoern Doebel <doebel@amazon.de>,
        David Woodhouse <dwmw@amazon.co.uk>,
        Frank van der Linden <fllinden@amazon.com>,
        Alexander Graf <graf@amazon.de>, Karen Noel <knoel@redhat.com>,
        Martin Pohlack <mpohlack@amazon.de>,
        Matt Wilson <msw@amazon.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Balbir Singh <sblbir@amazon.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        "Stefan Hajnoczi" <stefanha@redhat.com>,
        Stewart Smith <trawets@amazon.com>,
        "Uwe Dannowski" <uwed@amazon.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>, <kvm@vger.kernel.org>,
        <ne-devel-upstream@amazon.com>, Alexander Graf <graf@amazon.com>
References: <20200715194540.45532-1-andraprs@amazon.com>
 <20200715194540.45532-2-andraprs@amazon.com>
 <20200721121225.GA1855212@kroah.com>
 <5dad638c-0ef3-9d16-818c-54e1556d8fc8@amazon.com>
 <20200722095759.GA2817347@kroah.com>
 <b952de82-94de-fc14-74d3-f13859fe19f0@amazon.com>
 <20200723105409.GC1949236@kroah.com>
From:   "Paraschiv, Andra-Irina" <andraprs@amazon.com>
Message-ID: <dd99213b-3caf-4fc0-1bf5-314297e3d450@amazon.com>
Date:   Thu, 23 Jul 2020 21:21:51 +0300
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200723105409.GC1949236@kroah.com>
Content-Language: en-US
X-Originating-IP: [10.43.161.146]
X-ClientProxiedBy: EX13D12UWA004.ant.amazon.com (10.43.160.168) To
 EX13D16EUB003.ant.amazon.com (10.43.166.99)
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: base64
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

CgpPbiAyMy8wNy8yMDIwIDEzOjU0LCBHcmVnIEtIIHdyb3RlOgo+IE9uIFRodSwgSnVsIDIzLCAy
MDIwIGF0IDEyOjIzOjU2UE0gKzAzMDAsIFBhcmFzY2hpdiwgQW5kcmEtSXJpbmEgd3JvdGU6Cj4+
Cj4+IE9uIDIyLzA3LzIwMjAgMTI6NTcsIEdyZWcgS0ggd3JvdGU6Cj4+PiBPbiBXZWQsIEp1bCAy
MiwgMjAyMCBhdCAxMToyNzoyOUFNICswMzAwLCBQYXJhc2NoaXYsIEFuZHJhLUlyaW5hIHdyb3Rl
Ogo+Pj4+Pj4gKyNpZm5kZWYgX1VBUElfTElOVVhfTklUUk9fRU5DTEFWRVNfSF8KPj4+Pj4+ICsj
ZGVmaW5lIF9VQVBJX0xJTlVYX05JVFJPX0VOQ0xBVkVTX0hfCj4+Pj4+PiArCj4+Pj4+PiArI2lu
Y2x1ZGUgPGxpbnV4L3R5cGVzLmg+Cj4+Pj4+PiArCj4+Pj4+PiArLyogTml0cm8gRW5jbGF2ZXMg
KE5FKSBLZXJuZWwgRHJpdmVyIEludGVyZmFjZSAqLwo+Pj4+Pj4gKwo+Pj4+Pj4gKyNkZWZpbmUg
TkVfQVBJX1ZFUlNJT04gKDEpCj4+Pj4+IFdoeSBkbyB5b3UgbmVlZCB0aGlzIHZlcnNpb24/ICBJ
dCBzaG91bGRuJ3QgYmUgbmVlZGVkLCByaWdodD8KPj4+PiBUaGUgdmVyc2lvbiBpcyB1c2VkIGFz
IGEgd2F5IGZvciB0aGUgdXNlciBzcGFjZSB0b29saW5nIHRvIHN5bmMgb24gdGhlCj4+Pj4gZmVh
dHVyZXMgc2V0IHByb3ZpZGVkIGJ5IHRoZSBkcml2ZXIgZS5nLiBpbiBjYXNlIGFuIG9sZGVyIHZl
cnNpb24gb2YgdGhlCj4+Pj4gZHJpdmVyIGlzIGF2YWlsYWJsZSBvbiB0aGUgc3lzdGVtIGFuZCB0
aGUgdXNlciBzcGFjZSB0b29saW5nIGV4cGVjdHMgYSBzZXQKPj4+PiBvZiBmZWF0dXJlcyB0aGF0
IGlzIG5vdCBpbmNsdWRlZCBpbiB0aGF0IGRyaXZlciB2ZXJzaW9uLgo+Pj4gVGhhdCBpcyBndWFy
YW50ZWVkIHRvIGdldCBvdXQgb2Ygc3luYyBpbnN0YW50bHkgd2l0aCBkaWZmZXJlbnQgZGlzdHJv
Cj4+PiBrZXJuZWxzIGJhY2twb3J0aW5nIHJhbmRvbSB0aGluZ3MsIGNvbWJpbmVkIHdpdGggc3Rh
YmxlIGtlcm5lbCBwYXRjaAo+Pj4gdXBkYXRlcyBhbmQgdGhlIGxpa2UuCj4+Pgo+Pj4gSnVzdCB1
c2UgdGhlIG5vcm1hbCBhcGkgaW50ZXJmYWNlcyBpbnN0ZWFkLCBkb24ndCB0cnkgdG8gInZlcnNp
b24iCj4+PiBhbnl0aGluZywgaXQgd2lsbCBub3Qgd29yaywgdHJ1c3QgdXMgOikKPj4+Cj4+PiBJ
ZiBhbiBpb2N0bCByZXR1cm5zIC1FTk9UVFkgdGhlbiBoZXksIGl0J3Mgbm90IHByZXNlbnQgYW5k
IHlvdXIKPj4+IHVzZXJzcGFjZSBjb2RlIGNhbiBoYW5kbGUgaXQgdGhhdCB3YXkuCj4+IENvcnJl
Y3QsIHRoZXJlIGNvdWxkIGJlIGEgdmFyaWV0eSBvZiBrZXJuZWwgdmVyc2lvbnMgYW5kIHVzZXIg
c3BhY2UgdG9vbGluZwo+PiBlaXRoZXIgaW4gdGhlIG9yaWdpbmFsIGZvcm0sIGN1c3RvbWl6ZWQg
b3Igd3JpdHRlbiBmcm9tIHNjcmF0Y2guIEFuZCBFTk9UVFkKPj4gc2lnbmFscyBhbiBpb2N0bCBu
b3QgYXZhaWxhYmxlIG9yIGUuZy4gRUlOVkFMIChvciBjdXN0b20gZXJyb3IpIGlmIHRoZQo+PiBw
YXJhbWV0ZXIgZmllbGQgdmFsdWUgaXMgbm90IHZhbGlkIHdpdGhpbiBhIGNlcnRhaW4gdmVyc2lv
bi4gV2UgaGF2ZSB0aGVzZQo+PiBpbiBwbGFjZSwgdGhhdCdzIGdvb2QuIDopCj4+Cj4+IEhvd2V2
ZXIsIEkgd2FzIHRoaW5raW5nLCBmb3IgZXhhbXBsZSwgb2YgYW4gaW9jdGwgZmxvdyB1c2FnZSB3
aGVyZSBhIGNlcnRhaW4KPj4gb3JkZXIgbmVlZHMgdG8gYmUgZm9sbG93ZWQgZS5nLiBjcmVhdGUg
YSBWTSwgYWRkIHJlc291cmNlcyB0byBhIFZNLCBzdGFydCBhCj4+IFZNLgo+Pgo+PiBMZXQncyBz
YXksIGZvciBhbiB1c2UgY2FzZSB3cnQgbmV3IGZlYXR1cmVzLCBpb2N0bCBBIChjcmVhdGUgYSBW
TSkgc3VjY2VlZHMsCj4+IGlvY3RsIEIgKGFkZCBtZW1vcnkgdG8gdGhlIFZNKSBzdWNjZWVkcywg
aW9jdGwgQyAoYWRkIENQVSB0byB0aGUgVk0pCj4+IHN1Y2NlZWRzIGFuZCBpb2N0bCBEIChhZGQg
YW55IG90aGVyIHR5cGUgb2YgcmVzb3VyY2UgYmVmb3JlIHN0YXJ0aW5nIHRoZSBWTSkKPj4gZmFp
bHMgYmVjYXVzZSBpdCBpcyBub3Qgc3VwcG9ydGVkLgo+Pgo+PiBXb3VsZCBub3QgbmVlZCB0byBj
YWxsIGlvY3RsIEEgdG8gQyBhbmQgZ28gdGhyb3VnaCB0aGVpciB1bmRlcm5lYXRoIGxvZ2ljIHRv
Cj4+IHJlYWxpemUgaW9jdGwgRCBzdXBwb3J0IGlzIG5vdCB0aGVyZSBhbmQgcm9sbGJhY2sgYWxs
IHRoZSBjaGFuZ2VzIGRvbmUgdGlsbAo+PiB0aGVuIHdpdGhpbiBpb2N0bCBBIHRvIEMgbG9naWMu
IE9mIGNvdXJzZSwgdGhlcmUgY291bGQgYmUgaW9jdGwgQSBmb2xsb3dlZAo+PiBieSBpb2N0bCBE
LCBhbmQgd291bGQgbmVlZCB0byByb2xsYmFjayBpb2N0bCBBIGNoYW5nZXMsIGJ1dCBJIHNoYXJl
ZCBhIG1vcmUKPj4gbGVuZ3RoeSBjYWxsIGNoYWluIHRoYXQgY2FuIGJlIGFuIG9wdGlvbiBhcyB3
ZWxsLgo+IEkgdGhpbmsgeW91IGFyZSBvdmVydGhpbmtpbmcgdGhpcy4KPgo+IElmIHlvdXIgaW50
ZXJmYWNlIGlzIHRoaXMgY29tcGxleCwgeW91IGhhdmUgbXVjaCBsYXJnZXIgaXNzdWVzIGFzIHlv
dQo+IEFMV0FZUyBoYXZlIHRvIGJlIGFibGUgdG8gaGFuZGxlIGVycm9yIGNvbmRpdGlvbnMgcHJv
cGVybHksIGV2ZW4gaWYgdGhlCj4gQVBJIGlzICJzdXBwb3J0ZWQiLgoKVHJ1ZSwgdGhlIGVycm9y
IHBhdGhzIG5lZWQgdG8gaGFuZGxlZCBjb3JyZWN0bHkgb24gdGhlIGtlcm5lbCBkcml2ZXIgYW5k
IApvbiB0aGUgdXNlciBzcGFjZSBsb2dpYyBzaWRlLCBpbmRlcGVuZGVudCBvZiBzdXBwb3J0ZWQg
ZmVhdHVyZXMgb3Igbm90LiAKQ2Fubm90IGFzc3VtZSB0aGF0IGFsbCBpb2N0bCBjYWxsZXJzIGFy
ZSBiZWhhdmluZyBjb3JyZWN0bHkgb3IgdGhlcmUgYXJlIApubyBlcnJvcnMgaW4gdGhlIHN5c3Rl
bS4KCldoYXQgSSB3YW50ZWQgdG8gY292ZXIgd2l0aCB0aGF0IGV4YW1wbGUgaXMgbW9yZSB0b3dh
cmRzIHRoZSB1c2VyIHNwYWNlIApsb2dpYyB1c2luZyBuZXcgZmVhdHVyZXMsIGVpdGhlciBlYXJs
eSBleGl0aW5nIGJlZm9yZSBldmVuIHRyeWluZyB0aGUgCmlvY3RsIGNhbGwgZmxvdyBwYXRoIG9y
IGdvaW5nIHRocm91Z2ggcGFydCBvZiB0aGUgZmxvdyB0aWxsIGdldHRpbmcgdGhlIAplcnJvciBl
LmcuIEVOT1RUWSBmb3Igb25lIG9mIHRoZSBpb2N0bCBjYWxscy4KCj4KPiBQZXJoYXBzIHlvdXIg
QVBJIGlzIHNob3dpbmcgdG8gYmUgdG9vIGNvbXBsZXg/Cj4KPiBBbHNvLCB3aGVyZSBpcyB0aGUg
dXNlcnNwYWNlIGNvZGUgZm9yIGFsbCBvZiB0aGlzPyAgRGlkIEkgbWlzcyBhIGxpbmsgdG8KPiBp
dCBpbiB0aGUgcGF0Y2hlcyBzb21ld2hlcmU/CgpOb3BlLCB5b3UgZGlkbid0IG1pc3MgYW55IHJl
ZmVyZW5jZXMgdG8gaXQuIFRoZSBjb2RlYmFzZSBmb3IgdGhlIHVzZXIgCnNwYWNlIGNvZGUgaXMg
bm90IHB1YmxpY2x5IGF2YWlsYWJsZSBmb3Igbm93LCBidXQgaXQgd2lsbCBiZSBhdmFpbGFibGUg
Cm9uIEdpdEh1YiBvbmNlIHRoZSB3aG9sZSBwcm9qZWN0IGlzIEdBLiBBbmQgSSdsbCBpbmNsdWRl
IHRoZSByZWZzLCBvbmNlIAphdmFpbGFibGUsIGluIHRoZSBORSBrZXJuZWwgZHJpdmVyIGRvY3Vt
ZW50YXRpb24uCgpJIGNhbiBzdW1tYXJpemUgaGVyZSB0aGUgaW9jdGwgaW50ZXJmYWNlIHVzYWdl
IGZsb3csIGxldCBtZSBrbm93IGlmIEkgCmNhbiBoZWxwIHdpdGggbW9yZSBjbGFyaWZpY2F0aW9u
czoKCkVuY2xhdmUgY3JlYXRpb24KCiogT3BlbiB0aGUgbWlzYyBkZXZpY2UgKC9kZXYvbml0cm9f
ZW5jbGF2ZXMpIGFuZCBnZXQgdGhlIGRldmljZSBmZC4KKiBVc2luZyB0aGUgZGV2aWNlIGZkLCBj
YWxsIE5FX0dFVF9BUElfVkVSU0lPTiB0byBjaGVjayB0aGUgQVBJIHZlcnNpb24uCiogVXNpbmcg
dGhlIGRldmljZSBmZCwgY2FsbCBORV9DUkVBVEVfVk0gYW5kIGdldCBhbiBlbmNsYXZlIGZkLgoq
IFVzaW5nIHRoZSBlbmNsYXZlIGZkLCBjYWxsIE5FX0dFVF9JTUFHRV9MT0FEX0lORk8gdG8gZ2V0
IHRoZSBvZmZzZXQgaW4gCnRoZSBlbmNsYXZlIG1lbW9yeSB3aGVyZSB0byBwbGFjZSB0aGUgZW5j
bGF2ZSBpbWFnZS4gRW5jbGF2ZSBtZW1vcnkgCnJlZ2lvbnMgY29uc2lzdCBvZiBodWdldGxiZnMg
aHVnZSBwYWdlcy4gUGxhY2UgdGhlIGVuY2xhdmUgaW1hZ2UgaW4gCmVuY2xhdmUgbWVtb3J5Lgoq
IFVzaW5nIHRoZSBlbmNsYXZlIGZkLCBjYWxsIE5FX1NFVF9VU0VSX01FTU9SWV9SRUdJT04gdG8g
c2V0IGEgbWVtb3J5IApyZWdpb24gZm9yIGFuIGVuY2xhdmUuIFJlcGVhdCB0aGlzIHN0ZXAgZm9y
IGFsbCBlbmNsYXZlIG1lbW9yeSByZWdpb25zLgoqIFVzaW5nIHRoZSBlbmNsYXZlIGZkLCBjYWxs
IE5FX0FERF9WQ1BVIHRvIGFkZCBhIHZDUFUgZm9yIGFuIGVuY2xhdmUuIApSZXBlYXQgdGhpcyBz
dGVwIGZvciBhbGwgZW5jbGF2ZSB2Q1BVcy4gVGhlIENQVXMgYXJlIHBhcnQgb2YgdGhlIE5FIENQ
VSAKcG9vbCwgc2V0IHVzaW5nIGEgc3lzZnMgZmlsZSBiZWZvcmUgc3RhcnRpbmcgdG8gY3JlYXRl
IGFuIGVuY2xhdmUuCiogVXNpbmcgdGhlIGVuY2xhdmUgZmQsIGNhbGwgTkVfU1RBUlRfRU5DTEFW
RSB0byBzdGFydCBhbiBlbmNsYXZlLgoKCkVuY2xhdmUgdGVybWluYXRpb24KCiogQ2xvc2UgdGhl
IGVuY2xhdmUgZmQuCgoKVGhhbmtzLApBbmRyYQoKPgo+IGdvb2QgbHVjayEKPgo+IGdyZWcgay1o
CgoKCgpBbWF6b24gRGV2ZWxvcG1lbnQgQ2VudGVyIChSb21hbmlhKSBTLlIuTC4gcmVnaXN0ZXJl
ZCBvZmZpY2U6IDI3QSBTZi4gTGF6YXIgU3RyZWV0LCBVQkM1LCBmbG9vciAyLCBJYXNpLCBJYXNp
IENvdW50eSwgNzAwMDQ1LCBSb21hbmlhLiBSZWdpc3RlcmVkIGluIFJvbWFuaWEuIFJlZ2lzdHJh
dGlvbiBudW1iZXIgSjIyLzI2MjEvMjAwNS4K

