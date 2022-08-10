Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 482D958E808
	for <lists+kvm@lfdr.de>; Wed, 10 Aug 2022 09:46:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231231AbiHJHqg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Aug 2022 03:46:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231209AbiHJHqZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Aug 2022 03:46:25 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F21A5A3E9
        for <kvm@vger.kernel.org>; Wed, 10 Aug 2022 00:46:24 -0700 (PDT)
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27A5ZrvS007294
        for <kvm@vger.kernel.org>; Wed, 10 Aug 2022 07:46:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=k70waNni3N9f4dE2P4pKQmD2Q/2lr5e2vXYJ8gajPwg=;
 b=SMn+sdvdipSyXqYw9Qo/Y+EEFXLMDLDG3ZAFGVRzLV8utMcpPNCtf31rYgI6igW3bZek
 CVqmQv1FcSQJ4w42uRpBwrYaXuAKnwfJow70dYVaRp1fmqbBpFq9BrCZMs+BVvC1nW2K
 +ZQNr2HbtVcm9U9lLKGnykkwgGNN9+0vfCy1FtCjRlA2lF1YIhjIM/VW0LO2d9gcLQo2
 MMJoUxDZsyOgmvczthk75fXn0WREn4C5HonCpUon0EJN/Pi8Os4SphiZm94sRc6Jyw7x
 bvWW3KAG8Ou652x3LDgIqikOyFXuOLnq7PNhjubZ8E5Q5GnO5+LznHG+0LCKz0hQfLkJ Wg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hv31vgaaq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Wed, 10 Aug 2022 07:46:23 +0000
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 27A6YjGP025168
        for <kvm@vger.kernel.org>; Wed, 10 Aug 2022 07:46:23 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hv31vga9c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 10 Aug 2022 07:46:23 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 27A7NRO1025811;
        Wed, 10 Aug 2022 07:46:20 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma03fra.de.ibm.com with ESMTP id 3huwvfrdgs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 10 Aug 2022 07:46:20 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 27A7kHm122086094
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 10 Aug 2022 07:46:17 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5BB864C04E;
        Wed, 10 Aug 2022 07:46:17 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 22B494C046;
        Wed, 10 Aug 2022 07:46:17 +0000 (GMT)
Received: from a46lp57.lnxne.boe (unknown [9.152.108.100])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 10 Aug 2022 07:46:17 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, imbrenda@linux.ibm.com, thuth@redhat.com
Subject: [kvm-unit-tests PATCH v4 0/3] s390x: add tests for SIGP call orders in enabled wait
Date:   Wed, 10 Aug 2022 09:46:13 +0200
Message-Id: <20220810074616.1223561-1-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: z5nxwEfH3X_aEpnwR_7P66p0ty2f1OSL
X-Proofpoint-ORIG-GUID: pgXGTo3oUJJYUuSwclr3IUvdTga7f31_
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-10_03,2022-08-09_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 impostorscore=0
 spamscore=0 adultscore=0 mlxscore=0 lowpriorityscore=0 bulkscore=0
 phishscore=0 suspectscore=0 malwarescore=0 priorityscore=1501
 mlxlogscore=728 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2208100021
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

v3->v4:
---
* uint32_t -> unsigned int for cr0_bit so it matches ctl_set/clear_bit
  argument (thanks Claudio)
* fix double interrupt not detected because ctl0 bit was cleared in the
  interrupt handler

v2->v3:
---
* added some comments (thanks Janosch)
* fix bit-mask confusion (thanks Janosch)
* remove ctl_clear_bit() in call_in_wait_received() since it's handled
  in the interrupt cleanup already

v1->v2:
---
* rebase to latest master to align with Claudio's SMP changes, drop
  patch which adds the ext int clean up since it is already in Claudio's
  series
* make sure ctl0 register bit is cleared

When a CPU is in enabled wait, it can still receive SIGP calls from
other CPUs.

Since this requires some special handling in KVM, we should have tests
for it. This has already revealed a KVM bug with ecall under PV, which
is why this test currently fails there.

Some refactoring is done as part of this series to reduce code
duplication.

Nico Boehr (3):
  s390x: smp: move sigp calls with invalid cpu address to array
  s390x: smp: use an array for sigp calls
  s390x: smp: add tests for calls in wait state

 s390x/smp.c | 217 +++++++++++++++++++++++++++++++++-------------------
 1 file changed, 137 insertions(+), 80 deletions(-)

-- 
2.36.1

