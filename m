Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B3DF81E5AE
	for <lists+kvm@lfdr.de>; Wed, 15 May 2019 01:42:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726748AbfENXm6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 May 2019 19:42:58 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:58648 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726195AbfENXm6 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 14 May 2019 19:42:58 -0400
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x4ENLrCA094064
        for <kvm@vger.kernel.org>; Tue, 14 May 2019 19:42:56 -0400
Received: from e06smtp02.uk.ibm.com (e06smtp02.uk.ibm.com [195.75.94.98])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2sg66qu1a6-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 14 May 2019 19:42:56 -0400
Received: from localhost
        by e06smtp02.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <farman@linux.ibm.com>;
        Wed, 15 May 2019 00:42:54 +0100
Received: from b06cxnps4076.portsmouth.uk.ibm.com (9.149.109.198)
        by e06smtp02.uk.ibm.com (192.168.101.132) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Wed, 15 May 2019 00:42:53 +0100
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x4ENgpGI44433562
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 May 2019 23:42:51 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 92E1742041;
        Tue, 14 May 2019 23:42:51 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7FD2842047;
        Tue, 14 May 2019 23:42:51 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Tue, 14 May 2019 23:42:51 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 4958)
        id 2C7C8E05E7; Wed, 15 May 2019 01:42:51 +0200 (CEST)
From:   Eric Farman <farman@linux.ibm.com>
To:     Cornelia Huck <cohuck@redhat.com>, Farhan Ali <alifm@linux.ibm.com>
Cc:     Halil Pasic <pasic@linux.ibm.com>,
        Pierre Morel <pmorel@linux.ibm.com>,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        Eric Farman <farman@linux.ibm.com>
Subject: [PATCH v2 1/7] s390/cio: Update SCSW if it points to the end of the chain
Date:   Wed, 15 May 2019 01:42:42 +0200
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190514234248.36203-1-farman@linux.ibm.com>
References: <20190514234248.36203-1-farman@linux.ibm.com>
X-TM-AS-GCONF: 00
x-cbid: 19051423-0008-0000-0000-000002E6B4D8
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19051423-0009-0000-0000-000022535161
Message-Id: <20190514234248.36203-2-farman@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-14_13:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1905140153
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Per the POPs [1], when processing an interrupt the SCSW.CPA field of an
IRB generally points to 8 bytes after the last CCW that was executed
(there are exceptions, but this is the most common behavior).

In the case of an error, this points us to the first un-executed CCW
in the chain.  But in the case of normal I/O, the address points beyond
the end of the chain.  While the guest generally only cares about this
when possibly restarting a channel program after error recovery, we
should convert the address even in the good scenario so that we provide
a consistent, valid, response upon I/O completion.

[1] Figure 16-6 in SA22-7832-11.  The footnotes in that table also state
that this is true even if the resulting address is invalid or protected,
but moving to the end of the guest chain should not be a surprise.

Signed-off-by: Eric Farman <farman@linux.ibm.com>
---
 drivers/s390/cio/vfio_ccw_cp.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/s390/cio/vfio_ccw_cp.c b/drivers/s390/cio/vfio_ccw_cp.c
index 384b3987eeb4..41f48b8790bc 100644
--- a/drivers/s390/cio/vfio_ccw_cp.c
+++ b/drivers/s390/cio/vfio_ccw_cp.c
@@ -870,7 +870,11 @@ void cp_update_scsw(struct channel_program *cp, union scsw *scsw)
 	 */
 	list_for_each_entry(chain, &cp->ccwchain_list, next) {
 		ccw_head = (u32)(u64)chain->ch_ccw;
-		if (is_cpa_within_range(cpa, ccw_head, chain->ch_len)) {
+		/*
+		 * On successful execution, cpa points just beyond the end
+		 * of the chain.
+		 */
+		if (is_cpa_within_range(cpa, ccw_head, chain->ch_len + 1)) {
 			/*
 			 * (cpa - ccw_head) is the offset value of the host
 			 * physical ccw to its chain head.
-- 
2.17.1

