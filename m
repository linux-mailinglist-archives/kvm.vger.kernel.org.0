Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BF97245FF5
	for <lists+kvm@lfdr.de>; Mon, 17 Aug 2020 10:27:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727879AbgHQI1c (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Aug 2020 04:27:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:48224 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726688AbgHQI0V (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Aug 2020 04:26:21 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A194E207FB;
        Mon, 17 Aug 2020 08:26:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597652780;
        bh=DqrhFlbqsLKUbQeyFxnK0Kuuu4I7hstm5T+jbg9Evrs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=z5HKSUqwTqfvkxm/ePqE7aOX/IGBddSo4Kyjs9A8hSnGpHylUuJGDOnFkjOlw/U9/
         KkOnC5r+iRVraYQqDayVeenJpwxRA/QR7yvL/ExiGB4i1R3UUqOiA505g8nDnqlgjz
         j4tbijNIWMeZjXw/IpTb/plWqL1YNjPdC6fGZRKM=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
        by disco-boy.misterjones.org with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1k7aTD-003UEx-7D; Mon, 17 Aug 2020 09:26:19 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Date:   Mon, 17 Aug 2020 09:26:19 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     Jingyi Wang <wangjingyi11@huawei.com>
Cc:     drjones@redhat.com, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, eric.auger@redhat.com,
        wanghaibin.wang@huawei.com, yuzenghui@huawei.com
Subject: Re: [kvm-unit-tests PATCH v3 00/10] arm/arm64: Add IPI/LPI/vtimer
 latency test
In-Reply-To: <d9aa5414-490e-179f-d789-3c929ffe0727@huawei.com>
References: <20200731074244.20432-1-wangjingyi11@huawei.com>
 <957a4657-7e17-b173-ea4d-10c29ab9e3cd@huawei.com>
 <0bd81d1da9040fce660af46763507ac2@kernel.org>
 <54de9edf-3cca-f968-1ea8-027556b5f5ff@huawei.com>
 <b175763e4f4f08ecdae46e6e87b0bc81@kernel.org>
 <d9aa5414-490e-179f-d789-3c929ffe0727@huawei.com>
User-Agent: Roundcube Webmail/1.4.7
Message-ID: <9d2dcee37f9c2509cb9556f74b6f5277@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: wangjingyi11@huawei.com, drjones@redhat.com, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, eric.auger@redhat.com, wanghaibin.wang@huawei.com, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2020-08-17 02:46, Jingyi Wang wrote:
> On 8/11/2020 3:49 PM, Marc Zyngier wrote:
>> On 2020-08-11 02:48, Jingyi Wang wrote:

[...]

>>> As I mentioned before, we want to add vLPI direct injection test
>>> in KUT, meanwhile measure the latency of hardware vLPI injection.
>>> 
>>> Sure, vLPI is triggered by hardware. Since kernel supports sending
>>> ITS INT command in guest to trigger vLPI, I wonder if it is possible
>> 
>> So can the host.
>> 
>>> to add an extra interface to make a vLPI hardware-offload(just as
>>> kvm_vgic_v4_set_forwarding() does). If so, vgic_its_trigger_msi()
>>> can inject vLPI directly instead of using LR.
>> 
>> The interface exists, it is in debugfs. But it mandates that the
>> device exists. And no, I am not willing to add an extra KVM userspace
>> API for this.
>> 
>> The whole concept of injecting an INT to measure the performance
>> of GICv4 is slightly bonkers, actually. Most of the cost is paid
>> on the injection path (queuing a pair of command, waiting until
>> the ITS wakes up and generate the signal...).
>> 
>> What you really want to measure is the time from generation of
>> the LPI by a device until the guest acknowledges the interrupt
>> to the device itself. and this can only be implemented in the
>> device.
>> 
>>          M.
> 
> OK understood. I just thought measuring the latency of the path
> kvm->guest can be useful.

That's the problem. There is no way you can implement this, because
you cannot distinguish injection latency from the delivery latency.
And frankly, it doesn't matter, because the hypervisor is not on
that path at all (if it is slow, that's because the HW is slow, and
you can't change anything in KVM to make it better).

On the other hand, measuring the latency of a guest being scheduled
back in when blocked on WFI would be much more relevant, as this is
exactly what would happen on delivery of a doorbell.

         M.
-- 
Jazz is not dead. It just smells funny...
