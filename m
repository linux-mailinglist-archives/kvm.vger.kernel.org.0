Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDBDE24178D
	for <lists+kvm@lfdr.de>; Tue, 11 Aug 2020 09:49:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728101AbgHKHtN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Aug 2020 03:49:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:51924 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728060AbgHKHtM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Aug 2020 03:49:12 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 07A87205CB;
        Tue, 11 Aug 2020 07:49:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597132150;
        bh=IUPcw48csQBeWPj+tDEVEv+3O8+8xdOT0GWWmV3xhXw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=p6JHJtSkOAuL9lUt8UMmNp2FiD+cO71u9hYD09Cqu9Klj1htM/inD+5+Tfs7CkEUY
         M8QhF+hGH0Y7EnehjjPZMoXWrkLP/77UNyPf1BI75ackInMB3a8SV+XFnriOHZ2aUL
         j5ygXxbHlSJ5/n4+yROoGpqyrrPymoy5wPBXhl8Y=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
        by disco-boy.misterjones.org with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1k5P1w-001EIN-8x; Tue, 11 Aug 2020 08:49:08 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Date:   Tue, 11 Aug 2020 08:49:08 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     Jingyi Wang <wangjingyi11@huawei.com>
Cc:     drjones@redhat.com, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, eric.auger@redhat.com,
        wanghaibin.wang@huawei.com, yuzenghui@huawei.com
Subject: Re: [kvm-unit-tests PATCH v3 00/10] arm/arm64: Add IPI/LPI/vtimer
 latency test
In-Reply-To: <54de9edf-3cca-f968-1ea8-027556b5f5ff@huawei.com>
References: <20200731074244.20432-1-wangjingyi11@huawei.com>
 <957a4657-7e17-b173-ea4d-10c29ab9e3cd@huawei.com>
 <0bd81d1da9040fce660af46763507ac2@kernel.org>
 <54de9edf-3cca-f968-1ea8-027556b5f5ff@huawei.com>
User-Agent: Roundcube Webmail/1.4.5
Message-ID: <b175763e4f4f08ecdae46e6e87b0bc81@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: wangjingyi11@huawei.com, drjones@redhat.com, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, eric.auger@redhat.com, wanghaibin.wang@huawei.com, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2020-08-11 02:48, Jingyi Wang wrote:
> Hi Marc,
> 
> On 8/5/2020 8:13 PM, Marc Zyngier wrote:
>> On 2020-08-05 12:54, Jingyi Wang wrote:
>>> Hi all,
>>> 
>>> Currently, kvm-unit-tests only support GICv3 vLPI injection. May I 
>>> ask
>>> is there any plan or suggestion on constructing irq bypass mechanism
>>> to test vLPI direct injection in kvm-unit-tests?
>> 
>> I'm not sure what you are asking for here. VLPIs are only delivered
>> from a HW device, and the offloading mechanism isn't visible from
>> userspace (you either have an enabled GICv4 implementation, or
>> you don't).
>> 
>> There are ways to *trigger* device MSIs from userspace and inject
>> them in a guest, but that's only a debug feature, which shouldn't
>> be enabled on a production system.
>> 
>>          M.
> 
> Sorry for the late reply.
> 
> As I mentioned before, we want to add vLPI direct injection test
> in KUT, meanwhile measure the latency of hardware vLPI injection.
> 
> Sure, vLPI is triggered by hardware. Since kernel supports sending
> ITS INT command in guest to trigger vLPI, I wonder if it is possible

So can the host.

> to add an extra interface to make a vLPI hardware-offload(just as
> kvm_vgic_v4_set_forwarding() does). If so, vgic_its_trigger_msi()
> can inject vLPI directly instead of using LR.

The interface exists, it is in debugfs. But it mandates that the
device exists. And no, I am not willing to add an extra KVM userspace
API for this.

The whole concept of injecting an INT to measure the performance
of GICv4 is slightly bonkers, actually. Most of the cost is paid
on the injection path (queuing a pair of command, waiting until
the ITS wakes up and generate the signal...).

What you really want to measure is the time from generation of
the LPI by a device until the guest acknowledges the interrupt
to the device itself. and this can only be implemented in the
device.

         M.
-- 
Jazz is not dead. It just smells funny...
