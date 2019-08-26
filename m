Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3687C9CD3D
	for <lists+kvm@lfdr.de>; Mon, 26 Aug 2019 12:25:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729909AbfHZKZj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Aug 2019 06:25:39 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:42530 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729713AbfHZKZj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Aug 2019 06:25:39 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7QANtdL180807;
        Mon, 26 Aug 2019 10:25:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2019-08-05;
 bh=0+6TQbTOfjgPGnk0mmhKb+lU/1ufITZyvfUTwWdfu+w=;
 b=Mwlfe31ioElwhL+JYh2DTU+wXtjGglPwIyNBiVXBKfjV8/OELX0kUs/dWL0sRrP6CV6X
 bsgADdq8ifCY/7S5PpR52PD/54jrPq49ZOkqiaj5k1yKUa9ptZl5okZLUJnu+zmQxQXL
 wwsbfDgMnkjhp97DjKo+C9FDsjhcVkijwFDWYJ1X9GfHMtE7QzNf8lqWyMMujhVeeYD8
 /ZbAgI9dDWRTJcI7Ml7jf+/G26mjjqgXhmFKYMN1hvgPygxuKiZe/m/JRGrV5NhIIHwM
 D5X75xr7gatyTnwFb4a4cWUno8QEChqlzmgTcONc6RLw+DVVGdfeA0G6nc+v/yLaiff6 XQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 2ujw70052u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 26 Aug 2019 10:25:21 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7QAO3Wv103452;
        Mon, 26 Aug 2019 10:25:21 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 2ujw6hmjst-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 26 Aug 2019 10:25:21 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x7QAPKEJ009879;
        Mon, 26 Aug 2019 10:25:20 GMT
Received: from spark.ravello.local (/213.57.127.2)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 26 Aug 2019 10:25:19 +0000
From:   Liran Alon <liran.alon@oracle.com>
To:     pbonzini@redhat.com, rkrcmar@redhat.com, kvm@vger.kernel.org
Cc:     sean.j.christopherson@intel.com, jmattson@google.com,
        vkuznets@redhat.com, Liran Alon <liran.alon@oracle.com>,
        Bhavesh Davda <bhavesh.davda@oracle.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        Nikita Leshenko <nikita.leshchenko@oracle.com>
Subject: [PATCH 1/2] KVM: VMX: Introduce exit reason for receiving INIT signal on guest-mode
Date:   Mon, 26 Aug 2019 13:24:48 +0300
Message-Id: <20190826102449.142687-2-liran.alon@oracle.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190826102449.142687-1-liran.alon@oracle.com>
References: <20190826102449.142687-1-liran.alon@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9360 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=604
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908260115
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9360 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=666 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908260116
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

According to Intel SDM section 25.2 "Other Causes of VM Exits",
When INIT signal is received on a CPU that is running in VMX
non-root mode it should cause an exit with exit-reason of 3.
(See Intel SDM Appendix C "VMX BASIC EXIT REASONS")

This patch introduce the exit-reason definition.

Reviewed-by: Bhavesh Davda <bhavesh.davda@oracle.com>
Reviewed-by: Joao Martins <joao.m.martins@oracle.com>
Co-developed-by: Nikita Leshenko <nikita.leshchenko@oracle.com>
Signed-off-by: Nikita Leshenko <nikita.leshchenko@oracle.com>
Signed-off-by: Liran Alon <liran.alon@oracle.com>
---
 arch/x86/include/uapi/asm/vmx.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/include/uapi/asm/vmx.h b/arch/x86/include/uapi/asm/vmx.h
index f0b0c90dd398..f01950aa7fae 100644
--- a/arch/x86/include/uapi/asm/vmx.h
+++ b/arch/x86/include/uapi/asm/vmx.h
@@ -31,6 +31,7 @@
 #define EXIT_REASON_EXCEPTION_NMI       0
 #define EXIT_REASON_EXTERNAL_INTERRUPT  1
 #define EXIT_REASON_TRIPLE_FAULT        2
+#define EXIT_REASON_INIT_SIGNAL			3
 
 #define EXIT_REASON_PENDING_INTERRUPT   7
 #define EXIT_REASON_NMI_WINDOW          8
@@ -90,6 +91,7 @@
 	{ EXIT_REASON_EXCEPTION_NMI,         "EXCEPTION_NMI" }, \
 	{ EXIT_REASON_EXTERNAL_INTERRUPT,    "EXTERNAL_INTERRUPT" }, \
 	{ EXIT_REASON_TRIPLE_FAULT,          "TRIPLE_FAULT" }, \
+	{ EXIT_REASON_INIT_SIGNAL,           "INIT_SIGNAL" }, \
 	{ EXIT_REASON_PENDING_INTERRUPT,     "PENDING_INTERRUPT" }, \
 	{ EXIT_REASON_NMI_WINDOW,            "NMI_WINDOW" }, \
 	{ EXIT_REASON_TASK_SWITCH,           "TASK_SWITCH" }, \
-- 
2.20.1

