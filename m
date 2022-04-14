Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A36E500E46
	for <lists+kvm@lfdr.de>; Thu, 14 Apr 2022 15:01:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243694AbiDNNDf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Apr 2022 09:03:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242163AbiDNNDd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Apr 2022 09:03:33 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F65885BD0;
        Thu, 14 Apr 2022 06:01:08 -0700 (PDT)
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23EC3wZB019753;
        Thu, 14 Apr 2022 13:01:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=7Ni552NCpJN+iMVbAphLxX+Thjf0FLlKqeU+Nzjvh5s=;
 b=g/7TQofXQJc0dgjSLaD+ijZdQ1BVZKJY+2oGBSORRJnK+wBfQl62s3cZJd+Ez9TIld5q
 vl1SiuRqqwNSag/4xa75WkKj/79CdCS1Pm0C9Xn4UDkBiP6n/6k/+IDdS2gJ76Fsal2Z
 LHS71OktoEUdaPNACXqOrXYN3w7HFJ9bfOh1wEmbXBLv1GF8NrHAe7FNcb2H7lmxIcJq
 5gfWAiLXQxPtYmSvR0dG0a5gYKOUgv1L6Te2OpVRZ4HvLsPU0OZFTD3C/62KQbtJBqkA
 T5hINP+OJYpfLPd34BnaV4Tbuf0ekgh/7a7G5Z16Ld9FOycyGbGzGGDfpDDxm5HSrvXb Qw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3fegbrvs6w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 14 Apr 2022 13:01:07 +0000
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 23ECnUUp007685;
        Thu, 14 Apr 2022 13:01:06 GMT
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3fegbrvs67-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 14 Apr 2022 13:01:06 +0000
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 23ECwDNw017659;
        Thu, 14 Apr 2022 13:01:05 GMT
Received: from b01cxnp23034.gho.pok.ibm.com (b01cxnp23034.gho.pok.ibm.com [9.57.198.29])
        by ppma03dal.us.ibm.com with ESMTP id 3fb1sah37x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 14 Apr 2022 13:01:05 +0000
Received: from b01ledav005.gho.pok.ibm.com (b01ledav005.gho.pok.ibm.com [9.57.199.110])
        by b01cxnp23034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 23ED14QL11993596
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 14 Apr 2022 13:01:04 GMT
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 759E0AE05F;
        Thu, 14 Apr 2022 13:01:04 +0000 (GMT)
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D37ABAE091;
        Thu, 14 Apr 2022 13:00:59 +0000 (GMT)
Received: from [9.211.76.45] (unknown [9.211.76.45])
        by b01ledav005.gho.pok.ibm.com (Postfix) with ESMTP;
        Thu, 14 Apr 2022 13:00:59 +0000 (GMT)
Message-ID: <59db2baa-02ba-e438-db3b-ee06ed6c2fbc@linux.ibm.com>
Date:   Thu, 14 Apr 2022 09:00:58 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH v5 11/21] KVM: s390: pci: do initial setup for AEN
 interpretation
Content-Language: en-US
To:     Christian Borntraeger <borntraeger@linux.ibm.com>,
        linux-s390@vger.kernel.org
Cc:     alex.williamson@redhat.com, cohuck@redhat.com,
        schnelle@linux.ibm.com, farman@linux.ibm.com, pmorel@linux.ibm.com,
        hca@linux.ibm.com, gor@linux.ibm.com,
        gerald.schaefer@linux.ibm.com, agordeev@linux.ibm.com,
        svens@linux.ibm.com, frankja@linux.ibm.com, david@redhat.com,
        imbrenda@linux.ibm.com, vneethv@linux.ibm.com,
        oberpar@linux.ibm.com, freude@linux.ibm.com, thuth@redhat.com,
        pasic@linux.ibm.com, pbonzini@redhat.com, corbet@lwn.net,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org
