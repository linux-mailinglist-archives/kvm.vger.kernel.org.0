Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A1F82D5F99
	for <lists+kvm@lfdr.de>; Thu, 10 Dec 2020 16:27:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391546AbgLJP1Q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Dec 2020 10:27:16 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:47956 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2390483AbgLJP1L (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 10 Dec 2020 10:27:11 -0500
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0BAFNNEe105068;
        Thu, 10 Dec 2020 10:26:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=8TuZ966qA9ZNiuC4VMviYgJgs5x/qiXSkeaAgDKBwBw=;
 b=VNvTVj9UDden97tAVM74cQKismSDWEcwk2rtQjwQdxf7z7ttR2wSzVk/gg2+9UWY+dkx
 X9te0gOuZGOaCeOSmdTxz6Mr5ZAzk0sGyjU50czJsOU2owZx0Q9Vb6Uv5rAFfzS7fW1c
 ciYchuAjtgMdgA1baHFIEcZRjZ4KhIC5d9L788snlQVYxRq8BzEcxtY0HKA8N+Cz014J
 YUMrpZfI28840tfKW/zLaIifCnEPdr75TtiEEzuyjNknXR7Wm8XFMyixqQYhZ3xJuW/H
 jie4GIZLCUZl1Ndmgnsg+fBA76X5JHc4dHJMyX6wQo1kvjDTHh9+RK61mEme3pp3xq/6 YQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 35bp4jgea4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 10 Dec 2020 10:26:29 -0500
Received: from m0098413.ppops.net (m0098413.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0BAFO5Ha108304;
        Thu, 10 Dec 2020 10:26:29 -0500
Received: from ppma03wdc.us.ibm.com (ba.79.3fa9.ip4.static.sl-reverse.com [169.63.121.186])
        by mx0b-001b2d01.pphosted.com with ESMTP id 35bp4jge9d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 10 Dec 2020 10:26:28 -0500
Received: from pps.filterd (ppma03wdc.us.ibm.com [127.0.0.1])
        by ppma03wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0BAFHiOM010965;
        Thu, 10 Dec 2020 15:26:28 GMT
Received: from b03cxnp08026.gho.boulder.ibm.com (b03cxnp08026.gho.boulder.ibm.com [9.17.130.18])
        by ppma03wdc.us.ibm.com with ESMTP id 3581u9gj97-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 10 Dec 2020 15:26:28 +0000
Received: from b03ledav001.gho.boulder.ibm.com (b03ledav001.gho.boulder.ibm.com [9.17.130.232])
        by b03cxnp08026.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0BAFQPJk22216994
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 10 Dec 2020 15:26:25 GMT
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 010ED6E06C;
        Thu, 10 Dec 2020 15:26:25 +0000 (GMT)
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E17906E04C;
        Thu, 10 Dec 2020 15:26:23 +0000 (GMT)
Received: from oc4221205838.ibm.com (unknown [9.163.37.122])
        by b03ledav001.gho.boulder.ibm.com (Postfix) with ESMTP;
        Thu, 10 Dec 2020 15:26:23 +0000 (GMT)
Subject: Re: [RFC 1/4] s390/pci: track alignment/length strictness for
 zpci_dev
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     alex.williamson@redhat.com, schnelle@linux.ibm.com,
        pmorel@linux.ibm.com, borntraeger@de.ibm.com, hca@linux.ibm.com,
        gor@linux.ibm.com, gerald.schaefer@linux.ibm.com,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1607545670-1557-1-git-send-email-mjrosato@linux.ibm.com>
 <1607545670-1557-2-git-send-email-mjrosato@linux.ibm.com>
 <20201210113318.136636e2.cohuck@redhat.com>
From:   Matthew Rosato <mjrosato@linux.ibm.com>
Message-ID: <15132f7f-cad7-d663-a8b9-90f417e85c81@linux.ibm.com>
Date:   Thu, 10 Dec 2020 10:26:22 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201210113318.136636e2.cohuck@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-10_06:2020-12-09,2020-12-10 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 malwarescore=0
 spamscore=0 lowpriorityscore=0 clxscore=1015 impostorscore=0
 suspectscore=0 bulkscore=0 mlxlogscore=999 priorityscore=1501 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012100092
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/10/20 5:33 AM, Cornelia Huck wrote:
> On Wed,  9 Dec 2020 15:27:47 -0500
> Matthew Rosato <mjrosato@linux.ibm.com> wrote:
> 
>> Some zpci device types (e.g., ISM) follow different rules for length
>> and alignment of pci instructions.  Recognize this and keep track of
>> it in the zpci_dev.
>>
>> Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
>> Reviewed-by: Niklas Schnelle <schnelle@linux.ibm.com>
>> Reviewed-by: Pierre Morel <pmorel@linux.ibm.com>
>> ---
>>   arch/s390/include/asm/pci.h     | 3 ++-
>>   arch/s390/include/asm/pci_clp.h | 4 +++-
>>   arch/s390/pci/pci_clp.c         | 1 +
>>   3 files changed, 6 insertions(+), 2 deletions(-)
>>
>> diff --git a/arch/s390/include/asm/pci.h b/arch/s390/include/asm/pci.h
>> index 2126289..f16ffba 100644
>> --- a/arch/s390/include/asm/pci.h
>> +++ b/arch/s390/include/asm/pci.h
>> @@ -133,7 +133,8 @@ struct zpci_dev {
>>   	u8		has_hp_slot	: 1;
>>   	u8		is_physfn	: 1;
>>   	u8		util_str_avail	: 1;
>> -	u8		reserved	: 4;
>> +	u8		relaxed_align	: 1;
>> +	u8		reserved	: 3;
>>   	unsigned int	devfn;		/* DEVFN part of the RID*/
>>   
>>   	struct mutex lock;
>> diff --git a/arch/s390/include/asm/pci_clp.h b/arch/s390/include/asm/pci_clp.h
>> index 1f4b666..9fb7cbf 100644
>> --- a/arch/s390/include/asm/pci_clp.h
>> +++ b/arch/s390/include/asm/pci_clp.h
>> @@ -150,7 +150,9 @@ struct clp_rsp_query_pci_grp {
>>   	u16			:  4;
>>   	u16 noi			: 12;	/* number of interrupts */
>>   	u8 version;
>> -	u8			:  6;
>> +	u8			:  4;
>> +	u8 relaxed_align	:  1;	/* Relax length and alignment rules */
>> +	u8			:  1;
>>   	u8 frame		:  1;
>>   	u8 refresh		:  1;	/* TLB refresh mode */
>>   	u16 reserved2;
>> diff --git a/arch/s390/pci/pci_clp.c b/arch/s390/pci/pci_clp.c
>> index 153720d..630f8fc 100644
>> --- a/arch/s390/pci/pci_clp.c
>> +++ b/arch/s390/pci/pci_clp.c
>> @@ -103,6 +103,7 @@ static void clp_store_query_pci_fngrp(struct zpci_dev *zdev,
>>   	zdev->max_msi = response->noi;
>>   	zdev->fmb_update = response->mui;
>>   	zdev->version = response->version;
>> +	zdev->relaxed_align = response->relaxed_align;
>>   
>>   	switch (response->version) {
>>   	case 1:
> 
> Hm, what does that 'relaxed alignment' imply? Is that something that
> can apply to emulated devices as well?
> 
The relaxed alignment simply loosens the rules on the PCISTB instruction 
so that it doesn't have to be on particular boundaries / have a minimum 
length restriction, these effectively allow ISM devices to use PCISTB 
instead of PCISTG for just about everything.  If you have a look at the 
patch "s390x/pci: Handle devices that support relaxed alignment" from 
the linked qemu set, you can get an idea of what the bit changes via the 
way qemu has to be more permissive of what the guest provides for PCISTB.

Re: emulated devices...  The S390 PCI I/O layer in the guest is always 
issuing strict? aligned I/O for PCISTB, and if it decided to later 
change that behavior it would need to look at this CLP bit to decide 
whether that would be a valid operation for a given PCI function anyway. 
  This bit will remain off in the CLP response we give for emulated 
devices, ensuring that should such a change occur in the guest s390 PCI 
I/O layer, we'd just continue getting strictly-aligned PCISTB.
