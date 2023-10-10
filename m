Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 339A47BF47E
	for <lists+kvm@lfdr.de>; Tue, 10 Oct 2023 09:39:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1442509AbjJJHjM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Oct 2023 03:39:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1442488AbjJJHjJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Oct 2023 03:39:09 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 652B2AC
        for <kvm@vger.kernel.org>; Tue, 10 Oct 2023 00:39:07 -0700 (PDT)
Received: from pps.filterd (m0353728.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 39A75tkx022969
        for <kvm@vger.kernel.org>; Tue, 10 Oct 2023 07:39:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=rpdPgNiLuFDnr8wzn0HVtZqs83LhDCbcjL1bH9xKTDg=;
 b=IaPfmZlRE0JEVjpY9TPgQ/b60mkOGn7ozhvxMGK3wRep2WmS1fEYBPd+MyogrAkVsJs5
 0CGnWjcVeIzMdvoYApUby8Uk0fhDpGoZd7lSuUuxbMryGkSO8sFJv5AmVfDvOXSXHm9W
 QGd1yOq93H4taIQ+W4rfLp+oq4Umf9t8zXi5yLDx5LXxqc/DcucmZrQyS9MAB33Vx16Q
 Bfco1/JQkonP/1rCy25jwDpePtibXPg88YhS2NgsUix9KD1y7kkzt0Q551WZW390LlIh
 bErKxb70lpRW9xdxvIUXSWe1r7Jb0PoRGQYwdaH7I8oAOaUVQOUYEp60gnEgC7ypADqg JQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3tn1qrse5a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 10 Oct 2023 07:39:06 +0000
Received: from m0353728.ppops.net (m0353728.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 39A7Kxi9011231
        for <kvm@vger.kernel.org>; Tue, 10 Oct 2023 07:39:06 GMT
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3tn1qrse4y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 10 Oct 2023 07:39:06 +0000
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
        by ppma13.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 39A6TEQa001147;
        Tue, 10 Oct 2023 07:39:05 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
        by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 3tkkvjpdrg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 10 Oct 2023 07:39:05 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
        by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 39A7d2xO24314438
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 10 Oct 2023 07:39:02 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B930220040;
        Tue, 10 Oct 2023 07:39:02 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8BD2D2004B;
        Tue, 10 Oct 2023 07:39:02 +0000 (GMT)
Received: from a46lp67.. (unknown [9.152.108.100])
        by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Tue, 10 Oct 2023 07:39:02 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     imbrenda@linux.ibm.com, thuth@redhat.com, david@redhat.com,
        nsg@linux.ibm.com, nrb@linux.ibm.com
Subject: [kvm-unit-tests PATCH 1/3] lib: s390x: hw: Provide early detect host
Date:   Tue, 10 Oct 2023 07:38:53 +0000
Message-Id: <20231010073855.26319-2-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231010073855.26319-1-frankja@linux.ibm.com>
References: <20231010073855.26319-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: kSd18uN9s-bKNzgPMOj2tvqUVlj5T-Uk
X-Proofpoint-ORIG-GUID: 3vJLLqZrfAUO8v3vLas-x-0ETUbqglGd
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-10_04,2023-10-09_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 mlxscore=0
 clxscore=1015 impostorscore=0 spamscore=0 suspectscore=0 adultscore=0
 priorityscore=1501 lowpriorityscore=0 mlxlogscore=548 bulkscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2309180000 definitions=main-2310100056
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

For early sclp printing it's necessary to know if we're under LPAR or
not so we can apply compat SCLP ASCII transformations.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 lib/s390x/hardware.c | 8 ++++++++
 lib/s390x/hardware.h | 1 +
 2 files changed, 9 insertions(+)

diff --git a/lib/s390x/hardware.c b/lib/s390x/hardware.c
index 2bcf9c4c..d5a752c0 100644
--- a/lib/s390x/hardware.c
+++ b/lib/s390x/hardware.c
@@ -52,6 +52,14 @@ static enum s390_host do_detect_host(void *buf)
 	return HOST_IS_UNKNOWN;
 }
 
+enum s390_host detect_host_early(void)
+{
+	if (stsi_get_fc() == 2)
+		return HOST_IS_LPAR;
+
+	return HOST_IS_UNKNOWN;
+}
+
 enum s390_host detect_host(void)
 {
 	static enum s390_host host = HOST_IS_UNKNOWN;
diff --git a/lib/s390x/hardware.h b/lib/s390x/hardware.h
index 86fe873c..5e5a9d90 100644
--- a/lib/s390x/hardware.h
+++ b/lib/s390x/hardware.h
@@ -24,6 +24,7 @@ enum s390_host {
 };
 
 enum s390_host detect_host(void);
+enum s390_host detect_host_early(void);
 
 static inline uint16_t get_machine_id(void)
 {
-- 
2.34.1

