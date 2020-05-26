Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C96241D179B
	for <lists+kvm@lfdr.de>; Wed, 13 May 2020 16:29:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388997AbgEMO3o (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 May 2020 10:29:44 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:53252 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2388790AbgEMO3m (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 13 May 2020 10:29:42 -0400
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 04DEAo62156622;
        Wed, 13 May 2020 10:29:41 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3101knnxk6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 13 May 2020 10:29:41 -0400
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 04DEBLQ4158639;
        Wed, 13 May 2020 10:29:40 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3101knnxje-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 13 May 2020 10:29:40 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 04DEL5fd015403;
        Wed, 13 May 2020 14:29:39 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma03ams.nl.ibm.com with ESMTP id 3100ub9rgv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 13 May 2020 14:29:38 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 04DESPjt25035040
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 13 May 2020 14:28:25 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 14DD2A4066;
        Wed, 13 May 2020 14:29:36 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EC722A405F;
        Wed, 13 May 2020 14:29:35 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Wed, 13 May 2020 14:29:35 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 4958)
        id A4F0BE02B1; Wed, 13 May 2020 16:29:35 +0200 (CEST)
From:   Eric Farman <farman@linux.ibm.com>
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     Jared Rossi <jrossi@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, Eric Farman <farman@linux.ibm.com>
Subject: [RFC PATCH v2 0/4] vfio-ccw: Fix interrupt handling for HALT/CLEAR
Date:   Wed, 13 May 2020 16:29:30 +0200
Message-Id: <20200513142934.28788-1-farman@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.676
 definitions=2020-05-13_06:2020-05-13,2020-05-13 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 impostorscore=0 lowpriorityscore=0 mlxscore=0 bulkscore=0
 cotscore=-2147483648 mlxlogscore=999 adultscore=0 clxscore=1015
 suspectscore=0 spamscore=0 phishscore=0 priorityscore=1501 classifier=spam
 adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005130121
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Conny,

Back in January, I suggested a small patch [1] to try to clean up
the handling of HSCH/CSCH interrupts, especially as it relates to
concurrent SSCH interrupts. Here is a new attempt to address this.

There was some suggestion earlier about locking the FSM, but I'm not
seeing any problems with that. Rather, what I'm noticing is that the
flow between a synchronous START and asynchronous HALT/CLEAR have
different impacts on the FSM state. Consider:

    CPU 1                           CPU 2

    SSCH (set state=CP_PENDING)
    INTERRUPT (set state=IDLE)
    CSCH (no change in state)
                                    SSCH (set state=CP_PENDING)
    INTERRUPT (set state=IDLE)
                                    INTERRUPT (set state=IDLE)

The second interrupt on CPU 1 will call cp_free() for the START
created by CPU 2, and our results will be, um, messy. This
suggests that three things must be true:

 A) cp_free() must be called for either a final interrupt,
or a failure issuing a SSCH
 B) The FSM state must only be set to IDLE once cp_free()
has been called
 C) A SSCH cannot be issued while an interrupt is outstanding

It's not great that items B and C are separated in the interrupt
path by a mutex boundary where the copy into io_region occurs.
We could (and perhaps should) move them together, which would
improve things somewhat, but still doesn't address the scenario
laid out above. Even putting that work within the mutex window
during interrupt processing doesn't address things totally.

So, the patches here do two things. One to handle unsolicited
interrupts [2], which I think is pretty straightforward. Though,
it does make me want to do a more drastic rearranging of the
affected function. :)

The other warrants some discussion, since it's sort of weird.
Basically, recognize what commands we've issued, expect interrupts
for each, and prevent new SSCH's while asynchronous commands are
pending. It doesn't address interrupts from the HSCH/CSCH that
could be generated by the Channel Path Handling code [3] for an
offline CHPID yet, and it needs some TLC to make checkpatch happy.
But it's the best possibility I've seen thus far.

I used private->scsw for this because it's barely used for anything
else; at one point I had been considering removing it outright because
we have entirely too many SCSW's in this code. :) I could implement
this as three small flags in private, to simplify the code and avoid
confusion with the different fctl/actl flags in private vs schib.

It does make me wonder whether the CP_PENDING check before cp_free()
is still necessary, but that's a query for a later date.

Also, perhaps this could be accomplished with two new FSM states,
one for a HALT and one for a CLEAR. I put it aside because the
interrupt handler got a little hairy with that, but I'm still looking
at it in parallel to this discussion.

I look forward to hearing your thoughts...

[1] https://lore.kernel.org/kvm/20200124145455.51181-1-farman@linux.ibm.com/
[2] https://lore.kernel.org/kvm/9635c45f-4652-c837-d256-46f426737a5e@linux.ibm.com/
[3] https://lore.kernel.org/kvm/20200505122745.53208-1-farman@linux.ibm.com/

Eric Farman (4):
  vfio-ccw: Do not reset FSM state for unsolicited interrupts
  vfio-ccw: Utilize scsw actl to serialize start operations
  vfio-ccw: Expand SCSW usage to HALT and CLEAR
  vfio-ccw: Clean up how to react to a failed START

 drivers/s390/cio/vfio_ccw_drv.c | 10 +++++++++-
 drivers/s390/cio/vfio_ccw_fsm.c | 26 ++++++++++++++++++++++++++
 drivers/s390/cio/vfio_ccw_ops.c |  3 +--
 3 files changed, 36 insertions(+), 3 deletions(-)

-- 
2.17.1

