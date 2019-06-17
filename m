Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 53BDD47B42
	for <lists+kvm@lfdr.de>; Mon, 17 Jun 2019 09:38:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727333AbfFQHiO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Jun 2019 03:38:14 -0400
Received: from smtp-fw-2101.amazon.com ([72.21.196.25]:17391 "EHLO
        smtp-fw-2101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725826AbfFQHiO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Jun 2019 03:38:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1560757091; x=1592293091;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=8xZP6BRYVHqRBD1v3aCylovGhFA01FEft+IhJzUopnA=;
  b=lU0A/K514EP44LlSbe7+gAvDPtiOstqo0LpUj+nsacdnconLiACx9kTw
   eEJWABrBVCs6WKnRLtbqL40F8UG7SZxepHUItn1WHzLolesXSb+0g7L7t
   TLozrtFQNGmrF+R8mNqUmlOaEDLmQ+H2hD2CseAUNBRXNguRMYNfyoZ+A
   U=;
X-IronPort-AV: E=Sophos;i="5.62,384,1554768000"; 
   d="scan'208";a="737725018"
Received: from iad6-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-1a-67b371d8.us-east-1.amazon.com) ([10.124.125.2])
  by smtp-border-fw-out-2101.iad2.amazon.com with ESMTP; 17 Jun 2019 07:38:09 +0000
Received: from EX13MTAUWC001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan3.iad.amazon.com [10.40.159.166])
        by email-inbound-relay-1a-67b371d8.us-east-1.amazon.com (Postfix) with ESMTPS id 11569A2B0B;
        Mon, 17 Jun 2019 07:38:07 +0000 (UTC)
Received: from EX13D20UWC001.ant.amazon.com (10.43.162.244) by
 EX13MTAUWC001.ant.amazon.com (10.43.162.135) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Mon, 17 Jun 2019 07:38:07 +0000
Received: from 38f9d3867b82.ant.amazon.com (10.43.160.69) by
 EX13D20UWC001.ant.amazon.com (10.43.162.244) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Mon, 17 Jun 2019 07:38:04 +0000
Subject: Re: [RFC 00/10] Process-local memory allocations for hiding KVM
 secrets
To:     Thomas Gleixner <tglx@linutronix.de>,
        Andy Lutomirski <luto@amacapital.net>
CC:     Dave Hansen <dave.hansen@intel.com>,
        Marius Hillenbrand <mhillenb@amazon.de>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        <kernel-hardening@lists.openwall.com>, <linux-mm@kvack.org>,
        Alexander Graf <graf@amazon.de>,
        David Woodhouse <dwmw@amazon.co.uk>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        Andy Lutomirski <luto@kernel.org>,
        "Peter Zijlstra" <peterz@infradead.org>
References: <20190612170834.14855-1-mhillenb@amazon.de>
 <eecc856f-7f3f-ed11-3457-ea832351e963@intel.com>
 <A542C98B-486C-4849-9DAC-2355F0F89A20@amacapital.net>
 <alpine.DEB.2.21.1906141618000.1722@nanos.tec.linutronix.de>
From:   Alexander Graf <graf@amazon.com>
Message-ID: <58788f05-04c3-e71c-12c3-0123be55012c@amazon.com>
Date:   Mon, 17 Jun 2019 09:38:00 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.21.1906141618000.1722@nanos.tec.linutronix.de>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Originating-IP: [10.43.160.69]
X-ClientProxiedBy: EX13D20UWC004.ant.amazon.com (10.43.162.41) To
 EX13D20UWC001.ant.amazon.com (10.43.162.244)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 14.06.19 16:21, Thomas Gleixner wrote:
> On Wed, 12 Jun 2019, Andy Lutomirski wrote:
>>> On Jun 12, 2019, at 12:55 PM, Dave Hansen <dave.hansen@intel.com> wrote:
>>>
>>>> On 6/12/19 10:08 AM, Marius Hillenbrand wrote:
>>>> This patch series proposes to introduce a region for what we call
>>>> process-local memory into the kernel's virtual address space.
>>> It might be fun to cc some x86 folks on this series.  They might have
>>> some relevant opinions. ;)
>>>
>>> A few high-level questions:
>>>
>>> Why go to all this trouble to hide guest state like registers if all the
>>> guest data itself is still mapped?
>>>
>>> Where's the context-switching code?  Did I just miss it?
>>>
>>> We've discussed having per-cpu page tables where a given PGD is only in
>>> use from one CPU at a time.  I *think* this scheme still works in such a
>>> case, it just adds one more PGD entry that would have to context-switched.
>> Fair warning: Linus is on record as absolutely hating this idea. He might
>> change his mind, but it’s an uphill battle.
> Yes I know, but as a benefit we could get rid of all the GSBASE horrors in
> the entry code as we could just put the percpu space into the local PGD.


Would that mean that with Meltdown affected CPUs we open speculation 
attacks against the mmlocal memory from KVM user space?


Alex

