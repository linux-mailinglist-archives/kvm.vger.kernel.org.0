Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2953E2FBDF3
	for <lists+kvm@lfdr.de>; Tue, 19 Jan 2021 18:44:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390684AbhASOts (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Jan 2021 09:49:48 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:10748 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2389552AbhASKFs (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 19 Jan 2021 05:05:48 -0500
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 10JA3UxX030299;
        Tue, 19 Jan 2021 05:05:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=8H7BE5qafj9KsQRDUGOWKDm4V/rUGUehRQilH/Unm4w=;
 b=CcfsM8W/yq9Sj0dNXTzudrdOF4Ksw4zKsABGzSMuxMBrpTgEKlt897Uyay5BDkk4CGFC
 hGZvLX4n2pmqqD+60E3sqikOtDrR3Q/bZILD1e2Z8q8qhj3/L2ZviPkvZrh0fqAXKfSs
 OvYnRS1ZBKVwaUa5U1zk7VFYMxvfmMdVvNn007+Evuo/ObQR+hwFCqO80IZvTTaVm1G2
 sYa9gfKqBpM87fgN1H9OOUSiMblk6rzwIAmHTk9U7rh00Wdd0fghTMW7b5kLsMUChETe
 bUo+O2NHjK4KCuLf1EPCQDZyLb2AA0pHoHpGWp08XF1jCAFdJ3VQ8NXsmiTJSmKgqcxK Qg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 365w2hgfts-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 19 Jan 2021 05:05:07 -0500
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 10JA56mm038560;
        Tue, 19 Jan 2021 05:05:06 -0500
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com with ESMTP id 365w2hgfrj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 19 Jan 2021 05:05:06 -0500
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 10JA3Swq002255;
        Tue, 19 Jan 2021 10:05:03 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma05fra.de.ibm.com with ESMTP id 363qs89gj0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 19 Jan 2021 10:05:03 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 10JA50n77733530
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 19 Jan 2021 10:05:00 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9216A4C046;
        Tue, 19 Jan 2021 10:05:00 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8E1284C050;
        Tue, 19 Jan 2021 10:04:59 +0000 (GMT)
Received: from linux01.pok.stglabs.ibm.com (unknown [9.114.17.81])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 19 Jan 2021 10:04:59 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     linux-kernel@vger.kernel.org
Cc:     kvm@vger.kernel.org, thuth@redhat.com, david@redhat.com,
        borntraeger@de.ibm.com, imbrenda@linux.ibm.com, cohuck@redhat.com,
        linux-s390@vger.kernel.org, gor@linux.ibm.com,
        mihajlov@linux.ibm.com
Subject: [PATCH 1/2] s390: uv: Fix sysfs max number of VCPUs reporting
Date:   Tue, 19 Jan 2021 05:04:01 -0500
Message-Id: <20210119100402.84734-2-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210119100402.84734-1-frankja@linux.ibm.com>
References: <20210119100402.84734-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-19_02:2021-01-18,2021-01-19 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999
 impostorscore=0 bulkscore=0 mlxscore=0 lowpriorityscore=0 malwarescore=0
 priorityscore=1501 clxscore=1015 phishscore=0 adultscore=0 spamscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101190058
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The number reported by the query is N-1 and I think people reading the
sysfs file would expect N instead. For users creating VMs there's no
actual difference because KVM's limit is currently below the UV's
limit.

The naming of the field is a bit misleading. Number in this context is
used like ID and starts at 0. The query field denotes the maximum
number that can be put into the VCPU number field in the "create
secure CPU" UV call.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Fixes: a0f60f8431999 ("s390/protvirt: Add sysfs firmware interface for Ultravisor information")
Cc: stable@vger.kernel.org
---
 arch/s390/boot/uv.c        | 2 +-
 arch/s390/include/asm/uv.h | 4 ++--
 arch/s390/kernel/uv.c      | 2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/s390/boot/uv.c b/arch/s390/boot/uv.c
index a15c033f53ca..afb721082989 100644
--- a/arch/s390/boot/uv.c
+++ b/arch/s390/boot/uv.c
@@ -35,7 +35,7 @@ void uv_query_info(void)
 		uv_info.guest_cpu_stor_len = uvcb.cpu_stor_len;
 		uv_info.max_sec_stor_addr = ALIGN(uvcb.max_guest_stor_addr, PAGE_SIZE);
 		uv_info.max_num_sec_conf = uvcb.max_num_sec_conf;
-		uv_info.max_guest_cpus = uvcb.max_guest_cpus;
+		uv_info.max_guest_cpu_id = uvcb.max_guest_cpu_num;
 	}
 
 #ifdef CONFIG_PROTECTED_VIRTUALIZATION_GUEST
diff --git a/arch/s390/include/asm/uv.h b/arch/s390/include/asm/uv.h
index 0325fc0469b7..c484c95ea142 100644
--- a/arch/s390/include/asm/uv.h
+++ b/arch/s390/include/asm/uv.h
@@ -96,7 +96,7 @@ struct uv_cb_qui {
 	u32 max_num_sec_conf;
 	u64 max_guest_stor_addr;
 	u8  reserved88[158 - 136];
-	u16 max_guest_cpus;
+	u16 max_guest_cpu_num;
 	u8  reserveda0[200 - 160];
 } __packed __aligned(8);
 
@@ -273,7 +273,7 @@ struct uv_info {
 	unsigned long guest_cpu_stor_len;
 	unsigned long max_sec_stor_addr;
 	unsigned int max_num_sec_conf;
-	unsigned short max_guest_cpus;
+	unsigned short max_guest_cpu_id;
 };
 
 extern struct uv_info uv_info;
diff --git a/arch/s390/kernel/uv.c b/arch/s390/kernel/uv.c
index 883bfed9f5c2..b2d2ad153067 100644
--- a/arch/s390/kernel/uv.c
+++ b/arch/s390/kernel/uv.c
@@ -368,7 +368,7 @@ static ssize_t uv_query_max_guest_cpus(struct kobject *kobj,
 				       struct kobj_attribute *attr, char *page)
 {
 	return scnprintf(page, PAGE_SIZE, "%d\n",
-			uv_info.max_guest_cpus);
+			uv_info.max_guest_cpu_id + 1);
 }
 
 static struct kobj_attribute uv_query_max_guest_cpus_attr =
-- 
2.25.1

