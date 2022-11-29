Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5F8A63BD21
	for <lists+kvm@lfdr.de>; Tue, 29 Nov 2022 10:42:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229935AbiK2JmA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Nov 2022 04:42:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230021AbiK2Jlu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 29 Nov 2022 04:41:50 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA38D5C0E2
        for <kvm@vger.kernel.org>; Tue, 29 Nov 2022 01:41:49 -0800 (PST)
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2AT7IPdh006636
        for <kvm@vger.kernel.org>; Tue, 29 Nov 2022 09:41:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=vRBLPQGax4KUVqw/MVCszbCyaoq/Gjyqs1F/Q78bd7k=;
 b=jhC6mm3zWgAXtoIHFfq+J2F5bIaWb62fENAKunWLH8Q7ULO4vnyaSjWrUpjGuMSV/Nkm
 xeSp/hwcLyIO3K2Rl4ox/iZD9mzHlVUJy+phkuCTot6lhgx6LBWTBORr0cFTQYZGmzNh
 afuq5zsfmXE16Mi325RrDInH0ErDGyqCnFsT5mRXFAfeBSIuCRtjSn03gjuyiV7hQy5n
 6KhuCDZwdhO2uef0oDgJ93WwdXbYvv+YvAIJ9hRpl3Kiphxc/UrbAmMbnhiCGwCraeuM
 KvIDY1JaZf6hnTeIQ7LGSWuKdTOEJ1grnKjq5XsU+9nqyxr7MzXP2B7WjQ9jruLTs9NY rw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3m5djwk81y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 29 Nov 2022 09:41:49 +0000
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2AT9aSAZ016600
        for <kvm@vger.kernel.org>; Tue, 29 Nov 2022 09:41:48 GMT
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3m5djwk818-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 29 Nov 2022 09:41:48 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2AT9ZFXo010999;
        Tue, 29 Nov 2022 09:41:46 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma05fra.de.ibm.com with ESMTP id 3m3ae9arnv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 29 Nov 2022 09:41:46 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2AT9fhvl27984630
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 29 Nov 2022 09:41:43 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6453342041;
        Tue, 29 Nov 2022 09:41:43 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 22C0A4203F;
        Tue, 29 Nov 2022 09:41:43 +0000 (GMT)
Received: from p-imbrenda.boeblingen.de.ibm.com (unknown [9.152.224.56])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 29 Nov 2022 09:41:43 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, nrb@linux.ibm.com, seiden@linux.ibm.com,
        scgl@linux.ibm.com, thuth@redhat.com
Subject: [PATCH v2 0/2] lib: s390x: add PSW and PSW_CUR_MASK macros
Date:   Tue, 29 Nov 2022 10:41:40 +0100
Message-Id: <20221129094142.10141-1-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: o1ge9XV_XilfpyXl-Ce52cMqRTT3XDNd
X-Proofpoint-GUID: vZG9UVDjN62a6gZJvO3CoAl26gi8rb3G
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-29_06,2022-11-28_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 adultscore=0
 mlxscore=0 bulkscore=0 priorityscore=1501 mlxlogscore=752 spamscore=0
 clxscore=1015 lowpriorityscore=0 phishscore=0 suspectscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211290059
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


Since a lot of code starts new CPUs using the current PSW mask, add two
macros to streamline the creation of generic PSWs and PSWs with the
current program mask.

Update the existing code to use the newly introduced macros.


Claudio Imbrenda (2):
  lib: s390x: add PSW and PSW_CUR_MASK macros
  s390x: use the new PSW and PSW_CUR_MASK macros

 lib/s390x/asm/arch_def.h |  4 +++
 s390x/adtl-status.c      | 24 +++---------------
 s390x/firq.c             |  5 +---
 s390x/migration.c        |  6 +----
 s390x/skrf.c             |  7 +-----
 s390x/smp.c              | 53 +++++++++-------------------------------
 s390x/uv-host.c          |  5 +---
 7 files changed, 23 insertions(+), 81 deletions(-)

-- 
2.38.1

