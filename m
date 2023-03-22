Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B57096C494A
	for <lists+kvm@lfdr.de>; Wed, 22 Mar 2023 12:34:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229584AbjCVLez (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Mar 2023 07:34:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229747AbjCVLer (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Mar 2023 07:34:47 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58831EC7C
        for <kvm@vger.kernel.org>; Wed, 22 Mar 2023 04:34:41 -0700 (PDT)
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32MBCKtX015428;
        Wed, 22 Mar 2023 11:34:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type :
 content-transfer-encoding; s=pp1;
 bh=CZ4K5dOiLMYXjllYM00X9+H/REQcT7iAnjC6+d7HZvs=;
 b=Phgmh+9Dy9WIEHI2zyJhJ1rtv21QibIBF6GVCyLEBT2deAVxrR38X9/Z0EzSkhlhM937
 mTJFG0dtxRrvD5x7gD1O/qMWPBFCWyKfHb/fMlO/APOx7lC0tjNaafCAPDMAoVdcgxPj
 SqTH1dKNAqmlgjWoc8YJ7KS38SxPsXDv9pKGUy8aF2zlRvibQiSloFYNnWLNsUeUKbnI
 H2SvGc9TqqvTC00CPijrFgnSLI/SAJLCO/9TGB58wxZ7/hIkN34GYhsU98XPUV/12bSn
 NymVKgECJ5oEIqwsKWtO4q3oTPz/pjIjghriNzCtIzWdTnyPd2dnVjHMbyzyDs2CTx5O lA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3pg0kb8h5c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 22 Mar 2023 11:34:37 +0000
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 32MBCoUp017351;
        Wed, 22 Mar 2023 11:34:37 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3pg0kb8h4f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 22 Mar 2023 11:34:37 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 32M1e8eI006865;
        Wed, 22 Mar 2023 11:34:34 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
        by ppma03fra.de.ibm.com (PPS) with ESMTPS id 3pd4x64w1f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 22 Mar 2023 11:34:34 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
        by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 32MBYVw512386860
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 22 Mar 2023 11:34:31 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0B87620043;
        Wed, 22 Mar 2023 11:34:31 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B549F20040;
        Wed, 22 Mar 2023 11:34:30 +0000 (GMT)
Received: from a46lp67.. (unknown [9.152.108.100])
        by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Wed, 22 Mar 2023 11:34:30 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org, thuth@redhat.com, nrb@linux.ibm.com
Cc:     pbonzini@redhat.com, andrew.jones@linux.dev,
        imbrenda@linux.ibm.com, david@redhat.com, borntraeger@linux.ibm.com
Subject: [kvm-unit-tests PATCH] MAINTAINERS: Add Nico as s390x Maintainer and make Thomas reviewer
Date:   Wed, 22 Mar 2023 11:34:00 +0000
Message-Id: <20230322113400.1123378-1-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: Q3JWRonbfqZpjFQzVtgQaJ3th_6eHPlk
X-Proofpoint-ORIG-GUID: gyBCLV0jgei0BEromzp0oAXZxxdlfbtq
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-22_08,2023-03-22_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0
 priorityscore=1501 impostorscore=0 bulkscore=0 phishscore=0 spamscore=0
 mlxscore=0 mlxlogscore=994 clxscore=1011 lowpriorityscore=0 malwarescore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303150002 definitions=main-2303220082
X-Spam-Status: No, score=-0.1 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The circle of life continues as we bring in Nico as a s390x
maintainer. Thomas moves from the maintainer position to reviewer but
he's a general maintainer of the project anyway.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 MAINTAINERS | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 649de509..bd1761db 100644
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
2.34.1

