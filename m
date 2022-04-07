Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03EED4F8869
	for <lists+kvm@lfdr.de>; Thu,  7 Apr 2022 22:33:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229789AbiDGUdg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Apr 2022 16:33:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229937AbiDGUdW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Apr 2022 16:33:22 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07F7E320DB8
        for <kvm@vger.kernel.org>; Thu,  7 Apr 2022 13:18:42 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id g14-20020a17090a4b0e00b001cb1363ae99so1609883pjh.1
        for <kvm@vger.kernel.org>; Thu, 07 Apr 2022 13:18:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=Ku8/xhQuY+DnaUKfaV/zzEU2U1z2wt3bXsnqQqFqkqc=;
        b=M3ZS8Aiq4mZdEltM4TPvQxBlNDtZ5ARAyG4HJSf7KbrTU9eEooYFvgfOobSIGlllyi
         CE02YilAIANO7ovsSumaS3UAoN/fZBTfzlEOZIaX/CXkYe74UAH5vZzcrGwRIFwwALCq
         DZC4F6uzVaWWgV8M6b2y1Noxmjm1vFrdoNbqzkXUwV29S0QFkbL2NL4Klv0EZvKVXpAd
         UwgqmZwO5sKsSv8HpkhpLuUG0Qi2YVssaT0issL/qLqJuYMvUb3HPtOTLXh0UxS9HdOi
         B9OyKC3dQ9xz7PUO9RmbRRvA9WqciG8SdgAksytDfEgdDCmFhyBSrWT1uGXykoWyhlIw
         Dp/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=Ku8/xhQuY+DnaUKfaV/zzEU2U1z2wt3bXsnqQqFqkqc=;
        b=3xrFHaA67ARNaCBC7h6BKhi52tHoEQhpp7tS94yqnOorAgl8Hk/Xqv6JpVeDLe7g4p
         YHFoQnWrZ3SE4HmwiuaEeVOslIbmNmUgfX7iIVhaFvDtI6EzPx7yBiuU7jBdcPbPoqgQ
         iBvJRdIDhH+ZSlFm3RNUYQ6tDezBTWYS3wU5gWtTaHTS2SZbY2PuD+ClcJPv3i+92Pbm
         eI8ZVf+q5D4kLDVv9AR7aUHrg9YnYvcdKtlFYz6JsMlsE24xXS4Xz/zX68+A9w7AEyB7
         ffFAy72VgUmrodeWWLJM5xulBskGPJL8HYa08km9PsHt6DUaxg6dQrCFFx+xIXiYpMCp
         ut7A==
X-Gm-Message-State: AOAM531GffUzut7Z8U2On9/17RrSfWFrSd6Xc3eEa632J+y+ZHgqdYGs
        h6navCneJs/znDEgyJPcOfpCPLKeq6BDzjBMamdQPyuHFa6RrKDBOhZh07Gr3LoyieXoROaP9ac
        WO4pO/JXeeeu+IrHirshkgkOukpEqSSmaPdlNLJAeQeQXsOPCxONgLGeJEg==
X-Google-Smtp-Source: ABdhPJzMbjER7HNgCRI9nhUzY8Uo13WQPhIvuQ+NCrB4gGoHKtJ31PXyU9pKTuZK5BX9ao19iY2kTP87Lrg=
X-Received: from pgonda1.kir.corp.google.com ([2620:15c:29:203:469d:83b1:de7b:c47f])
 (user=pgonda job=sendgmr) by 2002:a17:903:1251:b0:156:9d8e:1077 with SMTP id
 u17-20020a170903125100b001569d8e1077mr15375452plh.116.1649362721388; Thu, 07
 Apr 2022 13:18:41 -0700 (PDT)
Date:   Thu,  7 Apr 2022 13:18:38 -0700
Message-Id: <20220407201838.715024-1-pgonda@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.35.1.1178.g4f1659d476-goog
Subject: [PATCH v4] KVM, SEV: Add KVM_EXIT_SHUTDOWN metadata for SEV-ES
From:   Peter Gonda <pgonda@google.com>
To:     kvm@vger.kernel.org
Cc:     Peter Gonda <pgonda@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED,
        USER_IN_DEF_DKIM_WL autolearn=unavailable autolearn_force=no
        version=3.4.6
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

Suggested-by: Sean Christopherson <seanjc@google.com>
Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Peter Gonda <pgonda@google.com>

---
V4
 * Updated to Sean and Paolo's suggestion of reworking the
   kvm_run.system_event struct to ndata and data fields to fix the
   padding.

V3
 * Add Documentation/ update.
 * Updated other KVM_EXIT_SHUTDOWN exits to clear ndata and set reason
   to KVM_SHUTDOWN_REQ.

V2
 * Add KVM_CAP_EXIT_SHUTDOWN_REASON check for KVM_CHECK_EXTENSION.

Tested by making an SEV-ES guest call sev_es_terminate() with hardcoded
reason code set and reason code and then observing the codes from the
userspace VMM in the kvm_run.shutdown.data fields.

---
 arch/x86/kvm/svm/sev.c   | 9 +++++++--
 include/uapi/linux/kvm.h | 5 ++++-
 2 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 75fa6dd268f0..1a080f3f09d8 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -2735,8 +2735,13 @@ static int sev_handle_vmgexit_msr_protocol(struct vcpu_svm *svm)
 		pr_info("SEV-ES guest requested termination: %#llx:%#llx\n",
 			reason_set, reason_code);
 
-		ret = -EINVAL;
-		break;
+		vcpu->run->exit_reason = KVM_EXIT_SYSTEM_EVENT;
+		vcpu->run->system_event.type = KVM_SYSTEM_EVENT_SEV_TERM |
+					       KVM_SYSTEM_EVENT_NDATA_VALID;
+		vcpu->run->system_event.ndata = 1;
+		vcpu->run->system_event.data[1] = control->ghcb_gpa;
+
+		return 0;
 	}
 	default:
 		/* Error, keep GHCB MSR value as-is */
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 8616af85dc5d..dd1d8167e71f 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -444,8 +444,11 @@ struct kvm_run {
 #define KVM_SYSTEM_EVENT_SHUTDOWN       1
 #define KVM_SYSTEM_EVENT_RESET          2
 #define KVM_SYSTEM_EVENT_CRASH          3
+#define KVM_SYSTEM_EVENT_SEV_TERM       4
+#define KVM_SYSTEM_EVENT_NDATA_VALID    (1u << 31)
 			__u32 type;
-			__u64 flags;
+			__u32 ndata;
+			__u64 data[16];
 		} system_event;
 		/* KVM_EXIT_S390_STSI */
 		struct {
-- 
2.35.1.1178.g4f1659d476-goog

