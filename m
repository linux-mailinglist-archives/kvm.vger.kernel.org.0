Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FAFB3EF43D
	for <lists+kvm@lfdr.de>; Tue, 17 Aug 2021 22:51:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231787AbhHQUvm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Aug 2021 16:51:42 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:4614 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229531AbhHQUvm (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 17 Aug 2021 16:51:42 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17HKYodR003818;
        Tue, 17 Aug 2021 16:50:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=B104m2PI+epMBBjLUjsc3SB9fXJeWpwRwNIs73eCpak=;
 b=pFwEzqxZEy5wVbAo8N894f0wBAd/wZwMlI7mjibY/F/4p2Hubyy8WywE1QtKgIpYWV/E
 iS68eGo9sZ8zAb9t4OQ4iInDHvHDWCpVXQ/qVDoQg1xeKGpDvPu0pu0zNsUrmTpERdt3
 Jg5uIlT4CECcEef6DeuZV2oMamn9w7EcqHXqK13SenAgdjGNhqbLWWIFXgO0ctb3SuSE
 gtnoFUxnQYsRZudy1uXH3EMKZJY6fOfnHhDYCEIrPKyiIGkkBnuxOPHdypEDGKUjzPaW
 CONJlHFjou+OH3TqZHiOMpB+2C9NDKMYemqtNdBw/zGe/Fd7ZNvtOKNpZ4mTCJQxtDVr xw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3aeua1dquy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 17 Aug 2021 16:50:57 -0400
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 17HKZLer005645;
        Tue, 17 Aug 2021 16:50:57 -0400
Received: from ppma01wdc.us.ibm.com (fd.55.37a9.ip4.static.sl-reverse.com [169.55.85.253])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3aeua1dqu3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 17 Aug 2021 16:50:57 -0400
Received: from pps.filterd (ppma01wdc.us.ibm.com [127.0.0.1])
        by ppma01wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 17HKmCJx030408;
        Tue, 17 Aug 2021 20:50:55 GMT
Received: from b01cxnp22036.gho.pok.ibm.com (b01cxnp22036.gho.pok.ibm.com [9.57.198.26])
        by ppma01wdc.us.ibm.com with ESMTP id 3ae5fcd9m9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 17 Aug 2021 20:50:55 +0000
Received: from b01ledav004.gho.pok.ibm.com (b01ledav004.gho.pok.ibm.com [9.57.199.109])
        by b01cxnp22036.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 17HKosDb3473992
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 Aug 2021 20:50:54 GMT
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 89D72112067;
        Tue, 17 Aug 2021 20:50:54 +0000 (GMT)
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2885B112063;
        Tue, 17 Aug 2021 20:50:54 +0000 (GMT)
Received: from Tobins-MacBook-Pro-2.local (unknown [9.65.234.123])
        by b01ledav004.gho.pok.ibm.com (Postfix) with ESMTP;
        Tue, 17 Aug 2021 20:50:54 +0000 (GMT)
Subject: Re: [RFC PATCH 00/13] Add support for Mirror VM.
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Steve Rutherford <srutherford@google.com>,
        Ashish Kalra <Ashish.Kalra@amd.com>
Cc:     thomas.lendacky@amd.com, brijesh.singh@amd.com,
        ehabkost@redhat.com, kvm@vger.kernel.org, mst@redhat.com,
        tobin@ibm.com, jejb@linux.ibm.com, richard.henderson@linaro.org,
        qemu-devel@nongnu.org, dgilbert@redhat.com, frankeh@us.ibm.com,
        dovmurik@linux.vnet.ibm.com
References: <cover.1629118207.git.ashish.kalra@amd.com>
 <CABayD+fyrcyPGg5TdXLr95AFkPFY+EeeNvY=NvQw_j3_igOd6Q@mail.gmail.com>
 <0fcfafde-a690-f53a-01fc-542054948bb2@redhat.com>
From:   Tobin Feldman-Fitzthum <tobin@linux.ibm.com>
Message-ID: <37796fd1-bbc2-f22c-b786-eb44f4d473b9@linux.ibm.com>
Date:   Tue, 17 Aug 2021 16:50:53 -0400
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <0fcfafde-a690-f53a-01fc-542054948bb2@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: -eVd6COz8P1NJwxjpav9fMNNEB8kjAIF
X-Proofpoint-ORIG-GUID: 3x3mgxWH1-5y34FI0YQ3S8UeoumS0W9P
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-17_06:2021-08-17,2021-08-17 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015
 lowpriorityscore=0 impostorscore=0 adultscore=0 bulkscore=0 malwarescore=0
 priorityscore=1501 mlxlogscore=999 phishscore=0 spamscore=0 suspectscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2108170129
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 8/17/21 12:32 PM, Paolo Bonzini wrote:
> On 17/08/21 01:53, Steve Rutherford wrote:
>> Separately, I'm a little weary of leaving the migration helper mapped
>> into the shared address space as writable.
>
> A related question here is what the API should be for how the 
> migration helper sees the memory in both physical and virtual address.
>
> First of all, I would like the addresses passed to and from the 
> migration helper to *not* be guest physical addresses (this is what I 
> referred to as QEMU's ram_addr_t in other messages).  The reason is 
> that some unmapped memory regions, such as virtio-mem hotplugged 
> memory, would still have to be transferred and could be encrypted.  
> While the guest->host hypercall interface uses guest physical 
> addresses to communicate which pages are encrypted, the host can do 
> the GPA->ram_addr_t conversion and remember the encryption status of 
> currently-unmapped regions.
>
> This poses a problem, in that the guest needs to prepare the page 
> tables for the migration helper and those need to use the migration 
> helper's physical address space.
>
> There's three possibilities for this:
>
> 1) the easy one: the bottom 4G of guest memory are mapped in the 
> mirror VM 1:1.  The ram_addr_t-based addresses are shifted by either 
> 4G or a huge value such as 2^42 (MAXPHYADDR - physical address 
> reduction - 1). This even lets the migration helper reuse the OVMF 
> runtime services memory map (but be careful about thread safety...).

This is essentially what we do in our prototype, although we have an 
even simpler approach. We have a 1:1 mapping that maps an address to 
itself with the cbit set. During Migration QEMU asks the migration 
handler to import/export encrypted pages and provides the GPA for said 
page. Since the migration handler only exports/imports encrypted pages, 
we can have the cbit set for every page in our mapping. We can still use 
OVMF functions with these mappings because they are on encrypted pages. 
The MH does need to use a few shared pages (to communicate with QEMU, 
for instance), so we have another mapping without the cbit that is at a 
large offset.

I think this is basically equivalent to what you suggest. As you point 
out above, this approach does require that any page that will be 
exported/imported by the MH is mapped in the guest. Is this a bad 
assumption? The VMSA for SEV-ES is one example of a region that is 
encrypted but not mapped in the guest (the PSP handles it directly). We 
have been planning to map the VMSA into the guest to support migration 
with SEV-ES (along with other changes).

> 2) the more future-proof one.  Here, the migration helper tells QEMU 
> which area to copy from the guest to the mirror VM, as a (main GPA, 
> length, mirror GPA) tuple.  This could happen for example the first 
> time the guest writes 1 to MSR_KVM_MIGRATION_CONTROL.  When migration 
> starts, QEMU uses this information to issue KVM_SET_USER_MEMORY_REGION 
> accordingly.  The page tables are built for this (usually very high) 
> mirror GPA and the migration helper operates in a completely separate 
> address space.  However, the backing memory would still be shared 
> between the main and mirror VMs.  I am saying this is more future 
> proof because we have more flexibility in setting up the physical 
> address space of the mirror VM.

The Migration Handler in OVMF is not a contiguous region of memory. The 
MH uses OVMF helper functions that are allocated in various regions of 
runtime memory. I guess I can see how separating the memory of the MH 
and the guest OS could be positive. On the other hand, since the MH is 
in OVMF, it is fundamentally designed to coexist with the guest OS.

What do you envision in terms of future changes to the mirror address space?

> 3) the paranoid one, which I think is what you hint at above: this is 
> an extension of (2), where userspace invokes the PSP send/receive API 
> to copy the small requested area of the main VM into the mirror VM.  
> The mirror VM code and data are completely separate from the main VM.  
> All that the mirror VM shares is the ram_addr_t data. Though I am not 
> even sure it is possible to use the send/receive API this way...

Yeah not sure if you could use the PSP for this.

-Tobin

>
> What do you think?
>
> Paolo
>
>
