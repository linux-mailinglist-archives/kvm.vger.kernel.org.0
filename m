Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16CBC25168A
	for <lists+kvm@lfdr.de>; Tue, 25 Aug 2020 12:21:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729803AbgHYKVB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Aug 2020 06:21:01 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:3988 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729653AbgHYKVA (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 25 Aug 2020 06:21:00 -0400
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07PA1xGj169229
        for <kvm@vger.kernel.org>; Tue, 25 Aug 2020 06:20:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=s6jg51TymRoMGZ3NFB7GYH4/t2bnpPS6wJ6yvbwFgd4=;
 b=GEK0fDXg1AFxZmrLXRpOVeo9afBI+ko0kgThBKg/e5xO+zjL+KpIPl2LS+vCraP9S3tC
 2o+JkxZfsEw1zV8RlbQFkobafYOJSD3giTNqal62wHbUFmBTHiglevrUUnbtKmfMqHdf
 pw31qR3Job6Pi5zPO9QQRvDS0aLeg0bhZH+4Vc3IeiDUGFlhFRG04/KAim3HS4UYTyr3
 Q05z7Ta3mjthMeVIvfGaIYJNwj9sDLL+UEZKIAt3PHNecQOe110zzh2Dfe2GOjarjHKC
 E0SsefNkadwPvly6RvXMQrX3+XnJNus8GrgxO8kbiSCETH8krejruLeAdnRxor+KLYkE yg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 334xpm3f8m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 25 Aug 2020 06:20:59 -0400
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 07PA2ZDm171021
        for <kvm@vger.kernel.org>; Tue, 25 Aug 2020 06:20:58 -0400
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 334xpm3f87-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 25 Aug 2020 06:20:58 -0400
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 07PAF3qN022643;
        Tue, 25 Aug 2020 10:20:56 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma06ams.nl.ibm.com with ESMTP id 332uk6baka-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 25 Aug 2020 10:20:56 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 07PAKsaZ31523304
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Aug 2020 10:20:54 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2E3DEA405B;
        Tue, 25 Aug 2020 10:20:54 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BA3FCA4057;
        Tue, 25 Aug 2020 10:20:53 +0000 (GMT)
Received: from marcibm.ibmuc.com (unknown [9.145.56.167])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 25 Aug 2020 10:20:53 +0000 (GMT)
From:   Marc Hartmayer <mhartmay@linux.ibm.com>
To:     <kvm@vger.kernel.org>
Cc:     Thomas Huth <thuth@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [kvm-unit-tests PATCH v2 1/2] runtime.bash: remove outdated comment
Date:   Tue, 25 Aug 2020 12:20:35 +0200
Message-Id: <20200825102036.17232-2-mhartmay@linux.ibm.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200825102036.17232-1-mhartmay@linux.ibm.com>
References: <20200825102036.17232-1-mhartmay@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-25_02:2020-08-24,2020-08-25 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 mlxscore=0
 mlxlogscore=999 suspectscore=0 bulkscore=0 clxscore=1015
 lowpriorityscore=0 impostorscore=0 spamscore=0 adultscore=0
 priorityscore=1501 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2006250000 definitions=main-2008250073
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Since commit 6e1d3752d7ca ("tap13: list testcases individually") the
comment is no longer valid. Therefore let's remove it.

Reviewed-by: Andrew Jones <drjones@redhat.com>
Reviewed-by: Cornelia Huck <cohuck@redhat.com>
Signed-off-by: Marc Hartmayer <mhartmay@linux.ibm.com>
---
 scripts/runtime.bash | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/scripts/runtime.bash b/scripts/runtime.bash
index c88e246245a6..caa4c5ba18cc 100644
--- a/scripts/runtime.bash
+++ b/scripts/runtime.bash
@@ -53,9 +53,6 @@ skip_nodefault()
 
 function print_result()
 {
-    # output test results in a TAP format
-    # https://testanything.org/tap-version-13-specification.html
-
     local status="$1"
     local testname="$2"
     local summary="$3"
-- 
2.25.4

