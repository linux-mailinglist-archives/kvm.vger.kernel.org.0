Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 217CEA899B
	for <lists+kvm@lfdr.de>; Wed,  4 Sep 2019 21:24:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731371AbfIDPhc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Sep 2019 11:37:32 -0400
Received: from smtp-fw-9102.amazon.com ([207.171.184.29]:62904 "EHLO
        smtp-fw-9102.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731360AbfIDPhb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Sep 2019 11:37:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1567611449; x=1599147449;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=TSJJMr2XeybrWUSFKXm2GdaxGOMjsJphUCuZr5birTk=;
  b=QOhrnZlzbpyOpzd/geXpUCL74G7KNd88XecpMtAc/hCAcM5J1LBQ0lWz
   qAdil1nML5O4IIClmApAA0Qgy6uUnAHdlFw7PmsFEgK8WmKI8xLrNEkQq
   zbzshxZv5bYzjIaxYA5Xu/9kaG2DpEvtqLHhKmK1sCqu2KtHJxco1wvCf
   0=;
X-IronPort-AV: E=Sophos;i="5.64,467,1559520000"; 
   d="scan'208";a="700703240"
Received: from sea3-co-svc-lb6-vlan3.sea.amazon.com (HELO email-inbound-relay-1a-807d4a99.us-east-1.amazon.com) ([10.47.22.38])
  by smtp-border-fw-out-9102.sea19.amazon.com with ESMTP; 04 Sep 2019 15:36:53 +0000
Received: from EX13MTAUWC001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan2.iad.amazon.com [10.40.159.162])
        by email-inbound-relay-1a-807d4a99.us-east-1.amazon.com (Postfix) with ESMTPS id 82E05A21E7;
        Wed,  4 Sep 2019 15:36:45 +0000 (UTC)
Received: from EX13D20UWC001.ant.amazon.com (10.43.162.244) by
 EX13MTAUWC001.ant.amazon.com (10.43.162.135) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Wed, 4 Sep 2019 15:36:44 +0000
Received: from 38f9d3867b82.ant.amazon.com (10.43.161.243) by
 EX13D20UWC001.ant.amazon.com (10.43.162.244) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Wed, 4 Sep 2019 15:36:41 +0000
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
From:   Alexander Graf <graf@amazon.com>
Message-ID: <fcaefade-16c1-6480-aeab-413bcd16dc52@amazon.com>
Date:   Wed, 4 Sep 2019 17:36:39 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190904144045.GA24079@linux.intel.com>
Content-Language: en-US
X-Originating-IP: [10.43.161.243]
X-ClientProxiedBy: EX13D08UWB001.ant.amazon.com (10.43.161.104) To
 EX13D20UWC001.ant.amazon.com (10.43.162.244)
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: base64
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

