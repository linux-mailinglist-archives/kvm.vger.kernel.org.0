Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8B4F71E5B7
	for <lists+kvm@lfdr.de>; Wed, 15 May 2019 01:43:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726785AbfENXnC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 May 2019 19:43:02 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:38876 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726742AbfENXm7 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 14 May 2019 19:42:59 -0400
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x4ENMomF121677
        for <kvm@vger.kernel.org>; Tue, 14 May 2019 19:42:58 -0400
Received: from e06smtp07.uk.ibm.com (e06smtp07.uk.ibm.com [195.75.94.103])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2sg66rjpsf-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 14 May 2019 19:42:58 -0400
Received: from localhost
        by e06smtp07.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <farman@linux.ibm.com>;
        Wed, 15 May 2019 00:42:55 +0100
Received: from b06cxnps4076.portsmouth.uk.ibm.com (9.149.109.198)
        by e06smtp07.uk.ibm.com (192.168.101.137) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Wed, 15 May 2019 00:42:53 +0100
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x4ENgpt049676516
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 May 2019 23:42:51 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 84ED7A4054;
        Tue, 14 May 2019 23:42:51 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 73A4AA405F;
        Tue, 14 May 2019 23:42:51 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Tue, 14 May 2019 23:42:51 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 4958)
        id 2AEE5E05B9; Wed, 15 May 2019 01:42:51 +0200 (CEST)
From:   Eric Farman <farman@linux.ibm.com>
To:     Cornelia Huck <cohuck@redhat.com>, Farhan Ali <alifm@linux.ibm.com>
Cc:     Halil Pasic <pasic@linux.ibm.com>,
        Pierre Morel <pmorel@linux.ibm.com>,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        Eric Farman <farman@linux.ibm.com>
Subject: [PATCH v2 0/7] s390: vfio-ccw fixes
Date:   Wed, 15 May 2019 01:42:41 +0200
X-Mailer: git-send-email 2.17.1
X-TM-AS-GCONF: 00
x-cbid: 19051423-0028-0000-0000-0000036DBABA
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19051423-0029-0000-0000-0000242D4E68
Message-Id: <20190514234248.36203-1-farman@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-14_13:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=935 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1905140153
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The attached are a few fixes to the vfio-ccw kernel code for potential
errors or architecture anomalies.  Under normal usage, and even most
abnormal usage, they don't expose any problems to a well-behaved guest
and its devices.  But, they are deficiencies just the same and could
cause some weird behavior if they ever popped up in real life.

I have tried to arrange these patches in a "solves a noticeable problem
with existing workloads" to "solves a theoretical problem with
hypothetical workloads" order.  This way, the bigger ones at the end
can be discussed without impeding the smaller and more impactful ones
at the start.

Per the conversations on patch 7, the last several patches remain
unchanged.  They continue to buid an IDAL for each CCW, and only pin
guest pages and assign the resulting addresses to IDAWs if they are
expected to cause a data transfer.  This will avoid sending an
unmodified guest address, which may be invalid but anyway is not mapped
to the same host address, in the IDAL sent to the channel subsystem and
any unexpected behavior that may result.

They are based on 5.1.0, not Conny's vfio-ccw tree even though there are
some good fixes pending for 5.2 there.  I've run this series both with
and without that code, but couldn't decide which base would provide an
easier time applying patches.  "I think" they should apply fine to both,
but I apologize in advance if I guessed wrong!  :)


Changelog:
 v1 -> v2:
  - Patch 1:
     - [Cornelia] Added a code comment about why we update the SCSW when
       we've gone past the end of the chain for normal, successful, I/O
  - Patch 2:
     - [Cornelia] Cleaned up the cc info in the commit message
     - [Pierre] Added r-b
  - Patch 3:
     - [Cornelia] Update the return code information in prologue of
       pfn_array_pin(), and then only call vfio_unpin_pages() if we
       pinned anything, rather than silently creating an error
       (this last bit was mentioned on patch 6, but applied here)
     - [Eric] Clean up the error exit in pfn_array_pin()
  - Patch 4-7 unchanged

Eric Farman (7):
  s390/cio: Update SCSW if it points to the end of the chain
  s390/cio: Set vfio-ccw FSM state before ioeventfd
  s390/cio: Split pfn_array_alloc_pin into pieces
  s390/cio: Initialize the host addresses in pfn_array
  s390/cio: Allow zero-length CCWs in vfio-ccw
  s390/cio: Don't pin vfio pages for empty transfers
  s390/cio: Remove vfio-ccw checks of command codes

 drivers/s390/cio/vfio_ccw_cp.c  | 159 +++++++++++++++++++++++---------
 drivers/s390/cio/vfio_ccw_drv.c |   6 +-
 2 files changed, 119 insertions(+), 46 deletions(-)

-- 
2.17.1

