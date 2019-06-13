Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 057B444469
	for <lists+kvm@lfdr.de>; Thu, 13 Jun 2019 18:37:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388604AbfFMQgs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Jun 2019 12:36:48 -0400
Received: from smtp-fw-9102.amazon.com ([207.171.184.29]:43469 "EHLO
        smtp-fw-9102.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727867AbfFMH1L (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Jun 2019 03:27:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1560410830; x=1591946830;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=Laetec4ccSCBOw8YMZruaBJ+PWt1iLta0CpWlGDAXuM=;
  b=VE7dlWqvkizytsOoyQdjqbF18715cizu2shKsjdMRQzNmJ1v+kEmlcu/
   EeSpgTGxzQFrPBwtqCRIcLQeLGQaW/5fU9ByzJzCP7nAyCzVNMrlWEoO5
   5mgf1aYdBaVzD8lMsiD8acc4pu/Q2oaZxZSqWKHKCijwxlIqeJDVdw7AI
   c=;
X-IronPort-AV: E=Sophos;i="5.62,368,1554768000"; 
   d="scan'208";a="679674698"
Received: from sea3-co-svc-lb6-vlan3.sea.amazon.com (HELO email-inbound-relay-1a-67b371d8.us-east-1.amazon.com) ([10.47.22.38])
  by smtp-border-fw-out-9102.sea19.amazon.com with ESMTP; 13 Jun 2019 07:27:07 +0000
Received: from EX13MTAUWC001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan3.iad.amazon.com [10.40.159.166])
        by email-inbound-relay-1a-67b371d8.us-east-1.amazon.com (Postfix) with ESMTPS id 66CC3A24B7;
        Thu, 13 Jun 2019 07:27:05 +0000 (UTC)
Received: from EX13D20UWC001.ant.amazon.com (10.43.162.244) by
 EX13MTAUWC001.ant.amazon.com (10.43.162.135) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Thu, 13 Jun 2019 07:27:04 +0000
Received: from 38f9d3867b82.ant.amazon.com (10.43.160.177) by
 EX13D20UWC001.ant.amazon.com (10.43.162.244) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Thu, 13 Jun 2019 07:27:02 +0000
Subject: Re: [RFC 00/10] Process-local memory allocations for hiding KVM
 secrets
To:     Dave Hansen <dave.hansen@intel.com>,
        Marius Hillenbrand <mhillenb@amazon.de>, <kvm@vger.kernel.org>
CC:     <linux-kernel@vger.kernel.org>,
        <kernel-hardening@lists.openwall.com>, <linux-mm@kvack.org>,
        Alexander Graf <graf@amazon.de>,
        David Woodhouse <dwmw@amazon.co.uk>,
        the arch/x86 maintainers <x86@kernel.org>,
        "Andy Lutomirski" <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
References: <20190612170834.14855-1-mhillenb@amazon.de>
 <eecc856f-7f3f-ed11-3457-ea832351e963@intel.com>
From:   Alexander Graf <graf@amazon.com>
Message-ID: <54a4d14c-b19b-339e-5a15-adb10297cb30@amazon.com>
Date:   Thu, 13 Jun 2019 09:27:00 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <eecc856f-7f3f-ed11-3457-ea832351e963@intel.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [10.43.160.177]
X-ClientProxiedBy: EX13D01UWA003.ant.amazon.com (10.43.160.107) To
 EX13D20UWC001.ant.amazon.com (10.43.162.244)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 12.06.19 21:55, Dave Hansen wrote:
> On 6/12/19 10:08 AM, Marius Hillenbrand wrote:
>> This patch series proposes to introduce a region for what we call
>> process-local memory into the kernel's virtual address space.
> It might be fun to cc some x86 folks on this series.  They might have
> some relevant opinions. ;)
>
> A few high-level questions:
>
> Why go to all this trouble to hide guest state like registers if all the
> guest data itself is still mapped?


(jumping in for Marius, he's offline today)

Glad you asked :). I hope this cover letter explains well how to achieve 
guest data not being mapped:

https://lkml.org/lkml/2019/1/31/933


> Where's the context-switching code?  Did I just miss it?


I'm not sure I understand the question. With this mechanism, the global 
linear map pages are just not present anymore, so there is no context 
switching needed. For the process local memory, the page table is 
already mm local, so we don't need to do anything special during context 
switch, no?


Alex

