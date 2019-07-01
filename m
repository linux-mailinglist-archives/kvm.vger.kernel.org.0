Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 406714ABA0
	for <lists+kvm@lfdr.de>; Tue, 18 Jun 2019 22:24:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730627AbfFRUYE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Jun 2019 16:24:04 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:29904 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730571AbfFRUYE (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 18 Jun 2019 16:24:04 -0400
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5IKH9Qv123861
        for <kvm@vger.kernel.org>; Tue, 18 Jun 2019 16:24:03 -0400
Received: from e06smtp02.uk.ibm.com (e06smtp02.uk.ibm.com [195.75.94.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2t75c74j78-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 18 Jun 2019 16:24:01 -0400
Received: from localhost
        by e06smtp02.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <farman@linux.ibm.com>;
        Tue, 18 Jun 2019 21:23:59 +0100
Received: from b06avi18626390.portsmouth.uk.ibm.com (9.149.26.192)
        by e06smtp02.uk.ibm.com (192.168.101.132) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Tue, 18 Jun 2019 21:23:56 +0100
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x5IKNk1w22348242
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 18 Jun 2019 20:23:46 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4115E11C052;
        Tue, 18 Jun 2019 20:23:54 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 379F711C04C;
        Tue, 18 Jun 2019 20:23:54 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Tue, 18 Jun 2019 20:23:54 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 4958)
        id C813FE023C; Tue, 18 Jun 2019 22:23:53 +0200 (CEST)
From:   Eric Farman <farman@linux.ibm.com>
To:     Cornelia Huck <cohuck@redhat.com>, Farhan Ali <alifm@linux.ibm.com>
Cc:     Halil Pasic <pasic@linux.ibm.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, Eric Farman <farman@linux.ibm.com>
Subject: [RFC PATCH v1 0/5] s390: more vfio-ccw code rework
Date:   Tue, 18 Jun 2019 22:23:47 +0200
X-Mailer: git-send-email 2.17.1
X-TM-AS-GCONF: 00
x-cbid: 19061820-0008-0000-0000-000002F4E2B7
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19061820-0009-0000-0000-00002261FBA2
Message-Id: <20190618202352.39702-1-farman@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-18_09:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=941 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906180161
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

A couple little improvements to the malloc load in vfio-ccw.
Really, there were just (the first) two patches, but then I
got excited and added a few stylistic ones to the end.

The routine ccwchain_calc_length() has this basic structure:

  ccwchain_calc_length
    a0 = kcalloc(CCWCHAIN_LEN_MAX, sizeof(struct ccw1))
    copy_ccw_from_iova(a0, src)
      copy_from_iova
        pfn_array_alloc
          b = kcalloc(len, sizeof(*pa_iova_pfn + *pa_pfn)
        pfn_array_pin
          vfio_pin_pages
        memcpy(a0, src)
        pfn_array_unpin_free
          vfio_unpin_pages
          kfree(b)
    kfree(a0)

We do this EVERY time we process a new channel program chain,
meaning at least once per SSCH and more if TICs are involved,
to figure out how many CCWs are chained together.  Once that
is determined, a new piece of memory is allocated (call it a1)
and then passed to copy_ccw_from_iova() again, but for the
value calculated by ccwchain_calc_length().

This seems inefficient.

Patch 1 moves the malloc of a0 from the CCW processor to the
initialization of the device.  Since only one SSCH can be
handled concurrently, we can use this space safely to
determine how long the chain being processed actually is.

Patch 2 then removes the second copy_ccw_from_iova() call
entirely, and replaces it with a memcpy from a0 to a1.  This
is done before we process a TIC and thus a second chain, so
there is no overlap in the storage in channel_program.

Patches 3-5 clean up some things that aren't as clear as I'd
like, but didn't want to pollute the first two changes.
For example, patch 3 moves the population of guest_cp to the
same routine that copies from it, rather than in a called
function.  Meanwhile, patch 4 (and thus, 5) was something I
had lying around for quite some time, because it looked to
be structured weird.  Maybe that's one bridge too far.

Eric Farman (5):
  vfio-ccw: Move guest_cp storage into common struct
  vfio-ccw: Skip second copy of guest cp to host
  vfio-ccw: Copy CCW data outside length calculation
  vfio-ccw: Factor out the ccw0-to-ccw1 transition
  vfio-ccw: Remove copy_ccw_from_iova()

 drivers/s390/cio/vfio_ccw_cp.c  | 108 +++++++++++---------------------
 drivers/s390/cio/vfio_ccw_cp.h  |   7 +++
 drivers/s390/cio/vfio_ccw_drv.c |   7 +++
 3 files changed, 52 insertions(+), 70 deletions(-)

-- 
2.17.1

