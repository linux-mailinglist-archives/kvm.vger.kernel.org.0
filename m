Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DBA32DD420
	for <lists+kvm@lfdr.de>; Thu, 17 Dec 2020 16:27:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728627AbgLQP0D (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Dec 2020 10:26:03 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:28110 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728414AbgLQP0C (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 17 Dec 2020 10:26:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1608218676;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wEHDWPFk5PgRzOKFAglEyJDjwX+jw51j9lBfgrdRfwk=;
        b=LbUm2VRgz2Yi36p33PO7S9h2rmxksyjAcEHt9TWYzelqf1nXXYO/11vkjyydoxmr2kVSt9
        3g+DuxqjvWq9V+6vEtHn37usz7OKmLQnkYunRSAQqCj25nPEpkGaZnHQAGlDcyEM/RVgSX
        MOo164shUpfFnnnH7qjiukbf9b6Y4O4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-518-tJ2-_SZVMTGLq5TSIKmbhg-1; Thu, 17 Dec 2020 10:24:34 -0500
X-MC-Unique: tJ2-_SZVMTGLq5TSIKmbhg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4866C190B2A6;
        Thu, 17 Dec 2020 15:24:33 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-112-175.ams2.redhat.com [10.36.112.175])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 26C7D60BE5;
        Thu, 17 Dec 2020 15:24:24 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH v3 3/8] s390x: SCLP feature checking
To:     Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     kvm@vger.kernel.org, david@redhat.com, borntraeger@de.ibm.com,
        cohuck@redhat.com, linux-s390@vger.kernel.org
References: <20201211100039.63597-1-frankja@linux.ibm.com>
 <20201211100039.63597-4-frankja@linux.ibm.com>
 <20201217131837.5946c853@ibm-vm>
 <14a2d6ab-7f9b-86cd-26ca-0c83385f62ca@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Message-ID: <646efe10-2f5b-a354-65a3-6358fd0dc6c6@redhat.com>
Date:   Thu, 17 Dec 2020 16:24:24 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <14a2d6ab-7f9b-86cd-26ca-0c83385f62ca@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 17/12/2020 16.21, Janosch Frank wrote:
> On 12/17/20 1:18 PM, Claudio Imbrenda wrote:
>> On Fri, 11 Dec 2020 05:00:34 -0500
>> Janosch Frank <frankja@linux.ibm.com> wrote:
>>
>>> Availability of SIE is announced via a feature bit in a SCLP info CPU
>>> entry. Let's add a framework that allows us to easily check for such
>>> facilities.
>>>
>>> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
>>> Reviewed-by: Thomas Huth <thuth@redhat.com>
>>> ---
>>>  lib/s390x/io.c   |  1 +
>>>  lib/s390x/sclp.c | 19 +++++++++++++++++++
>>>  lib/s390x/sclp.h | 13 ++++++++++++-
>>>  3 files changed, 32 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/lib/s390x/io.c b/lib/s390x/io.c
>>> index 6a1da63..ef9f59e 100644
>>> --- a/lib/s390x/io.c
>>> +++ b/lib/s390x/io.c
>>> @@ -35,6 +35,7 @@ void setup(void)
>>>  	setup_args_progname(ipl_args);
>>>  	setup_facilities();
>>>  	sclp_read_info();
>>> +	sclp_facilities_setup();
>>>  	sclp_console_setup();
>>>  	sclp_memory_setup();
>>>  	smp_setup();
>>> diff --git a/lib/s390x/sclp.c b/lib/s390x/sclp.c
>>> index bf1d9c0..cf6ea7c 100644
>>> --- a/lib/s390x/sclp.c
>>> +++ b/lib/s390x/sclp.c
>>> @@ -9,6 +9,7 @@
>>>   */
>>>  
>>>  #include <libcflat.h>
>>> +#include <bitops.h>
>>
>> you add this include, but it seems you are not actually using it?
> 
> Leftover from last version
> 
>>
>>>  #include <asm/page.h>
>>>  #include <asm/arch_def.h>
>>>  #include <asm/interrupt.h>
>>> @@ -25,6 +26,7 @@ static uint64_t max_ram_size;
>>>  static uint64_t ram_size;
>>>  char _read_info[PAGE_SIZE] __attribute__((__aligned__(4096)));
>>>  static ReadInfo *read_info;
>>> +struct sclp_facilities sclp_facilities;
>>>  
>>>  char _sccb[PAGE_SIZE] __attribute__((__aligned__(4096)));
>>>  static volatile bool sclp_busy;
>>> @@ -128,6 +130,23 @@ CPUEntry *sclp_get_cpu_entries(void)
>>>  	return (void *)read_info + read_info->offset_cpu;
>>>  }
>>>  
>>> +void sclp_facilities_setup(void)
>>> +{
>>> +	unsigned short cpu0_addr = stap();
>>> +	CPUEntry *cpu;
>>> +	int i;
>>> +
>>> +	assert(read_info);
>>> +
>>> +	cpu = (void *)read_info + read_info->offset_cpu;
>>
>> another void* arithmetic. consider using well-defined constructs, like
>>
>> cpu = (CPUEntry *)(_read_info + read_info->offset_cpu);
>>
>>> +	for (i = 0; i < read_info->entries_cpu; i++, cpu++) {
>>> +		if (cpu->address == cpu0_addr) {
>>> +			sclp_facilities.has_sief2 = cpu->feat_sief2;
>>> +			break;
>>
>> this only checks CPU 0. I wonder if you shouldn't check all CPUs? Or if
>> we assume that all CPUs have the same facilities, isn't it enough to
>> check the first CPU in the list? (i.e. avoid the loop)
> 
> This is the way.
> 
> Thomas already asked me that. I had a look what the kernel does and
> that's what they are doing. QEMU writes the same feature bits to all
> cpus and I haven't found an explanation for that code yet but I figured
> there might (have) be(en) one.

Well, if two people are asking, that's maybe a good indication that a
comment in the code would be a good idea? (even if it just references to the
kernel way of doing it?)

 Thomas

