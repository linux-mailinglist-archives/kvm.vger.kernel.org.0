Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7E587B6576
	for <lists+kvm@lfdr.de>; Tue,  3 Oct 2023 11:28:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239596AbjJCJ2r (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Oct 2023 05:28:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231199AbjJCJ2n (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Oct 2023 05:28:43 -0400
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id DD710AB;
        Tue,  3 Oct 2023 02:28:40 -0700 (PDT)
Received: from jinank-dev.tail216e5.ts.net (unknown [40.90.178.231])
        by linux.microsoft.com (Postfix) with ESMTPSA id A8F1E20B74C0;
        Tue,  3 Oct 2023 02:28:37 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com A8F1E20B74C0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1696325320;
        bh=gZ9ywJ91S296Vc3gZYVJDfc5JwL0EbNgI9h5fuzeoMs=;
        h=From:To:Cc:Subject:Date:From;
        b=XZIQSHKJ2GJcqrskFeoitJoIRQDbTmhtbG9GUNbxq44Yg1LPDmOtDXK9ydOXjYJYy
         uHK6MTVlQyvK7DsnrN8keJnCFnNJF9tF5bPBZyq2lREo7WGQBhw40/w2LSRY6zJMgX
         Ycuxp7hz8fS9ZlGJr3wcfca7pvPhsm8rvdYXvi8o=
From:   Jinank Jain <jinankjain@linux.microsoft.com>
To:     seanjc@google.com, pbonzini@redhat.com, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, hpa@zytor.com, jinankjain@microsoft.com,
        thomas.lendacky@amd.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     wei.liu@kernel.org, tiala@microsoft.com
Subject: [PATCH] arch/x86: Set XSS while handling #VC intercept for CPUID
Date:   Tue,  3 Oct 2023 09:28:35 +0000
Message-Id: <20231003092835.18974-1-jinankjain@linux.microsoft.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-17.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_PASS,SPF_PASS,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

According to [1], while handling the #VC intercept for CPUID leaf
0x0000_000D, we need to supply the value of XSS in the GHCB page. If
this value is not provided then a spec compliant hypervisor can fail the
GHCB request and kill the guest.

[1] https://www.amd.com/system/files/TechDocs/56421-guest-hypervisor-communication-block-standardization.pdf

Signed-off-by: Jinank Jain <jinankjain@linux.microsoft.com>
---
 arch/x86/include/asm/svm.h   | 1 +
 arch/x86/kernel/sev-shared.c | 3 +++
 2 files changed, 4 insertions(+)

diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
index 19bf955b67e0..c2f670f7cb47 100644
--- a/arch/x86/include/asm/svm.h
+++ b/arch/x86/include/asm/svm.h
@@ -678,5 +678,6 @@ DEFINE_GHCB_ACCESSORS(sw_exit_info_1)
 DEFINE_GHCB_ACCESSORS(sw_exit_info_2)
 DEFINE_GHCB_ACCESSORS(sw_scratch)
 DEFINE_GHCB_ACCESSORS(xcr0)
+DEFINE_GHCB_ACCESSORS(xss)
 
 #endif
diff --git a/arch/x86/kernel/sev-shared.c b/arch/x86/kernel/sev-shared.c
index 2eabccde94fb..92350a24848c 100644
--- a/arch/x86/kernel/sev-shared.c
+++ b/arch/x86/kernel/sev-shared.c
@@ -880,6 +880,9 @@ static enum es_result vc_handle_cpuid(struct ghcb *ghcb,
 	if (snp_cpuid_ret != -EOPNOTSUPP)
 		return ES_VMM_ERROR;
 
+	if (regs->ax == 0xD && regs->cx == 0x1)
+		ghcb_set_xss(ghcb, 0);
+
 	ghcb_set_rax(ghcb, regs->ax);
 	ghcb_set_rcx(ghcb, regs->cx);
 
-- 
2.34.1

