Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F361367684
	for <lists+kvm@lfdr.de>; Thu, 22 Apr 2021 02:53:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238587AbhDVAxm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Apr 2021 20:53:42 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:37758 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235168AbhDVAxl (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 21 Apr 2021 20:53:41 -0400
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 13M0Wm4T119475;
        Wed, 21 Apr 2021 20:53:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=+gGUx1sNshe+I44p8sIGmfmHRCxtWareHWcSohlwfVA=;
 b=p/AVgeSkiQBGeUovP4pUrLt4id5LOAIW4GKWIVEYqkEsnGRM5ogZDcSNZasHmXzNuVrM
 s1V34Q626wDdmqc9mQxGsysfHm6MPdf57VftCpr729QtAhxVKSpDOslTiEm31Nfc89zw
 zJxuLI2ibokYsPpHGJ5hWTRRj0tRgdSpAAnPynopfKYMEjNCAQCxMb16iKMq+dFp4du4
 YjFvxcply2QvlstqSeSb+Xc8C0v+ZSVsReDOqTxWvWXYhDwlVuW9gb31eVjEQ9fJ/usx
 Kx+wkJX0YlMLbXU0HdLn95Cl5QkPd66PbRCTQn0M1BQV4l88JJeVrRarCua++M2RHtGv QA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 382xh08kv5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 21 Apr 2021 20:53:07 -0400
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 13M0YOvH125903;
        Wed, 21 Apr 2021 20:53:07 -0400
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com with ESMTP id 382xh08kuj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 21 Apr 2021 20:53:06 -0400
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 13M0laQg015086;
        Thu, 22 Apr 2021 00:53:04 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma06fra.de.ibm.com with ESMTP id 37ypxh9dr7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 22 Apr 2021 00:53:04 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 13M0r0dJ31785304
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 22 Apr 2021 00:53:01 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E11CAAE051;
        Thu, 22 Apr 2021 00:53:00 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6C2F9AE045;
        Thu, 22 Apr 2021 00:53:00 +0000 (GMT)
Received: from li-e979b1cc-23ba-11b2-a85c-dfd230f6cf82 (unknown [9.171.31.18])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with SMTP;
        Thu, 22 Apr 2021 00:53:00 +0000 (GMT)
Date:   Thu, 22 Apr 2021 02:52:58 +0200
From:   Halil Pasic <pasic@linux.ibm.com>
To:     Eric Farman <farman@linux.ibm.com>
Cc:     Cornelia Huck <cohuck@redhat.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Jared Rossi <jrossi@linux.ibm.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [RFC PATCH v4 0/4] vfio-ccw: Fix interrupt handling for
 HALT/CLEAR
Message-ID: <20210422025258.6ed7619d.pasic@linux.ibm.com>
In-Reply-To: <20210413182410.1396170-1-farman@linux.ibm.com>
References: <20210413182410.1396170-1-farman@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: -tn7Dq0vjRQVrJu2iUUvQnQBCSMVUaFa
X-Proofpoint-ORIG-GUID: qD3C3reA9tJhAPzsvP5tNF2bkiRCPTE7
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-04-21_08:2021-04-21,2021-04-21 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 mlxscore=0
 adultscore=0 lowpriorityscore=0 malwarescore=0 suspectscore=0 spamscore=0
 impostorscore=0 clxscore=1015 priorityscore=1501 mlxlogscore=999
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104220003
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 13 Apr 2021 20:24:06 +0200
Eric Farman <farman@linux.ibm.com> wrote:

> Hi Conny, Halil,
> 
> Let's restart our discussion about the collision between interrupts for
> START SUBCHANNEL and HALT/CLEAR SUBCHANNEL. It's been a quarter million
> minutes (give or take), so here is the problematic scenario again:
> 
> 	CPU 1			CPU 2
>  1	CLEAR SUBCHANNEL
>  2	fsm_irq()
>  3				START SUBCHANNEL
>  4	vfio_ccw_sch_io_todo()
>  5				fsm_irq()
>  6				vfio_ccw_sch_io_todo()
> 
> From the channel subsystem's point of view the CLEAR SUBCHANNEL (step 1)
> is complete once step 2 is called, as the Interrupt Response Block (IRB)
> has been presented and the TEST SUBCHANNEL was driven by the cio layer.
> Thus, the START SUBCHANNEL (step 3) is submitted [1] and gets a cc=0 to
> indicate the I/O was accepted. However, step 2 stacks the bulk of the
> actual work onto a workqueue for when the subchannel lock is NOT held,
> and is unqueued at step 4. That code misidentifies the data in the IRB
> as being associated with the newly active I/O, and may release memory
> that is actively in use by the channel subsystem and/or device. Eww.
> 
> In this version...
> 
> Patch 1 and 2 are defensive checks. Patch 2 was part of v3 [2], but I
> would love a better option here to guard between steps 2 and 4.
> 
> Patch 3 is a subset of the removal of the CP_PENDING FSM state in v3.
> I've obviously gone away from this idea, but I thought this piece is
> still valuable.
> 
> Patch 4 collapses the code on the interrupt path so that changes to
> the FSM state and the channel_program struct are handled at the same
> point, rather than separated by a mutex boundary. Because of the
> possibility of a START and HALT/CLEAR running concurrently, it does
> not make sense to split them here.
> 
> With the above patches, maybe it then makes sense to hold the io_mutex
> across the entirety of vfio_ccw_sch_io_todo(). But I'm not completely
> sure that would be acceptable.
> 
> So... Thoughts?

I believe we should address the concurrency, encapsulation and layering
issues in the subchannel/ccw pass-through code (vfio-ccw) by taking a
holistic approach as soon as possible.

I find the current state of art very hard to reason about, and that
adversely  affects my ability to reason about attempts at partial
improvements.

I understand that such a holistic approach needs a lot of work, and we
may have to stop some bleeding first. In the stop the bleeding phase we
can take a pragmatic approach and accept changes that empirically seem to
work towards stopping the bleeding. I.e. if your tests say it's better,
I'm willing to accept that it is better.

I have to admit, I don't understand how synchronization is done in the
vfio-ccw kernel module (in the sense of avoiding data races).

Regarding your patches, I have to admit, I have a hard time figuring out
which one of these (or what combination of them) is supposed to solve
the problem you described above. If I had to guess, I would guess it is
either patch 4, because it has a similar scenario diagram in the
commit message like the one in the problem statement. Is my guess right?

If it is right I don't quite understand the mechanics of the fix,
because what the patch seems to do is changing the content of step 4 in
the above diagram. And I don't see how is change that code
so that it does not "misidentifies the data in the IRB as being
associated with the newly active I/O". Moreover patch 4 seems to rely on
private->state which, AFAIR is still used in a racy fashion.

But if strong empirical evidence shows that it performs better (stops
the bleeding), I think we can go ahead with it.

Regards,
Halil







