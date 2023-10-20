Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 730657D11CF
	for <lists+kvm@lfdr.de>; Fri, 20 Oct 2023 16:49:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377588AbjJTOtY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Oct 2023 10:49:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377239AbjJTOtX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Oct 2023 10:49:23 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAB31CF;
        Fri, 20 Oct 2023 07:49:21 -0700 (PDT)
Received: from pps.filterd (m0353724.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 39KEiWpw017498;
        Fri, 20 Oct 2023 14:49:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=Kaz1ZAB6nK3IbptVY/pEWTU37xKrHWxpq8e63wCzV4I=;
 b=WGNsDkuSofvIDCr/dBBHwgDBWbbY3rKbSC8Mo6KNro3ikh03TU7f+vDdm4Z1ZFrDmSPm
 qg+0j59o17YRQsKvFooIqES/O83AYWqXDDfQ0RdRVyD7C+JdNZLcFnn80+HTCpSEtUwr
 c0rpc3FNkKoNgFmfly+FPPoetJmOAZOmKN2pa7IIv2wvhzpU+8+sqxcWF8NGFs+EVU6D
 j54MCoFptsUX7uffCUQpGcRvNGvUSwUX5ZiJPdX/SJ4POotyiij/HOkl0PXSzzSlMTrS
 HFVW3kC2+XsdiZdrNg1ATtno9OsEkwN2gaJ8BwZTG/aEAYJZU8dFB9rSMDD9P+jEoqgu xg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3tuuk086qu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 20 Oct 2023 14:49:11 +0000
Received: from m0353724.ppops.net (m0353724.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 39KEii4T018229;
        Fri, 20 Oct 2023 14:49:11 GMT
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3tuuk086pc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 20 Oct 2023 14:49:11 +0000
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
        by ppma21.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 39KC9npr024179;
        Fri, 20 Oct 2023 14:49:09 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
        by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3tuc29574a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 20 Oct 2023 14:49:09 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
        by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 39KEn6ZA37093980
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 20 Oct 2023 14:49:06 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1CDEC20040;
        Fri, 20 Oct 2023 14:49:06 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CD2A720043;
        Fri, 20 Oct 2023 14:49:05 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Fri, 20 Oct 2023 14:49:05 +0000 (GMT)
From:   Nina Schoetterl-Glausch <nsg@linux.ibm.com>
To:     =?UTF-8?q?Nico=20B=C3=B6hr?= <nrb@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Nikos Nikoleris <nikos.nikoleris@arm.com>,
        Ricardo Koller <ricarkol@google.com>,
        Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org,
        Colton Lewis <coltonlewis@google.com>,
        Shaoqin Huang <shahuang@redhat.com>,
        Thomas Huth <thuth@redhat.com>, linux-s390@vger.kernel.org,
        Andrew Jones <andrew.jones@linux.dev>
Subject: [kvm-unit-tests PATCH 07/10] s390x: topology: Rename topology_core to topology_cpu
Date:   Fri, 20 Oct 2023 16:48:57 +0200
Message-Id: <20231020144900.2213398-8-nsg@linux.ibm.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20231020144900.2213398-1-nsg@linux.ibm.com>
References: <20231020144900.2213398-1-nsg@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: QQTtwBGXh5npQ9eY6IyLK3ADLXvEFfoi
X-Proofpoint-ORIG-GUID: NtdHXMbeEaDizn-TAEqkb3mwnEm3Lu5j
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-20_10,2023-10-19_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 phishscore=0 mlxlogscore=999 spamscore=0 clxscore=1015 mlxscore=0
 suspectscore=0 malwarescore=0 lowpriorityscore=0 impostorscore=0
 bulkscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2310170001 definitions=main-2310200121
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is more in line with the nomenclature in the PoP.

Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Nico Boehr <nrb@linux.ibm.com>
Signed-off-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
---
 lib/s390x/stsi.h | 4 ++--
 s390x/topology.c | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/lib/s390x/stsi.h b/lib/s390x/stsi.h
index 2f6182c1..1e9d0958 100644
--- a/lib/s390x/stsi.h
+++ b/lib/s390x/stsi.h
@@ -30,7 +30,7 @@ struct sysinfo_3_2_2 {
 };
 
 #define CPUS_TLE_RES_BITS 0x00fffffff8000000UL
-struct topology_core {
+struct topology_cpu {
 	uint8_t nl;
 	uint8_t reserved1[3];
 	uint8_t reserved4:5;
@@ -61,7 +61,7 @@ struct topology_container {
 
 union topology_entry {
 	uint8_t nl;
-	struct topology_core cpu;
+	struct topology_cpu cpu;
 	struct topology_container container;
 };
 
diff --git a/s390x/topology.c b/s390x/topology.c
index 6a5f100e..df158aef 100644
--- a/s390x/topology.c
+++ b/s390x/topology.c
@@ -247,7 +247,7 @@ done:
 static uint8_t *check_tle(void *tc)
 {
 	struct topology_container *container = tc;
-	struct topology_core *cpus;
+	struct topology_cpu *cpus;
 	int n;
 
 	if (container->nl) {
-- 
2.41.0

