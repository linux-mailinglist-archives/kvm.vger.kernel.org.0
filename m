Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4C59A1C707
	for <lists+kvm@lfdr.de>; Tue, 14 May 2019 12:29:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726412AbfENK3a (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 May 2019 06:29:30 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:33884 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726036AbfENK3a (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 May 2019 06:29:30 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4EAOCF4162648;
        Tue, 14 May 2019 10:26:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : references : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=HyoEJG6NjsyHsNKNQwL239w7XdNZ36sL7RhVidoBH+Y=;
 b=eZGNKozFDNYKTFY2RTWJ35YGfn3mhjEA8HHUXglMJawyb8sst0F7BP0/4Tqo8wyOl/Zl
 c984f8fM9ND92GrFfsqMa0Ekw3FYrxj9nyaI6XB/ijWegKO7CEuHzv/bEDXWjbKVyHtB
 aP6vteMS5DEMIeUb1zbdHhC1a9NWZOEQWAd2ZsDebp00Li4T5WyeXFvyS8a6FIj9uYBg
 IyFKQeacv8bVjNGoYSzwd6LMyAHhggvTMnVuBy7xcd1xGRc3WmKn8UoQFkKIG7NF+vmK
 NwQN3wj7rJzV9JSEieX+QQ5xD2mZUQoMxeQ4Xcn23Lp/CvNFBG6uQZpIc8/pqjiWzQb0 YQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2sdq1qcubw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 May 2019 10:26:50 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4EAPYwj130365;
        Tue, 14 May 2019 10:26:50 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 2se0tw2na5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 May 2019 10:26:50 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x4EAQlqh024795;
        Tue, 14 May 2019 10:26:47 GMT
Received: from [10.166.106.34] (/10.166.106.34)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 14 May 2019 03:26:47 -0700
Subject: Re: [RFC KVM 19/27] kvm/isolation: initialize the KVM page table with
 core mappings
From:   Alexandre Chartre <alexandre.chartre@oracle.com>
To:     Dave Hansen <dave.hansen@intel.com>, pbonzini@redhat.com,
        rkrcmar@redhat.com, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, hpa@zytor.com, dave.hansen@linux.intel.com,
        luto@kernel.org, peterz@infradead.org, kvm@vger.kernel.org,
        x86@kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Cc:     konrad.wilk@oracle.com, jan.setjeeilers@oracle.com,
        liran.alon@oracle.com, jwadams@google.com
References: <1557758315-12667-1-git-send-email-alexandre.chartre@oracle.com>
 <1557758315-12667-20-git-send-email-alexandre.chartre@oracle.com>
 <a9198e28-abe1-b980-597e-2d82273a2c17@intel.com>
 <463b86c8-e9a0-fc13-efa4-31df3aea8e54@oracle.com>
Organization: Oracle Corporation
Message-ID: <daace7ff-e85c-442d-a53e-6e08c5fb8385@oracle.com>
Date:   Tue, 14 May 2019 12:26:43 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.0
MIME-Version: 1.0
In-Reply-To: <463b86c8-e9a0-fc13-efa4-31df3aea8e54@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9256 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1905140076
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9256 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1905140076
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 5/13/19 6:47 PM, Alexandre Chartre wrote:
> 
> 
> On 5/13/19 5:50 PM, Dave Hansen wrote:
>>> +    /*
>>> +     * Copy the mapping for all the kernel text. We copy at the PMD
>>> +     * level since the PUD is shared with the module mapping space.
>>> +     */
>>> +    rv = kvm_copy_mapping((void *)__START_KERNEL_map, KERNEL_IMAGE_SIZE,
>>> +         PGT_LEVEL_PMD);
>>> +    if (rv)
>>> +        goto out_uninit_page_table;
>>
>> Could you double-check this?  We (I) have had some repeated confusion
>> with the PTI code and kernel text vs. kernel data vs. __init.
>> KERNEL_IMAGE_SIZE looks to be 512MB which is quite a bit bigger than
>> kernel text.
> 
> I probably have the same confusion :-) but I will try to check again.
> 
> 

mm.txt says that kernel text is 512MB, and that's probably why I used
KERNEL_IMAGE_SIZE.

https://www.kernel.org/doc/Documentation/x86/x86_64/mm.txt

========================================================================================================================
     Start addr    |   Offset   |     End addr     |  Size   | VM area description
========================================================================================================================
  [...]
  ffffffff80000000 |   -2    GB | ffffffff9fffffff |  512 MB | kernel text mapping, mapped to physical address 0
  [...]


However, vmlinux.lds.S does:

. = ASSERT((_end - _text <= KERNEL_IMAGE_SIZE),
            "kernel image bigger than KERNEL_IMAGE_SIZE");

So this covers everything between _text and _end, which includes text, data,
init and other stuff

The end of the text section is tagged with _etext. So the text section is
effectively (_etext - _text). This matches with what efi_setup_page_tables()
used to copy kernel text:

int __init efi_setup_page_tables(unsigned long pa_memmap, unsigned num_pages)
{
	[...]
         npages = (_etext - _text) >> PAGE_SHIFT;
         text = __pa(_text);
         pfn = text >> PAGE_SHIFT;

         pf = _PAGE_RW | _PAGE_ENC;
         if (kernel_map_pages_in_pgd(pgd, pfn, text, npages, pf)) {
                 pr_err("Failed to map kernel text 1:1\n");
                 return 1;
         }
	[...]
}


alex.
