Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A0E25538CFF
	for <lists+kvm@lfdr.de>; Tue, 31 May 2022 10:37:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244795AbiEaIhy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 May 2022 04:37:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241386AbiEaIhX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 31 May 2022 04:37:23 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70313522FA;
        Tue, 31 May 2022 01:37:20 -0700 (PDT)
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24V5g18X001311;
        Tue, 31 May 2022 08:37:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=XC7zduPNmSfRtyt3S9GB+uoHsgq1u4k82CI3w6NYzu8=;
 b=LOxNcqAGeknPU8fTdZ6nWBaoSJZ8hyT2CUUewfsqusQGB4bTxnEkp5/Bu0VEdBvyGjbJ
 GDsJBxXVCuGhxvapLRKQYRMvj0ue0FW545tDMpTwOsPolSxad6rGVbbwuOSXNuPdOgko
 vbRKCTjCwjJOVB1SlSxR8lKzuYbPsMv1zCea87lI1+x9Bv3ipEXTL26zQw5SISuPoEaL
 j6CTJzR0a9qKHJv2aNR+2z/Ixy06PxRiOjnyRfPfb805EuPOQNKAjcC+2R1SD/AcL2S/
 7qr53/N1NOeFel6yh2UsIa7Jjvt60GZmTcDqZW2S+KiU8g7j8GBE54s+OhrEfXfQoWG4 aw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gdd3mu3hc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 31 May 2022 08:37:19 +0000
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 24V6wxU1009429;
        Tue, 31 May 2022 08:37:19 GMT
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gdd3mu3fp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 31 May 2022 08:37:19 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 24V8ZDVe003289;
        Tue, 31 May 2022 08:37:17 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma04fra.de.ibm.com with ESMTP id 3gbc8yjvms-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 31 May 2022 08:37:16 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 24V8bDmE22020568
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 31 May 2022 08:37:13 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CDCCE11C04C;
        Tue, 31 May 2022 08:37:13 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 879C411C04A;
        Tue, 31 May 2022 08:37:13 +0000 (GMT)
Received: from t46lp57.lnxne.boe (unknown [9.152.108.100])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 31 May 2022 08:37:13 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
Cc:     frankja@linux.ibm.com, imbrenda@linux.ibm.com, thuth@redhat.com,
        scgl@linux.ibm.com
Subject: [kvm-unit-tests PATCH v3 0/1] s390x: add migration test for storage keys
Date:   Tue, 31 May 2022 10:37:12 +0200
Message-Id: <20220531083713.48534-1-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: Y9XEBG_SPWtxFxocKttjOia-2fPtn54x
X-Proofpoint-GUID: kLnl5f4lEqXctvhMCeP4dueIIclA4BGX
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-05-31_03,2022-05-30_03,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 spamscore=0
 adultscore=0 lowpriorityscore=0 suspectscore=0 priorityscore=1501
 bulkscore=0 mlxscore=0 clxscore=1015 phishscore=0 impostorscore=0
 mlxlogscore=882 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2205310041
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

v2->v3:
----
* remove some useless variables, style suggestions, improve commit description
  (thanks Janis)
* reverse christmas tree (thanks Claudio)

v1->v2:
----
* As per discussion with Janis and Claudio, remove the actual access check from
  the test. This also allows us to remove the check_pgm_int_code_xfail() patch.
* Typos/Style suggestions (thanks Janis)

Upon migration, we expect storage keys set by the guest to be preserved,
so add a test for it.

We keep 128 pages and set predictable storage keys. Then, we migrate and check
they can be read back.

Nico Boehr (1):
  s390x: add migration test for storage keys

 s390x/Makefile         |  1 +
 s390x/migration-skey.c | 76 ++++++++++++++++++++++++++++++++++++++++++
 s390x/unittests.cfg    |  4 +++
 3 files changed, 81 insertions(+)
 create mode 100644 s390x/migration-skey.c

-- 
2.36.1

