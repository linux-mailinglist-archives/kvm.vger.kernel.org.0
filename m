Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C7A5DBAE07
	for <lists+kvm@lfdr.de>; Mon, 23 Sep 2019 08:54:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393342AbfIWGyW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Sep 2019 02:54:22 -0400
Received: from smtp-fw-2101.amazon.com ([72.21.196.25]:24477 "EHLO
        smtp-fw-2101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388937AbfIWGyW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Sep 2019 02:54:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1569221661; x=1600757661;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=0LuES5jNYjOJrVNcd7E+YqVsn5M9qjRy0UqX6zqVjPQ=;
  b=V/9z/I/cSgh/62qUMNbPQCjnEiA+S777eXFJHh1cQU7ynE9KxVgOWYLv
   ZT97z6Bn+OsKn/96AIug55Fdvpx0l6W+gDFTdV+IHLCuqXMjD/Z7ciHmB
   nAOrGbZbJc8LG6TdL/WZI7IJ4+GzHuHGBKQ55RLgtre4ZGQOV2uIiIen+
   Y=;
X-IronPort-AV: E=Sophos;i="5.64,539,1559520000"; 
   d="scan'208";a="752438067"
Received: from iad6-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-1e-a70de69e.us-east-1.amazon.com) ([10.124.125.2])
  by smtp-border-fw-out-2101.iad2.amazon.com with ESMTP; 23 Sep 2019 06:54:21 +0000
Received: from EX13MTAUWC001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan2.iad.amazon.com [10.40.159.162])
        by email-inbound-relay-1e-a70de69e.us-east-1.amazon.com (Postfix) with ESMTPS id D5DF9A0745;
        Mon, 23 Sep 2019 06:54:16 +0000 (UTC)
Received: from EX13D20UWC001.ant.amazon.com (10.43.162.244) by
 EX13MTAUWC001.ant.amazon.com (10.43.162.135) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Mon, 23 Sep 2019 06:54:15 +0000
Received: from 38f9d3867b82.ant.amazon.com (10.43.161.217) by
 EX13D20UWC001.ant.amazon.com (10.43.162.244) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Mon, 23 Sep 2019 06:53:58 +0000
Subject: Re: [PATCH v7 11/21] RISC-V: KVM: Handle WFI exits for VCPU
To:     Anup Patel <Anup.Patel@wdc.com>,
        Palmer Dabbelt <palmer@sifive.com>,
        "Paul Walmsley" <paul.walmsley@sifive.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim K <rkrcmar@redhat.com>
CC:     Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Atish Patra <Atish.Patra@wdc.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Damien Le Moal <Damien.LeMoal@wdc.com>,
        "Christoph Hellwig" <hch@infradead.org>,
        Anup Patel <anup@brainfault.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-riscv@lists.infradead.org" <linux-riscv@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20190904161245.111924-1-anup.patel@wdc.com>
 <20190904161245.111924-13-anup.patel@wdc.com>
From:   Alexander Graf <graf@amazon.com>
Message-ID: <3c149ec4-38df-9073-2880-b28148d3c059@amazon.com>
Date:   Mon, 23 Sep 2019 08:53:49 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20190904161245.111924-13-anup.patel@wdc.com>
Content-Language: en-US
X-Originating-IP: [10.43.161.217]
X-ClientProxiedBy: EX13D28UWC002.ant.amazon.com (10.43.162.145) To
 EX13D20UWC001.ant.amazon.com (10.43.162.244)
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: base64
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

