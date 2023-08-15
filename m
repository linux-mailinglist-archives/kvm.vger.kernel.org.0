Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE77C77CED0
	for <lists+kvm@lfdr.de>; Tue, 15 Aug 2023 17:15:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237856AbjHOPOp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Aug 2023 11:14:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237920AbjHOPOe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Aug 2023 11:14:34 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4019F1BDA;
        Tue, 15 Aug 2023 08:14:24 -0700 (PDT)
Received: from pps.filterd (m0353726.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 37FEvj3E002279;
        Tue, 15 Aug 2023 15:14:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=zqjFYU5QdPdq/NHI3+4Y4CavCLJM0D8JM50BowmVVHA=;
 b=iCvRt7B/zb0TuebgrH4XD9DN0TVvhSBF2RDBYUsZw5Aui+hY1doZdQ+EpnulPe8s3CYb
 md+yb9bec1hHA4d9Pqt1CZToLJLjtsg+BKHzQWtduCII92CJ0D/tM3Pons7aZt/IkTsF
 RrLc6MTYtK9iR3WB20wwketskjvxsiGvBZPCzjJOfyALonipcl7Rfn8Ho4QxEKo/IoUh
 OT3bAp85/Vbf/yixmvkPsmcdUWTEwWVkUvcx5cRDnE+KoFAPzc9ioNQul7JLfvoFWDoo
 p0QlfuFjxbWFidB8eYyop38uxLEXwnrcjNlHCQ1cuFQsqKUpQ2YCkoNEdtj5F3aFngWX YA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3sgbk0gjj4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Aug 2023 15:14:23 +0000
Received: from m0353726.ppops.net (m0353726.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 37FF07SA008888;
        Tue, 15 Aug 2023 15:14:23 GMT
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3sgbk0gjhh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Aug 2023 15:14:23 +0000
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
        by ppma21.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 37FCuZt1002421;
        Tue, 15 Aug 2023 15:14:21 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
        by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3sendn5ktv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Aug 2023 15:14:21 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
        by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 37FFEGHn23921292
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 15 Aug 2023 15:14:16 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 30C082004D;
        Tue, 15 Aug 2023 15:14:16 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E3D262004B;
        Tue, 15 Aug 2023 15:14:15 +0000 (GMT)
Received: from a46lp73.lnxne.boe (unknown [9.152.108.100])
        by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Tue, 15 Aug 2023 15:14:15 +0000 (GMT)
From:   Steffen Eiden <seiden@linux.ibm.com>
To:     linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Michael Mueller <mimu@linux.vnet.ibm.com>,
        Marc Hartmayer <mhartmay@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Viktor Mihajlovski <mihajlov@linux.ibm.com>
Subject: [PATCH v4 0/4] KVM: s390: Enable AP instructions for PV-guests
Date:   Tue, 15 Aug 2023 17:14:11 +0200
Message-ID: <20230815151415.379760-1-seiden@linux.ibm.com>
X-Mailer: git-send-email 2.41.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: ZfryHlECIzIiy1jgoC-D9LPYFkrKAVrO
X-Proofpoint-GUID: Uq5wQWdWc86rcHF8N5uUtpVic3igFAjr
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.601,FMLib:17.11.176.26
 definitions=2023-08-15_16,2023-08-15_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1011 impostorscore=0
 bulkscore=0 mlxlogscore=542 suspectscore=0 phishscore=0 spamscore=0
 malwarescore=0 priorityscore=1501 mlxscore=0 lowpriorityscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2306200000 definitions=main-2308150134
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H5,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This series enables general KVM support for AP-passthrough for Secure
Execution guests (PV-guests).

To enable AP inside PV-guests two things have to be done/considered:
	1) set corresponding flags in the Create Secure Configuration UVC if
     firmware supports AP for PV-guests (patch 4).
	2) enable/disable AP in PV-guests if the VMM wants this (patch 3).

since v3:
  - add a patch from Viktor that handles a new rc that can occur with AP-pt.
  - remove KVM_S390_VM_CPU_UV_FEAT_GUEST_DEFAULT define (Janosch)
  - add a boundary check in uv_has_feature() (Janosch)
  - add r-b from Janosch

since v2:
  - applied styling recommendations from Heiko

since v1:
  - PATCH 1: r-b from Claudio
  - PATCH 2: fixed formatting issues (Claudio)
  - PATCH 3: removed unnecessary checks (Claudio)

Steffen

Steffen Eiden (3):
  s390: uv: UV feature check utility
  KVM: s390: Add UV feature negotiation
  KVM: s390: pv:  Allow AP-instructions for pv-guests

Viktor Mihajlovski (1):
  KVM: s390: pv: relax WARN_ONCE condition for destroy fast

 arch/s390/include/asm/kvm_host.h |  2 +
 arch/s390/include/asm/uv.h       | 19 +++++++-
 arch/s390/include/uapi/asm/kvm.h | 16 +++++++
 arch/s390/kernel/uv.c            |  2 +-
 arch/s390/kvm/kvm-s390.c         | 75 +++++++++++++++++++++++++++++++-
 arch/s390/kvm/pv.c               |  9 ++--
 arch/s390/mm/fault.c             |  2 +-
 7 files changed, 118 insertions(+), 7 deletions(-)

-- 
2.41.0

