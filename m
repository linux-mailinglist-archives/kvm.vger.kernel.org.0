Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 292159E3B7
	for <lists+kvm@lfdr.de>; Tue, 27 Aug 2019 11:11:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728704AbfH0JLE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Aug 2019 05:11:04 -0400
Received: from smtp-fw-9102.amazon.com ([207.171.184.29]:24834 "EHLO
        smtp-fw-9102.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725805AbfH0JLE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Aug 2019 05:11:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1566897062; x=1598433062;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=kAsHi3j+TbQl6FjG1Q5eSuJmO7i++0Wyq36ouUzhBno=;
  b=dhPmEYaVRz1NOQttSzkIWrbwXZPoHM045vIZWpuU/peWfWKZTqX3gonL
   pfkHE4pW7eULy96fVxeKw6IcWx5Wd9dla/1rG6GNYldmRt9YmmyXG8Y13
   RXE8WeU4a/HEgPp7OPy+et6KBsfBAQDb0gxP3ZjkBFivDkj+PT0w3Oudr
   o=;
X-IronPort-AV: E=Sophos;i="5.64,436,1559520000"; 
   d="scan'208";a="697831983"
Received: from sea3-co-svc-lb6-vlan3.sea.amazon.com (HELO email-inbound-relay-1a-7d76a15f.us-east-1.amazon.com) ([10.47.22.38])
  by smtp-border-fw-out-9102.sea19.amazon.com with ESMTP; 27 Aug 2019 09:11:00 +0000
Received: from EX13MTAUWC001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan2.iad.amazon.com [10.40.159.162])
        by email-inbound-relay-1a-7d76a15f.us-east-1.amazon.com (Postfix) with ESMTPS id E8CA1A2B6E;
        Tue, 27 Aug 2019 09:10:57 +0000 (UTC)
Received: from EX13D20UWC001.ant.amazon.com (10.43.162.244) by
 EX13MTAUWC001.ant.amazon.com (10.43.162.135) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Tue, 27 Aug 2019 09:10:57 +0000
Received: from 38f9d3867b82.ant.amazon.com (10.43.162.191) by
 EX13D20UWC001.ant.amazon.com (10.43.162.244) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Tue, 27 Aug 2019 09:10:54 +0000
Subject: Re: [PATCH v2 12/15] kvm: i8254: Check LAPIC EOI pending when
 injecting irq on SVM AVIC
To:     "Suthikulpanit, Suravee" <Suravee.Suthikulpanit@amd.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC:     "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "rkrcmar@redhat.com" <rkrcmar@redhat.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "jschoenh@amazon.de" <jschoenh@amazon.de>,
        "karahmed@amazon.de" <karahmed@amazon.de>,
        "rimasluk@amazon.com" <rimasluk@amazon.com>,
        "Grimm, Jon" <Jon.Grimm@amd.com>
References: <1565886293-115836-1-git-send-email-suravee.suthikulpanit@amd.com>
 <1565886293-115836-13-git-send-email-suravee.suthikulpanit@amd.com>
 <ac9fa8d4-2c25-52a5-3938-3ce373b3c3e0@amazon.com>
 <8320fecb-de61-1a01-b90d-a45f224de287@amd.com>
From:   Alexander Graf <graf@amazon.com>
Message-ID: <a72ac8cc-d0df-9a3f-dff2-0e85e944fb74@amazon.com>
Date:   Tue, 27 Aug 2019 11:10:51 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <8320fecb-de61-1a01-b90d-a45f224de287@amd.com>
Content-Language: en-US
X-Originating-IP: [10.43.162.191]
X-ClientProxiedBy: EX13P01UWA002.ant.amazon.com (10.43.160.46) To
 EX13D20UWC001.ant.amazon.com (10.43.162.244)
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: base64
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

