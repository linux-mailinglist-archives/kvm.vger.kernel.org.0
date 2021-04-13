Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E39035E645
	for <lists+kvm@lfdr.de>; Tue, 13 Apr 2021 20:25:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347650AbhDMSYj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Apr 2021 14:24:39 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:59878 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1347643AbhDMSYi (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 13 Apr 2021 14:24:38 -0400
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 13DI3MYB141482;
        Tue, 13 Apr 2021 14:24:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=iVZvMMs/efkGygppdSTS1PcuDAYDe00R8Isl46tHuf0=;
 b=AjpSak88hNl6SWLyUIVYPZ79n+3x92zjBNRmaf0kaht9luEPRWaI1itrCzkuBQts4BrS
 OLT4movdH2ygoo0PllvLbzFVRJcrZPedtgK0BTqxkxRh++69Nr0oTYzx9CONJf/pG7hb
 vF3HKuiDTiGxUItRnrYpmE9b509B1XA4rYkoiqXao5/KKalSwBztcMXsKFsMQDuM7OlI
 g2WrWYa3RZpCh8LvoKfvRY65JlRjifZbPW87Bg+msiyziLG0Ttxkgmuxryjl435ehgQQ
 bO69OCy2rqSVi1gR1a/lcYzJleUd4P877b3gbARsnJXtK7voDMxu/JqNXRrbIbyJJEhO cQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37vkpk1yxh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 13 Apr 2021 14:24:18 -0400
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 13DI3cHU142836;
        Tue, 13 Apr 2021 14:24:18 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37vkpk1ywn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 13 Apr 2021 14:24:18 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 13DIMXMG002366;
        Tue, 13 Apr 2021 18:24:15 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma04ams.nl.ibm.com with ESMTP id 37u3n8tueh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 13 Apr 2021 18:24:15 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 13DIOCBX23724502
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Apr 2021 18:24:13 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D90BD11C050;
        Tue, 13 Apr 2021 18:24:12 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C777211C04A;
        Tue, 13 Apr 2021 18:24:12 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Tue, 13 Apr 2021 18:24:12 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 4958)
        id 7BE81E047D; Tue, 13 Apr 2021 20:24:12 +0200 (CEST)
From:   Eric Farman <farman@linux.ibm.com>
To:     Cornelia Huck <cohuck@redhat.com>,
        Halil Pasic <pasic@linux.ibm.com>
Cc:     Matthew Rosato <mjrosato@linux.ibm.com>,
        Jared Rossi <jrossi@linux.ibm.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, Eric Farman <farman@linux.ibm.com>
Subject: [RFC PATCH v4 1/4] vfio-ccw: Check initialized flag in cp_init()
Date:   Tue, 13 Apr 2021 20:24:07 +0200
Message-Id: <20210413182410.1396170-2-farman@linux.ibm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210413182410.1396170-1-farman@linux.ibm.com>
References: <20210413182410.1396170-1-farman@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: pZGF1yLkdtTN5uVk2a90FKzpxvWor71P
X-Proofpoint-ORIG-GUID: V3XYCC8bXPrg0PiTPVs0pJRNcQvobB58
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-04-13_12:2021-04-13,2021-04-13 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 spamscore=0
 impostorscore=0 malwarescore=0 mlxlogscore=999 mlxscore=0
 lowpriorityscore=0 clxscore=1015 adultscore=0 phishscore=0
 priorityscore=1501 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2104060000 definitions=main-2104130122
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

