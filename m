Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BEB11D85AA
	for <lists+kvm@lfdr.de>; Wed, 16 Oct 2019 03:58:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388939AbfJPB6d (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Oct 2019 21:58:33 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:55668 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388720AbfJPB6c (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 15 Oct 2019 21:58:32 -0400
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x9G1q3Ru073821
        for <kvm@vger.kernel.org>; Tue, 15 Oct 2019 21:58:31 -0400
Received: from e06smtp07.uk.ibm.com (e06smtp07.uk.ibm.com [195.75.94.103])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2vnq8sm3w3-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 15 Oct 2019 21:58:31 -0400
Received: from localhost
        by e06smtp07.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <farman@linux.ibm.com>;
        Wed, 16 Oct 2019 02:58:29 +0100
Received: from b06cxnps4075.portsmouth.uk.ibm.com (9.149.109.197)
        by e06smtp07.uk.ibm.com (192.168.101.137) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Wed, 16 Oct 2019 02:58:26 +0100
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x9G1wO3w29753438
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 16 Oct 2019 01:58:24 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 85F9F4203F;
        Wed, 16 Oct 2019 01:58:24 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 714C942047;
        Wed, 16 Oct 2019 01:58:24 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Wed, 16 Oct 2019 01:58:24 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 4958)
        id CD915E016E; Wed, 16 Oct 2019 03:58:23 +0200 (CEST)
From:   Eric Farman <farman@linux.ibm.com>
To:     Cornelia Huck <cohuck@redhat.com>,
        Steffen Maier <maier@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>
Cc:     Jason Herne <jjherne@linux.ibm.com>,
        Jared Rossi <jrossi@linux.ibm.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, Eric Farman <farman@linux.ibm.com>
Subject: [PATCH v2 0/4] vfio-ccw: A couple trace changes
Date:   Wed, 16 Oct 2019 03:58:18 +0200
X-Mailer: git-send-email 2.17.1
X-TM-AS-GCONF: 00
x-cbid: 19101601-0028-0000-0000-000003AA6617
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19101601-0029-0000-0000-0000246C7D7C
Message-Id: <20191016015822.72425-1-farman@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-10-15_08:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=600 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1908290000 definitions=main-1910160015
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Here a couple updates to the vfio-ccw traces in the kernel,
based on things I've been using locally.  Perhaps they'll
be useful for future debugging.

Steffen's comments earlier today (thank you!) were simple enough
that here's a quick turnaround on a v2:

v1/RFC -> v2:
 - Convert state/event=%x to %d
 - Use individual fields for cssid/ssid/sch_no, to enable
   filtering by device
 - Add 0x prefix to remaining %x substitution in existing trace

Eric Farman (4):
  vfio-ccw: Refactor how the traces are built
  vfio-ccw: Trace the FSM jumptable
  vfio-ccw: Add a trace for asynchronous requests
  vfio-ccw: Rework the io_fctl trace

 drivers/s390/cio/Makefile           |  4 +-
 drivers/s390/cio/vfio_ccw_cp.h      |  1 +
 drivers/s390/cio/vfio_ccw_fsm.c     | 11 +++--
 drivers/s390/cio/vfio_ccw_private.h |  1 +
 drivers/s390/cio/vfio_ccw_trace.c   | 14 ++++++
 drivers/s390/cio/vfio_ccw_trace.h   | 76 ++++++++++++++++++++++++++---
 6 files changed, 93 insertions(+), 14 deletions(-)
 create mode 100644 drivers/s390/cio/vfio_ccw_trace.c

-- 
2.17.1

