Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD13337B02D
	for <lists+kvm@lfdr.de>; Tue, 11 May 2021 22:38:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230097AbhEKUkA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 May 2021 16:40:00 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:13680 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229736AbhEKUj7 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 11 May 2021 16:39:59 -0400
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14BKWmXN146674;
        Tue, 11 May 2021 16:38:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=FP9DEa12D8Zn6/enLAJwPyNGBdGrZc65oF5h+ubOnHs=;
 b=M9F5aUiq1Tqv7rhyjyb8ncl6Ye6ALJ2lxLuB0RjkWVTRODJg9rNsEBSimShVYngxrKFq
 5/ykaa9ETjDRNwYsKM/KBSEB9oEplJrBqJfjU+Kn9WwDe1eCz1j0MbWFGbKCqtUo+Pnr
 yjZ0FIXDlyNYTG80yQKVMW0JllkGQyYsHwQKgfEcZBhcTOZKHleCDVQqmaFgJav/bz7s
 LA6HdbzpqGYKUvP1lG28MVtIrBJEsfsh3vUd84+2RofQVZgSN3h6umtCvZL1r4Wr/pFW
 yAz2j21G7AZJiryaP8Pj3+qY3P6AOFiiab3NkFkeB+xpxCpWUv+FFJCkac8cRr6lOtWU ZA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 38g10808h2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 11 May 2021 16:38:52 -0400
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 14BKXc8V001882;
        Tue, 11 May 2021 16:38:52 -0400
Received: from ppma01wdc.us.ibm.com (fd.55.37a9.ip4.static.sl-reverse.com [169.55.85.253])
        by mx0a-001b2d01.pphosted.com with ESMTP id 38g10808gf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 11 May 2021 16:38:52 -0400
Received: from pps.filterd (ppma01wdc.us.ibm.com [127.0.0.1])
        by ppma01wdc.us.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 14BKbwIM030870;
        Tue, 11 May 2021 20:38:51 GMT
Received: from b03cxnp08027.gho.boulder.ibm.com (b03cxnp08027.gho.boulder.ibm.com [9.17.130.19])
        by ppma01wdc.us.ibm.com with ESMTP id 38dj98rkr1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 11 May 2021 20:38:51 +0000
Received: from b03ledav002.gho.boulder.ibm.com (b03ledav002.gho.boulder.ibm.com [9.17.130.233])
        by b03cxnp08027.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 14BKcnaQ31785484
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 May 2021 20:38:49 GMT
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 94378136053;
        Tue, 11 May 2021 20:38:49 +0000 (GMT)
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 95D39136059;
        Tue, 11 May 2021 20:38:48 +0000 (GMT)
Received: from oc4221205838.ibm.com (unknown [9.211.43.140])
        by b03ledav002.gho.boulder.ibm.com (Postfix) with ESMTP;
        Tue, 11 May 2021 20:38:48 +0000 (GMT)
Subject: Re: [PATCH v6 2/3] vfio-ccw: Reset FSM state to IDLE inside FSM
To:     Eric Farman <farman@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Halil Pasic <pasic@linux.ibm.com>
Cc:     Jared Rossi <jrossi@linux.ibm.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org
References: <20210511195631.3995081-1-farman@linux.ibm.com>
 <20210511195631.3995081-3-farman@linux.ibm.com>
From:   Matthew Rosato <mjrosato@linux.ibm.com>
Message-ID: <751e15e8-d1df-6ec7-134b-f97b58bde6f5@linux.ibm.com>
Date:   Tue, 11 May 2021 16:38:47 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <20210511195631.3995081-3-farman@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: S-sS03pr492qY90YNCQjmebNgCo7A6QB
X-Proofpoint-ORIG-GUID: kb3yYvS1Ty0ZGS0mp3AKn5ZfK6vEk4hx
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-11_04:2021-05-11,2021-05-11 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 clxscore=1015
 mlxscore=0 bulkscore=0 phishscore=0 impostorscore=0 suspectscore=0
 mlxlogscore=999 spamscore=0 lowpriorityscore=0 adultscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105110139
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/11/21 3:56 PM, Eric Farman wrote:
> When an I/O request is made, the fsm_io_request() routine
> moves the FSM state from IDLE to CP_PROCESSING, and then
> fsm_io_helper() moves it to CP_PENDING if the START SUBCHANNEL
> received a cc0. Yet, the error case to go from CP_PROCESSING
> back to IDLE is done after the FSM call returns.
> 
> Let's move this up into the FSM proper, to provide some
> better symmetry when unwinding in this case.
> 
> Signed-off-by: Eric Farman <farman@linux.ibm.com>
> Reviewed-by: Cornelia Huck <cohuck@redhat.com>

Acked-by: Matthew Rosato <mjrosato@linux.ibm.com>

> ---
>   drivers/s390/cio/vfio_ccw_fsm.c | 1 +
>   drivers/s390/cio/vfio_ccw_ops.c | 2 --
>   2 files changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/drivers/s390/cio/vfio_ccw_fsm.c b/drivers/s390/cio/vfio_ccw_fsm.c
> index 23e61aa638e4..e435a9cd92da 100644
> --- a/drivers/s390/cio/vfio_ccw_fsm.c
> +++ b/drivers/s390/cio/vfio_ccw_fsm.c
> @@ -318,6 +318,7 @@ static void fsm_io_request(struct vfio_ccw_private *private,
>   	}
>   
>   err_out:
> +	private->state = VFIO_CCW_STATE_IDLE;
>   	trace_vfio_ccw_fsm_io_request(scsw->cmd.fctl, schid,
>   				      io_region->ret_code, errstr);
>   }
> diff --git a/drivers/s390/cio/vfio_ccw_ops.c b/drivers/s390/cio/vfio_ccw_ops.c
> index 767ac41686fe..5971641964c6 100644
> --- a/drivers/s390/cio/vfio_ccw_ops.c
> +++ b/drivers/s390/cio/vfio_ccw_ops.c
> @@ -276,8 +276,6 @@ static ssize_t vfio_ccw_mdev_write_io_region(struct vfio_ccw_private *private,
>   	}
>   
>   	vfio_ccw_fsm_event(private, VFIO_CCW_EVENT_IO_REQ);
> -	if (region->ret_code != 0)
> -		private->state = VFIO_CCW_STATE_IDLE;
>   	ret = (region->ret_code != 0) ? region->ret_code : count;
>   
>   out_unlock:
> 

