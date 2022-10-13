Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D458D5FD5A9
	for <lists+kvm@lfdr.de>; Thu, 13 Oct 2022 09:42:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229527AbiJMHmC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Oct 2022 03:42:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229573AbiJMHmA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Oct 2022 03:42:00 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 833A012C8A2
        for <kvm@vger.kernel.org>; Thu, 13 Oct 2022 00:41:59 -0700 (PDT)
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29D7dYoG027284
        for <kvm@vger.kernel.org>; Thu, 13 Oct 2022 07:41:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : content-transfer-encoding : mime-version; s=pp1;
 bh=IGIhyWAwqHpOaZKLJlIEwBlgBsl1gTik0biTsuCTNww=;
 b=BBUj/sWFI7D3rvY5Qu75zVHM2GbLN+KwQ7VT/NZUtDo9ZVcLmjJsNLbnWRaYMV02kxBG
 GerRYawvSqACuJTygu8kI6A4PQb7/gNi4+aHrPWag7FLXzGIVUajKams4y07RRbqZji/
 /Smk4qcyp9ltsL2cTPlMOla/j5adQf0h5adMl+m/LmQMHrVXTNY2td2RmmaUgUzMldVO
 hSc7mp6MtELBlZcYx4HInTSyMrOJ7q2W3PgdZzRKYlvCSFcihcvG7swhOaW+QAXTLlQH
 oGBKgve6LPK77zhduOEZEsUE76MLqDpKQnPLwqatV/1SZZe5hREUayE9KmFfL5h8JuAE bA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3k6cx4k2ut-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 13 Oct 2022 07:41:58 +0000
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 29D5sidP028818
        for <kvm@vger.kernel.org>; Thu, 13 Oct 2022 07:41:58 GMT
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3k6cx4k2tn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 13 Oct 2022 07:41:58 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 29D7aORn016257;
        Thu, 13 Oct 2022 07:41:55 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma01fra.de.ibm.com with ESMTP id 3k30u8wdgc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 13 Oct 2022 07:41:55 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 29D7b5eB48759162
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 13 Oct 2022 07:37:05 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 947C311C050;
        Thu, 13 Oct 2022 07:41:52 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 628D311C052;
        Thu, 13 Oct 2022 07:41:52 +0000 (GMT)
Received: from a46lp57.lnxne.boe (unknown [9.152.108.100])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 13 Oct 2022 07:41:52 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, imbrenda@linux.ibm.com, thuth@redhat.com
Subject: [kvm-unit-tests PATCH v5 0/1] s390x: Add exit time test
Date:   Thu, 13 Oct 2022 09:41:51 +0200
Message-Id: <20221013074152.1412545-1-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.36.1
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: o0kV5w8BSlWrhcNhjLZf550D5D-gN68g
X-Proofpoint-ORIG-GUID: WC46VffYz7i_nRowNsa4vHgS34tXIdtU
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-13_05,2022-10-12_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015
 priorityscore=1501 impostorscore=0 mlxscore=0 lowpriorityscore=0
 malwarescore=0 suspectscore=0 adultscore=0 bulkscore=0 spamscore=0
 phishscore=0 mlxlogscore=668 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2209130000 definitions=main-2210130044
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

v4->v5:
---
* print normalized runtime to be able to compare runtime of
  instructions in a single run (thanks Claudio)

v3->v4:
---
* remove merge conflict markers (thanks Christian)

v2->v3:
---
* print average (thanks Claudio)
* have asm constraints look the same everywhere (thanks Claudio)
* rebase patchset on top of my migration sck patches[1] to make use of the
  time.h improvements

v1->v2:
---
* add missing cc clobber, fix constraints for get_clock_us() (thanks
  Thomas)
* avoid array and use pointer to const char* (thanks Thomas)
* add comment why testing nop makes sense (thanks Thomas)
* rework constraints and clobbers (thanks Thomas)

Sometimes, it is useful to measure the exit time of certain instructions
to e.g. identify performance regressions in instructions emulated by the
hypervisor.

This series adds a test which executes some instructions and measures
their execution time. Since their execution time depends a lot on the
environment at hand, all tests are reported as PASS currently.

The point of this series is not so much the instructions which have been
chosen here (but your ideas are welcome), but rather the general
question whether it makes sense to have a test like this in
kvm-unit-tests.

This series is based on my migration sck patches[1] to make use of the
time.h improvements there.

[1] https://lore.kernel.org/all/20221011170024.972135-1-nrb@linux.ibm.com/

Nico Boehr (1):
  s390x: add exittime tests

 s390x/Makefile      |   1 +
 s390x/exittime.c    | 311 ++++++++++++++++++++++++++++++++++++++++++++
 s390x/unittests.cfg |   4 +
 3 files changed, 316 insertions(+)
 create mode 100644 s390x/exittime.c

-- 
2.36.1

