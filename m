Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 343F6696ACC
	for <lists+kvm@lfdr.de>; Tue, 14 Feb 2023 18:07:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232334AbjBNRHW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Feb 2023 12:07:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232108AbjBNRHR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Feb 2023 12:07:17 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 461D62A9A8
        for <kvm@vger.kernel.org>; Tue, 14 Feb 2023 09:06:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1676394380;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uesXxXN/dT64YF2ezxYCV9U/lKwcw+rA6wj9DkAfaxY=;
        b=WLTH5z5F/bCAU1t69KUB4taab3WzimEyh0xycfra3LjTo77FOyO7hzqHWslsbwaz76iBMD
        NYto2gCNrOe8Z5bPN2R9qnJM9Z4GOgVHQ30wqYmmI7H/Hoe4NiR8ydqVI3+w9PFs5l+GNo
        3AydHN+sDA6sKQFWMNwXeS4gd3as8Ww=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-437-YFHjxPmpPNi2nT_UIMlLHw-1; Tue, 14 Feb 2023 12:06:17 -0500
X-MC-Unique: YFHjxPmpPNi2nT_UIMlLHw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 64A943C16E8E;
        Tue, 14 Feb 2023 17:06:16 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 42D7CC15BA0;
        Tue, 14 Feb 2023 17:06:16 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     thomas.lendacky@amd.com, Borislav Petkov <bp@alien8.de>
Subject: [PATCH 1/3] x86/speculation: Identify processors vulnerable to SMT RSB predictions
Date:   Tue, 14 Feb 2023 12:06:13 -0500
Message-Id: <20230214170615.1297202-2-pbonzini@redhat.com>
In-Reply-To: <20230214170615.1297202-1-pbonzini@redhat.com>
References: <20230214170615.1297202-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Tom Lendacky <thomas.lendacky@amd.com>

Certain AMD processors are vulnerable to a cross-thread return address
predictions bug. When running in SMT mode and one of the sibling threads
transitions out of C0 state, the other sibling thread could use return
target predictions from the sibling thread that transitioned out of C0.

The Spectre v2 mitigations cover the Linux kernel, as it fills the RSB
when context switching to the idle thread. However, KVM allows a VMM to
prevent exiting guest mode when transitioning out of C0. A guest could
act maliciously in this situation, so create a new x86 BUG that can be
used to detect if the processor is vulnerable.

Reviewed-by: Borislav Petkov (AMD) <bp@alien8.de>
Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
Message-Id: <91cec885656ca1fcd4f0185ce403a53dd9edecb7.1675956146.git.thomas.lendacky@amd.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/include/asm/cpufeatures.h | 1 +
 arch/x86/kernel/cpu/common.c       | 9 +++++++--
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
index 61012476d66e..8f39c46197b8 100644
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -466,5 +466,6 @@
 #define X86_BUG_MMIO_UNKNOWN		X86_BUG(26) /* CPU is too old and its MMIO Stale Data status is unknown */
 #define X86_BUG_RETBLEED		X86_BUG(27) /* CPU is affected by RETBleed */
 #define X86_BUG_EIBRS_PBRSB		X86_BUG(28) /* EIBRS is vulnerable to Post Barrier RSB Predictions */
+#define X86_BUG_SMT_RSB			X86_BUG(29) /* CPU is vulnerable to Cross-Thread Return Address Predictions */
 
 #endif /* _ASM_X86_CPUFEATURES_H */
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 9cfca3d7d0e2..f3cc7699e1e1 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -1256,6 +1256,8 @@ static const __initconst struct x86_cpu_id cpu_vuln_whitelist[] = {
 #define MMIO_SBDS	BIT(2)
 /* CPU is affected by RETbleed, speculating where you would not expect it */
 #define RETBLEED	BIT(3)
+/* CPU is affected by SMT (cross-thread) return predictions */
+#define SMT_RSB		BIT(4)
 
 static const struct x86_cpu_id cpu_vuln_blacklist[] __initconst = {
 	VULNBL_INTEL_STEPPINGS(IVYBRIDGE,	X86_STEPPING_ANY,		SRBDS),
@@ -1287,8 +1289,8 @@ static const struct x86_cpu_id cpu_vuln_blacklist[] __initconst = {
 
 	VULNBL_AMD(0x15, RETBLEED),
 	VULNBL_AMD(0x16, RETBLEED),
-	VULNBL_AMD(0x17, RETBLEED),
-	VULNBL_HYGON(0x18, RETBLEED),
+	VULNBL_AMD(0x17, RETBLEED | SMT_RSB),
+	VULNBL_HYGON(0x18, RETBLEED | SMT_RSB),
 	{}
 };
 
@@ -1406,6 +1408,9 @@ static void __init cpu_set_bug_bits(struct cpuinfo_x86 *c)
 	    !(ia32_cap & ARCH_CAP_PBRSB_NO))
 		setup_force_cpu_bug(X86_BUG_EIBRS_PBRSB);
 
+	if (cpu_matches(cpu_vuln_blacklist, SMT_RSB))
+		setup_force_cpu_bug(X86_BUG_SMT_RSB);
+
 	if (cpu_matches(cpu_vuln_whitelist, NO_MELTDOWN))
 		return;
 
-- 
2.39.1


