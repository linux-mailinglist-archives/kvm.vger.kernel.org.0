Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C6EC145A6D
	for <lists+kvm@lfdr.de>; Fri, 14 Jun 2019 12:30:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727074AbfFNKa2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Jun 2019 06:30:28 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:34466 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726693AbfFNKa2 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 14 Jun 2019 06:30:28 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5EARElW084952;
        Fri, 14 Jun 2019 06:30:11 -0400
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2t49j3gs87-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 14 Jun 2019 06:30:10 -0400
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id x5EAROXF000957;
        Fri, 14 Jun 2019 10:30:09 GMT
Received: from b01cxnp22036.gho.pok.ibm.com (b01cxnp22036.gho.pok.ibm.com [9.57.198.26])
        by ppma04dal.us.ibm.com with ESMTP id 2t1xj316jq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 14 Jun 2019 10:30:09 +0000
Received: from b01ledav005.gho.pok.ibm.com (b01ledav005.gho.pok.ibm.com [9.57.199.110])
        by b01cxnp22036.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x5EAU9Nv38011212
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 14 Jun 2019 10:30:09 GMT
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0052EAE06A;
        Fri, 14 Jun 2019 10:30:09 +0000 (GMT)
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B9C24AE066;
        Fri, 14 Jun 2019 10:30:08 +0000 (GMT)
Received: from [9.85.188.22] (unknown [9.85.188.22])
        by b01ledav005.gho.pok.ibm.com (Postfix) with ESMTP;
        Fri, 14 Jun 2019 10:30:08 +0000 (GMT)
Subject: Re: [PATCH v2 9/9] s390/cio: Combine direct and indirect CCW paths
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     Farhan Ali <alifm@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org
References: <20190606202831.44135-1-farman@linux.ibm.com>
 <20190606202831.44135-10-farman@linux.ibm.com>
 <20190614120111.00b4bd48.cohuck@redhat.com>
From:   Eric Farman <farman@linux.ibm.com>
Message-ID: <cd8dfb17-be1b-5edd-8849-1bbf47c9bfd6@linux.ibm.com>
Date:   Fri, 14 Jun 2019 06:30:08 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190614120111.00b4bd48.cohuck@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-14_05:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=686 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906140088
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 6/14/19 6:01 AM, Cornelia Huck wrote:
> On Thu,  6 Jun 2019 22:28:31 +0200
> Eric Farman <farman@linux.ibm.com> wrote:
> 
>> With both the direct-addressed and indirect-addressed CCW paths
>> simplified to this point, the amount of shared code between them is
>> (hopefully) more easily visible.  Move the processing of IDA-specific
>> bits into the direct-addressed path, and add some useful commentary of
>> what the individual pieces are doing.  This allows us to remove the
>> entire ccwchain_fetch_idal() routine and maintain a single function
>> for any non-TIC CCW.
>>
>> Signed-off-by: Eric Farman <farman@linux.ibm.com>
>> ---
>>  drivers/s390/cio/vfio_ccw_cp.c | 115 +++++++++++----------------------
>>  1 file changed, 39 insertions(+), 76 deletions(-)
> 
> Another nice cleanup :)

Thanks!  This one makes me feel warm and fuzzy having only CCW processor
to manage in the future.

> 
>>
>> diff --git a/drivers/s390/cio/vfio_ccw_cp.c b/drivers/s390/cio/vfio_ccw_cp.c
>> index 8205d0b527fc..90d86e1354c1 100644
>> --- a/drivers/s390/cio/vfio_ccw_cp.c
>> +++ b/drivers/s390/cio/vfio_ccw_cp.c
>> @@ -534,10 +534,12 @@ static int ccwchain_fetch_direct(struct ccwchain *chain,
> 
> The one minor thing I have is that the function name
> (ccwchain_fetch_direct) is now slightly confusing. But we can easily do
> a patch on top renaming it (if we can come up with a better name.)

Agreed!  Maybe just ccwchain_fetch() ?  Or perhaps ccwchain_fetch_ccw()
if that won't cause too much confusion with the ccwchain_handle_ccw()
called from cp_init().

> 
> Reviewed-by: Cornelia Huck <cohuck@redhat.com>
> 

Thanks for all of these!  :)
