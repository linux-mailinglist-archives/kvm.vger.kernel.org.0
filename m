Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 689AF7668CF
	for <lists+kvm@lfdr.de>; Fri, 28 Jul 2023 11:27:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235562AbjG1J1M (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Jul 2023 05:27:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234779AbjG1J0q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Jul 2023 05:26:46 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DFB63AA9;
        Fri, 28 Jul 2023 02:23:47 -0700 (PDT)
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36S9EC02012984;
        Fri, 28 Jul 2023 09:23:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=LWxQ1EEos2cV97Yv0h3NvRp8id3vWdJ7k6pejvwldaw=;
 b=T3vRAJQRjBEqjxJux0b+10LOFR6Xk2Oox1qPuMVKzNohUA4XlcNnq5HaoQkbOjPrpDrA
 ESq1iKXpCg/pg4R0S4oHsH2OGZniR+hZ3zx1q7RbPKaibk9SPi8t19ObrcOQxndjNB84
 nqhuqKPLyxo3tOdJzsO/IWGBaxa8NWk5JfFZoG2ZtzO0pWpnULndKXDvkAhHTDeLLzeI
 /Sbg1sIb2IgcZ9sAfWJz1z5bomVUdhi7ww/x/1yXOWY4EGfY336Zg3kgWmsIKqo5oUSX
 uKb5mZ9m/7seivkNEIkJwrkGo5esELIt2E9FqIP0jRWifG8j3Fn/+6ybTNiPGnbDcJlh rA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3s4av287s8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 28 Jul 2023 09:23:46 +0000
Received: from m0360072.ppops.net (m0360072.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 36S9EFXC013116;
        Fri, 28 Jul 2023 09:23:46 GMT
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3s4av287rx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 28 Jul 2023 09:23:46 +0000
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
        by ppma21.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 36S6vmov002013;
        Fri, 28 Jul 2023 09:23:45 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
        by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3s0tenmt96-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 28 Jul 2023 09:23:45 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
        by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 36S9NgHJ17957578
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 28 Jul 2023 09:23:42 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 11BC42004E;
        Fri, 28 Jul 2023 09:23:42 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A2E1E20040;
        Fri, 28 Jul 2023 09:23:41 +0000 (GMT)
Received: from a46lp73.lnxne.boe (unknown [9.152.108.100])
        by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Fri, 28 Jul 2023 09:23:41 +0000 (GMT)
From:   Steffen Eiden <seiden@linux.ibm.com>
To:     linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Michael Mueller <mimu@linux.vnet.ibm.com>,
        Marc Hartmayer <mhartmay@linux.ibm.com>
Subject: [PATCH v2 0/3]  KVM: s390: Enable AP instructions for pv-guests
Date:   Fri, 28 Jul 2023 11:23:38 +0200
Message-Id: <20230728092341.1131787-1-seiden@linux.ibm.com>
X-Mailer: git-send-email 2.40.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: lB25_JTRQGoTL_y296AgFA60HxuWfoRE
X-Proofpoint-GUID: LbtxkgT84I9fGprDZYHAaVsMSjdCtcgj
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-27_10,2023-07-26_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 bulkscore=0
 priorityscore=1501 lowpriorityscore=0 suspectscore=0 phishscore=0
 mlxlogscore=533 impostorscore=0 clxscore=1015 adultscore=0 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2306200000 definitions=main-2307280082
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This series enables general KVM support for AP-passthrough for Secure
Execution guests (pv-guests).

To enable AP inside pv-guests two things have to be done/considered:
	1) set corresponding flags in the Create Secure Configuration UVC ifi
     firmware supports AP for pv-guests (patch 3).
	2) enable/disable AP in pv-guests if the VMM wants this (patch 2).

since v1:
  - PATCH 1: r-b from Claudio
  - PATCH 2: fixed formatting issues (Claudio)
  - PATCH 3: removed unnecessary checks (Claudio)

Steffen

Steffen Eiden (3):
  s390: uv: UV feature check utility
  KVM: s390: Add UV feature negotiation
  KVM: s390: pv:  Allow AP-instructions for pv guests

 arch/s390/include/asm/kvm_host.h |  2 ++
 arch/s390/include/asm/uv.h       | 17 ++++++++-
 arch/s390/include/uapi/asm/kvm.h | 25 +++++++++++++
 arch/s390/kernel/uv.c            |  2 +-
 arch/s390/kvm/kvm-s390.c         | 62 +++++++++++++++++++++++++++++++-
 arch/s390/kvm/pv.c               |  6 ++--
 arch/s390/mm/fault.c             |  2 +-
 7 files changed, 110 insertions(+), 6 deletions(-)

-- 
2.40.1

