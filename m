Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F344A20E33
	for <lists+kvm@lfdr.de>; Thu, 16 May 2019 19:49:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728105AbfEPRtN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 May 2019 13:49:13 -0400
Received: from smtp-fw-9102.amazon.com ([207.171.184.29]:50049 "EHLO
        smtp-fw-9102.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726441AbfEPRtM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 May 2019 13:49:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1558028951; x=1589564951;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=9nVrkLPFrKFzW5I8vXU9JV7oHZCN/SUECinSigxy+dM=;
  b=p7z8pf6l5SM6L73FjEss9AbW6394rhnt4c0LO3Xj8gflXVAHYnExujUc
   wORwvgp+AotEDFma/c0u3U8Ol8QblDW5GrCKu3pW656n2VwIUZdSzeRcZ
   yU9tqkaRhZ0Npxf69pKyoT+QkdM4FC2moU+saeglRI5zmHBz37fGe6/ft
   E=;
X-IronPort-AV: E=Sophos;i="5.60,477,1549929600"; 
   d="scan'208";a="674736306"
Received: from sea3-co-svc-lb6-vlan3.sea.amazon.com (HELO email-inbound-relay-2b-baacba05.us-west-2.amazon.com) ([10.47.22.38])
  by smtp-border-fw-out-9102.sea19.amazon.com with ESMTP/TLS/DHE-RSA-AES256-SHA; 16 May 2019 17:49:07 +0000
Received: from EX13MTAUWC001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-2b-baacba05.us-west-2.amazon.com (8.14.7/8.14.7) with ESMTP id x4GHn6De107439
        (version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=FAIL);
        Thu, 16 May 2019 17:49:07 GMT
Received: from EX13D20UWC001.ant.amazon.com (10.43.162.244) by
 EX13MTAUWC001.ant.amazon.com (10.43.162.135) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Thu, 16 May 2019 17:49:06 +0000
Received: from macbook-2.local (10.43.160.4) by EX13D20UWC001.ant.amazon.com
 (10.43.162.244) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Thu, 16 May
 2019 17:49:05 +0000
Subject: Re: [PATCH v2 2/2] KVM: x86: Implement the arch-specific hook to
 report the VM UUID
To:     "Sironi, Filippo" <sironi@amazon.de>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>
CC:     LKML <linux-kernel@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>,
        "vasu.srinivasan@oracle.com" <vasu.srinivasan@oracle.com>
References: <1539078879-4372-1-git-send-email-sironi@amazon.de>
 <1557847002-23519-1-git-send-email-sironi@amazon.de>
 <1557847002-23519-3-git-send-email-sironi@amazon.de>
 <f51a6a84-b21c-ab75-7e30-bfbe2ac6b98b@amazon.com>
 <7395EFE9-0B38-4B61-81D4-E8450561AABE@amazon.de>
 <8c6a2de2-f080-aad5-16af-c4a5eafb31af@amazon.com>
 <3a9762a2-24e8-a842-862d-fadae563361d@oracle.com>
 <DD0087B6-094D-4D07-9C85-827881E3DDD0@amazon.de>
From:   Alexander Graf <graf@amazon.com>
Message-ID: <cb50c8a6-58e7-e123-feb9-d9dd2bc33b34@amazon.com>
Date:   Thu, 16 May 2019 10:49:03 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <DD0087B6-094D-4D07-9C85-827881E3DDD0@amazon.de>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [10.43.160.4]
X-ClientProxiedBy: EX13D27UWB001.ant.amazon.com (10.43.161.169) To
 EX13D20UWC001.ant.amazon.com (10.43.162.244)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 16.05.19 10:41, Sironi, Filippo wrote:
>> On 16. May 2019, at 18:40, Boris Ostrovsky <boris.ostrovsky@oracle.com> wrote:
>>
>> On 5/16/19 11:33 AM, Alexander Graf wrote:
>>> On 16.05.19 08:25, Sironi, Filippo wrote:
>>>>> On 16. May 2019, at 15:56, Graf, Alexander <graf@amazon.com> wrote:
>>>>>
>>>>> On 14.05.19 08:16, Filippo Sironi wrote:
>>>>>> On x86, we report the UUID in DMI System Information (i.e., DMI Type 1)
>>>>>> as VM UUID.
>>>>>>
>>>>>> Signed-off-by: Filippo Sironi <sironi@amazon.de>
>>>>>> ---
>>>>>> arch/x86/kernel/kvm.c | 7 +++++++
>>>>>> 1 file changed, 7 insertions(+)
>>>>>>
>>>>>> diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
>>>>>> index 5c93a65ee1e5..441cab08a09d 100644
>>>>>> --- a/arch/x86/kernel/kvm.c
>>>>>> +++ b/arch/x86/kernel/kvm.c
>>>>>> @@ -25,6 +25,7 @@
>>>>>> #include <linux/kernel.h>
>>>>>> #include <linux/kvm_para.h>
>>>>>> #include <linux/cpu.h>
>>>>>> +#include <linux/dmi.h>
>>>>>> #include <linux/mm.h>
>>>>>> #include <linux/highmem.h>
>>>>>> #include <linux/hardirq.h>
>>>>>> @@ -694,6 +695,12 @@ bool kvm_para_available(void)
>>>>>> }
>>>>>> EXPORT_SYMBOL_GPL(kvm_para_available);
>>>>>>
>>>>>> +const char *kvm_para_get_uuid(void)
>>>>>> +{
>>>>>> +	return dmi_get_system_info(DMI_PRODUCT_UUID);
>>>>> This adds a new dependency on CONFIG_DMI. Probably best to guard it with
>>>>> an #if IS_ENABLED(CONFIG_DMI).
>>>>>
>>>>> The concept seems sound though.
>>>>>
>>>>> Alex
>>>> include/linux/dmi.h contains a dummy implementation of
>>>> dmi_get_system_info that returns NULL if CONFIG_DMI isn't defined.
>>> Oh, I missed that bit. Awesome! Less work :).
>>>
>>>
>>>> This is enough unless we decide to return "<denied>" like in Xen.
>>>> If then, we can have the check in the generic code to turn NULL
>>>> into "<denied>".
>>> Yes. Waiting for someone from Xen to answer this :)
>> Not sure I am answering your question but on Xen we return UUID value
>> zero if access permissions are not sufficient. Not <denied>.
>>
>> http://xenbits.xen.org/gitweb/?p=xen.git;a=blob;f=xen/common/kernel.c;h=612575430f1ce7faf5bd66e7a99f1758c63fb3cb;hb=HEAD#l506
>>
>> -boris
> Then, I believe that returning 00000000-0000-0000-0000-000000000000
> instead of NULL in the weak implementation of 1/2 and translating
> NULL into 00000000-0000-0000-0000-000000000000 is the better approach.


Just keep it at NULL in kvm_para_get_uuid() and convert to the canonical
00000000-0000-0000-0000-000000000000 in uuid_show().

Alex

