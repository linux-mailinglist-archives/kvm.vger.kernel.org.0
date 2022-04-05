Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B83D64F497A
	for <lists+kvm@lfdr.de>; Wed,  6 Apr 2022 02:27:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1389874AbiDEWRp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Apr 2022 18:17:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1442334AbiDEPhb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 Apr 2022 11:37:31 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2884710E043;
        Tue,  5 Apr 2022 06:51:43 -0700 (PDT)
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 235DWRjZ003272;
        Tue, 5 Apr 2022 13:51:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=70f3++uodWHlr/PXmHHWDTclVF91IG0xsbEDXHos37A=;
 b=DMdIq0bl6/8VKmrHbW7wM6dIBwQofXy30Ekze1jv+W36eX+v5tx38d0A7JrvYQIWAqWs
 PytJ8x1Um5W6COeLdTOTjrKrvx55uz+eFvaEmAwmTcd3hsmZ+l/KPIR1c6LSkyNDf9GG
 NHU1IOLwoMwSjbRn1mU4/qaf7Tnb94wzU2LaJ2XMEM7MCj9QX3J39+MEYLPptgBhkdxV
 NYlBZOvKhCZoCk5sUf8f7Tp66XBW2ziCgb5x6cFJcM3MzCqiypsVEiUERf4IMM/ogsud
 0MIhodjCZiOrsQVZeJSa4SMZ2pVoGjNzCL6nBDDxwXpqKad4yjGzQMfGGoJ+syPKayTX 0A== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3f8ph20rn4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 05 Apr 2022 13:51:42 +0000
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 235DWvRX004595;
        Tue, 5 Apr 2022 13:51:42 GMT
Received: from ppma02wdc.us.ibm.com (aa.5b.37a9.ip4.static.sl-reverse.com [169.55.91.170])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3f8ph20rmn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 05 Apr 2022 13:51:41 +0000
Received: from pps.filterd (ppma02wdc.us.ibm.com [127.0.0.1])
        by ppma02wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 235DmwQM029536;
        Tue, 5 Apr 2022 13:51:40 GMT
Received: from b01cxnp23033.gho.pok.ibm.com (b01cxnp23033.gho.pok.ibm.com [9.57.198.28])
        by ppma02wdc.us.ibm.com with ESMTP id 3f6e49fny5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 05 Apr 2022 13:51:40 +0000
Received: from b01ledav001.gho.pok.ibm.com (b01ledav001.gho.pok.ibm.com [9.57.199.106])
        by b01cxnp23033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 235DpdFA46072108
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 5 Apr 2022 13:51:39 GMT
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CA3D728065;
        Tue,  5 Apr 2022 13:51:39 +0000 (GMT)
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E77E428074;
        Tue,  5 Apr 2022 13:51:34 +0000 (GMT)
Received: from [9.211.32.125] (unknown [9.211.32.125])
        by b01ledav001.gho.pok.ibm.com (Postfix) with ESMTP;
        Tue,  5 Apr 2022 13:51:34 +0000 (GMT)
Message-ID: <26fa1eef-8c89-8819-b12c-3b8caaf40bb2@linux.ibm.com>
Date:   Tue, 5 Apr 2022 09:51:34 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH v5 10/21] KVM: s390: pci: add basic kvm_zdev structure
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
 <20220404174349.58530-11-mjrosato@linux.ibm.com>
 <8fc611271c6156dee5c5f5b5c2f583d2d7774843.camel@linux.ibm.com>
From:   Matthew Rosato <mjrosato@linux.ibm.com>
In-Reply-To: <8fc611271c6156dee5c5f5b5c2f583d2d7774843.camel@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: Qt5-YCCO2ZAkFtw-CyjLutRvAHpvHu4x
X-Proofpoint-ORIG-GUID: abzCw4HVKfcXKNf_D465BhRHBCQe8tNw
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-04-05_02,2022-04-05_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 spamscore=0
 clxscore=1015 priorityscore=1501 adultscore=0 mlxlogscore=898 phishscore=0
 suspectscore=0 lowpriorityscore=0 impostorscore=0 bulkscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204050079
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H5,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/5/22 4:20 AM, Niklas Schnelle wrote:
> On Mon, 2022-04-04 at 13:43 -0400, Matthew Rosato wrote:
>> This structure will be used to carry kvm passthrough information related to
>> zPCI devices.
>>
>> Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
>> ---
>>   arch/s390/include/asm/pci.h |  3 +++
>>   arch/s390/kvm/Makefile      |  1 +
>>   arch/s390/kvm/pci.c         | 38 +++++++++++++++++++++++++++++++++++++
>>   arch/s390/kvm/pci.h         | 21 ++++++++++++++++++++
>>   4 files changed, 63 insertions(+)
>>   create mode 100644 arch/s390/kvm/pci.c
>>   create mode 100644 arch/s390/kvm/pci.h
>>
>> diff --git a/arch/s390/include/asm/pci.h b/arch/s390/include/asm/pci.h
>> index 4c5b8fbc2079..9eb20cebaa18 100644
>> --- a/arch/s390/include/asm/pci.h
>> +++ b/arch/s390/include/asm/pci.h
>> @@ -97,6 +97,7 @@ struct zpci_bar_struct {
>>   };
>>   
>>   struct s390_domain;
>> +struct kvm_zdev;
>>   
>>   #define ZPCI_FUNCTIONS_PER_BUS 256
>>   struct zpci_bus {
>> @@ -190,6 +191,8 @@ struct zpci_dev {
>>   	struct dentry	*debugfs_dev;
>>   
>>   	struct s390_domain *s390_domain; /* s390 IOMMU domain data */
>> +
>> +	struct kvm_zdev *kzdev; /* passthrough data */
>>   };
> 
> The struct zpci_dev tries to use semantic groups in its formatting.
> It's not perfect and we probably need to clean this up to remove some
> holes in the future. For now let's put the new kzdev without a blank
> line together with s390_domain and add a "section comment" like
> "IOMMU and passthrough".
> Also I'd drop the "... data" part of the line end comment or even drop
> it entirely, the name is pretty clear already when combined with the
> section comment.

Sure, will do

> 
> With that Reviewed-by: Niklas Schnelle <schnelle@linux.ibm.com>
> 

Thanks!