CgpPbiAwNC4wOS4xOSAxNjo0MCwgU2VhbiBDaHJpc3RvcGhlcnNvbiB3cm90ZToKPiBPbiBXZWQs
IFNlcCAwNCwgMjAxOSBhdCAwMzozNToxMFBNICswMjAwLCBBbGV4YW5kZXIgR3JhZiB3cm90ZToK
Pj4gV2UgY2FuIGVhc2lseSByb3V0ZSBoYXJkd2FyZSBpbnRlcnJ1cHRzIGRpcmVjdGx5IGludG8g
Vk0gY29udGV4dCB3aGVuCj4+IHRoZXkgdGFyZ2V0IHRoZSAiRml4ZWQiIG9yICJMb3dQcmlvcml0
eSIgZGVsaXZlcnkgbW9kZXMuCj4+Cj4+IEhvd2V2ZXIsIG9uIG1vZGVzIHN1Y2ggYXMgIlNNSSIg
b3IgIkluaXQiLCB3ZSBuZWVkIHRvIGdvIHZpYSBLVk0gY29kZQo+PiB0byBhY3R1YWxseSBwdXQg
dGhlIHZDUFUgaW50byBhIGRpZmZlcmVudCBtb2RlIG9mIG9wZXJhdGlvbiwgc28gd2UgY2FuCj4+
IG5vdCBwb3N0IHRoZSBpbnRlcnJ1cHQKPj4KPj4gQWRkIGNvZGUgaW4gdGhlIFZNWCBQSSBsb2dp
YyB0byBleHBsaWNpdGx5IHJlZnVzZSB0byBlc3RhYmxpc2ggcG9zdGVkCj4+IG1hcHBpbmdzIGZv
ciBhZHZhbmNlZCBJUlEgZGVsaXZlciBtb2Rlcy4gVGhpcyByZWZsZWN0cyB0aGUgbG9naWMgaW4K
Pj4gX19hcGljX2FjY2VwdF9pcnEoKSB3aGljaCBhbHNvIG9ubHkgZXZlciBwYXNzZXMgRml4ZWQg
YW5kIExvd1ByaW9yaXR5Cj4+IGludGVycnVwdHMgYXMgcG9zdGVkIGludGVycnVwdHMgaW50byB0
aGUgZ3Vlc3QuCj4+Cj4+IFRoaXMgZml4ZXMgYSBidWcgSSBoYXZlIHdpdGggY29kZSB3aGljaCBj
b25maWd1cmVzIHJlYWwgaGFyZHdhcmUgdG8KPj4gaW5qZWN0IHZpcnR1YWwgU01JcyBpbnRvIG15
IGd1ZXN0Lgo+Pgo+PiBTaWduZWQtb2ZmLWJ5OiBBbGV4YW5kZXIgR3JhZiA8Z3JhZkBhbWF6b24u
Y29tPgo+PiBSZXZpZXdlZC1ieTogTGlyYW4gQWxvbiA8bGlyYW4uYWxvbkBvcmFjbGUuY29tPgo+
Pgo+PiAtLS0KPj4KPj4gdjEgLT4gdjI6Cj4+Cj4+ICAgIC0gTWFrZSBlcnJvciBtZXNzYWdlIG1v
cmUgdW5pcXVlCj4+ICAgIC0gVXBkYXRlIGNvbW1pdCBtZXNzYWdlIHRvIHBvaW50IHRvIF9fYXBp
Y19hY2NlcHRfaXJxKCkKPj4gLS0tCj4+ICAgYXJjaC94ODYva3ZtL3ZteC92bXguYyB8IDIyICsr
KysrKysrKysrKysrKysrKysrKysKPj4gICAxIGZpbGUgY2hhbmdlZCwgMjIgaW5zZXJ0aW9ucygr
KQo+Pgo+PiBkaWZmIC0tZ2l0IGEvYXJjaC94ODYva3ZtL3ZteC92bXguYyBiL2FyY2gveDg2L2t2
bS92bXgvdm14LmMKPj4gaW5kZXggNTcwYTIzM2UyNzJiLi44MDI5ZmU2NThjMzAgMTAwNjQ0Cj4+
IC0tLSBhL2FyY2gveDg2L2t2bS92bXgvdm14LmMKPj4gKysrIGIvYXJjaC94ODYva3ZtL3ZteC92
bXguYwo+PiBAQCAtNzQwMSw2ICs3NDAxLDI4IEBAIHN0YXRpYyBpbnQgdm14X3VwZGF0ZV9waV9p
cnRlKHN0cnVjdCBrdm0gKmt2bSwgdW5zaWduZWQgaW50IGhvc3RfaXJxLAo+PiAgIAkJCWNvbnRp
bnVlOwo+PiAgIAkJfQo+PiAgIAo+PiArCQlzd2l0Y2ggKGlycS5kZWxpdmVyeV9tb2RlKSB7Cj4+
ICsJCWNhc2UgZGVzdF9GaXhlZDoKPj4gKwkJY2FzZSBkZXN0X0xvd2VzdFByaW86Cj4+ICsJCQli
cmVhazsKPj4gKwkJZGVmYXVsdDoKPj4gKwkJCS8qCj4+ICsJCQkgKiBGb3Igbm9uLXRyaXZpYWwg
aW50ZXJydXB0IGV2ZW50cywgd2UgbmVlZCB0byBnbwo+PiArCQkJICogdGhyb3VnaCB0aGUgZnVs
bCBLVk0gSVJRIGNvZGUsIHNvIHJlZnVzZSB0byB0YWtlCj4+ICsJCQkgKiBhbnkgZGlyZWN0IFBJ
IGFzc2lnbm1lbnRzIGhlcmUuCj4+ICsJCQkgKi8KPiAKPiBJTU8sIGEgYmVlZnkgY29tbWVudCBp
cyB1bm5lY2Vzc2FyeSwgYW55b25lIHRoYXQgaXMgZGlnZ2luZyB0aHJvdWdoIHRoaXMKPiBjb2Rl
IGhhcyBob3BlZnVsbHkgcmVhZCB0aGUgUEkgc3BlYyBvciBhdCBsZWFzdCB1bmRlcnN0YW5kcyB0
aGUgYmFzaWMKPiBjb25jZXB0cy4gIEkuZS4gaXQgc2hvdWxkIGJlIG9idmlvdXMgdGhhdCBQSSBj
YW4ndCBiZSB1c2VkIGZvciBTTUksIGV0Yy4uLgo+IAo+PiArCQkJcmV0ID0gaXJxX3NldF92Y3B1
X2FmZmluaXR5KGhvc3RfaXJxLCBOVUxMKTsKPj4gKwkJCWlmIChyZXQgPCAwKSB7Cj4+ICsJCQkJ
cHJpbnRrKEtFUk5fSU5GTwo+PiArCQkJCSAgICAibm9uLXN0ZCBJUlEgZmFpbGVkIHRvIHJlY292
ZXIsIGlycTogJXVcbiIsCj4+ICsJCQkJICAgIGhvc3RfaXJxKTsKPj4gKwkJCQlnb3RvIG91dDsK
Pj4gKwkJCX0KPj4gKwo+PiArCQkJY29udGludWU7Cj4gCj4gVXNpbmcgYSBzd2l0Y2ggdG8gZmls
dGVyIG91dCB0d28gdHlwZXMgaXMgYSBiaXQgb2Ygb3ZlcmtpbGwuICBJdCBhbHNvCgpUaGUgc3dp
dGNoIHNob3VsZCBjb21waWxlIGludG8gdGhlIHNhbWUgYXMgdGhlIGlmKCkgYmVsb3csIGl0J3Mg
anVzdCBhIAptYXR0ZXIgb2YgYmVpbmcgbW9yZSB2ZXJib3NlIGluIGNvZGUuCgo+IHByb2JhYmx5
IG1ha2VzIHNlbnNlIHRvIHBlcmZvcm0gdGhlIGRlbGl2ZXJfbW9kZSBjaGVja3MgYmVmb3JlIGNh
bGxpbmcKPiBrdm1faW50cl9pc19zaW5nbGVfdmNwdSgpLiAgV2h5IG5vdCBzaW1wbHkgc29tZXRo
aW5nIGxpa2UgdGhpcz8gIFRoZQo+IGV4aXN0aW5nIGNvbW1lbnQgYW5kIGVycm9yIG1lc3NhZ2Ug
YXJlIGV2ZW4gZ2VuZXJpYyBlbm91Z2ggdG8ga2VlcCBhcyBpcy4KCk9rLCBzbyBob3cgYWJvdXQg
dGhpcywgZXZlbiB0aG91Z2ggaXQgZ29lcyBhZ2FpbnN0IExpcmFuJ3MgY29tbWVudCBvbiAKdGhl
IGNvbWJpbmVkIGRlYnVnIHByaW50PwoKSWYgeW91IHRoaW5rIGl0J3MgcmVhc29uYWJsZSBkZXNw
aXRlIHRoZSBicm9rZW4gZm9ybWF0dGluZywgSSdsbCBiZSAKaGFwcHkgdG8gZm9sZCB0aGUgcGF0
Y2hlcyBhbmQgc3VibWl0IGFzIHYzLgoKCkFsZXgKCgpkaWZmIC0tZ2l0IGEvYXJjaC94ODYvaW5j
bHVkZS9hc20va3ZtX2hvc3QuaCAKYi9hcmNoL3g4Ni9pbmNsdWRlL2FzbS9rdm1faG9zdC5oCmlu
ZGV4IDQ0YTVjZTU3YTkwNS4uNTVmNjhmYjBkNzkxIDEwMDY0NAotLS0gYS9hcmNoL3g4Ni9pbmNs
dWRlL2FzbS9rdm1faG9zdC5oCisrKyBiL2FyY2gveDg2L2luY2x1ZGUvYXNtL2t2bV9ob3N0LmgK
QEAgLTE1ODEsNiArMTU4MSwxMiBAQCBib29sIGt2bV9pbnRyX2lzX3NpbmdsZV92Y3B1KHN0cnVj
dCBrdm0gKmt2bSwgCnN0cnVjdCBrdm1fbGFwaWNfaXJxICppcnEsCiAgdm9pZCBrdm1fc2V0X21z
aV9pcnEoc3RydWN0IGt2bSAqa3ZtLCBzdHJ1Y3QgCmt2bV9rZXJuZWxfaXJxX3JvdXRpbmdfZW50
cnkgKmUsCiAgCQkgICAgIHN0cnVjdCBrdm1fbGFwaWNfaXJxICppcnEpOwoKK3N0YXRpYyBpbmxp
bmUgYm9vbCBrdm1faXJxX2lzX2dlbmVyaWMoc3RydWN0IGt2bV9sYXBpY19pcnEgKmlycSkKK3sK
KwlyZXR1cm4gKGlycS0+ZGVsaXZlcnlfbW9kZSA9PSBkZXN0X0ZpeGVkIHx8CisJCWlycS0+ZGVs
aXZlcnlfbW9kZSA9PSBkZXN0X0xvd2VzdFByaW8pOworfQorCiAgc3RhdGljIGlubGluZSB2b2lk
IGt2bV9hcmNoX3ZjcHVfYmxvY2tpbmcoc3RydWN0IGt2bV92Y3B1ICp2Y3B1KQogIHsKICAJaWYg
KGt2bV94ODZfb3BzLT52Y3B1X2Jsb2NraW5nKQpkaWZmIC0tZ2l0IGEvYXJjaC94ODYva3ZtL3N2
bS5jIGIvYXJjaC94ODYva3ZtL3N2bS5jCmluZGV4IDFmMjIwYTg1NTE0Zi4uMzRjYzU5NTE4Y2Ji
IDEwMDY0NAotLS0gYS9hcmNoL3g4Ni9rdm0vc3ZtLmMKKysrIGIvYXJjaC94ODYva3ZtL3N2bS5j
CkBAIC01MjYwLDcgKzUyNjAsOCBAQCBnZXRfcGlfdmNwdV9pbmZvKHN0cnVjdCBrdm0gKmt2bSwg
c3RydWN0IAprdm1fa2VybmVsX2lycV9yb3V0aW5nX2VudHJ5ICplLAoKICAJa3ZtX3NldF9tc2lf
aXJxKGt2bSwgZSwgJmlycSk7CgotCWlmICgha3ZtX2ludHJfaXNfc2luZ2xlX3ZjcHUoa3ZtLCAm
aXJxLCAmdmNwdSkpIHsKKwlpZiAoIWt2bV9pbnRyX2lzX3NpbmdsZV92Y3B1KGt2bSwgJmlycSwg
JnZjcHUpIHx8CisJICAgICFrdm1faXJxX2lzX2dlbmVyaWMoJmlycSkpIHsKICAJCXByX2RlYnVn
KCJTVk06ICVzOiB1c2UgbGVnYWN5IGludHIgcmVtYXAgbW9kZSBmb3IgaXJxICV1XG4iLAogIAkJ
CSBfX2Z1bmNfXywgaXJxLnZlY3Rvcik7CiAgCQlyZXR1cm4gLTE7CkBAIC01MzE0LDYgKzUzMTUs
NyBAQCBzdGF0aWMgaW50IHN2bV91cGRhdGVfcGlfaXJ0ZShzdHJ1Y3Qga3ZtICprdm0sIAp1bnNp
Z25lZCBpbnQgaG9zdF9pcnEsCiAgCQkgKiAxLiBXaGVuIGNhbm5vdCB0YXJnZXQgaW50ZXJydXB0
IHRvIGEgc3BlY2lmaWMgdmNwdS4KICAJCSAqIDIuIFVuc2V0dGluZyBwb3N0ZWQgaW50ZXJydXB0
LgogIAkJICogMy4gQVBJQyB2aXJ0aWFsaXphdGlvbiBpcyBkaXNhYmxlZCBmb3IgdGhlIHZjcHUu
CisJCSAqIDQuIElSUSBoYXMgZXh0ZW5kZWQgZGVsaXZlcnkgbW9kZSAoU01JLCBJTklULCBldGMp
CiAgCQkgKi8KICAJCWlmICghZ2V0X3BpX3ZjcHVfaW5mbyhrdm0sIGUsICZ2Y3B1X2luZm8sICZz
dm0pICYmIHNldCAmJgogIAkJICAgIGt2bV92Y3B1X2FwaWN2X2FjdGl2ZSgmc3ZtLT52Y3B1KSkg
ewpkaWZmIC0tZ2l0IGEvYXJjaC94ODYva3ZtL3ZteC92bXguYyBiL2FyY2gveDg2L2t2bS92bXgv
dm14LmMKaW5kZXggNTcwYTIzM2UyNzJiLi42OWY1MzgwOWM3YmIgMTAwNjQ0Ci0tLSBhL2FyY2gv
eDg2L2t2bS92bXgvdm14LmMKKysrIGIvYXJjaC94ODYva3ZtL3ZteC92bXguYwpAQCAtNzM4Miwx
MCArNzM4MiwxNCBAQCBzdGF0aWMgaW50IHZteF91cGRhdGVfcGlfaXJ0ZShzdHJ1Y3Qga3ZtICpr
dm0sIAp1bnNpZ25lZCBpbnQgaG9zdF9pcnEsCiAgCQkgKiBpcnFiYWxhbmNlIHRvIG1ha2UgdGhl
IGludGVycnVwdHMgc2luZ2xlLUNQVS4KICAJCSAqCiAgCQkgKiBXZSB3aWxsIHN1cHBvcnQgZnVs
bCBsb3dlc3QtcHJpb3JpdHkgaW50ZXJydXB0IGxhdGVyLgorCQkgKgorCQkgKiBJbiBhZGRpdGlv
biwgd2UgY2FuIG9ubHkgaW5qZWN0IGdlbmVyaWMgaW50ZXJydXB0cyB1c2luZworCQkgKiB0aGUg
UEkgbWVjaGFuaXNtLCByZWZ1c2UgdG8gcm91dGUgb3RoZXJzIHRocm91Z2ggaXQuCiAgCQkgKi8K
CiAgCQlrdm1fc2V0X21zaV9pcnEoa3ZtLCBlLCAmaXJxKTsKLQkJaWYgKCFrdm1faW50cl9pc19z
aW5nbGVfdmNwdShrdm0sICZpcnEsICZ2Y3B1KSkgeworCQlpZiAoIWt2bV9pbnRyX2lzX3Npbmds
ZV92Y3B1KGt2bSwgJmlycSwgJnZjcHUpIHx8CisJCSAgICAha3ZtX2lycV9pc19nZW5lcmljKCZp
cnEpKSB7CiAgCQkJLyoKICAJCQkgKiBNYWtlIHN1cmUgdGhlIElSVEUgaXMgaW4gcmVtYXBwZWQg
bW9kZSBpZgogIAkJCSAqIHdlIGRvbid0IGhhbmRsZSBpdCBpbiBwb3N0ZWQgbW9kZS4KCgoKCkFt
YXpvbiBEZXZlbG9wbWVudCBDZW50ZXIgR2VybWFueSBHbWJICktyYXVzZW5zdHIuIDM4CjEwMTE3
IEJlcmxpbgpHZXNjaGFlZnRzZnVlaHJ1bmc6IENocmlzdGlhbiBTY2hsYWVnZXIsIFJhbGYgSGVy
YnJpY2gKRWluZ2V0cmFnZW4gYW0gQW10c2dlcmljaHQgQ2hhcmxvdHRlbmJ1cmcgdW50ZXIgSFJC
IDE0OTE3MyBCClNpdHo6IEJlcmxpbgpVc3QtSUQ6IERFIDI4OSAyMzcgODc5CgoK

