Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 870A02FF9A9
	for <lists+kvm@lfdr.de>; Fri, 22 Jan 2021 02:00:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726013AbhAVA5K (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Jan 2021 19:57:10 -0500
Received: from mga04.intel.com ([192.55.52.120]:4381 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725827AbhAVA4q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Jan 2021 19:56:46 -0500
IronPort-SDR: EtUPYmJ7Mig7SBpAiGh9yQM7xzPB0r+8Dwz3ce800JY98C7RbAgSRLY1dwRRDIoHM2oDDekqV5
 7fRh+iSLroKw==
X-IronPort-AV: E=McAfee;i="6000,8403,9871"; a="176798323"
X-IronPort-AV: E=Sophos;i="5.79,365,1602572400"; 
   d="scan'208";a="176798323"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jan 2021 16:56:01 -0800
IronPort-SDR: b7CmkL0KyAbmS3MjocQJn6wOkYJUAm5buxc6jnqvBHz8yg9uy8PY8LPQLnehehTuvisco1zXES
 SsloD6twB44w==
X-IronPort-AV: E=Sophos;i="5.79,365,1602572400"; 
   d="scan'208";a="385547138"
Received: from cqiang-mobl.ccr.corp.intel.com (HELO [10.249.168.202]) ([10.249.168.202])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jan 2021 16:55:58 -0800
Subject: Re: [kvm-unit-tests PATCH v1 0/2] Fix smap and pku tests for new
 allocator
To:     David Matlack <dmatlack@google.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     kvm list <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Thomas Huth <thuth@redhat.com>, frankja@linux.ibm.com,
        cohuck@redhat.com, Laurent Vivier <lvivier@redhat.com>,
        nadav.amit@gmail.com, krish.sadhukhan@oracle.com, seanjc@google.com
References: <20210121111808.619347-1-imbrenda@linux.ibm.com>
 <CALzav=cDeL++8qdY2dJsbTmh+2z0hiAOeYk=NUqttEmKiPMvKw@mail.gmail.com>
From:   Chenyi Qiang <chenyi.qiang@intel.com>
Message-ID: <07d42693-2cce-3bea-be32-a433a7d0fad7@intel.com>
Date:   Fri, 22 Jan 2021 08:55:55 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <CALzav=cDeL++8qdY2dJsbTmh+2z0hiAOeYk=NUqttEmKiPMvKw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 1/22/2021 2:23 AM, David Matlack wrote:
> On Thu, Jan 21, 2021 at 3:18 AM Claudio Imbrenda <imbrenda@linux.ibm.com> wrote:
>>
>> The recent fixes to the page allocator broke the SMAP test.
>>
>> The reason is that the test blindly took a chunk of memory and used it,
>> hoping that the page allocator would not touch it.
>>
>> Unfortunately the memory area affected is exactly where the new
>> allocator puts the metadata information for the 16M-4G memory area.
>>
>> This causes the SMAP test to fail.
>>
>> The solution is to reserve the memory properly using the reserve_pages
>> function. To make things simpler, the memory area reserved is now
>> 8M-16M instead of 16M-32M.
>>
>> This issue was not found immediately, because the SMAP test needs
>> non-default qemu parameters in order not to be skipped.
>>
>> I tested the patch and it seems to work.
>>
>> While fixing the SMAP test, I also noticed that the PKU test was doing
>> the same thing, so I went ahead and fixed that test too in the same
>> way. Unfortunately I do not have the right hardware and therefore I
>> cannot test it.
>>
>>
>>
>> I would really appreciate if someone who has the right hardware could
>> test the PKU test and see if it works.
> 
> Thanks for identifying the PKU test as well. I can confirm it is also failing.
> 
> I tested out your patches on supported hardware and both the smap and
> pku tests passed.
> 
> chenyi.qiang@intel.com: FYI your in-progress PKS test looks like it
> will need the same fix.
> 
> 

Yeah, thank you for your reminder!

> 
>>
>>
>>
>>
>> Claudio Imbrenda (2):
>>    x86: smap: fix the test to work with new allocator
>>    x86: pku: fix the test to work with new allocator
>>
>>   x86/pku.c  | 5 ++++-
>>   x86/smap.c | 9 ++++++---
>>   2 files changed, 10 insertions(+), 4 deletions(-)
>>
>> --
>> 2.26.2
>>
