Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 060ED3798A9
	for <lists+kvm@lfdr.de>; Mon, 10 May 2021 22:57:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232932AbhEJU6D (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 May 2021 16:58:03 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:63442 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S232082AbhEJU6A (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 10 May 2021 16:58:00 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14AKXhAt070264;
        Mon, 10 May 2021 16:56:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=p0284PXPUHhf4NkH9CJp5lmWMmZESNYJC4ZxS8XqRVc=;
 b=Je7TkvCHmX3GDq1TXwEg9fDV8G+CelW2HBCuCF1wNvmNllbJkm6kTiZ3sYrx6AUVAHnO
 0nirtOtwxnaeuNXdGOcYmGj2JF6ZFtCXyImNKnKq98r4eEyA968qpSmYD0ujJ/crvJ3C
 1YEd1amXwssmoR1eshltx4IKm+PqgNdw6D1VeZUcPJda4HwEGPNgMzN+dPDxGNwioY7B
 0mEvt37hrSUVR7CjAyRo4TY8ZiQoi7InAoiacYYuaNHOL//9M2hEgy0eY1UZjtfzZ704
 M+QTKh1ZT+41zHBpyyreMwSiHuEiaPxvclsTxMREQbQ+Ni403b9qJN47N9gOaS10TErV 1g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 38fb032n9y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 10 May 2021 16:56:54 -0400
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 14AKamqN082039;
        Mon, 10 May 2021 16:56:53 -0400
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0b-001b2d01.pphosted.com with ESMTP id 38fb032n93-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 10 May 2021 16:56:53 -0400
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 14AKqYVe018052;
        Mon, 10 May 2021 20:56:51 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma06ams.nl.ibm.com with ESMTP id 38dhwh99fw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 10 May 2021 20:56:51 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 14AKumRC31981994
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 10 May 2021 20:56:48 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9D41642045;
        Mon, 10 May 2021 20:56:48 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8A4514203F;
        Mon, 10 May 2021 20:56:48 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Mon, 10 May 2021 20:56:48 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 4958)
        id 2F576E047A; Mon, 10 May 2021 22:56:48 +0200 (CEST)
From:   Eric Farman <farman@linux.ibm.com>
To:     Cornelia Huck <cohuck@redhat.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>
Cc:     Jared Rossi <jrossi@linux.ibm.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, Eric Farman <farman@linux.ibm.com>
Subject: [RFC PATCH v5 2/3] vfio-ccw: Reset FSM state to IDLE inside FSM
Date:   Mon, 10 May 2021 22:56:45 +0200
Message-Id: <20210510205646.1845844-3-farman@linux.ibm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210510205646.1845844-1-farman@linux.ibm.com>
References: <20210510205646.1845844-1-farman@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: WPxMYi9V9fwZLMVn2ucakNhU1tQfL_Hn
X-Proofpoint-GUID: SO2ScjRarnnx56lVmbzZHU5s2Zw0B_V5
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-10_12:2021-05-10,2021-05-10 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999
 lowpriorityscore=0 phishscore=0 malwarescore=0 adultscore=0 bulkscore=0
 clxscore=1015 priorityscore=1501 impostorscore=0 spamscore=0 mlxscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105100140
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When an I/O request is made, the fsm_io_request() routine
moves the FSM state from IDLE to CP_PROCESSING, and then
fsm_io_helper() moves it to CP_PENDING if the START SUBCHANNEL
received a cc0. Yet, the error case to go from CP_PROCESSING
back to IDLE is done after the FSM call returns.

Let's move this up into the FSM proper, to provide some
better symmetry when unwinding in this case.

Signed-off-by: Eric Farman <farman@linux.ibm.com>
Reviewed-by: Cornelia Huck <cohuck@redhat.com>
---
 drivers/s390/cio/vfio_ccw_fsm.c | 1 +
 drivers/s390/cio/vfio_ccw_ops.c | 2 --
 2 files changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/s390/cio/vfio_ccw_fsm.c b/drivers/s390/cio/vfio_ccw_fsm.c
index 23e61aa638e4..e435a9cd92da 100644
--- a/drivers/s390/cio/vfio_ccw_fsm.c
+++ b/drivers/s390/cio/vfio_ccw_fsm.c
@@ -318,6 +318,7 @@ static void fsm_io_request(struct vfio_ccw_private *private,
 	}
 
 err_out:
+	private->state = VFIO_CCW_STATE_IDLE;
 	trace_vfio_ccw_fsm_io_request(scsw->cmd.fctl, schid,
 				      io_region->ret_code, errstr);
 }
diff --git a/drivers/s390/cio/vfio_ccw_ops.c b/drivers/s390/cio/vfio_ccw_ops.c
index 767ac41686fe..5971641964c6 100644
--- a/drivers/s390/cio/vfio_ccw_ops.c
+++ b/drivers/s390/cio/vfio_ccw_ops.c
@@ -276,8 +276,6 @@ static ssize_t vfio_ccw_mdev_write_io_region(struct vfio_ccw_private *private,
 	}
 
 	vfio_ccw_fsm_event(private, VFIO_CCW_EVENT_IO_REQ);
-	if (region->ret_code != 0)
-		private->state = VFIO_CCW_STATE_IDLE;
 	ret = (region->ret_code != 0) ? region->ret_code : count;
 
 out_unlock:
-- 
2.25.1

