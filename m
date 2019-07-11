Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0D65D65442
	for <lists+kvm@lfdr.de>; Thu, 11 Jul 2019 11:59:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728312AbfGKJ7P (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Jul 2019 05:59:15 -0400
Received: from smtp-fw-33001.amazon.com ([207.171.190.10]:10054 "EHLO
        smtp-fw-33001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728295AbfGKJ7O (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 Jul 2019 05:59:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1562839154; x=1594375154;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=W+BY+BDHpadPTc6gpQ0QnhWpwEB27thoesZOWy03oIw=;
  b=nOUvVPeStvn0seGqfERbfs8TskcxJaQY7aL5LeKsIA65KUZa2/m1+Uy/
   r82I7NA3g7R7nBHgusm13gsCQPoeH8DtFTXtdAAO5naN6bNEtn8AnbKjC
   1uOdyNEdCv3jvrl3/eHjuhwcBO36wWZ79JBvUq0BqzCmPpGhJLSmjDzlH
   A=;
X-IronPort-AV: E=Sophos;i="5.62,478,1554768000"; 
   d="scan'208";a="810609096"
Received: from sea3-co-svc-lb6-vlan3.sea.amazon.com (HELO email-inbound-relay-2c-6f38efd9.us-west-2.amazon.com) ([10.47.22.38])
  by smtp-border-fw-out-33001.sea14.amazon.com with ESMTP; 11 Jul 2019 09:59:11 +0000
Received: from EX13MTAUWC001.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan3.pdx.amazon.com [10.170.41.166])
        by email-inbound-relay-2c-6f38efd9.us-west-2.amazon.com (Postfix) with ESMTPS id 66878A209B;
        Thu, 11 Jul 2019 09:59:11 +0000 (UTC)
Received: from EX13D20UWC001.ant.amazon.com (10.43.162.244) by
 EX13MTAUWC001.ant.amazon.com (10.43.162.135) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Thu, 11 Jul 2019 09:59:10 +0000
Received: from 38f9d3867b82.ant.amazon.com (10.43.161.30) by
 EX13D20UWC001.ant.amazon.com (10.43.162.244) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Thu, 11 Jul 2019 09:59:09 +0000
Subject: Re: [PATCH kvm-unit-tests] arm: Add PL031 test
To:     Andre Przywara <andre.przywara@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>
CC:     <kvm@vger.kernel.org>, Marc Zyngier <marc.zyngier@arm.com>,
        <kvmarm@lists.cs.columbia.edu>
References: <20190710132724.28350-1-graf@amazon.com>
 <20190710180235.25c54b84@donnerap.cambridge.arm.com>
 <35e19306-d31b-187b-185d-e783f8d5a51a@redhat.com>
 <1537a9f2-9d23-97dd-b195-8239b263d5db@amazon.com>
 <8c88eb2e-b401-42c7-f04f-2162f26af32c@redhat.com>
 <20190711104200.254073fb@donnerap.cambridge.arm.com>
From:   Alexander Graf <graf@amazon.com>
Message-ID: <e1ea413e-a809-2a42-3888-204d7c037ab3@amazon.com>
Date:   Thu, 11 Jul 2019 11:59:07 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190711104200.254073fb@donnerap.cambridge.arm.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.43.161.30]
X-ClientProxiedBy: EX13D07UWB001.ant.amazon.com (10.43.161.238) To
 EX13D20UWC001.ant.amazon.com (10.43.162.244)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 11.07.19 11:42, Andre Przywara wrote:
> On Thu, 11 Jul 2019 09:52:42 +0200
> Paolo Bonzini <pbonzini@redhat.com> wrote:
> 
> Hi,
> 
>> On 11/07/19 07:49, Alexander Graf wrote:
>>>> I agree that it would belong more in qtest, but tests in not exactly the
>>>> right place is better than no tests.
>>>
>>> The problem with qtest is that it tests QEMU device models from a QEMU
>>> internal view.
>>
>> Not really: fundamentally it tests QEMU device models with stimuli that
>> come from another process in the host, rather than code that runs in a
>> guest.  It does have hooks into QEMU's internal view (mostly to
>> intercept interrupts and advance the clocks), but the main feature of
>> the protocol is the ability to do memory reads and writes.
>>
>>> I am much more interested in the guest visible side of things. If
>>> kvmtool wanted to implement a PL031, it should be able to execute the
>>> same test that we run against QEMU, no?
> 
> One of the design goals of kvmtool is to get away with as little emulation
> as possible, in favour of paravirtualisation (so it's just virtio and not
> IDE/flash). So a hardware RTC emulation sounds dispensable in this context.

The main reason to have a PL031 exposed to a VM is to make OVMF happy, 
so that it can provide wall clock time runtime services. I suppose that 
sooner or later you may want to run OVMF in kvmtool as well, no?

The alternative to the PL031 here is to do a PV interface, yes. I'm not 
really convinced that that would be any easier though. The PL031 is a 
very trivial device. The only real downside is that it will wrap around 
in 2038.


Alex
