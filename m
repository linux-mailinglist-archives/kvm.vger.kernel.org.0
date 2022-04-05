Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E05B84F49B8
	for <lists+kvm@lfdr.de>; Wed,  6 Apr 2022 02:29:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1444532AbiDEWVM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Apr 2022 18:21:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1392323AbiDEPgD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 Apr 2022 11:36:03 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B89013D15;
        Tue,  5 Apr 2022 06:48:39 -0700 (PDT)
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 235DWShG013950;
        Tue, 5 Apr 2022 13:48:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=+btC4gU4s+nPb97YMonz7mX3kcm1fmY4AwI+1gHG20g=;
 b=bTphuem0PUznD8kg2rs+NuV0+FB3nebmNyXgnAM9OsljMjy3s3h2lRLhcHxo0qugHbiy
 kA5QLqUjwW6S8rEJmLh3Kqqh5D+AuHpCY0gnFVYDu7f3AHFch5GvGouQ0OTBK9vBFroA
 2R8394cXhj8YWnq5pfS0B1H2xY7SHGjAjHBIFar2Gt1YlNmtmm6o96fnMBzJJc2higNO
 X0BRYdCCxBeCPBY9j70QrYn/fSNyHjWR909d0jWzJpUAS82Qs/t2FKcb6sGPUdDa4Cqe
 ojVTJ6P/en/C8WPiE90i1osoRr07UcVA+9M4MYdAwf1KPoHrpOCOpdosYE1injkmvIgM EA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3f85tcpbw6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 05 Apr 2022 13:48:37 +0000
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 235DXZMf018785;
        Tue, 5 Apr 2022 13:48:37 GMT
Received: from ppma05wdc.us.ibm.com (1b.90.2fa9.ip4.static.sl-reverse.com [169.47.144.27])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3f85tcpbvw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 05 Apr 2022 13:48:37 +0000
Received: from pps.filterd (ppma05wdc.us.ibm.com [127.0.0.1])
        by ppma05wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 235Dl5Je012330;
        Tue, 5 Apr 2022 13:48:36 GMT
Received: from b01cxnp22036.gho.pok.ibm.com (b01cxnp22036.gho.pok.ibm.com [9.57.198.26])
        by ppma05wdc.us.ibm.com with ESMTP id 3f6e48ykm6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 05 Apr 2022 13:48:36 +0000
Received: from b01ledav001.gho.pok.ibm.com (b01ledav001.gho.pok.ibm.com [9.57.199.106])
        by b01cxnp22036.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 235DmZg24260488
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 5 Apr 2022 13:48:35 GMT
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C44BC2805C;
        Tue,  5 Apr 2022 13:48:35 +0000 (GMT)
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 74D662805A;
        Tue,  5 Apr 2022 13:48:30 +0000 (GMT)
Received: from [9.211.32.125] (unknown [9.211.32.125])
        by b01ledav001.gho.pok.ibm.com (Postfix) with ESMTP;
        Tue,  5 Apr 2022 13:48:30 +0000 (GMT)
Message-ID: <7196af99-fcfa-c9a6-a245-c15268c6851b@linux.ibm.com>
Date:   Tue, 5 Apr 2022 09:48:29 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH v5 14/21] KVM: s390: pci: provide routines for
 enabling/disabling interrupt forwarding
Content-Language: en-US
To:     Niklas Schnelle <schnelle@linux.ibm.com>,
        linux-s390@vger.kernel.org
Cc:     alex.williamson@redhat.com, cohuck@redhat.com,
        farman@linux.ibm.com, pmorel@linux.ibm.com,
        borntraeger@linux.ibm.com, hca@linux.ibm.com, gor@linux.ibm.com,
        gerald.schaefer@linux.ibm.com, agordeev@linux.ibm.com,
        svens@linux.ibm.com, frankja@linux.ibm.com, david@redhat.com,
        imbrenda@linux.ibm.com, vneethv@linux.ibm.com,
        oberpar@linux.ibm.com, freude@linux.ibm.com, thuth@redhat.com,
        pasic@linux.ibm.com, pbonzini@redhat.com, corbet@lwn.net,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org
References: <20220404174349.58530-1-mjrosato@linux.ibm.com>
 <20220404174349.58530-15-mjrosato@linux.ibm.com>
 <9a551f04c3878ecb3a26fed6aff2834fbfe41f18.camel@linux.ibm.com>
From:   Matthew Rosato <mjrosato@linux.ibm.com>
In-Reply-To: <9a551f04c3878ecb3a26fed6aff2834fbfe41f18.camel@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: hT11Spx2r5AaBwzNTO_ciEBQkLoA00Hz
X-Proofpoint-ORIG-GUID: Mn_KHom0Nmle7NXb8B0QGQ9sRPbMTF4a
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-04-05_02,2022-04-05_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 phishscore=0 suspectscore=0 lowpriorityscore=0 mlxscore=0
 impostorscore=0 mlxlogscore=999 bulkscore=0 adultscore=0 clxscore=1015
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204050079
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/5/22 9:39 AM, Niklas Schnelle wrote:
> On Mon, 2022-04-04 at 13:43 -0400, Matthew Rosato wrote:
>> These routines will be wired into a kvm ioctl in order to respond to
>> requests to enable / disable a device for Adapter Event Notifications /
>> Adapter Interuption Forwarding.
>>
>> Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
>> ---
>>   arch/s390/kvm/pci.c      | 247 +++++++++++++++++++++++++++++++++++++++
>>   arch/s390/kvm/pci.h      |   1 +
>>   arch/s390/pci/pci_insn.c |   1 +
>>   3 files changed, 249 insertions(+)
>>
>> diff --git a/arch/s390/kvm/pci.c b/arch/s390/kvm/pci.c
>> index 01bd8a2f503b..f0fd68569a9d 100644
>> --- a/arch/s390/kvm/pci.c
>> +++ b/arch/s390/kvm/pci.c
>> @@ -11,6 +11,7 @@
>>   #include <linux/pci.h>
>>   #include <asm/pci.h>
>>   #include <asm/pci_insn.h>
>> +#include <asm/pci_io.h>
>>   #include "pci.h"
>>   
>>   struct zpci_aift *aift;
>> @@ -152,6 +153,252 @@ int kvm_s390_pci_aen_init(u8 nisc)
>>   	return rc;
>>   }
>>   
>> +/* Modify PCI: Register floating adapter interruption forwarding */
>> +static int kvm_zpci_set_airq(struct zpci_dev *zdev)
>> +{
>> +	u64 req = ZPCI_CREATE_REQ(zdev->fh, 0, ZPCI_MOD_FC_REG_INT);
>> +	struct zpci_fib fib = {};
> 
> Hmm this one uses '{}' as initializer while all current callers of
> zpci_mod_fc() use '{0}'. As far as I know the empty braces are a GNU
> extension so should work for the kernel but for consistency I'd go with
> '{0}' or possibly '{.foo = bar, ...}' where that is more readable.
> There too uninitialized fields will be set to 0. Unless of course there
> is a conflicting KVM convention that I don't know about.

No convention that I'm aware of, I previously had fib = {0} based on the 
same rationale you describe and changed to fib = {} per review request 
from Pierre a few versions back.  I don't have a strong preference, but 
I did not note any functional difference between the two and see a bunch 
of examples of both methods throughout the kernel.

