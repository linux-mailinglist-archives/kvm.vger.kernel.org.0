Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF930533DB2
	for <lists+kvm@lfdr.de>; Wed, 25 May 2022 15:20:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238005AbiEYNUz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 May 2022 09:20:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244522AbiEYNTw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 May 2022 09:19:52 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48C341AF3D;
        Wed, 25 May 2022 06:19:39 -0700 (PDT)
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24PD7pvt012789;
        Wed, 25 May 2022 13:19:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=5gThyaGaWA+mcR/Yr7gUjJjf5ptNc6JGxVkl7LE8FFM=;
 b=DjwvLQanquSEhZG5INJ3XXQ/oH9u7lm/zl+cCj9YPb0LUier2dm64Se3xL04iecENpvz
 p28n9koRrFRuS4s7xHoP9GDS65J1BvaKfs5AGY77Na4xrJ1FWA9izeQgnDFPW/DyMfOH
 bKl0RdzMH7xn1gFAouafN5rn/MsjXT0b9D4RKbIi/41HEW+AKW8fSP1i8Au3kXAqL47K
 9hKnPSen50nbwE5dQV1sAupKlKX+zVIh+ahtIXlp2kfn4VPub2aLUCpSvzjv83OEThb4
 3mxjrErT3b8jl6fw8b/2hNs1FiIzD2oer0s5WNlPH85lJ/oSeNncjNUQT4UbyNoGv2wB nw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g9fxjxn7c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 25 May 2022 13:19:18 +0000
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 24PC66Ce008893;
        Wed, 25 May 2022 13:19:18 GMT
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g9fxjxn71-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 25 May 2022 13:19:17 +0000
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 24PDF68A009255;
        Wed, 25 May 2022 13:19:16 GMT
Received: from b01cxnp23034.gho.pok.ibm.com (b01cxnp23034.gho.pok.ibm.com [9.57.198.29])
        by ppma01dal.us.ibm.com with ESMTP id 3g93v8qq0a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 25 May 2022 13:19:16 +0000
Received: from b01ledav005.gho.pok.ibm.com (b01ledav005.gho.pok.ibm.com [9.57.199.110])
        by b01cxnp23034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 24PDJFAB26607956
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 25 May 2022 13:19:15 GMT
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 648FFAE05C;
        Wed, 25 May 2022 13:19:15 +0000 (GMT)
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0DE1DAE063;
        Wed, 25 May 2022 13:19:09 +0000 (GMT)
Received: from [9.163.3.233] (unknown [9.163.3.233])
        by b01ledav005.gho.pok.ibm.com (Postfix) with ESMTP;
        Wed, 25 May 2022 13:19:08 +0000 (GMT)
Message-ID: <3b6bdde6-2a6d-4792-ff5c-86b6fc7a2dca@linux.ibm.com>
Date:   Wed, 25 May 2022 09:19:08 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH v8 11/22] KVM: s390: pci: add basic kvm_zdev structure
Content-Language: en-US
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     linux-s390@vger.kernel.org, cohuck@redhat.com,
        schnelle@linux.ibm.com, farman@linux.ibm.com, pmorel@linux.ibm.com,
        borntraeger@linux.ibm.com, hca@linux.ibm.com, gor@linux.ibm.com,
        gerald.schaefer@linux.ibm.com, agordeev@linux.ibm.com,
        svens@linux.ibm.com, frankja@linux.ibm.com, david@redhat.com,
        imbrenda@linux.ibm.com, vneethv@linux.ibm.com,
        oberpar@linux.ibm.com, freude@linux.ibm.com, thuth@redhat.com,
        pasic@linux.ibm.com, pbonzini@redhat.com, corbet@lwn.net,
        jgg@nvidia.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org
References: <20220524185907.140285-1-mjrosato@linux.ibm.com>
 <20220524185907.140285-12-mjrosato@linux.ibm.com>
 <20220524165046.69f0d84a.alex.williamson@redhat.com>
From:   Matthew Rosato <mjrosato@linux.ibm.com>
In-Reply-To: <20220524165046.69f0d84a.alex.williamson@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: mm_PGQd2Z4_saabnBYfHgsrkmpzQDUjS
X-Proofpoint-GUID: pmrdjbA_L2CZLW5FH0VHmC9vXHlcv2JY
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-25_03,2022-05-25_02,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 phishscore=0
 priorityscore=1501 spamscore=0 suspectscore=0 adultscore=0 mlxscore=0
 malwarescore=0 impostorscore=0 lowpriorityscore=0 mlxlogscore=999
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2205250067
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/24/22 6:50 PM, Alex Williamson wrote:
> On Tue, 24 May 2022 14:58:56 -0400
> Matthew Rosato <mjrosato@linux.ibm.com> wrote:
>> diff --git a/arch/s390/kvm/pci.c b/arch/s390/kvm/pci.c
>> new file mode 100644
>> index 000000000000..21c2be5c2713
>> --- /dev/null
>> +++ b/arch/s390/kvm/pci.c
>> @@ -0,0 +1,36 @@
>> +// SPDX-License-Identifier: GPL-2.0
>> +/*
>> + * s390 kvm PCI passthrough support
>> + *
>> + * Copyright IBM Corp. 2022
>> + *
>> + *    Author(s): Matthew Rosato <mjrosato@linux.ibm.com>
>> + */
>> +
>> +#include <linux/kvm_host.h>
>> +#include <linux/pci.h>
>> +#include "pci.h"
>> +
>> +static int kvm_s390_pci_dev_open(struct zpci_dev *zdev)
>> +{
>> +	struct kvm_zdev *kzdev;
>> +
>> +	kzdev = kzalloc(sizeof(struct kvm_zdev), GFP_KERNEL);
>> +	if (!kzdev)
>> +		return -ENOMEM;
>> +
>> +	kzdev->zdev = zdev;
>> +	zdev->kzdev = kzdev;
>> +
>> +	return 0;
>> +}
>> +
>> +static void kvm_s390_pci_dev_release(struct zpci_dev *zdev)
>> +{
>> +	struct kvm_zdev *kzdev;
>> +
>> +	kzdev = zdev->kzdev;
>> +	WARN_ON(kzdev->zdev != zdev);
>> +	zdev->kzdev = 0;
> 
> I imagine this should be s/0/NULL/, right?  I feel like there was a
> recent similar discussion, but I can't think of any unique search terms
> to sort it out of my inbox.  Thanks,
> 

Yup, I recall a similar comment on a prior version but I don't recall if 
it was this particular patch or not -- anyway will change

