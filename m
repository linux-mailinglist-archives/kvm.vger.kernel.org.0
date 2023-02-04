Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14B0568A79F
	for <lists+kvm@lfdr.de>; Sat,  4 Feb 2023 02:46:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233372AbjBDBqL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Feb 2023 20:46:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233170AbjBDBqE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Feb 2023 20:46:04 -0500
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 341C4A07EC
        for <kvm@vger.kernel.org>; Fri,  3 Feb 2023 17:46:02 -0800 (PST)
Received: by mail-pg1-x54a.google.com with SMTP id 127-20020a630685000000b004ec5996dcc0so3244683pgg.8
        for <kvm@vger.kernel.org>; Fri, 03 Feb 2023 17:46:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=qyYa8Qat+lTw3atiunoKQmFDsPCPb3UNXVzDZ2TBu3Q=;
        b=cuzQZ4tKFiA10Kddd6EOQmYsDVZzTLPRgrAaTczH/Hu7mF6xMvgj07YXc2DWpmUw3U
         GcfM43hkFZgOclVNSw3t9rGEyvbpuzt5AltJAKouxXUvdVDBjuwq3+Cy+G7DqrwboLF5
         +NX7h9oyJzd7cjNpvXsevWWc5dnJ9RQvRrRxRN67lD/AAWVL4KuWjn/+EVHEchPJHcl3
         elceONyabSV3rORU2F/XBAmyFOfTKgEVWVGuNObKjaqxrj82LqdE+AxPI4KrcpiwRu2R
         wS14T7XeaUP1jIXSoprF+FjJkxdS0eI99a0i615TE5d37fU1TMm5xYv1lUPr1Lv8uWCG
         YxJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qyYa8Qat+lTw3atiunoKQmFDsPCPb3UNXVzDZ2TBu3Q=;
        b=pZYTPQFBFFv6WaZTCwrIMKuXHPGzG++xfU2O66jLRASLVHIDZ7hREzAlRr6cvZkxv3
         7wafdgSwAGnZwAdHKFTTbsfE9KINdzny8+E78CBaGAhkNBNUo0rW0VVd8/UfEoZJnh3S
         l8VTcLf+HZax3IOwev/3rxexbEHjcgvFHh8fkM4jMZzaLgFEPqIV3jaOLMvPjYNw4+mn
         LKrSz0esvsEGKMxCvt/ZsDRd3XoEAkzapGnhjhpS0XqtgfhZ5T9SiVotlGO1BIa8evQF
         2Ub+229s0dvIhC/SiMoifVDKvTom4CwrpRq+ff2AljzlPhV9KwiWq+tSDeCh+koYY6vi
         KiHw==
X-Gm-Message-State: AO0yUKUwOCi8Tx9QSmznrAa4L46Ut0iVYR0nIRZNNNOMf4azqjggEoDt
        a10sXNceZYq2wc8ji2zPIb0p5SUa5OX9
X-Google-Smtp-Source: AK7set+64pnLKSbG2DzqahkjY5BqKe4cY/Uu2AaK9qj5DZjp6GWybtk+8ZvUugJS5vzEWyWL2VaLezn7Iuw2
X-Received: from vipin.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:479f])
 (user=vipinsh job=sendgmr) by 2002:a17:902:eac4:b0:196:7664:39a with SMTP id
 p4-20020a170902eac400b001967664039amr2735913pld.30.1675475161680; Fri, 03 Feb
 2023 17:46:01 -0800 (PST)
Date:   Fri,  3 Feb 2023 17:45:47 -0800
In-Reply-To: <20230204014547.583711-1-vipinsh@google.com>
Mime-Version: 1.0
References: <20230204014547.583711-1-vipinsh@google.com>
X-Mailer: git-send-email 2.39.1.519.gcb327c4b5f-goog
Message-ID: <20230204014547.583711-5-vipinsh@google.com>
Subject: [Patch v2 4/4] KVM: selftests: Sync KVM exit reasons in selftests
From:   Vipin Sharma <vipinsh@google.com>
To:     seanjc@google.com, pbonzini@redhat.com, maz@kernel.org,
        james.morse@arm.com, suzuki.poulose@arm.com,
        oliver.upton@linux.dev, yuzenghui@huawei.com,
        borntraeger@linux.ibm.com, frankja@linux.ibm.com,
        imbrenda@linux.ibm.com, david@redhat.com
Cc:     dmatlack@google.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Vipin Sharma <vipinsh@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,UPPERCASE_50_75,USER_IN_DEF_DKIM_WL
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add missing KVM_EXIT_* reasons in KVM selftests from
include/uapi/linux/kvm.h

Signed-off-by: Vipin Sharma <vipinsh@google.com>
---
 tools/testing/selftests/kvm/lib/kvm_util.c | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 2413ce511d20..704cc652849c 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -1842,10 +1842,24 @@ static struct exit_reason {
 	KVM_EXIT_STRING(INTERNAL_ERROR),
 	KVM_EXIT_STRING(OSI),
 	KVM_EXIT_STRING(PAPR_HCALL),
-	KVM_EXIT_STRING(DIRTY_RING_FULL),
+	KVM_EXIT_STRING(S390_UCONTROL),
+	KVM_EXIT_STRING(WATCHDOG),
+	KVM_EXIT_STRING(S390_TSCH),
+	KVM_EXIT_STRING(EPR),
+	KVM_EXIT_STRING(SYSTEM_EVENT),
+	KVM_EXIT_STRING(S390_STSI),
+	KVM_EXIT_STRING(IOAPIC_EOI),
+	KVM_EXIT_STRING(HYPERV),
+	KVM_EXIT_STRING(ARM_NISV),
 	KVM_EXIT_STRING(X86_RDMSR),
 	KVM_EXIT_STRING(X86_WRMSR),
+	KVM_EXIT_STRING(DIRTY_RING_FULL),
+	KVM_EXIT_STRING(AP_RESET_HOLD),
+	KVM_EXIT_STRING(X86_BUS_LOCK),
 	KVM_EXIT_STRING(XEN),
+	KVM_EXIT_STRING(RISCV_SBI),
+	KVM_EXIT_STRING(RISCV_CSR),
+	KVM_EXIT_STRING(NOTIFY),
 #ifdef KVM_EXIT_MEMORY_NOT_PRESENT
 	KVM_EXIT_STRING(MEMORY_NOT_PRESENT),
 #endif
-- 
2.39.1.519.gcb327c4b5f-goog

