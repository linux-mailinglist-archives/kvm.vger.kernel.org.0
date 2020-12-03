Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E8BE2CDE9E
	for <lists+kvm@lfdr.de>; Thu,  3 Dec 2020 20:17:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729248AbgLCTPj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Dec 2020 14:15:39 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:52630 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726829AbgLCTPj (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 3 Dec 2020 14:15:39 -0500
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0B3J2AP7144237;
        Thu, 3 Dec 2020 14:14:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=sxUfLc0WsUlnI3s6mQc/gnCFxbAMIxUa9zBeXAumMvQ=;
 b=ilDKDVbIrCWnweRx2BwT2ZLaNR8ACV2HomgHr2JuB3O76a3wAQNyleedy1z2KLi4PkG3
 F119veb9BWWsOKdc3h302HePuL+oUcRsC956GsFyK7GJUHC22DKUZS8zfolia0hNSE3n
 tGR+RHlTbzTdXpb6HbycRMjAgOOzh01+z8ARYpSazisQLm0rUB3OcEbuXsDXgE+CwaLv
 y/wJKvblq6vsEH2mh2CMfgxuJHp7Nf3gXKDyaPrwEPTw7FbyDSexEfcxGYWAg92W9c3L
 PntRgEJSryAhXPLp/9pkeplUE8Z9md60of+PZKyTqkvRg/eR/h+XobKESV6En2Ev83Oy Xw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3573jf4wtm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 03 Dec 2020 14:14:56 -0500
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0B3J2HsI145053;
        Thu, 3 Dec 2020 14:14:55 -0500
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3573jf4wt4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 03 Dec 2020 14:14:55 -0500
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0B3Ivh0R006586;
        Thu, 3 Dec 2020 19:14:54 GMT
Received: from b01cxnp22036.gho.pok.ibm.com (b01cxnp22036.gho.pok.ibm.com [9.57.198.26])
        by ppma03dal.us.ibm.com with ESMTP id 356xqhbtqf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 03 Dec 2020 19:14:54 +0000
Received: from b01ledav004.gho.pok.ibm.com (b01ledav004.gho.pok.ibm.com [9.57.199.109])
        by b01cxnp22036.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0B3JEs4a20841264
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 3 Dec 2020 19:14:54 GMT
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EBA13112061;
        Thu,  3 Dec 2020 19:14:53 +0000 (GMT)
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6AE3B112063;
        Thu,  3 Dec 2020 19:14:53 +0000 (GMT)
Received: from cpe-66-24-58-13.stny.res.rr.com (unknown [9.85.195.249])
        by b01ledav004.gho.pok.ibm.com (Postfix) with ESMTP;
        Thu,  3 Dec 2020 19:14:53 +0000 (GMT)
Subject: Re: [PATCH] s390/vfio-ap: Clean up vfio_ap resources when KVM pointer
 invalidated
To:     Halil Pasic <pasic@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, borntraeger@de.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com, david@redhat.com
References: <20201202234101.32169-1-akrowiak@linux.ibm.com>
 <20201203111907.72a89884.cohuck@redhat.com>
 <20201203180141.19425931.pasic@linux.ibm.com>
From:   Tony Krowiak <akrowiak@linux.ibm.com>
Message-ID: <3299bd03-f0b8-39ac-4f0e-04bd198633fa@linux.ibm.com>
Date:   Thu, 3 Dec 2020 14:14:52 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20201203180141.19425931.pasic@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-12-03_11:2020-12-03,2020-12-03 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 impostorscore=0 suspectscore=3 phishscore=0 clxscore=1015 malwarescore=0
 adultscore=0 lowpriorityscore=0 mlxscore=0 mlxlogscore=859 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012030109
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 12/3/20 12:01 PM, Halil Pasic wrote:
> On Thu, 3 Dec 2020 11:19:07 +0100
> Cornelia Huck <cohuck@redhat.com> wrote:
>
>>> @@ -1095,7 +1106,7 @@ static int vfio_ap_mdev_group_notifier(struct notifier_block *nb,
>>>   	matrix_mdev = container_of(nb, struct ap_matrix_mdev, group_notifier);
>>>   
>>>   	if (!data) {
>>> -		matrix_mdev->kvm = NULL;
>>> +		vfio_ap_mdev_put_kvm(matrix_mdev);
>> Hm. I'm wondering whether you need to hold the maxtrix_dev lock here as
>> well?
> In v12 we eventually did come along and patch "s390/vfio-ap: allow hot
> plug/unplug of AP resources using mdev device" made this a part of a
> critical section protected by the matrix_dev->lock.
>
> IMHO the cleanup should definitely happen with the matrix_dev->lock held.

Agreed!

>
> Regards,
> Halil

