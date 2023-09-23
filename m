Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C9AE7AC3C9
	for <lists+kvm@lfdr.de>; Sat, 23 Sep 2023 18:44:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232003AbjIWQoa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 23 Sep 2023 12:44:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229965AbjIWQo3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 23 Sep 2023 12:44:29 -0400
Received: from smtp-fw-33001.amazon.com (smtp-fw-33001.amazon.com [207.171.190.10])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15668139;
        Sat, 23 Sep 2023 09:44:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazon201209;
  t=1695487458; x=1727023458;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=2xx3LLBKBr2Twnx9PDcMEphhMOW9wkJNY6OBiL1LK0c=;
  b=eovHWO/qP3zZBHv7nsDMk9sNiZdHRp7KsQ10W2JEoFS+Kllo9p6HC7FI
   dSADKeXtrOuhZ51ElOELu2ctFLfdSK8P//rAWX0XVCl+HpSM2Cwzym2MC
   eT1HV32fdPDniZpaiNwe1IQrY8+Oe2n1T1H7e3URDn2f2wMLQB4nvoHwF
   A=;
X-IronPort-AV: E=Sophos;i="6.03,171,1694736000"; 
   d="scan'208";a="305729342"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-iad-1e-m6i4x-9694bb9e.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-33001.sea14.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Sep 2023 16:44:12 +0000
Received: from EX19MTAUWC001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-iad-1e-m6i4x-9694bb9e.us-east-1.amazon.com (Postfix) with ESMTPS id 36B84805FB;
        Sat, 23 Sep 2023 16:43:36 +0000 (UTC)
Received: from EX19D020UWC004.ant.amazon.com (10.13.138.149) by
 EX19MTAUWC001.ant.amazon.com (10.250.64.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.37; Sat, 23 Sep 2023 16:43:34 +0000
Received: from [0.0.0.0] (10.253.83.51) by EX19D020UWC004.ant.amazon.com
 (10.13.138.149) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1118.37; Sat, 23 Sep
 2023 16:43:31 +0000
Message-ID: <d3e0c3e9-4994-4808-a8df-3d23487ff9c4@amazon.de>
Date:   Sat, 23 Sep 2023 18:43:29 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC] KVM: x86: Allow userspace exit on HLT and MWAIT, else yield
 on MWAIT
Content-Language: en-GB
To:     Paolo Bonzini <pbonzini@redhat.com>,
        David Woodhouse <dwmw2@infradead.org>
CC:     <kvm@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        "Sean Christopherson" <seanjc@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, <linux-kernel@vger.kernel.org>,
        Nicolas Saenz Julienne <nsaenz@amazon.es>,
        "Griffoul, Fred" <fgriffo@amazon.com>
References: <1b52b557beb6606007f7ec5672eab0adf1606a34.camel@infradead.org>
 <CABgObfZgYXaXqP=6s53=+mYWvOnbgYJiCRct-0ob444sK9SvGw@mail.gmail.com>
 <faec494b6df5ebee5644017c9415e747bd34952b.camel@infradead.org>
 <3dc66987-49c7-abda-eb70-1898181ef3fe@redhat.com>
