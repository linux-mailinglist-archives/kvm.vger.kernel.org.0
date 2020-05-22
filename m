Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD5981DF2A5
	for <lists+kvm@lfdr.de>; Sat, 23 May 2020 01:02:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731303AbgEVXCz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 May 2020 19:02:55 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:32836 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731172AbgEVXCz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 May 2020 19:02:55 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04MMvcid092607;
        Fri, 22 May 2020 23:02:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=IxJ6cS14WCserilQLBoNiEGo0Bh0iAczz7ODlDCfecE=;
 b=jCat8/ByYWjsJGPHWUTerb5XSztD0+nYEtAa+lcksNW/EUqE2pajtU5SM28hvZYq1UwA
 n0Th0Re9pSSmDhbCOy8PtIqKTCzU6ka5s/U0d1HKX4G3zqvX8IJ0mLaSPlbi3t72uwml
 NHA0K7+K/isoaEGWP9/Jh/ZTk7hUbZFEingG39kEWf8SE6O3qLF//ASmVBCBCJvhozI/
 y56ucT/WLiuL5DMZBpezTKb3JppMCJcpqtwRYFhswNTM9IRSGcw4OBHk0KC3gIG4RuSv
 OMQ58sbHT77rcfbb0tFasfoX0DSXGzf8ibInr+k5CSqbuZg241e+cKiZQ0PamGllBxZk lQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 316qrvr1ab-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 22 May 2020 23:02:33 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04MMwaLC032242;
        Fri, 22 May 2020 23:02:33 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 314gmbxt6n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 22 May 2020 23:02:33 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 04MN2WGp002865;
        Fri, 22 May 2020 23:02:32 GMT
Received: from ban25x6uut29.us.oracle.com (/10.153.73.29)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 22 May 2020 16:02:31 -0700
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com
Subject: [PATCH 1/4] KVM: x86: Move the check for upper 32 reserved bits of DR6 to separate function
Date:   Fri, 22 May 2020 18:19:51 -0400
Message-Id: <20200522221954.32131-2-krish.sadhukhan@oracle.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200522221954.32131-1-krish.sadhukhan@oracle.com>
References: <20200522221954.32131-1-krish.sadhukhan@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9629 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=999
 adultscore=0 phishscore=0 mlxscore=0 spamscore=0 suspectscore=1
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2005220179
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9629 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 impostorscore=0
 malwarescore=0 cotscore=-2147483648 suspectscore=1 adultscore=0
 phishscore=0 clxscore=1015 priorityscore=1501 lowpriorityscore=0
 mlxlogscore=999 spamscore=0 bulkscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005220179
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
---
 arch/x86/kvm/x86.c | 2 +-
 arch/x86/kvm/x86.h | 5 +++++
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index c17e6eb..4746ec1 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1096,7 +1096,7 @@ static int __kvm_set_dr(struct kvm_vcpu *vcpu, int dr, unsigned long val)
 	case 4:
 		/* fall through */
 	case 6:
-		if (val & 0xffffffff00000000ULL)
+		if (!kvm_dr6_valid(val))
 			return -1; /* #GP */
 		vcpu->arch.dr6 = (val & DR6_VOLATILE) | kvm_dr6_fixed(vcpu);
 		break;
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index b968acc..5043108 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -354,6 +354,11 @@ static inline bool kvm_dr7_valid(u64 data)
 	/* Bits [63:32] are reserved */
 	return !(data >> 32);
 }
+static inline bool kvm_dr6_valid(u64 data)
+{
+	/* Bits [63:32] are reserved */
+	return !(data >> 32);
+}
 
 void kvm_load_guest_xsave_state(struct kvm_vcpu *vcpu);
 void kvm_load_host_xsave_state(struct kvm_vcpu *vcpu);
-- 
1.8.3.1

