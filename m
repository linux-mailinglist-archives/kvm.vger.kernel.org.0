Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B5D277A4917
	for <lists+kvm@lfdr.de>; Mon, 18 Sep 2023 14:01:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240916AbjIRMBJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Sep 2023 08:01:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241895AbjIRMA4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Sep 2023 08:00:56 -0400
Received: from smtp-fw-80009.amazon.com (smtp-fw-80009.amazon.com [99.78.197.220])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6D64DE;
        Mon, 18 Sep 2023 04:59:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazon201209;
  t=1695038398; x=1726574398;
  h=message-id:date:mime-version:to:cc:references:from:
   in-reply-to:content-transfer-encoding:subject;
  bh=eG1C2BVfgTVepLC8sSyqp0SwuaWBXylv0y093IGXnjg=;
  b=TA/qFGuc7dCF5wMPiQGsqwunvKi3A24nQ3fGyvNir3hu4wsaIVDueQ6x
   NuRUPs6CCeNjHlEPLt6yg+4ZznhTJH1dGDWWv+onXMEzlXf0pxFiWFCdI
   xGVJq9vut3EUWz3Lvd5jv5hG5Ck1/haUpFnGM8xBJFBhSrJLtH6a/++V5
   Y=;
X-IronPort-AV: E=Sophos;i="6.02,156,1688428800"; 
   d="scan'208";a="29601258"
Subject: Re: [RFC] KVM: x86: Allow userspace exit on HLT and MWAIT,
 else yield on MWAIT
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-pdx-2c-m6i4x-8c5b1df3.us-west-2.amazon.com) ([10.25.36.210])
  by smtp-border-fw-80009.pdx80.corp.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Sep 2023 11:59:56 +0000
Received: from EX19MTAUWA002.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-pdx-2c-m6i4x-8c5b1df3.us-west-2.amazon.com (Postfix) with ESMTPS id A557840D69;
        Mon, 18 Sep 2023 11:59:55 +0000 (UTC)
