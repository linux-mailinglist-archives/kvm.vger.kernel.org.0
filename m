Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 83AF04F89A2
	for <lists+kvm@lfdr.de>; Fri,  8 Apr 2022 00:14:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230336AbiDGVEk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Apr 2022 17:04:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230437AbiDGVEh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Apr 2022 17:04:37 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8C1816E208
        for <kvm@vger.kernel.org>; Thu,  7 Apr 2022 14:02:36 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id bv2-20020a17090af18200b001c63c69a774so3595833pjb.0
        for <kvm@vger.kernel.org>; Thu, 07 Apr 2022 14:02:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=4QE36tLivJMOr8j5gSWfIuNJsPy+ywKzgj6NE2BrPcs=;
        b=Vg1IZkAU7wouNoj01H35jjVuZKodtI9CgCVnOlD9/W9/NmOS39Dx7B1M4flvPDdDhF
         nwYJZYQxf/9zjy0PvRkkonQlAFzixVnAmSTnaumBsjn+5NBdUQxN2qM5h83dmQycxaGA
         rke08AspJx9Uvhp7fxRGNncz5IHB/DsFvwM9gYyFsD+qlDr/oeyyEYNcKG2HO3tSc0YP
         Ps4pDdzLDBlsSCtuAt0gUt/Fdy/vmCgcNEdFfjU6Jc0ZQkpsxiCE/IrHc+IDF/MAVW6R
         LKyhsF5z/Q6RLXQcGWEN4LrKDcxvhRENuLGh5x9V3/2/mSK4bgjQd8lxzjF94cGOFvOI
         yGSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=4QE36tLivJMOr8j5gSWfIuNJsPy+ywKzgj6NE2BrPcs=;
        b=DSePgb15bJo1ff8uYGBEy2Sny0P7sSf1PHOYjl4Id4dcp6aH2mqc366jrr59/04Qss
         5CY88CTiofOOqIvn+XS7yNf6/Uydsc0EfPtHa+bZMpTcJxoo1MgpNWnf1iwoTMk5v7tw
         StF+kBUdNe6ZSKF88NMF9mWtfP94SpHX5B3ibHCT+Qrdw6zZlV4SBFbaYJ6I4VyiGFEJ
         KVobQ1Qhlh3dcgKPh1WDs9Drgb1bBpty9G1V7HkJasAskQreBBdO6+HBKhddX7AgDxfc
         aeQua9YBP0B4GSY2yD9iOBzhyqZxdSro+pVFcpvRTdesZR+Ii3Sau1oI7u4kAxkbJgTz
         gzRA==
X-Gm-Message-State: AOAM533gnas6ZhkeKNr1VMgYvvAiWlWDxIOhxocdTHi+HTJCMz/lrNiu
        Z25lsxlMV/8vKn5v4jHD3sz3WdgjAaVwfZjJATaPka/NxNyM0wqMxWov/XZv9+ODcmu4ugKWicz
        rj0ORlMTjHQeNiCS95Ork+rXjAPWb/gH5pZPbYjQAM27rRJuXklsj6RKdkw==
X-Google-Smtp-Source: ABdhPJyS28Mfl84I0wegy2xkdJkSJ0asjZ2OpVkxkk6x7dHGZ3IXpzzZLKYftBYDgB1E1rRhUzd42g29W+E=
X-Received: from pgonda1.kir.corp.google.com ([2620:15c:29:203:469d:83b1:de7b:c47f])
 (user=pgonda job=sendgmr) by 2002:a63:8f45:0:b0:398:d78:142f with SMTP id
 r5-20020a638f45000000b003980d78142fmr12931225pgn.162.1649365355882; Thu, 07
 Apr 2022 14:02:35 -0700 (PDT)
Date:   Thu,  7 Apr 2022 14:02:33 -0700
Message-Id: <20220407210233.782250-1-pgonda@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.35.1.1178.g4f1659d476-goog
Subject: [PATCH v4.1] KVM, SEV: Add KVM_EXIT_SHUTDOWN metadata for SEV-ES
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

If an SEV-ES guest requests termination, exit to userspace with
KVM_EXIT_SYSTEM_EVENT and a dedicated SEV_TERM type instead of -EINVAL
so that userspace can take appropriate action.

See AMD's GHCB spec section '4.1.13 Termination Request' for more details.

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
 * 4.1 Updated commit description

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

