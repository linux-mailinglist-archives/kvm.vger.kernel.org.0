Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB9A16CDB3B
	for <lists+kvm@lfdr.de>; Wed, 29 Mar 2023 15:52:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230105AbjC2NwV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Mar 2023 09:52:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbjC2NwT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Mar 2023 09:52:19 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4B15C4;
        Wed, 29 Mar 2023 06:52:17 -0700 (PDT)
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32TDmwsw014068;
        Wed, 29 Mar 2023 13:52:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : content-transfer-encoding : mime-version; s=pp1;
 bh=zwgwAGabZxOHhjihwDy6eqH9qBv7a2XT/ocgE64DQBY=;
 b=W/tXtAUu4ZwmozDIqEDEEbiUuMFDs5NvitqSVBw8DsYWExwu2FDCXkUzFnZ4+Kv5pMKi
 RhscO1gD2C5U6U1GMoDwVZC/q8cpYXyRUgiN3SEHslSs7bDKFFvb2SYGvMnCKF2WAJwO
 s5yVUkwHiR3FarNkag4UPzuhS0mi4LO7JKg2chJSkDsVsDd7CXZtnMn0hNt/Rttrjdde
 +vZKK604sxUJnS6oSY7tITru42CNjGmRLMaDrfg1CEA52wt6tfZgI3Y++OzhgItUK67Y
 9iZFKs1kkmQWhYCJOuZ5H5k+d2VYsHFTXdxHPZjbYMiIDp/1s88O/yqEwp2Wi1RhwBvW aw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3pmn2mb7vy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 29 Mar 2023 13:52:16 +0000
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 32TCrKtP012260;
        Wed, 29 Mar 2023 13:52:16 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3pmn2mb7va-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 29 Mar 2023 13:52:16 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 32SMhGAT010525;
        Wed, 29 Mar 2023 13:52:14 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
        by ppma03fra.de.ibm.com (PPS) with ESMTPS id 3phrk6m792-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 29 Mar 2023 13:52:14 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
        by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 32TDqBft43843928
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 29 Mar 2023 13:52:11 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E7F3E2004B;
        Wed, 29 Mar 2023 13:52:10 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6F38A20040;
        Wed, 29 Mar 2023 13:52:10 +0000 (GMT)
Received: from li-9fd7f64c-3205-11b2-a85c-df942b00d78d.ibm.com.com (unknown [9.171.75.165])
        by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Wed, 29 Mar 2023 13:52:10 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, david@redhat.com,
        borntraeger@linux.ibm.com, cohuck@redhat.com,
        linux-s390@vger.kernel.org, imbrenda@linux.ibm.com
Subject: [GIT PULL 0/1] kvm/s390: Fixes for 6.3
Date:   Wed, 29 Mar 2023 15:51:28 +0200
Message-Id: <20230329135129.77385-1-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.39.2
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: -Gj4nRQHCFK-RiLN0giiK1hAGs1sRRAY
X-Proofpoint-GUID: Vyoodi4xnUas9BYioLv84n7riRR5W7OJ
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-29_07,2023-03-28_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 bulkscore=0
 clxscore=1015 spamscore=0 malwarescore=0 priorityscore=1501
 impostorscore=0 adultscore=0 mlxlogscore=729 phishscore=0 suspectscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2303290107
X-Spam-Status: No, score=-0.1 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Dear Paolo,

currently we only have one fix patch to offer which repairs the
external loop detection code for PV guests.

Please pull,
Janosch

The following changes since commit 197b6b60ae7bc51dd0814953c562833143b292aa:

  Linux 6.3-rc4 (2023-03-26 14:40:20 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/kvms390/linux.git tags/kvm-s390-master-6.3-1

for you to fetch changes up to 21f27df854008b86349a203bf97fef79bb11f53e:

  KVM: s390: pv: fix external interruption loop not always detected (2023-03-28 07:16:37 +0000)

Nico Boehr (1):
      KVM: s390: pv: fix external interruption loop not always detected

 arch/s390/kvm/intercept.c | 32 ++++++++++++++++++++++++--------
 1 file changed, 24 insertions(+), 8 deletions(-)
-- 
2.39.2

