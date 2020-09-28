Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A7AE27ABF4
	for <lists+kvm@lfdr.de>; Mon, 28 Sep 2020 12:37:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726667AbgI1Khs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Sep 2020 06:37:48 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:60210 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726576AbgI1Khr (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 28 Sep 2020 06:37:47 -0400
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08SAUeHq145167;
        Mon, 28 Sep 2020 06:37:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=MtrwxyWrFvYnunZtd6yIx1cwXkZDozx9BbnSq/59vgc=;
 b=jruHA71TSV5UuMevJbl862Fm/nYcgSaKe+flDOkz1XjGz7EbOtwGX6WVDLcDIQxWUsGc
 5wFlGjSCJHKsdZAR6+4Brskb55smur2ii0Ds810hSMnlB7TzebxyuFZpfD20EHx6A6AM
 cTJwGA+mKq7t4BS4aXSf66Gp26gcP6j14SLIZA79kvUbYelYA/LSj9rzXOk4gzJQsVxK
 E7wA47/mjlOyzbgOvz68CzInEhNE82YfEujkOrGHH8+1zu12LH1k0HKwwf+EK1TOcTqI
 FLuAEHEophXEPG/6rlu+BMI+spn6mAH+YK0gTH5ztLEBGcfzP47yqAyS9dRhrLyVPvIv VA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 33uchp35wh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 28 Sep 2020 06:37:46 -0400
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 08SAUu7m146265;
        Mon, 28 Sep 2020 06:37:45 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0b-001b2d01.pphosted.com with ESMTP id 33uchp35w5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 28 Sep 2020 06:37:45 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 08SAb0sV006723;
        Mon, 28 Sep 2020 10:37:44 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma04ams.nl.ibm.com with ESMTP id 33sw97t11a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 28 Sep 2020 10:37:44 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 08SAbf9S29688128
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 28 Sep 2020 10:37:41 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 35AE211C04C;
        Mon, 28 Sep 2020 10:37:41 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DCF2611C04A;
        Mon, 28 Sep 2020 10:37:40 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.61.99])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 28 Sep 2020 10:37:40 +0000 (GMT)
Subject: Re: [PATCH v1 2/4] s390x: pv: implement routine to share/unshare
 memory
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, imbrenda@linux.ibm.com
References: <1601049764-11784-1-git-send-email-pmorel@linux.ibm.com>
 <1601049764-11784-3-git-send-email-pmorel@linux.ibm.com>
 <6c87a0ef-63ef-a0b8-58ff-d60e58bdb223@linux.ibm.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
Message-ID: <9aa7e0ab-7013-db0b-4af5-8015ade5c40c@linux.ibm.com>
Date:   Mon, 28 Sep 2020 12:37:40 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <6c87a0ef-63ef-a0b8-58ff-d60e58bdb223@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-28_07:2020-09-24,2020-09-28 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015
 priorityscore=1501 phishscore=0 lowpriorityscore=0 bulkscore=0 spamscore=0
 malwarescore=0 mlxscore=0 adultscore=0 impostorscore=0 mlxlogscore=999
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009280080
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2020-09-28 10:22, Janosch Frank wrote:
> On 9/25/20 6:02 PM, Pierre Morel wrote:
>> When communicating with the host we need to share part of
>> the memory.
>>
>> Let's implement the ultravisor calls for this.
>>
>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>> Suggested-by: Janosch Frank <frankja@linux.ibm.com>
>> ---
>>   lib/s390x/asm/uv.h | 33 +++++++++++++++++++++++++++++++++
>>   1 file changed, 33 insertions(+)
>>
>> diff --git a/lib/s390x/asm/uv.h b/lib/s390x/asm/uv.h
>> index 4c2fc48..19019e4 100644
>> --- a/lib/s390x/asm/uv.h
>> +++ b/lib/s390x/asm/uv.h
>> @@ -71,4 +71,37 @@ static inline int uv_call(unsigned long r1, unsigned long r2)
>>   	return cc;
>>   }
>>   
>> +static inline int share(unsigned long addr, u16 cmd)
>> +{
>> +	struct uv_cb_share uvcb = {
>> +		.header.cmd = cmd,
>> +		.header.len = sizeof(uvcb),
>> +		.paddr = addr
>> +	};
>> +
>> +	uv_call(0, (u64)&uvcb);
>> +	return uvcb.header.rc;
> 
> That's not a great idea, rc is > 1 for error codes...
> In the kernel we check for the cc instead since uv_call() has only 0/1
> as possible cc return values.

hum, Yes.
I will add some report too here in case of error.




-- 
Pierre Morel
IBM Lab Boeblingen
