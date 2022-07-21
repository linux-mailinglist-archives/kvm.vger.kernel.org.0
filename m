Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A1D5857D12A
	for <lists+kvm@lfdr.de>; Thu, 21 Jul 2022 18:14:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233633AbiGUQOi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Jul 2022 12:14:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233578AbiGUQOX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Jul 2022 12:14:23 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A69F289A7F;
        Thu, 21 Jul 2022 09:14:10 -0700 (PDT)
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26LG6jxK006196;
        Thu, 21 Jul 2022 16:13:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-transfer-encoding
 : mime-version; s=pp1; bh=PyDOz4Qq2e+bHwizu3jm5OITZAOxvMgw2bpY9oQVxDw=;
 b=gZGMJPnO3dkeSDPrqlvexRYcRt/5Dto3dLGtjOqpvatNbcY6tXGbqB4oT8se67dUMxji
 GUYgdWRy0Q/7cX2n3ZgopjHuEyGonsG3gbzytkyJqbqeeqK5t60vapvJ+cdqpV/blai0
 sCy1YZYSGKXZLhdRA15Jri9CSvgWwH0m3zRovTkxib+rwls4eSrXJpSx4AhqlZWGnMZR
 gUmxB6nfiBIfsrCTB4KVgWaOSrAxFqOT2obyLvWg4C86XPW7BfUkgQZcj53Sb7BVamsn
 sZ6XUY3droLkpdxQ5ENX9cjBmtUEwUSAAwXonlxvjNTbjrW2pdsvWvrN6w54MJPWL+yt iw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hf9tfgfms-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Jul 2022 16:13:26 +0000
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 26LG6wg7008242;
        Thu, 21 Jul 2022 16:13:25 GMT
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hf9tfgfjw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Jul 2022 16:13:25 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 26LG8YuP029970;
        Thu, 21 Jul 2022 16:13:23 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma05fra.de.ibm.com with ESMTP id 3hbmy8werm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Jul 2022 16:13:23 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 26LGDKM820447498
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Jul 2022 16:13:20 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0C02BA405C;
        Thu, 21 Jul 2022 16:13:20 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4F21CA4054;
        Thu, 21 Jul 2022 16:13:19 +0000 (GMT)
Received: from p-imbrenda.ibmuc.com (unknown [9.145.4.232])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 21 Jul 2022 16:13:19 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        frankja@linux.ibm.com, borntraeger@linux.ibm.com,
        hca@linux.ibm.com, gor@linux.ibm.com, agordeev@linux.ibm.com,
        thuth@redhat.com, david@redhat.com,
        Bagas Sanjaya <bagasdotme@gmail.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Jonathan Corbet <corbet@lwn.net>,
        Pierre Morel <pmorel@linux.ibm.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL 25/42] Documentation: kvm: extend KVM_S390_ZPCI_OP subheading underline
Date:   Thu, 21 Jul 2022 18:12:45 +0200
Message-Id: <20220721161302.156182-26-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220721161302.156182-1-imbrenda@linux.ibm.com>
References: <20220721161302.156182-1-imbrenda@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: m9rBFsKiJinVsJ8CgNsX_jVsSKV_Nhn1
X-Proofpoint-ORIG-GUID: lvQ0oQs65y2pk8uSL6x2Mcr0GnBHQk9B
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-21_22,2022-07-20_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 suspectscore=0
 phishscore=0 adultscore=0 mlxlogscore=806 clxscore=1015 bulkscore=0
 priorityscore=1501 malwarescore=0 impostorscore=0 lowpriorityscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2207210064
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Bagas Sanjaya <bagasdotme@gmail.com>

Stephen Rothwell reported the htmldocs warning:

Documentation/virt/kvm/api.rst:5959: WARNING: Title underline too short.

4.137 KVM_S390_ZPCI_OP
--------------------

The warning is due to subheading underline on KVM_S390_ZPCI_OP section is
short of 2 dashes.

Extend the underline to fix the warning.

Link: https://lore.kernel.org/linux-next/20220711205557.183c3b14@canb.auug.org.au/
Fixes: a0c4d1109d6cc5 ("KVM: s390: add KVM_S390_ZPCI_OP to manage guest zPCI devices")
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Pierre Morel <pmorel@linux.ibm.com>
Cc: Thomas Huth <thuth@redhat.com>
Cc: Matthew Rosato <mjrosato@linux.ibm.com>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Janosch Frank <frankja@linux.ibm.com>
Cc: kvm@vger.kernel.org
Cc: linux-s390@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Bagas Sanjaya <bagasdotme@gmail.com>
Link: https://lore.kernel.org/r/20220712092954.142027-4-bagasdotme@gmail.com
Signed-off-by: Christian Borntraeger <borntraeger@linux.ibm.com>
---
 Documentation/virt/kvm/api.rst | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 5abc0c1a5aff..5be5cc59869d 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -5956,7 +5956,7 @@ KVM_PV_DUMP_CPU
   The length of the returned data is provided by uv_info.guest_cpu_stor_len.
 
 4.137 KVM_S390_ZPCI_OP
---------------------
+----------------------
 
 :Capability: KVM_CAP_S390_ZPCI_OP
 :Architectures: s390
-- 
2.36.1

