Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1DE674F49AF
	for <lists+kvm@lfdr.de>; Wed,  6 Apr 2022 02:29:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1443979AbiDEWUv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Apr 2022 18:20:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1573262AbiDEShI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 Apr 2022 14:37:08 -0400
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE63817049
        for <kvm@vger.kernel.org>; Tue,  5 Apr 2022 11:35:09 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id x68-20020a623147000000b004fd8d1ed04cso101386pfx.23
        for <kvm@vger.kernel.org>; Tue, 05 Apr 2022 11:35:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=K74uTYo0p50+68Eav5hPTlnLwyyYs0SvA0+aQKwvrcM=;
        b=KQEqtHlUIrCMPDEZNKiPS9MvgfELfDBKde+wsTIq1ryHFf4ypzTaT5ALjkqm0JVA/K
         97yK54GjAMf/hbNvHEfcLoErQsv6rPoLKHy2OA9GpDLManJ08OL6cBliH1pE8PSbtm7x
         Egplaa+kzgODwKtSCsT31nZ0UmtGrh8hUA9msDIyH4k5N+aHpal+4rr8KrD7SYUpXE3m
         nBRZDzeYOKQosGLkqviomA/pOiSPf+ru1BtqjlgFBULpSQyd2phEdgIk9HV/Y5NxCLe8
         iqooldC/WoJSZZ1Savcf5GCUvvf+FBFSipfwHPk+DR5bRvXG/cGwBk20mzlgOlgGncf3
         D7Mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=K74uTYo0p50+68Eav5hPTlnLwyyYs0SvA0+aQKwvrcM=;
        b=uGnGaFMcM9gTQr9FlTz7KmXCzLQ3MU52lyvwkOG/ZQpNEZCUfAyOD9zRKG8LtD+j49
         iGHmSsi/CL3tnCvgphbL6QczpzfZwANghaGdVUHcfOC0jkxyRse1J1kPljU9EoPlqEM7
         abXkd9fZFn3HiRnmNU3KhisIbDOc9gu3hZZe4EfAZM4wfzUm3M9u535KZShe3SQWsYxc
         bbsOHwWBhRU3ZpD1PNYzA0VLp8TtkO8xoN1ATjTq85tDSHHBg+Ss4wwpdGCHRDU+Jgs5
         dWwHHoxNKVpfr7V2E4A8V3YbOZK5nCWaX9oO1Q2d3Q3zw/WG9kC5XqTgSVNl15EM+qXY
         Tl9Q==
X-Gm-Message-State: AOAM531OhEkV3DunYVFiRX4suWAPfG+E//WOjXQrpqldZtLcGTANuNTU
        AAADP91dY87lUL2FbYKu7BZkIkfMh+RDmcxoHZV4Qzgw54afpBB4E7hLuQaRcfX483LM398LMLq
        G2DSXRvnblWcBkyDCNeCc+8VjBRco74P0Z6YNVa+vuRbqys30X3PPrK+1kQ==
X-Google-Smtp-Source: ABdhPJwWLVGLr/vHL4lq1ATs4OZuBgElqxvfAYIpOrbOfXGyZoR0O+W+IABkWZEAFyqxM0aqFqnkdt8jf2k=
X-Received: from pgonda1.kir.corp.google.com ([2620:15c:29:203:9f5c:353e:771c:7686])
 (user=pgonda job=sendgmr) by 2002:a17:902:e545:b0:154:4d5b:2006 with SMTP id
 n5-20020a170902e54500b001544d5b2006mr4889343plf.94.1649183709169; Tue, 05 Apr
 2022 11:35:09 -0700 (PDT)
Date:   Tue,  5 Apr 2022 11:35:06 -0700
Message-Id: <20220405183506.2138403-1-pgonda@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.35.1.1094.g7c7d902a7c-goog
Subject: [PATCH V4] KVM, SEV: Add KVM_EXIT_SYSTEM_EVENT metadata for SEV-ES
From:   Peter Gonda <pgonda@google.com>
To:     kvm@vger.kernel.org
Cc:     Peter Gonda <pgonda@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Joerg Roedel <jroedel@suse.de>, Marc Orr <marcorr@google.com>,
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
return code from KVM_RUN. By adding a KVM_EXIT_SYSTEM_EVENT to kvm_run
struct the userspace VMM can clearly see the guest has requested a SEV-ES
termination including the termination reason code set and reason code.

Signed-off-by: Peter Gonda <pgonda@google.com>
Suggested-by: Sean Christopherson <seanjc@google.com>
Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Cc: Brijesh Singh <brijesh.singh@amd.com>
Cc: Joerg Roedel <jroedel@suse.de>
Cc: Marc Orr <marcorr@google.com>
Cc: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org

---

V4
 * Switch to using KVM_SYSTEM_EVENT exit reason.

V3
 * Add Documentation/ update.
 * Updated other KVM_EXIT_SHUTDOWN exits to clear ndata and set reason
   to KVM_SHUTDOWN_REQ.

V2
 * Add KVM_CAP_EXIT_SHUTDOWN_REASON check for KVM_CHECK_EXTENSION.

Tested by making an SEV-ES guest call sev_es_terminate() with hardcoded
reason code set and reason code and then observing the codes from the
userspace VMM in the kvm_run.system_event fields.

---
 arch/x86/kvm/svm/sev.c   | 7 +++++--
 include/uapi/linux/kvm.h | 1 +
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 75fa6dd268f0..039b241a9fb5 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -2735,8 +2735,11 @@ static int sev_handle_vmgexit_msr_protocol(struct vcpu_svm *svm)
 		pr_info("SEV-ES guest requested termination: %#llx:%#llx\n",
 			reason_set, reason_code);
 
-		ret = -EINVAL;
-		break;
+		vcpu->run->exit_reason = KVM_EXIT_SHUTDOWN;
+		vcpu->run->system_event.type = KVM_SYSTEM_EVENT_SEV_TERM;
+		vcpu->run->system_event.flags = control->ghcb_gpa;
+
+		return 0;
 	}
 	default:
 		/* Error, keep GHCB MSR value as-is */
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 8616af85dc5d..d9d24db12930 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -444,6 +444,7 @@ struct kvm_run {
 #define KVM_SYSTEM_EVENT_SHUTDOWN       1
 #define KVM_SYSTEM_EVENT_RESET          2
 #define KVM_SYSTEM_EVENT_CRASH          3
+#define KVM_SYSTEM_EVENT_SEV_TERM       4
 			__u32 type;
 			__u64 flags;
 		} system_event;
-- 
2.35.1.1094.g7c7d902a7c-goog

