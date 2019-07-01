Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EE7FC37ECB
	for <lists+kvm@lfdr.de>; Thu,  6 Jun 2019 22:29:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727201AbfFFU2v (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Jun 2019 16:28:51 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:36152 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727017AbfFFU2l (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 6 Jun 2019 16:28:41 -0400
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x56KQtw5059134
        for <kvm@vger.kernel.org>; Thu, 6 Jun 2019 16:28:40 -0400
Received: from e06smtp02.uk.ibm.com (e06smtp02.uk.ibm.com [195.75.94.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2sy78q7dce-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 06 Jun 2019 16:28:40 -0400
Received: from localhost
        by e06smtp02.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <farman@linux.ibm.com>;
        Thu, 6 Jun 2019 21:28:37 +0100
Received: from b06avi18878370.portsmouth.uk.ibm.com (9.149.26.194)
        by e06smtp02.uk.ibm.com (192.168.101.132) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 6 Jun 2019 21:28:35 +0100
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x56KSXAb25952752
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 6 Jun 2019 20:28:33 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D715C11C054;
        Thu,  6 Jun 2019 20:28:33 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C528311C052;
        Thu,  6 Jun 2019 20:28:33 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Thu,  6 Jun 2019 20:28:33 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 4958)
        id 507D2E0250; Thu,  6 Jun 2019 22:28:33 +0200 (CEST)
From:   Eric Farman <farman@linux.ibm.com>
To:     Cornelia Huck <cohuck@redhat.com>, Farhan Ali <alifm@linux.ibm.com>
Cc:     Halil Pasic <pasic@linux.ibm.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, Eric Farman <farman@linux.ibm.com>
Subject: [PATCH v2 0/9] s390: vfio-ccw code rework
Date:   Thu,  6 Jun 2019 22:28:22 +0200
X-Mailer: git-send-email 2.17.1
X-TM-AS-GCONF: 00
x-cbid: 19060620-0008-0000-0000-000002F0EC0D
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19060620-0009-0000-0000-0000225DD9CE
Message-Id: <20190606202831.44135-1-farman@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-06_14:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=665 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906060138
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Now that we've gotten a lot of other series either merged or
pending for the next merge window, I'd like to revisit some
code simplification that I started many moons ago.

In that first series, a couple of fixes got merged into 4.20,
a couple more got some "seems okay" acks/reviews, and the rest
were nearly forgotten about.  I dusted them off and did quite a
bit of rework to make things a little more sequential and
providing a better narrative (I think) based on the lessons we
learned in my earlier changes.  Because of this rework, the
acks/reviews on the first version didn't really translate to the
code that exists here (patch 1 being the closest exception), so
I didn't apply any of them here.  The end result is mostly the
same as before, but now looks like this:

Patch summary:
1:   Squash duplicate code
2-4: Remove duplicate code in CCW processor
5-7: Remove one layer of nested arrays
8-9: Combine direct/indirect addressing CCW processors

Using 5.2.0-rc3 as a base plus the vfio-ccw branch of recent fixes,
we shrink the code quite a bit (8.7% according to the bloat-o-meter),
and we remove one set of mallocs/frees on the I/O path by removing
one layer of the nested arrays.  There are no functional/behavioral
changes with this series; all the tests that I would run previously
continue to pass/fail as they today.

Changelog:
 v1/RFC->v2:
  - [Eric] Dropped first two patches, as they have been merged
  - [Eric] Shuffling of patches for readability/understandability
  - [Halil] Actually added meaningful comments/commit messages
    in the patches
 v1/RFC: https://patchwork.kernel.org/cover/10675251/

Eric Farman (9):
  s390/cio: Squash cp_free() and cp_unpin_free()
  s390/cio: Refactor the routine that handles TIC CCWs
  s390/cio: Generalize the TIC handler
  s390/cio: Use generalized CCW handler in cp_init()
  vfio-ccw: Rearrange pfn_array and pfn_array_table arrays
  vfio-ccw: Adjust the first IDAW outside of the nested loops
  vfio-ccw: Remove pfn_array_table
  vfio-ccw: Rearrange IDAL allocation in direct CCW
  s390/cio: Combine direct and indirect CCW paths

 drivers/s390/cio/vfio_ccw_cp.c | 313 +++++++++++----------------------
 1 file changed, 102 insertions(+), 211 deletions(-)

-- 
2.17.1

