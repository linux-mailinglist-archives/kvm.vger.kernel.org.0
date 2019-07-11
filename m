Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D5E13651A6
	for <lists+kvm@lfdr.de>; Thu, 11 Jul 2019 07:49:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727831AbfGKFty (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Jul 2019 01:49:54 -0400
Received: from smtp-fw-9102.amazon.com ([207.171.184.29]:23347 "EHLO
        smtp-fw-9102.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727248AbfGKFty (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 Jul 2019 01:49:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1562824193; x=1594360193;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=wHeGT4hyzwEYhrwtHzWbpeS08ZRBQe5s5SLIUut76AM=;
  b=iqGY9Nj8RrwnFqcs4iZwohZpFVlWyeX4wUs8FfqVThnqFRLcuEynRGEM
   uhtpWj5TjXVziz2TwibTTtNLnEg2LR1zrozqbmAE/bTGJ+0fCc+Zj5PCb
   I9/G8Owa6ug/9JOrLEYtdGeQP4/sK7FwFCAXMk3KcPdKGPGPyQEsm4Jue
   g=;
X-IronPort-AV: E=Sophos;i="5.62,476,1554768000"; 
   d="scan'208";a="684877205"
Received: from sea3-co-svc-lb6-vlan2.sea.amazon.com (HELO email-inbound-relay-1e-62350142.us-east-1.amazon.com) ([10.47.22.34])
  by smtp-border-fw-out-9102.sea19.amazon.com with ESMTP; 11 Jul 2019 05:49:51 +0000
Received: from EX13MTAUWC001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan3.iad.amazon.com [10.40.159.166])
        by email-inbound-relay-1e-62350142.us-east-1.amazon.com (Postfix) with ESMTPS id EBF12A2402;
        Thu, 11 Jul 2019 05:49:49 +0000 (UTC)
Received: from EX13D20UWC001.ant.amazon.com (10.43.162.244) by
 EX13MTAUWC001.ant.amazon.com (10.43.162.135) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Thu, 11 Jul 2019 05:49:49 +0000
Received: from 38f9d3867b82.ant.amazon.com (10.43.162.144) by
 EX13D20UWC001.ant.amazon.com (10.43.162.244) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Thu, 11 Jul 2019 05:49:47 +0000
Subject: Re: [PATCH kvm-unit-tests] arm: Add PL031 test
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Andre Przywara <andre.przywara@arm.com>
CC:     <kvm@vger.kernel.org>, Marc Zyngier <marc.zyngier@arm.com>,
        <kvmarm@lists.cs.columbia.edu>
References: <20190710132724.28350-1-graf@amazon.com>
 <20190710180235.25c54b84@donnerap.cambridge.arm.com>
 <35e19306-d31b-187b-185d-e783f8d5a51a@redhat.com>
From:   Alexander Graf <graf@amazon.com>
Message-ID: <1537a9f2-9d23-97dd-b195-8239b263d5db@amazon.com>
Date:   Thu, 11 Jul 2019 07:49:45 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <35e19306-d31b-187b-185d-e783f8d5a51a@redhat.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.43.162.144]
X-ClientProxiedBy: EX13D19UWC002.ant.amazon.com (10.43.162.179) To
 EX13D20UWC001.ant.amazon.com (10.43.162.244)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 10.07.19 19:06, Paolo Bonzini wrote:
> On 10/07/19 19:02, Andre Przywara wrote:
>>> + * This test verifies whether the emulated PL031 behaves
>>> correctly.
>> ^^^^^^^^
>>
>> While I appreciate the effort and like the fact that this actually
>> triggers an SPI, I wonder if this actually belongs into
>> kvm-unit-tests. After all this just test a device purely emulated in
>> (QEMU) userland, so it's not really KVM related.
>>
>> What is the general opinion on this? Don't we care about this
>> hair-splitting as long as it helps testing? Do we even want to extend
>> kvm-unit-tests coverage to more emulated devices, for instance
>> virtio?
> 
> I agree that it would belong more in qtest, but tests in not exactly the
> right place is better than no tests.

The problem with qtest is that it tests QEMU device models from a QEMU 
internal view.

I am much more interested in the guest visible side of things. If 
kvmtool wanted to implement a PL031, it should be able to execute the 
same test that we run against QEMU, no?

If kvm-unit-test is the wrong place for it, we would probably want to 
have a separate testing framework for guest side unit tests targeting 
emulated devices.

Given how nice the kvm-unit-test framework is though, I'd rather rename 
it to "virt-unit-test" than reinvent the wheel :).


Alex