CgpPbiAwNC4wOS4xOSAxODoxNSwgQW51cCBQYXRlbCB3cm90ZToKPiBXZSBnZXQgaWxsZWdhbCBp
bnN0cnVjdGlvbiB0cmFwIHdoZW5ldmVyIEd1ZXN0L1ZNIGV4ZWN1dGVzIFdGSQo+IGluc3RydWN0
aW9uLgo+IAo+IFRoaXMgcGF0Y2ggaGFuZGxlcyBXRkkgdHJhcCBieSBibG9ja2luZyB0aGUgdHJh
cHBlZCBWQ1BVIHVzaW5nCj4ga3ZtX3ZjcHVfYmxvY2soKSBBUEkuIFRoZSBibG9ja2VkIFZDUFUg
d2lsbCBiZSBhdXRvbWF0aWNhbGx5Cj4gcmVzdW1lZCB3aGVuZXZlciBhIFZDUFUgaW50ZXJydXB0
IGlzIGluamVjdGVkIGZyb20gdXNlci1zcGFjZQo+IG9yIGZyb20gaW4ta2VybmVsIElSUUNISVAg
ZW11bGF0aW9uLgo+IAo+IFNpZ25lZC1vZmYtYnk6IEFudXAgUGF0ZWwgPGFudXAucGF0ZWxAd2Rj
LmNvbT4KPiBBY2tlZC1ieTogUGFvbG8gQm9uemluaSA8cGJvbnppbmlAcmVkaGF0LmNvbT4KPiBS
ZXZpZXdlZC1ieTogUGFvbG8gQm9uemluaSA8cGJvbnppbmlAcmVkaGF0LmNvbT4KPiAtLS0KPiAg
IGFyY2gvcmlzY3Yva3ZtL3ZjcHVfZXhpdC5jIHwgNzIgKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysKPiAgIDEgZmlsZSBjaGFuZ2VkLCA3MiBpbnNlcnRpb25zKCspCj4gCj4g
ZGlmZiAtLWdpdCBhL2FyY2gvcmlzY3Yva3ZtL3ZjcHVfZXhpdC5jIGIvYXJjaC9yaXNjdi9rdm0v
dmNwdV9leGl0LmMKPiBpbmRleCBkNzVhNmMzNWI2YzcuLjM5NDY5ZjY3YjI0MSAxMDA2NDQKPiAt
LS0gYS9hcmNoL3Jpc2N2L2t2bS92Y3B1X2V4aXQuYwo+ICsrKyBiL2FyY2gvcmlzY3Yva3ZtL3Zj
cHVfZXhpdC5jCj4gQEAgLTEyLDYgKzEyLDEzIEBACj4gICAjaW5jbHVkZSA8bGludXgva3ZtX2hv
c3QuaD4KPiAgICNpbmNsdWRlIDxhc20vY3NyLmg+Cj4gICAKPiArI2RlZmluZSBJTlNOX09QQ09E
RV9NQVNLCTB4MDA3Ywo+ICsjZGVmaW5lIElOU05fT1BDT0RFX1NISUZUCTIKPiArI2RlZmluZSBJ
TlNOX09QQ09ERV9TWVNURU0JMjgKPiArCj4gKyNkZWZpbmUgSU5TTl9NQVNLX1dGSQkJMHhmZmZm
ZmYwMAo+ICsjZGVmaW5lIElOU05fTUFUQ0hfV0ZJCQkweDEwNTAwMDAwCj4gKwo+ICAgI2RlZmlu
ZSBJTlNOX01BVENIX0xCCQkweDMKPiAgICNkZWZpbmUgSU5TTl9NQVNLX0xCCQkweDcwN2YKPiAg
ICNkZWZpbmUgSU5TTl9NQVRDSF9MSAkJMHgxMDAzCj4gQEAgLTExMiw2ICsxMTksNjcgQEAKPiAg
IAkJCQkgKHMzMikoKChpbnNuKSA+PiA3KSAmIDB4MWYpKQo+ICAgI2RlZmluZSBNQVNLX0ZVTkNU
MwkJMHg3MDAwCj4gICAKPiArc3RhdGljIGludCB0cnVseV9pbGxlZ2FsX2luc24oc3RydWN0IGt2
bV92Y3B1ICp2Y3B1LAo+ICsJCQkgICAgICBzdHJ1Y3Qga3ZtX3J1biAqcnVuLAo+ICsJCQkgICAg
ICB1bG9uZyBpbnNuKQo+ICt7Cj4gKwkvKiBSZWRpcmVjdCB0cmFwIHRvIEd1ZXN0IFZDUFUgKi8K
PiArCWt2bV9yaXNjdl92Y3B1X3RyYXBfcmVkaXJlY3QodmNwdSwgRVhDX0lOU1RfSUxMRUdBTCwg
aW5zbik7Cj4gKwo+ICsJcmV0dXJuIDE7Cj4gK30KPiArCj4gK3N0YXRpYyBpbnQgc3lzdGVtX29w
Y29kZV9pbnNuKHN0cnVjdCBrdm1fdmNwdSAqdmNwdSwKPiArCQkJICAgICAgc3RydWN0IGt2bV9y
dW4gKnJ1biwKPiArCQkJICAgICAgdWxvbmcgaW5zbikKPiArewo+ICsJaWYgKChpbnNuICYgSU5T
Tl9NQVNLX1dGSSkgPT0gSU5TTl9NQVRDSF9XRkkpIHsKPiArCQl2Y3B1LT5zdGF0LndmaV9leGl0
X3N0YXQrKzsKPiArCQlpZiAoIWt2bV9hcmNoX3ZjcHVfcnVubmFibGUodmNwdSkpIHsKPiArCQkJ
c3JjdV9yZWFkX3VubG9jaygmdmNwdS0+a3ZtLT5zcmN1LCB2Y3B1LT5hcmNoLnNyY3VfaWR4KTsK
PiArCQkJa3ZtX3ZjcHVfYmxvY2sodmNwdSk7Cj4gKwkJCXZjcHUtPmFyY2guc3JjdV9pZHggPSBz
cmN1X3JlYWRfbG9jaygmdmNwdS0+a3ZtLT5zcmN1KTsKPiArCQkJa3ZtX2NsZWFyX3JlcXVlc3Qo
S1ZNX1JFUV9VTkhBTFQsIHZjcHUpOwo+ICsJCX0KPiArCQl2Y3B1LT5hcmNoLmd1ZXN0X2NvbnRl
eHQuc2VwYyArPSBJTlNOX0xFTihpbnNuKTsKPiArCQlyZXR1cm4gMTsKPiArCX0KPiArCj4gKwly
ZXR1cm4gdHJ1bHlfaWxsZWdhbF9pbnNuKHZjcHUsIHJ1biwgaW5zbik7Cj4gK30KPiArCj4gK3N0
YXRpYyBpbnQgaWxsZWdhbF9pbnN0X2ZhdWx0KHN0cnVjdCBrdm1fdmNwdSAqdmNwdSwgc3RydWN0
IGt2bV9ydW4gKnJ1biwKPiArCQkJICAgICAgdW5zaWduZWQgbG9uZyBpbnNuKQo+ICt7Cj4gKwl1
bnNpZ25lZCBsb25nIHV0X3NjYXVzZSA9IDA7Cj4gKwlzdHJ1Y3Qga3ZtX2NwdV9jb250ZXh0ICpj
dDsKPiArCj4gKwlpZiAodW5saWtlbHkoKGluc24gJiAzKSAhPSAzKSkgewoKV2hhdCBkbyB0aGUg
bG93IDIgYml0cyBtZWFuIGhlcmU/IE1heWJlIHlvdSBjYW4gdXNlIGEgZGVmaW5lIGluc3RlYWQ/
CgoKQWxleAoKCgoKQW1hem9uIERldmVsb3BtZW50IENlbnRlciBHZXJtYW55IEdtYkgKS3JhdXNl
bnN0ci4gMzgKMTAxMTcgQmVybGluCkdlc2NoYWVmdHNmdWVocnVuZzogQ2hyaXN0aWFuIFNjaGxh
ZWdlciwgUmFsZiBIZXJicmljaApFaW5nZXRyYWdlbiBhbSBBbXRzZ2VyaWNodCBDaGFybG90dGVu
YnVyZyB1bnRlciBIUkIgMTQ5MTczIEIKU2l0ejogQmVybGluClVzdC1JRDogREUgMjg5IDIzNyA4
NzkKCgo=

