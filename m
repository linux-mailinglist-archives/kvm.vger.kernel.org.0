Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC6A06D5F30
	for <lists+kvm@lfdr.de>; Tue,  4 Apr 2023 13:37:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234976AbjDDLhU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Apr 2023 07:37:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234849AbjDDLhH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Apr 2023 07:37:07 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1190830DB
        for <kvm@vger.kernel.org>; Tue,  4 Apr 2023 04:37:01 -0700 (PDT)
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 334BFLBd018097;
        Tue, 4 Apr 2023 11:36:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=TQj/CLq8Xfqlz6SrmQQ3j+00+jgb2sU6nBcLaWgSyKE=;
 b=lozJE1OgP88ASCKBvsrc93PoJhuY/SvhgDn3Gh06qJi9PEuHeAOh1Aj1G/DaUG83GNRt
 6V82849IPSeVPSCTC6w4eaZZVLHH1EJ6h24H0rp7mFD0J5n+S1dd/8P/bXZOv4gRoGgX
 sxUF52DDe/1O7ai5D3XLVYNbGQyRcmUk8BK4Tkt3I3Re0AcY1wHfg30Uxlwjgz0ItRRI
 A+xbP4aUqMdi63CaId5GsSZMkie/bQOGTFT4bYG90OmiXGHFzSfsfs4epE+zW40+Aa+B
 /1T+aMBQW9mhku9yneQXACI9QazMFIdA4xFCwEUxPhS7xc0qRc3/LmTiRo4Y1Wm3uv3h 0g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3pr2mcc6g0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 04 Apr 2023 11:36:58 +0000
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 334BHsZM003657;
        Tue, 4 Apr 2023 11:36:57 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3pr2mcc6f1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 04 Apr 2023 11:36:57 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 333MJmuk020344;
        Tue, 4 Apr 2023 11:36:55 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
        by ppma06ams.nl.ibm.com (PPS) with ESMTPS id 3ppbvg2fsa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 04 Apr 2023 11:36:55 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
        by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 334BapVc45351508
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 4 Apr 2023 11:36:52 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D74E12004B;
        Tue,  4 Apr 2023 11:36:51 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5E4A820043;
        Tue,  4 Apr 2023 11:36:51 +0000 (GMT)
Received: from t14-nrb.ibmuc.com (unknown [9.171.55.238])
        by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Tue,  4 Apr 2023 11:36:51 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     thuth@redhat.com, pbonzini@redhat.com, andrew.jones@linux.dev
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, imbrenda@linux.ibm.com
Subject: [kvm-unit-tests GIT PULL v2 13/14] MAINTAINERS: Add Nico as s390x Maintainer and make Thomas reviewer
Date:   Tue,  4 Apr 2023 13:36:38 +0200
Message-Id: <20230404113639.37544-14-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230404113639.37544-1-nrb@linux.ibm.com>
References: <20230404113639.37544-1-nrb@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: -u4bq_yuNewmDwsK4TNa-NIAmnMudU4Y
X-Proofpoint-ORIG-GUID: qemYR7vdqxqejJ3HzBKnwsVXl7W5qvdX
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-04_04,2023-04-04_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 malwarescore=0
 mlxscore=0 bulkscore=0 adultscore=0 priorityscore=1501 impostorscore=0
 lowpriorityscore=0 suspectscore=0 clxscore=1015 mlxlogscore=999
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2304040107
X-Spam-Status: No, score=-0.1 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Janosch Frank <frankja@linux.ibm.com>

The circle of life continues as we bring in Nico as a s390x
maintainer. Thomas moves from the maintainer position to reviewer but
he's a general maintainer of the project anyway.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Acked-by: Thomas Huth <thuth@redhat.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Acked-by: Nico Boehr <nrb@linux.ibm.com>
Link: https://lore.kernel.org/r/20230322113400.1123378-1-frankja@linux.ibm.com
Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
---
 MAINTAINERS | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 649de50..bd1761d 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -85,11 +85,12 @@ F: lib/powerpc/
 F: lib/ppc64/
 
 S390X
-M: Thomas Huth <thuth@redhat.com>
 M: Janosch Frank <frankja@linux.ibm.com>
 M: Claudio Imbrenda <imbrenda@linux.ibm.com>
+M: Nico Böhr <nrb@linux.ibm.com>
 S: Supported
 R: David Hildenbrand <david@redhat.com>
+R: Thomas Huth <thuth@redhat.com>
 L: kvm@vger.kernel.org
 L: linux-s390@vger.kernel.org
 F: s390x/
-- 
2.39.2

