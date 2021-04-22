Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B99436883C
	for <lists+kvm@lfdr.de>; Thu, 22 Apr 2021 22:49:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237063AbhDVUuA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Apr 2021 16:50:00 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:24608 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236851AbhDVUuA (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 22 Apr 2021 16:50:00 -0400
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 13MKXlOD152576;
        Thu, 22 Apr 2021 16:49:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=BbwCB/8MjB6byr7m4mjFYrmXLfkxNyZa/delVaGQsjA=;
 b=pkpOXmDblBh6veMsYDt873fZLum+PkjCNDyGOl9fcj6hFGljico2T7MQQrj7i2HuaQyF
 vy5wcrEWmrHKrFi6bZvMRmWLPbm0+yYNLTYdjcweKg93JyHPXyW6eWFigkEBzq82kWrD
 bGtJLy1T19uUyYLJQrym2/P14aXQw/7ZM8XoxCO4vPyUkB3aD1IP2i7mOzpiltx2Vkyj
 jcC2LuKlgucfYpQGJzRqFf6sHVa9Tp/nwcMzrYlDtj1enZ5DfH3tjR3ogWHYeVZCB+bJ
 DqnBl7F26HsjQdaxq+beDmfYPHr4dWx7qDxPxNnUlexhVTFvx4U7g7q4Lp5iow476HEA rg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3838hkpucy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 22 Apr 2021 16:49:24 -0400
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 13MKXlqm152652;
        Thu, 22 Apr 2021 16:49:24 -0400
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3838hkpucs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 22 Apr 2021 16:49:24 -0400
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 13MKguKc010267;
        Thu, 22 Apr 2021 20:49:23 GMT
Received: from b01cxnp22033.gho.pok.ibm.com (b01cxnp22033.gho.pok.ibm.com [9.57.198.23])
        by ppma02dal.us.ibm.com with ESMTP id 37yqaay8j6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 22 Apr 2021 20:49:23 +0000
Received: from b01ledav002.gho.pok.ibm.com (b01ledav002.gho.pok.ibm.com [9.57.199.107])
        by b01cxnp22033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 13MKnMcV29622648
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 22 Apr 2021 20:49:22 GMT
Received: from b01ledav002.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AD023124055;
        Thu, 22 Apr 2021 20:49:22 +0000 (GMT)
Received: from b01ledav002.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3178B124052;
        Thu, 22 Apr 2021 20:49:22 +0000 (GMT)
Received: from farman-thinkpad-t470p (unknown [9.160.17.178])
        by b01ledav002.gho.pok.ibm.com (Postfix) with ESMTP;
        Thu, 22 Apr 2021 20:49:22 +0000 (GMT)
Message-ID: <1eb9cbdfe43a42a62f6afb0315bb1e3a103dac9a.camel@linux.ibm.com>
Subject: Re: [RFC PATCH v4 0/4] vfio-ccw: Fix interrupt handling for
 HALT/CLEAR
From:   Eric Farman <farman@linux.ibm.com>
To:     Halil Pasic <pasic@linux.ibm.com>
Cc:     Cornelia Huck <cohuck@redhat.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Jared Rossi <jrossi@linux.ibm.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org
Date:   Thu, 22 Apr 2021 16:49:21 -0400
In-Reply-To: <20210422025258.6ed7619d.pasic@linux.ibm.com>
References: <20210413182410.1396170-1-farman@linux.ibm.com>
         <20210422025258.6ed7619d.pasic@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-14.el8) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: TBrSFBYFlBNHdA14wW4XiGvy9OkPsgAp
