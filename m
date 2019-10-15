Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 672B9D6CA8
	for <lists+kvm@lfdr.de>; Tue, 15 Oct 2019 02:53:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727273AbfJOAxB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Oct 2019 20:53:01 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:58802 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727259AbfJOAxA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Oct 2019 20:53:00 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9F0n2dh014170;
        Tue, 15 Oct 2019 00:52:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2019-08-05;
 bh=A8+L0eme83pTqd5Y1BDEDDB76m1kmITNQZ8NqER1iIE=;
 b=nVVelDNpli9G3PZgcAsfcKo6adxqkuy2T4ytnqADfN8jebfSt9cJViOKyjdlhCjYM1Hq
 Xf4sb4UmX1hlG9wmg/qRbFeHYZnmPPuBF7GOe4yObhqmDfzgQ2wh4YodNHgfZHevKpnX
 YHQuLB9lR5+sIkZVka1tkeGl6pCY7nMhLrIbRXKuK2DS3NsQrv/bR81rimJFSH6Jfabw
 1v8tDHp/j64+6uT4+xdZvp6kxdEbvVRhzTNycS8rfYgUNGeHlayNF/kt4G/VbeG2Ao+3
 4NSNZ/tb+qu86ZhDEPgnYWheZdh3xlyUCezIEH4lKSE3UxuG0JSOD0PY11eJGOrT1Swe lw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2vk68ucax2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 15 Oct 2019 00:52:38 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9F0mvWI101114;
        Tue, 15 Oct 2019 00:52:37 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 2vkrbkw0c2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 15 Oct 2019 00:52:37 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x9F0qa0L030997;
        Tue, 15 Oct 2019 00:52:36 GMT
Received: from ban25x6uut29.us.oracle.com (/10.153.73.29)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 15 Oct 2019 00:52:36 +0000
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, rkrcmar@redhat.com, jmattson@google.com
Subject: [PATCH 2/4] kvm-unit-test: nVMX: __enter_guest() needs to also check for VMX_FAIL_STATE
Date:   Mon, 14 Oct 2019 20:16:31 -0400
Message-Id: <20191015001633.8603-3-krish.sadhukhan@oracle.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191015001633.8603-1-krish.sadhukhan@oracle.com>
References: <20191015001633.8603-1-krish.sadhukhan@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9410 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=13 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910150007
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9410 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=13 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910150007
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

  ..as both VMX_ENTRY_FAILURE and VMX_FAIL_STATE together comprise the
    exit eeason when VM-entry fails due invalid guest state.

Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
Reviewed-by: Karl Heubaum <karl.heubaum@oracle.com>
---
 x86/vmx.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/x86/vmx.c b/x86/vmx.c
index 647ab49..4ce0fb5 100644
--- a/x86/vmx.c
+++ b/x86/vmx.c
@@ -1848,7 +1848,8 @@ static void __enter_guest(u8 abort_flag, struct vmentry_failure *failure)
 	vmx_enter_guest(failure);
 	if ((abort_flag & ABORT_ON_EARLY_VMENTRY_FAIL && failure->early) ||
 	    (abort_flag & ABORT_ON_INVALID_GUEST_STATE &&
-	    vmcs_read(EXI_REASON) & VMX_ENTRY_FAILURE)) {
+	    (vmcs_read(EXI_REASON) & (VMX_ENTRY_FAILURE | VMX_FAIL_STATE))
+	    == (VMX_ENTRY_FAILURE | VMX_FAIL_STATE))) {
 
 		print_vmentry_failure_info(failure);
 		abort();
-- 
2.20.1

