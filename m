Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 203F0517293
	for <lists+kvm@lfdr.de>; Mon,  2 May 2022 17:31:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1385791AbiEBPeh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 May 2022 11:34:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1385774AbiEBPeg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 May 2022 11:34:36 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01F9F10FCA;
        Mon,  2 May 2022 08:31:01 -0700 (PDT)
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 242EoO3A026378;
        Mon, 2 May 2022 15:31:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : content-transfer-encoding : mime-version; s=pp1;
 bh=/VoJ+AoqgeFf9BiV5ZbMjsYFGAZou4Vwb9itYmw+xOc=;
 b=WpVxJiaQeZo6EISLFbsiImFrjHnBifQly6noi60NxJ1Ffb0/enc4ixf0iPtFpMev9naU
 11y9HSvBfFp82LEfwlQ8DcHktLqAh/f9S1N2gr/D6Qgrwm4h5akdshwtul20VbAbyYVd
 9x/PugNuxOHm3qnLI5f6j/DS04Xl8LJ5oBEFXhOFDX+M61PWNxVc/c1xH9njd5eMYBSP
 Z4Pv6+XosQYmH6wRs8+GSot3T0PgbYQbCSAvuThHnm30OUBiurV4iFyEhQ6Gk0KkfnDe
 HMx1LaVoD5UzGGp4mYDwZLkpMLDpSmjri522Q8fMEJ19XOZvj08XNlgDuysUpvVSlco2 Kw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3fth1jsh7e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 02 May 2022 15:31:00 +0000
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 242FOjjU002652;
        Mon, 2 May 2022 15:30:59 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3fth1jsh6q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 02 May 2022 15:30:59 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 242FRxla025429;
        Mon, 2 May 2022 15:30:57 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma03ams.nl.ibm.com with ESMTP id 3frvr8tuw0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 02 May 2022 15:30:57 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 242FUsYE49414458
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 2 May 2022 15:30:54 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 74CE25204F;
        Mon,  2 May 2022 15:30:54 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTPS id 63A815204E;
        Mon,  2 May 2022 15:30:54 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 25651)
        id 34ADFE02C7; Mon,  2 May 2022 17:30:54 +0200 (CEST)
From:   Christian Borntraeger <borntraeger@linux.ibm.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     KVM <kvm@vger.kernel.org>, Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Janis Schoetterl-Glausch <scgl@linux.ibm.com>,
        Thomas Huth <thuth@redhat.com>
Subject: [GIT PULL 0/1] KVM: s390: Fix lockdep issue in vm memop
Date:   Mon,  2 May 2022 17:30:52 +0200
Message-Id: <20220502153053.6460-1-borntraeger@linux.ibm.com>
X-Mailer: git-send-email 2.35.1
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: LS5EmqijmTYkblOHM9H03q-LgVpKPbSS
X-Proofpoint-GUID: gTedacztcOomKeIY1KjYOOpTsgU0XNbe
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-02_04,2022-05-02_03,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0 mlxscore=0
 impostorscore=0 bulkscore=0 adultscore=0 clxscore=1015 spamscore=0
 suspectscore=0 mlxlogscore=825 phishscore=0 priorityscore=1501
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205020118
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Paolo,

one patch that is sitting already too long in my tree (sorry, was out of
office some days).

The following changes since commit 3bcc372c9865bec3ab9bfcf30b2426cf68bc18af:

  KVM: s390: selftests: Add error memop tests (2022-03-14 16:12:27 +0100)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvms390/linux.git  tags/kvm-s390-master-5.18-1

for you to fetch changes up to 4aa5ac75bf79cbbc46369163eb2e3addbff0d434:

  KVM: s390: Fix lockdep issue in vm memop (2022-03-23 10:41:04 +0100)

----------------------------------------------------------------
KVM: s390: fix lockdep warning in new MEMOP call

----------------------------------------------------------------
Janis Schoetterl-Glausch (1):
      KVM: s390: Fix lockdep issue in vm memop

 arch/s390/kvm/kvm-s390.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)
