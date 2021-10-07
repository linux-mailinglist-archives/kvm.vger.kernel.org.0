Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CFAA424F82
	for <lists+kvm@lfdr.de>; Thu,  7 Oct 2021 10:52:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240529AbhJGIx6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Oct 2021 04:53:58 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:31442 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S240489AbhJGIxz (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 7 Oct 2021 04:53:55 -0400
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1978DCAx030499;
        Thu, 7 Oct 2021 04:52:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=2arVfakYICkJpKtrNNFqHhYlWTqscLWzUbr8dh7tMME=;
 b=SfO1TD0CzoZHQ/NxOlAGpeVpzb5s9D2R/WbYnFh5AvMarvU6zL0qdowWl60kcSjFAAoe
 mGQMxuhmoDLGgP9JaJ9b6WdYhPQeGl8rK81+Y79MX9tK5zDlzkLmD1tt8Xi2S7cMhH74
 Nty88Jit/V6HjFVwDqu9aL2J1z1H+4HPUpeIsFMQ+VXbQyKJk6AGvIHqyM0RlLjiU4KX
 q9KnKogBiKWTS9QorT0LJwBahvp9MeGbUut1B2C7ol2HJtwHy6Q8tg2tHM5zswsY+Kwc
 v6O6lIeC1oaQTdTbEeF5/TI26xXt9uaagoPNGh0w+JjiHm7qP92ogFQrnv25+yGIy3b6 Xw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3bhcsd78ut-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 07 Oct 2021 04:52:01 -0400
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1978QpP2024584;
        Thu, 7 Oct 2021 04:52:01 -0400
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3bhcsd78uc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 07 Oct 2021 04:52:00 -0400
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1978hAf1015766;
        Thu, 7 Oct 2021 08:51:59 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma06fra.de.ibm.com with ESMTP id 3beepk2u5d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 07 Oct 2021 08:51:58 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1978kUnC29163818
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 7 Oct 2021 08:46:30 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 27CF3AE06E;
        Thu,  7 Oct 2021 08:51:51 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 47A97AE076;
        Thu,  7 Oct 2021 08:51:48 +0000 (GMT)
Received: from linux6.. (unknown [9.114.12.104])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu,  7 Oct 2021 08:51:47 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        david@redhat.com, thuth@redhat.com, seiden@linux.ibm.com,
        scgl@linux.ibm.com
Subject: [kvm-unit-tests PATCH v3 3/9] lib: s390x: uv: Fix share return value and print
Date:   Thu,  7 Oct 2021 08:50:21 +0000
Message-Id: <20211007085027.13050-4-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211007085027.13050-1-frankja@linux.ibm.com>
References: <20211007085027.13050-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 0WSr-B-7M2PDNpzkEOXzKqafgo_dyxLZ
X-Proofpoint-GUID: TiM4FWoH9Qj52CrOBq5xvRadHPnKmmLF
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-10-06_04,2021-10-07_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 spamscore=0
 clxscore=1015 phishscore=0 mlxlogscore=971 priorityscore=1501
 lowpriorityscore=0 adultscore=0 bulkscore=0 malwarescore=0 impostorscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110070059
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Let's only return 0/1 for success/failure respectively.
If needed we can later add rc/rrc pointers so we can check for the
reasons of cc==1 cases like we do in the kernel.

As share() might also be used in snippets it's best not to use prints
to avoid linking problems so lets remove the report_info().

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Acked-by: Thomas Huth <thuth@redhat.com>
---
 lib/s390x/asm/uv.h | 9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

diff --git a/lib/s390x/asm/uv.h b/lib/s390x/asm/uv.h
index ec10d1c4..2f099553 100644
--- a/lib/s390x/asm/uv.h
+++ b/lib/s390x/asm/uv.h
@@ -219,15 +219,8 @@ static inline int share(unsigned long addr, u16 cmd)
 		.header.len = sizeof(uvcb),
 		.paddr = addr
 	};
-	int cc;
 
-	cc = uv_call(0, (u64)&uvcb);
-	if (!cc && uvcb.header.rc == UVC_RC_EXECUTED)
-		return 0;
-
-	report_info("uv_call: cmd %04x cc %d response code: %04x", cc, cmd,
-		    uvcb.header.rc);
-	return -1;
+	return uv_call(0, (u64)&uvcb);
 }
 
 /*
-- 
2.30.2

