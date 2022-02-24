Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 724634C3028
	for <lists+kvm@lfdr.de>; Thu, 24 Feb 2022 16:45:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236579AbiBXPoU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Feb 2022 10:44:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234679AbiBXPoO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Feb 2022 10:44:14 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EA1B1C60F8;
        Thu, 24 Feb 2022 07:43:43 -0800 (PST)
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21OFFBev026579;
        Thu, 24 Feb 2022 15:43:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=3xLtkj7897O7rorRmjeKvkI1Au2D4s5q7zglC3gkNn0=;
 b=YzJ/KotWMoThrOjkSJaQEYvMwU1iN2YzX4h+ot5ooEm7bU14wDgxaDKXLr8QVw8jyR/c
 MVVQkHjHtd3PYctUGEShFOVhxADbMipcUc6q9cZ7REYyIrTAF2EEwZ14uFNIJ+m16e+/
 gjVu7HxRZw8pwOXrjxTvITBhTYG7pQlw07IVslsAvN/XHNPSNBd10Cegdy+IJvEPDOPO
 jH37Gn/l1cS1wmNsq42SicLSq955YRL3fsV057OFkmdW4xSsMBv+q0zxrvl9y+lWfmAm
 FKnEZ8W81r2UIcATz3FE1YwlJzs9FZQd751fkMUMLvZEC7CEtRMuLufHacOeP8ecQUxV cg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3edwkekpfk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 24 Feb 2022 15:43:42 +0000
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 21OFGuJo001359;
        Thu, 24 Feb 2022 15:43:42 GMT
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3edwkekpev-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 24 Feb 2022 15:43:42 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 21OFcIO4002217;
        Thu, 24 Feb 2022 15:43:40 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma05fra.de.ibm.com with ESMTP id 3ear69rrhe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 24 Feb 2022 15:43:40 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 21OFhaxi46137630
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 24 Feb 2022 15:43:36 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A448F4204C;
        Thu, 24 Feb 2022 15:43:36 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 636D04203F;
        Thu, 24 Feb 2022 15:43:36 +0000 (GMT)
Received: from t46lp57.lnxne.boe (unknown [9.152.108.100])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 24 Feb 2022 15:43:36 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
Cc:     frankja@linux.ibm.com, imbrenda@linux.ibm.com, thuth@redhat.com,
        david@redhat.com
Subject: [kvm-unit-tests PATCH v4 0/8] s390x: Extend instruction interception tests
Date:   Thu, 24 Feb 2022 16:43:28 +0100
Message-Id: <20220224154336.3459839-1-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: W-av9WWXMiJl9c82_gSvVIw-98h0a2m4
X-Proofpoint-ORIG-GUID: oizj-m9Q5FPdHoG1w6pxaqN3l0t_yVS_
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-02-24_03,2022-02-24_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 clxscore=1015
 mlxscore=0 lowpriorityscore=0 phishscore=0 adultscore=0 suspectscore=0
 bulkscore=0 mlxlogscore=877 priorityscore=1501 impostorscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202240092
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This series extends the instruction interception tests for s390x.

For most instructions, there is already coverage in existing tests, but they are
not covering some failure cases, e.g. bad alignment. In this case, the existing
tests were extended.

SCK was not under test anywhere yet, hence a new test file was added.

The EPSW test gets it's own file, too, because it requires a I/O device, more
details in the respective commit. 

Changelog from v3:
----
- make log messages in sck tests unique
- test pmcw reserved bits are indeed stored as zero
- add comments as requested by Janosch

Nico Boehr (8):
  s390x: Add more tests for MSCH
  s390x: Add test for PFMF low-address protection
  s390x: Add sck tests
  s390x: Add tests for STCRW
  s390x: Add more tests for SSCH
  s390x: Add more tests for STSCH
  s390x: Add tests for TSCH
  s390x: Add EPSW test

 lib/s390x/css.h     |  17 +++
 lib/s390x/css_lib.c |  60 +++++++++
 s390x/Makefile      |   2 +
 s390x/css.c         | 291 ++++++++++++++++++++++++++++++++++++++++++++
 s390x/epsw.c        | 113 +++++++++++++++++
 s390x/pfmf.c        |  29 +++++
 s390x/sck.c         | 136 +++++++++++++++++++++
 s390x/unittests.cfg |   7 ++
 8 files changed, 655 insertions(+)
 create mode 100644 s390x/epsw.c
 create mode 100644 s390x/sck.c

-- 
2.31.1

