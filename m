Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8935136966B
	for <lists+kvm@lfdr.de>; Fri, 23 Apr 2021 17:53:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242984AbhDWPyd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Apr 2021 11:54:33 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:54534 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231409AbhDWPyd (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 23 Apr 2021 11:54:33 -0400
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 13NFiW24056544;
        Fri, 23 Apr 2021 11:53:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=mRB5CKujD8h4Q/Vg435ANzBcb4D+nq3BRxe9HJmpN+M=;
 b=WGeiem2a92lBMX7wGujc8ZE3qwHvpGFOrFWjwIHkgnOz93ci7Kcqmf9y5r4VS3Po1uWK
 r9LP/nSUOoNqlump2l00kYQMg1JisvBsAzouxGpDYfo6/l0wIIsuU1bCf5XPYrQ4kYy6
 tLGyE4PIRWIBGcsDeD7elZM0rHXqtP9HTzxi8fksZrTdvupeje9p3hsu4Ct3as1oPnVD
 izLoQA3rtATVRKk0exYSpwaA0aBXtbcoe1ee4ON4K30ASGLG0FBCv8ORHsbBTfyaRXM1
 w0c9sxEWyJJi4M7FvCsvfkFBIHqv4hyln6MwhdcJwZYycJ2PLNQ0YPUdK8IT6FU0UN9y Ew== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 384155r842-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 23 Apr 2021 11:53:56 -0400
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 13NFmlo1073722;
        Fri, 23 Apr 2021 11:53:55 -0400
Received: from ppma02wdc.us.ibm.com (aa.5b.37a9.ip4.static.sl-reverse.com [169.55.91.170])
        by mx0a-001b2d01.pphosted.com with ESMTP id 384155r83v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 23 Apr 2021 11:53:55 -0400
Received: from pps.filterd (ppma02wdc.us.ibm.com [127.0.0.1])
        by ppma02wdc.us.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 13NFXRJF024573;
        Fri, 23 Apr 2021 15:53:55 GMT
Received: from b03cxnp07027.gho.boulder.ibm.com (b03cxnp07027.gho.boulder.ibm.com [9.17.130.14])
        by ppma02wdc.us.ibm.com with ESMTP id 37yqaahwgj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 23 Apr 2021 15:53:54 +0000
Received: from b03ledav003.gho.boulder.ibm.com (b03ledav003.gho.boulder.ibm.com [9.17.130.234])
        by b03cxnp07027.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 13NFrrEr32899332
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 23 Apr 2021 15:53:53 GMT
Received: from b03ledav003.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EFB8F6A047;
        Fri, 23 Apr 2021 15:53:52 +0000 (GMT)
Received: from b03ledav003.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 466916A04D;
        Fri, 23 Apr 2021 15:53:52 +0000 (GMT)
Received: from farman-thinkpad-t470p (unknown [9.160.17.178])
        by b03ledav003.gho.boulder.ibm.com (Postfix) with ESMTP;
        Fri, 23 Apr 2021 15:53:52 +0000 (GMT)
Message-ID: <655a69d7c094f19b0b78a776c13675a8c07809d1.camel@linux.ibm.com>
Subject: Re: [RFC PATCH v4 0/4] vfio-ccw: Fix interrupt handling for
 HALT/CLEAR
From:   Eric Farman <farman@linux.ibm.com>
To:     Halil Pasic <pasic@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>
Cc:     Matthew Rosato <mjrosato@linux.ibm.com>,
        Jared Rossi <jrossi@linux.ibm.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org
Date:   Fri, 23 Apr 2021 11:53:51 -0400
In-Reply-To: <20210423152311.20570945.pasic@linux.ibm.com>
References: <20210413182410.1396170-1-farman@linux.ibm.com>
         <20210422025258.6ed7619d.pasic@linux.ibm.com>
         <1eb9cbdfe43a42a62f6afb0315bb1e3a103dac9a.camel@linux.ibm.com>
         <20210423130616.6dcbf4e4.cohuck@redhat.com>
         <20210423152311.20570945.pasic@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-14.el8) 
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: I4XkNzKuzPGVQIt_0ijKz1Pivg7hNZ5Y
X-Proofpoint-ORIG-GUID: XJCIyUMWHIgsWvcAs3MoIrXG_km9JDzo
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-04-23_07:2021-04-23,2021-04-23 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 malwarescore=0 suspectscore=0 bulkscore=0 phishscore=0 clxscore=1015
 priorityscore=1501 adultscore=0 mlxlogscore=999 impostorscore=0 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104230100
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 2021-04-23 at 15:23 +0200, Halil Pasic wrote:
> On Fri, 23 Apr 2021 13:06:16 +0200
> Cornelia Huck <cohuck@redhat.com> wrote:
> 
> > On Thu, 22 Apr 2021 16:49:21 -0400
> > Eric Farman <farman@linux.ibm.com> wrote:
> > 
> > > On Thu, 2021-04-22 at 02:52 +0200, Halil Pasic wrote:  
> > > > On Tue, 13 Apr 2021 20:24:06 +0200
> > > > Eric Farman <farman@linux.ibm.com> wrote:
> > > >     
> > > > > Hi Conny, Halil,
> > > > > 
> > > > > Let's restart our discussion about the collision between
> > > > > interrupts
> > > > > for
> > > > > START SUBCHANNEL and HALT/CLEAR SUBCHANNEL. It's been a
> > > > > quarter
> > > > > million
> > > > > minutes (give or take), so here is the problematic scenario
> > > > > again:
> > > > > 
> > > > > 	CPU 1			CPU 2
> > > > >  1	CLEAR SUBCHANNEL
> > > > >  2	fsm_irq()
> > > > >  3				START SUBCHANNEL
> > > > >  4	vfio_ccw_sch_io_todo()
> > > > >  5				fsm_irq()
> > > > >  6				vfio_ccw_sch_io_todo()
> > > > > 
> > > > > From the channel subsystem's point of view the CLEAR
> > > > > SUBCHANNEL
> > > > > (step 1)
> > > > > is complete once step 2 is called, as the Interrupt Response
> > > > > Block
> > > > > (IRB)
> > > > > has been presented and the TEST SUBCHANNEL was driven by the
> > > > > cio
> > > > > layer.
> > > > > Thus, the START SUBCHANNEL (step 3) is submitted [1] and gets
> > > > > a
> > > > > cc=0 to
> > > > > indicate the I/O was accepted. However, step 2 stacks the
> > > > > bulk of
> > > > > the
> > > > > actual work onto a workqueue for when the subchannel lock is
> > > > > NOT
> > > > > held,
> > > > > and is unqueued at step 4. That code misidentifies the data
> > > > > in the
> > > > > IRB
> > > > > as being associated with the newly active I/O, and may
> > > > > release
> > > > > memory
> > > > > that is actively in use by the channel subsystem and/or
> > > > > device.
> > > > > Eww.
> > > > > 
> > > > > In this version...
> > > > > 
> > > > > Patch 1 and 2 are defensive checks. Patch 2 was part of v3
> > > > > [2], but
> > > > > I
> > > > > would love a better option here to guard between steps 2 and
> > > > > 4.
> > > > > 
> > > > > Patch 3 is a subset of the removal of the CP_PENDING FSM
> > > > > state in
> > > > > v3.
> > > > > I've obviously gone away from this idea, but I thought this
> > > > > piece
> > > > > is
> > > > > still valuable.
> > > > > 
> > > > > Patch 4 collapses the code on the interrupt path so that
> > > > > changes to
> > > > > the FSM state and the channel_program struct are handled at
> > > > > the
> > > > > same
> > > > > point, rather than separated by a mutex boundary. Because of
> > > > > the
> > > > > possibility of a START and HALT/CLEAR running concurrently,
> > > > > it does
> > > > > not make sense to split them here.
> > > > > 
> > > > > With the above patches, maybe it then makes sense to hold the
> > > > > io_mutex
> > > > > across the entirety of vfio_ccw_sch_io_todo(). But I'm not
> > > > > completely
> > > > > sure that would be acceptable.
> > > > > 
> > > > > So... Thoughts?    
> > > > 
> > > > I believe we should address    
> > > 
> > > Who is the "we" here?
> > >   
> > > >  the concurrency, encapsulation and layering
> > > > issues in the subchannel/ccw pass-through code (vfio-ccw) by
> > > > taking a
> > > > holistic approach as soon as possible.  
> > 
> > Let me also ask: what is "holistic"? If that's a complete rewrite,
> > I
> > definitely don't have the capacity for that; if others want to take
> > over the code, feel free.
> > 

