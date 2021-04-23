Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47B11369668
	for <lists+kvm@lfdr.de>; Fri, 23 Apr 2021 17:53:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243018AbhDWPxq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Apr 2021 11:53:46 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:60676 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229691AbhDWPxq (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 23 Apr 2021 11:53:46 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 13NFp0j4177857;
        Fri, 23 Apr 2021 11:53:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=dSocCxnE/1eza4CfQ2181FKYT/pGEpmEtiThxIEpd3o=;
 b=VoGdgQkitAu76l4iL9WpsOWq57DzHPAlMv5hDIlHVy9QQJ0azD2FeGpk1o3gGON5xTcg
 Q1mHtSjmW2I4MmYEP5NN3SCzkPBxaUdUx7AGzTP3Xqj/ldaFLfsdRJQzfl32GHdeJ11V
 1Dg8O+l7q3TgYfxrGWt4zphwjoyFZCo8TS1blRHnzGibPKJDTf86puDE2I8/Jb9xUgVo
 Jl0gpj+V8PFAWubttUwddifblE8GZBZGql8ssbEKZyHSpO8KWI+OQMB6VonWeon6dqrO
 scxb7DJFUFgjeCPecDdgif1TaYCoTMWiqpKUtVr6maFRbKtrLO2xE30uYHPSVXk0JdCj Gw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 383y5g4t0e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 23 Apr 2021 11:53:08 -0400
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 13NFYL09107074;
        Fri, 23 Apr 2021 11:53:08 -0400
Received: from ppma05wdc.us.ibm.com (1b.90.2fa9.ip4.static.sl-reverse.com [169.47.144.27])
        by mx0a-001b2d01.pphosted.com with ESMTP id 383y5g4t06-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 23 Apr 2021 11:53:08 -0400
Received: from pps.filterd (ppma05wdc.us.ibm.com [127.0.0.1])
        by ppma05wdc.us.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 13NFr0Tm022782;
        Fri, 23 Apr 2021 15:53:07 GMT
Received: from b01cxnp22036.gho.pok.ibm.com (b01cxnp22036.gho.pok.ibm.com [9.57.198.26])
        by ppma05wdc.us.ibm.com with ESMTP id 37yqa9sv3c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 23 Apr 2021 15:53:07 +0000
Received: from b01ledav001.gho.pok.ibm.com (b01ledav001.gho.pok.ibm.com [9.57.199.106])
        by b01cxnp22036.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 13NFr7Uh11928544
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 23 Apr 2021 15:53:07 GMT
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7235328058;
        Fri, 23 Apr 2021 15:53:07 +0000 (GMT)
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E412D28064;
        Fri, 23 Apr 2021 15:53:06 +0000 (GMT)
Received: from farman-thinkpad-t470p (unknown [9.160.17.178])
        by b01ledav001.gho.pok.ibm.com (Postfix) with ESMTP;
        Fri, 23 Apr 2021 15:53:06 +0000 (GMT)
Message-ID: <c23691d7e4d0456dffbbeb1cea80fe3395f92c86.camel@linux.ibm.com>
Subject: Re: [RFC PATCH v4 0/4] vfio-ccw: Fix interrupt handling for
 HALT/CLEAR
From:   Eric Farman <farman@linux.ibm.com>
To:     Halil Pasic <pasic@linux.ibm.com>
Cc:     Cornelia Huck <cohuck@redhat.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Jared Rossi <jrossi@linux.ibm.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org
Date:   Fri, 23 Apr 2021 11:53:06 -0400
In-Reply-To: <20210423135015.5283edde.pasic@linux.ibm.com>
References: <20210413182410.1396170-1-farman@linux.ibm.com>
         <20210422025258.6ed7619d.pasic@linux.ibm.com>
         <1eb9cbdfe43a42a62f6afb0315bb1e3a103dac9a.camel@linux.ibm.com>
         <20210423135015.5283edde.pasic@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-14.el8) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 5D6xHIWdyXk8aaOUJFCBHYxgzIAm9ken
