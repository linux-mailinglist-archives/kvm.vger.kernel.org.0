Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 479C7606312
	for <lists+kvm@lfdr.de>; Thu, 20 Oct 2022 16:32:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229911AbiJTOcK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Oct 2022 10:32:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229752AbiJTOcH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Oct 2022 10:32:07 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60445196357;
        Thu, 20 Oct 2022 07:32:06 -0700 (PDT)
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29KDlfwd019070;
        Thu, 20 Oct 2022 14:32:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=4+UEjqwJWPIeH7Q4GTtEwU1Sd32iswuXqZeVqSLTVMw=;
 b=WPjemOpH3VDAyaHBv/itwzb9GpsXKos6jgiW7Py5/aKYCIK0W81ld6jFwiko4Iyzuzap
 58/4nXWKM+8JMrQxrcvGye+evVzIKSNAz+XnfweoTQt++XpeXkfL8G3Z2W+vpXv0EPa4
 ClhnlElv68qkPry3sA8eJP0I4g1wPsNLz87e18oRBHeXwpJqd2rk9y3+11+p+Str5B3g
 1wM+pUjC0dIAnf5qFIiGlcPsKXy91A/Qr6zXPTUovbh3nb5he3MGvYu2Ostjgw+YqTNK
 Rc0/oSG2TwuRmsmfSfmQSSH/Muwz2WAbwc+6XS80JuPktcoZfWaNWQMpmJk6Wy9ccDOU YQ== 
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3kb7h81xy0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 20 Oct 2022 14:32:05 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 29KELjWY013741;
        Thu, 20 Oct 2022 14:32:03 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma04fra.de.ibm.com with ESMTP id 3k7mg96tce-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 20 Oct 2022 14:32:03 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 29KEW0wN459456
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 20 Oct 2022 14:32:00 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 17B56AE051;
        Thu, 20 Oct 2022 14:32:00 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B6C7DAE04D;
        Thu, 20 Oct 2022 14:31:59 +0000 (GMT)
Received: from t35lp63.lnxne.boe (unknown [9.152.108.100])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 20 Oct 2022 14:31:59 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     borntraeger@linux.ibm.com, frankja@linux.ibm.com,
        imbrenda@linux.ibm.com
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org, hca@linux.ibm.com,
        gor@linux.ibm.com, agordeev@linux.ibm.com
Subject: [v1 0/5] KVM: s390: Fix virtual-real address confusions
Date:   Thu, 20 Oct 2022 16:31:54 +0200
Message-Id: <20221020143159.294605-1-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.37.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: lzwuTSS37smEneyfAShazi0JweFbdKd1
X-Proofpoint-ORIG-GUID: lzwuTSS37smEneyfAShazi0JweFbdKd1
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-20_05,2022-10-20_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 suspectscore=0 clxscore=1015 malwarescore=0 phishscore=0 mlxscore=0
 adultscore=0 lowpriorityscore=0 priorityscore=1501 spamscore=0
 mlxlogscore=816 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2209130000 definitions=main-2210200083
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This series fixes several virtual-real address confusions in the basic
KVM infrastructure for s390.

Since physical addresses are currently equal to virtual addresses in
kernel space, the address confusions do not represent issues at the
moment.

IO-related fixes are going to follow in further series.

Nico Boehr (5):
  s390/mm: gmap: sort out physical vs virtual pointers usage
  s390/entry: sort out physical vs virtual pointers usage in sie64a
  KVM: s390: sort out physical vs virtual pointers usage
  KVM: s390: sida: sort out physical vs virtual pointers usage
  KVM: s390: pv: sort out physical vs virtual pointers usage

 arch/s390/include/asm/kvm_host.h   |  12 ++-
 arch/s390/include/asm/stacktrace.h |   1 +
 arch/s390/kernel/asm-offsets.c     |   1 +
 arch/s390/kernel/entry.S           |  26 ++---
 arch/s390/kvm/intercept.c          |   9 +-
 arch/s390/kvm/kvm-s390.c           |  53 ++++++-----
 arch/s390/kvm/kvm-s390.h           |   5 +-
 arch/s390/kvm/priv.c               |   3 +-
 arch/s390/kvm/pv.c                 |  17 ++--
 arch/s390/mm/gmap.c                | 147 +++++++++++++++--------------
 10 files changed, 150 insertions(+), 124 deletions(-)

-- 
2.37.3

