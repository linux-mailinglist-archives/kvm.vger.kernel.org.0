Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39620559CC2
	for <lists+kvm@lfdr.de>; Fri, 24 Jun 2022 17:00:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233479AbiFXOvX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Jun 2022 10:51:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233316AbiFXOvG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Jun 2022 10:51:06 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 856038288B;
        Fri, 24 Jun 2022 07:45:40 -0700 (PDT)
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25OD6h68019389;
        Fri, 24 Jun 2022 14:45:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=oOhFBn2hJsOZnH84dhl+a/us9yUmZ2e5qLyWHskSt/4=;
 b=r5ow47lY/0MJrZRd1fys7RFd6+QcoCTJ7EGYRI+R0UWv3SVFs6hzcZBhkfg9s+6NJ785
 I1/dUoJXncw+ULPApV2QGmp1JbgNZAMQTuQ+KxBv3spjsB2CmBEF9WhKzsr4p/sB4oQP
 xImMrITsNio+gPSI0aEAPcIz/njLy9LZ/T3CWY23DZX35OlN/fk+I8i1FKDrCQaSUNiG
 Tus0VUbe/tbrNptNhnzRp9MWy4AggOgPeH7Q0G7m00/37gxTuB/DBwO1gKCDtBjsB2Zi
 cd3lcPXlha5ib1GmXDT+aEVk6QVYrM/XFgeVdQHzQi/ewV9s6rDk5bYuU0EkjCP12Sg5 RQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gw9hysw99-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 24 Jun 2022 14:45:25 +0000
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 25OE69Qr009460;
        Fri, 24 Jun 2022 14:45:25 GMT
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gw9hysw8a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 24 Jun 2022 14:45:25 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 25OELcPm008564;
        Fri, 24 Jun 2022 14:45:22 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma01fra.de.ibm.com with ESMTP id 3gv3j6ap7q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 24 Jun 2022 14:45:22 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 25OEjPUO32833862
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 24 Jun 2022 14:45:25 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 70630A4053;
        Fri, 24 Jun 2022 14:45:19 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2C554A4051;
        Fri, 24 Jun 2022 14:45:19 +0000 (GMT)
Received: from p-imbrenda.boeblingen.de.ibm.com (unknown [9.152.224.40])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 24 Jun 2022 14:45:19 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        scgl@linux.ibm.com, nrb@linux.ibm.com, thuth@redhat.com
Subject: [kvm-unit-tests PATCH v2 0/3] better smp interrupt checks
Date:   Fri, 24 Jun 2022 16:45:15 +0200
Message-Id: <20220624144518.66573-1-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: a2ekArEbNYtZjC5swi5ZEVMvZEEmwKf_
X-Proofpoint-ORIG-GUID: hHkD5J8xmUPVso-aaWF0kbKvBdn5xlGH
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-06-24_07,2022-06-23_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 adultscore=0
 lowpriorityscore=0 spamscore=0 bulkscore=0 mlxlogscore=554 malwarescore=0
 priorityscore=1501 clxscore=1015 suspectscore=0 mlxscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2204290000
 definitions=main-2206240056
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Use per-CPU flags and callbacks for Program, Extern, and I/O interrupts
instead of global variables.
    
This allows for more accurate error handling; a CPU waiting for an
interrupt will not have it "stolen" by a different CPU that was not
supposed to wait for one, and now two CPUs can wait for interrupts at
the same time.

Also fix skey.c to be compatible with the new interrupt handling.

Add some utility functions to manipulate bits in the PSW mask, to
improve readability.

Claudio Imbrenda (3):
  lib: s390x: add functions to set and clear PSW bits
  s390x: skey.c: rework the interrupt handler
  lib: s390x: better smp interrupt checks

 lib/s390x/asm/arch_def.h | 75 +++++++++++++++++++++++++++++++++++-----
 lib/s390x/asm/pgtable.h  |  2 --
 lib/s390x/smp.h          |  8 +----
 lib/s390x/interrupt.c    | 57 ++++++++++++++++++++++--------
 lib/s390x/mmu.c          | 14 +-------
 lib/s390x/sclp.c         |  7 +---
 lib/s390x/smp.c          | 11 ++++++
 s390x/diag288.c          |  6 ++--
 s390x/selftest.c         |  4 +--
 s390x/skey.c             | 24 +++++--------
 s390x/skrf.c             | 12 ++-----
 s390x/smp.c              | 18 ++--------
 12 files changed, 141 insertions(+), 97 deletions(-)

-- 
2.36.1

