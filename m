Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E9131DF2AB
	for <lists+kvm@lfdr.de>; Sat, 23 May 2020 01:04:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731333AbgEVXEh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 May 2020 19:04:37 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:44510 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731322AbgEVXEg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 May 2020 19:04:36 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04MMvxhR145338;
        Fri, 22 May 2020 23:04:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=cSxb/vSYn7y60DgcKHUMcctNjEclEQ1N4Dh5h3I9hFs=;
 b=Gkst6EwKdl6UgQJ1Ep6Voyy+N+pfb931VceDf3+PvG2XSX6Tcd4HUmPDtSNT+6skJFgH
 v0jrDahcKKuMfx8W7q74iSpeGf8h1khuhUdVCqrnOyqfFXzsZMEXtWGpc+c1vO8rcNcB
 RCI9IrDk1WzjSHIoyfSe9JxZXdbUzvHeisCK73gfxLyaCY9EefLGqcXBsAgmmmQiH2lz
 2cin3LNQL78C8KCLCKOZNX1rlJtwK0HsKjq74nEZTcePjR1csP4vrwWDkNErrnLqg4zJ
 bu/t0KgKVDY00Xo9Qbkz2vlfRQeBQtqI0vapwgOuC+N6SwmNOkEuwrBDc6Np8t4+9ysB bw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 31284mg1y2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 22 May 2020 23:04:34 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04MMxKtp192402;
        Fri, 22 May 2020 23:02:33 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 3150254gqt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 22 May 2020 23:02:33 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 04MN2WVP007582;
        Fri, 22 May 2020 23:02:32 GMT
Received: from ban25x6uut29.us.oracle.com (/10.153.73.29)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 22 May 2020 16:02:32 -0700
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com
Subject: [PATCH 2/4] KVM: nSVM: Check that DR6[63:32] and DR7[64:32] are not set on vmrun of nested guests
Date:   Fri, 22 May 2020 18:19:52 -0400
Message-Id: <20200522221954.32131-3-krish.sadhukhan@oracle.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200522221954.32131-1-krish.sadhukhan@oracle.com>
References: <20200522221954.32131-1-krish.sadhukhan@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9629 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 bulkscore=0 suspectscore=1 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005220179
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9629 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 mlxscore=0
 cotscore=-2147483648 impostorscore=0 malwarescore=0 mlxlogscore=999
 lowpriorityscore=0 phishscore=0 spamscore=0 bulkscore=0 adultscore=0
 priorityscore=1501 clxscore=1015 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2005220179
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

According to section "Canonicalization and Consistency Checks" in APM vol. 2
the following guest state is illegal:

    "DR6[63:32] are not zero."
    "DR7[63:32] are not zero."
    "Any MBZ bit of EFER is set."

Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
---
 arch/x86/kvm/svm/nested.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 9a2a62e..2fec51d 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -208,6 +208,9 @@ static bool nested_vmcb_checks(struct vmcb *vmcb)
 	if ((vmcb->save.efer & EFER_SVME) == 0)
 		return false;
 
+	if (!kvm_dr6_valid(vmcb->save.dr6) || !kvm_dr7_valid(vmcb->save.dr7))
+		return false;
+
 	if ((vmcb->control.intercept & (1ULL << INTERCEPT_VMRUN)) == 0)
 		return false;
 
-- 
1.8.3.1

