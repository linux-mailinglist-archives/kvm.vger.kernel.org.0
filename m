Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B07054E87C
	for <lists+kvm@lfdr.de>; Thu, 16 Jun 2022 19:14:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377997AbiFPROb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Jun 2022 13:14:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377733AbiFPROZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Jun 2022 13:14:25 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74D251C108;
        Thu, 16 Jun 2022 10:14:24 -0700 (PDT)
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25GGMj6d029633;
        Thu, 16 Jun 2022 17:14:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=cPEBR1gU2twzzKI4QjL39+4s4u9zd8v3uWZlOmC8MjQ=;
 b=YNCSB3fxuJAExjGLNjqO80YrRwys1K8pmMsrUfjV4Hn0C5ZT0bNW2L7/j+12RzUAisWc
 Vfnp+1hYrX/o/IVfryZ8x/TlGKup5AvKmYSvfOgckJ+N/Osijcqv0IfEJGBWzolyPOzM
 vgWeREclM8yS8qFpPAe7g35RFfxk7olnjDYAdYiUxdTX9dQJLli0LshPqgcfZ0qhfbm4
 /RQQickbTLqHb34xvCP6KtCZRkJWdKPUPz5n0L9CV/trdW7PsfVp5BXALAgCyODFp3Nk
 vuHT1db4/WEFCA6jQ8C++0ai5F0q+t3TjxMPpf2E+3srD3JkGo1K3rZUKofui/J+Tf04 uQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gqgytnvfb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 16 Jun 2022 17:14:22 +0000
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 25GG49WW021389;
        Thu, 16 Jun 2022 17:14:21 GMT
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gqgytnvew-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 16 Jun 2022 17:14:21 +0000
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 25GH80CA011281;
        Thu, 16 Jun 2022 17:14:20 GMT
Received: from b01cxnp22033.gho.pok.ibm.com (b01cxnp22033.gho.pok.ibm.com [9.57.198.23])
        by ppma02dal.us.ibm.com with ESMTP id 3gmjpakwe7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 16 Jun 2022 17:14:20 +0000
Received: from b01ledav005.gho.pok.ibm.com (b01ledav005.gho.pok.ibm.com [9.57.199.110])
        by b01cxnp22033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 25GHEJ4x15728926
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Jun 2022 17:14:19 GMT
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B7600AE05F;
        Thu, 16 Jun 2022 17:14:19 +0000 (GMT)
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4D982AE05C;
        Thu, 16 Jun 2022 17:14:18 +0000 (GMT)
Received: from farman-thinkpad-t470p (unknown [9.211.62.157])
        by b01ledav005.gho.pok.ibm.com (Postfix) with ESMTP;
        Thu, 16 Jun 2022 17:14:18 +0000 (GMT)
Message-ID: <a1fd40e16fd4feb88b3f538e02319267d6901475.camel@linux.ibm.com>
Subject: Re: [PATCH v2 07/10] vfio/ccw: Create an OPEN FSM Event
From:   Eric Farman <farman@linux.ibm.com>
To:     Matthew Rosato <mjrosato@linux.ibm.com>
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Halil Pasic <pasic@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Date:   Thu, 16 Jun 2022 13:14:16 -0400
In-Reply-To: <0816ab3a-8601-0462-6c2b-4ba7fa8a1e2b@linux.ibm.com>
References: <20220615203318.3830778-1-farman@linux.ibm.com>
         <20220615203318.3830778-8-farman@linux.ibm.com>
         <0816ab3a-8601-0462-6c2b-4ba7fa8a1e2b@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-18.el8) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: AXPt8elTIl48zxQBP97gfypFDfx3ac6W
X-Proofpoint-GUID: pCRxnDe65lRL0HXIPVfgpFY00NzW2bLs
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-16_14,2022-06-16_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=923
 suspectscore=0 bulkscore=0 clxscore=1015 adultscore=0 priorityscore=1501
 impostorscore=0 malwarescore=0 mlxscore=0 spamscore=0 lowpriorityscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206160071
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2022-06-16 at 12:33 -0400, Matthew Rosato wrote:
> On 6/15/22 4:33 PM, Eric Farman wrote:
> > Move the process of enabling a subchannel for use by vfio-ccw
> > into the FSM, such that it can manage the sequence of lifecycle
> > events for the device.
> > 
> > That is, if the FSM state is NOT_OPER(erational), then do the work
> > that would enable the subchannel and move the FSM to STANDBY state.
> > An attempt to perform this event again from any of the other
> > operating
> > states (IDLE, CP_PROCESSING, CP_PENDING) will convert the device
> > back
> > to NOT_OPER so the configuration process can be started again.
> 
> Except STANDBY, which ignores the event via fsm_nop.  I wonder
> though, 
> whether that's the right thing to do.  For each of the other states 
> you're saying 'if it's already open, go back to NOT_OPER so we can
> start 
> over' -- In this case a STANDBY->STANDBY is also a case of 'it's
> already 
> open' so shouldn't we also go back to NOT_OPER so we can start over?

Yeah, the subchannel's already been probed but the mdev hasn't yet. (Or
perhaps it did, but that failed.) I was viewing it as a "well there's
nothing to do here" but you're right that the rest of the entries take
a "oh that's unexpected, go to NOT_OPER" approach. So should make that
consistent here, since it would be quite a surprise.

