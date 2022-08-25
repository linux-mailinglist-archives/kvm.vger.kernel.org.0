Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E10725A084D
	for <lists+kvm@lfdr.de>; Thu, 25 Aug 2022 07:10:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233220AbiHYFKF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Aug 2022 01:10:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232972AbiHYFKD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Aug 2022 01:10:03 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 046F94F198
        for <kvm@vger.kernel.org>; Wed, 24 Aug 2022 22:10:00 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-33580e26058so325502557b3.4
        for <kvm@vger.kernel.org>; Wed, 24 Aug 2022 22:09:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:from:to:cc;
        bh=Q3hjf8MS4AzzCWp5/oCSzOsoQ1ZbyBHYLyXOhMM4IQU=;
        b=VcczpBcdz/1D305XYzhC6q4QuudDMoUbJqkU5dHnorb9t4TPC3YwLgmqsMEgbahnh2
         +hfdMdra6lWeBABxnmLdId4Ay0ymjcNv5EE4jwqvZ2EibwlPZAZAz6kqcHdQR+jrui9V
         3Y90iiBnvUuscRTb5mNg1fDqOSXTCsWuDQ83fJ5FSRid5MLS6CNxBUG7Iy/V95SQ3Tng
         5nGiaioEr1PWX94QrqMYngmxniCLA0gWbZ7FG+9v0DlrN7P/DkVhTT8u3leAUgc7zos2
         MW4e0TWfavCUFfS++lbscSG4VwEa4ERsBnaAV3U678vU7DDvmy6klM5GBI/dJBos8c/p
         OXqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:x-gm-message-state:from:to:cc;
        bh=Q3hjf8MS4AzzCWp5/oCSzOsoQ1ZbyBHYLyXOhMM4IQU=;
        b=Cf69InOOd8g4XQxIPKivVp++Y8Ohf3ZBu1xhhRjbg2/2Pd8znKbECtgc9X+s9gPZqj
         hg0RYhj3aajkAYZ038C7Xjy8wlB0MF5Ukp4FXa6Z3GTHKHUbx+MpUjR5jjCpD8f9HXIA
         L/T8t4nIVHoYTfAvD0pWbY/SHTx/ax/aE893GUS6xg6h+90ps/A0wVzmCWIulHmrk+5o
         arD1j2Nv2HnNFwg8McTbpGhuSrRE2rtog1c2ZtxY3WZaIerCV1ZR+kdkphfceznWZtxx
         RZ29m04JxVDvYDd8ayNvXlb/izN9J+SCcIM06gArNyP/UAGK9zPVwweqjTHnkaMe85pI
         2s1Q==
X-Gm-Message-State: ACgBeo3iTd+434pqeeBOow8YDhmxh40ZEnWMFPPn/aznpOkPQozEzJGT
        6CoLQ8rZTCazlobn6ANwLkFNu8M0OK0=
X-Google-Smtp-Source: AA6agR58GZbl6co9b3RXWIjzW0YOxe8HSUhxD7OeeygT/Iu7A8ou68w797ekVXhGcdByFqk3CBisadep1EQ=
X-Received: from reijiw-west4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:aa1])
 (user=reijiw job=sendgmr) by 2002:a25:6d88:0:b0:695:9728:f253 with SMTP id
 i130-20020a256d88000000b006959728f253mr2035825ybc.39.1661404199334; Wed, 24
 Aug 2022 22:09:59 -0700 (PDT)
Date:   Wed, 24 Aug 2022 22:08:38 -0700
In-Reply-To: <20220825050846.3418868-1-reijiw@google.com>
Message-Id: <20220825050846.3418868-2-reijiw@google.com>
Mime-Version: 1.0
References: <20220825050846.3418868-1-reijiw@google.com>
X-Mailer: git-send-email 2.37.1.595.g718a3a8f04-goog
Subject: [PATCH 1/9] KVM: arm64: selftests: Add helpers to extract a field of
 an ID register
From:   Reiji Watanabe <reijiw@google.com>
To:     Marc Zyngier <maz@kernel.org>, kvmarm@lists.cs.columbia.edu
Cc:     kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Andrew Jones <andrew.jones@linux.dev>,
        Ricardo Koller <ricarkol@google.com>,
        Oliver Upton <oupton@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        Reiji Watanabe <reijiw@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Introduce helpers to extract a field of an ID register.
Subsequent patches will use those helpers.

Signed-off-by: Reiji Watanabe <reijiw@google.com>
---
 .../selftests/kvm/include/aarch64/processor.h     |  2 ++
 .../testing/selftests/kvm/lib/aarch64/processor.c | 15 +++++++++++++++
 2 files changed, 17 insertions(+)

diff --git a/tools/testing/selftests/kvm/include/aarch64/processor.h b/tools/testing/selftests/kvm/include/aarch64/processor.h
index a8124f9dd68a..a9b4b4e0e592 100644
--- a/tools/testing/selftests/kvm/include/aarch64/processor.h
+++ b/tools/testing/selftests/kvm/include/aarch64/processor.h
@@ -193,4 +193,6 @@ void smccc_hvc(uint32_t function_id, uint64_t arg0, uint64_t arg1,
 
 uint32_t guest_get_vcpuid(void);
 
+int cpuid_get_sfield(uint64_t val, int field_shift);
+unsigned int cpuid_get_ufield(uint64_t val, int field_shift);
 #endif /* SELFTEST_KVM_PROCESSOR_H */
diff --git a/tools/testing/selftests/kvm/lib/aarch64/processor.c b/tools/testing/selftests/kvm/lib/aarch64/processor.c
index 6f5551368944..0b2ad46e7ff5 100644
--- a/tools/testing/selftests/kvm/lib/aarch64/processor.c
+++ b/tools/testing/selftests/kvm/lib/aarch64/processor.c
@@ -528,3 +528,18 @@ void smccc_hvc(uint32_t function_id, uint64_t arg0, uint64_t arg1,
 		       [arg4] "r"(arg4), [arg5] "r"(arg5), [arg6] "r"(arg6)
 		     : "x0", "x1", "x2", "x3", "x4", "x5", "x6", "x7");
 }
+
+/* Helpers to get a signed/unsigned feature field from ID register value */
+int cpuid_get_sfield(uint64_t val, int field_shift)
+{
+	int width = 4;
+
+	return (int64_t)(val << (64 - width - field_shift)) >> (64 - width);
+}
+
+unsigned int cpuid_get_ufield(uint64_t val, int field_shift)
+{
+	int width = 4;
+
+	return (uint64_t)(val << (64 - width - field_shift)) >> (64 - width);
+}
-- 
2.37.1.595.g718a3a8f04-goog