X-Proofpoint-GUID: 3dQ3EvdPrCWr-ythjp_a5cstdXNZYRV7
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-04-23_07:2021-04-23,2021-04-23 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 clxscore=1015
 mlxlogscore=999 priorityscore=1501 lowpriorityscore=0 suspectscore=0
 bulkscore=0 spamscore=0 adultscore=0 impostorscore=0 phishscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104230100
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 2021-04-23 at 13:50 +0200, Halil Pasic wrote:
> On Thu, 22 Apr 2021 16:49:21 -0400
> Eric Farman <farman@linux.ibm.com> wrote:
> 
> > On Thu, 2021-04-22 at 02:52 +0200, Halil Pasic wrote:
> > > On Tue, 13 Apr 2021 20:24:06 +0200
> > > Eric Farman <farman@linux.ibm.com> wrote:
> > >   
> > > > Hi Conny, Halil,
> > > > 
> > > > Let's restart our discussion about the collision between
> > > > interrupts
> > > > for
> > > > START SUBCHANNEL and HALT/CLEAR SUBCHANNEL. It's been a quarter
> > > > million
> > > > minutes (give or take), so here is the problematic scenario
> > > > again:
> > > > 
> > > > 	CPU 1			CPU 2
> > > >  1	CLEAR SUBCHANNEL
> > > >  2	fsm_irq()
> > > >  3				START SUBCHANNEL
> > > >  4	vfio_ccw_sch_io_todo()
> > > >  5				fsm_irq()
> > > >  6				vfio_ccw_sch_io_todo()
> > > > 
> > > > From the channel subsystem's point of view the CLEAR SUBCHANNEL
> > > > (step 1)
> > > > is complete once step 2 is called, as the Interrupt Response
> > > > Block
> > > > (IRB)
> > > > has been presented and the TEST SUBCHANNEL was driven by the
> > > > cio
> > > > layer.
> > > > Thus, the START SUBCHANNEL (step 3) is submitted [1] and gets a
> > > > cc=0 to
> > > > indicate the I/O was accepted. However, step 2 stacks the bulk
> > > > of
> > > > the
> > > > actual work onto a workqueue for when the subchannel lock is
> > > > NOT
> > > > held,
> > > > and is unqueued at step 4. That code misidentifies the data in
> > > > the
> > > > IRB
> > > > as being associated with the newly active I/O, and may release
> > > > memory
> > > > that is actively in use by the channel subsystem and/or device.
> > > > Eww.
> > > > 
> > > > In this version...
> > > > 
> > > > Patch 1 and 2 are defensive checks. Patch 2 was part of v3 [2],
> > > > but
> > > > I
> > > > would love a better option here to guard between steps 2 and 4.
> > > > 
> > > > Patch 3 is a subset of the removal of the CP_PENDING FSM state
> > > > in
> > > > v3.
> > > > I've obviously gone away from this idea, but I thought this
> > > > piece
> > > > is
> > > > still valuable.
> > > > 
> > > > Patch 4 collapses the code on the interrupt path so that
> > > > changes to
> > > > the FSM state and the channel_program struct are handled at the
> > > > same
> > > > point, rather than separated by a mutex boundary. Because of
> > > > the
> > > > possibility of a START and HALT/CLEAR running concurrently, it
> > > > does
> > > > not make sense to split them here.
> > > > 
> > > > With the above patches, maybe it then makes sense to hold the
> > > > io_mutex
> > > > across the entirety of vfio_ccw_sch_io_todo(). But I'm not
> > > > completely
> > > > sure that would be acceptable.
> > > > 
> > > > So... Thoughts?  
> > > 
> > > I believe we should address  
> > 
> > Who is the "we" here?
> > 
> 
> The people that are responsible for vfio-ccw. 
> 
> > >  the concurrency, encapsulation and layering
> > > issues in the subchannel/ccw pass-through code (vfio-ccw) by
> > > taking a
> > > holistic approach as soon as possible.
> > > 
> > > I find the current state of art very hard to reason about, and
> > > that
> > > adversely  affects my ability to reason about attempts at partial
> > > improvements.
> > > 
> > > I understand that such a holistic approach needs a lot of work,
> > > and
> > > we
> > > may have to stop some bleeding first. In the stop the bleeding
> > > phase
> > > we
> > > can take a pragmatic approach and accept changes that empirically
> > > seem to
> > > work towards stopping the bleeding. I.e. if your tests say it's
> > > better,
> > > I'm willing to accept that it is better.  
> > 
> > So much bleeding!
> > 
> > RE: my tests... I have only been seeing the described problem in
> > pathological tests, and this series lets those tests run without
> > issue.
> > 
> 
> Good to know.
> 
> > > I have to admit, I don't understand how synchronization is done
> > > in
> > > the
> > > vfio-ccw kernel module (in the sense of avoiding data races).
> > > 
> > > Regarding your patches, I have to admit, I have a hard time
> > > figuring
> > > out
> > > which one of these (or what combination of them) is supposed to
> > > solve
> > > the problem you described above. If I had to guess, I would guess
> > > it
> > > is
> > > either patch 4, because it has a similar scenario diagram in the
> > > commit message like the one in the problem statement. Is my guess
> > > right?  
> > 
> > Sort of. It is true that Patch 4 is the last piece of the puzzle,
> > and
> > the diagram is included in that commit message so it is kept with
> > the
> > change, instead of being lost with the cover letter.
> > 
> > As I said in the cover letter, "Patch 1 and 2 are defensive checks"
> > which are simply included to provide a more robust solution. You
> > could
> > argue that Patch 3 should be held out separately, but as it came
> > from
> > the previous version of this series it made sense to include here.
> > 
> 
> Does that mean we need patches 1, 2 and 4 to fix the issue or is just
> 4 sufficient?

