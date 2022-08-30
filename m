Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 85C6E5A5E3D
	for <lists+kvm@lfdr.de>; Tue, 30 Aug 2022 10:35:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231565AbiH3If3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Aug 2022 04:35:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231449AbiH3If1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Aug 2022 04:35:27 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDB834B495;
        Tue, 30 Aug 2022 01:35:26 -0700 (PDT)
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27U8JQr8023862;
        Tue, 30 Aug 2022 08:35:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : content-transfer-encoding : mime-version; s=pp1;
 bh=Z0NpnLtel1OykdhGMb3I4wRWDo/nQNEbCIJD8hZWBIM=;
 b=NJ1OZwzcOQJvQhf9EblafUWEh2+06NiORKLd5PGQuBjYfhobjwZQ/ZuHGUeQnbir8KXp
 YKEptVkOkMrYu8CJKAbQnTtEc3R63MhRsaPILY2iCXJif06TzbZHeRGfXkWAAeGQj1/z
 QIZ0sWWu7ULjz9RytqcsfeuERgnRZlCuPDF+xALLa4aFFhLsT7HKq9knDRVOdGUQpghn
 k1r3A53EEXLOiMZFAJSSVYNvYMFgynbFoctATf9ORcZPbjDKPG3y315JSRQpCtVDfkyR
 8RylR+cSPUS+r2U1K6EtbxLvSLP4j6C4zbwMF+Qqlos5/x4fu68raPeHD76DmbMObJO4 Ag== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3j9exj8dgb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 30 Aug 2022 08:35:26 +0000
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 27U8K74s027522;
        Tue, 30 Aug 2022 08:35:25 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3j9exj8df6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 30 Aug 2022 08:35:25 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 27U8LiRk032163;
        Tue, 30 Aug 2022 08:35:23 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma03ams.nl.ibm.com with ESMTP id 3j7aw93ebs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 30 Aug 2022 08:35:23 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 27U8ZKij40108474
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 30 Aug 2022 08:35:20 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EBAA642041;
        Tue, 30 Aug 2022 08:35:19 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7EDC34203F;
        Tue, 30 Aug 2022 08:35:19 +0000 (GMT)
Received: from localhost.localdomain.com (unknown [9.145.56.39])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 30 Aug 2022 08:35:19 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, david@redhat.com,
        borntraeger@de.ibm.com, cohuck@redhat.com,
        linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        pmorel@linux.ibm.com
Subject: [GIT PULL 0/1] KVM: s390: VFIO PCI build fix
Date:   Tue, 30 Aug 2022 10:32:49 +0200
Message-Id: <20220830083250.25720-1-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.34.3
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: ZU7frhvgsyOaHvTB53MuHzgU0H3h1H0d
X-Proofpoint-GUID: H7H26RZg-5RqeqUvvVB7F8jAwdGXRK1z
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-30_04,2022-08-25_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 mlxscore=0
 lowpriorityscore=0 malwarescore=0 impostorscore=0 bulkscore=0
 priorityscore=1501 phishscore=0 spamscore=0 clxscore=1015 mlxlogscore=955
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2208300041
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Paolo,

here's a lone fix for a KVM/VFIO build problem.

A few PV fixes are currently still in development but fixing those
issues will be harder.

The following changes since commit b90cb1053190353cc30f0fef0ef1f378ccc063c5:

  Linux 6.0-rc3 (2022-08-28 15:05:29 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvms390/linux.git tags/kvm-s390-master-6.0-1

for you to fetch changes up to ca922fecda6caa5162409406dc3b663062d75089:

  KVM: s390: pci: Hook to access KVM lowlevel from VFIO (2022-08-29 13:29:28 +0200)

----------------------------------------------------------------
PCI interpretation compile fixes

----------------------------------------------------------------

Pierre Morel (1):
  KVM: s390: pci: Hook to access KVM lowlevel from VFIO

 arch/s390/include/asm/kvm_host.h | 17 ++++++-----------
 arch/s390/kvm/pci.c              | 12 ++++++++----
 arch/s390/pci/Makefile           |  2 +-
 arch/s390/pci/pci_kvm_hook.c     | 11 +++++++++++
 drivers/vfio/pci/vfio_pci_zdev.c |  8 ++++++--
 5 files changed, 32 insertions(+), 18 deletions(-)
 create mode 100644 arch/s390/pci/pci_kvm_hook.c

-- 
2.34.3

