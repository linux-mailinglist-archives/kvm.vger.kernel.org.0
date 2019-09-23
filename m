Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0AB75BBDD7
	for <lists+kvm@lfdr.de>; Mon, 23 Sep 2019 23:24:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503046AbfIWVYa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Sep 2019 17:24:30 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:15256 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2390066AbfIWVY3 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 23 Sep 2019 17:24:29 -0400
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x8NLNESS076409;
        Mon, 23 Sep 2019 17:24:18 -0400
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2v72g46feq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 23 Sep 2019 17:24:18 -0400
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id x8NLJNJV023606;
        Mon, 23 Sep 2019 21:24:17 GMT
Received: from b03cxnp08028.gho.boulder.ibm.com (b03cxnp08028.gho.boulder.ibm.com [9.17.130.20])
        by ppma02dal.us.ibm.com with ESMTP id 2v5bg74fee-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 23 Sep 2019 21:24:17 +0000
Received: from b03ledav005.gho.boulder.ibm.com (b03ledav005.gho.boulder.ibm.com [9.17.130.236])
        by b03cxnp08028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x8NLOG0A64684394
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 23 Sep 2019 21:24:16 GMT
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 36782BE053;
        Mon, 23 Sep 2019 21:24:16 +0000 (GMT)
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DD269BE051;
        Mon, 23 Sep 2019 21:24:14 +0000 (GMT)
Received: from LeoBras.aus.stglabs.ibm.com (unknown [9.18.235.184])
        by b03ledav005.gho.boulder.ibm.com (Postfix) with ESMTP;
        Mon, 23 Sep 2019 21:24:14 +0000 (GMT)
From:   Leonardo Bras <leonardo@linux.ibm.com>
To:     kvm@vger.kernel.org, kvm-ppc@vger.kernel.org
Cc:     Leonardo Bras <leonardo@linux.ibm.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 0/3] Replace current->mm by kvm->mm on powerpc/kvm
Date:   Mon, 23 Sep 2019 18:24:06 -0300
Message-Id: <20190923212409.7153-1-leonardo@linux.ibm.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-09-23_08:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=8 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1011 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=640 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1908290000 definitions=main-1909230179
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

By replacing, we would reduce the use of 'global' current on code,
relying more in the contents of kvm struct.

On code, I found that in kvm_create_vm() there is:
kvm->mm = current->mm;

And that on every kvm_*_ioctl we have tests like that:
if (kvm->mm != current->mm)
        return -EIO;

So this change would be safe.

I split the changes in 3 patches, so it would be easier to read
and reject separated parts. If decided that squashing is better,
I see no problem doing that.

Best regards,

Leonardo Bras (3):
  powerpc/kvm/book3s: Replace current->mm by kvm->mm
  powerpc/kvm/book3e: Replace current->mm by kvm->mm
  powerpc/kvm/e500: Replace current->mm by kvm->mm

 arch/powerpc/kvm/book3s_64_mmu_hv.c |  4 ++--
 arch/powerpc/kvm/book3s_64_vio.c    |  6 +++---
 arch/powerpc/kvm/book3s_hv.c        | 10 +++++-----
 arch/powerpc/kvm/booke.c            |  2 +-
 arch/powerpc/kvm/e500_mmu_host.c    |  6 +++---
 5 files changed, 14 insertions(+), 14 deletions(-)

-- 
2.20.1

