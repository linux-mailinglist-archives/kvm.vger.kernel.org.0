Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B2FE7632A24
	for <lists+kvm@lfdr.de>; Mon, 21 Nov 2022 17:58:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229757AbiKUQ6r (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Nov 2022 11:58:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229460AbiKUQ6o (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Nov 2022 11:58:44 -0500
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C25E5655F;
        Mon, 21 Nov 2022 08:58:43 -0800 (PST)
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2ALGLg5s038223;
        Mon, 21 Nov 2022 16:58:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : content-transfer-encoding : mime-version; s=pp1;
 bh=cor3Zlin5zLteJm2iNwSy7VCJvCiJvJZtPldC18uFW8=;
 b=n0zckYlf+8TdcFVbpz9JElwPEw7EkjUhCgqJHvyCWv/uElkI8LfztiNuEkoCR/Mdx5SI
 vbfGe18TQ/M3E7jPZ5hCG76i4RuuDmUFDXU74e193nxzOIL5onK0Bgf6KE6r2s8M0a3A
 Gy79ElnTFPDcX3TsLy7u74kt1YM6uDViKbOLNcMDY3IwMsqUJkLID80NedOFUvQvrcr1
 5h9u0iMCZ9oEpQ9wUWS+rPUVUnML6Vt7Eo/RdGaHt6dy85BRr9uy5LvpwAEqa/s5YsmT
 PgcOz66KBCuoYYmcGhxYHDyZYi2ZADIyVZnUeWhst4LsNRaKQTG0B1n4lceE0ih2U+uz Yg== 
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3ky90p7ghf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 21 Nov 2022 16:58:42 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2ALGoqP0015818;
        Mon, 21 Nov 2022 16:58:40 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma04ams.nl.ibm.com with ESMTP id 3kxps8ty37-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 21 Nov 2022 16:58:40 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2ALGwb6P57672118
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 21 Nov 2022 16:58:37 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 698A6A4051;
        Mon, 21 Nov 2022 16:58:37 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 57453A4055;
        Mon, 21 Nov 2022 16:58:37 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Mon, 21 Nov 2022 16:58:37 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 4958)
        id 169E7E0174; Mon, 21 Nov 2022 17:58:37 +0100 (CET)
From:   Eric Farman <farman@linux.ibm.com>
To:     Vineeth Vijayan <vneethv@linux.ibm.com>,
        Peter Oberparleiter <oberpar@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>
Cc:     Matthew Rosato <mjrosato@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        Eric Farman <farman@linux.ibm.com>
Subject: [PATCH v2 0/2] s390/vfio-ccw: addressing fixes
Date:   Mon, 21 Nov 2022 17:58:34 +0100
Message-Id: <20221121165836.283781-1-farman@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: OVcFgz5F_4iBaig6WqPFoMCfSsa6LKUX
X-Proofpoint-ORIG-GUID: OVcFgz5F_4iBaig6WqPFoMCfSsa6LKUX
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-21_14,2022-11-18_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 phishscore=0
 spamscore=0 bulkscore=0 clxscore=1015 impostorscore=0 priorityscore=1501
 mlxlogscore=685 lowpriorityscore=0 mlxscore=0 suspectscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211210128
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi everyone,

Here's the update to the couple small addressing fixes
created/used by vfio-ccw, which are shared with hardware,
which I'd sent a week or two ago.

One thing left un-done is a broader rework of the cp_get_orb()
interface that Matthew suggested [1]. I intend to address that
with a larger series that reworks the whole channel program
path in the not-too-distant future; doing it here expands the
otherwise tidy scope of these commits more than I'd like.

[1] https://lore.kernel.org/linux-s390/c9e7229e-a88d-2185-bb6b-a94e9dac7b7a@linux.ibm.com/

v1->v2:
 - [MR, NB] Patch 1: Update commit message per suggestions
 - [MR, NB] Add reviewed-by tags (thank you!)
v1: https://lore.kernel.org/linux-s390/20221109202157.1050545-1-farman@linux.ibm.com/

Alexander Gordeev (1):
  vfio/ccw: sort out physical vs virtual pointers usage

Eric Farman (1):
  vfio/ccw: identify CCW data addresses as physical

 drivers/s390/cio/vfio_ccw_cp.c  | 4 ++--
 drivers/s390/cio/vfio_ccw_fsm.c | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

-- 
2.34.1

