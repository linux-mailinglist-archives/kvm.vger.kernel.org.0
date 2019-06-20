Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 174424DB36
	for <lists+kvm@lfdr.de>; Thu, 20 Jun 2019 22:27:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726233AbfFTU1Z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Jun 2019 16:27:25 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:37670 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726073AbfFTU1Y (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 20 Jun 2019 16:27:24 -0400
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5KKM1Uh005796
        for <kvm@vger.kernel.org>; Thu, 20 Jun 2019 16:27:24 -0400
Received: from e35.co.us.ibm.com (e35.co.us.ibm.com [32.97.110.153])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2t8g04jwh4-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 20 Jun 2019 16:27:24 -0400
Received: from localhost
        by e35.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <farman@linux.ibm.com>;
        Thu, 20 Jun 2019 21:27:23 +0100
Received: from b03cxnp08028.gho.boulder.ibm.com (9.17.130.20)
        by e35.co.us.ibm.com (192.168.1.135) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 20 Jun 2019 21:27:22 +0100
Received: from b03ledav006.gho.boulder.ibm.com (b03ledav006.gho.boulder.ibm.com [9.17.130.237])
        by b03cxnp08028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x5KKRKYW66519510
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 20 Jun 2019 20:27:20 GMT
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8A8ACC605F;
        Thu, 20 Jun 2019 20:27:20 +0000 (GMT)
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CFCEFC6057;
        Thu, 20 Jun 2019 20:27:19 +0000 (GMT)
Received: from [9.80.222.142] (unknown [9.80.222.142])
        by b03ledav006.gho.boulder.ibm.com (Postfix) with ESMTP;
        Thu, 20 Jun 2019 20:27:19 +0000 (GMT)
Subject: Re: [RFC v1 1/1] vfio-ccw: Don't call cp_free if we are processing a
 channel program
To:     Farhan Ali <alifm@linux.ibm.com>, cohuck@redhat.com
Cc:     pasic@linux.ibm.com, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org
References: <cover.1561055076.git.alifm@linux.ibm.com>
 <46dc0cbdcb8a414d70b7807fceb1cca6229408d5.1561055076.git.alifm@linux.ibm.com>
From:   Eric Farman <farman@linux.ibm.com>
Date:   Thu, 20 Jun 2019 16:27:19 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <46dc0cbdcb8a414d70b7807fceb1cca6229408d5.1561055076.git.alifm@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
x-cbid: 19062020-0012-0000-0000-000017467D2B
X-IBM-SpamModules-Scores: 
X-IBM-SpamModules-Versions: BY=3.00011298; HX=3.00000242; KW=3.00000007;
 PH=3.00000004; SC=3.00000286; SDB=6.01220852; UDB=6.00642265; IPR=6.01001991;
 MB=3.00027397; MTD=3.00000008; XFM=3.00000015; UTC=2019-06-20 20:27:23
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19062020-0013-0000-0000-000057C43BFA
Message-Id: <638804dc-53c0-ff2f-d123-13c257ad593f@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-20_14:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906200146
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 6/20/19 3:40 PM, Farhan Ali wrote:
> There is a small window where it's possible that an interrupt can
> arrive and can call cp_free, while we are still processing a channel
> program (i.e allocating memory, pinnging pages, translating

s/pinnging/pinning/

> addresses etc). This can lead to allocating and freeing at the same
> time and can cause memory corruption.
> 
> Let's not call cp_free if we are currently processing a channel program.

The check around this cp_free() call is for a solicited interrupt, so
it's presumably in response to a SSCH we issued.  But if we're still
processing a CP, then we hadn't issued the SSCH to the hardware yet.  So
what is this interrupt for?  Do the contents of irb.cpa provide any
clues, perhaps if it's in the current cp or for someone else?

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

As I alluded earlier, do we know this irb is for this cp?  If no, what
does this function end up putting in the scsw?

> -		if (is_final)
> +		if (is_final && private->state != VFIO_CCW_STATE_CP_PROCESSING)

In looking at how we set this state, and how we exit it, I see we do:

if SSCH got CC0, CP_PROCESSING -> CP_PENDING
if SSCH got !CC0, CP_PROCESSING -> IDLE

While the first scenario happens immediately after the SSCH instruction,
I guess it could be just tiny enough, like the io_trigger FSM patch I
sent a few weeks ago.

Meanwhile, the latter happens way after we return from the jump table.
So that scenario leaves considerable time for such an interrupt to
occur, though I don't understand why it would if we got a CC(1-3) on the
SSCH.

And anyway, the return from fsm_io_helper() in that case will also call
cp_free().  So why does the cp->initialized check provide protection
from a double-free in that direction, but not here?  I'm confused.

>  			cp_free(&private->cp);
>  	}
>  	mutex_lock(&private->io_mutex);
> 

