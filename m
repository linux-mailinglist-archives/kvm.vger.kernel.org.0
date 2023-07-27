Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B5E33765380
	for <lists+kvm@lfdr.de>; Thu, 27 Jul 2023 14:21:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233874AbjG0MVF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Jul 2023 08:21:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233851AbjG0MVC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Jul 2023 08:21:02 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A7842D56;
        Thu, 27 Jul 2023 05:21:00 -0700 (PDT)
Received: from pps.filterd (m0353727.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36RBC6ng015247;
        Thu, 27 Jul 2023 12:21:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=NV3+PLUlxdqf2XWgA2dYeSJKL2Pvl6qqkulPyUAaJEU=;
 b=aFTiaV4Fc/llL5Wh8n6YvUZ7pyYTRS/4EXrQSLPecoK1Eh7x7OKM4TiWIzgRSHN1l9H2
 qrHXjNH/lTW2QqUC5xP2Vhvnx3ZBvUYP75C6n+L2NOQyYE0/cSmK3wWrbDu6S2X+0FRv
 BH+CBVCdBcebNNH/p+bm+H7YbuxiFAw+pgkHv+MM6YZRBEsgvRzWbDJ5xbkrBF+LGZkw
 yrOKDl76Qn+fBzG/L8nbW7N5zpFCjnWFGK/6REZnnxX5UexgNOaxwDiyfdwlOlCRvRjj
 Vnbg1qryePj5hS7bS3ts9LSOmx6xLIntfQJ+2sfhwsjCbUHyKktAO/yEUCzPM5DH0pJm wg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3s3qg81u81-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 27 Jul 2023 12:20:59 +0000
Received: from m0353727.ppops.net (m0353727.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 36RBCpOd017476;
        Thu, 27 Jul 2023 12:20:58 GMT
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3s3qg81u7n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 27 Jul 2023 12:20:58 +0000
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
        by ppma22.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 36RASICL014374;
        Thu, 27 Jul 2023 12:20:57 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
        by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3s0stydnx2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 27 Jul 2023 12:20:57 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
        by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 36RCKs4v28770946
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 27 Jul 2023 12:20:54 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2AE1520043;
        Thu, 27 Jul 2023 12:20:54 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DBFA720040;
        Thu, 27 Jul 2023 12:20:53 +0000 (GMT)
Received: from a46lp73.lnxne.boe (unknown [9.152.108.100])
        by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Thu, 27 Jul 2023 12:20:53 +0000 (GMT)
From:   Steffen Eiden <seiden@linux.ibm.com>
To:     linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Michael Mueller <mimu@linux.vnet.ibm.com>,
        Marc Hartmayer <mhartmay@linux.ibm.com>
Subject: [PATCH 0/3] KVM: s390: Enable AP instructions for pv-guests
Date:   Thu, 27 Jul 2023 14:20:50 +0200
Message-Id: <20230727122053.774473-1-seiden@linux.ibm.com>
X-Mailer: git-send-email 2.40.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: qDUNraaa1HVV-zYZ2NzgNH-kmUsfkVWU
X-Proofpoint-GUID: f8BQ7fb5w0wC-93H26naxECrU8o16bPb
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-27_06,2023-07-26_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0
 lowpriorityscore=0 phishscore=0 mlxlogscore=435 adultscore=0
 suspectscore=0 clxscore=1015 impostorscore=0 priorityscore=1501 mlxscore=0
 spamscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2306200000 definitions=main-2307270108
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This series enables general KVM support for AP pass-through for Secure
Execution guests (pv-guests).

To enable AP inside pv-guests two things have to be done/considered:
	1) set corresponding flags in the Create Secure Configuration UVC ifi
     firmware supports AP for pv-guests (patch 3).
	2) enable/disable AP in pv-guests if the VMM wants this (patch 2).

Steffen

Steffen Eiden (3):
  s390: uv: UV feature check utility
  KVM: s390: Add UV feature negotiation
  KVM: s390: pv:  Allow AP-instructions for pv guests

 arch/s390/include/asm/kvm_host.h |  2 +
 arch/s390/include/asm/uv.h       | 17 +++++++-
 arch/s390/include/uapi/asm/kvm.h | 24 +++++++++++
 arch/s390/kernel/uv.c            |  2 +-
 arch/s390/kvm/kvm-s390.c         | 72 +++++++++++++++++++++++++++++++-
 arch/s390/kvm/pv.c               |  8 +++-
 arch/s390/mm/fault.c             |  2 +-
 7 files changed, 121 insertions(+), 6 deletions(-)

-- 
2.40.1

