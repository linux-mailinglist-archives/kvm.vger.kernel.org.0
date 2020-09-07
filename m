Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73E4625FAF0
	for <lists+kvm@lfdr.de>; Mon,  7 Sep 2020 15:05:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729387AbgIGNEp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Sep 2020 09:04:45 -0400
Received: from smtp-fw-9101.amazon.com ([207.171.184.25]:64735 "EHLO
        smtp-fw-9101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729367AbgIGNEN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Sep 2020 09:04:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1599483852; x=1631019852;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=54WQHn/17TcO6cCHmVibi7YJ1lUn7vPNRWJcsGNa46U=;
  b=FzMEBqOx4SQUhEGBSkdo3Qvues7qp5MsR90XgeuTufGSB/aBtliAcrus
   f2PVfcxi4MSaZCAlQZCYuNw13qOaISXeQ/SxHKD34WxgEJLBbHMTfPZxw
   H/+r5mqQA62c+nuqIYdPcLdBO0wesaLMbB83b2aMT5alkHBFxlNIzs+md
   M=;
X-IronPort-AV: E=Sophos;i="5.76,401,1592870400"; 
   d="scan'208";a="66019990"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-2a-53356bf6.us-west-2.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9101.sea19.amazon.com with ESMTP; 07 Sep 2020 13:04:09 +0000
Received: from EX13D16EUB001.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan2.pdx.amazon.com [10.170.41.162])
        by email-inbound-relay-2a-53356bf6.us-west-2.amazon.com (Postfix) with ESMTPS id 139ACA21F6;
        Mon,  7 Sep 2020 13:04:09 +0000 (UTC)
Received: from 38f9d34ed3b1.ant.amazon.com (10.43.162.167) by
 EX13D16EUB001.ant.amazon.com (10.43.166.28) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 7 Sep 2020 13:03:48 +0000
Subject: Re: [PATCH v8 09/18] nitro_enclaves: Add logic for setting an enclave
 vCPU
To:     Greg KH <gregkh@linuxfoundation.org>
CC:     linux-kernel <linux-kernel@vger.kernel.org>,
        Anthony Liguori <aliguori@amazon.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Colm MacCarthaigh <colmmacc@amazon.com>,
        David Duncan <davdunc@amazon.com>,
        Bjoern Doebel <doebel@amazon.de>,
        David Woodhouse <dwmw@amazon.co.uk>,
        "Frank van der Linden" <fllinden@amazon.com>,
        Alexander Graf <graf@amazon.de>,
        "Karen Noel" <knoel@redhat.com>,
        Martin Pohlack <mpohlack@amazon.de>,
        Matt Wilson <msw@amazon.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Balbir Singh <sblbir@amazon.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        "Stefan Hajnoczi" <stefanha@redhat.com>,
        Stewart Smith <trawets@amazon.com>,
        "Uwe Dannowski" <uwed@amazon.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        kvm <kvm@vger.kernel.org>,
        ne-devel-upstream <ne-devel-upstream@amazon.com>
References: <20200904173718.64857-1-andraprs@amazon.com>
 <20200904173718.64857-10-andraprs@amazon.com>
 <20200907085818.GB1101646@kroah.com>
From:   "Paraschiv, Andra-Irina" <andraprs@amazon.com>
Message-ID: <389bca85-4fb4-8b04-df90-58c153764fef@amazon.com>
Date:   Mon, 7 Sep 2020 16:03:44 +0300
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:78.0)
 Gecko/20100101 Thunderbird/78.2.1
MIME-Version: 1.0
In-Reply-To: <20200907085818.GB1101646@kroah.com>
Content-Language: en-US
X-Originating-IP: [10.43.162.167]
X-ClientProxiedBy: EX13D35UWB002.ant.amazon.com (10.43.161.154) To
 EX13D16EUB001.ant.amazon.com (10.43.166.28)
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: base64
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

