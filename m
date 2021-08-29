Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 306E43FA968
	for <lists+kvm@lfdr.de>; Sun, 29 Aug 2021 08:01:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233899AbhH2GCV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 29 Aug 2021 02:02:21 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:50792 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229634AbhH2GCU (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sun, 29 Aug 2021 02:02:20 -0400
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17T5uDh5107480;
        Sun, 29 Aug 2021 02:01:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : content-transfer-encoding : mime-version; s=pp1;
 bh=qRUSnzH8Q5ZUGV0OXgkbCsOibmAMVxcMR4LqWn/knhk=;
 b=bakdzzjMOIuhLBVm9IjoIqZp9otlR97fE8spiCKwGKbE8c4K+e4aLBZdfjmljSghpyAc
 eEAXf2wIVal0a0OkJCpebeluVenBI64Rlwb8fnaqeYdWxnG3/f3heNWDJ5x8pzT+3XTT
 +zpCGvJ3CIDQwzPUtsPgzbCQjmtuDXeUiEuWWx6FuTUwrtaL9qaovei5TDh+498E21t9
 ef3l5+Nx3rmUn+H8nTvz9aXMxpkP3BCb0j11HIpXTbGFlwgqgTJjEIyXV5zVE+KPxH3F
 YL3KiD8MXtLGzRJBIurYntd3mbb8crJ6YvUur1VuE/ufkWc+X7kDLhTfDl6cJq5WpSU8 Dw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3ar4hcg2qp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 29 Aug 2021 02:01:28 -0400
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 17T5uED3107584;
        Sun, 29 Aug 2021 02:01:28 -0400
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3ar4hcg2q4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 29 Aug 2021 02:01:28 -0400
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 17T5tEg8012400;
        Sun, 29 Aug 2021 06:01:26 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma04fra.de.ibm.com with ESMTP id 3aqcs896dq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 29 Aug 2021 06:01:25 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 17T61M5J29819352
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 29 Aug 2021 06:01:22 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4E3B652051;
        Sun, 29 Aug 2021 06:01:22 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTPS id 39DB052065;
        Sun, 29 Aug 2021 06:01:22 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 25651)
        id DC72FE07E8; Sun, 29 Aug 2021 08:01:21 +0200 (CEST)
From:   Christian Borntraeger <borntraeger@de.ibm.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     KVM <kvm@vger.kernel.org>, Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Janis Schoetterl-Glausch <scgl@linux.ibm.com>
Subject: [GIT PULL 0/2] KVM: s390: Fix and feature for 5.15
Date:   Sun, 29 Aug 2021 08:01:19 +0200
Message-Id: <20210829060121.16702-1-borntraeger@de.ibm.com>
X-Mailer: git-send-email 2.31.1
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: ftngaYicVHpVnMw8eX-iQbvwxyGNFkTr
X-Proofpoint-GUID: bMb_SbGmhRlyAgiqHkc0dXUQs5HkP77R
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-29_01:2021-08-27,2021-08-29 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 adultscore=0
 clxscore=1015 impostorscore=0 suspectscore=0 phishscore=0 mlxlogscore=999
 lowpriorityscore=0 bulkscore=0 priorityscore=1501 mlxscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108290031
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Paolo,

sorry for being so late. One feature (enable hardware interpretion of
specification exceptions) and one fix targeted for stable. Given the
short runway to 5.14 I decided to let this go via next and not try to
sneak it into 5.14.

The following changes since commit 1f703d2cf20464338c3d5279dddfb65ac79b8782:

  KVM: s390: allow facility 192 (vector-packed-decimal-enhancement facility 2) (2021-06-23 09:35:20 +0200)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvms390/linux.git  tags/kvm-s390-next-5.15-1

for you to fetch changes up to a3e03bc1368c1bc16e19b001fc96dc7430573cc8:

  KVM: s390: index kvm->arch.idle_mask by vcpu_idx (2021-08-27 18:35:41 +0200)

----------------------------------------------------------------
KVM: s390: Fix and feature for 5.15

- enable interpretion of specification exceptions
- fix a vcpu_idx vs vcpu_id mixup

----------------------------------------------------------------
Halil Pasic (1):
      KVM: s390: index kvm->arch.idle_mask by vcpu_idx

Janis Schoetterl-Glausch (1):
      KVM: s390: Enable specification exception interpretation

 arch/s390/include/asm/kvm_host.h |  2 ++
 arch/s390/kvm/interrupt.c        | 12 ++++++------
 arch/s390/kvm/kvm-s390.c         |  4 +++-
 arch/s390/kvm/kvm-s390.h         |  2 +-
 arch/s390/kvm/vsie.c             |  2 ++
 5 files changed, 14 insertions(+), 8 deletions(-)
