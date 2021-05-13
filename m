Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C27537FD4B
	for <lists+kvm@lfdr.de>; Thu, 13 May 2021 20:33:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230332AbhEMSee (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 May 2021 14:34:34 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:4852 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230125AbhEMSee (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 13 May 2021 14:34:34 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14DIXMg2077401;
        Thu, 13 May 2021 14:33:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=RlzVUst0B2TXfJg48V/QH3bAxOQakqti0qe45OWkjdQ=;
 b=XBo1+mBe0ousiOSzFA4xU5qNhB56l61moQp0AoIRXV6ECtxTqXcWxh+swZkjCEktykgx
 mlsjW/bifC7+4DErm07yMT/3GSmQTgB7YDS/X8cGMVOgYIml9y2TGUP9DO5lEGclLwTl
 1fZIaViEGhrO/WOLKjLSqaVrYGUTFmC0LK/oatYYLuqoJ+R5XYZLi90teH0jp/pVZitl
 o8Sd7vsxiVrVxcDUsQBbsgOZIl852rQKYC3pVjh4m3lSRZt6VmdeAKlSR6VwVbnx4bjW
 yl+Gx0b3UioSeQVVjN4dxwJn1rggYDcJMEG/UKf2vpX9LDmUwTa2fcY4UZgL/dT2FaX6 Bg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 38h8wbgwe7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 13 May 2021 14:33:23 -0400
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 14DIXNmH077548;
        Thu, 13 May 2021 14:33:23 -0400
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0a-001b2d01.pphosted.com with ESMTP id 38h8wbgwdu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 13 May 2021 14:33:23 -0400
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 14DIDFLP013152;
        Thu, 13 May 2021 18:33:22 GMT
Received: from b01cxnp22034.gho.pok.ibm.com (b01cxnp22034.gho.pok.ibm.com [9.57.198.24])
        by ppma03dal.us.ibm.com with ESMTP id 38dj9a0jeg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 13 May 2021 18:33:22 +0000
Received: from b01ledav001.gho.pok.ibm.com (b01ledav001.gho.pok.ibm.com [9.57.199.106])
        by b01cxnp22034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 14DIXLqf35324202
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 13 May 2021 18:33:21 GMT
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9895728059;
        Thu, 13 May 2021 18:33:21 +0000 (GMT)
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E7A6028060;
        Thu, 13 May 2021 18:33:20 +0000 (GMT)
Received: from farman-thinkpad-t470p (unknown [9.160.49.189])
        by b01ledav001.gho.pok.ibm.com (Postfix) with ESMTP;
        Thu, 13 May 2021 18:33:20 +0000 (GMT)
Message-ID: <8224aa872f243610583aab327c7e0b813ddaf0dd.camel@linux.ibm.com>
Subject: Re: [PATCH v6 0/3] vfio-ccw: Fix interrupt handling for HALT/CLEAR
From:   Eric Farman <farman@linux.ibm.com>
To:     Halil Pasic <pasic@linux.ibm.com>
Cc:     Cornelia Huck <cohuck@redhat.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Jared Rossi <jrossi@linux.ibm.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org
Date:   Thu, 13 May 2021 14:33:20 -0400
In-Reply-To: <20210513030543.67601a8c.pasic@linux.ibm.com>
References: <20210511195631.3995081-1-farman@linux.ibm.com>
         <20210513030543.67601a8c.pasic@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-14.el8) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: Vh7pZw2v3cGEsOLwlRwAHA7Y3yLbAvg-
X-Proofpoint-ORIG-GUID: N9CKE4j6qfuG9i-ysitPxyxtZow_9eMT
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-13_12:2021-05-12,2021-05-13 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 spamscore=0
 lowpriorityscore=0 bulkscore=0 priorityscore=1501 malwarescore=0
 phishscore=0 clxscore=1015 mlxscore=0 suspectscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105130129
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2021-05-13 at 03:05 +0200, Halil Pasic wrote:
> On Tue, 11 May 2021 21:56:28 +0200
> Eric Farman <farman@linux.ibm.com> wrote:
> 
> > Hi Conny, Matt, Halil,
> > 
> > Here's one (last?) update to my proposal for handling the collision
> > between interrupts for START SUBCHANNEL and HALT/CLEAR SUBCHANNEL.
> > 
> > Only change here is to include Conny's suggestions on patch 3.
> > 
> > Thanks,
> 
> I believe these changes are beneficial, although I don't understand
> everything about them. In that sense I'm happy with the these getting
> merged.
> 
> Let me also spend some words answering the unasked question, what I'm
> not understanding about these.
> 
> Not understanding how the problem stated in the cover letter of v4 is
> actually resolved is certainly the most important one. 

Per our phone call last week, one of Conny's suggestions from that
particular version was related to vfio_ccw_sch_io_todo() and was giving
me some difficulties. We all agreed that I should send what I had, and
leave the other corner case(s) to be addressed later along with the
broader serialization topic throughout the driver. That is still my
intention, but I suspect that's where you are going here...

(I realize I said "last?" at the top here. Poor decision on my part.)

> Let me cite
> the relevant part of it (your cover letter already contains a link to
> the full version).
> 
> """
> 
> 	CPU 1			CPU 2
>  1	CLEAR SUBCHANNEL
>  2	fsm_irq()
>  3				START SUBCHANNEL
>  4	vfio_ccw_sch_io_todo()
>  5				fsm_irq()
>  6				vfio_ccw_sch_io_todo()
> 
> From the channel subsystem's point of view the CLEAR SUBCHANNEL (step
> 1)
> is complete once step 2 is called, as the Interrupt Response Block
> (IRB)
> has been presented and the TEST SUBCHANNEL was driven by the cio
> layer.
> Thus, the START SUBCHANNEL (step 3) is submitted [1] and gets a cc=0
> to
> indicate the I/O was accepted. However, step 2 stacks the bulk of the
> actual work onto a workqueue for when the subchannel lock is NOT
> held,
> and is unqueued at step 4. That code misidentifies the data in the
> IRB
> as being associated with the newly active I/O, and may release memory
> that is actively in use by the channel subsystem and/or device. Eww.
> """
> 
> The last sentence clearly states "may release memory that is actively
> used by ... the device", and I understood it refers to the invocation
> of cp_free() from vfio_ccw_sch_io_todo(). Patch 3 of this series does
> not change the conditions under which cp_free() is called.

Correct.

> 
> Looking at the cited diagram, since patch 3 changes things in
> vfio_ccw_sch_io_todo() it probably ain't affecting steps 1-3 and
> I understood the description so that bad free happens in step 4.

You are correct that patch 3 touches vfio_ccw_sch_io_todo(), but it is
not addressing the possibility of a bad free described in the old cover
letter. The commit message for patch 3 describes pretty clearly the
scenario in question.

> 
> My guess is that your change from patch 3 somehow via the fsm
> prevents
> the SSCH on CPU 2 (using the diagram) from being executed  if it
> actually
> happens to be after vfio_ccw_sch_io_todo(). 

That's an incorrect guess. The code in vfio_ccw_sch_io_todo() today
says "If another CPU is building an I/O (FSM is CP_PROCESSING), or
there is no CPU building an I/O (FSM is IDLE), then skip the cp_free()
call." The change in patch 3 says that in that situation, it should
also not adjust the FSM state because the interrupt being handled on
CPU1 was unrelated (maybe it was for a HALT/CLEAR, maybe it was an
unsolicited interrupt). The SSCH on CPU2 will still go on as expected.

> And patch 1 is supposed to
> prevent the SSCH on CPU2 from being executed in the depicted case
> because
> if there is a cp to free, then we would bail out form if we see it
> while processing the new IO request.

Not really. It's the FSM's job to prevent a second SSCH, and route to
fsm_io_retry() or fsm_io_busy() as appropriate. But the scenario
described by patch 3 in this series would leave the cp initialized,
while also resetting the FSM back to IDLE. As such, the FSM was free to
allow another SSCH in, which would then re-initialize the cp and orphan
the existing (active) cp resources.

With the application of patch 3, that concern isn't present, so the
change in patch 1 is really a NOP. But it allows for consistency in how
the cp_*() functions are working, and a safety valve should this
situation show up another way. (We'll get trace data that says
cp_init() bailed out, rather than going on as if nothing were wrong.)

> 
> In any case, I don't want to hold this up any further.
> 

Thanks for that. You are correct that there's still a potential issue
here, in the handoff between fsm_irq() and vfio_ccw_sch_io_todo(), and
another fsm_io_request() that would arrive between those points. But
it's not anything that we haven't already discussed, and will hopefully
begin discussing in the next couple of weeks.

Thanks,
Eric

> Regards,
> Halil