CgpPbiAwNy8wOS8yMDIwIDExOjU4LCBHcmVnIEtIIHdyb3RlOgo+Cj4gT24gRnJpLCBTZXAgMDQs
IDIwMjAgYXQgMDg6Mzc6MDlQTSArMDMwMCwgQW5kcmEgUGFyYXNjaGl2IHdyb3RlOgo+PiBBbiBl
bmNsYXZlLCBiZWZvcmUgYmVpbmcgc3RhcnRlZCwgaGFzIGl0cyByZXNvdXJjZXMgc2V0LiBPbmUg
b2YgaXRzCj4+IHJlc291cmNlcyBpcyBDUFUuCj4+Cj4+IEEgTkUgQ1BVIHBvb2wgaXMgc2V0IGFu
ZCBlbmNsYXZlIENQVXMgYXJlIGNob3NlbiBmcm9tIGl0LiBPZmZsaW5lIHRoZQo+PiBDUFVzIGZy
b20gdGhlIE5FIENQVSBwb29sIGR1cmluZyB0aGUgcG9vbCBzZXR1cCBhbmQgb25saW5lIHRoZW0g
YmFjawo+PiBkdXJpbmcgdGhlIE5FIENQVSBwb29sIHRlYXJkb3duLiBUaGUgQ1BVIG9mZmxpbmUg
aXMgbmVjZXNzYXJ5IHNvIHRoYXQKPj4gdGhlcmUgd291bGQgbm90IGJlIG1vcmUgdkNQVXMgdGhh
biBwaHlzaWNhbCBDUFVzIGF2YWlsYWJsZSB0byB0aGUKPj4gcHJpbWFyeSAvIHBhcmVudCBWTS4g
SW4gdGhhdCBjYXNlIHRoZSBDUFVzIHdvdWxkIGJlIG92ZXJjb21taXR0ZWQgYW5kCj4+IHdvdWxk
IGNoYW5nZSB0aGUgaW5pdGlhbCBjb25maWd1cmF0aW9uIG9mIHRoZSBwcmltYXJ5IC8gcGFyZW50
IFZNIG9mCj4+IGhhdmluZyBkZWRpY2F0ZWQgdkNQVXMgdG8gcGh5c2ljYWwgQ1BVcy4KPj4KPj4g
VGhlIGVuY2xhdmUgQ1BVcyBuZWVkIHRvIGJlIGZ1bGwgY29yZXMgYW5kIGZyb20gdGhlIHNhbWUg
TlVNQSBub2RlLiBDUFUKPj4gMCBhbmQgaXRzIHNpYmxpbmdzIGhhdmUgdG8gcmVtYWluIGF2YWls
YWJsZSB0byB0aGUgcHJpbWFyeSAvIHBhcmVudCBWTS4KPj4KPj4gQWRkIGlvY3RsIGNvbW1hbmQg
bG9naWMgZm9yIHNldHRpbmcgYW4gZW5jbGF2ZSB2Q1BVLgo+Pgo+PiBTaWduZWQtb2ZmLWJ5OiBB
bGV4YW5kcnUgVmFzaWxlIDxsZXhudkBhbWF6b24uY29tPgo+PiBTaWduZWQtb2ZmLWJ5OiBBbmRy
YSBQYXJhc2NoaXYgPGFuZHJhcHJzQGFtYXpvbi5jb20+Cj4+IFJldmlld2VkLWJ5OiBBbGV4YW5k
ZXIgR3JhZiA8Z3JhZkBhbWF6b24uY29tPgo+PiAtLS0KPj4gQ2hhbmdlbG9nCj4+Cj4+IHY3IC0+
IHY4Cj4+Cj4+ICogTm8gY2hhbmdlcy4KPj4KPj4gdjYgLT4gdjcKPj4KPj4gKiBDaGVjayBmb3Ig
ZXJyb3IgcmV0dXJuIHZhbHVlIHdoZW4gc2V0dGluZyB0aGUga2VybmVsIHBhcmFtZXRlciBzdHJp
bmcuCj4+ICogVXNlIHRoZSBORSBtaXNjIGRldmljZSBwYXJlbnQgZmllbGQgdG8gZ2V0IHRoZSBO
RSBQQ0kgZGV2aWNlLgo+PiAqIFVwZGF0ZSB0aGUgbmFtaW5nIGFuZCBhZGQgbW9yZSBjb21tZW50
cyB0byBtYWtlIG1vcmUgY2xlYXIgdGhlIGxvZ2ljCj4+ICAgIG9mIGhhbmRsaW5nIGZ1bGwgQ1BV
IGNvcmVzIGFuZCBkZWRpY2F0aW5nIHRoZW0gdG8gdGhlIGVuY2xhdmUuCj4+ICogQ2FsY3VsYXRl
IHRoZSBudW1iZXIgb2YgdGhyZWFkcyBwZXIgY29yZSBhbmQgbm90IHVzZSBzbXBfbnVtX3NpYmxp
bmdzCj4+ICAgIHRoYXQgaXMgeDg2IHNwZWNpZmljLgo+Pgo+PiB2NSAtPiB2Ngo+Pgo+PiAqIENo
ZWNrIENQVXMgYXJlIGZyb20gdGhlIHNhbWUgTlVNQSBub2RlIGJlZm9yZSBnb2luZyB0aHJvdWdo
IENQVQo+PiAgICBzaWJsaW5ncyBkdXJpbmcgdGhlIE5FIENQVSBwb29sIHNldHVwLgo+PiAqIFVw
ZGF0ZSBkb2N1bWVudGF0aW9uIHRvIGtlcm5lbC1kb2MgZm9ybWF0Lgo+Pgo+PiB2NCAtPiB2NQo+
Pgo+PiAqIFNldCBlbXB0eSBzdHJpbmcgaW4gY2FzZSBvZiBpbnZhbGlkIE5FIENQVSBwb29sLgo+
PiAqIENsZWFyIE5FIENQVSBwb29sIG1hc2sgb24gcG9vbCBzZXR1cCBmYWlsdXJlLgo+PiAqIFNl
dHVwIE5FIENQVSBjb3JlcyBvdXQgb2YgdGhlIE5FIENQVSBwb29sLgo+PiAqIEVhcmx5IGV4aXQg
b24gTkUgQ1BVIHBvb2wgc2V0dXAgaWYgZW5jbGF2ZShzKSBhbHJlYWR5IHJ1bm5pbmcuCj4+ICog
UmVtb3ZlIHNhbml0eSBjaGVja3MgZm9yIHNpdHVhdGlvbnMgdGhhdCBzaG91bGRuJ3QgaGFwcGVu
LCBvbmx5IGlmCj4+ICAgIGJ1Z2d5IHN5c3RlbSBvciBicm9rZW4gbG9naWMgYXQgYWxsLgo+PiAq
IEFkZCBjaGVjayBmb3IgbWF4aW11bSB2Q1BVIGlkIHBvc3NpYmxlIGJlZm9yZSBsb29raW5nIGlu
dG8gdGhlIENQVQo+PiAgICBwb29sLgo+PiAqIFJlbW92ZSBsb2cgb24gY29weV9mcm9tX3VzZXIo
KSAvIGNvcHlfdG9fdXNlcigpIGZhaWx1cmUgYW5kIG9uIGFkbWluCj4+ICAgIGNhcGFiaWxpdHkg
Y2hlY2sgZm9yIHNldHRpbmcgdGhlIE5FIENQVSBwb29sLgo+PiAqIFVwZGF0ZSB0aGUgaW9jdGwg
Y2FsbCB0byBub3QgY3JlYXRlIGEgZmlsZSBkZXNjcmlwdG9yIGZvciB0aGUgdkNQVS4KPj4gKiBT
cGxpdCB0aGUgQ1BVIHBvb2wgdXNhZ2UgbG9naWMgaW4gMiBzZXBhcmF0ZSBmdW5jdGlvbnMgLSBv
bmUgdG8gZ2V0IGEKPj4gICAgQ1BVIGZyb20gdGhlIHBvb2wgYW5kIHRoZSBvdGhlciB0byBjaGVj
ayB0aGUgZ2l2ZW4gQ1BVIGlzIGF2YWlsYWJsZSBpbgo+PiAgICB0aGUgcG9vbC4KPj4KPj4gdjMg
LT4gdjQKPj4KPj4gKiBTZXR1cCB0aGUgTkUgQ1BVIHBvb2wgYXQgcnVudGltZSB2aWEgYSBzeXNm
cyBmaWxlIGZvciB0aGUga2VybmVsCj4+ICAgIHBhcmFtZXRlci4KPj4gKiBDaGVjayBlbmNsYXZl
IENQVXMgdG8gYmUgZnJvbSB0aGUgc2FtZSBOVU1BIG5vZGUuCj4+ICogVXNlIGRldl9lcnIgaW5z
dGVhZCBvZiBjdXN0b20gTkUgbG9nIHBhdHRlcm4uCj4+ICogVXBkYXRlIHRoZSBORSBpb2N0bCBj
YWxsIHRvIG1hdGNoIHRoZSBkZWNvdXBsaW5nIGZyb20gdGhlIEtWTSBBUEkuCj4+Cj4+IHYyIC0+
IHYzCj4+Cj4+ICogUmVtb3ZlIHRoZSBXQVJOX09OIGNhbGxzLgo+PiAqIFVwZGF0ZSBzdGF0aWMg
Y2FsbHMgc2FuaXR5IGNoZWNrcy4KPj4gKiBVcGRhdGUga3pmcmVlKCkgY2FsbHMgdG8ga2ZyZWUo
KS4KPj4gKiBSZW1vdmUgZmlsZSBvcHMgdGhhdCBkbyBub3RoaW5nIGZvciBub3cgLSBvcGVuLCBp
b2N0bCBhbmQgcmVsZWFzZS4KPj4KPj4gdjEgLT4gdjIKPj4KPj4gKiBBZGQgbG9nIHBhdHRlcm4g
Zm9yIE5FLgo+PiAqIFVwZGF0ZSBnb3RvIGxhYmVscyB0byBtYXRjaCB0aGVpciBwdXJwb3NlLgo+
PiAqIFJlbW92ZSB0aGUgQlVHX09OIGNhbGxzLgo+PiAqIENoZWNrIGlmIGVuY2xhdmUgc3RhdGUg
aXMgaW5pdCB3aGVuIHNldHRpbmcgZW5jbGF2ZSB2Q1BVLgo+PiAtLS0KPj4gICBkcml2ZXJzL3Zp
cnQvbml0cm9fZW5jbGF2ZXMvbmVfbWlzY19kZXYuYyB8IDcwMiArKysrKysrKysrKysrKysrKysr
KysrCj4+ICAgMSBmaWxlIGNoYW5nZWQsIDcwMiBpbnNlcnRpb25zKCspCj4+Cj4+IGRpZmYgLS1n
aXQgYS9kcml2ZXJzL3ZpcnQvbml0cm9fZW5jbGF2ZXMvbmVfbWlzY19kZXYuYyBiL2RyaXZlcnMv
dmlydC9uaXRyb19lbmNsYXZlcy9uZV9taXNjX2Rldi5jCj4+IGluZGV4IDdhZDNmMWViNzVkNC4u
MDQ3N2IxMWJmMTVkIDEwMDY0NAo+PiAtLS0gYS9kcml2ZXJzL3ZpcnQvbml0cm9fZW5jbGF2ZXMv
bmVfbWlzY19kZXYuYwo+PiArKysgYi9kcml2ZXJzL3ZpcnQvbml0cm9fZW5jbGF2ZXMvbmVfbWlz
Y19kZXYuYwo+PiBAQCAtNjQsOCArNjQsMTEgQEAKPj4gICAgKiBUT0RPOiBVcGRhdGUgbG9naWMg
dG8gY3JlYXRlIG5ldyBzeXNmcyBlbnRyaWVzIGluc3RlYWQgb2YgdXNpbmcKPj4gICAgKiBhIGtl
cm5lbCBwYXJhbWV0ZXIgZS5nLiBpZiBtdWx0aXBsZSBzeXNmcyBmaWxlcyBuZWVkZWQuCj4+ICAg
ICovCj4+ICtzdGF0aWMgaW50IG5lX3NldF9rZXJuZWxfcGFyYW0oY29uc3QgY2hhciAqdmFsLCBj
b25zdCBzdHJ1Y3Qga2VybmVsX3BhcmFtICprcCk7Cj4+ICsKPj4gICBzdGF0aWMgY29uc3Qgc3Ry
dWN0IGtlcm5lbF9wYXJhbV9vcHMgbmVfY3B1X3Bvb2xfb3BzID0gewo+PiAgICAgICAgLmdldCAg
ICA9IHBhcmFtX2dldF9zdHJpbmcsCj4+ICsgICAgIC5zZXQgICAgPSBuZV9zZXRfa2VybmVsX3Bh
cmFtLAo+PiAgIH07Cj4+Cj4+ICAgc3RhdGljIGNoYXIgbmVfY3B1c1tORV9DUFVTX1NJWkVdOwo+
PiBAQCAtMTAzLDYgKzEwNiw3MDIgQEAgc3RydWN0IG5lX2NwdV9wb29sIHsKPj4KPj4gICBzdGF0
aWMgc3RydWN0IG5lX2NwdV9wb29sIG5lX2NwdV9wb29sOwo+Pgo+PiArLyoqCj4+ICsgKiBuZV9j
aGVja19lbmNsYXZlc19jcmVhdGVkKCkgLSBWZXJpZnkgaWYgYXQgbGVhc3Qgb25lIGVuY2xhdmUg
aGFzIGJlZW4gY3JlYXRlZC4KPj4gKyAqIEB2b2lkOiAgICBObyBwYXJhbWV0ZXJzIHByb3ZpZGVk
Lgo+PiArICoKPj4gKyAqIENvbnRleHQ6IFByb2Nlc3MgY29udGV4dC4KPj4gKyAqIFJldHVybjoK
Pj4gKyAqICogVHJ1ZSBpZiBhdCBsZWFzdCBvbmUgZW5jbGF2ZSBpcyBjcmVhdGVkLgo+PiArICog
KiBGYWxzZSBvdGhlcndpc2UuCj4+ICsgKi8KPj4gK3N0YXRpYyBib29sIG5lX2NoZWNrX2VuY2xh
dmVzX2NyZWF0ZWQodm9pZCkKPj4gK3sKPj4gKyAgICAgc3RydWN0IG5lX3BjaV9kZXYgKm5lX3Bj
aV9kZXYgPSBOVUxMOwo+PiArICAgICBzdHJ1Y3QgcGNpX2RldiAqcGRldiA9IE5VTEw7Cj4+ICsg
ICAgIGJvb2wgcmV0ID0gZmFsc2U7Cj4+ICsKPj4gKyAgICAgaWYgKCFuZV9taXNjX2Rldi5wYXJl
bnQpCj4gSG93IGNhbiB0aGF0IGJlIHRoZSBjYXNlPwo+Cj4gSSB3b3VsZG4ndCByZWx5IG9uIHRo
ZSBtaXNjIGRldmljZSdzIGludGVybmFscyB0byBiZSBzb21ldGhpbmcgdGhhdCB5b3UKPiBjb3Vu
dCBvbiBmb3IgcHJvcGVyIG9wZXJhdGlvbiBvZiB5b3VyIGNvZGUsIHJpZ2h0PwoKR2l2ZW4gdGhl
IG9wdGlvbiB0aGF0IHlvdSBzaGFyZWQgaW4gdGhlIHByZXZpb3VzIHBhdGNoLCB0byBoYXZlIGEg
ZmllbGQgCihpbiBhbiB1cGRhdGVkIG5lX21pc2NfZGV2IGRhdGEgc3RydWN0dXJlKSBmb3IgdGhl
IGRhdGEgd2Ugd2FudCB0byBrZWVwIAoobmVfcGNpX2RldikgYW5kIG5vdCByZWx5IG9uIHRoZSBt
aXNjIGRldmljZSdzIHBhcmVudCBmaWVsZCwgdGhpcyBsb2dpYyAKd291bGQgY291bnQgb24gdGhh
dCBwYXJ0aWN1bGFyIGZpZWxkIGluc3RlYWQuCgpUaGFua3MsCkFuZHJhCgoKCgoKQW1hem9uIERl
dmVsb3BtZW50IENlbnRlciAoUm9tYW5pYSkgUy5SLkwuIHJlZ2lzdGVyZWQgb2ZmaWNlOiAyN0Eg
U2YuIExhemFyIFN0cmVldCwgVUJDNSwgZmxvb3IgMiwgSWFzaSwgSWFzaSBDb3VudHksIDcwMDA0
NSwgUm9tYW5pYS4gUmVnaXN0ZXJlZCBpbiBSb21hbmlhLiBSZWdpc3RyYXRpb24gbnVtYmVyIEoy
Mi8yNjIxLzIwMDUuCg==

