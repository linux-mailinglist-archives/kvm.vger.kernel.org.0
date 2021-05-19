Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F388138896D
	for <lists+kvm@lfdr.de>; Wed, 19 May 2021 10:29:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245202AbhESI3H (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 May 2021 04:29:07 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:22488 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S245142AbhESI3G (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 19 May 2021 04:29:06 -0400
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14J83piO073952;
        Wed, 19 May 2021 04:27:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=wm8EzEp0hbruUfdJVkUo5iG8w+LwCA4Z3V8AkVbpEus=;
 b=Q4TTDnIOiohW6VGC2P0Ph+0bsq2I8GhgR8RXjCrI+8ltPBaDvYUMVOd8aO0fqNGbKmvj
 0ZdWhOCvffcrI4equb/nTySABNqAE1YWv1tKmt9DDMvLebPHnXBPWsvPwhcQgdIzSmuR
 wrlDH/MNa2QQwx3VoL/bvUx0ytF5hKhPFIvjCDSs+eLCDE9R630rpNvcMGocpdrB05MU
 H+Z0inW+JW8sJg29wBrEXyG+D+O5GcJM8BgXWmZqbuIUTY4ulyDCpAzqK0oabOaBNmN3
 mH+uy3PSn5erq+sY8Uplyf9W1BfkgVr6Mw6PQtq8sXj57RRNuuq/DsRv6RXOhK+E3GNy xg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 38mxj1162y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 19 May 2021 04:27:46 -0400
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 14J8Rksp192724;
        Wed, 19 May 2021 04:27:46 -0400
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com with ESMTP id 38mxj1162d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 19 May 2021 04:27:45 -0400
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 14J8M9Ja022436;
        Wed, 19 May 2021 08:27:44 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma02fra.de.ibm.com with ESMTP id 38mceh8ad0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 19 May 2021 08:27:44 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 14J8RD4B34144738
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 19 May 2021 08:27:13 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0A46D42041;
        Wed, 19 May 2021 08:27:41 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3DF3B42042;
        Wed, 19 May 2021 08:27:40 +0000 (GMT)
Received: from linux01.pok.stglabs.ibm.com (unknown [9.114.17.81])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 19 May 2021 08:27:40 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, david@redhat.com, cohuck@redhat.com,
        linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        thuth@redhat.com
Subject: [kvm-unit-tests PATCH v2 1/3] s390x: sclp: Only fetch read info byte 134 if cpu entries are above it
Date:   Wed, 19 May 2021 08:26:46 +0000
Message-Id: <20210519082648.46803-2-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210519082648.46803-1-frankja@linux.ibm.com>
References: <20210519082648.46803-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: YLOFJvebgh-j4HBMJuFB8KUkbzNK_Qan
X-Proofpoint-ORIG-GUID: i6th0VspFX8HMN-O0vVKpOtXl1SMxyfF
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-19_02:2021-05-18,2021-05-19 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 mlxlogscore=999 impostorscore=0 adultscore=0 bulkscore=0
 clxscore=1015 suspectscore=0 mlxscore=0 spamscore=0 lowpriorityscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105190059
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The cpu offset tells us where the cpu entries are in the sclp read
info structure.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Cornelia Huck <cohuck@redhat.com>
---
 lib/s390x/sclp.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/lib/s390x/sclp.c b/lib/s390x/sclp.c
index 7a9b2c52..f11c2035 100644
--- a/lib/s390x/sclp.c
+++ b/lib/s390x/sclp.c
@@ -138,7 +138,8 @@ void sclp_facilities_setup(void)
 	assert(read_info);
 
 	cpu = sclp_get_cpu_entries();
-	sclp_facilities.has_diag318 = read_info->byte_134_diag318;
+	if (read_info->offset_cpu > 134)
+		sclp_facilities.has_diag318 = read_info->byte_134_diag318;
 	for (i = 0; i < read_info->entries_cpu; i++, cpu++) {
 		/*
 		 * The logic for only reading the facilities from the
-- 
2.30.2

