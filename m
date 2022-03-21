Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D36834E2B69
	for <lists+kvm@lfdr.de>; Mon, 21 Mar 2022 16:02:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349763AbiCUPDp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Mar 2022 11:03:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349756AbiCUPDn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Mar 2022 11:03:43 -0400
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0ABF45C349
        for <kvm@vger.kernel.org>; Mon, 21 Mar 2022 08:02:18 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id 77-20020a621450000000b004fa8868a49eso3350992pfu.3
        for <kvm@vger.kernel.org>; Mon, 21 Mar 2022 08:02:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=7qxY5R4b4k3tZIlP/A/FDGNN142+VI1rVlCy2DOCwi0=;
        b=nC46NUSEFVQbOeDk6LfOyhS40oaJ2zPSxyh0pGmiY9ES2hb+V/UH15eh6ZaYsitZd3
         a4Cj1IZDWfD0Tn+NEfBoMz8Z/Ji1Uz/kkj5U3a4XCZGxYPreJLOAz1qz6+ifam2Thay3
         DLvopEw1LTvoFncjzixRSB45p+8BCSc60lEP6wdL+hHgyw7uH/0gToixw9cvzxYrdT1g
         B/5QVa31BXXKsH43r3Cug2AGvZtRdIOESnSF6nYridvRB8A2/5IxgDlQg+/nN9iN1O56
         ptQJE8EwFMLAi0oX0FqY/bf1/NrR98yHRqDM1EaWASTLAbc+e3eG+9wIL8nYTk0fcO0q
         XCPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=7qxY5R4b4k3tZIlP/A/FDGNN142+VI1rVlCy2DOCwi0=;
        b=VWOpy34YW5DffkLGlYp48YNklLxONZzdjTrj586Ouq86li1Lz2nu9VbtYVKepesxLC
         N3QPDr6HVO1oKiUxfbbuxr6g5cipf5MoaCMG/H7vcJahda1khllFcoA6+1ydgVdywJso
         kJx/LZ2wgl+liPios/QPU6lS0A1H4bR5bp1OzH/H91curIKiWErrUNciGbBNHtWAghCb
         LMMKpoWrJ3kTcomJnNSXte1dU48yhg5rQHTPyOkEhgfUWm5jDF720m2pc0cK4/GwRuQf
         Xfdp+/f/3IJsE1xqfbRyS4HCAHtTo0gr8+bVxj3DsV27hIkvCoXzFhsQmqurXZqcoq4A
         +ONw==
X-Gm-Message-State: AOAM531ySbMEVALcunUDc6j1BM65oy6HaMGI2AmLrwimWtCsy9mj0zHy
        5yfcWOHINGQIlwyxVaxqB0cehpDJV15xWVvd+ko+sjeD2EWlhZtoKnU9aoHdi1IgPKtoDU5kyRC
        LgmyGhHAThv/MC0awTZ9g3rWysNxj7TJN9wWaBhubFrK7EOK2eOe17EwGbA==
X-Google-Smtp-Source: ABdhPJw5HrqT+acz2IEXJQLkk1uQOBVBLwD5RCVwc17uWxphkqjuN7JbiWkcphBM/5381aZBpBbMk/wALfY=
X-Received: from pgonda1.kir.corp.google.com ([2620:15c:29:203:dc6f:6bfe:c575:7dd])
 (user=pgonda job=sendgmr) by 2002:a17:903:2285:b0:154:c94:c5b7 with SMTP id
 b5-20020a170903228500b001540c94c5b7mr13543882plh.64.1647874937331; Mon, 21
 Mar 2022 08:02:17 -0700 (PDT)
Date:   Mon, 21 Mar 2022 08:02:14 -0700
Message-Id: <20220321150214.1895231-1-pgonda@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.35.1.894.gb6a874cedc-goog
Subject: [PATCH] Add KVM_EXIT_SHUTDOWN metadata for SEV-ES
From:   Peter Gonda <pgonda@google.com>
To:     kvm@vger.kernel.org
Cc:     Peter Gonda <pgonda@google.com>, Borislav Petkov <bp@alien8.de>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Joerg Roedel <jroedel@suse.de>, Marc Orr <marcorr@google.com>,
        Sean Christopherson <seanjc@google.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

SEV-ES guests can request termination using the GHCB's MSR protocol. See
AMD's GHCB spec section '4.1.13 Termination Request'. Currently when a
guest does this the userspace VMM sees an KVM_EXIT_UNKNOWN (-EVINAL)
return code from KVM_RUN. By adding a KVM_EXIT_SHUTDOWN_ENTRY to kvm_run
struct the userspace VMM can clearly see the guest has requested a SEV-ES
termination including the termination reason code set and reason code.

Signed-off-by: Peter Gonda <pgonda@google.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Cc: Brijesh Singh <brijesh.singh@amd.com>
Cc: Joerg Roedel <jroedel@suse.de>
Cc: Marc Orr <marcorr@google.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org

---

Tested by making an SEV-ES guest call sev_es_terminate() with hardcoded
reason code set and reason code and then observing the codes from the
userspace VMM in the kvm_run.shutdown.data fields.

---
 arch/x86/kvm/svm/sev.c   |  9 +++++++--
 include/uapi/linux/kvm.h | 12 ++++++++++++
 2 files changed, 19 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 75fa6dd268f0..5f9d37dd3f6f 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -2735,8 +2735,13 @@ static int sev_handle_vmgexit_msr_protocol(struct vcpu_svm *svm)
 		pr_info("SEV-ES guest requested termination: %#llx:%#llx\n",
 			reason_set, reason_code);
 
-		ret = -EINVAL;
-		break;
+		vcpu->run->exit_reason = KVM_EXIT_SHUTDOWN;
+		vcpu->run->shutdown.reason = KVM_SHUTDOWN_SEV_TERM;
+		vcpu->run->shutdown.ndata = 2;
+		vcpu->run->shutdown.data[0] = reason_set;
+		vcpu->run->shutdown.data[1] = reason_code;
+
+		return 0;
 	}
 	default:
 		/* Error, keep GHCB MSR value as-is */
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 8616af85dc5d..12138b8f290c 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -271,6 +271,12 @@ struct kvm_xen_exit {
 #define KVM_EXIT_XEN              34
 #define KVM_EXIT_RISCV_SBI        35
 
+/* For KVM_EXIT_SHUTDOWN */
+/* Standard VM shutdown request. No additional metadata provided. */
+#define KVM_SHUTDOWN_REQ	0
+/* SEV-ES termination request */
+#define KVM_SHUTDOWN_SEV_TERM	1
+
 /* For KVM_EXIT_INTERNAL_ERROR */
 /* Emulate instruction failed. */
 #define KVM_INTERNAL_ERROR_EMULATION	1
@@ -311,6 +317,12 @@ struct kvm_run {
 		struct {
 			__u64 hardware_exit_reason;
 		} hw;
+		/* KVM_EXIT_SHUTDOWN_ENTRY */
+		struct {
+			__u64 reason;
+			__u32 ndata;
+			__u64 data[16];
+		} shutdown;
 		/* KVM_EXIT_FAIL_ENTRY */
 		struct {
 			__u64 hardware_entry_failure_reason;
-- 
2.35.1.894.gb6a874cedc-goog

