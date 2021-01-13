Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D12772F41FF
	for <lists+kvm@lfdr.de>; Wed, 13 Jan 2021 03:47:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728277AbhAMCr1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Jan 2021 21:47:27 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:45938 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726406AbhAMCr0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Jan 2021 21:47:26 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10D2iMXY185076;
        Wed, 13 Jan 2021 02:46:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding;
 s=corp-2020-01-29; bh=W7ZvHrqwNaSrlRi/nBaFlLzxuIBB7Lu1nM1UtmASoaI=;
 b=j9+fcXCFA27SEZXRBCz2qBOkUWhH4h/7xzZy2iCDJKcjKEEKqs5p4rOHK5w+LmqYy9Xg
 Er8X0j2SK4PQunwP0XYu13BVkLMfLmRBHwPGMxVhMVI3FWHOK472qTwWFSFd0683u1tF
 lNxwjeLWhjQ1l7aAyUsiRAHxCyWbGPzKhfyvL12d42aF3EGcwIvCfPvTT1hQt3paqCIT
 Xu6ghGglKqmfaC31120XarNukpxtLFJ9j3qqXuMtrCxa4gM6LpGZX5/vqyVfCQyru+Er
 j3vq5TKPZGDnnG6SypikcYU/dwLFoJyCW/sG2/Cp/PTN5recE6SoiHA+VDFSACyp+uNS dg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 360kcysbt5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 13 Jan 2021 02:46:42 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10D2k36t147601;
        Wed, 13 Jan 2021 02:46:42 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 360keytnkq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 13 Jan 2021 02:46:42 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 10D2kfIq006717;
        Wed, 13 Jan 2021 02:46:41 GMT
Received: from nsvm-sadhukhan.osdevelopmeniad.oraclevcn.com (/100.100.230.216)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 12 Jan 2021 18:46:40 -0800
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com
Subject: [PATCH 0/3] KVM: nSVM: Check addresses of MSR bitmap and IO bitmap tables on vmrun of nested guests
Date:   Wed, 13 Jan 2021 02:46:30 +0000
Message-Id: <20210113024633.8488-1-krish.sadhukhan@oracle.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9862 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 malwarescore=0
 suspectscore=0 adultscore=0 spamscore=0 mlxlogscore=999 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101130014
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9862 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0
 impostorscore=0 bulkscore=0 adultscore=0 suspectscore=0 malwarescore=0
 lowpriorityscore=0 clxscore=1015 mlxlogscore=999 mlxscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101130014
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

According to section "Canonicalization and Consistency Checks" in APM vol 2,
the following guest state is illegal:

    "The MSR or IOIO intercept tables extend to a physical address that
     is greater than or equal to the maximum supported physical address."

Patch# 1: Adds the KVM checks.
Patch# 2: Adds a test
Patch# 3: Replaces a hard-coded value with an available macro.


[PATCH 1/3] KVM: nSVM: Check addresses of MSR and IO bitmap
[PATCH 2/3] Test: nSVM: Test MSR and IO bitmap address
[PATCH 3/3] Test: SVM: Use ALIGN macro when aligning 'io_bitmap_area'

 arch/x86/kvm/svm/nested.c | 17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

Krish Sadhukhan (1):
      nSVM: Check addresses of MSR and IO bitmap

 x86/svm.c       |  2 +-
 x86/svm_tests.c | 38 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 39 insertions(+), 1 deletion(-)

Krish Sadhukhan (2):
      nSVM: Test MSR and IO bitmap address
      SVM: Use ALIGN macro when aligning 'io_bitmap_area'

