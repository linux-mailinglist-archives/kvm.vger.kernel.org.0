Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 20B1550B70B
	for <lists+kvm@lfdr.de>; Fri, 22 Apr 2022 14:12:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1447359AbiDVMOD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Apr 2022 08:14:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1447473AbiDVMN4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Apr 2022 08:13:56 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EC8C5715F
        for <kvm@vger.kernel.org>; Fri, 22 Apr 2022 05:10:49 -0700 (PDT)
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23MBlSXq017503;
        Fri, 22 Apr 2022 12:10:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=5SAS3lOhc41mekbq3ItnfDwgHr/whPaP4RfScw//zUk=;
 b=Hb2rm4K/CPIMJXgvHkm2TNo9obIeFOtSbQTmXxO+P7mdlQghLWJ50F9tGG8pBilzIGFY
 kerd0NQoyc/cSG/Ij3kyIHDKd62mIxNx/rH4En+Bd2N5hF1Jr7zqoWGW6PH1DGVX3O8C
 BVnqKVPSz9KDhGNBlwDP3VoGxV7JCzaSzXGNxjvlpyo7KFJFeqYNhET6IY5toyB6dnWH
 tvey56dCUhS/mne3odR02D+oV7kzsn55aXmPg5SznmoWtfp/15HIToWzmstEwnBgrnMi
 zL0OAraVahCC2KWyLqYgXedgOC9fxzE5HLhSv39Ax+gsvyrRd3WV2zREQb3YwWu7MN+j eA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3fjm2jq5h4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 22 Apr 2022 12:10:41 +0000
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 23MAN7Fi017956;
        Fri, 22 Apr 2022 12:10:41 GMT
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3fjm2jq5gt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 22 Apr 2022 12:10:41 +0000
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 23MC7CXI024023;
        Fri, 22 Apr 2022 12:10:40 GMT
Received: from b01cxnp22034.gho.pok.ibm.com (b01cxnp22034.gho.pok.ibm.com [9.57.198.24])
        by ppma02dal.us.ibm.com with ESMTP id 3ffneaw8jm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 22 Apr 2022 12:10:40 +0000
Received: from b01ledav003.gho.pok.ibm.com (b01ledav003.gho.pok.ibm.com [9.57.199.108])
        by b01cxnp22034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 23MCAdoP57868784
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 22 Apr 2022 12:10:39 GMT
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6BADFB2064;
        Fri, 22 Apr 2022 12:10:39 +0000 (GMT)
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0ADD4B2067;
        Fri, 22 Apr 2022 12:10:36 +0000 (GMT)
Received: from [9.211.145.86] (unknown [9.211.145.86])
        by b01ledav003.gho.pok.ibm.com (Postfix) with ESMTP;
        Fri, 22 Apr 2022 12:10:35 +0000 (GMT)
Message-ID: <9a171204-6d71-ee1d-d8bd-cd4eac91c3d5@linux.ibm.com>
Date:   Fri, 22 Apr 2022 08:10:34 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH v5 7/9] s390x/pci: enable adapter event notification for
 interpreted devices
Content-Language: en-US
To:     Pierre Morel <pmorel@linux.ibm.com>, qemu-s390x@nongnu.org
Cc:     alex.williamson@redhat.com, schnelle@linux.ibm.com,
        cohuck@redhat.com, thuth@redhat.com, farman@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com,
        pasic@linux.ibm.com, borntraeger@linux.ibm.com, mst@redhat.com,
        pbonzini@redhat.com, qemu-devel@nongnu.org, kvm@vger.kernel.org
References: <20220404181726.60291-1-mjrosato@linux.ibm.com>
 <20220404181726.60291-8-mjrosato@linux.ibm.com>
 <31b5f911-0e1f-ba3c-94f2-1947d5b16057@linux.ibm.com>
From:   Matthew Rosato <mjrosato@linux.ibm.com>
In-Reply-To: <31b5f911-0e1f-ba3c-94f2-1947d5b16057@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 0Oo-4KEx3ZLQVXxMgUV-Q531CBH-15UI
X-Proofpoint-ORIG-GUID: fSc6mpgNoIEkD61BE-eM1TLWNeee0uZB
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-22_03,2022-04-22_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 impostorscore=0 clxscore=1015 lowpriorityscore=0 adultscore=0
 suspectscore=0 mlxlogscore=999 spamscore=0 bulkscore=0 phishscore=0
 malwarescore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204220053
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/22/22 5:39 AM, Pierre Morel wrote:
> 
> 
> On 4/4/22 20:17, Matthew Rosato wrote:
>> Use the associated kvm ioctl operation to enable adapter event 
>> notification
>> and forwarding for devices when requested.  This feature will be set up
>> with or without firmware assist based upon the 'forwarding_assist' 
>> setting.
>>
>> Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
>> ---
>>   hw/s390x/s390-pci-bus.c         | 20 ++++++++++++++---
>>   hw/s390x/s390-pci-inst.c        | 40 +++++++++++++++++++++++++++++++--
>>   hw/s390x/s390-pci-kvm.c         | 30 +++++++++++++++++++++++++
>>   include/hw/s390x/s390-pci-bus.h |  1 +
>>   include/hw/s390x/s390-pci-kvm.h | 14 ++++++++++++
>>   5 files changed, 100 insertions(+), 5 deletions(-)
>>
>> diff --git a/hw/s390x/s390-pci-bus.c b/hw/s390x/s390-pci-bus.c
>> index 9c02d31250..47918d2ce9 100644
>> --- a/hw/s390x/s390-pci-bus.c
>> +++ b/hw/s390x/s390-pci-bus.c
>> @@ -190,7 +190,10 @@ void s390_pci_sclp_deconfigure(SCCB *sccb)
>>           rc = SCLP_RC_NO_ACTION_REQUIRED;
>>           break;
>>       default:
>> -        if (pbdev->summary_ind) {
>> +        if (pbdev->interp && (pbdev->fh & FH_MASK_ENABLE)) {
>> +            /* Interpreted devices were using interrupt forwarding */
>> +            s390_pci_kvm_aif_disable(pbdev);
> 
> Same remark as for the kernel part.
> The VFIO device is already initialized and the action is on this device, 
> Shouldn't we use the VFIO device interface instead of the KVM interface?
> 

I don't necessarily disagree, but in v3 of the kernel series I was told 
not to use VFIO ioctls to accomplish tasks that are unique to KVM (e.g. 
AEN interpretation) and to instead use a KVM ioctl.

VFIO_DEVICE_SET_IRQS won't work as-is for reasons described in the 
kernel series (e.g. we don't see any of the config space notifiers 
because of instruction interpretation) -- as far as I can figure we 
could add our own s390 code to QEMU to issue VFIO_DEVICE_SET_IRQS 
directly for an interpreted device, but I think would also need 
s390-specific changes to VFIO_DEVICE_SET_IRQS accommodate this (e.g. 
maybe something like a VFIO_IRQ_SET_DATA_S390AEN where we can then 
specify the aen information in vfio_irq_set.data -- or something else I 
haven't though of yet) -- I can try to look at this some more and see if 
I get a good idea.