Ditto.

The idea of a rewrite has come up in the past, and I still don't see
how that's a good use of time/resources. Looking at the fixes and
improvements from the last couple of years, I feel good about the
current components, their design, and their handshaking.

> 
> In general: https://en.wikipedia.org/wiki/Holism
> 
> In this context I mean:
> * Fix all data races in in the vfio-ccw module instead of making the
> "race window" smaller. Reasoning about the behavior of racy programs
> is very difficult.
> * The passed-through subchannel of the VM, as seen by the guest OS is
> an
> overlay of the host subchannel (which we have to assume is within the
> specification), the vfio-ccw kernel module, and an userspace
> emulator.
> The interface between the kernel module and the userspace emulator is
> something the authors of the vfio-ccw kernel module design, and while
> doing so we have to think about the interface the whole solution
> needs
> to implemnet. For example we should ask ourselves: what is the right
> response in kernel when we encounter the situation described by the
> steps 1-3 of Eric's scenario. Our VMs subchannel needs to reward the
> SSC with a cc=2 if the subchannel has the clear FC bit set. If we
> detect
> the described condition, does it mean that the userspace emulator is
> broken? Or is the userspace emulator allowed to rely on the vfio-ccw
> kernel module to detect this condition and return an -EBUSY (which
> corresponds to cc=2 because that is apart of the definition of the
> interface between the kernel and the userspace)? When is the FC bit
> of our VMs subchannel cleared? 



> I read patch 2 like it is trying to catch
> the condition and return an -EBUSY, but I don't see it catching all
> the possible cases. I.e. what if another CPU is executing the first
> instruction of vfio_ccw_sch_io_todo() when we check 
> work_pending(&private->io_work) in fsm_io_helper()?

This last hunk is part of the concern that Conny raised in reply to
Patch 2, which we have an idea on how to pursue.

Eric

> 
> [..]
> 
> > >   
> > > > Moreover patch 4 seems to rely on
> > > > private->state which, AFAIR is still used in a racy fashion.
> > > > 
> > > > But if strong empirical evidence shows that it performs better
> > > > (stops
> > > > the bleeding), I think we can go ahead with it.    
> > > 
> > > Again with the bleeding. Is there a Doctor in the house? :)  
> > 
> > No idea, seen any blue boxes around? :)
> > 
> 
> Let me also ask what: blue boxes do you mean? If you mean
> https://en.wikipedia.org/wiki/Blue_box
> then, I'm not sure I can follow your association. Are you looking for
> phone to call a doctor?
> 
> Regards,
> Halil

