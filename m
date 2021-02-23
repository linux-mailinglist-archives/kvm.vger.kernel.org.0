Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA001322BF2
	for <lists+kvm@lfdr.de>; Tue, 23 Feb 2021 15:09:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231717AbhBWOIw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Feb 2021 09:08:52 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:61664 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229996AbhBWOIr (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 23 Feb 2021 09:08:47 -0500
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 11NE2ZEH155325;
        Tue, 23 Feb 2021 09:08:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=G1PDUqDMpsNe0ntgFx4AwBRrGhhIiVEZj41qImbLcWc=;
 b=iYDnL5TytSZ66V7xK2m0fENph+8vO4rCwAqZZu+PNDiYwwBU/uNXte6sveregjDr8Xre
 aYONx2lQVEoYg4lZONJPd/uCF9lCxSUYfmqwgRc5MOEEliOuOZTRov9s8E3HdGxrXe5r
 1Nr3Jdr0GypeoQqyp08i+QEMjKyUJaV6SdzkMldhs7T9EFQjDGozDDUt1Rr9f7aXYzr3
 xVTNwNC+bQj5Lw86gGOnoXRAYhMoQfEEni3X8hSoa9bbdT1/mJXFnrUMEW4A5DZuRBaL
 HkfKghZqgeedLfQPpph9jv5YUoaR+/2rp4gvJm+L7suMzFKdRuvBXf8dNUYzHQhjfLpX Wg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 36vkndqy3d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 23 Feb 2021 09:08:06 -0500
Received: from m0098413.ppops.net (m0098413.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 11NE34Bb157143;
        Tue, 23 Feb 2021 09:08:05 -0500
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0b-001b2d01.pphosted.com with ESMTP id 36vkndqy2f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 23 Feb 2021 09:08:05 -0500
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 11NE845P017814;
        Tue, 23 Feb 2021 14:08:04 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma06ams.nl.ibm.com with ESMTP id 36tsph2nuh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 23 Feb 2021 14:08:04 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 11NE7mKn30212438
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 23 Feb 2021 14:07:48 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1BC40A407E;
        Tue, 23 Feb 2021 14:08:01 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AA0E0A4081;
        Tue, 23 Feb 2021 14:08:00 +0000 (GMT)
Received: from ibm-vm.ibmuc.com (unknown [9.145.5.213])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 23 Feb 2021 14:08:00 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, david@redhat.com, thuth@redhat.com,
        frankja@linux.ibm.com, cohuck@redhat.com, pmorel@linux.ibm.com
Subject: [kvm-unit-tests PATCH v2 1/5] libcflat: add SZ_1M and SZ_2G
Date:   Tue, 23 Feb 2021 15:07:55 +0100
Message-Id: <20210223140759.255670-2-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210223140759.255670-1-imbrenda@linux.ibm.com>
References: <20210223140759.255670-1-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-02-23_07:2021-02-23,2021-02-23 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 bulkscore=0
 mlxlogscore=999 impostorscore=0 lowpriorityscore=0 clxscore=1015
 phishscore=0 adultscore=0 priorityscore=1501 malwarescore=0 spamscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102230119
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add SZ_1M and SZ_2G to libcflat.h

s390x needs those for large/huge pages

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Reviewed-by: Thomas Huth <thuth@redhat.com>
---
 lib/libcflat.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/lib/libcflat.h b/lib/libcflat.h
index 460a1234..8dac0621 100644
--- a/lib/libcflat.h
+++ b/lib/libcflat.h
@@ -157,7 +157,9 @@ extern void setup_vm(void);
 #define SZ_8K			(1 << 13)
 #define SZ_16K			(1 << 14)
 #define SZ_64K			(1 << 16)
+#define SZ_1M			(1 << 20)
 #define SZ_2M			(1 << 21)
 #define SZ_1G			(1 << 30)
+#define SZ_2G			(1ul << 31)
 
 #endif
-- 
2.26.2

