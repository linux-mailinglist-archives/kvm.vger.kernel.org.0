Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3FF31A8A20
	for <lists+kvm@lfdr.de>; Wed,  4 Sep 2019 21:25:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731954AbfIDP6Y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Sep 2019 11:58:24 -0400
Received: from smtp-fw-6002.amazon.com ([52.95.49.90]:36607 "EHLO
        smtp-fw-6002.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731920AbfIDP6Y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Sep 2019 11:58:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1567612701; x=1599148701;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=wsfWprD0lblrzJogtQSyv9S1R0jZAPO9JjBP0KTAUko=;
  b=QohgHZWPfFXliMRb9rGT2+CJFUZgq+HqCYnpskuhKSCa48ICOdVv+39T
   yWLaIXTr4mOCCLKZ8a6jz/YJM61uA25YMLQRiACj4DeFTrd2MeQVDJKuj
   efCrHkcvyBqvRpRv9XcZUvllM4zsTwP+6x2KTyQ82qGuLB+kXL/2qq/v2
   Q=;
X-IronPort-AV: E=Sophos;i="5.64,467,1559520000"; 
   d="scan'208";a="419445455"
Received: from iad6-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-1e-17c49630.us-east-1.amazon.com) ([10.124.125.6])
  by smtp-border-fw-out-6002.iad6.amazon.com with ESMTP; 04 Sep 2019 15:58:19 +0000
Received: from EX13MTAUWC001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan3.iad.amazon.com [10.40.159.166])
        by email-inbound-relay-1e-17c49630.us-east-1.amazon.com (Postfix) with ESMTPS id E6DB8A082B;
        Wed,  4 Sep 2019 15:58:14 +0000 (UTC)
Received: from EX13D20UWC001.ant.amazon.com (10.43.162.244) by
 EX13MTAUWC001.ant.amazon.com (10.43.162.135) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Wed, 4 Sep 2019 15:58:13 +0000
Received: from 38f9d3867b82.ant.amazon.com (10.43.162.125) by
 EX13D20UWC001.ant.amazon.com (10.43.162.244) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Wed, 4 Sep 2019 15:58:10 +0000
Subject: Re: [PATCH v2 1/2] KVM: VMX: Disable posted interrupts for odd IRQs
To:     Sean Christopherson <sean.j.christopherson@intel.com>
CC:     <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Liran Alon <liran.alon@oracle.com>
References: <20190904133511.17540-1-graf@amazon.com>
 <20190904133511.17540-2-graf@amazon.com>
 <20190904144045.GA24079@linux.intel.com>
 <fcaefade-16c1-6480-aeab-413bcd16dc52@amazon.com>
 <20190904155125.GC24079@linux.intel.com>
From:   Alexander Graf <graf@amazon.com>
Message-ID: <3f15f8d5-6129-e202-f56e-a5809c41782c@amazon.com>
Date:   Wed, 4 Sep 2019 17:58:08 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190904155125.GC24079@linux.intel.com>
Content-Language: en-US
X-Originating-IP: [10.43.162.125]
X-ClientProxiedBy: EX13D02UWC003.ant.amazon.com (10.43.162.199) To
 EX13D20UWC001.ant.amazon.com (10.43.162.244)
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: base64
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

