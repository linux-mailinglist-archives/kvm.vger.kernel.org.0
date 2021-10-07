Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47115424F93
	for <lists+kvm@lfdr.de>; Thu,  7 Oct 2021 10:53:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240203AbhJGIzd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Oct 2021 04:55:33 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:8446 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S231661AbhJGIzc (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 7 Oct 2021 04:55:32 -0400
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1978Muic019436;
        Thu, 7 Oct 2021 04:53:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=1IgqnY2S9Cl+JU0Q6jh6JwpEdBL6LiL9JGoNXR/r2hs=;
 b=WPQhoEowswNmrIzzMwg/hWuT0ejLTociDJ2VMUPz9Mn0XSPKri1osI4Ko4FsM/AsiAuN
 RwiLdFoCQTrePZP4SKi/569J6H7N78o0HhA/0VRetHJXJ65IVRgP3j4pZOeEmU9Gfn3n
 xaol4FyFfYGzSWhj73PSl+NLq+AjrPUEysoCmWvaYymiUH1I4Xo2OdBMDQuBmCaqZdqo
 VeBUePI800LjS+suU7O/igy1JzShPCqT2c5g+k3DdwrSCTtyvrdW+0w7dTH4E+9t2/cB
 hRziPfTWpxM9OT8yOlKA+IfmgVX8jFHrZ23jJbJv6phNGSxfKEP81RcfIQrb7bUtYb+j XA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3bhhkny8vj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 07 Oct 2021 04:53:39 -0400
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1978O5EX006491;
        Thu, 7 Oct 2021 04:53:38 -0400
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3bhhkny8ut-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 07 Oct 2021 04:53:38 -0400
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1978pvE8013521;
        Thu, 7 Oct 2021 08:53:36 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma04fra.de.ibm.com with ESMTP id 3bef2ajp8x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 07 Oct 2021 08:53:36 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1978q7EI36700670
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 7 Oct 2021 08:52:07 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BF1EDAE05F;
        Thu,  7 Oct 2021 08:52:06 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7B64FAE08F;
        Thu,  7 Oct 2021 08:52:04 +0000 (GMT)
Received: from linux6.. (unknown [9.114.12.104])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu,  7 Oct 2021 08:52:04 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        david@redhat.com, thuth@redhat.com, seiden@linux.ibm.com,
        scgl@linux.ibm.com
Subject: [kvm-unit-tests PATCH v3 8/9] s390x: snippets: Set stackptr and stacktop in cstart.S
Date:   Thu,  7 Oct 2021 08:50:26 +0000
Message-Id: <20211007085027.13050-9-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211007085027.13050-1-frankja@linux.ibm.com>
References: <20211007085027.13050-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: Taza0J2yhzIsy-EWQv3TpODPrgDMgz8X
X-Proofpoint-GUID: cJqNJfCmsdh__R7MHQ72-rkgjHyC7eNM
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-10-06_04,2021-10-07_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 spamscore=0 malwarescore=0 suspectscore=0 adultscore=0 phishscore=0
 clxscore=1015 impostorscore=0 lowpriorityscore=0 mlxlogscore=999
 bulkscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110070059
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We have a stack, so why not define it and be a step closer to include
the lib into the snippets.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 s390x/snippets/c/cstart.S | 2 +-
 s390x/snippets/c/flat.lds | 2 ++
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/s390x/snippets/c/cstart.S b/s390x/snippets/c/cstart.S
index a1754808..031a6b83 100644
--- a/s390x/snippets/c/cstart.S
+++ b/s390x/snippets/c/cstart.S
@@ -17,7 +17,7 @@ start:
 	xgr \i,\i
 	.endr
 	/* 0x3000 is the stack page for now */
-	lghi	%r15, 0x4000 - 160
+	lghi	%r15, stackptr
 	sam64
 	brasl	%r14, main
 	/* For now let's only use cpu 0 in snippets so this will always work. */
diff --git a/s390x/snippets/c/flat.lds b/s390x/snippets/c/flat.lds
index ce3bfd69..59974b38 100644
--- a/s390x/snippets/c/flat.lds
+++ b/s390x/snippets/c/flat.lds
@@ -15,6 +15,8 @@ SECTIONS
 		 QUAD(0x0000000000004000)
 	}
 	. = 0x4000;
+	stackptr = . - 160;
+	stacktop = .;
 	.text : {
 		*(.init)
 		*(.text)
-- 
2.30.2

