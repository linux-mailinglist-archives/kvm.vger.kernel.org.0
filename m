Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 992D97BD71C
	for <lists+kvm@lfdr.de>; Mon,  9 Oct 2023 11:33:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345449AbjJIJdO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Oct 2023 05:33:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345799AbjJIJdM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Oct 2023 05:33:12 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 918EACA;
        Mon,  9 Oct 2023 02:33:10 -0700 (PDT)
Received: from pps.filterd (m0353728.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3998vYLA005159;
        Mon, 9 Oct 2023 09:33:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=DEGfXopXxfNFo2GLBi+C68L/Odr0Kc84gq4TMiQHlHo=;
 b=TVKm265r0kf3o8SD9qVCN+Vo2koLMDvHHrputHtkXIgCfXpSESTMk22qyBGhdeOFg0Ej
 3QNPNtuHKgpREtoUthvxueznQAg4oEmZFTRN7q8PZbzs6JxUcQf72IDHPMLxsDl/oh/4
 jcoCmXuB2hgk0SoGZ5crt3sdxwyZ80LwFp7584EItHwS6D2niKHdpNKJpCXCzZLihlbB
 vN40N/pyV2JV5rxAcbUJQKXovgCTNlzMFS7TQ6oGZW2ZMCJSosu4uMDFdwnC/jC1IsQJ
 6hxfnAyedJZgLUXtM7u6afmr6WNGTA1sgndFSKoiW36wc11kTnMwcOKMJCOICA8UX74k vQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3tmefbrscs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 09 Oct 2023 09:33:09 +0000
Received: from m0353728.ppops.net (m0353728.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3999FvHL013656;
        Mon, 9 Oct 2023 09:33:09 GMT
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3tmefbrsc4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 09 Oct 2023 09:33:09 +0000
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
        by ppma21.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3999KNVl025927;
        Mon, 9 Oct 2023 09:33:08 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
        by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3tkjnmyyac-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 09 Oct 2023 09:33:08 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
        by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 3999X4ZX43778760
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 9 Oct 2023 09:33:04 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BEF392004B;
        Mon,  9 Oct 2023 09:33:04 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8A0F720040;
        Mon,  9 Oct 2023 09:33:04 +0000 (GMT)
Received: from t35lp63.lnxne.boe (unknown [9.152.108.100])
        by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Mon,  9 Oct 2023 09:33:04 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     borntraeger@linux.ibm.com, frankja@linux.ibm.com,
        imbrenda@linux.ibm.com, david@redhat.com
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
Subject: [PATCH v4 0/2] KVM: s390: add counters for vsie performance
Date:   Mon,  9 Oct 2023 11:32:51 +0200
Message-ID: <20231009093304.2555344-1-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.41.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: DQAds250jDIYJ9B3AJhHb3c7H2LYGo_5
X-Proofpoint-ORIG-GUID: kXmfZ4gjVH0q0mnLI2BYUQ_vAbsMznqG
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-09_07,2023-10-06_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 suspectscore=0
 adultscore=0 impostorscore=0 spamscore=0 priorityscore=1501 bulkscore=0
 lowpriorityscore=0 clxscore=1015 mlxscore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2309180000
 definitions=main-2310090078
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

v4:
---
* fix indent in tracepoint (thanks Janosch)

v3:
---
* rename te -> entry (David)
* add counters for gmap reuse and gmap create (David)

v2:
---
* also count shadowing of pages (Janosch)
* fix naming of counters (Janosch)
* mention shadowing of multiple levels is counted in each level (Claudio)
* fix inaccuate commit description regarding gmap notifier (Claudio)

When running a guest-3 via VSIE, guest-1 needs to shadow the page table
structures of guest-2.

To reflect changes of the guest-2 in the _shadowed_ page table structures,
the _shadowing_ sturctures sometimes need to be rebuilt. Since this is a
costly operation, it should be avoided whenever possible.

This series adds kvm stat counters to count the number of shadow gmaps
created and a tracepoint whenever something is unshadowed. This is a first
step to try and improve VSIE performance.

Please note that "KVM: s390: add tracepoint in gmap notifier" has some
checkpatch --strict findings. I did not fix these since the tracepoint
definition would then look completely different from all the other
tracepoints in arch/s390/kvm/trace-s390.h. If you want me to fix that,
please let me know.

Nico Boehr (2):
  KVM: s390: add stat counter for shadow gmap events
  KVM: s390: add tracepoint in gmap notifier

 arch/s390/include/asm/kvm_host.h |  7 +++++++
 arch/s390/kvm/gaccess.c          |  7 +++++++
 arch/s390/kvm/kvm-s390.c         | 11 ++++++++++-
 arch/s390/kvm/trace-s390.h       | 23 +++++++++++++++++++++++
 arch/s390/kvm/vsie.c             |  5 ++++-
 5 files changed, 51 insertions(+), 2 deletions(-)

-- 
2.41.0