Received: from EX19D020UWC004.ant.amazon.com (10.13.138.149) by
 EX19MTAUWA002.ant.amazon.com (10.250.64.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.37; Mon, 18 Sep 2023 11:59:55 +0000
Received: from [0.0.0.0] (10.253.83.51) by EX19D020UWC004.ant.amazon.com
 (10.13.138.149) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1118.37; Mon, 18 Sep
 2023 11:59:52 +0000
Message-ID: <db756c13-eee5-414a-a28d-2ce08e7b77d9@amazon.de>
Date:   Mon, 18 Sep 2023 13:59:50 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-GB
To:     David Woodhouse <dwmw2@infradead.org>, <kvm@vger.kernel.org>,
        "Peter Zijlstra" <peterz@infradead.org>
CC:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, <linux-kernel@vger.kernel.org>,
        Nicolas Saenz Julienne <nsaenz@amazon.es>,
        "Griffoul, Fred" <fgriffo@amazon.com>
References: <1b52b557beb6606007f7ec5672eab0adf1606a34.camel@infradead.org>
 <63b382bf-d1fb-464f-ab06-4185f796a85f@amazon.de>
 <b3c1a64daa6d265b295aedd6176daa8ab95e273f.camel@infradead.org>
From:   Alexander Graf <graf@amazon.de>
In-Reply-To: <b3c1a64daa6d265b295aedd6176daa8ab95e273f.camel@infradead.org>
X-Originating-IP: [10.253.83.51]
X-ClientProxiedBy: EX19D046UWB001.ant.amazon.com (10.13.139.187) To
 EX19D020UWC004.ant.amazon.com (10.13.138.149)
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: base64
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,T_SPF_PERMERROR
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Ck9uIDE4LjA5LjIzIDEzOjEwLCBEYXZpZCBXb29kaG91c2Ugd3JvdGU6Cj4gT24gTW9uLCAyMDIz
LTA5LTE4IGF0IDExOjQxICswMjAwLCBBbGV4YW5kZXIgR3JhZiB3cm90ZToKPj4gSUlVQyB5b3Ug
d2FudCB0byBkbyB3b3JrIGluIGEgdXNlciBzcGFjZSB2Q1BVIHRocmVhZCB3aGVuIHRoZSBndWVz
dCB2Q1BVCj4+IGlzIGlkbGUuIEFzIHlvdSBwb2ludGVkIG91dCBhYm92ZSwgS1ZNIGNhbiBub3Qg
YWN0dWFsbHkgZG8gbXVjaCBhYm91dAo+PiBNV0FJVDogSXQgYmFzaWNhbGx5IGJ1c3kgbG9vcHMg
YW5kIGhvZ3MgdGhlIENQVS4KPiBXZWxsLi4gSSBzdXNwZWN0IHdoYXQgSSAqcmVhbGx5KiB3YW50
IGlzIGEgZGVjZW50IHdheSB0byBlbXVsYXRlIE1XQUlUCj4gcHJvcGVybHkgYW5kIGxldCBpdCBh
Y3R1YWxseSBzbGVlcC4gT3IgZmFpbGluZyB0aGF0LCB0byBkZWNsYXJlIHRoYXQgd2UKPiBjYW4g
YWN0dWFsbHkgY2hhbmdlIHRoZSBndWVzdC12aXNpYmxlIGV4cGVyaWVuY2Ugd2hlbiB0aG9zZSBn
dWVzdHMgYXJlCj4gbWlncmF0ZWQgdG8gS1ZNLCBhbmQgdGFrZSBhd2F5IE1XQUlUIGNvbXBsZXRl
bHkuCj4KPj4gVGhlIHR5cGljYWwgZmxvdyBJIHdvdWxkIGV4cGVjdCBmb3IgIndvcmsgaW4gYSB2
Q1BVIHRocmVhZCIgaXM6Cj4+Cj4+IDApIHZDUFUgcnVucy4gSExUL01XQUlUIGlzIGRpcmVjdGx5
IGV4cG9zZWQgdG8gZ3Vlc3QuCj4+IDEpIHZDUFUgZXhpdHMuIENyZWF0ZXMgZGVmZXJyZWQgd29y
ay4gRW5hYmxlcyBITFQvTVdBSVQgdHJhcHBpbmcuCj4gVGhhdCBjYW4gaGFwcGVuLCBidXQgaXQg
bWF5IGFsc28gYmUgYSBzZXBhcmF0ZSBJL08gdGhyZWFkIHdoaWNoCj4gcmVjZWl2ZXMgYW4gZXZl
bnRmZCBub3RpZmljYXRpb24gYW5kIGZpbmRzIHRoYXQgdGhlcmUgaXMgbm93IHdvcmsgdG8gYmUK
PiBkb25lLiBJZiB0aGF0IHdvcmsgY2FuIGJlIGZhaXJseSBtdWNoIGluc3RhbnRhbmVvdXMsIGl0
IGNhbiBiZSBkb25lCj4gaW1tZWRpYXRlbHkuIEVsc2UgaXQgZ2V0cyBkZWZlcnJlZCB0byB3aGF0
IHdlIExpbnV4IGhhY2tlcnMgbWlnaHQgdGhpbmsKPiBvZiBhcyBhIHdvcmtxdWV1ZS4KPgo+IElm
IGFsbCB0aGUgdkNQVXMgYXJlIGluIEhMVCB3aGVuIHRoZSB3b3JrIHF1ZXVlIGJlY29tZXMgbm9u
LWVtcHR5LCB3ZSdkCj4gbmVlZCB0byBwcm9kIHRoZW0gKmFsbCogdG8gY2hhbmdlIHRoZWlyIGV4
aXQtb24te0hMVCxNV0FJVH0gc3RhdHVzIHdoZW4KPiB3b3JrIGJlY29tZXMgYXZhaWxhYmxlLCBq
dXN0IGluIGNhc2Ugb25lIG9mIHRoZW0gYmVjb21lcyBpZGxlIGFuZCBjYW4KPiBwcm9jZXNzIHRo
ZSB3b3JrICJmb3IgZnJlZSIgdXNpbmcgaWRsZSBjeWNsZXMuCj4KPj4gMikgdkNQVSBydW5zIGFn
YWluCj4+IDMpIHZDUFUgY2FsbHMgSExUL01XQUlULiBXZSBleGl0IHRvIHVzZXIgc3BhY2UgdG8g
ZmluaXNoIHdvcmsgZnJvbSAxCj4+IDQpIHZDUFUgcnVucyBhZ2FpbiB3aXRob3V0IEhMVC9NV0FJ
VCB0cmFwcGluZwo+Pgo+PiBUaGF0IG1lYW5zIG9uIHRvcCAob3IgaW5zdGVhZD8pIG9mIHRoZSBi
aXRzIHlvdSBoYXZlIGJlbG93IHRoYXQgaW5kaWNhdGUKPj4gIlNob3VsZCBJIGV4aXQgdG8gdXNl
ciBzcGFjZT8iLCB3aGF0IHlvdSByZWFsbHkgbmVlZCBhcmUgYml0cyB0aGF0IGRvCj4+IHdoYXQg
ZW5hYmxlX2NhcChLVk1fQ0FQX1g4Nl9ESVNBQkxFX0VYSVRTKSBkb2VzIGluIGxpZ2h0LXdlaWdo
dDogRGlzYWJsZQo+PiBITFQvTVdBSVQgdHJhcHBpbmcgdGVtcG9yYXJpbHkuCj4gSWYgSSBkbyBp
dCB0aGF0IHdheSwgeWVzLiBBIGxpZ2h0d2VpZ2h0IHdheSB0byBlbmFibGUvZGlzYWJsZSB0aGUg
ZXhpdHMKPiBldmVuIHRvIGtlcm5lbCB3b3VsZCBiZSBhIG5pY2UgdG8gaGF2ZS4gQnV0IGl0J3Mg
YSB0cmFkZS1vZmYuIEZvciBITFQKPiB5b3UnZCBnZXQgbG93ZXIgbGF0ZW5jeSByZS1lbnRlcmlu
ZyB0aGUgdkNQVSBhdCBhIGNvc3Qgb2YgbXVjaCBoaWdoZXIKPiBsYXRlbmN5IHByb2Nlc3Npbmcg
d29yayBpZiB0aGUgdkNQVSB3YXMgKmFscmVhZHkqIGluIEhMVC4KPgo+IFdlIHByb2JhYmx5IHdv
dWxkIHdhbnQgdG8gc3RvcCBidXJuaW5nIHBvd2VyIGluIHRoZSBNV0FJVCBsb29wIHRob3VnaCwK
PiBhbmQgbGV0IHRoZSBwQ1BVIHNpdCBpbiB0aGUgZ3Vlc3QgaW4gTVdBSVQgaWYgdGhlcmUgcmVh
bGx5IGlzIG5vdGhpbmcKPiBlbHNlIHRvIGRvLgo+Cj4gV2UncmUgZXhwZXJpbWVudGluZyB3aXRo
IHZhcmlvdXMgcGVybXV0YXRpb25zLgo+Cj4+IEFsc28sIHBsZWFzZSBrZWVwIGluIG1pbmQgdGhh
dCB5b3Ugc3RpbGwgd291bGQgbmVlZCBhIGZhbGxiYWNrIG1lY2hhbmlzbQo+PiB0byBydW4geW91
ciAiZGVmZXJyZWQgd29yayIgZXZlbiB3aGVuIHRoZSBndWVzdCBkb2VzIG5vdCBjYWxsIEhMVC9N
V0FJVCwKPj4gbGlrZSBhIHJlZ3VsYXIgdGltZXIgaW4geW91ciBtYWluIHRocmVhZC4KPiBZZWFo
LiBJbiB0aGF0IGNhc2UgSSB0aGluayB0aGUgaWRlYWwgYW5zd2VyIGlzIHRoYXQgd2UgbGV0IHRo
ZSBrZXJuZWwKPiBzY2hlZHVsZXIgc29ydCBpdCBvdXQuIEkgd2FzIHRoaW5raW5nIG9mIGEgbW9k
ZWwgd2hlcmUgd2UgaGF2ZSBJL08gKG9yCj4gd29ya3F1ZXVlKSB0aHJlYWRzIGluICphZGRpdGlv
biogdG8gdGhlIHVzZXJzcGFjZSBleGl0cyBvbiBpZGxlLiBUaGUKPiBzZXBhcmF0ZSB0aHJlYWRz
IG93biB0aGUgd29yayAoYW5kIGEgbnVtYmVyIG9mIHRoZW0gYXJlIHdva2VuIGFjY29yZGluZwo+
IHRvIHRoZSBxdWV1ZSBkZXB0aCksIGFuZCBpZGxlIHZDUFVzICpvcHBvcnR1bmlzdGljYWxseSog
cHJvY2VzcyB3b3JrCj4gaXRlbXMgb24gdG9wIG9mIHRoYXQuCj4KPiBUaGF0IGFwcHJvYWNoIGFs
b25lIHdvdWxkIHdvcmsgZmluZSB3aXRoIHRoZSBleGlzdGluZyBITFQgc2NoZWR1bGluZzsKPiBp
dCdzIGp1c3QgTVdBSVQgd2hpY2ggaXMgYSBwYWluIGJlY2F1c2UgeWllbGQoKSBkb2Vzbid0IHJl
YWxseSBkbyBtdWNoCj4gKGJ1dCBhcyBub3RlZCwgaXQncyBiZXR0ZXIgdGhhbiAqbm90aGluZyop
Lgo+Cj4+IE9uIHRvcCBvZiBhbGwgdGhpcywgSSdtIG5vdCBzdXJlIGl0J3MgbW9yZSBlZmZpY2ll
bnQgdG8gZG8gdGhlIHRyYXAgdG8KPj4gdGhlIHZDUFUgdGhyZWFkIGNvbXBhcmVkIHRvIGp1c3Qg
Y3JlYXRpbmcgYSBzZXBhcmF0ZSByZWFsIHRocmVhZC4gWW91cgo+PiBtYWluIHByb2JsZW0gaXMg
dGhlIGVtdWxhdGFiaWxpdHkgb2YgTVdBSVQgYmVjYXVzZSB0aGF0IGxlYXZlcyAibm8gdGltZSIK
Pj4gdG8gZG8gZGVmZXJyZWQgd29yay4gQnV0IHRoZW4gYWdhaW4sIGlmIHlvdXIgZGVmZXJyZWQg
d29yayBpcyBzbyBjb21wbGV4Cj4+IHRoYXQgaXQgbmVlZHMgbW9yZSB0aGFuIGEgZmV3IG1zICh3
aGljaCB5b3UgY2FuIGFsd2F5cyBzdGVhbCBmcm9tIHRoZQo+PiB2Q1BVIHRocmVhZCwgZXNwZWNp
YWxsIHdpdGggeWllbGQoKSksIHlvdSdsbCBuZWVkIHRvIHN0YXJ0IGltcGxlbWVudGluZwo+PiB0
aW1lIHNsaWNpbmcgb2YgdGhhdCB3b3JrIGluIHVzZXIgc3BhY2UgbmV4dCAtIGFuZCBiYXNpY2Fs
bHkgcmVidWlsZAo+PiB5b3VyIG93biBzY2hlZHVsZXIgdGhlcmUuIFVnaC4KPj4KPj4gSU1ITyB0
aGUgcmVhbCBjb3JlIHZhbHVlIG9mIHRoaXMgaWRlYSB3b3VsZCBiZSBpbiBhIHZjcHVfcnVuIGJp
dCB0aGF0IG9uCj4+IFZDUFVfUlVOIGNhbiB0b2dnbGUgYmV0d2VlbiBITFQvTVdBSVQgaW50ZXJj
ZXB0IG9uIGFuZCBvZmYuIFRoZSBhY3R1YWwKPj4gdHJhcCB0byB1c2VyIHNwYWNlLCB5b3UncmUg
bW9zdCBsaWtlbHkgYmV0dGVyIG9mZiB3aXRoIGEgc2VwYXJhdGUgdGhyZWFkLgo+IE5vLCB0aGF0
J3MgdmVyeSBtdWNoIG5vdCB0aGUgcG9pbnQuIFRoZSBwcm9ibGVtIGlzIHRoYXQgeWllbGQoKSBk
b2Vzbid0Cj4gd29yayB3ZWxsIGVub3VnaCDigJQgYW5kIGlzbid0IGRlc2lnbmVkIG9yIGd1YXJh
bnRlZWQgdG8gZG8gYW55dGhpbmcgaW4KPiBwYXJ0aWN1bGFyIGZvciBtb3N0IGNhc2VzLiBJdCdz
IGJldHRlciB0aGFuICpub3RoaW5nKiBidXQgd2Ugd2FudCB0aGUKPiBvcHBvcnR1bml0eSB0byBk
byB0aGUgYWN0dWFsIHdvcmsgcmlnaHQgdGhlcmUgaW4gdGhlICpsb29wKiBvZiB0aGUKPiBndWVz
dCBib3VuY2luZyB0aHJvdWdoIE1XQUlULgoKClRoZSBwcm9ibGVtIHdpdGggTVdBSVQgaXMgdGhh
dCB5b3UgZG9uJ3QgcmVhbGx5IGtub3cgd2hlbiBpdCdzIGRvbmUuCgpZb3UgY291bGQgZmluZCBv
dXQgYnkgbWFraW5nIE1PTklUT1InZWQgcGFnZXMoISkgcmVhZC1vbmx5IHNvIHlvdSBjYW4gCndh
a2UgdXAgYW55IHRhcmdldCB2Q1BVIHRoYXQncyBpbiBNV0FJVCwgYnV0IHRoYXQncyBjb25zaWRl
cmFibHkgCmV4cGVuc2l2ZSBpZiB5b3Ugd2FudCB0byBkbyBpdCB3ZWxsLgoKWW91IGNvdWxkIGFs
c28gYnVybiBvbmUgVk0vc3lzdGVtIHdpZGUgQ1BVIHRoYXQgZG9lcyBub3RoaW5nIGJ1dCB3YWl0
cyAKZm9yIGNoYW5nZXMgaW4gYW55IE1PTklUT1InZWQgY2FjaGUgbGluZS4gRG9hYmxlIHdpdGgg
bGVzcyBwb3dlciAKY29uc3VtcHRpb24gaWYgeW91IHVzZSBUU1ggSSBndWVzcy4gQnV0IHByb2Jh
Ymx5IG5vdCB3aGF0IHlvdSB3YW50IGVpdGhlci4KCkFub3RoZXIgYWx0ZXJuYXRpdmUgd291bGQg
YmUgdG8gbWFrZSBndWVzdHMgUFYgYXdhcmUsIHNvIHRoZXkgdW5kZXJzdGFuZCAKeW91IGRvbid0
IGFjdHVhbGx5IGRvIE1XQUlUIGFuZCBnaXZlIHlvdSBhIGh5cGVyY2FsbCBldmVyeSB0aW1lIHRo
ZXkgCm1vZGlmeSB3aGF0ZXZlciBhbnlvbmUgd291bGQgd2FudCB0byBtb25pdG9yIChzdWNoIGFz
IAp0aHJlYWRfaW5mby0+ZmxhZ3MpLiBCdXQgdGhhdCByZXF1aXJlcyBuZXcgZ3Vlc3Qga2VybmVs
cy4gSSBkb24ndCB0aGluayAKeW91IHdhbnQgdG8gd2FpdCBmb3IgdGhhdCA6KS4KClNvIGluIGEg
bnV0c2hlbGwsIGVtdWxhdGluZyBNV0FJVCBwcm9wZXJseSBpcyBqdXN0IHN1cGVyIGRpZmZpY3Vs
dC4gSWYgCnlvdSBoYXZlIGV2ZW4gdGhlIHJlbW90ZXN0IGNoYW5jZSB0byBnZXQgYXdheSB3aXRo
IGRvaW5nIEhMVCBpbnN0ZWFkLCAKSSdkIHRha2UgdGhhdC4gSW4gdGhhdCBtb2RlbCwgYW4gSS9P
IHRocmVhZCB0aGF0IHNjaGVkdWxlcyBvdmVyIGlkbGUgCnRocmVhZHMgYmVjb21lcyBuYXR1cmFs
LgoKCkFsZXgKCgoKCgpBbWF6b24gRGV2ZWxvcG1lbnQgQ2VudGVyIEdlcm1hbnkgR21iSApLcmF1
c2Vuc3RyLiAzOAoxMDExNyBCZXJsaW4KR2VzY2hhZWZ0c2Z1ZWhydW5nOiBDaHJpc3RpYW4gU2No
bGFlZ2VyLCBKb25hdGhhbiBXZWlzcwpFaW5nZXRyYWdlbiBhbSBBbXRzZ2VyaWNodCBDaGFybG90
dGVuYnVyZyB1bnRlciBIUkIgMTQ5MTczIEIKU2l0ejogQmVybGluClVzdC1JRDogREUgMjg5IDIz
NyA4NzkKCgo=

