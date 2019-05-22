Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3D8A127327
	for <lists+kvm@lfdr.de>; Thu, 23 May 2019 02:12:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729064AbfEWAMi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 May 2019 20:12:38 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:44742 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728994AbfEWAMi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 May 2019 20:12:38 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4N04Ld2121839;
        Thu, 23 May 2019 00:12:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2018-07-02;
 bh=fCP09ilKX3gFNlX8Zw5y5521aYO7alNlmGyHnLWivGE=;
 b=243BBLP+6E5Nb9f9+th3MGdGxxB5WaD84PWPRDHAdySiW1lhdXWgg7yeFl8kSR0tJNLd
 4cCYD5rBtMlZg3OdpfQC4XQMCseH/KU3m2P/meXkqquDzDawazHe0KlpowTimw+vrMko
 +XTHM9/A3xOLXevMedh7qkisDBR5QlUEI1PFR6nMWmrR/WXVIVUZbpp12k+h0vztSgTM
 Kcmw2DdDLhoFtldNPM6dskfi6LNoT3W/1YvNAXjNR1fN9tIj3A9iwP1Qf6CJq62gn3uT
 sAK88NNMjVzRDPnTM9pz5O8r2VVMlc7fRWO7dVEId7pByo06eCmcD1hRN3jTvXKzszCm vA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2smsk5f43q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 23 May 2019 00:12:03 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4N0C3jU033982;
        Thu, 23 May 2019 00:12:03 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 2smsgswxy5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 23 May 2019 00:12:02 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x4N0C164003375;
        Thu, 23 May 2019 00:12:01 GMT
Received: from ban25x6uut29.us.oracle.com (/10.153.73.29)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 23 May 2019 00:12:01 +0000
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
To:     kvm@vger.kernel.org
Cc:     rkrcmar@redhat.com, pbonzini@redhat.com, jmattson@google.com
Subject: [PATCH 1/2] kvm-unit-test: x86: Add a wrapper to check if the CPU supports NX bit in MSR_EFER
Date:   Wed, 22 May 2019 19:45:44 -0400
Message-Id: <20190522234545.5930-2-krish.sadhukhan@oracle.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190522234545.5930-1-krish.sadhukhan@oracle.com>
References: <20190522234545.5930-1-krish.sadhukhan@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9265 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=13 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1905220168
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9265 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=13 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1905220168
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
Reviewed-by: Karl Heubaum <karl.heubaum@oracle.com>
---
 lib/x86/processor.h | 8 ++++++++
 x86/vmexit.c        | 2 +-
 2 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/lib/x86/processor.h b/lib/x86/processor.h
index 15237a5..2ca988e 100644
--- a/lib/x86/processor.h
+++ b/lib/x86/processor.h
@@ -476,4 +476,12 @@ static inline void set_bit(int bit, u8 *addr)
 			     : "+m" (*addr) : "Ir" (bit) : "cc", "memory");
 }
 
+static inline int efer_nx_enabled(void)
+{
+	if (cpuid(0x80000001).d & (1 << 20))
+		return 1;
+	else
+		return 0;
+}
+
 #endif
diff --git a/x86/vmexit.c b/x86/vmexit.c
index c12dd24..7053a46 100644
--- a/x86/vmexit.c
+++ b/x86/vmexit.c
@@ -526,7 +526,7 @@ static bool do_test(struct test *test)
 
 static void enable_nx(void *junk)
 {
-	if (cpuid(0x80000001).d & (1 << 20))
+	if (efer_nx_enabled())
 		wrmsr(MSR_EFER, rdmsr(MSR_EFER) | EFER_NX_MASK);
 }
 
-- 
2.20.1

