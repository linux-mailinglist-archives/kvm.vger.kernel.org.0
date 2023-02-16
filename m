Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DFAEF6993F4
	for <lists+kvm@lfdr.de>; Thu, 16 Feb 2023 13:12:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229788AbjBPMMS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Feb 2023 07:12:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229524AbjBPMMQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Feb 2023 07:12:16 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AEF455E51;
        Thu, 16 Feb 2023 04:12:15 -0800 (PST)
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31GC0WCK019227;
        Thu, 16 Feb 2023 12:12:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=RlxpYpt5CuMMWJervzBjpenh7aoLwDWKIaU6JluD+vM=;
 b=P7wkUsyws9h4fTgkcbv6DEOU/19B+uJ73g6vSA9TyBRWw0f7JzkXwDjxsr5pZ79bBh4Z
 Pbc1inN45+GmFeGTQdWwQBRi5mlW8kyLxFH5eYzrHaW7jE8pwMTa6uZHAPgrvw1mk6WX
 dGTM1/2TGBfiAKdYu3f3UhEJpVIa+jF2Kcn38uQdaOwB/s6CXP5XTaLqnVU2C60DHt23
 tS9Sv0XuNdsu4nACzUJ17uHJsV7bDnigHI3pQIo3ggXTZmustdp/tlNZCeKPAtVuLJwG
 d4g1BS4/LCcujq5h3x6VjkCLYiQZMo3BQI2ouvDITiXa7gAmsNFHLSSmhpn0rL4ZlS0p /Q== 
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3nsgts57rv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 16 Feb 2023 12:12:14 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 31G12mho007609;
        Thu, 16 Feb 2023 12:12:12 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
        by ppma04fra.de.ibm.com (PPS) with ESMTPS id 3np2n6cwnt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 16 Feb 2023 12:12:12 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
        by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 31GCC9FD23003752
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Feb 2023 12:12:09 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 07E2220043;
        Thu, 16 Feb 2023 12:12:09 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A8C9720040;
        Thu, 16 Feb 2023 12:12:08 +0000 (GMT)
Received: from t35lp63.lnxne.boe (unknown [9.152.108.100])
        by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Thu, 16 Feb 2023 12:12:08 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     borntraeger@linux.ibm.com, frankja@linux.ibm.com,
        imbrenda@linux.ibm.com, agordeev@linux.ibm.com
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
Subject: [PATCH v2 0/1] s390: nmi: fix virtual-physical address confusion
Date:   Thu, 16 Feb 2023 13:12:07 +0100
Message-Id: <20230216121208.4390-1-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.39.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 3IcV6KMEr2kTsSVsSqZPLcRzt59EISuM
X-Proofpoint-ORIG-GUID: 3IcV6KMEr2kTsSVsSqZPLcRzt59EISuM
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-16_09,2023-02-16_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0
 priorityscore=1501 impostorscore=0 lowpriorityscore=0 adultscore=0
 suspectscore=0 mlxlogscore=999 spamscore=0 phishscore=0 malwarescore=0
 mlxscore=0 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302160103
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

v2:
---
* remove unneeded cast (thanks Alexander)

When a machine check is received while in SIE, it is reinjected into the
guest in some cases. The respective code needs to access the sie_block,
which is taken from the backed up R14.

Since reinjection only occurs while we are in SIE (i.e. between the
labels sie_entry and sie_leave in entry.S and thus if CIF_MCCK_GUEST is
set), the backed up R14 will always contain a physical address in
s390_backup_mcck_info.

This currently works, because virtual and physical addresses are
the same.

Add phys_to_virt() to resolve the virtual-physical confusion.

Nico Boehr (1):
  s390: nmi: fix virtual-physical address confusion

 arch/s390/kernel/nmi.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

-- 
2.39.1