Based on everything I understand, I would not feel comfortable with
only 4.

If you look at the commit message for patch 1, I do explain why its
absence is not exposing any serialization problems today. But as it is
part of the "CCW translation API" (documented in
Documentation/s390/vfio-ccw.rst) I feel it is important to include.

Something needs to be done in the transition described by Patch 2, even
though it still has problems in its current form.

> 
> > > If it is right I don't quite understand the mechanics of the fix,
> > > because what the patch seems to do is changing the content of
> > > step 4
> > > in
> > > the above diagram. And I don't see how is change that code
> > > so that it does not "misidentifies the data in the IRB as being
> > > associated with the newly active I/O".   
> > 
> > Consider that the cp_update_scsw() and cp_free() routines that get
> > called here are looking at the cp->initialized flag to determine
> > whether to perform any work. For a system that is otherwise idle,
> > the
> > cp->initialized flag will be false when processing an IRB related
> > to a
> > CSCH, meaning the bulk of this routine will be a NOP.
> > 
> > In the failing scenario, as I describe in the commit message for
> > patch
> > 4, we could be processing an interrupt that is unaffiliated with
> > the CP
> > that was (or is being) built. It need not even be a solicited
> > interrupt; it just happened that the CSCH interrupt is what got me
> > looking at this path. The whole situation boils down to the FSM
> > state
> > and cp->initialized flag being out of sync from one another after
> > coming through this function.
> > 
> 
> Thanks for the explanation. Since you are about to send out a new
> verison which I understand won't be just about cosmetic fixes, I
> won't
> invest any more in understanding this one. But I hope this will help
> me
> understand that one. 
> 
> > > Moreover patch 4 seems to rely on
> > > private->state which, AFAIR is still used in a racy fashion.
> > > 
> > > But if strong empirical evidence shows that it performs better
> > > (stops
> > > the bleeding), I think we can go ahead with it.  
> > 
> > Again with the bleeding. Is there a Doctor in the house? :)
> > 
> 
> Sorry if I expressed myself comically. Was not my intention. I'm
> puzzled.

No need to be sorry, and I didn't mean to offend you. The repeated use
of such a dramatic phrase struck me as humorous, because it conveyed a
much more prevalant problem than the one being fixed.

> 
> Is in your opinion the vfio-ccw kernel module data race free with
> this
> series applied?

I have no further concerns.

Eric

> 
> Regards,
> Halil

