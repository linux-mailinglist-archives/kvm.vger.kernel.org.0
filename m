Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8220644471
	for <lists+kvm@lfdr.de>; Thu, 13 Jun 2019 18:37:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391723AbfFMQhA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Jun 2019 12:37:00 -0400
Received: from smtp-fw-2101.amazon.com ([72.21.196.25]:47255 "EHLO
        smtp-fw-2101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730670AbfFMHUt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Jun 2019 03:20:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1560410448; x=1591946448;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=dhmXrepDAZcjXkpQs5VfxOBzitc3aINuYRH8cXmOgbc=;
  b=GWhicdJzBpWeJdgTa7sgEYhPFV3t6Oyh9XsErtlfW76CtRRC5iZR+nBE
   qhghegzUiVbUo1ul+bNUu7mxZWUA9NvCdURG0rJdnAUqSNT07VRcDGlhI
   2herR7rcSnOTimoyXZNMNu7IB8pvKN/Cn7NeCeBwx+sNGjrYu48KEg2fq
   c=;
X-IronPort-AV: E=Sophos;i="5.62,368,1554768000"; 
   d="scan'208";a="737272759"
Received: from iad6-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-1a-7d76a15f.us-east-1.amazon.com) ([10.124.125.2])
  by smtp-border-fw-out-2101.iad2.amazon.com with ESMTP; 13 Jun 2019 07:20:46 +0000
Received: from EX13MTAUWC001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan2.iad.amazon.com [10.40.159.162])
        by email-inbound-relay-1a-7d76a15f.us-east-1.amazon.com (Postfix) with ESMTPS id 254ACA26DA;
        Thu, 13 Jun 2019 07:20:44 +0000 (UTC)
Received: from EX13D20UWC001.ant.amazon.com (10.43.162.244) by
 EX13MTAUWC001.ant.amazon.com (10.43.162.135) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Thu, 13 Jun 2019 07:20:43 +0000
Received: from 38f9d3867b82.ant.amazon.com (10.43.160.69) by
 EX13D20UWC001.ant.amazon.com (10.43.162.244) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Thu, 13 Jun 2019 07:20:41 +0000
Subject: Re: [RFC 00/10] Process-local memory allocations for hiding KVM
 secrets
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Marius Hillenbrand <mhillenb@amazon.de>
CC:     <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <kernel-hardening@lists.openwall.com>, <linux-mm@kvack.org>,
        Alexander Graf <graf@amazon.de>,
        David Woodhouse <dwmw@amazon.co.uk>
References: <20190612170834.14855-1-mhillenb@amazon.de>
 <20190612182550.GI20308@linux.intel.com>
From:   Alexander Graf <graf@amazon.com>
Message-ID: <7162182f-74e5-9be7-371d-48ee483206c2@amazon.com>
Date:   Thu, 13 Jun 2019 09:20:40 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190612182550.GI20308@linux.intel.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [10.43.160.69]
X-ClientProxiedBy: EX13D22UWC001.ant.amazon.com (10.43.162.192) To
 EX13D20UWC001.ant.amazon.com (10.43.162.244)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 12.06.19 20:25, Sean Christopherson wrote:
> On Wed, Jun 12, 2019 at 07:08:24PM +0200, Marius Hillenbrand wrote:
>> The Linux kernel has a global address space that is the same for any
>> kernel code. This address space becomes a liability in a world with
>> processor information leak vulnerabilities, such as L1TF. With the right
>> cache load gadget, an attacker-controlled hyperthread pair can leak
>> arbitrary data via L1TF. Disabling hyperthreading is one recommended
>> mitigation, but it comes with a large performance hit for a wide range
>> of workloads.
>>
>> An alternative mitigation is to not make certain data in the kernel
>> globally visible, but only when the kernel executes in the context of
>> the process where this data belongs to.
>>
>> This patch series proposes to introduce a region for what we call
>> process-local memory into the kernel's virtual address space. Page
>> tables and mappings in that region will be exclusive to one address
>> space, instead of implicitly shared between all kernel address spaces.
>> Any data placed in that region will be out of reach of cache load
>> gadgets that execute in different address spaces. To implement
>> process-local memory, we introduce a new interface kmalloc_proclocal() /
>> kfree_proclocal() that allocates and maps pages exclusively into the
>> current kernel address space. As a first use case, we move architectural
>> state of guest CPUs in KVM out of reach of other kernel address spaces.
> Can you briefly describe what types of attacks this is intended to
> mitigate?  E.g. guest-guest, userspace-guest, etc...  I don't want to
> make comments based on my potentially bad assumptions.


(quickly jumping in for Marius, he's offline today)

The main purpose of this is to protect from leakage of data from one 
guest into another guest using speculation gadgets on the host.

The same mechanism can be used to prevent leakage of secrets from one 
host process into another host process though, as host processes 
potentially have access to gadgets via the syscall interface.


Alex

