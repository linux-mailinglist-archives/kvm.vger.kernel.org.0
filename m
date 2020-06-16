Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DBE51FBF67
	for <lists+kvm@lfdr.de>; Tue, 16 Jun 2020 21:51:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730940AbgFPTvC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Jun 2020 15:51:02 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:41400 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728518AbgFPTvB (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 16 Jun 2020 15:51:01 -0400
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05GJWNEJ002581;
        Tue, 16 Jun 2020 15:51:01 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 31n45dvujq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 16 Jun 2020 15:51:01 -0400
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 05GJWbHm003478;
        Tue, 16 Jun 2020 15:51:00 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 31n45dvuj7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 16 Jun 2020 15:51:00 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 05GJnhjG013450;
        Tue, 16 Jun 2020 19:50:58 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma04ams.nl.ibm.com with ESMTP id 31mpe7wv99-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 16 Jun 2020 19:50:58 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 05GJot3S58916932
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 16 Jun 2020 19:50:55 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6C844A405C;
        Tue, 16 Jun 2020 19:50:55 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 53030A405B;
        Tue, 16 Jun 2020 19:50:55 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Tue, 16 Jun 2020 19:50:55 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 4958)
        id E791DE01F3; Tue, 16 Jun 2020 21:50:54 +0200 (CEST)
From:   Eric Farman <farman@linux.ibm.com>
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     Jared Rossi <jrossi@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, Eric Farman <farman@linux.ibm.com>
Subject: [RFC PATCH v3 0/3] vfio-ccw: Fix interrupt handling for HALT/CLEAR
Date:   Tue, 16 Jun 2020 21:50:50 +0200
Message-Id: <20200616195053.99253-1-farman@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-16_12:2020-06-16,2020-06-16 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 suspectscore=0 phishscore=0 adultscore=0 mlxlogscore=999
 priorityscore=1501 bulkscore=0 malwarescore=0 spamscore=0 impostorscore=0
 clxscore=1011 cotscore=-2147483648 mlxscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006160134
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Let's continue our discussion of the handling of vfio-ccw interrupts.

The initial fix [1] relied upon the interrupt path's examination of the
FSM state, and freeing all resources if it were CP_PENDING. But the
interface used by HALT/CLEAR SUBCHANNEL doesn't affect the FSM state.
Consider this sequence:

    CPU 1                           CPU 2
    CLEAR (state=IDLE/no change)
                                    START [2]
    INTERRUPT (set state=IDLE)
                                    INTERRUPT (set state=IDLE)

This translates to a couple of possible scenarios:

 A) The START gets a cc2 because of the outstanding CLEAR, -EBUSY is
    returned, resources are freed, and state remains IDLE
 B) The START gets a cc0 because the CLEAR has already presented an
    interrupt, and state is set to CP_PENDING

If the START gets a cc0 before the CLEAR INTERRUPT (stacked onto a
workqueue by the IRQ context) gets a chance to run, then the INTERRUPT
will release the channel program memory prematurely. If the two
operations run concurrently, then the FSM state set to CP_PROCESSING
will prevent the cp_free() from being invoked. But the io_mutex
boundary on that path will pause itself until the START completes,
and then allow the FSM to be reset to IDLE without considering the
outstanding START. Neither scenario would be considered good.

Having said all of that, in v2 Conny suggested [3] the following:

> - Detach the cp from the subchannel (or better, remove the 1:1
>   relationship). By that I mean building the cp as a separately
>   allocated structure (maybe embedding a kref, but that might not be
>   needed), and appending it to a list after SSCH with cc=0. Discard it
>   if cc!=0.
> - Remove the CP_PENDING state. The state is either IDLE after any
>   successful SSCH/HSCH/CSCH, or a new state in that case. But no
>   special state for SSCH.
> - A successful CSCH removes the first queued request, if any.
> - A final interrupt removes the first queued request, if any.

What I have implemented here is basically this, with a few changes:

 - I don't queue cp's. Since there should only be one START in process
   at a time, and HALT/CLEAR doesn't build a cp, I didn't see a pressing
   need to introduce that complexity.
 - Furthermore, while I initially made a separately allocated cp, adding
   an alloc for a cp on each I/O AND moving the guest_cp alloc from the
   probe path to the I/O path seems excessive. So I implemented a
   "started" flag to the cp, set after a cc0 from the START, and examine
   that on the interrupt path to determine whether cp_free() is needed.
 - I opted against a "SOMETHING_PENDING" state if START/HALT/CLEAR
   got a cc0, and just put the FSM back to IDLE. It becomes too unwieldy
   to discern which operation an interrupt is completing, and whether
   more interrupts are expected, to be worth the additional state.
 - A successful CSCH doesn't do anything special, and cp_free()
   is only performed on the interrupt path. Part of me wrestled with
   how a HALT fits into that, but mostly it was that a cc0 on any
   of the instructions indicated the "channel subsystem is signaled
   to asynchronously perform the [START/HALT/CLEAR] function."
   This means that an in-flight START could still receive data from the
   device/subchannel, so not a good idea to release memory at that point.

Separate from all that, I added a small check of the io_work queue to
the FSM START path. Part of the problems I've seen was that an interrupt
is presented by a CPU, but not yet processed by vfio-ccw. Some of the
problems seen thus far is because of this gap, and the above changes
don't address that either. Whether this is appropriate or ridiculous
would be a welcome discussion.

Previous versions:
v2: https://lore.kernel.org/kvm/20200513142934.28788-1-farman@linux.ibm.com/
v1: https://lore.kernel.org/kvm/20200124145455.51181-1-farman@linux.ibm.com/

Footnotes:
[1] https://lore.kernel.org/kvm/62e87bf67b38dc8d5760586e7c96d400db854ebe.1562854091.git.alifm@linux.ibm.com/
[2] Halil has pointed out that QEMU should prohibit this, based on the
    rules set forth by the POPs. This is true, but we should not rely on
    it behaving properly without addressing this scenario that is visible
    today. Once I get this behaving correctly, I'll spend some time
    seeing if QEMU is misbehaving somehow.
[3] https://lore.kernel.org/kvm/20200518180903.7cb21dd8.cohuck@redhat.com/
[4] https://lore.kernel.org/kvm/a52368d3-8cec-7b99-1587-25e055228b62@linux.ibm.com/

Eric Farman (3):
  vfio-ccw: Indicate if a channel_program is started
  vfio-ccw: Remove the CP_PENDING FSM state
  vfio-ccw: Check workqueue before doing START

 drivers/s390/cio/vfio_ccw_cp.c      |  2 ++
 drivers/s390/cio/vfio_ccw_cp.h      |  1 +
 drivers/s390/cio/vfio_ccw_drv.c     |  5 +----
 drivers/s390/cio/vfio_ccw_fsm.c     | 32 +++++++++++++++++------------
 drivers/s390/cio/vfio_ccw_ops.c     |  3 +--
 drivers/s390/cio/vfio_ccw_private.h |  1 -
 6 files changed, 24 insertions(+), 20 deletions(-)

-- 
2.17.1

