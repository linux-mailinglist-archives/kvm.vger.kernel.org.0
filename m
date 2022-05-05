Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F1EF51BFBC
	for <lists+kvm@lfdr.de>; Thu,  5 May 2022 14:47:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377671AbiEEMup (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 May 2022 08:50:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229704AbiEEMuo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 May 2022 08:50:44 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA93D2ED61;
        Thu,  5 May 2022 05:47:05 -0700 (PDT)
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 245Bg3tH015707;
        Thu, 5 May 2022 12:47:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=qO5FrkGjEDfSXDwcj3JKB+pKq1QZ2YCrl5e+xVQ8adY=;
 b=tWqokK/F+V/Fpl0XNBodpzFJC9BFLq8z2i/xJ0SCIig4k6tZoXP1IuHkUyQyvTwRAN+4
 UG47PUczzoAsIEfeS5soHN7UiLjWmSqJB6Pl2yQpyFkItcxP4hgaxERa6fK+78ojVXPq
 SCh+ONt9vB219Q6RowiLaKxWUSXMltIkdiGvn/quuOYKBt/+9FiI63peWNdWKj0wqeh0
 cc37q3pXb3kxO88b9IJocnNiEJWeMk+Sg8XcptFdtUZ8KL0J0rL//17o6eErmIO1VlEk
 hf8o07vGKxapDG0gPV0GnqNbnecm4BGYH1QSW84BHS6AESNoWGpyxiTqCoBPYxjy9h5N JA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3fvdxbs956-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 05 May 2022 12:47:05 +0000
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 245CZEY8021457;
        Thu, 5 May 2022 12:47:04 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3fvdxbs944-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 05 May 2022 12:47:04 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 245CiNaR019782;
        Thu, 5 May 2022 12:47:02 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma03fra.de.ibm.com with ESMTP id 3fscdk56b0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 05 May 2022 12:47:02 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 245Ckwm335389758
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 5 May 2022 12:46:58 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B915C4203F;
        Thu,  5 May 2022 12:46:58 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 656E942042;
        Thu,  5 May 2022 12:46:58 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu,  5 May 2022 12:46:58 +0000 (GMT)
From:   Janis Schoetterl-Glausch <scgl@linux.ibm.com>
To:     Thomas Huth <thuth@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     Janis Schoetterl-Glausch <scgl@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: [kvm-unit-tests PATCH 0/3] s390x: More storage key instruction
Date:   Thu,  5 May 2022 14:46:53 +0200
Message-Id: <20220505124656.1954092-1-scgl@linux.ibm.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: lCem2wx3DHTl04D-f_YlxuppFgHDwxQe
X-Proofpoint-GUID: orgNLLakoQezp_jtBoAp6DyI6o-rI9C8
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-05_05,2022-05-05_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 suspectscore=0
 phishscore=0 priorityscore=1501 clxscore=1015 bulkscore=0 impostorscore=0
 mlxscore=0 adultscore=0 mlxlogscore=999 spamscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2205050091
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add test cases similar to those testing the effect of storage keys on
instructions emulated by KVM, but test instructions emulated by user
space/qemu instead.
Additionally, check the transaction exception identification on
protection exceptions

Based on the previous storage key test series.

Janis Schoetterl-Glausch (3):
  s390x: Fix sclp facility bit numbers
  s390x: Test TEID values in storage key test
  s390x: Test effect of storage keys on some more instructions

 lib/s390x/asm/facility.h |  21 +++
 lib/s390x/sclp.h         |  18 ++-
 lib/s390x/sclp.c         |   2 +
 s390x/skey.c             | 337 ++++++++++++++++++++++++++++++++++++++-
 s390x/unittests.cfg      |   1 +
 5 files changed, 366 insertions(+), 13 deletions(-)


base-commit: 6a7a83ed106211fc0ee530a3a05f171f6a4c4e66
prerequisite-patch-id: fbcb3161ffa816cec4edea484bd9d9b22b11518b
prerequisite-patch-id: f7e97c6d2555ac61a603fa9054ba5ad391aa5dbf
prerequisite-patch-id: 14c928967e08fb48de955ccd37d5698c972e54f9
-- 
2.33.1

