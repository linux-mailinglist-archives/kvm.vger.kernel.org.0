Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A49D2FAF8
	for <lists+kvm@lfdr.de>; Tue, 30 Apr 2019 16:05:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727939AbfD3OEa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Apr 2019 10:04:30 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:45936 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726294AbfD3OEa (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 30 Apr 2019 10:04:30 -0400
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x3UE2xXh040684
        for <kvm@vger.kernel.org>; Tue, 30 Apr 2019 10:04:27 -0400
Received: from e06smtp02.uk.ibm.com (e06smtp02.uk.ibm.com [195.75.94.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2s6n48rmeh-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 30 Apr 2019 10:04:19 -0400
Received: from localhost
        by e06smtp02.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <pmorel@linux.ibm.com>;
        Tue, 30 Apr 2019 15:03:36 +0100
Received: from b06cxnps4074.portsmouth.uk.ibm.com (9.149.109.196)
        by e06smtp02.uk.ibm.com (192.168.101.132) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Tue, 30 Apr 2019 15:03:33 +0100
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x3UE3VGY45088966
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 30 Apr 2019 14:03:31 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C7224A4066;
        Tue, 30 Apr 2019 14:03:31 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1D45BA405B;
        Tue, 30 Apr 2019 14:03:31 +0000 (GMT)
Received: from [9.145.13.117] (unknown [9.145.13.117])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 30 Apr 2019 14:03:31 +0000 (GMT)
Reply-To: pmorel@linux.ibm.com
Subject: Re: [PATCH v7 3/4] s390: ap: implement PAPQ AQIC interception in
 kernel
To:     Halil Pasic <pasic@linux.ibm.com>
Cc:     borntraeger@de.ibm.com, alex.williamson@redhat.com,
        cohuck@redhat.com, linux-kernel@vger.kernel.org,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        frankja@linux.ibm.com, akrowiak@linux.ibm.com, david@redhat.com,
        schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com,
        freude@linux.ibm.com, mimu@linux.ibm.com
References: <1556283688-556-1-git-send-email-pmorel@linux.ibm.com>
 <1556283688-556-4-git-send-email-pmorel@linux.ibm.com>
 <20190430160031.198b83c1.pasic@linux.ibm.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
Date:   Tue, 30 Apr 2019 16:03:30 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190430160031.198b83c1.pasic@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 19043014-0008-0000-0000-000002E1E0CC
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19043014-0009-0000-0000-0000224E48F5
Message-Id: <40c7e3a5-06b1-8ab9-e32d-c0305c60d63f@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-04-30_07:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1904300089
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 30/04/2019 16:00, Halil Pasic wrote:
> On Fri, 26 Apr 2019 15:01:27 +0200
> Pierre Morel <pmorel@linux.ibm.com> wrote:
> 
>> diff --git a/drivers/s390/crypto/vfio_ap_private.h b/drivers/s390/crypto/vfio_ap_private.h
>> index 18dcc4d..7cc02ff 100644
>> --- a/drivers/s390/crypto/vfio_ap_private.h
>> +++ b/drivers/s390/crypto/vfio_ap_private.h
>> @@ -4,6 +4,7 @@
>>    *
>>    * Author(s): Tony Krowiak <akrowiak@linux.ibm.com>
>>    *	      Halil Pasic <pasic@linux.ibm.com>
>> + *	      Pierre Morel <pmorel@linux.ibm.com>
>>    *
>>    * Copyright IBM Corp. 2018
>>    */
>> @@ -90,4 +91,14 @@ struct ap_matrix_mdev {
>>   extern int vfio_ap_mdev_register(void);
>>   extern void vfio_ap_mdev_unregister(void);
>>   
>> +struct vfio_ap_queue {
>> +	struct ap_matrix_mdev *matrix_mdev;
>> +	unsigned long a_nib;
>> +	unsigned long a_pfn;
>> +	unsigned long p_pfn;
>> +	int	apqn;
>> +#define VFIO_AP_ISC_INVALID 0xff
> 
> How about -1?
> 
>> +	unsigned char a_isc;
>> +	unsigned char p_isc;
>> +};
>>   #endif /* _VFIO_AP_PRIVATE_H_ */
> 
> I assume a_ and p_ are for argument and private, or? Anyway it would be
> nice to have nicer names for these.
> 
> If the a_ members are really just arguments, we could probably live
> without the. I'm fine either way.
> 
> Regards,
> Halil
> 

Since there will be another iteration to modify other part of this patch
I will simplify this handling and make the names clearer.

Thanks
Pierre

-- 
Pierre Morel
Linux/KVM/QEMU in Böblingen - Germany

