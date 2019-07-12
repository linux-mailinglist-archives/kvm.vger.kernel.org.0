Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2661F66FF7
	for <lists+kvm@lfdr.de>; Fri, 12 Jul 2019 15:24:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727741AbfGLNX7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Jul 2019 09:23:59 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:22208 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726318AbfGLNX7 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 12 Jul 2019 09:23:59 -0400
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x6CDDZLt031341
        for <kvm@vger.kernel.org>; Fri, 12 Jul 2019 09:23:58 -0400
Received: from e11.ny.us.ibm.com (e11.ny.us.ibm.com [129.33.205.201])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2tprnbekuv-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 12 Jul 2019 09:23:58 -0400
Received: from localhost
        by e11.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <farman@linux.ibm.com>;
        Fri, 12 Jul 2019 14:23:56 +0100
Received: from b01cxnp22033.gho.pok.ibm.com (9.57.198.23)
        by e11.ny.us.ibm.com (146.89.104.198) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Fri, 12 Jul 2019 14:23:54 +0100
Received: from b01ledav001.gho.pok.ibm.com (b01ledav001.gho.pok.ibm.com [9.57.199.106])
        by b01cxnp22033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x6CDNrEj50201004
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 12 Jul 2019 13:23:53 GMT
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8AA6128059;
        Fri, 12 Jul 2019 13:23:53 +0000 (GMT)
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3CEBE28058;
        Fri, 12 Jul 2019 13:23:53 +0000 (GMT)
Received: from [9.85.144.233] (unknown [9.85.144.233])
        by b01ledav001.gho.pok.ibm.com (Postfix) with ESMTP;
        Fri, 12 Jul 2019 13:23:53 +0000 (GMT)
Subject: Re: [PATCH v3 4/5] vfio-ccw: Don't call cp_free if we are processing
 a channel program
To:     Farhan Ali <alifm@linux.ibm.com>, cohuck@redhat.com,
        pasic@linux.ibm.com
Cc:     linux-s390@vger.kernel.org, kvm@vger.kernel.org
References: <cover.1562854091.git.alifm@linux.ibm.com>
 <62e87bf67b38dc8d5760586e7c96d400db854ebe.1562854091.git.alifm@linux.ibm.com>
From:   Eric Farman <farman@linux.ibm.com>
Date:   Fri, 12 Jul 2019 09:19:38 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <62e87bf67b38dc8d5760586e7c96d400db854ebe.1562854091.git.alifm@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
x-cbid: 19071213-2213-0000-0000-000003ADA721
X-IBM-SpamModules-Scores: 
X-IBM-SpamModules-Versions: BY=3.00011415; HX=3.00000242; KW=3.00000007;
 PH=3.00000004; SC=3.00000286; SDB=6.01231109; UDB=6.00648508; IPR=6.01012394;
 MB=3.00027691; MTD=3.00000008; XFM=3.00000015; UTC=2019-07-12 13:23:56
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19071213-2214-0000-0000-00005F34800E
Message-Id: <32c1c941-2971-f956-c532-b606336ea74b@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-12_04:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1907120144
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 7/11/19 10:28 AM, Farhan Ali wrote:
> There is a small window where it's possible that we could be working
> on an interrupt (queued in the workqueue) and setting up a channel
> program (i.e allocating memory, pinning pages, translating address).
> This can lead to allocating and freeing the channel program at the
> same time and can cause memory corruption.
> 
> Let's not call cp_free if we are currently processing a channel program.
> The only way we know for sure that we don't have a thread setting
> up a channel program is when the state is set to VFIO_CCW_STATE_CP_PENDING.>
> Fixes: d5afd5d135c8 ("vfio-ccw: add handling for async channel instructions")
> Signed-off-by: Farhan Ali <alifm@linux.ibm.com>
> Reviewed-by: Cornelia Huck <cohuck@redhat.com>

I think this seems like a reasonable fix.

Reviewed-by: Eric Farman <farman@linux.ibm.com>

> ---
>  drivers/s390/cio/vfio_ccw_drv.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/s390/cio/vfio_ccw_drv.c b/drivers/s390/cio/vfio_ccw_drv.c
> index 4e3a903..0357165 100644
> --- a/drivers/s390/cio/vfio_ccw_drv.c
> +++ b/drivers/s390/cio/vfio_ccw_drv.c
> @@ -92,7 +92,7 @@ static void vfio_ccw_sch_io_todo(struct work_struct *work)
>  		     (SCSW_ACTL_DEVACT | SCSW_ACTL_SCHACT));
>  	if (scsw_is_solicited(&irb->scsw)) {
>  		cp_update_scsw(&private->cp, &irb->scsw);
> -		if (is_final)
> +		if (is_final && private->state == VFIO_CCW_STATE_CP_PENDING)
>  			cp_free(&private->cp);
>  	}
>  	mutex_lock(&private->io_mutex);
> 

