Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A0FC37B037
	for <lists+kvm@lfdr.de>; Tue, 11 May 2021 22:45:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229917AbhEKUqw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 May 2021 16:46:52 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:5056 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229637AbhEKUqw (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 11 May 2021 16:46:52 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14BKY20j014812;
        Tue, 11 May 2021 16:45:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=1gL2UDWf+boB2tGHv/kF3gP+iQ8dP10AeqY7V0nHNkU=;
 b=lSd2V6JjlFvJZH2/uluYFHFQaM/V0prfzonfQXGNU032i5KAYDRHNQ0rWVbhO3VBIOFS
 rpAeEYBftOUS/V3JbZ2M1pxr4UBrsdEEPybkHWTQhMLe0HXQtMJ6FkGG4I/OtbfKycI3
 N0ahw/KzcTr5HJCq0nf2t0JB/ulq82r4EtvOo2UexwosWir7ww3Z+HbOJGbm4NGi99Ue
 LzQQAesh08E+N9jWagAiWEs6F5pktApUdAT2Yu2I4OdCX13yUd1DDeVB+SgOElSfKULJ
 8rmuBIDSyrLZV865gowpBwp8VEN5XywlPFHknAj/p+yqvn/kF08+Aiuqc7YsZ7HgH2Z/ Pg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 38g12ng85d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 11 May 2021 16:45:44 -0400
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 14BKaXXU023672;
        Tue, 11 May 2021 16:45:44 -0400
Received: from ppma01wdc.us.ibm.com (fd.55.37a9.ip4.static.sl-reverse.com [169.55.85.253])
        by mx0b-001b2d01.pphosted.com with ESMTP id 38g12ng857-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 11 May 2021 16:45:44 -0400
Received: from pps.filterd (ppma01wdc.us.ibm.com [127.0.0.1])
        by ppma01wdc.us.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 14BKj2MQ008449;
        Tue, 11 May 2021 20:45:43 GMT
Received: from b03cxnp08026.gho.boulder.ibm.com (b03cxnp08026.gho.boulder.ibm.com [9.17.130.18])
        by ppma01wdc.us.ibm.com with ESMTP id 38dj98rmr3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 11 May 2021 20:45:43 +0000
Received: from b03ledav002.gho.boulder.ibm.com (b03ledav002.gho.boulder.ibm.com [9.17.130.233])
        by b03cxnp08026.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 14BKjgqk26476928
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 May 2021 20:45:42 GMT
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 480B413604F;
        Tue, 11 May 2021 20:45:42 +0000 (GMT)
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9244F136051;
        Tue, 11 May 2021 20:45:41 +0000 (GMT)
Received: from oc4221205838.ibm.com (unknown [9.211.43.140])
        by b03ledav002.gho.boulder.ibm.com (Postfix) with ESMTP;
        Tue, 11 May 2021 20:45:41 +0000 (GMT)
Subject: Re: [PATCH v6 3/3] vfio-ccw: Serialize FSM IDLE state with I/O
 completion
To:     Eric Farman <farman@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Halil Pasic <pasic@linux.ibm.com>
Cc:     Jared Rossi <jrossi@linux.ibm.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org
References: <20210511195631.3995081-1-farman@linux.ibm.com>
 <20210511195631.3995081-4-farman@linux.ibm.com>
From:   Matthew Rosato <mjrosato@linux.ibm.com>
Message-ID: <9e8934bd-a832-984f-18f7-e7e66c4db6cf@linux.ibm.com>
Date:   Tue, 11 May 2021 16:45:40 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <20210511195631.3995081-4-farman@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: uwK0fSqZk9jvMgTM17NHJIZLqA4NARUj
X-Proofpoint-ORIG-GUID: 7rH9LXMcJ0Cgu6_sYKLiUTka4_kWOfyy
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-11_04:2021-05-11,2021-05-11 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0
 priorityscore=1501 impostorscore=0 malwarescore=0 suspectscore=0
 clxscore=1015 phishscore=0 lowpriorityscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105110139
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/11/21 3:56 PM, Eric Farman wrote:
> Today, the stacked call to vfio_ccw_sch_io_todo() does three things:
> 
>    1) Update a solicited IRB with CP information, and release the CP
>       if the interrupt was the end of a START operation.
>    2) Copy the IRB data into the io_region, under the protection of
>       the io_mutex
>    3) Reset the vfio-ccw FSM state to IDLE to acknowledge that
>       vfio-ccw can accept more work.
> 
> The trouble is that step 3 is (A) invoked for both solicited and
> unsolicited interrupts, and (B) sitting after the mutex for step 2.
> This second piece becomes a problem if it processes an interrupt
> for a CLEAR SUBCHANNEL while another thread initiates a START,
> thus allowing the CP and FSM states to get out of sync. That is:
> 
>      CPU 1                           CPU 2
>      fsm_do_clear()
>      fsm_irq()
>                                      fsm_io_request()
>      vfio_ccw_sch_io_todo()
>                                      fsm_io_helper()
> 
> Since the FSM state and CP should be kept in sync, let's make a
> note when the CP is released, and rely on that as an indication
> that the FSM should also be reset at the end of this routine and
> open up the device for more work.
> 
> Signed-off-by: Eric Farman <farman@linux.ibm.com>

Thanks for the detailed commit message and comment block -- this makes 
sense to me.

Acked-by: Matthew Rosato <mjrosato@linux.ibm.com>

> ---
>   drivers/s390/cio/vfio_ccw_drv.c | 12 ++++++++++--
>   1 file changed, 10 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/s390/cio/vfio_ccw_drv.c b/drivers/s390/cio/vfio_ccw_drv.c
> index 8c625b530035..9b61e9b131ad 100644
> --- a/drivers/s390/cio/vfio_ccw_drv.c
> +++ b/drivers/s390/cio/vfio_ccw_drv.c
> @@ -86,6 +86,7 @@ static void vfio_ccw_sch_io_todo(struct work_struct *work)
>   	struct vfio_ccw_private *private;
>   	struct irb *irb;
>   	bool is_final;
> +	bool cp_is_finished = false;
>   
>   	private = container_of(work, struct vfio_ccw_private, io_work);
>   	irb = &private->irb;
> @@ -94,14 +95,21 @@ static void vfio_ccw_sch_io_todo(struct work_struct *work)
>   		     (SCSW_ACTL_DEVACT | SCSW_ACTL_SCHACT));
>   	if (scsw_is_solicited(&irb->scsw)) {
>   		cp_update_scsw(&private->cp, &irb->scsw);
> -		if (is_final && private->state == VFIO_CCW_STATE_CP_PENDING)
> +		if (is_final && private->state == VFIO_CCW_STATE_CP_PENDING) {
>   			cp_free(&private->cp);
> +			cp_is_finished = true;
> +		}
>   	}
>   	mutex_lock(&private->io_mutex);
>   	memcpy(private->io_region->irb_area, irb, sizeof(*irb));
>   	mutex_unlock(&private->io_mutex);
>   
> -	if (private->mdev && is_final)
> +	/*
> +	 * Reset to IDLE only if processing of a channel program
> +	 * has finished. Do not overwrite a possible processing
> +	 * state if the final interrupt was for HSCH or CSCH.
> +	 */
> +	if (private->mdev && cp_is_finished)
>   		private->state = VFIO_CCW_STATE_IDLE;
>   
>   	if (private->io_trigger)
> 

