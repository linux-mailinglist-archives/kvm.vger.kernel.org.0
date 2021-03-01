Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB2613289F8
	for <lists+kvm@lfdr.de>; Mon,  1 Mar 2021 19:11:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238674AbhCASJS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Mar 2021 13:09:18 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:39960 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239286AbhCASIN (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 1 Mar 2021 13:08:13 -0500
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 121I5Hmn082609;
        Mon, 1 Mar 2021 13:07:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=F1hb+n5s2fmqDT5sJBOPJKoW/36d26E/grmNy+XIC2c=;
 b=UkVvL9VR6hetjnTkSAbt130igvHuDmro56EoCFzGF/vHfCsIZX3EvT88rqNlUNc7pvF0
 QSHLRxB4PgSSQgNj7QS7WZUv1Vzjmt1+XtqiKlzauFEBaGT6qJlYlPGPfFwYQL5WA+TD
 RdXVWXIajDfrzQ8oKYovdGmCF1U1eV2pbyXy/nH3eBsgjxbqcKoejEwbdqURusg6ipUL
 nVXtSR25eg5z1x4q9ObLjrTILrjMRLFj0nZ9HYGxXwldBGhaA1VVDpNeN2Md3SCuyew5
 1ZSrP8LHGaA1Jnf5httnN+GG66FsPAtJpJZ9hFl+MBwcunmeQ0jr1zR87rjDmgPIEpiQ BA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37106dbjac-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 01 Mar 2021 13:07:33 -0500
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 121I5JPf082782;
        Mon, 1 Mar 2021 13:07:33 -0500
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37106dbja3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 01 Mar 2021 13:07:32 -0500
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 121I21hZ027540;
        Mon, 1 Mar 2021 18:07:32 GMT
Received: from b03cxnp07029.gho.boulder.ibm.com (b03cxnp07029.gho.boulder.ibm.com [9.17.130.16])
        by ppma03dal.us.ibm.com with ESMTP id 37103vttew-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 01 Mar 2021 18:07:32 +0000
Received: from b03ledav005.gho.boulder.ibm.com (b03ledav005.gho.boulder.ibm.com [9.17.130.236])
        by b03cxnp07029.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 121I7Sel43516378
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 1 Mar 2021 18:07:28 GMT
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A479FBE05B;
        Mon,  1 Mar 2021 18:07:28 +0000 (GMT)
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 653FBBE04F;
        Mon,  1 Mar 2021 18:07:27 +0000 (GMT)
Received: from [9.65.212.95] (unknown [9.65.212.95])
        by b03ledav005.gho.boulder.ibm.com (Postfix) with ESMTP;
        Mon,  1 Mar 2021 18:07:27 +0000 (GMT)
Subject: Re: [PATCH] s390: cio: Return -EFAULT if copy_to_user() fails
To:     Heiko Carstens <hca@linux.ibm.com>, Wang Qing <wangqing@vivo.com>
Cc:     Cornelia Huck <cohuck@redhat.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Vineeth Vijayan <vneethv@linux.ibm.com>,
        Peter Oberparleiter <oberpar@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1614600093-13992-1-git-send-email-wangqing@vivo.com>
 <YDzob/k70ix1g0s+@osiris>
From:   Eric Farman <farman@linux.ibm.com>
Message-ID: <e7edc20c-49d7-9297-7d0e-01f8a55c9c37@linux.ibm.com>
Date:   Mon, 1 Mar 2021 13:07:26 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <YDzob/k70ix1g0s+@osiris>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-01_12:2021-03-01,2021-03-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 spamscore=0
 suspectscore=0 adultscore=0 mlxlogscore=999 priorityscore=1501
 lowpriorityscore=0 clxscore=1011 bulkscore=0 mlxscore=0 phishscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103010146
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 3/1/21 8:13 AM, Heiko Carstens wrote:
> On Mon, Mar 01, 2021 at 08:01:33PM +0800, Wang Qing wrote:
>> The copy_to_user() function returns the number of bytes remaining to be
>> copied, but we want to return -EFAULT if the copy doesn't complete.
>>
>> Signed-off-by: Wang Qing <wangqing@vivo.com>
>> ---
>>   drivers/s390/cio/vfio_ccw_ops.c | 4 ++--
>>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> Applied, thanks!
> 

There's a third copy_to_user() call in this same routine, that deserves 
the same treatment. I'll get that fixup applied.

Thanks,
Eric
