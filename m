Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 142403798A6
	for <lists+kvm@lfdr.de>; Mon, 10 May 2021 22:56:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232965AbhEJU6C (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 May 2021 16:58:02 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:53878 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232831AbhEJU6A (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 10 May 2021 16:58:00 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14AKYTs0165979;
        Mon, 10 May 2021 16:56:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=6Ji2N+g5BEfEKgFOPSitgWqnRCwc0MS0b5j0S+cgxRA=;
 b=Nnh86e5uVSApHODvjnvTHYN2M/HTzI9dr9f+BdDWUa3Fphz+DiGAmud7MtzE+lF77hRw
 sQpKex5SG1C9wBNJgaF/Fq8dxTIoN/9/T7dbEhb98CAEU1PQ/Hzz+FkieSWpKhl1+tqG
 i0i+m5qUVbswqRDQ1jujjYoakuafinA7TZLG+e7K6ndijZnXnd0T93zlmotGUW8MARip
 MxJliWcZcWOf5If/vQMEa+QRO0SQ/jCcLcuTg9IbSUq7mZIUOzvEWT82ntkpXf+2o6N6
 ZVEHW8CTOY2j1a35TC9F+88lvTNiqVwQ1uU2mMX/0MbRoCLdUAYyGO2npXZtxO210p7w 6Q== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 38fatrtxjm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 10 May 2021 16:56:54 -0400
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 14AKZEd6168055;
        Mon, 10 May 2021 16:56:53 -0400
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com with ESMTP id 38fatrtxhu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 10 May 2021 16:56:53 -0400
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 14AKulMc025733;
        Mon, 10 May 2021 20:56:51 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma03fra.de.ibm.com with ESMTP id 38dj988pgx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 10 May 2021 20:56:51 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 14AKummR23331152
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 10 May 2021 20:56:48 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9D86F4C050;
        Mon, 10 May 2021 20:56:48 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8ACB24C046;
        Mon, 10 May 2021 20:56:48 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Mon, 10 May 2021 20:56:48 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 4958)
        id 2D21FE0322; Mon, 10 May 2021 22:56:48 +0200 (CEST)
From:   Eric Farman <farman@linux.ibm.com>
To:     Cornelia Huck <cohuck@redhat.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>
Cc:     Jared Rossi <jrossi@linux.ibm.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, Eric Farman <farman@linux.ibm.com>
Subject: [RFC PATCH v5 1/3] vfio-ccw: Check initialized flag in cp_init()
Date:   Mon, 10 May 2021 22:56:44 +0200
Message-Id: <20210510205646.1845844-2-farman@linux.ibm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210510205646.1845844-1-farman@linux.ibm.com>
References: <20210510205646.1845844-1-farman@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: hEPbuEAmc3v0JmYrqTxLBzkEB1nWjYob
X-Proofpoint-ORIG-GUID: 5LRcVOx_A-WpkI-4TH7RQY3fYqgyxHMJ
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-10_12:2021-05-10,2021-05-10 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 impostorscore=0
 spamscore=0 suspectscore=0 phishscore=0 mlxscore=0 lowpriorityscore=0
 priorityscore=1501 adultscore=0 malwarescore=0 mlxlogscore=999
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105100140
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We have a really nice flag in the channel_program struct that
indicates if it had been initialized by cp_init(), and use it
as a guard in the other cp accessor routines, but not for a
duplicate call into cp_init(). The possibility of this occurring
is low, because that flow is protected by the private->io_mutex
and FSM CP_PROCESSING state. But then why bother checking it
in (for example) cp_prefetch() then?

Let's just be consistent and check for that in cp_init() too.

Fixes: 71189f263f8a3 ("vfio-ccw: make it safe to access channel programs")
Signed-off-by: Eric Farman <farman@linux.ibm.com>
Reviewed-by: Cornelia Huck <cohuck@redhat.com>
---
 drivers/s390/cio/vfio_ccw_cp.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/s390/cio/vfio_ccw_cp.c b/drivers/s390/cio/vfio_ccw_cp.c
index b9febc581b1f..8d1b2771c1aa 100644
--- a/drivers/s390/cio/vfio_ccw_cp.c
+++ b/drivers/s390/cio/vfio_ccw_cp.c
@@ -638,6 +638,10 @@ int cp_init(struct channel_program *cp, struct device *mdev, union orb *orb)
 	static DEFINE_RATELIMIT_STATE(ratelimit_state, 5 * HZ, 1);
 	int ret;
 
+	/* this is an error in the caller */
+	if (cp->initialized)
+		return -EBUSY;
+
 	/*
 	 * We only support prefetching the channel program. We assume all channel
 	 * programs executed by supported guests likewise support prefetching.
-- 
2.25.1

