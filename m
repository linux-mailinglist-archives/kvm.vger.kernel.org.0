Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF5E269158E
	for <lists+kvm@lfdr.de>; Fri, 10 Feb 2023 01:33:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230430AbjBJAdS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Feb 2023 19:33:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230423AbjBJAcs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Feb 2023 19:32:48 -0500
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BDDA6E8BD
        for <kvm@vger.kernel.org>; Thu,  9 Feb 2023 16:32:12 -0800 (PST)
Received: by mail-pg1-x54a.google.com with SMTP id 201-20020a6300d2000000b004ccf545f44fso1759981pga.12
        for <kvm@vger.kernel.org>; Thu, 09 Feb 2023 16:32:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=ErxDS8Mt98Bh2G42hGdy1a7/D5r7Doi1oWDwj8D/bzs=;
        b=USF0vWnw8XD6xBLgfR077GlxM3M8cLOgPzJzS6EyFsuX6Tz8IHUkS8VPCkzqBTmHvN
         Ykf+xRwHERwEpqaivb5knRZXK7+fGnzrSTi1XrZyxqR6Q60BkOI8CM6b8JSh8DB/R0pH
         4H+7XX84Ax3fgVPq9kk8MqBvtc17sRz60GvWG7PKDZvy+cW3DHPNk8LGk+rXZ8EdP3MA
         1LvirwcUYAWpFeiz8VOvBXd7t1XiX98omtxZerYmngSI8lgMBQDUa3czCiFm3tSiQEYb
         GrAkqew/EPp8L8AGnDCCHBmFWmectV5S3uIvrtJ0HkEuAQGhWqPNYAlIN4dHYb12rJRX
         cqIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ErxDS8Mt98Bh2G42hGdy1a7/D5r7Doi1oWDwj8D/bzs=;
        b=pjgoPJ0xwUjrWpPg/OQ/OATHmP52qTysoLTm6JUlzCrADPyIFALFEW8VMs7ud2yPoy
         hLCgheAUFZ2APAMZK3IyyP8sCfIC2KvJkzcL8BWWwvwuuwcKkhp2NIEOJodGRRVzhsJk
         QjhKKKYpGSXUI53HNJSzcR+sw5vI9n1HXmp9cBXgXMZLaabqQPg151Vmqpx6uJ8+oDz6
         cGIczz/zST6Jyw139MhqIkk8n5VDqHsYTUv5HQ7f1la2dQGX2icSGHEvKbgCgf+r2Nqu
         qQWumG/+kIpe3o34vAlelkOlVB7K/bPn/6VhsQPeaumGZEIJxk8HhyyFFxPLVDSqgPIu
         Gwow==
X-Gm-Message-State: AO0yUKW7r3DFT8Fm2WPzgCmuODgDJR29zMYuUPoefYNwpAeS8fykOu0g
        BsKJtw2qFls14sPiMXQbRYlcuT7qSIo=
X-Google-Smtp-Source: AK7set8h/nB3pdroiVoJRiecXwOsrU2Ut28o2uCxWE9ULqbia1fKZFH/AY7xnX6Y1NyCUWUI+ibxV7GA0Oc=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:6b06:b0:22c:266c:2c45 with SMTP id
 v6-20020a17090a6b0600b0022c266c2c45mr1763828pjj.49.1675989131403; Thu, 09 Feb
 2023 16:32:11 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 10 Feb 2023 00:31:39 +0000
In-Reply-To: <20230210003148.2646712-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230210003148.2646712-1-seanjc@google.com>
X-Mailer: git-send-email 2.39.1.581.gbfd45094c4-goog
Message-ID: <20230210003148.2646712-13-seanjc@google.com>
Subject: [PATCH v2 12/21] KVM: selftests: Verify KVM preserves userspace
 writes to "durable" MSRs
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Xiaoyao Li <xiaoyao.li@intel.com>,
        Like Xu <like.xu.linux@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Assert that KVM provides "read what you wrote" semantics for all "durable"
MSRs (for lack of a better name).  The extra coverage is cheap from a
runtime performance perspective, and verifying the behavior in the common
helper avoids gratuitous copy+paste in individual tests.

Note, this affects all tests that set MSRs from userspace!

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/include/x86_64/processor.h    | 17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/tools/testing/selftests/kvm/include/x86_64/processor.h
index 26c8e202a956..52260f6c2465 100644
--- a/tools/testing/selftests/kvm/include/x86_64/processor.h
+++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
@@ -945,12 +945,27 @@ do {										\
 	}									\
 } while (0)
 
+/*
+ * Returns true if KVM should return the last written value when reading an MSR
+ * from userspace, e.g. the MSR isn't a command MSR, doesn't emulate state that
+ * is changing, etc.  This is NOT an exhaustive list!  The intent is to filter
+ * out MSRs that are not durable _and_ that a selftest wants to write.
+ */
+static inline bool is_durable_msr(uint32_t msr)
+{
+	return msr != MSR_IA32_TSC;
+}
+
 #define vcpu_set_msr(vcpu, msr, val)							\
 do {											\
-	uint64_t v = val;								\
+	uint64_t r, v = val;								\
 											\
 	TEST_ASSERT_MSR(_vcpu_set_msr(vcpu, msr, v) == 1,				\
 			"KVM_SET_MSRS failed on %s, value = 0x%lx", msr, #msr, v);	\
+	if (!is_durable_msr(msr))							\
+		break;									\
+	r = vcpu_get_msr(vcpu, msr);							\
+	TEST_ASSERT_MSR(r == v, "Set %s to '0x%lx', got back '0x%lx'", msr, #msr, v, r);\
 } while (0)
 
 void kvm_get_cpu_address_width(unsigned int *pa_bits, unsigned int *va_bits);
-- 
2.39.1.581.gbfd45094c4-goog

