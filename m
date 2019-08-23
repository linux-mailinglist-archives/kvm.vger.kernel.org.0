Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 84F2E9A9AD
	for <lists+kvm@lfdr.de>; Fri, 23 Aug 2019 10:09:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388241AbfHWIJE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Aug 2019 04:09:04 -0400
Received: from smtp-fw-9102.amazon.com ([207.171.184.29]:2819 "EHLO
        smtp-fw-9102.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731543AbfHWIJE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 23 Aug 2019 04:09:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1566547743; x=1598083743;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=p8k+BwEXxcgqgLdTcHBDrzbBbly6hFrYYffkrNC6Kj0=;
  b=nItEzEUZ0LvYapOYyaIiVW79mGqYzro1mPhFZb52LEPqFSPT4gcWIoRu
   Q6aWHPffJhJ8lcpQJl6vROetnencCFfu+kzQc7fsOOht7kfvMq8LraMZq
   a1P1JapcFFYa4b2lhfqJFBS/fyf0yBrbHzP8BDAbK6WBJkZhq3QXY9sdK
   8=;
X-IronPort-AV: E=Sophos;i="5.64,420,1559520000"; 
   d="scan'208";a="696736472"
Received: from sea3-co-svc-lb6-vlan3.sea.amazon.com (HELO email-inbound-relay-1e-17c49630.us-east-1.amazon.com) ([10.47.22.38])
  by smtp-border-fw-out-9102.sea19.amazon.com with ESMTP; 23 Aug 2019 08:08:54 +0000
Received: from EX13MTAUWC001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan3.iad.amazon.com [10.40.159.166])
        by email-inbound-relay-1e-17c49630.us-east-1.amazon.com (Postfix) with ESMTPS id 607BBA0696;
        Fri, 23 Aug 2019 08:08:49 +0000 (UTC)
Received: from EX13D20UWC001.ant.amazon.com (10.43.162.244) by
 EX13MTAUWC001.ant.amazon.com (10.43.162.135) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Fri, 23 Aug 2019 08:08:48 +0000
Received: from 38f9d3867b82.ant.amazon.com (10.43.161.214) by
 EX13D20UWC001.ant.amazon.com (10.43.162.244) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Fri, 23 Aug 2019 08:08:44 +0000
Subject: Re: [PATCH v5 00/20] KVM RISC-V Support
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
References: <20190822084131.114764-1-anup.patel@wdc.com>
From:   Alexander Graf <graf@amazon.com>
Message-ID: <8a2a9ea6-5636-e79a-b041-580159e703b2@amazon.com>
Date:   Fri, 23 Aug 2019 10:08:42 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190822084131.114764-1-anup.patel@wdc.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.43.161.214]
X-ClientProxiedBy: EX13D17UWB002.ant.amazon.com (10.43.161.141) To
 EX13D20UWC001.ant.amazon.com (10.43.162.244)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 22.08.19 10:42, Anup Patel wrote:
> This series adds initial KVM RISC-V support. Currently, we are able to boot
> RISC-V 64bit Linux Guests with multiple VCPUs.
> 
> Few key aspects of KVM RISC-V added by this series are:
> 1. Minimal possible KVM world-switch which touches only GPRs and few CSRs.
> 2. Full Guest/VM switch is done via vcpu_get/vcpu_put infrastructure.
> 3. KVM ONE_REG interface for VCPU register access from user-space.
> 4. PLIC emulation is done in user-space. In-kernel PLIC emulation, will
>     be added in future.
> 5. Timer and IPI emuation is done in-kernel.
> 6. MMU notifiers supported.
> 7. FP lazy save/restore supported.
> 8. SBI v0.1 emulation for KVM Guest available.
> 
> Here's a brief TODO list which we will work upon after this series:
> 1. Handle trap from unpriv access in reading Guest instruction
> 2. Handle trap from unpriv access in SBI v0.1 emulation
> 3. Implement recursive stage2 page table programing
> 4. SBI v0.2 emulation in-kernel
> 5. SBI v0.2 hart hotplug emulation in-kernel
> 6. In-kernel PLIC emulation
> 7. ..... and more .....

Please consider patches I did not comment on as

Reviewed-by: Alexander Graf <graf@amazon.com>

Overall, I'm quite happy with the code. It's a very clean implementation 
of a KVM target.

The only major nit I have is the guest address space read: I don't think 
we should pull in code that we know allows user space to DOS the kernel. 
For that, we need to find an alternative. Either you implement a 
software page table walker and resolve VAs manually or you find a way to 
ensure that *any* exception taken during the read does not affect 
general code execution.


Thanks,

Alex
