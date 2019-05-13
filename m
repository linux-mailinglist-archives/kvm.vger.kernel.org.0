Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4C3301B890
	for <lists+kvm@lfdr.de>; Mon, 13 May 2019 16:40:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730610AbfEMOkV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 May 2019 10:40:21 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:37628 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730584AbfEMOkQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 May 2019 10:40:16 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4DEdHlu193231;
        Mon, 13 May 2019 14:39:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2018-07-02;
 bh=gJ5tt/4IYtOQ64SjXc4XK/hg4MlEde9v0jqeQXYD/eQ=;
 b=ZVeO12rORSnjNn30oKP4IfrRQOnpuWsZZpTFew29AW/A1AopB4vNTvJPzoBUNnLwecR5
 RxfhLqEFwtp98NkffYHLWW/xGFZAMdCGFC1Cm5FhGyQSMCaCSB6w20I2qahvkzKCsFa5
 m/f/wbDM5y5zJuEnz5wG8g9nfWjmPhU8RB2bXp/ASv1kj1gRX0Hrz8Moy8R160Qf+K6H
 gpnLK5eK57XeoRIkkZcloR/MsoTBMRliLnztAGJlyy4fIbv6fkl19QVpaSKUSvXbYn60
 PuCO41ERbdVUgxGByWPWdcyJSJL7JyT3ve6bcXI+B2FmQnOupQrAXYuphyQi5YY9ctn+ Fg== 
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by aserp2130.oracle.com with ESMTP id 2sdkwdfm05-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 13 May 2019 14:39:44 +0000
Received: from achartre-desktop.fr.oracle.com (dhcp-10-166-106-34.fr.oracle.com [10.166.106.34])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id x4DEcZQN022780;
        Mon, 13 May 2019 14:39:36 GMT
From:   Alexandre Chartre <alexandre.chartre@oracle.com>
To:     pbonzini@redhat.com, rkrcmar@redhat.com, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
        dave.hansen@linux.intel.com, luto@kernel.org, peterz@infradead.org,
        kvm@vger.kernel.org, x86@kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Cc:     konrad.wilk@oracle.com, jan.setjeeilers@oracle.com,
        liran.alon@oracle.com, jwadams@google.com,
        alexandre.chartre@oracle.com
Subject: [RFC KVM 20/27] kvm/isolation: initialize the KVM page table with vmx specific data
Date:   Mon, 13 May 2019 16:38:28 +0200
Message-Id: <1557758315-12667-21-git-send-email-alexandre.chartre@oracle.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1557758315-12667-1-git-send-email-alexandre.chartre@oracle.com>
References: <1557758315-12667-1-git-send-email-alexandre.chartre@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9255 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1905130103
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In addition of core memory mappings, the KVM page table has to be
initialized with vmx specific data.

Signed-off-by: Alexandre Chartre <alexandre.chartre@oracle.com>
---
 arch/x86/kvm/vmx/vmx.c |   19 +++++++++++++++++++
 1 files changed, 19 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 0c955bb..f181b3c 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -63,6 +63,7 @@
 #include "vmcs12.h"
 #include "vmx.h"
 #include "x86.h"
+#include "isolation.h"
 
 MODULE_AUTHOR("Qumranet");
 MODULE_LICENSE("GPL");
@@ -7830,6 +7831,24 @@ static int __init vmx_init(void)
 		}
 	}
 
+	if (kvm_isolation()) {
+		pr_debug("mapping vmx init");
+		/* copy mapping of the current module (kvm_intel) */
+		r = kvm_copy_module_mapping();
+		if (r) {
+			vmx_exit();
+			return r;
+		}
+		if (vmx_l1d_flush_pages) {
+			r = kvm_copy_ptes(vmx_l1d_flush_pages,
+					  PAGE_SIZE << L1D_CACHE_ORDER);
+			if (r) {
+				vmx_exit();
+				return r;
+			}
+		}
+	}
+
 #ifdef CONFIG_KEXEC_CORE
 	rcu_assign_pointer(crash_vmclear_loaded_vmcss,
 			   crash_vmclear_local_loaded_vmcss);
-- 
1.7.1

