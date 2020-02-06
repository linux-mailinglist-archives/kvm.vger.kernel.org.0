Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0A1B7154E21
	for <lists+kvm@lfdr.de>; Thu,  6 Feb 2020 22:38:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727803AbgBFViq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Feb 2020 16:38:46 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:23190 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727502AbgBFVid (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 6 Feb 2020 16:38:33 -0500
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 016LbsOA096287
        for <kvm@vger.kernel.org>; Thu, 6 Feb 2020 16:38:32 -0500
Received: from e06smtp01.uk.ibm.com (e06smtp01.uk.ibm.com [195.75.94.97])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2xyhmjpwxf-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 06 Feb 2020 16:38:31 -0500
Received: from localhost
        by e06smtp01.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <farman@linux.ibm.com>;
        Thu, 6 Feb 2020 21:38:30 -0000
Received: from b06cxnps4076.portsmouth.uk.ibm.com (9.149.109.198)
        by e06smtp01.uk.ibm.com (192.168.101.131) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 6 Feb 2020 21:38:27 -0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 016LcQZh51314858
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 6 Feb 2020 21:38:26 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4AF0F11C052;
        Thu,  6 Feb 2020 21:38:26 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 37C0611C050;
        Thu,  6 Feb 2020 21:38:26 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Thu,  6 Feb 2020 21:38:26 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 4958)
        id A6662E026B; Thu,  6 Feb 2020 22:38:25 +0100 (CET)
From:   Eric Farman <farman@linux.ibm.com>
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     Halil Pasic <pasic@linux.ibm.com>,
        Jason Herne <jjherne@linux.ibm.com>,
        Jared Rossi <jrossi@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org
Subject: [RFC PATCH v2 0/9] s390x/vfio-ccw: Channel Path Handling
Date:   Thu,  6 Feb 2020 22:38:16 +0100
X-Mailer: git-send-email 2.17.1
X-TM-AS-GCONF: 00
x-cbid: 20020621-4275-0000-0000-0000039EA97B
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20020621-4276-0000-0000-000038B2D801
Message-Id: <20200206213825.11444-1-farman@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-06_04:2020-02-06,2020-02-06 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 clxscore=1015
 impostorscore=0 malwarescore=0 priorityscore=1501 adultscore=0
 mlxlogscore=810 suspectscore=0 bulkscore=0 lowpriorityscore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002060157
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Here is a new pass at the channel-path handling code for vfio-ccw.
This was initially developed by Farhan Ali this past summer, and
picked up by me.  For my own benefit/sanity, I made a small changelog
in the commit message for each patch, describing the changes I've
made to his original code beyond just rebasing to master, rather than
a giant list appended here.

I had been encountering a host crash which I think was triggered by
this code rather than existing within it.  I'd sent a potential fix
for that separately, but need more diagnosis.  So while that is
outstanding, I think I've gotten most (but probably not all) comments
from v1 addressed within.

With this, and the corresponding QEMU series (to be posted momentarily),
applied I am able to configure off/on a CHPID (for example, by issuing
"chchp -c 0/1 xx" on the host), and the guest is able to see both the
events and reflect the updated path masks in its structures.

For reasons that are hopefully obvious, issuing chchp within the guest
only works for the logical vary.  Configuring it off/on does not work,
which I think is fine.

v1: https://lore.kernel.org/kvm/20191115025620.19593-1-farman@linux.ibm.com/

Eric Farman (4):
  vfio-ccw: Refactor the unregister of the async regions
  vfio-ccw: Refactor IRQ handlers
  vfio-ccw: Add trace for CRW event
  vfio-ccw: Remove inline get_schid() routine

Farhan Ali (5):
  vfio-ccw: Introduce new helper functions to free/destroy regions
  vfio-ccw: Register a chp_event callback for vfio-ccw
  vfio-ccw: Introduce a new schib region
  vfio-ccw: Introduce a new CRW region
  vfio-ccw: Wire up the CRW irq and CRW region

 Documentation/s390/vfio-ccw.rst     |  31 ++++-
 drivers/s390/cio/Makefile           |   2 +-
 drivers/s390/cio/vfio_ccw_chp.c     | 136 ++++++++++++++++++++
 drivers/s390/cio/vfio_ccw_drv.c     | 186 ++++++++++++++++++++++++++--
 drivers/s390/cio/vfio_ccw_fsm.c     |   8 +-
 drivers/s390/cio/vfio_ccw_ops.c     |  65 +++++++---
 drivers/s390/cio/vfio_ccw_private.h |  16 +++
 drivers/s390/cio/vfio_ccw_trace.c   |   1 +
 drivers/s390/cio/vfio_ccw_trace.h   |  30 +++++
 include/uapi/linux/vfio.h           |   3 +
 include/uapi/linux/vfio_ccw.h       |  19 +++
 11 files changed, 463 insertions(+), 34 deletions(-)
 create mode 100644 drivers/s390/cio/vfio_ccw_chp.c

-- 
2.17.1

