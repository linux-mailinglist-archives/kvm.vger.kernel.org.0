Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6A4D8BAE00
	for <lists+kvm@lfdr.de>; Mon, 23 Sep 2019 08:50:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393218AbfIWGuu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Sep 2019 02:50:50 -0400
Received: from smtp-fw-2101.amazon.com ([72.21.196.25]:30412 "EHLO
        smtp-fw-2101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2393160AbfIWGuu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Sep 2019 02:50:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1569221449; x=1600757449;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=66BxKyEsadOoOfbaqrGNVZTKJUAK251j6+K+EAtqSQE=;
  b=uYhnoC4cyZ9lbnrInynytpcX3ivXKzE/0SKTGFR8qqXMIG0vy93dnBS5
   c6Bl+JyLiXLBaGH8QIvtVFFk6iYXuzdYcMWARJl2rjVgO/9ELJQyLsxks
   +trfa5cSaJzWVz6N5dcByp6vKK+J2x6RqSOCj17FqR0ocDmaXy0n+8whw
   U=;
X-IronPort-AV: E=Sophos;i="5.64,539,1559520000"; 
   d="scan'208";a="752436814"
Received: from iad6-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-1d-474bcd9f.us-east-1.amazon.com) ([10.124.125.2])
  by smtp-border-fw-out-2101.iad2.amazon.com with ESMTP; 23 Sep 2019 06:50:46 +0000
Received: from EX13MTAUWC001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan2.iad.amazon.com [10.40.159.162])
        by email-inbound-relay-1d-474bcd9f.us-east-1.amazon.com (Postfix) with ESMTPS id 1C6D1A2423;
        Mon, 23 Sep 2019 06:50:41 +0000 (UTC)
Received: from EX13D20UWC001.ant.amazon.com (10.43.162.244) by
 EX13MTAUWC001.ant.amazon.com (10.43.162.135) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Mon, 23 Sep 2019 06:50:41 +0000
Received: from 38f9d3867b82.ant.amazon.com (10.43.161.217) by
 EX13D20UWC001.ant.amazon.com (10.43.162.244) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Mon, 23 Sep 2019 06:50:36 +0000
Subject: Re: [PATCH v7 10/21] RISC-V: KVM: Handle MMIO exits for VCPU
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
 <20190904161245.111924-12-anup.patel@wdc.com>
From:   Alexander Graf <graf@amazon.com>
Message-ID: <f5bf0227-5066-5fcc-55bd-9a3777826404@amazon.com>
Date:   Mon, 23 Sep 2019 08:50:27 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20190904161245.111924-12-anup.patel@wdc.com>
Content-Language: en-US
X-Originating-IP: [10.43.161.217]
X-ClientProxiedBy: EX13D29UWC001.ant.amazon.com (10.43.162.143) To
 EX13D20UWC001.ant.amazon.com (10.43.162.244)
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: base64
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

CgpPbiAwNC4wOS4xOSAxODoxNSwgQW51cCBQYXRlbCB3cm90ZToKPiBXZSB3aWxsIGdldCBzdGFn
ZTIgcGFnZSBmYXVsdHMgd2hlbmV2ZXIgR3Vlc3QvVk0gYWNjZXNzIFNXIGVtdWxhdGVkCj4gTU1J
TyBkZXZpY2Ugb3IgdW5tYXBwZWQgR3Vlc3QgUkFNLgo+IAo+IFRoaXMgcGF0Y2ggaW1wbGVtZW50
cyBNTUlPIHJlYWQvd3JpdGUgZW11bGF0aW9uIGJ5IGV4dHJhY3RpbmcgTU1JTwo+IGRldGFpbHMg
ZnJvbSB0aGUgdHJhcHBlZCBsb2FkL3N0b3JlIGluc3RydWN0aW9uIGFuZCBmb3J3YXJkaW5nIHRo
ZQo+IE1NSU8gcmVhZC93cml0ZSB0byB1c2VyLXNwYWNlLiBUaGUgYWN0dWFsIE1NSU8gZW11bGF0
aW9uIHdpbGwgaGFwcGVuCj4gaW4gdXNlci1zcGFjZSBhbmQgS1ZNIGtlcm5lbCBtb2R1bGUgd2ls
bCBvbmx5IHRha2UgY2FyZSBvZiByZWdpc3Rlcgo+IHVwZGF0ZXMgYmVmb3JlIHJlc3VtaW5nIHRo
ZSB0cmFwcGVkIFZDUFUuCj4gCj4gVGhlIGhhbmRsaW5nIGZvciBzdGFnZTIgcGFnZSBmYXVsdHMg
Zm9yIHVubWFwcGVkIEd1ZXN0IFJBTSB3aWxsIGJlCj4gaW1wbGVtZXRlZCBieSBhIHNlcGFyYXRl
IHBhdGNoIGxhdGVyLgo+IAo+IFNpZ25lZC1vZmYtYnk6IEFudXAgUGF0ZWwgPGFudXAucGF0ZWxA
d2RjLmNvbT4KPiBBY2tlZC1ieTogUGFvbG8gQm9uemluaSA8cGJvbnppbmlAcmVkaGF0LmNvbT4K
PiBSZXZpZXdlZC1ieTogUGFvbG8gQm9uemluaSA8cGJvbnppbmlAcmVkaGF0LmNvbT4KClRoaXMg
dmVyc2lvbiBpcyBpbmRlZWQgbXVjaCBiZXR0ZXIuIEkgd291bGQgbm90IG1pbmQgYSBiaXQgbW9y
ZSAKZG9jdW1lbnRhdGlvbiB3aGVuIGl0IGNvbWVzIHRvIGltcGxpY2l0IHJlZ2lzdGVyIHZhbHVl
IGFzc3VtcHRpb25zIChhMCwgCmExIGluIHRoZSB0cmFwIGhhbmRsZXIpLCBidXQgdGhlIGNvZGUg
aXMgc21hbGwgZW5vdWdoIHRoYXQgc29tZW9uZSB3aG8gCmNhcmVzIGNhbiBmaWd1cmUgaXQgb3V0
IHF1aWNrbHkgZW5vdWdoLgoKUmV2aWV3ZWQtYnk6IEFsZXhhbmRlciBHcmFmIDxncmFmQGFtYXpv
bi5jb20+CgoKQWxleAoKCgpBbWF6b24gRGV2ZWxvcG1lbnQgQ2VudGVyIEdlcm1hbnkgR21iSApL
cmF1c2Vuc3RyLiAzOAoxMDExNyBCZXJsaW4KR2VzY2hhZWZ0c2Z1ZWhydW5nOiBDaHJpc3RpYW4g
U2NobGFlZ2VyLCBSYWxmIEhlcmJyaWNoCkVpbmdldHJhZ2VuIGFtIEFtdHNnZXJpY2h0IENoYXJs
b3R0ZW5idXJnIHVudGVyIEhSQiAxNDkxNzMgQgpTaXR6OiBCZXJsaW4KVXN0LUlEOiBERSAyODkg
MjM3IDg3OQoKCg==

