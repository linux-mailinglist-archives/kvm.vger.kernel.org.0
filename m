Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE02525B9C2
	for <lists+kvm@lfdr.de>; Thu,  3 Sep 2020 06:26:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726047AbgICE0v (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Sep 2020 00:26:51 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:36922 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725851AbgICE0u (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Sep 2020 00:26:50 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0831Oawc169739;
        Thu, 3 Sep 2020 01:29:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=8d2PA+bnb3BaMMxU1VUW8GlQFSzjZAyv9cMxQHig4i8=;
 b=WkS7ePnXeGzpc2eoVM/1PX9oczmvnD4z+3LMVEBp6hqvMfHPCBWEguPz6Q6cGAxJwJv/
 JvnnhIFT2k5c0O1ABQvmSvS5D6o6R5cLG6YR7XN5/A/Rfke9NB2NkMTG2U8sdnswnwXL
 ikdW0gmxv+6SV4pVlThWETodtUdjqdaSS51xsXj0WP0K5hPNPPbZ28xXqvUKaGd+qvd+
 sN2Ba/65OTTsJSMKkzVxkVJaTg7po6xo9a1wt7tfeRuv2Yqa6NXE95Gull4VCgZuPuCT
 6w4uzNZb7KaKIr+CxIofVeA2um39LdzThYuak4gYm06COjmxGE/EoliENKrOMdqPPPwU 9A== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 337eymdwa5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 03 Sep 2020 01:29:10 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0831Oea1109426;
        Thu, 3 Sep 2020 01:29:10 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 3380x8cjh0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 03 Sep 2020 01:29:10 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0831T8Hm003229;
        Thu, 3 Sep 2020 01:29:08 GMT
Received: from nsvm-sadhukhan-1.osdevelopmeniad.oraclevcn.com (/100.100.230.216)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 02 Sep 2020 18:29:08 -0700
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com
Subject: [PATCH v2] nSVM: Add a test for the P (present) bit in NPT entry
Date:   Thu,  3 Sep 2020 01:28:51 +0000
Message-Id: <20200903012851.22299-2-krish.sadhukhan@oracle.com>
X-Mailer: git-send-email 2.18.4
In-Reply-To: <20200903012851.22299-1-krish.sadhukhan@oracle.com>
References: <20200903012851.22299-1-krish.sadhukhan@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9732 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 phishscore=0
 mlxlogscore=999 adultscore=0 suspectscore=1 bulkscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009030010
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9732 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 adultscore=0
 priorityscore=1501 phishscore=0 mlxlogscore=999 mlxscore=0
 lowpriorityscore=0 clxscore=1015 spamscore=0 bulkscore=0 impostorscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009030009
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

If the P (present) bit in an NPT entry is cleared, page translation will
fail at the level where the final guest physical address is translated to
the host physical address and the guest will VMEXIT to the host with an
exit code of 0x400 (#NPF). Additionally, the EXITINFO1 field will have
the following bit pattern set on VMEXIT:

	Bit# 0: Cleared due to the nested page not being preset (P bit cleared)
	Bit# 1: Cleared due to the access to the NPT being a read-access
	Bit# 2: Set due to the access to the NPT by MMU is a user-level access
	Bit# 3: Cleared due to no reserved bits being set in the NPT entry
	Bit# 4: Cleared due to the NPT walk being a code-read-access
	Bit# 32: Set due to the NPF occurring at the level where the final
		 guest physical address gets translated to host physical address

Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
---
 x86/svm_tests.c | 29 +++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

diff --git a/x86/svm_tests.c b/x86/svm_tests.c
index 1908c7c..f47d21d 100644
--- a/x86/svm_tests.c
+++ b/x86/svm_tests.c
@@ -720,6 +720,32 @@ static bool npt_nx_check(struct svm_test *test)
            && (vmcb->control.exit_info_1 == 0x100000015ULL);
 }
 
+static void npt_np_prepare(struct svm_test *test)
+{
+	u64 *pte;
+
+	scratch_page = alloc_page();
+	vmcb_ident(vmcb);
+	pte = npt_get_pte((u64)scratch_page);
+
+	*pte &= ~1ULL;
+}
+
+static void npt_np_test(struct svm_test *test)
+{
+	(void) *(volatile u64 *)scratch_page;
+}
+
+static bool npt_np_check(struct svm_test *test)
+{
+	u64 *pte = npt_get_pte((u64)scratch_page);
+
+	*pte |= 1ULL;
+
+	return (vmcb->control.exit_code == SVM_EXIT_NPF)
+	    && (vmcb->control.exit_info_1 == 0x100000004ULL);
+}
+
 static void npt_us_prepare(struct svm_test *test)
 {
     u64 *pte;
@@ -2119,6 +2145,9 @@ struct svm_test svm_tests[] = {
     { "npt_nx", npt_supported, npt_nx_prepare,
       default_prepare_gif_clear, null_test,
       default_finished, npt_nx_check },
+    { "npt_np", npt_supported, npt_np_prepare,
+      default_prepare_gif_clear, npt_np_test,
+      default_finished, npt_np_check },
     { "npt_us", npt_supported, npt_us_prepare,
       default_prepare_gif_clear, npt_us_test,
       default_finished, npt_us_check },
-- 
2.18.4

