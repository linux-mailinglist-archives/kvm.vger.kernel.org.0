Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2233ABADF7
	for <lists+kvm@lfdr.de>; Mon, 23 Sep 2019 08:44:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392344AbfIWGoi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Sep 2019 02:44:38 -0400
Received: from smtp-fw-6001.amazon.com ([52.95.48.154]:26653 "EHLO
        smtp-fw-6001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389082AbfIWGoh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Sep 2019 02:44:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1569221076; x=1600757076;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=RgSUTh1W/pPjW8MoN9jzPoRAZYLQRC12Kn961QLA8zA=;
  b=u7+3OuhtCMoFA19TtAD/1vEuFVraI2lkHLGG5SgjDj1PChGXOuhFxCzp
   l11rIj+PcJOoHSwc45NxvEDSO0U/Z+cKTkNr9E2XMjhbAtabk6f/tOsPv
   FFKCA0TygoURNmUXUAEDIvHIvxCbuRqAUkgscjqcQGdcwc5ggnGIRviwS
   s=;
X-IronPort-AV: E=Sophos;i="5.64,539,1559520000"; 
   d="scan'208";a="416897595"
Received: from iad6-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-1d-74cf8b49.us-east-1.amazon.com) ([10.124.125.6])
  by smtp-border-fw-out-6001.iad6.amazon.com with ESMTP; 23 Sep 2019 06:44:35 +0000
Received: from EX13MTAUWC001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan2.iad.amazon.com [10.40.159.162])
        by email-inbound-relay-1d-74cf8b49.us-east-1.amazon.com (Postfix) with ESMTPS id EC80DC0C6A;
        Mon, 23 Sep 2019 06:44:30 +0000 (UTC)
Received: from EX13D20UWC001.ant.amazon.com (10.43.162.244) by
 EX13MTAUWC001.ant.amazon.com (10.43.162.135) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Mon, 23 Sep 2019 06:44:30 +0000
Received: from 38f9d3867b82.ant.amazon.com (10.43.162.74) by
 EX13D20UWC001.ant.amazon.com (10.43.162.244) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Mon, 23 Sep 2019 06:44:25 +0000
Subject: Re: [PATCH v7 06/21] RISC-V: KVM: Implement VCPU create, init and
 destroy functions
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
 <20190904161245.111924-8-anup.patel@wdc.com>
From:   Alexander Graf <graf@amazon.com>
Message-ID: <520eed26-9332-1519-44b1-fb08b6410116@amazon.com>
Date:   Mon, 23 Sep 2019 08:44:22 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20190904161245.111924-8-anup.patel@wdc.com>
Content-Language: en-US
X-Originating-IP: [10.43.162.74]
X-ClientProxiedBy: EX13D29UWA004.ant.amazon.com (10.43.160.33) To
 EX13D20UWC001.ant.amazon.com (10.43.162.244)
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: base64
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

CgpPbiAwNC4wOS4xOSAxODoxNCwgQW51cCBQYXRlbCB3cm90ZToKPiBUaGlzIHBhdGNoIGltcGxl
bWVudHMgVkNQVSBjcmVhdGUsIGluaXQgYW5kIGRlc3Ryb3kgZnVuY3Rpb25zCj4gcmVxdWlyZWQg
YnkgZ2VuZXJpYyBLVk0gbW9kdWxlLiBXZSBkb24ndCBoYXZlIG11Y2ggZHluYW1pYwo+IHJlc291
cmNlcyBpbiBzdHJ1Y3Qga3ZtX3ZjcHVfYXJjaCBzbyB0aGVzdCBmdW5jdGlvbnMgYXJlIHF1aXRl
CgpTaW5jZSB5b3UncmUgcmVzcGlubmluZyBmb3IgdjggYW55d2F5LCBwbGVhc2Ugcy90aGVzdC90
aGVzZS8gOikKCkFsZXgKCgoKCkFtYXpvbiBEZXZlbG9wbWVudCBDZW50ZXIgR2VybWFueSBHbWJI
CktyYXVzZW5zdHIuIDM4CjEwMTE3IEJlcmxpbgpHZXNjaGFlZnRzZnVlaHJ1bmc6IENocmlzdGlh
biBTY2hsYWVnZXIsIFJhbGYgSGVyYnJpY2gKRWluZ2V0cmFnZW4gYW0gQW10c2dlcmljaHQgQ2hh
cmxvdHRlbmJ1cmcgdW50ZXIgSFJCIDE0OTE3MyBCClNpdHo6IEJlcmxpbgpVc3QtSUQ6IERFIDI4
OSAyMzcgODc5CgoK