References: <20220404174349.58530-1-mjrosato@linux.ibm.com>
 <20220404174349.58530-12-mjrosato@linux.ibm.com>
 <95e46303-931c-ec90-94f3-67ed34383650@linux.ibm.com>
From:   Matthew Rosato <mjrosato@linux.ibm.com>
In-Reply-To: <95e46303-931c-ec90-94f3-67ed34383650@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: TCo_0jnSNqrqUfFMovp90vItAnPLQhl0
X-Proofpoint-ORIG-GUID: rV-rkPXcfrcUjITBpRYAtndrsmflrBuI
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-14_04,2022-04-14_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 phishscore=0
 priorityscore=1501 clxscore=1015 lowpriorityscore=0 spamscore=0
 malwarescore=0 bulkscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204140072
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H4,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/14/22 3:20 AM, Christian Borntraeger wrote:
> 
> 
> Am 04.04.22 um 19:43 schrieb Matthew Rosato:
>> Initial setup for Adapter Event Notification Interpretation for zPCI
>> passthrough devices.  Specifically, allocate a structure for 
>> forwarding of
>> adapter events and pass the address of this structure to firmware.
>>
>> Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
> [...]
>> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
>> index 156d1c25a3c1..9db6f8080f71 100644
>> --- a/arch/s390/kvm/kvm-s390.c
>> +++ b/arch/s390/kvm/kvm-s390.c
>> @@ -47,6 +47,7 @@
>>   #include <asm/fpu/api.h>
>>   #include "kvm-s390.h"
>>   #include "gaccess.h"
>> +#include "pci.h"
>>   #define CREATE_TRACE_POINTS
>>   #include "trace.h"
>> @@ -502,6 +503,14 @@ int kvm_arch_init(void *opaque)
>>           goto out;
>>       }
>> +    if (kvm_s390_pci_interp_allowed()) {
>> +        rc = kvm_s390_pci_init();
>> +        if (rc) {
>> +            pr_err("Unable to allocate AIFT for PCI\n");
>> +            goto out;
>> +        }
>> +    }
>> +
>>       rc = kvm_s390_gib_init(GAL_ISC);
>>       if (rc)
>>           goto out;
> 
> We would not free the aift that was allocated by kvm_s390_pci_init
> in kvm_arch_exit.
> Wouldnt we re-allocate a new aift when we unload/reload kvm forgetting 
> about the old one?

Oops, yes it looks like that's the case.  We must back-pocket a certain 
subset of firmware-shared structures (e.g. zpci_aipb and zpci_aif_sbv) 
as these cannot change for the life of the system once registered with 
firmware; but the aift is a kernel-only structure that should be safe to 
free until next module load.  I think this can be done at the end of 
kvm_s390_pci_aen_exit (with some caller adjustments re: the aift mutex)
> 
> 
>> diff --git a/arch/s390/kvm/pci.c b/arch/s390/kvm/pci.c
> [...]
>> +static int zpci_setup_aipb(u8 nisc)
> [...]
>> +    size = get_order(PAGE_ALIGN(ZPCI_NR_DEVICES *
>> +                        sizeof(struct zpci_gaite)));
> [...]
>> +    if (zpci_set_irq_ctrl(SIC_SET_AENI_CONTROLS, 0, zpci_aipb)) {
>> +        rc = -EIO;
>> +        goto free_gait;
>> +    }
>> +
>> +    return 0;
>> +
>> +free_gait:
>> +    size = get_order(PAGE_ALIGN(ZPCI_NR_DEVICES *
>> +                    sizeof(struct zpci_gaite)));
> 
> size should still be valid here?

Good point

> 
>> +    free_pages((unsigned long)aift->gait, size);
>> +free_sbv:
>> +    airq_iv_release(aift->sbv);
>> +    zpci_aif_sbv = 0;
>> +free_aipb:
>> +    kfree(zpci_aipb);
>> +    zpci_aipb = 0;
>> +
>> +    return rc;
>> +}
>> +
> 
> The remaining parts look sane.