CgpPbiAwNC4wOS4xOSAxNzo1MSwgU2VhbiBDaHJpc3RvcGhlcnNvbiB3cm90ZToKPiBPbiBXZWQs
IFNlcCAwNCwgMjAxOSBhdCAwNTozNjozOVBNICswMjAwLCBBbGV4YW5kZXIgR3JhZiB3cm90ZToK
Pj4KPj4KPj4gT24gMDQuMDkuMTkgMTY6NDAsIFNlYW4gQ2hyaXN0b3BoZXJzb24gd3JvdGU6Cj4+
PiBPbiBXZWQsIFNlcCAwNCwgMjAxOSBhdCAwMzozNToxMFBNICswMjAwLCBBbGV4YW5kZXIgR3Jh
ZiB3cm90ZToKPj4+PiBXZSBjYW4gZWFzaWx5IHJvdXRlIGhhcmR3YXJlIGludGVycnVwdHMgZGly
ZWN0bHkgaW50byBWTSBjb250ZXh0IHdoZW4KPj4+PiB0aGV5IHRhcmdldCB0aGUgIkZpeGVkIiBv
ciAiTG93UHJpb3JpdHkiIGRlbGl2ZXJ5IG1vZGVzLgo+Pj4+Cj4+Pj4gSG93ZXZlciwgb24gbW9k
ZXMgc3VjaCBhcyAiU01JIiBvciAiSW5pdCIsIHdlIG5lZWQgdG8gZ28gdmlhIEtWTSBjb2RlCj4+
Pj4gdG8gYWN0dWFsbHkgcHV0IHRoZSB2Q1BVIGludG8gYSBkaWZmZXJlbnQgbW9kZSBvZiBvcGVy
YXRpb24sIHNvIHdlIGNhbgo+Pj4+IG5vdCBwb3N0IHRoZSBpbnRlcnJ1cHQKPj4+Pgo+Pj4+IEFk
ZCBjb2RlIGluIHRoZSBWTVggUEkgbG9naWMgdG8gZXhwbGljaXRseSByZWZ1c2UgdG8gZXN0YWJs
aXNoIHBvc3RlZAo+Pj4+IG1hcHBpbmdzIGZvciBhZHZhbmNlZCBJUlEgZGVsaXZlciBtb2Rlcy4g
VGhpcyByZWZsZWN0cyB0aGUgbG9naWMgaW4KPj4+PiBfX2FwaWNfYWNjZXB0X2lycSgpIHdoaWNo
IGFsc28gb25seSBldmVyIHBhc3NlcyBGaXhlZCBhbmQgTG93UHJpb3JpdHkKPj4+PiBpbnRlcnJ1
cHRzIGFzIHBvc3RlZCBpbnRlcnJ1cHRzIGludG8gdGhlIGd1ZXN0Lgo+Pj4+Cj4+Pj4gVGhpcyBm
aXhlcyBhIGJ1ZyBJIGhhdmUgd2l0aCBjb2RlIHdoaWNoIGNvbmZpZ3VyZXMgcmVhbCBoYXJkd2Fy
ZSB0bwo+Pj4+IGluamVjdCB2aXJ0dWFsIFNNSXMgaW50byBteSBndWVzdC4KPj4+Pgo+Pj4+IFNp
Z25lZC1vZmYtYnk6IEFsZXhhbmRlciBHcmFmIDxncmFmQGFtYXpvbi5jb20+Cj4+Pj4gUmV2aWV3
ZWQtYnk6IExpcmFuIEFsb24gPGxpcmFuLmFsb25Ab3JhY2xlLmNvbT4KPj4+Pgo+Pj4+IC0tLQo+
Pj4+Cj4+Pj4gdjEgLT4gdjI6Cj4+Pj4KPj4+PiAgICAtIE1ha2UgZXJyb3IgbWVzc2FnZSBtb3Jl
IHVuaXF1ZQo+Pj4+ICAgIC0gVXBkYXRlIGNvbW1pdCBtZXNzYWdlIHRvIHBvaW50IHRvIF9fYXBp
Y19hY2NlcHRfaXJxKCkKPj4+PiAtLS0KPj4+PiAgIGFyY2gveDg2L2t2bS92bXgvdm14LmMgfCAy
MiArKysrKysrKysrKysrKysrKysrKysrCj4+Pj4gICAxIGZpbGUgY2hhbmdlZCwgMjIgaW5zZXJ0
aW9ucygrKQo+Pj4+Cj4+Pj4gZGlmZiAtLWdpdCBhL2FyY2gveDg2L2t2bS92bXgvdm14LmMgYi9h
cmNoL3g4Ni9rdm0vdm14L3ZteC5jCj4+Pj4gaW5kZXggNTcwYTIzM2UyNzJiLi44MDI5ZmU2NThj
MzAgMTAwNjQ0Cj4+Pj4gLS0tIGEvYXJjaC94ODYva3ZtL3ZteC92bXguYwo+Pj4+ICsrKyBiL2Fy
Y2gveDg2L2t2bS92bXgvdm14LmMKPj4+PiBAQCAtNzQwMSw2ICs3NDAxLDI4IEBAIHN0YXRpYyBp
bnQgdm14X3VwZGF0ZV9waV9pcnRlKHN0cnVjdCBrdm0gKmt2bSwgdW5zaWduZWQgaW50IGhvc3Rf
aXJxLAo+Pj4+ICAgCQkJY29udGludWU7Cj4+Pj4gICAJCX0KPj4+PiArCQlzd2l0Y2ggKGlycS5k
ZWxpdmVyeV9tb2RlKSB7Cj4+Pj4gKwkJY2FzZSBkZXN0X0ZpeGVkOgo+Pj4+ICsJCWNhc2UgZGVz
dF9Mb3dlc3RQcmlvOgo+Pj4+ICsJCQlicmVhazsKPj4+PiArCQlkZWZhdWx0Ogo+Pj4+ICsJCQkv
Kgo+Pj4+ICsJCQkgKiBGb3Igbm9uLXRyaXZpYWwgaW50ZXJydXB0IGV2ZW50cywgd2UgbmVlZCB0
byBnbwo+Pj4+ICsJCQkgKiB0aHJvdWdoIHRoZSBmdWxsIEtWTSBJUlEgY29kZSwgc28gcmVmdXNl
IHRvIHRha2UKPj4+PiArCQkJICogYW55IGRpcmVjdCBQSSBhc3NpZ25tZW50cyBoZXJlLgo+Pj4+
ICsJCQkgKi8KPj4+Cj4+PiBJTU8sIGEgYmVlZnkgY29tbWVudCBpcyB1bm5lY2Vzc2FyeSwgYW55
b25lIHRoYXQgaXMgZGlnZ2luZyB0aHJvdWdoIHRoaXMKPj4+IGNvZGUgaGFzIGhvcGVmdWxseSBy
ZWFkIHRoZSBQSSBzcGVjIG9yIGF0IGxlYXN0IHVuZGVyc3RhbmRzIHRoZSBiYXNpYwo+Pj4gY29u
Y2VwdHMuICBJLmUuIGl0IHNob3VsZCBiZSBvYnZpb3VzIHRoYXQgUEkgY2FuJ3QgYmUgdXNlZCBm
b3IgU01JLCBldGMuLi4KPj4+Cj4+Pj4gKwkJCXJldCA9IGlycV9zZXRfdmNwdV9hZmZpbml0eSho
b3N0X2lycSwgTlVMTCk7Cj4+Pj4gKwkJCWlmIChyZXQgPCAwKSB7Cj4+Pj4gKwkJCQlwcmludGso
S0VSTl9JTkZPCj4+Pj4gKwkJCQkgICAgIm5vbi1zdGQgSVJRIGZhaWxlZCB0byByZWNvdmVyLCBp
cnE6ICV1XG4iLAo+Pj4+ICsJCQkJICAgIGhvc3RfaXJxKTsKPj4+PiArCQkJCWdvdG8gb3V0Owo+
Pj4+ICsJCQl9Cj4+Pj4gKwo+Pj4+ICsJCQljb250aW51ZTsKPj4+Cj4+PiBVc2luZyBhIHN3aXRj
aCB0byBmaWx0ZXIgb3V0IHR3byB0eXBlcyBpcyBhIGJpdCBvZiBvdmVya2lsbC4gIEl0IGFsc28K
Pj4KPj4gVGhlIHN3aXRjaCBzaG91bGQgY29tcGlsZSBpbnRvIHRoZSBzYW1lIGFzIHRoZSBpZigp
IGJlbG93LCBpdCdzIGp1c3QgYQo+PiBtYXR0ZXIgb2YgYmVpbmcgbW9yZSB2ZXJib3NlIGluIGNv
ZGUuCj4+Cj4+PiBwcm9iYWJseSBtYWtlcyBzZW5zZSB0byBwZXJmb3JtIHRoZSBkZWxpdmVyX21v
ZGUgY2hlY2tzIGJlZm9yZSBjYWxsaW5nCj4+PiBrdm1faW50cl9pc19zaW5nbGVfdmNwdSgpLiAg
V2h5IG5vdCBzaW1wbHkgc29tZXRoaW5nIGxpa2UgdGhpcz8gIFRoZQo+Pj4gZXhpc3RpbmcgY29t
bWVudCBhbmQgZXJyb3IgbWVzc2FnZSBhcmUgZXZlbiBnZW5lcmljIGVub3VnaCB0byBrZWVwIGFz
IGlzLgo+Pgo+PiBPaywgc28gaG93IGFib3V0IHRoaXMsIGV2ZW4gdGhvdWdoIGl0IGdvZXMgYWdh
aW5zdCBMaXJhbidzIGNvbW1lbnQgb24gdGhlCj4+IGNvbWJpbmVkIGRlYnVnIHByaW50Pwo+IAo+
IEkgbWlzc2VkIHRoYXQgY29tbWVudC4KPiAKPiBIb3cgb2Z0ZW4gZG8gd2UgZXhwZWN0IGlycV9z
ZXRfdmNwdV9hZmZpbml0eSgpIHRvIGZhaWw/ICBJZiBpdCdzIGZyZXF1ZW50Cj4gZW5vdWdoIHRo
YXQgdGhlIGRlYnVnIG1lc3NhZ2UgbWF0dGVycywgbWF5YmUgaXQgc2hvdWxkIGJlIGEgdHJhY2Vw
b2ludC4KCkkgZG9uJ3QgZXhwZWN0IHRvIGV2ZXIgaGl0IHRoYXQgZGVidWcgcHJpbnQsIHNvIEkg
ZG9uJ3QgdGhpbmsgaXQgbWF0dGVycyAKcmVhbGx5LgoKPiAgIAo+PiBJZiB5b3UgdGhpbmsgaXQn
cyByZWFzb25hYmxlIGRlc3BpdGUgdGhlIGJyb2tlbiBmb3JtYXR0aW5nLCBJJ2xsIGJlIGhhcHB5
IHRvCj4+IGZvbGQgdGhlIHBhdGNoZXMgYW5kIHN1Ym1pdCBhcyB2My4KPj4KPj4KPj4gQWxleAo+
Pgo+Pgo+PiBkaWZmIC0tZ2l0IGEvYXJjaC94ODYvaW5jbHVkZS9hc20va3ZtX2hvc3QuaAo+PiBi
L2FyY2gveDg2L2luY2x1ZGUvYXNtL2t2bV9ob3N0LmgKPj4gaW5kZXggNDRhNWNlNTdhOTA1Li41
NWY2OGZiMGQ3OTEgMTAwNjQ0Cj4+IC0tLSBhL2FyY2gveDg2L2luY2x1ZGUvYXNtL2t2bV9ob3N0
LmgKPj4gKysrIGIvYXJjaC94ODYvaW5jbHVkZS9hc20va3ZtX2hvc3QuaAo+PiBAQCAtMTU4MSw2
ICsxNTgxLDEyIEBAIGJvb2wga3ZtX2ludHJfaXNfc2luZ2xlX3ZjcHUoc3RydWN0IGt2bSAqa3Zt
LCBzdHJ1Y3QKPj4ga3ZtX2xhcGljX2lycSAqaXJxLAo+PiAgIHZvaWQga3ZtX3NldF9tc2lfaXJx
KHN0cnVjdCBrdm0gKmt2bSwgc3RydWN0IGt2bV9rZXJuZWxfaXJxX3JvdXRpbmdfZW50cnkKPj4g
KmUsCj4+ICAgCQkgICAgIHN0cnVjdCBrdm1fbGFwaWNfaXJxICppcnEpOwo+Pgo+PiArc3RhdGlj
IGlubGluZSBib29sIGt2bV9pcnFfaXNfZ2VuZXJpYyhzdHJ1Y3Qga3ZtX2xhcGljX2lycSAqaXJx
KQo+PiArewo+PiArCXJldHVybiAoaXJxLT5kZWxpdmVyeV9tb2RlID09IGRlc3RfRml4ZWQgfHwK
Pj4gKwkJaXJxLT5kZWxpdmVyeV9tb2RlID09IGRlc3RfTG93ZXN0UHJpbyk7Cj4+ICt9Cj4+ICsK
Pj4gICBzdGF0aWMgaW5saW5lIHZvaWQga3ZtX2FyY2hfdmNwdV9ibG9ja2luZyhzdHJ1Y3Qga3Zt
X3ZjcHUgKnZjcHUpCj4+ICAgewo+PiAgIAlpZiAoa3ZtX3g4Nl9vcHMtPnZjcHVfYmxvY2tpbmcp
Cj4+IGRpZmYgLS1naXQgYS9hcmNoL3g4Ni9rdm0vc3ZtLmMgYi9hcmNoL3g4Ni9rdm0vc3ZtLmMK
Pj4gaW5kZXggMWYyMjBhODU1MTRmLi4zNGNjNTk1MThjYmIgMTAwNjQ0Cj4+IC0tLSBhL2FyY2gv
eDg2L2t2bS9zdm0uYwo+PiArKysgYi9hcmNoL3g4Ni9rdm0vc3ZtLmMKPj4gQEAgLTUyNjAsNyAr
NTI2MCw4IEBAIGdldF9waV92Y3B1X2luZm8oc3RydWN0IGt2bSAqa3ZtLCBzdHJ1Y3QKPj4ga3Zt
X2tlcm5lbF9pcnFfcm91dGluZ19lbnRyeSAqZSwKPj4KPj4gICAJa3ZtX3NldF9tc2lfaXJxKGt2
bSwgZSwgJmlycSk7Cj4+Cj4+IC0JaWYgKCFrdm1faW50cl9pc19zaW5nbGVfdmNwdShrdm0sICZp
cnEsICZ2Y3B1KSkgewo+PiArCWlmICgha3ZtX2ludHJfaXNfc2luZ2xlX3ZjcHUoa3ZtLCAmaXJx
LCAmdmNwdSkgfHwKPj4gKwkgICAgIWt2bV9pcnFfaXNfZ2VuZXJpYygmaXJxKSkgewo+IAo+IEkn
dmUgbmV2ZXIgaGVhcmQvc2VlbiB0aGUgdGVybSBnZW5lcmljIHVzZWQgdG8gZGVzY3JpYmUgeDg2
IGludGVycnVwdHMuCj4gTWF5YmUga3ZtX2lycV9pc19pbnRyKCkgb3Iga3ZtX2lycV9pc192ZWN0
b3JlZF9pbnRyKCk/CgpJIHdhcyB0cnlpbmcgdG8gY29tZSB1cCB3aXRoIGFueSBuYW1lIHRoYXQg
ZGVzY3JpYmVzICJpbnRlcnJ1cHQgdGhhdCB3ZSAKY2FuIHBvc3QiLiBJZiAiaW50ciIgaXMgdGhh
dCwgSSdsbCBiZSBoYXBweSB0byB0YWtlIGl0LiBWZWN0b3JlZF9pbnRyIApzb3VuZHMgZXZlbiB3
b3JzZSBJTUhPIDopLgoKPiAKPj4gICAJCXByX2RlYnVnKCJTVk06ICVzOiB1c2UgbGVnYWN5IGlu
dHIgcmVtYXAgbW9kZSBmb3IgaXJxICV1XG4iLAo+PiAgIAkJCSBfX2Z1bmNfXywgaXJxLnZlY3Rv
cik7Cj4+ICAgCQlyZXR1cm4gLTE7Cj4+IEBAIC01MzE0LDYgKzUzMTUsNyBAQCBzdGF0aWMgaW50
IHN2bV91cGRhdGVfcGlfaXJ0ZShzdHJ1Y3Qga3ZtICprdm0sCj4+IHVuc2lnbmVkIGludCBob3N0
X2lycSwKPj4gICAJCSAqIDEuIFdoZW4gY2Fubm90IHRhcmdldCBpbnRlcnJ1cHQgdG8gYSBzcGVj
aWZpYyB2Y3B1Lgo+PiAgIAkJICogMi4gVW5zZXR0aW5nIHBvc3RlZCBpbnRlcnJ1cHQuCj4+ICAg
CQkgKiAzLiBBUElDIHZpcnRpYWxpemF0aW9uIGlzIGRpc2FibGVkIGZvciB0aGUgdmNwdS4KPj4g
KwkJICogNC4gSVJRIGhhcyBleHRlbmRlZCBkZWxpdmVyeSBtb2RlIChTTUksIElOSVQsIGV0YykK
PiAKPiBTaW1pbGFybHksICdleHRlbmRlZCBkZWxpdmVyeSBtb2RlJyBpc24ndCByZWFsbHkgYSB0
aGluZywgaXQncyBzaW1wbHkgdGhlCj4gZGVsaXZlcnkgbW9kZS4KCnMvZXh0ZW5kZWQvaW5jb21w
YXRpYmxlLyBtYXliZT8KCgpBbGV4CgoKCkFtYXpvbiBEZXZlbG9wbWVudCBDZW50ZXIgR2VybWFu
eSBHbWJICktyYXVzZW5zdHIuIDM4CjEwMTE3IEJlcmxpbgpHZXNjaGFlZnRzZnVlaHJ1bmc6IENo
cmlzdGlhbiBTY2hsYWVnZXIsIFJhbGYgSGVyYnJpY2gKRWluZ2V0cmFnZW4gYW0gQW10c2dlcmlj
aHQgQ2hhcmxvdHRlbmJ1cmcgdW50ZXIgSFJCIDE0OTE3MyBCClNpdHo6IEJlcmxpbgpVc3QtSUQ6
IERFIDI4OSAyMzcgODc5CgoK

