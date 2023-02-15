Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA776698020
	for <lists+kvm@lfdr.de>; Wed, 15 Feb 2023 17:03:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229777AbjBOQDD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Feb 2023 11:03:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229620AbjBOQDC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Feb 2023 11:03:02 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1B072823B;
        Wed, 15 Feb 2023 08:02:58 -0800 (PST)
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31FFuU7F013184;
        Wed, 15 Feb 2023 16:02:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=TGC/QzNFfJBKUzPIXH4qjHSlNVNbvav4il8Zuez6OMI=;
 b=dndU0ou4B711zhW3Cw6Rw832ulDTubAQV3bYf6B6KAbT4ugpgbw9jtxaCasE9qqEZvkO
 YuEGomE4jbdzM+FZsDc3Uo3WFeMBLnJyngK9M8uLLJtzJk5arD0QZ3TwRu7v3n0Fs0kI
 dJ6geB3k50TunNgLnmSd9WDuyFnfU94Wglqh8M2tPQf1DW/NXG46oAKjAtcsxTwtS3nb
 lzs28/WDEybOdA2sKGCgvS2dnlCmkggkHsdnEgKazyudd7Fu8t4+MhfhkkZRDVx+xr9P
 9tPKFV8h9ERy50/r6MiCq+31wLDVEVXUVLuY+ZcDaIDVOSql2iO4oitVoc3G8qrvaV5H DA== 
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3ns2ftr91j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 15 Feb 2023 16:02:58 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 31FBEAhC029819;
        Wed, 15 Feb 2023 16:02:56 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
        by ppma06ams.nl.ibm.com (PPS) with ESMTPS id 3np29fnkhh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 15 Feb 2023 16:02:56 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
        by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 31FG2ql123986438
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 Feb 2023 16:02:52 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7AA4420063;
        Wed, 15 Feb 2023 16:02:52 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3EF282004B;
        Wed, 15 Feb 2023 16:02:52 +0000 (GMT)
Received: from t35lp63.lnxne.boe (unknown [9.152.108.100])
        by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Wed, 15 Feb 2023 16:02:52 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     borntraeger@linux.ibm.com, frankja@linux.ibm.com,
        imbrenda@linux.ibm.com
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
Subject: [PATCH v1 0/1] s390: nmi: fix virtual-physical address confusion
Date:   Wed, 15 Feb 2023 17:02:51 +0100
Message-Id: <20230215160252.14672-1-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.39.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: LSX2JmKgb1xjrW7Qm5Z0uS0n9VOAYqWE
X-Proofpoint-ORIG-GUID: LSX2JmKgb1xjrW7Qm5Z0uS0n9VOAYqWE
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-15_06,2023-02-15_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 mlxscore=0
 impostorscore=0 adultscore=0 priorityscore=1501 clxscore=1015
 mlxlogscore=999 phishscore=0 lowpriorityscore=0 malwarescore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302150145
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

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

 arch/s390/kernel/nmi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

-- 
2.39.1