X-Proofpoint-GUID: KTnLqzCbSckwAk9zKAy1XnQfTsb4nPq7
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-04-22_14:2021-04-22,2021-04-22 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 impostorscore=0
 mlxscore=0 malwarescore=0 priorityscore=1501 spamscore=0 bulkscore=0
 suspectscore=0 phishscore=0 clxscore=1015 mlxlogscore=999
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104220153
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2021-04-22 at 02:52 +0200, Halil Pasic wrote:
> On Tue, 13 Apr 2021 20:24:06 +0200
> Eric Farman <farman@linux.ibm.com> wrote:
> 
> > Hi Conny, Halil,
> > 
> > Let's restart our discussion about the collision between interrupts
> > for
> > START SUBCHANNEL and HALT/CLEAR SUBCHANNEL. It's been a quarter
> > million
> > minutes (give or take), so here is the problematic scenario again:
> > 
> > 	CPU 1			CPU 2
> >  1	CLEAR SUBCHANNEL
> >  2	fsm_irq()
> >  3				START SUBCHANNEL
> >  4	vfio_ccw_sch_io_todo()
> >  5				fsm_irq()
> >  6				vfio_ccw_sch_io_todo()
> > 
> > From the channel subsystem's point of view the CLEAR SUBCHANNEL
> > (step 1)
> > is complete once step 2 is called, as the Interrupt Response Block
> > (IRB)
> > has been presented and the TEST SUBCHANNEL was driven by the cio
> > layer.
> > Thus, the START SUBCHANNEL (step 3) is submitted [1] and gets a
> > cc=0 to
> > indicate the I/O was accepted. However, step 2 stacks the bulk of
> > the
> > actual work onto a workqueue for when the subchannel lock is NOT
> > held,
> > and is unqueued at step 4. That code misidentifies the data in the
> > IRB
> > as being associated with the newly active I/O, and may release
> > memory
> > that is actively in use by the channel subsystem and/or device.
> > Eww.
> > 
> > In this version...
> > 
> > Patch 1 and 2 are defensive checks. Patch 2 was part of v3 [2], but
> > I
> > would love a better option here to guard between steps 2 and 4.
> > 
> > Patch 3 is a subset of the removal of the CP_PENDING FSM state in
> > v3.
> > I've obviously gone away from this idea, but I thought this piece
> > is
> > still valuable.
> > 
> > Patch 4 collapses the code on the interrupt path so that changes to
> > the FSM state and the channel_program struct are handled at the
> > same
> > point, rather than separated by a mutex boundary. Because of the
> > possibility of a START and HALT/CLEAR running concurrently, it does
> > not make sense to split them here.
> > 
> > With the above patches, maybe it then makes sense to hold the
> > io_mutex
> > across the entirety of vfio_ccw_sch_io_todo(). But I'm not
> > completely
> > sure that would be acceptable.
> > 
> > So... Thoughts?
> 
> I believe we should address

Who is the "we" here?

>  the concurrency, encapsulation and layering
> issues in the subchannel/ccw pass-through code (vfio-ccw) by taking a
> holistic approach as soon as possible.
> 
> I find the current state of art very hard to reason about, and that
> adversely  affects my ability to reason about attempts at partial
> improvements.
> 
> I understand that such a holistic approach needs a lot of work, and
> we
> may have to stop some bleeding first. In the stop the bleeding phase
> we
> can take a pragmatic approach and accept changes that empirically
> seem to
> work towards stopping the bleeding. I.e. if your tests say it's
> better,
> I'm willing to accept that it is better.

So much bleeding!

RE: my tests... I have only been seeing the described problem in
pathological tests, and this series lets those tests run without issue.

> 
> I have to admit, I don't understand how synchronization is done in
> the
> vfio-ccw kernel module (in the sense of avoiding data races).
> 
> Regarding your patches, I have to admit, I have a hard time figuring
> out
> which one of these (or what combination of them) is supposed to solve
> the problem you described above. If I had to guess, I would guess it
> is
> either patch 4, because it has a similar scenario diagram in the
> commit message like the one in the problem statement. Is my guess
> right?

Sort of. It is true that Patch 4 is the last piece of the puzzle, and
the diagram is included in that commit message so it is kept with the
change, instead of being lost with the cover letter.

As I said in the cover letter, "Patch 1 and 2 are defensive checks"
which are simply included to provide a more robust solution. You could
argue that Patch 3 should be held out separately, but as it came from
the previous version of this series it made sense to include here.

> 
> If it is right I don't quite understand the mechanics of the fix,
> because what the patch seems to do is changing the content of step 4
> in
> the above diagram. And I don't see how is change that code
> so that it does not "misidentifies the data in the IRB as being
> associated with the newly active I/O". 

Consider that the cp_update_scsw() and cp_free() routines that get
called here are looking at the cp->initialized flag to determine
whether to perform any work. For a system that is otherwise idle, the
cp->initialized flag will be false when processing an IRB related to a
CSCH, meaning the bulk of this routine will be a NOP.

In the failing scenario, as I describe in the commit message for patch
4, we could be processing an interrupt that is unaffiliated with the CP
that was (or is being) built. It need not even be a solicited
interrupt; it just happened that the CSCH interrupt is what got me
looking at this path. The whole situation boils down to the FSM state
and cp->initialized flag being out of sync from one another after
coming through this function.

> Moreover patch 4 seems to rely on
> private->state which, AFAIR is still used in a racy fashion.
> 
> But if strong empirical evidence shows that it performs better (stops
> the bleeding), I think we can go ahead with it.

Again with the bleeding. Is there a Doctor in the house? :)

Eric

> 
> Regards,
> Halil
> 
> 
> 
> 
> 
> 
> 

