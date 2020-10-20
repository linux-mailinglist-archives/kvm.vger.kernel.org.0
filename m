Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85B792938B5
	for <lists+kvm@lfdr.de>; Tue, 20 Oct 2020 12:01:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731713AbgJTKBG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Oct 2020 06:01:06 -0400
Received: from smtp-fw-33001.amazon.com ([207.171.190.10]:55864 "EHLO
        smtp-fw-33001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728761AbgJTKBG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Oct 2020 06:01:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazon201209;
  t=1603188065; x=1634724065;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=xYkebfF5v1VYrfmpt5H76y0GpMhcmAnnFxGU/jvjOsc=;
  b=Qbiet4WZAFw+PqTjoZOhhRbkVP7PhTfhIKnfgsJ+AgEyth+eCouom0DQ
   tm0icSLZ21QM23n7pW5B1JTywhStWP5Q38hoTqr7A4oVsjjLVlx/hSP39
   KWeKVlH4xBFXzqptnZ49jQvcSbTEDUFItZIupvOfMwhZr20ZOHB39v3Qb
   g=;
X-IronPort-AV: E=Sophos;i="5.77,396,1596499200"; 
   d="scan'208";a="85061117"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-1a-821c648d.us-east-1.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-33001.sea14.amazon.com with ESMTP; 20 Oct 2020 10:00:58 +0000
Received: from EX13MTAUWC002.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-1a-821c648d.us-east-1.amazon.com (Postfix) with ESMTPS id 6FE06A1DBD;
        Tue, 20 Oct 2020 10:00:50 +0000 (UTC)
Received: from EX13D20UWC001.ant.amazon.com (10.43.162.244) by
 EX13MTAUWC002.ant.amazon.com (10.43.162.240) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 20 Oct 2020 10:00:50 +0000
Received: from Alexanders-MacBook-Air.local (10.43.161.237) by
 EX13D20UWC001.ant.amazon.com (10.43.162.244) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 20 Oct 2020 10:00:44 +0000
Subject: Re: [PATCH] drivers/virt: vmgenid: add vm generation id driver
To:     Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Andy Lutomirski <luto@kernel.org>
CC:     Jann Horn <jannh@google.com>,
        "Catangiu, Adrian Costin" <acatan@amazon.com>,
        Jason Donenfeld <Jason@zx2c4.com>,
        Theodore Tso <tytso@mit.edu>, Willy Tarreau <w@1wt.eu>,
        Eric Biggers <ebiggers@kernel.org>,
        "open list, DOCUMENTATION" <linux-doc@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        <virtualization@lists.linux-foundation.org>,
        "MacCarthaigh, Colm" <colmmacc@amazon.com>,
        "Woodhouse, David" <dwmw@amazon.co.uk>, <bonzini@gnu.org>,
        "Singh, Balbir" <sblbir@amazon.com>,
        "Weiss, Radu" <raduweis@amazon.com>, <oridgar@gmail.com>,
        <ghammer@redhat.com>, "Jonathan Corbet" <corbet@lwn.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <mst@redhat.com>, <qemu-devel@nongnu.org>,
        KVM list <kvm@vger.kernel.org>,
        Michal Hocko <mhocko@kernel.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Pavel Machek <pavel@ucw.cz>,
        linux-api <linux-api@vger.kernel.org>
References: <788878CE-2578-4991-A5A6-669DCABAC2F2@amazon.com>
 <CAG48ez0EanBvDyfthe+hAP0OC8iGLNSq2e5wJVz-=ENNGF97_w@mail.gmail.com>
 <CALCETrViTg_BWvRa+nfDWq=_B_ithzL-anVJNpsgHaXe9VgCNQ@mail.gmail.com>
 <476895871.28084.1603127702969.JavaMail.zimbra@efficios.com>
From:   Alexander Graf <graf@amazon.de>
Message-ID: <487fd972-0d45-168b-af3d-6e67eb6d08d3@amazon.de>
Date:   Tue, 20 Oct 2020 12:00:42 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.3.3
MIME-Version: 1.0
In-Reply-To: <476895871.28084.1603127702969.JavaMail.zimbra@efficios.com>
Content-Language: en-US
X-Originating-IP: [10.43.161.237]
X-ClientProxiedBy: EX13D01UWB003.ant.amazon.com (10.43.161.94) To
 EX13D20UWC001.ant.amazon.com (10.43.162.244)
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

CgpPbiAxOS4xMC4yMCAxOToxNSwgTWF0aGlldSBEZXNub3llcnMgd3JvdGU6Cj4gCj4gCj4gLS0t
LS0gT24gT2N0IDE3LCAyMDIwLCBhdCAyOjEwIFBNLCBBbmR5IEx1dG9taXJza2kgbHV0b0BrZXJu
ZWwub3JnIHdyb3RlOgo+IAo+PiBPbiBGcmksIE9jdCAxNiwgMjAyMCBhdCA2OjQwIFBNIEphbm4g
SG9ybiA8amFubmhAZ29vZ2xlLmNvbT4gd3JvdGU6Cj4+Pgo+Pj4gW2FkZGluZyBzb21lIG1vcmUg
cGVvcGxlIHdobyBhcmUgaW50ZXJlc3RlZCBpbiBSTkcgc3R1ZmY6IEFuZHksIEphc29uLAo+Pj4g
VGhlb2RvcmUsIFdpbGx5IFRhcnJlYXUsIEVyaWMgQmlnZ2Vycy4gYWxzbyBsaW51eC1hcGlALCBi
ZWNhdXNlIHRoaXMKPj4+IGNvbmNlcm5zIHNvbWUgcHJldHR5IGZ1bmRhbWVudGFsIEFQSSBzdHVm
ZiByZWxhdGVkIHRvIFJORyB1c2FnZV0KPj4+Cj4+PiBPbiBGcmksIE9jdCAxNiwgMjAyMCBhdCA0
OjMzIFBNIENhdGFuZ2l1LCBBZHJpYW4gQ29zdGluCj4+PiA8YWNhdGFuQGFtYXpvbi5jb20+IHdy
b3RlOgo+Pj4+IC0gQmFja2dyb3VuZAo+Pj4+Cj4+Pj4gVGhlIFZNIEdlbmVyYXRpb24gSUQgaXMg
YSBmZWF0dXJlIGRlZmluZWQgYnkgTWljcm9zb2Z0IChwYXBlcjoKPj4+PiBodHRwOi8vZ28ubWlj
cm9zb2Z0LmNvbS9md2xpbmsvP0xpbmtJZD0yNjA3MDkpIGFuZCBzdXBwb3J0ZWQgYnkKPj4+PiBt
dWx0aXBsZSBoeXBlcnZpc29yIHZlbmRvcnMuCj4+Pj4KPj4+PiBUaGUgZmVhdHVyZSBpcyByZXF1
aXJlZCBpbiB2aXJ0dWFsaXplZCBlbnZpcm9ubWVudHMgYnkgYXBwcyB0aGF0IHdvcmsKPj4+PiB3
aXRoIGxvY2FsIGNvcGllcy9jYWNoZXMgb2Ygd29ybGQtdW5pcXVlIGRhdGEgc3VjaCBhcyByYW5k
b20gdmFsdWVzLAo+Pj4+IHV1aWRzLCBtb25vdG9uaWNhbGx5IGluY3JlYXNpbmcgY291bnRlcnMs
IGV0Yy4KPj4+PiBTdWNoIGFwcHMgY2FuIGJlIG5lZ2F0aXZlbHkgYWZmZWN0ZWQgYnkgVk0gc25h
cHNob3R0aW5nIHdoZW4gdGhlIFZNCj4+Pj4gaXMgZWl0aGVyIGNsb25lZCBvciByZXR1cm5lZCB0
byBhbiBlYXJsaWVyIHBvaW50IGluIHRpbWUuCj4+Pj4KPj4+PiBUaGUgVk0gR2VuZXJhdGlvbiBJ
RCBpcyBhIHNpbXBsZSBjb25jZXB0IG1lYW50IHRvIGFsbGV2aWF0ZSB0aGUgaXNzdWUKPj4+PiBi
eSBwcm92aWRpbmcgYSB1bmlxdWUgSUQgdGhhdCBjaGFuZ2VzIGVhY2ggdGltZSB0aGUgVk0gaXMg
cmVzdG9yZWQKPj4+PiBmcm9tIGEgc25hcHNob3QuIFRoZSBodyBwcm92aWRlZCBVVUlEIHZhbHVl
IGNhbiBiZSB1c2VkIHRvCj4+Pj4gZGlmZmVyZW50aWF0ZSBiZXR3ZWVuIFZNcyBvciBkaWZmZXJl
bnQgZ2VuZXJhdGlvbnMgb2YgdGhlIHNhbWUgVk0uCj4+Pj4KPj4+PiAtIFByb2JsZW0KPj4+Pgo+
Pj4+IFRoZSBWTSBHZW5lcmF0aW9uIElEIGlzIGV4cG9zZWQgdGhyb3VnaCBhbiBBQ1BJIGRldmlj
ZSBieSBtdWx0aXBsZQo+Pj4+IGh5cGVydmlzb3IgdmVuZG9ycyBidXQgbmVpdGhlciB0aGUgdmVu
ZG9ycyBvciB1cHN0cmVhbSBMaW51eCBoYXZlIG5vCj4+Pj4gZGVmYXVsdCBkcml2ZXIgZm9yIGl0
IGxlYXZpbmcgdXNlcnMgdG8gZmVuZCBmb3IgdGhlbXNlbHZlcy4KPj4+Pgo+Pj4+IEZ1cnRoZXJt
b3JlLCBzaW1wbHkgZmluZGluZyBvdXQgYWJvdXQgYSBWTSBnZW5lcmF0aW9uIGNoYW5nZSBpcyBv
bmx5Cj4+Pj4gdGhlIHN0YXJ0aW5nIHBvaW50IG9mIGEgcHJvY2VzcyB0byByZW5ldyBpbnRlcm5h
bCBzdGF0ZXMgb2YgcG9zc2libHkKPj4+PiBtdWx0aXBsZSBhcHBsaWNhdGlvbnMgYWNyb3NzIHRo
ZSBzeXN0ZW0uIFRoaXMgcHJvY2VzcyBjb3VsZCBiZW5lZml0Cj4+Pj4gZnJvbSBhIGRyaXZlciB0
aGF0IHByb3ZpZGVzIGFuIGludGVyZmFjZSB0aHJvdWdoIHdoaWNoIG9yY2hlc3RyYXRpb24KPj4+
PiBjYW4gYmUgZWFzaWx5IGRvbmUuCj4+Pj4KPj4+PiAtIFNvbHV0aW9uCj4+Pj4KPj4+PiBUaGlz
IHBhdGNoIGlzIGEgZHJpdmVyIHdoaWNoIGV4cG9zZXMgdGhlIFZpcnR1YWwgTWFjaGluZSBHZW5l
cmF0aW9uIElECj4+Pj4gdmlhIGEgY2hhci1kZXYgRlMgaW50ZXJmYWNlIHRoYXQgcHJvdmlkZXMg
SUQgdXBkYXRlIHN5bmMgYW5kIGFzeW5jCj4+Pj4gbm90aWZpY2F0aW9uLCByZXRyaWV2YWwgYW5k
IGNvbmZpcm1hdGlvbiBtZWNoYW5pc21zOgo+Pj4+Cj4+Pj4gV2hlbiB0aGUgZGV2aWNlIGlzICdv
cGVuKCknZWQgYSBjb3B5IG9mIHRoZSBjdXJyZW50IHZtIFVVSUQgaXMKPj4+PiBhc3NvY2lhdGVk
IHdpdGggdGhlIGZpbGUgaGFuZGxlLiAncmVhZCgpJyBvcGVyYXRpb25zIGJsb2NrIHVudGlsIHRo
ZQo+Pj4+IGFzc29jaWF0ZWQgVVVJRCBpcyBubyBsb25nZXIgdXAgdG8gZGF0ZSAtIHVudGlsIEhX
IHZtIGdlbiBpZCBjaGFuZ2VzIC0KPj4+PiBhdCB3aGljaCBwb2ludCB0aGUgbmV3IFVVSUQgaXMg
cHJvdmlkZWQvcmV0dXJuZWQuIE5vbmJsb2NraW5nICdyZWFkKCknCj4+Pj4gdXNlcyBFV09VTERC
TE9DSyB0byBzaWduYWwgdGhhdCB0aGVyZSBpcyBubyBfbmV3XyBVVUlEIGF2YWlsYWJsZS4KPj4+
Pgo+Pj4+ICdwb2xsKCknIGlzIGltcGxlbWVudGVkIHRvIGFsbG93IHBvbGxpbmcgZm9yIFVVSUQg
dXBkYXRlcy4gU3VjaAo+Pj4+IHVwZGF0ZXMgcmVzdWx0IGluICdFUE9MTElOJyBldmVudHMuCj4+
Pj4KPj4+PiBTdWJzZXF1ZW50IHJlYWQoKXMgZm9sbG93aW5nIGEgVVVJRCB1cGRhdGUgbm8gbG9u
Z2VyIGJsb2NrLCBidXQgcmV0dXJuCj4+Pj4gdGhlIHVwZGF0ZWQgVVVJRC4gVGhlIGFwcGxpY2F0
aW9uIG5lZWRzIHRvIGFja25vd2xlZGdlIHRoZSBVVUlEIHVwZGF0ZQo+Pj4+IGJ5IGNvbmZpcm1p
bmcgaXQgdGhyb3VnaCBhICd3cml0ZSgpJy4KPj4+PiBPbmx5IG9uIHdyaXRpbmcgYmFjayB0byB0
aGUgZHJpdmVyIHRoZSByaWdodC9sYXRlc3QgVVVJRCwgd2lsbCB0aGUKPj4+PiBkcml2ZXIgbWFy
ayB0aGlzICJ3YXRjaGVyIiBhcyB1cCB0byBkYXRlIGFuZCByZW1vdmUgRVBPTExJTiBzdGF0dXMu
Cj4+Pj4KPj4+PiAnbW1hcCgpJyBzdXBwb3J0IGFsbG93cyBtYXBwaW5nIGEgc2luZ2xlIHJlYWQt
b25seSBzaGFyZWQgcGFnZSB3aGljaAo+Pj4+IHdpbGwgYWx3YXlzIGNvbnRhaW4gdGhlIGxhdGVz
dCBVVUlEIHZhbHVlIGF0IG9mZnNldCAwLgo+Pj4KPj4+IEl0IHdvdWxkIGJlIG5pY2VyIGlmIHRo
YXQgcGFnZSBqdXN0IGNvbnRhaW5lZCBhbiBpbmNyZW1lbnRpbmcgY291bnRlciwKPj4+IGluc3Rl
YWQgb2YgYSBVVUlELiBJdCdzIG5vdCBsaWtlIHRoZSBhcHBsaWNhdGlvbiBjYXJlcyAqd2hhdCog
dGhlIFVVSUQKPj4+IGNoYW5nZWQgdG8sIGp1c3QgdGhhdCBpdCAqZGlkKiBjaGFuZ2UgYW5kIGFs
bCBSTkdzIHN0YXRlIG5vdyBuZWVkcyB0bwo+Pj4gYmUgcmVzZWVkZWQgZnJvbSB0aGUga2VybmVs
LCByaWdodD8gQW5kIGFuIGFwcGxpY2F0aW9uIGNhbid0IHJlbGlhYmx5Cj4+PiByZWFkIHRoZSBl
bnRpcmUgVVVJRCBmcm9tIHRoZSBtZW1vcnkgbWFwcGluZyBhbnl3YXksIGJlY2F1c2UgdGhlIFZN
Cj4+PiBtaWdodCBiZSBmb3JrZWQgaW4gdGhlIG1pZGRsZS4KPj4+Cj4+PiBTbyBJIHRoaW5rIHlv
dXIga2VybmVsIGRyaXZlciBzaG91bGQgZGV0ZWN0IFVVSUQgY2hhbmdlcyBhbmQgdGhlbiB0dXJu
Cj4+PiB0aG9zZSBpbnRvIGEgbW9ub3RvbmljYWxseSBpbmNyZW1lbnRpbmcgY291bnRlci4gKFBy
b2JhYmx5IDY0IGJpdHMKPj4+IHdpZGU/KSAoVGhhdCdzIHByb2JhYmx5IGFsc28gYSBsaXR0bGUg
Yml0IGZhc3RlciB0aGFuIGNvbXBhcmluZyBhbgo+Pj4gZW50aXJlIFVVSUQuKQo+Pj4KPj4+IEFu
IG9wdGlvbiBtaWdodCBiZSB0byBwdXQgdGhhdCBjb3VudGVyIGludG8gdGhlIHZEU08sIGluc3Rl
YWQgb2YgYQo+Pj4gc2VwYXJhdGUgVk1BOyBidXQgSSBkb24ndCBrbm93IGhvdyB0aGUgb3RoZXIg
Zm9sa3MgZmVlbCBhYm91dCB0aGF0Lgo+Pj4gQW5keSwgZG8geW91IGhhdmUgb3BpbmlvbnMgb24g
dGhpcz8gVGhhdCB3YXksIG5vcm1hbCB1c2Vyc3BhY2UgY29kZQo+Pj4gdGhhdCB1c2VzIHRoaXMg
aW5mcmFzdHJ1Y3R1cmUgd291bGRuJ3QgaGF2ZSB0byBtZXNzIGFyb3VuZCB3aXRoIGEKPj4+IHNw
ZWNpYWwgZGV2aWNlIGF0IGFsbC4gQW5kIGl0J2QgYmUgdXNhYmxlIGluIHNlY2NvbXAgc2FuZGJv
eGVzIGFuZCBzbwo+Pj4gb24gd2l0aG91dCBuZWVkaW5nIHNwZWNpYWwgcGx1bWJpbmcuIEFuZCBs
aWJyYXJpZXMgd291bGRuJ3QgaGF2ZSB0bwo+Pj4gY2FsbCBvcGVuKCkgYW5kIG1lc3Mgd2l0aCBm
aWxlIGRlc2NyaXB0b3IgbnVtYmVycy4KPj4KPj4gVGhlIHZEU08gbWlnaHQgYmUgYW5ub3lpbmds
eSBzbG93IGZvciB0aGlzLiAgU29tZXRoaW5nIGxpa2UgdGhlIHJzZXEKPj4gcGFnZSBtaWdodCBt
YWtlIHNlbnNlLiAgSXQgY291bGQgYmUgYSBnZW5lcmljIGluZGljYXRpb24gb2YgInN5c3RlbQo+
PiB3ZW50IHRocm91Z2ggc29tZSBmb3JtIG9mIHN1c3BlbmQiLgo+IAo+IFRoaXMgbWlnaHQgaW5k
ZWVkIGZpdCBuaWNlbHkgYXMgYW4gZXh0ZW5zaW9uIG9mIG15IEtUTFMgcHJvdG90eXBlIChleHRl
bnNpYmxlIHJzZXEpOgo+IAo+IGh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL2xrbWwvMjAyMDA5MjUx
ODE1MTguNDE0MS0xLW1hdGhpZXUuZGVzbm95ZXJzQGVmZmljaW9zLmNvbS8KPiAKPiBUaGVyZSBh
cmUgYSBmZXcgd2F5cyB3ZSBjb3VsZCB3aXJlIHRoaW5ncyB1cC4gT25lIG1pZ2h0IGJlIHRvIGFk
ZCB0aGUKPiBVVUlEIGZpZWxkIGludG8gdGhlIGV4dGVuZGVkIEtUTFMgc3RydWN0dXJlIChzbyBp
dCdzIGFsd2F5cyB1cGRhdGVkIGFmdGVyIGl0Cj4gY2hhbmdlcyBvbiBuZXh0IHJldHVybiB0byB1
c2VyLXNwYWNlKS4gRm9yIHRoaXMgSSBhc3N1bWUgdGhhdCB0aGUgTGludXggc2NoZWR1bGVyCgpJ
IHRoaW5rIG9uZSB0aGF0IHRoYXQgYmVjYW1lIGFwcGFyZW50IGluIHRoZSBkaXNjdXNzaW9uIGlu
IHRoaXMgdGhyZWFkIAp3YXMgdGhhdCB3ZSB3YW50IGEgTGludXggaW50ZXJuYWwgZ2VuZXJhdGlv
biBjb3VudGVyIHJhdGhlciB0aGFuIGV4cG9zZSAKdGhlIFVVSUQgdmVyYmF0aW0uIFRoYXQgd2F5
LCB3ZSBkb24ndCBnaXZlIGF3YXkgcG90ZW50aWFsIHNlY3JldHMgdG8gCnVzZXIgc3BhY2UgYW5k
IHdlIGNhbiBzdXBwb3J0IG90aGVyIGFyY2hpdGVjdHVyZXMgbW9yZSBlYXNpbHkuCgo+IHdpdGhp
biB0aGUgZ3Vlc3QgVk0gYWx3YXlzIHByZWVtcHRzIGFsbCB0aHJlYWRzIGJlZm9yZSBhIFZNIGlz
IHN1c3BlbmRlZCAoaXMgdGhhdAo+IGluZGVlZCB0cnVlID8pLgoKVGhlIFZNIGRvZXMgbm90IGtu
b3cgdGhhdCBpdCBnZXRzIHNuYXBzaG90dGVkLiBJdCBvbmx5IGtub3dzIHRoYXQgaXQgCmdldHMg
cmVzdW1lZCAodGhyb3VnaCB0aGlzIGludGVyZmFjZSkuCgo+IFRoaXMgbGVhZHMgdG8gb25lIGlt
cG9ydGFudCBxdWVzdGlvbiB0aG91Z2g6IGhvdyBpcyB0aGUgVVVJRCBjaGVjayB2cyBjb21taXQg
b3BlcmF0aW9uCj4gbWFkZSBhdG9taWMgd2l0aCByZXNwZWN0IHRvIHN1c3BlbmQgPyBVbmxlc3Mg
d2UgdXNlIHJzZXEgY3JpdGljYWwgc2VjdGlvbnMgaW4gYXNzZW1ibHksCj4gd2hlcmUgdGhlIGtl
cm5lbCB3aWxsIGFib3J0IHRoZSByc2VxIGNyaXRpY2FsIHNlY3Rpb24gb24gcHJlZW1wdGlvbiwg
SSBkb24ndCBzZWUgaG93IHdlCj4gY2FuIGVuc3VyZSB0aGF0IHRoZSBVVUlEIHZhbHVlIGRvZXMg
bm90IGNoYW5nZSByaWdodCBhZnRlciBpdCBoYXMgYmVlbiBjaGVja2VkLCBiZWZvcmUKPiB0aGUg
ImNvbW1pdCIgc2lkZS1lZmZlY3QuIEFuZCB3aGF0IGlzIHRoZSBleHBlY3RlZCAiY29tbWl0IiBz
aWRlLWVmZmVjdCA/IElzIGl0IGEgc3RvcmUKPiB0byBhIHZhcmlhYmxlIGluIHVzZXItc3BhY2Ug
bWVtb3J5LCBvciBpcyBpdCBpc3N1aW5nIGEgc3lzdGVtIGNhbGwgd2hpY2ggc2VuZHMgYSBwYWNr
ZXQgb3Zlcgo+IHRoZSBuZXR3b3JrID8KCkkgdGhpbmsgdGhlIGVhc2llc3QgYW5zd2VyIEkgY291
bGQgY29tZSB1cCB3aXRoIGhlcmUgd291bGQgYmUgIm1ha2UgaXQgYSAKdTMyIi4gVGhlbiB5b3Ug
Y2FuIGp1c3QgYWNjZXNzIGl0IGF0b21pY2FsbHkgYW55d2hlcmUsIG5vPwoKVGhlIGJ1cmRlbiBv
biB1c2VyIHNwYWNlIHdpdGggc3VjaCBhbiBpbnRlcmZhY2UgaXMgc3RpbGwgcHJldHR5IGhpZ2gg
CnRob3VnaC4gQWxsIHVzZXIgc3BhY2UgdGhhdCB3YW50cyB0byBkbyBhICJ0cmFuc2FjdGlvbiIg
YmFzZWQgb24gc2VjcmV0cyAKd291bGQgbm93IG5lZWQgdG8gcmVhZCB0aGUgZ2VuZXJhdGlvbiBJ
RCBhdCB0aGUgYmVnaW5uaW5nIG9mIHRoZSAKdHJhbnNhY3Rpb24gYW5kIGRvdWJsZSBjaGVjayB3
aGV0aGVyIGl0J3Mgc3RpbGwgdGhlIHNhbWUgYXQgdGhlIGVuZCBvZiAKaXQgKGUuZy4gYmVmb3Jl
IHNlbmRpbmcgb3V0IGEgbmV0d29yayBwYWNrZXQgYmFzZWQgb24gYSBrZXkgZGVyaXZlZCBmcm9t
IApyYW5kb21uZXNzPykuCgoKQWxleAoKCgpBbWF6b24gRGV2ZWxvcG1lbnQgQ2VudGVyIEdlcm1h
bnkgR21iSApLcmF1c2Vuc3RyLiAzOAoxMDExNyBCZXJsaW4KR2VzY2hhZWZ0c2Z1ZWhydW5nOiBD
aHJpc3RpYW4gU2NobGFlZ2VyLCBKb25hdGhhbiBXZWlzcwpFaW5nZXRyYWdlbiBhbSBBbXRzZ2Vy
aWNodCBDaGFybG90dGVuYnVyZyB1bnRlciBIUkIgMTQ5MTczIEIKU2l0ejogQmVybGluClVzdC1J
RDogREUgMjg5IDIzNyA4NzkKCgo=

