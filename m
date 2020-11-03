Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C906D2A44CA
	for <lists+kvm@lfdr.de>; Tue,  3 Nov 2020 13:07:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728915AbgKCMHz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Nov 2020 07:07:55 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:46802 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728146AbgKCMHz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Nov 2020 07:07:55 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0A3BxhkK075803;
        Tue, 3 Nov 2020 12:06:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding;
 s=corp-2020-01-29; bh=h9MFns4+YUM2WrMN1n/hdiPQQ9AmvoWKTdDk9TUNovM=;
 b=aLc618jUYvkIpc6amrRH57re+QonILrYfcHUpV7rkyFlfV9Usuo2GTt6h4OAhUJwXd5K
 81YnIXqlWBuCRrx6lGKPGXrhsZSIwWuvpsqJraedawh7s4AqMk6+XtqL3L57Yl0KErhE
 Xkx4hAi10CU1EZyloP+wwBjb3/oFTiiNMj4voujIa53reKmheIhH1nleLuYYfNwh6cy+
 PdOnVfTrE2GjxSZuV97+KixDqPEsJ5mn1e+VWHYN7jn8GDShkTn5NFRazsAg3/BXcOQo
 XQhzo7aLG3ctjQCBrRd+Dx9w/CQwtMHEdXA20zJ/ACt3TmKjjHs2TpomqAOGxZgVSqJq 1g== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 34hhvc8ves-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 03 Nov 2020 12:06:11 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0A3C0fGM156489;
        Tue, 3 Nov 2020 12:04:11 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 34hw0df56d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 03 Nov 2020 12:04:11 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0A3C459J030210;
        Tue, 3 Nov 2020 12:04:05 GMT
Received: from disaster-area.hh.sledj.net (/81.187.26.238)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 03 Nov 2020 04:04:05 -0800
Received: from localhost (disaster-area.hh.sledj.net [local])
        by disaster-area.hh.sledj.net (OpenSMTPD) with ESMTPA id 82f746cd;
        Tue, 3 Nov 2020 12:04:00 +0000 (UTC)
From:   David Edmondson <david.edmondson@oracle.com>
To:     linux-kernel@vger.kernel.org
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Nadav Amit <namit@cs.technion.ac.il>, x86@kernel.org,
        Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>,
        David Edmondson <david.edmondson@oracle.com>
Subject: [PATCH] KVM: x86: clflushopt should be treated as a no-op by emulation
Date:   Tue,  3 Nov 2020 12:04:00 +0000
Message-Id: <20201103120400.240882-1-david.edmondson@oracle.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9793 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 mlxlogscore=906
 phishscore=0 bulkscore=0 spamscore=0 malwarescore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011030083
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9793 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=1
 impostorscore=0 malwarescore=0 priorityscore=1501 mlxlogscore=933
 bulkscore=0 phishscore=0 adultscore=0 mlxscore=0 lowpriorityscore=0
 clxscore=1011 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011030083
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The instruction emulator ignores clflush instructions, yet fails to
support clflushopt. Treat both similarly.

Fixes: 13e457e0eebf ("KVM: x86: Emulator does not decode clflush well")
Signed-off-by: David Edmondson <david.edmondson@oracle.com>
---
 arch/x86/kvm/emulate.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index 0d917eb70319..56cae1ff9e3f 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -4046,6 +4046,12 @@ static int em_clflush(struct x86_emulate_ctxt *ctxt)
 	return X86EMUL_CONTINUE;
 }
 
+static int em_clflushopt(struct x86_emulate_ctxt *ctxt)
+{
+	/* emulating clflushopt regardless of cpuid */
+	return X86EMUL_CONTINUE;
+}
+
 static int em_movsxd(struct x86_emulate_ctxt *ctxt)
 {
 	ctxt->dst.val = (s32) ctxt->src.val;
@@ -4585,7 +4591,7 @@ static const struct opcode group11[] = {
 };
 
 static const struct gprefix pfx_0f_ae_7 = {
-	I(SrcMem | ByteOp, em_clflush), N, N, N,
+	I(SrcMem | ByteOp, em_clflush), I(SrcMem | ByteOp, em_clflushopt), N, N,
 };
 
 static const struct group_dual group15 = { {
-- 
2.28.0

