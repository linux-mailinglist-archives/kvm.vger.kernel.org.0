Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B17726E75F
	for <lists+kvm@lfdr.de>; Thu, 17 Sep 2020 23:25:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726252AbgIQVZV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Sep 2020 17:25:21 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:33482 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726245AbgIQVZU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Sep 2020 17:25:20 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08HLF5VN012576;
        Thu, 17 Sep 2020 21:22:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=4A2NgPr0lNAqN2KX+a6SQbPtGt796V8wB46BXwl0c1g=;
 b=kpZurblBgqbsMoWgFKbQmSwZpXgHV+uwzRnNQMZRmZhY+803+b/45gFe27KS07tOGAUz
 bg0+nX7ZirJHcpvS1hpcRGSctCcllD4radLned8y8DAtAwdsPYS6gd4xbPQKOSrYxZya
 CDTW2fhrVnJuCvG3N8YlchjvtV2JhSD+ulQl9wIXTSmjngONzWIAZ7Din1HswrPc7gm/
 iSkoVjzN4mbFQNymOoqMo3FpMJWztkMu34qC7EcoynZAu9cuuuYNjvcC5nvdUQzgzGHf
 LwDBINeOZhMi3pKcAEA2n8H1Ck3WfVNdsWPFvP67zW+hlWFetLQ7afT5TJLdCLSup4d9 iA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 33gp9mku7h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 17 Sep 2020 21:22:33 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08HLAnfn018898;
        Thu, 17 Sep 2020 21:22:32 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 33mega3vn9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 17 Sep 2020 21:22:32 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 08HLMReF010132;
        Thu, 17 Sep 2020 21:22:27 GMT
Received: from nsvm-sadhukhan-1.osdevelopmeniad.oraclevcn.com (/100.100.230.216)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 17 Sep 2020 21:22:27 +0000
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, x86@kernel.org,
        sean.j.christopherson@intel.com, vkuznets@redhat.com,
        wanpengli@tencent.com, joro@8bytes.org,
        dave.hansen@linux.intel.com, luto@kernel.org, peterz@infradead.org,
        linux-kernel@vger.kernel.org, hpa@zytor.com
Subject: [PATCH 2/3 v4] x86: AMD: Don't flush cache if hardware enforces cache coherency across encryption domnains
Date:   Thu, 17 Sep 2020 21:20:37 +0000
Message-Id: <20200917212038.5090-3-krish.sadhukhan@oracle.com>
X-Mailer: git-send-email 2.18.4
In-Reply-To: <20200917212038.5090-1-krish.sadhukhan@oracle.com>
References: <20200917212038.5090-1-krish.sadhukhan@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9747 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 mlxscore=0 spamscore=0
 mlxlogscore=983 adultscore=0 bulkscore=0 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009170158
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9747 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=998
 adultscore=0 malwarescore=0 clxscore=1015 lowpriorityscore=0 phishscore=0
 spamscore=0 priorityscore=1501 suspectscore=1 impostorscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009170158
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In some hardware implementations, coherency between the encrypted and
unencrypted mappings of the same physical page is enforced. In such a system,
it is not required for software to flush the page from all CPU caches in the
system prior to changing the value of the C-bit for the page.

Suggested-by: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
---
 arch/x86/mm/pat/set_memory.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/mm/pat/set_memory.c b/arch/x86/mm/pat/set_memory.c
index d1b2a889f035..40baa90e74f4 100644
--- a/arch/x86/mm/pat/set_memory.c
+++ b/arch/x86/mm/pat/set_memory.c
@@ -1999,7 +1999,7 @@ static int __set_memory_enc_dec(unsigned long addr, int numpages, bool enc)
 	/*
 	 * Before changing the encryption attribute, we need to flush caches.
 	 */
-	cpa_flush(&cpa, 1);
+	cpa_flush(&cpa, !this_cpu_has(X86_FEATURE_SME_COHERENT));
 
 	ret = __change_page_attr_set_clr(&cpa, 1);
 
-- 
2.18.4

