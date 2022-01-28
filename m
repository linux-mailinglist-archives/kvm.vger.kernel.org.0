Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D833B4A0079
	for <lists+kvm@lfdr.de>; Fri, 28 Jan 2022 19:54:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240035AbiA1Sy5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Jan 2022 13:54:57 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:25148 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230165AbiA1Sy4 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 28 Jan 2022 13:54:56 -0500
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20SI8veY021042
        for <kvm@vger.kernel.org>; Fri, 28 Jan 2022 18:54:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=lWT7zeCTqvdk1n/X5pH1b3V0Z8A8x/CzYm86bdpOw4o=;
 b=l9cOxb+qXsRD9wF9NS1+mYleupMvVF68qMXS13plTDq1BxCt5lq36p46zpjwtji+MubA
 h4ZfOCXsgF6ieDjVZgtddaSmz+8osyc8Vde4oWVlxpkeS3oYbgZOpR5Zi10us8Hz5U1E
 G5vq+55FL2dRdUpbbveTGtxnmc81wEb7RiasyKKdbGutI2+FxIH4Bk2d80svSfZdOIxc
 7vsUirM5drtbGtg0UhXLj/0jbiIJZQiWqh3lcP7t7VllYhAA9+BvhV1p7HI8n4B0vhhp
 cFdc+PEt7wCHj1I+QGgq8+wg6+CnNyliEXnGRLA5CkXC4TbtYK5W3R/U8hR3NmKinmgn zA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dvhm3pkcf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 28 Jan 2022 18:54:56 +0000
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 20SIdnp8030665
        for <kvm@vger.kernel.org>; Fri, 28 Jan 2022 18:54:55 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dvhm3pkc5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 28 Jan 2022 18:54:55 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20SIqBQJ006896;
        Fri, 28 Jan 2022 18:54:54 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma03ams.nl.ibm.com with ESMTP id 3dr9ja45q6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 28 Jan 2022 18:54:53 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20SIsoVD36176292
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 28 Jan 2022 18:54:50 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A1AE1A4062;
        Fri, 28 Jan 2022 18:54:50 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 332C5A4068;
        Fri, 28 Jan 2022 18:54:50 +0000 (GMT)
Received: from p-imbrenda.bredband2.com (unknown [9.145.7.17])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 28 Jan 2022 18:54:50 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, thuth@redhat.com, david@redhat.com,
        nrb@linux.ibm.com, scgl@linux.ibm.com, seiden@linux.ibm.com
Subject: [kvm-unit-tests PATCH v1 1/5] lib: s390x: smp: add functions to work with CPU indexes
Date:   Fri, 28 Jan 2022 19:54:45 +0100
Message-Id: <20220128185449.64936-2-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220128185449.64936-1-imbrenda@linux.ibm.com>
References: <20220128185449.64936-1-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: u71NISVQH70C2aoEVNzvQV-BgNpj0YOL
X-Proofpoint-ORIG-GUID: SuK1S0kHCKkZKRbE57ccIwCrjtHdET8w
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-28_05,2022-01-28_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501 mlxscore=0
 bulkscore=0 adultscore=0 impostorscore=0 spamscore=0 mlxlogscore=938
 suspectscore=0 malwarescore=0 lowpriorityscore=0 clxscore=1015
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2201280108
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Knowing the number of active CPUs is not enough to know which ones are
active. This patch adds 2 new functions:

* smp_cpu_addr_from_idx to get the CPU address from the index
* smp_cpu_from_idx allows to retrieve the struct cpu from the index

This makes it possible for tests to avoid hardcoding the CPU addresses.
It is useful in cases where the address and the index might not match.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 lib/s390x/smp.h |  2 ++
 lib/s390x/smp.c | 12 ++++++++++++
 2 files changed, 14 insertions(+)

diff --git a/lib/s390x/smp.h b/lib/s390x/smp.h
index a2609f11..69aa4003 100644
--- a/lib/s390x/smp.h
+++ b/lib/s390x/smp.h
@@ -37,6 +37,7 @@ struct cpu_status {
 
 int smp_query_num_cpus(void);
 struct cpu *smp_cpu_from_addr(uint16_t addr);
+struct cpu *smp_cpu_from_idx(uint16_t addr);
 bool smp_cpu_stopped(uint16_t addr);
 bool smp_sense_running_status(uint16_t addr);
 int smp_cpu_restart(uint16_t addr);
@@ -47,5 +48,6 @@ int smp_cpu_destroy(uint16_t addr);
 int smp_cpu_setup(uint16_t addr, struct psw psw);
 void smp_teardown(void);
 void smp_setup(void);
+uint16_t smp_cpu_addr_from_idx(uint16_t idx);
 
 #endif
diff --git a/lib/s390x/smp.c b/lib/s390x/smp.c
index b753eab5..64c647ec 100644
--- a/lib/s390x/smp.c
+++ b/lib/s390x/smp.c
@@ -46,6 +46,18 @@ struct cpu *smp_cpu_from_addr(uint16_t addr)
 	return NULL;
 }
 
+struct cpu *smp_cpu_from_idx(uint16_t idx)
+{
+	assert(idx < smp_query_num_cpus());
+	return &cpus[idx];
+}
+
+uint16_t smp_cpu_addr_from_idx(uint16_t idx)
+{
+	assert(idx < smp_query_num_cpus());
+	return cpus[idx].addr;
+}
+
 bool smp_cpu_stopped(uint16_t addr)
 {
 	uint32_t status;
-- 
2.34.1