From:   Alexander Graf <graf@amazon.de>
In-Reply-To: <3dc66987-49c7-abda-eb70-1898181ef3fe@redhat.com>
X-Originating-IP: [10.253.83.51]
X-ClientProxiedBy: EX19D037UWC001.ant.amazon.com (10.13.139.197) To
 EX19D020UWC004.ant.amazon.com (10.13.138.149)
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: base64
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,T_SPF_TEMPERROR autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Ck9uIDIzLjA5LjIzIDExOjI0LCBQYW9sbyBCb256aW5pIHdyb3RlOgo+Cj4gT24gOS8yMy8yMyAw
OToyMiwgRGF2aWQgV29vZGhvdXNlIHdyb3RlOgo+PiBPbiBGcmksIDIwMjMtMDktMjIgYXQgMTQ6
MDAgKzAyMDAsIFBhb2xvIEJvbnppbmkgd3JvdGU6Cj4+PiBUbyBhdm9pZCByYWNlcyB5b3UgbmVl
ZCB0d28gZmxhZ3MgdGhvdWdoOyB0aGVyZSBuZWVkcyB0byBiZSBhbHNvIGEKPj4+IGtlcm5lbC0+
dXNlcnNwYWNlIGNvbW11bmljYXRpb24gb2Ygd2hldGhlciB0aGUgdkNQVSBpcyBjdXJyZW50bHkg
aW4KPj4+IEhMVCBvciBNV0FJVCwgdXNpbmcgdGhlICJmbGFncyIgZmllbGQgZm9yIGV4YW1wbGUu
IElmIGl0IHdhcyBITFQgb25seSwKPj4+IG1vdmluZyB0aGUgbXBfc3RhdGUgaW4ga3ZtX3J1biB3
b3VsZCBzZWVtIGxpa2UgYSBnb29kIGlkZWE7IGJ1dCBub3QgaWYKPj4+IE1XQUlUIG9yIFBBVVNF
IGFyZSBhbHNvIGluY2x1ZGVkLgo+Pgo+PiBSaWdodC4gV2hlbiB3b3JrIGlzIGFkZGVkIHRvIGFu
IGVtcHR5IHdvcmtxdWV1ZSwgdGhlIFZNTSB3aWxsIHdhbnQgdG8KPj4gaHVudCBmb3IgYSB2Q1BV
IHdoaWNoIGlzIGN1cnJlbnRseSBpZGxlIGFuZCB0aGVuIHNpZ25hbCBpdCB0byBleGl0Lgo+Pgo+
PiBBcyB5b3Ugc2F5LCBmb3IgSExUIGl0J3Mgc2ltcGxlIGVub3VnaCB0byBsb29rIGF0IHRoZSBt
cF9zdGF0ZSwgYW5kIHdlCj4+IGNhbiBtb3ZlIHRoYXQgaW50byBrdm1fcnVuIHNvIGl0IGRvZXNu
J3QgbmVlZCBhbiBpb2N0bC4uLgo+Cj4gTG9va2luZyBhdCBpdCBhZ2Fpbjogbm90IHNvIGVhc3kg
YmVjYXVzZSB0aGUgbXBzdGF0ZSBpcyBjaGFuZ2VkIGluIHRoZQo+IHZDUFUgdGhyZWFkIGJ5IHZj
cHVfYmxvY2soKSBpdHNlbGYuCj4KPj4gYWx0aG91Z2ggaXQKPj4gd291bGQgYWxzbyBiZSBuaWNl
IHRvIGdldCBhbiAqZXZlbnQqIG9uIGFuIGV2ZW50ZmQgd2hlbiB0aGUgdkNQVQo+PiBiZWNvbWVz
IHJ1bm5hYmxlIChhcyBub3RlZCwgd2Ugd2FudCB0aGF0IGZvciBWU00gYW55d2F5KS4gT3IgcGVy
aGFwcwo+PiBldmVuIHRvIGJlIGFibGUgdG8gcG9sbCgpIG9uIHRoZSB2Q1BVIGZkLgo+Cj4gV2h5
IGRvIHlvdSBuZWVkIGl0P8KgIFlvdSBjYW4ganVzdCB1c2UgS1ZNX1JVTiB0byBnbyB0byBzbGVl
cCwgYW5kIGlmIHlvdQo+IGdldCBhbm90aGVyIGpvYiB5b3Uga2ljayBvdXQgdGhlIHZDUFUgd2l0
aCBwdGhyZWFkX2tpbGwuwqAgKEkgYWxzbyBkaWRuJ3QKPiBnZXQgdGhlIFZTTSByZWZlcmVuY2Up
LgoKCldpdGggdGhlIG9yaWdpbmFsIFZTTSBwYXRjaGVzLCB3ZSB1c2VkIHRvIG1ha2UgYSB2Q1BV
IGF3YXJlIG9mIHRoZSBmYWN0IAp0aGF0IGl0IGNhbiBtb3JwaCBpbnRvIG9uZSBvZiBtYW55IFZU
THMuIFRoYXQgYXBwcm9hY2ggdHVybmVkIG91dCB0byBiZSAKaW5zYW5lbHkgaW50cnVzaXZlIGFu
ZCBmcmFnaWxlIGFuZCBzbyB3ZSdyZSBjdXJyZW50bHkgcmVpbXBsZW1lbnRpbmcgCmV2ZXJ5dGhp
bmcgYXMgVlRMcyBhcyB2Q1BVcy4gVGhhdCBhbGxvd3MgdXMgdG8gbW92ZSB0aGUgbWFqb3JpdHkg
b2YgVlNNIApmdW5jdGlvbmFsaXR5IHRvIHVzZXIgc3BhY2UuIEV2ZXJ5dGhpbmcgd2UndmUgc2Vl
biBzbyBmYXIgbG9va3MgYXMgaWYgCnRoZXJlIGlzIG5vIHJlYWwgcGVyZm9ybWFuY2UgbG9zcyB3
aXRoIHRoYXQgYXBwcm9hY2guCgpPbmUgc21hbGwgcHJvYmxlbSB3aXRoIHRoYXQgaXMgdGhhdCBu
b3cgdXNlciBzcGFjZSBpcyByZXNwb25zaWJsZSBmb3IgCnN3aXRjaGluZyBiZXR3ZWVuIFZUTHM6
IEl0IGRldGVybWluZXMgd2hpY2ggVlRMIGlzIGN1cnJlbnRseSBydW5uaW5nIGFuZCAKbGVhdmVz
IGFsbCBvdGhlcnMgKHJlYWQ6IGFsbCBvdGhlciB2Q1BVcykgYXMgc3RvcHBlZC4gVGhhdCBtZWFu
cyBpZiB5b3UgCmFyZSBydW5uaW5nIGhhcHBpbHkgaW4gS1ZNX1JVTiBpbiBWVEwwIGFuZCBWVEwx
IGdldHMgYW4gaW50ZXJydXB0LCB1c2VyIApzcGFjZSBuZWVkcyB0byBzdG9wIFZUTDAgYW5kIHVu
cGF1c2UgVlRMMSB1bnRpbCBpdCB0cmlnZ2VycyBWVExfUkVUVVJOIAphdCB3aGljaCBwb2ludCBW
VEwxIHN0b3BzIGV4ZWN1dGlvbiBhbmQgVlRMMCBydW5zIGFnYWluLgoKTmljb2xhcyBidWlsdCBh
IHBhdGNoIHRoYXQgZXhwb3NlcyAiaW50ZXJydXB0IG9uIHZDUFUgaXMgcGVuZGluZyIgYXMgYW4g
CmlvZXZlbnRmZCB1c2VyIHNwYWNlIGNhbiByZXF1ZXN0LiBUaGF0IHdheSwgdXNlciBzcGFjZSBj
YW4ga25vdyB3aGVuZXZlciAKYSBjdXJyZW50bHkgcGF1c2VkIHZDUFUgaGFzIGEgcGVuZGluZyBp
bnRlcnJ1cHQgYW5kIGNhbiBhY3QgYWNjb3JkaW5nbHkuIApZb3UgY291bGQgdXNlIHRoZSBzYW1l
IG1lY2hhbmlzbSBpZiB5b3Ugd2FudGVkIHRvIGltcGxlbWVudCBITFQgaW4gdXNlciAKc3BhY2Us
IGJ1dCBzdGlsbCB1c2UgYW4gaW4ta2VybmVsIExBUElDLgoKCkFsZXgKCgoKCkFtYXpvbiBEZXZl
bG9wbWVudCBDZW50ZXIgR2VybWFueSBHbWJICktyYXVzZW5zdHIuIDM4CjEwMTE3IEJlcmxpbgpH
ZXNjaGFlZnRzZnVlaHJ1bmc6IENocmlzdGlhbiBTY2hsYWVnZXIsIEpvbmF0aGFuIFdlaXNzCkVp
bmdldHJhZ2VuIGFtIEFtdHNnZXJpY2h0IENoYXJsb3R0ZW5idXJnIHVudGVyIEhSQiAxNDkxNzMg
QgpTaXR6OiBCZXJsaW4KVXN0LUlEOiBERSAyODkgMjM3IDg3OQoKCg==

