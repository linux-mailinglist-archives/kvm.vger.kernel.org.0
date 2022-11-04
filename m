Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A6F261944A
	for <lists+kvm@lfdr.de>; Fri,  4 Nov 2022 11:17:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231626AbiKDKRA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Nov 2022 06:17:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231670AbiKDKQ6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Nov 2022 06:16:58 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F12429CA4
        for <kvm@vger.kernel.org>; Fri,  4 Nov 2022 03:16:57 -0700 (PDT)
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2A49JJHm016469;
        Fri, 4 Nov 2022 10:16:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=ahB/PfjDK94n1PAmaSlKvDTCLzVTexzJRVHaASREsl8=;
 b=QEGjkBjLbVapi7FODDcAVtejTr4KS+BGpyLWbmOl5Cbie2waVgSnxhlUfUsybczCGF0M
 Z8ZNbiSCTMXxzmBO22pxCOJSqOES/HRddjBq9eWFyl7t36XaIuCvmaLUVDYqjpUC8rfQ
 GO9+eNjJ1DaotmBujDVMjNiIpH9KKgEVqMcDNp0YCvMEyV6O++XAC31CLUwTie35991s
 t+7JaOtkoZjITekhchLpmYBVr12gTZW/WWXOiHUsqcA376nx8n3JbTed0DwC2Ib62u00
 KW45kMHVlhaeVXbN1CBtUsLQxHOFKDt8UtrFNJiJDbOKW+bC1fA8wcJYuV4vvr0DaSjn yw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3kmpy28yct-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 04 Nov 2022 10:16:50 +0000
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2A47vkOd009192;
        Fri, 4 Nov 2022 10:16:50 GMT
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3kmpy28yby-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 04 Nov 2022 10:16:50 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2A4AE0te022819;
        Fri, 4 Nov 2022 10:16:48 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma04fra.de.ibm.com with ESMTP id 3kgut8ym5k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 04 Nov 2022 10:16:48 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2A4AGjm961014450
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 4 Nov 2022 10:16:45 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F1564AE053;
        Fri,  4 Nov 2022 10:16:44 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0B559AE04D;
        Fri,  4 Nov 2022 10:16:44 +0000 (GMT)
Received: from [9.171.69.218] (unknown [9.171.69.218])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri,  4 Nov 2022 10:16:43 +0000 (GMT)
Message-ID: <7d809617-67e0-d233-97b2-8534e2a4610f@linux.ibm.com>
Date:   Fri, 4 Nov 2022 11:16:43 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.1
Subject: Re: [PATCH v11 01/11] s390x: Register TYPE_S390_CCW_MACHINE
 properties as class properties
Content-Language: en-US
To:     Thomas Huth <thuth@redhat.com>, qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, cohuck@redhat.com,
        mst@redhat.com, pbonzini@redhat.com, kvm@vger.kernel.org,
        ehabkost@redhat.com, marcel.apfelbaum@gmail.com, eblake@redhat.com,
        armbru@redhat.com, seiden@linux.ibm.com, nrb@linux.ibm.com,
        scgl@linux.ibm.com, frankja@linux.ibm.com, berrange@redhat.com,
        clg@kaod.org
References: <20221103170150.20789-1-pmorel@linux.ibm.com>
 <20221103170150.20789-2-pmorel@linux.ibm.com>
 <3f913a58-e7d0-539e-3bc0-6cbd5608db8e@redhat.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <3f913a58-e7d0-539e-3bc0-6cbd5608db8e@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 8pq0nlzQ2L6NzgVhrygMEuyvtiWVOyUM
X-Proofpoint-GUID: jeaXe9GcbWkRqses6YntYCL8zuLGxX-j
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-04_06,2022-11-03_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 suspectscore=0
 spamscore=0 phishscore=0 priorityscore=1501 mlxlogscore=909
 lowpriorityscore=0 impostorscore=0 malwarescore=0 adultscore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211040062
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 11/4/22 07:32, Thomas Huth wrote:
> On 03/11/2022 18.01, Pierre Morel wrote:
>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>> ---
>>   hw/s390x/s390-virtio-ccw.c | 127 +++++++++++++++++++++----------------
>>   1 file changed, 72 insertions(+), 55 deletions(-)
> 
> -EMISSINGPATCHDESCRIPTION
> 
> ... please add some words *why* this is a good idea / necessary.

I saw that the i386 patch had no description for the same patch so...

To be honest I do not know why it is necessary.
The only reason I see is to be in sync with the PC implementation.

So what about:
"
Register TYPE_S390_CCW_MACHINE properties as class properties
to be conform with the X architectures
"
?

@Cédric , any official recommendation for doing that?

> 
>   Thanks,
>    Thomas
> 
> 

-- 
Pierre Morel
IBM Lab Boeblingen
