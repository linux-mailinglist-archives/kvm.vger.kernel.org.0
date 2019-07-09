Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3D57163744
	for <lists+kvm@lfdr.de>; Tue,  9 Jul 2019 15:48:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727074AbfGINsj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Jul 2019 09:48:39 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:26642 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725947AbfGINsj (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 9 Jul 2019 09:48:39 -0400
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x69Dm93h063485;
        Tue, 9 Jul 2019 09:48:16 -0400
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2tmtk6mafs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 09 Jul 2019 09:48:14 -0400
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id x69Dj0BW015194;
        Tue, 9 Jul 2019 13:46:52 GMT
Received: from b01cxnp22035.gho.pok.ibm.com (b01cxnp22035.gho.pok.ibm.com [9.57.198.25])
        by ppma03dal.us.ibm.com with ESMTP id 2tjk96n9gk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 09 Jul 2019 13:46:52 +0000
Received: from b01ledav006.gho.pok.ibm.com (b01ledav006.gho.pok.ibm.com [9.57.199.111])
        by b01cxnp22035.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x69DkpKa45678934
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 9 Jul 2019 13:46:51 GMT
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BB885AC062;
        Tue,  9 Jul 2019 13:46:51 +0000 (GMT)
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id ACA01AC05E;
        Tue,  9 Jul 2019 13:46:51 +0000 (GMT)
Received: from [9.56.58.103] (unknown [9.56.58.103])
        by b01ledav006.gho.pok.ibm.com (Postfix) with ESMTP;
        Tue,  9 Jul 2019 13:46:51 +0000 (GMT)
Subject: Re: [RFC v2 4/5] vfio-ccw: Don't call cp_free if we are processing a
 channel program
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     farman@linux.ibm.com, pasic@linux.ibm.com,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org
References: <cover.1562616169.git.alifm@linux.ibm.com>
 <1405df8415d3bff446c22753d0e9b91ff246eb0f.1562616169.git.alifm@linux.ibm.com>
 <20190709121613.6a3554fa.cohuck@redhat.com>
From:   Farhan Ali <alifm@linux.ibm.com>
Message-ID: <45ad7230-3674-2601-af5b-d9beef9312be@linux.ibm.com>
Date:   Tue, 9 Jul 2019 09:46:51 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.4.0
MIME-Version: 1.0
In-Reply-To: <20190709121613.6a3554fa.cohuck@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-09_05:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1907090164
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 07/09/2019 06:16 AM, Cornelia Huck wrote:
> On Mon,  8 Jul 2019 16:10:37 -0400
> Farhan Ali <alifm@linux.ibm.com> wrote:
> 
>> There is a small window where it's possible that we could be working
>> on an interrupt (queued in the workqueue) and setting up a channel
>> program (i.e allocating memory, pinning pages, translating address).
>> This can lead to allocating and freeing the channel program at the
>> same time and can cause memory corruption.
>>
>> Let's not call cp_free if we are currently processing a channel program.
>> The only way we know for sure that we don't have a thread setting
>> up a channel program is when the state is set to VFIO_CCW_STATE_CP_PENDING.
> 
> Can we pinpoint a commit that introduced this bug, or has it been there
> since the beginning?
> 

I think the problem was always there.

>>
>> Signed-off-by: Farhan Ali <alifm@linux.ibm.com>
>> ---
>>   drivers/s390/cio/vfio_ccw_drv.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/s390/cio/vfio_ccw_drv.c b/drivers/s390/cio/vfio_ccw_drv.c
>> index 4e3a903..0357165 100644
>> --- a/drivers/s390/cio/vfio_ccw_drv.c
>> +++ b/drivers/s390/cio/vfio_ccw_drv.c
>> @@ -92,7 +92,7 @@ static void vfio_ccw_sch_io_todo(struct work_struct *work)
>>   		     (SCSW_ACTL_DEVACT | SCSW_ACTL_SCHACT));
>>   	if (scsw_is_solicited(&irb->scsw)) {
>>   		cp_update_scsw(&private->cp, &irb->scsw);
>> -		if (is_final)
>> +		if (is_final && private->state == VFIO_CCW_STATE_CP_PENDING)
>>   			cp_free(&private->cp);
>>   	}
>>   	mutex_lock(&private->io_mutex);
> 
> Reviewed-by: Cornelia Huck <cohuck@redhat.com>
> 
> 
Thanks for reviewing.

Thanks
Farhan