CgpPbiAyNi4wOC4xOSAyMjo0NiwgU3V0aGlrdWxwYW5pdCwgU3VyYXZlZSB3cm90ZToKPiBBbGV4
LAo+IAo+IE9uIDgvMTkvMjAxOSA1OjQyIEFNLCBBbGV4YW5kZXIgR3JhZiB3cm90ZToKPj4KPj4K
Pj4gT27CoDE1LjA4LjE5wqAxODoyNSzCoFN1dGhpa3VscGFuaXQswqBTdXJhdmVlwqB3cm90ZToK
Pj4+IEFDS8Kgbm90aWZpZXJzwqBkb24ndMKgd29ya8Kgd2l0aMKgQU1EwqBTVk3CoHcvwqBBVklD
wqB3aGVuwqB0aGXCoFBJVMKgaW50ZXJydXB0Cj4+PiBpc8KgZGVsaXZlcmVkwqBhc8KgZWRnZS10
cmlnZ2VyZWTCoGZpeGVkwqBpbnRlcnJ1cHTCoHNpbmNlwqBBTUTCoHByb2Nlc3NvcnMKPj4+IGNh
bm5vdMKgZXhpdMKgb27CoEVPScKgZm9ywqB0aGVzZcKgaW50ZXJydXB0cy4KPj4+Cj4+PiBBZGTC
oGNvZGXCoHRvwqBjaGVja8KgTEFQSUPCoHBlbmRpbmfCoEVPScKgYmVmb3JlwqBpbmplY3RpbmfC
oGFuecKgcGVuZGluZ8KgUElUCj4+PiBpbnRlcnJ1cHTCoG9uwqBBTUTCoFNWTcKgd2hlbsKgQVZJ
Q8KgaXPCoGFjdGl2YXRlZC4KPj4+Cj4+PiBTaWduZWQtb2ZmLWJ5OsKgU3VyYXZlZcKgU3V0aGlr
dWxwYW5pdCA8c3VyYXZlZS5zdXRoaWt1bHBhbml0QGFtZC5jb20+Cj4+PiAtLS0KPj4+ICDCoMKg
YXJjaC94ODYva3ZtL2k4MjU0LmPCoHzCoDMxwqArKysrKysrKysrKysrKysrKysrKysrKysrLS0t
LS0tCj4+PiAgwqDCoDHCoGZpbGXCoGNoYW5nZWQswqAyNcKgaW5zZXJ0aW9ucygrKSzCoDbCoGRl
bGV0aW9ucygtKQo+Pj4KPj4+IGRpZmbCoC0tZ2l0wqBhL2FyY2gveDg2L2t2bS9pODI1NC5jwqBi
L2FyY2gveDg2L2t2bS9pODI1NC5jCj4+PiBpbmRleMKgNGE2ZGM1NC4uMzFjNGE5YsKgMTAwNjQ0
Cj4+PiAtLS3CoGEvYXJjaC94ODYva3ZtL2k4MjU0LmMKPj4+ICsrK8KgYi9hcmNoL3g4Ni9rdm0v
aTgyNTQuYwo+Pj4gQEDCoC0zNCwxMMKgKzM0LDEywqBAQAo+Pj4gIMKgwqAjaW5jbHVkZcKgPGxp
bnV4L2t2bV9ob3N0Lmg+Cj4+PiAgwqDCoCNpbmNsdWRlwqA8bGludXgvc2xhYi5oPgo+Pj4gKyNp
bmNsdWRlwqA8YXNtL3ZpcnRleHQuaD4KPj4+ICDCoMKgI2luY2x1ZGXCoCJpb2FwaWMuaCIKPj4+
ICDCoMKgI2luY2x1ZGXCoCJpcnEuaCIKPj4+ICDCoMKgI2luY2x1ZGXCoCJpODI1NC5oIgo+Pj4g
KyNpbmNsdWRlwqAibGFwaWMuaCIKPj4+ICDCoMKgI2luY2x1ZGXCoCJ4ODYuaCIKPj4+ICDCoMKg
I2lmbmRlZsKgQ09ORklHX1g4Nl82NAo+Pj4gQEDCoC0yMzYsNsKgKzIzOCwxMsKgQEDCoHN0YXRp
Y8Kgdm9pZMKgZGVzdHJveV9waXRfdGltZXIoc3RydWN0wqBrdm1fcGl0wqAqcGl0KQo+Pj4gIMKg
wqDCoMKgwqDCoGt0aHJlYWRfZmx1c2hfd29yaygmcGl0LT5leHBpcmVkKTsKPj4+ICDCoMKgfQo+
Pj4gK3N0YXRpY8KgaW5saW5lwqB2b2lkwqBrdm1fcGl0X3Jlc2V0X3JlaW5qZWN0KHN0cnVjdMKg
a3ZtX3BpdMKgKnBpdCkKPj4+ICt7Cj4+PiArwqDCoMKgwqBhdG9taWNfc2V0KCZwaXQtPnBpdF9z
dGF0ZS5wZW5kaW5nLMKgMCk7Cj4+PiArwqDCoMKgwqBhdG9taWNfc2V0KCZwaXQtPnBpdF9zdGF0
ZS5pcnFfYWNrLMKgMSk7Cj4+PiArfQo+Pj4gKwo+Pj4gIMKgwqBzdGF0aWPCoHZvaWTCoHBpdF9k
b193b3JrKHN0cnVjdMKga3RocmVhZF93b3JrwqAqd29yaykKPj4+ICDCoMKgewo+Pj4gIMKgwqDC
oMKgwqDCoHN0cnVjdMKga3ZtX3BpdMKgKnBpdMKgPcKgY29udGFpbmVyX29mKHdvcmsswqBzdHJ1
Y3TCoGt2bV9waXQswqBleHBpcmVkKTsKPj4+IEBAwqAtMjQ0LDbCoCsyNTIsMjPCoEBAwqBzdGF0
aWPCoHZvaWTCoHBpdF9kb193b3JrKHN0cnVjdMKga3RocmVhZF93b3JrwqAqd29yaykKPj4+ICDC
oMKgwqDCoMKgwqBpbnTCoGk7Cj4+PiAgwqDCoMKgwqDCoMKgc3RydWN0wqBrdm1fa3BpdF9zdGF0
ZcKgKnBzwqA9wqAmcGl0LT5waXRfc3RhdGU7Cj4+PiArwqDCoMKgwqAvKgo+Pj4gK8KgwqDCoMKg
wqAqwqBTaW5jZSzCoEFNRMKgU1ZNwqBBVklDwqBhY2NlbGVyYXRlc8Kgd3JpdGXCoGFjY2Vzc8Kg
dG/CoEFQSUPCoEVPSQo+Pj4gK8KgwqDCoMKgwqAqwqByZWdpc3RlcsKgZm9ywqBlZGdlLXRyaWdn
ZXLCoGludGVycnVwdHMuwqBQSVTCoHdpbGzCoG5vdMKgYmXCoGFibGUKPj4+ICvCoMKgwqDCoMKg
KsKgdG/CoHJlY2VpdmXCoHRoZcKgSVJRwqBBQ0vCoG5vdGlmaWVywqBhbmTCoHdpbGzCoGFsd2F5
c8KgYmXCoHplcm8uCj4+PiArwqDCoMKgwqDCoCrCoFRoZXJlZm9yZSzCoHdlwqBjaGVja8KgaWbC
oGFuecKgTEFQSUPCoEVPScKgcGVuZGluZ8KgZm9ywqB2ZWN0b3LCoDAKPj4+ICvCoMKgwqDCoMKg
KsKgYW5kwqByZXNldMKgaXJxX2Fja8KgaWbCoG5vwqBwZW5kaW5nLgo+Pj4gK8KgwqDCoMKgwqAq
Lwo+Pj4gK8KgwqDCoMKgaWbCoChjcHVfaGFzX3N2bShOVUxMKcKgJibCoGt2bS0+YXJjaC5hcGlj
dl9zdGF0ZcKgPT3CoEFQSUNWX0FDVElWQVRFRCnCoHsKPj4+ICvCoMKgwqDCoMKgwqDCoMKgaW50
wqBlb2nCoD3CoDA7Cj4+PiArCj4+PiArwqDCoMKgwqDCoMKgwqDCoGt2bV9mb3JfZWFjaF92Y3B1
KGkswqB2Y3B1LMKga3ZtKQo+Pj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoGlmwqAoa3ZtX2Fw
aWNfcGVuZGluZ19lb2kodmNwdSzCoDApKQo+Pj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgZW9pKys7Cj4+PiArwqDCoMKgwqDCoMKgwqDCoGlmwqAoIWVvaSkKPj4+ICvCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqBrdm1fcGl0X3Jlc2V0X3JlaW5qZWN0KHBpdCk7Cj4+Cj4+IEluwqB3
aGljaMKgY2FzZcKgd291bGTCoGVvacKgYmXCoCE9wqAwwqB3aGVuwqBBUElDLVbCoGlzwqBhY3Rp
dmU/Cj4gCj4gVGhhdCB3b3VsZCBiZSB0aGUgY2FzZSB3aGVuIGd1ZXN0IGhhcyBub3QgcHJvY2Vz
c2VkIGFuZC9vciBzdGlsbCBwcm9jZXNzaW5nIHRoZSBpbnRlcnJ1cHQuCj4gT25jZSB0aGUgZ3Vl
c3Qgd3JpdGVzIHRvIEFQSUMgRU9JIHJlZ2lzdGVyIGZvciBlZGdlLXRyaWdnZXJlZCBpbnRlcnJ1
cHQgZm9yIHZlY3RvciAwLAo+IGFuZCB0aGUgQVZJQyBoYXJkd2FyZSBhY2NlbGVyYXRlZCB0aGUg
YWNjZXNzIGJ5IGNsZWFyaW5nIHRoZSBoaWdoZXN0IHByaW9yaXR5IElTUiBiaXQsCj4gdGhlbiB0
aGUgZW9pIHNob3VsZCBiZSB6ZXJvLgoKVGhpbmtpbmcgYWJvdXQgdGhpcyBhIGJpdCBtb3JlLCB5
b3UncmUgYmFzaWNhbGx5IHNheWluZyB0aGUgaXJxIGFjayAKbm90aWZpZXIgbmV2ZXIgdHJpZ2dl
cnMgYmVjYXVzZSB3ZSBkb24ndCBzZWUgdGhlIEVPSSByZWdpc3RlciB3cml0ZSwgYnV0IAp3ZSBj
YW4gZGV0ZXJtaW5lIHRoZSBzdGF0ZSBhc3luY2hyb25vdXNseS4KClRoZSBpcnFmZCBjb2RlIGFs
c28gdXNlcyB0aGUgYWNrIG5vdGlmaWVyIGZvciBsZXZlbCBpcnEgcmVpbmplY3Rpb24uIApXaWxs
IHRoYXQgYnJlYWsgYXMgd2VsbD8KCldvdWxkbid0IGl0IG1ha2UgbW9yZSBzZW5zZSB0byB0cnkg
dG8gZWl0aGVyIG1haW50YWluIHRoZSBhY2sgbm90aWZpZXIgCkFQSSBvciByZW1vdmUgaXQgY29t
cGxldGVseSBpZiB3ZSBjYW4ndCBmaW5kIGEgd2F5IHRvIG1ha2UgaXQgd29yayB3aXRoIApBUElD
LVY/CgpTbyB3aGF0IGlmIHdlIGRldGVjdCB0aGF0IGFuIElSUSB2ZWN0b3Igd2UncmUgaW5qZWN0
aW5nIGZvciBoYXMgYW4gaXJxIApub3RpZmllcj8gSWYgaXQgZG9lcywgd2Ugc2V0IHVwIC8gc3Rh
cnQ6CgogICAqIGFuIGhydGltZXIgdGhhdCBwb2xscyBmb3IgRU9JIG9uIHRoYXQgdmVjdG9yCiAg
ICogYSBmbGFnIHNvIHRoYXQgZXZlcnkgdmNwdSBvbiBleGl0IGNoZWNrcyBmb3IgRU9JIG9uIHRo
YXQgdmVjdG9yCiAgICogYSBkaXJlY3QgY2FsbCBmcm9tIHBpdF9kb193b3JrIHRvIGNoZWNrIG9u
IGl0IGFzIHdlbGwKCkVhY2ggb2YgdGhlbSB3b3VsZCBnbyB0aHJvdWdoIGEgc2luZ2xlIGNvZGUg
cGF0aCB0aGF0IHRoZW4gY2FsbHMgdGhlIAphY2tfbm90aWZpZXIuCgpUaGF0IHdheSB3ZSBzaG91
bGQgYmUgYWJsZSB0byBqdXN0IG1haW50YWluIHRoZSBvbGQgQVBJIGFuZCBub3QgZ2V0IGludG8g
CnVucGxlYXNhbnQgc3VycHJpc2VzIHRoYXQgb25seSBtYW5pZmVzdCBvbiBhIHRpbnkgZmFjdGlv
biBvZiBzeXN0ZW1zLCByaWdodD8KCgpBbHRlcm5hdGl2ZWx5LCBmZWVsIGZyZWUgdG8gcmVtb3Zl
IHRoZSBhY2sgbG9naWMgYWx0b2dldGhlciBhbmQgbW92ZSBhbGwgCnVzZXJzIG9mIGl0IHRvIGRp
ZmZlcmVudCBtZWNoYW5pc21zIChjaGVjayBpbiBkb193b3JrIGhlcmUsIGFkZGl0aW9uYWwgCnRp
bWVyIGluIGlycWZkIHByb2JhYmx5KS4KCgpMZXQncyB0cnkgdG8gYmUgYXMgY29uc2lzdGVudCBh
cyBwb3NzaWJsZSBhY3Jvc3MgZGlmZmVyZW50IGhvc3QgCnBsYXRmb3Jtcy4gT3RoZXJ3aXNlIHRo
ZSB0ZXN0IG1hdHJpeCBqdXN0IGV4cGxvZGVzLgoKCkFsZXgKCgoKQW1hem9uIERldmVsb3BtZW50
IENlbnRlciBHZXJtYW55IEdtYkgKS3JhdXNlbnN0ci4gMzgKMTAxMTcgQmVybGluCkdlc2NoYWVm
dHNmdWVocnVuZzogQ2hyaXN0aWFuIFNjaGxhZWdlciwgUmFsZiBIZXJicmljaApFaW5nZXRyYWdl
biBhbSBBbXRzZ2VyaWNodCBDaGFybG90dGVuYnVyZyB1bnRlciBIUkIgMTQ5MTczIEIKU2l0ejog
QmVybGluClVzdC1JRDogREUgMjg5IDIzNyA4NzkKCgo=