>  
> Seems to me really we just don't expect to ever get an OPEN event
> unless 
> we are in NOT_OPER.
> 
> If there's a reason to keep STANDBY->STANDBY as a nop, but we don't 
> expect to see it and don't' want to WARN because of it, then maybe a
> log 
> entry at least would make sense.
> 
> As for the IDLE/CP_PROCESSING/CP_PENDING cases, going fsm_notoper 
> because this is unexpected probably makes sense, but the logging is 
> going to be really confusing (before this change, you know that you 
> called fsm_notoper because you got VFIO_CCW_EVENT_NOT_OPER -- now
> you'll 
> see a log entry cut for NOT_OPER but won't be sure if it was for 
> EVENT_NOT_OPER or EVENT_OPEN).  Maybe you can look at 'event' inside 
> fsm_notoper and cut a slightly different trace entry when arriving
> here 
> for EVENT_OPEN?

Yeah, good idea. Since we don't expect any of these in normal behavior,
perhaps I'll trace both state and event, instead of trying to make
conditionals out of everything.

> 
> ...
> 
> > +static void fsm_open(struct vfio_ccw_private *private,
> > +		     enum vfio_ccw_event event)
> > +{
> > +	struct subchannel *sch = private->sch;
> > +	int ret;
> > +
> > +	spin_lock_irq(sch->lock);
> > +	sch->isc = VFIO_CCW_ISC;
> > +	ret = cio_enable_subchannel(sch, (u32)(unsigned long)sch);
> > +	if (!ret)
> > +		private->state = VFIO_CCW_STATE_STANDBY;
> 
> nit: could get rid of 'ret' and just do
> 
> if (!cio_enable...)
>       private->state = VFIO_CCW_STATE_STANDBY;

Ah, fair. Cut/paste and didn't really consider the simplification.

I see that I left the unconditional "private->state = STANDBY" in the
hunk just above this, which can be removed. (I finally do in patch 10.)
Will make that change too.

> 
> > +	spin_unlock_irq(sch->lock);
> > +}
> > +
> >   /*
> >    * Device statemachine
> >    */
> > @@ -373,29 +389,34 @@ fsm_func_t
> > *vfio_ccw_jumptable[NR_VFIO_CCW_STATES][NR_VFIO_CCW_EVENTS] = {
> >   		[VFIO_CCW_EVENT_IO_REQ]		= fsm_io_error,
> >   		[VFIO_CCW_EVENT_ASYNC_REQ]	= fsm_async_error,
> >   		[VFIO_CCW_EVENT_INTERRUPT]	= fsm_disabled_irq,
> > +		[VFIO_CCW_EVENT_OPEN]		= fsm_open,
> >   	},
> >   	[VFIO_CCW_STATE_STANDBY] = {
> >   		[VFIO_CCW_EVENT_NOT_OPER]	= fsm_notoper,
> >   		[VFIO_CCW_EVENT_IO_REQ]		= fsm_io_error,
> >   		[VFIO_CCW_EVENT_ASYNC_REQ]	= fsm_async_error,
> >   		[VFIO_CCW_EVENT_INTERRUPT]	= fsm_irq,
> > +		[VFIO_CCW_EVENT_OPEN]		= fsm_nop,
> >   	},
> >   	[VFIO_CCW_STATE_IDLE] = {
> >   		[VFIO_CCW_EVENT_NOT_OPER]	= fsm_notoper,
> >   		[VFIO_CCW_EVENT_IO_REQ]		= fsm_io_request,
> >   		[VFIO_CCW_EVENT_ASYNC_REQ]	= fsm_async_request,
> >   		[VFIO_CCW_EVENT_INTERRUPT]	= fsm_irq,
> > +		[VFIO_CCW_EVENT_OPEN]		= fsm_notoper,
> >   	},
> >   	[VFIO_CCW_STATE_CP_PROCESSING] = {
> >   		[VFIO_CCW_EVENT_NOT_OPER]	= fsm_notoper,
> >   		[VFIO_CCW_EVENT_IO_REQ]		= fsm_io_retry,
> >   		[VFIO_CCW_EVENT_ASYNC_REQ]	= fsm_async_retry,
> >   		[VFIO_CCW_EVENT_INTERRUPT]	= fsm_irq,
> > +		[VFIO_CCW_EVENT_OPEN]		= fsm_notoper,
> >   	},
> >   	[VFIO_CCW_STATE_CP_PENDING] = {
> >   		[VFIO_CCW_EVENT_NOT_OPER]	= fsm_notoper,
> >   		[VFIO_CCW_EVENT_IO_REQ]		= fsm_io_busy,
> >   		[VFIO_CCW_EVENT_ASYNC_REQ]	= fsm_async_request,
> >   		[VFIO_CCW_EVENT_INTERRUPT]	= fsm_irq,
> > +		[VFIO_CCW_EVENT_OPEN]		= fsm_notoper,
> >   	},
> >   };
> > diff --git a/drivers/s390/cio/vfio_ccw_private.h
> > b/drivers/s390/cio/vfio_ccw_private.h
> > index 4cfdd5fc0961..8dff1699a7d9 100644
> > --- a/drivers/s390/cio/vfio_ccw_private.h
> > +++ b/drivers/s390/cio/vfio_ccw_private.h
> > @@ -142,6 +142,7 @@ enum vfio_ccw_event {
> >   	VFIO_CCW_EVENT_IO_REQ,
> >   	VFIO_CCW_EVENT_INTERRUPT,
> >   	VFIO_CCW_EVENT_ASYNC_REQ,
> > +	VFIO_CCW_EVENT_OPEN,
> >   	/* last element! */
> >   	NR_VFIO_CCW_EVENTS
> >   };

