Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 74BEC5B9F7A
	for <lists+kvm@lfdr.de>; Thu, 15 Sep 2022 18:16:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229932AbiIOQQV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Sep 2022 12:16:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229837AbiIOQQS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Sep 2022 12:16:18 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D24DD9C2E8;
        Thu, 15 Sep 2022 09:16:17 -0700 (PDT)
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28FFFp0s015370;
        Thu, 15 Sep 2022 16:16:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=mP7xIiIoNVng2pUnSuk+JLsCADjNiiuTggfJ2AumvEk=;
 b=cXWBk3T1ADnBa0MwvUyjlI2PcYrJ+NF7TzlELEAeuZTy0pljv1JzRvAV7Nf1q1+VJawP
 KNiVCEPOdhoJg9YXWgFAlzi9g4sgK6KsA5MfudS5/NM9MxZ2RXcML7Dxte8/vefHIfu6
 lBrf3/mOzkhSI5+a+IdNit241YEApdLqglSb0V1xF1h30J7VXYcHWnnbeYZnMZi5Rqzn
 jocKIwKWzbB7Dq8vasTzoOGzLGjeWpPkvFGKyzLVmJnNy/cjHhCBzbhRFwR5HnHZ5+/H
 THK9SUJnaqY6aSwWeum7t8rsG7ZfQ9YwytZ9WzZbaQ4sGdnvJu9+GyiDxy6d0Qu0Lv03 Pg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3jm6hmj5fm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 15 Sep 2022 16:16:07 +0000
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 28FFGi0M021001;
        Thu, 15 Sep 2022 16:16:06 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3jm6hmj5er-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 15 Sep 2022 16:16:06 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 28FG7gF2025576;
        Thu, 15 Sep 2022 16:16:05 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma06ams.nl.ibm.com with ESMTP id 3jjyfran1t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 15 Sep 2022 16:16:04 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 28FGCD9930343544
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 15 Sep 2022 16:12:13 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9F0664C040;
        Thu, 15 Sep 2022 16:16:01 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EE98D4C046;
        Thu, 15 Sep 2022 16:16:00 +0000 (GMT)
Received: from [9.171.87.36] (unknown [9.171.87.36])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 15 Sep 2022 16:16:00 +0000 (GMT)
Message-ID: <9645ad8e-1fbe-894a-6a13-f5e91d019199@linux.ibm.com>
Date:   Thu, 15 Sep 2022 18:16:00 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [PATCH] KVM: s390: pci: fix plain integer as NULL pointer
 warnings
Content-Language: en-US
To:     Matthew Rosato <mjrosato@linux.ibm.com>,
        linux-s390@vger.kernel.org, frankja@linux.ibm.com
Cc:     farman@linux.ibm.com, schnelle@linux.ibm.com, pmorel@linux.ibm.com,
        imbrenda@linux.ibm.com, david@redhat.com, hca@linux.ibm.com,
        gor@linux.ibm.com, gerald.schaefer@linux.ibm.com,
        agordeev@linux.ibm.com, svens@linux.ibm.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel test robot <lkp@intel.com>
References: <20220823191548.77526-1-mjrosato@linux.ibm.com>
 <c558a8c8-4d87-13ee-8d33-ba0285445d62@linux.ibm.com>
From:   Christian Borntraeger <borntraeger@linux.ibm.com>
In-Reply-To: <c558a8c8-4d87-13ee-8d33-ba0285445d62@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 7A6rQPG6FilYpdhdzQewzHaf5eCEz412
X-Proofpoint-GUID: aGLs8GRLKUoSvCgnftfFS8Qtt_wsMyEf
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-15_10,2022-09-14_04,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 lowpriorityscore=0 bulkscore=0 phishscore=0 adultscore=0 mlxscore=0
 suspectscore=0 malwarescore=0 clxscore=1011 spamscore=0 mlxlogscore=999
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2208220000 definitions=main-2209150095
X-Spam-Status: No, score=-3.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Am 23.08.22 um 21:18 schrieb Matthew Rosato:
> On 8/23/22 3:15 PM, Matthew Rosato wrote:
>> Fix some sparse warnings that a plain integer 0 is being used instead of
>> NULL.
>>
>> Reported-by: kernel test robot <lkp@intel.com>
>> Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
> 
> @Janosch, since you are taking the other PCI fix can you also take this small cleanup through KVM?

Queued now for the kvm tree. Will have to look if we have other things for 6.0. Otherwise it will go with 6.1.

> 
>> ---
>>   arch/s390/kvm/pci.c | 4 ++--
>>   arch/s390/kvm/pci.h | 6 +++---
>>   2 files changed, 5 insertions(+), 5 deletions(-)
>>
>> diff --git a/arch/s390/kvm/pci.c b/arch/s390/kvm/pci.c
>> index bb8c335d17b9..3c12637ce08c 100644
>> --- a/arch/s390/kvm/pci.c
>> +++ b/arch/s390/kvm/pci.c
>> @@ -58,7 +58,7 @@ static int zpci_setup_aipb(u8 nisc)
>>   	if (!zpci_aipb)
>>   		return -ENOMEM;
>>   
>> -	aift->sbv = airq_iv_create(ZPCI_NR_DEVICES, AIRQ_IV_ALLOC, 0);
>> +	aift->sbv = airq_iv_create(ZPCI_NR_DEVICES, AIRQ_IV_ALLOC, NULL);
>>   	if (!aift->sbv) {
>>   		rc = -ENOMEM;
>>   		goto free_aipb;
>> @@ -373,7 +373,7 @@ static int kvm_s390_pci_aif_disable(struct zpci_dev *zdev, bool force)
>>   		gaite->gisc = 0;
>>   		gaite->aisbo = 0;
>>   		gaite->gisa = 0;
>> -		aift->kzdev[zdev->aisb] = 0;
>> +		aift->kzdev[zdev->aisb] = NULL;
>>   		/* Clear zdev info */
>>   		airq_iv_free_bit(aift->sbv, zdev->aisb);
>>   		airq_iv_release(zdev->aibv);
>> diff --git a/arch/s390/kvm/pci.h b/arch/s390/kvm/pci.h
>> index 3a3606c3a0fe..7be5568d8bd2 100644
>> --- a/arch/s390/kvm/pci.h
>> +++ b/arch/s390/kvm/pci.h
>> @@ -46,9 +46,9 @@ extern struct zpci_aift *aift;
>>   static inline struct kvm *kvm_s390_pci_si_to_kvm(struct zpci_aift *aift,
>>   						 unsigned long si)
>>   {
>> -	if (!IS_ENABLED(CONFIG_VFIO_PCI_ZDEV_KVM) || aift->kzdev == 0 ||
>> -	    aift->kzdev[si] == 0)
>> -		return 0;
>> +	if (!IS_ENABLED(CONFIG_VFIO_PCI_ZDEV_KVM) || aift->kzdev == NULL ||
>> +	    aift->kzdev[si] == NULL)
>> +		return NULL;
>>   	return aift->kzdev[si]->kvm;
>>   };
>>   
> 

