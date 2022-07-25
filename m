Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3773580247
	for <lists+kvm@lfdr.de>; Mon, 25 Jul 2022 17:54:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235754AbiGYPy2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Jul 2022 11:54:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235658AbiGYPy2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 Jul 2022 11:54:28 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51C6A1147D
        for <kvm@vger.kernel.org>; Mon, 25 Jul 2022 08:54:27 -0700 (PDT)
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26PFk012033034
        for <kvm@vger.kernel.org>; Mon, 25 Jul 2022 15:54:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=cMum0QacRQktnXkMv7QB64n94QsAaCmUtLVK91ouWfg=;
 b=j6hp9p3nk5t94+HMP6myMki0z+Vyi9x4DEEL+xWyEWt4HtNe66vLlfoTJGUOV8hNQJ+6
 kDsNzvkq04wmz/y/yMPnzJzPs+TuAk9X6pwqYkH+au4L6YyjU9Oc5CQGz4ECGf3gLXRb
 nKlaOS1Or27cFLIgpVIsprdBA0QiFVEnMYV5cxSVhVWWG3EDiKQMKQQEeTDNevnhSSZL
 zPrACg63dQaAvKU+k+xaSGgfQrTtbyQWLQj8VpHJkyGnIFguMNe+FRewB/h1nzR7Mb2S
 dz5XK23J23LSBrGhWzV36vwLKZ+jeVGG5bT8Pu+BH8I+sybyGKlpQ2rIeS93wpX2dWOd aw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hhx3vg6rg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Mon, 25 Jul 2022 15:54:26 +0000
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 26PFmIoj039651
        for <kvm@vger.kernel.org>; Mon, 25 Jul 2022 15:54:25 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hhx3vg6qq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 25 Jul 2022 15:54:25 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 26PFpX9a008291;
        Mon, 25 Jul 2022 15:54:23 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma03ams.nl.ibm.com with ESMTP id 3hh6euhbws-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 25 Jul 2022 15:54:23 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 26PFsKq724969560
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 25 Jul 2022 15:54:20 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AF8D252050;
        Mon, 25 Jul 2022 15:54:20 +0000 (GMT)
Received: from a46lp57.lnxne.boe (unknown [9.152.108.100])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 72B005204E;
        Mon, 25 Jul 2022 15:54:20 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, imbrenda@linux.ibm.com, thuth@redhat.com
Subject: [kvm-unit-tests PATCH v3 0/3] s390x: add tests for SIGP call orders in enabled wait
Date:   Mon, 25 Jul 2022 17:54:17 +0200
Message-Id: <20220725155420.2009109-1-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: bnjWGio30Zh3obhhLQEoSIQb2h4qrIFE
X-Proofpoint-GUID: 5EBOI9L9_oi-p0GAOJwJrXDFwV7sXMxV
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-25_10,2022-07-25_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 priorityscore=1501
 mlxlogscore=714 lowpriorityscore=0 malwarescore=0 adultscore=0
 suspectscore=0 phishscore=0 spamscore=0 impostorscore=0 clxscore=1015
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2207250063
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

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

 s390x/smp.c | 200 +++++++++++++++++++++++++++++++---------------------
 1 file changed, 119 insertions(+), 81 deletions(-)

-- 
2.36.1

