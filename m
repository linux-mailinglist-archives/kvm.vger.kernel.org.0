Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 77D484EA14
	for <lists+kvm@lfdr.de>; Fri, 21 Jun 2019 16:00:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726097AbfFUOA6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Jun 2019 10:00:58 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:48418 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725985AbfFUOA6 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 21 Jun 2019 10:00:58 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5LDxl2E074616
        for <kvm@vger.kernel.org>; Fri, 21 Jun 2019 10:00:56 -0400
Received: from e06smtp02.uk.ibm.com (e06smtp02.uk.ibm.com [195.75.94.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2t900h1ud5-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 21 Jun 2019 10:00:55 -0400
Received: from localhost
        by e06smtp02.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <pasic@linux.ibm.com>;
        Fri, 21 Jun 2019 15:00:39 +0100
Received: from b06avi18878370.portsmouth.uk.ibm.com (9.149.26.194)
        by e06smtp02.uk.ibm.com (192.168.101.132) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Fri, 21 Jun 2019 15:00:36 +0100
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x5LE0ZnC25100596
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 Jun 2019 14:00:35 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 788CD4C06A;
        Fri, 21 Jun 2019 14:00:34 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 422434C07E;
        Fri, 21 Jun 2019 14:00:34 +0000 (GMT)
Received: from oc2783563651 (unknown [9.152.224.137])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 21 Jun 2019 14:00:34 +0000 (GMT)
Date:   Fri, 21 Jun 2019 16:00:32 +0200
From:   Halil Pasic <pasic@linux.ibm.com>
To:     Farhan Ali <alifm@linux.ibm.com>
Cc:     cohuck@redhat.com, farman@linux.ibm.com,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [RFC v1 1/1] vfio-ccw: Don't call cp_free if we are processing
 a channel program
In-Reply-To: <46dc0cbdcb8a414d70b7807fceb1cca6229408d5.1561055076.git.alifm@linux.ibm.com>
References: <cover.1561055076.git.alifm@linux.ibm.com>
        <46dc0cbdcb8a414d70b7807fceb1cca6229408d5.1561055076.git.alifm@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.31; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 19062114-0008-0000-0000-000002F5DAEB
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19062114-0009-0000-0000-00002262FFC6
Message-Id: <20190621160032.1bd0c15f.pasic@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-21_10:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=921 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906210117
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 20 Jun 2019 17:07:09 -0400
Farhan Ali <alifm@linux.ibm.com> wrote:

> There is a small window where it's possible that an interrupt can
> arrive and can call cp_free, while we are still processing a channel
> program (i.e allocating memory, pinnging pages, translating
> addresses etc). This can lead to allocating and freeing at the same
> time and can cause memory corruption.
> 
> Let's not call cp_free if we are currently processing a channel program.
> 
> Signed-off-by: Farhan Ali <alifm@linux.ibm.com>
> ---
> 
> I have been running my test overnight with this patch and I haven't
> seen the stack traces that I mentioned about earlier. I would like
> to get some reviews on this and also if this is the right thing to
> do?
> 
> Thanks
> Farhan
> 
>  drivers/s390/cio/vfio_ccw_drv.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/s390/cio/vfio_ccw_drv.c b/drivers/s390/cio/vfio_ccw_drv.c
> index 66a66ac..61ece3f 100644
> --- a/drivers/s390/cio/vfio_ccw_drv.c
> +++ b/drivers/s390/cio/vfio_ccw_drv.c
> @@ -88,7 +88,7 @@ static void vfio_ccw_sch_io_todo(struct work_struct *work)
>  		     (SCSW_ACTL_DEVACT | SCSW_ACTL_SCHACT));
>  	if (scsw_is_solicited(&irb->scsw)) {
>  		cp_update_scsw(&private->cp, &irb->scsw);
> -		if (is_final)
> +		if (is_final && private->state != VFIO_CCW_STATE_CP_PROCESSING)

How is access to private->state correctly synchronized? And don't we
expect private->state == VFIO_CCW_STATE_CP_PENDING in case the cp was
submitted successfully with a ssch() and is done now (one way or the
other)?

Does this have something to do with 71189f2 "vfio-ccw: make it safe to
access channel programs" (Cornelia Huck, 2019-01-21)?

Regards,
Halil

>  			cp_free(&private->cp);
>  	}
>  	mutex_lock(&private->io_mutex);

