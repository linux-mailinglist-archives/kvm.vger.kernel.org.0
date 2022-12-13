Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7069D64AC12
	for <lists+kvm@lfdr.de>; Tue, 13 Dec 2022 01:17:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234070AbiLMARD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Dec 2022 19:17:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234059AbiLMARA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Dec 2022 19:17:00 -0500
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17BEA1CB08
        for <kvm@vger.kernel.org>; Mon, 12 Dec 2022 16:16:58 -0800 (PST)
Received: by mail-pf1-x44a.google.com with SMTP id a18-20020a62bd12000000b0056e7b61ec78so889514pff.17
        for <kvm@vger.kernel.org>; Mon, 12 Dec 2022 16:16:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=DOvY7w0rRl2MxDLB0k3o2yUeh+erpcmsWDFuA702T6s=;
        b=l9bHJR0oKKynBT27/jXjQ30QimwweOaqtl3QWSLCU6FiFSKCA3rrt+E957wr1zpBhD
         p4waCGA7XG6QFQxmIYOYBakT8OP8vBme+ryoiFdvRCbt7Q2ZtXp4RLmkXlcugdy8NM6J
         MYhNQigzo87mMoFsVV3kq1X4lwNDqM8YgTEc4/zV1HBrccTtlep12cAiKHftvJ9PO0k2
         dGucFeV2hflrJde6Dcxo9dBUuMVUPRQOUE5HkYqU6f8H7eZCPwsf2UIaBzMv3IzDH+uX
         QKFy0hRnovAJqXB4b5KB6Lo+KRVs0lKzNC9qMNzoduiGQCZghvBOB/ql+Wco/Cgp8R+b
         el5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=DOvY7w0rRl2MxDLB0k3o2yUeh+erpcmsWDFuA702T6s=;
        b=3uyHl/rvJj1vAMOomOCSw2ojVVrwcYAJxJ5GcjmqR7x/o1+lACCM3zlS8UR6B1D6zW
         jC52oHULEvuN+dtgDO3E0pkKmnXWXcqL4HeFumAccshZqj0XhqhZCUq04cdt45IzfFca
         D/1pas20Q7cUgAtYUUneWZvlbohDEFyzVHH3WdxQj/5MFEnTbqM3Ubp1kMGVKtDfXpJO
         VBiHrP7fecixT0sJspI9H9mGIvG5ChWdpjiiBuASK0lj87wvgvAIVf1O9L9tCJBrFwmg
         HQ4gROeziUH2iUhtZbt/y7EnGv6g7jtjbTAZvC83znhpxVATIFs/gHOGQnF5/xWnc6Dn
         OcNA==
X-Gm-Message-State: ANoB5plgzBDiS8hcrfT0E/xBlllskr3iYUjDaKgUnv0qBkn4hJo2/CVP
        x63mM+2Bjaip7ww9/Ak5SXzSq1UDBlo=
X-Google-Smtp-Source: AA0mqf4hBxtcZbd9UejO8wqEoLXBgUBqlQprFxOUH1fTAJDZ9Y1ut6pSZnFL0fRAkhQQsou2JfJD4SuBkEo=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:aa7:9629:0:b0:576:8cdd:3f26 with SMTP id
 r9-20020aa79629000000b005768cdd3f26mr26606972pfg.59.1670890618334; Mon, 12
 Dec 2022 16:16:58 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 13 Dec 2022 00:16:40 +0000
In-Reply-To: <20221213001653.3852042-1-seanjc@google.com>
Mime-Version: 1.0
References: <20221213001653.3852042-1-seanjc@google.com>
X-Mailer: git-send-email 2.39.0.rc1.256.g54fd8350bd-goog
Message-ID: <20221213001653.3852042-2-seanjc@google.com>
Subject: [PATCH 01/14] KVM: selftests: Define literal to asm constraint in
 aarch64 as unsigned long
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>
Cc:     James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Tom Rix <trix@redhat.com>, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        kvmarm@lists.cs.columbia.edu, linux-riscv@lists.infradead.org,
        llvm@lists.linux.dev, linux-kernel@vger.kernel.org,
        Ricardo Koller <ricarkol@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Aaron Lewis <aaronlewis@google.com>,
        Raghavendra Rao Ananta <rananta@google.com>
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

Define a literal '0' asm input constraint to aarch64/page_fault_test's
guest_cas() as an unsigned long to make clang happy.

  tools/testing/selftests/kvm/aarch64/page_fault_test.c:120:16: error:
    value size does not match register size specified by the constraint
    and modifier [-Werror,-Wasm-operand-widths]
                       :: "r" (0), "r" (TEST_DATA), "r" (guest_test_memory));
                               ^
  tools/testing/selftests/kvm/aarch64/page_fault_test.c:119:15: note:
    use constraint modifier "w"
                       "casal %0, %1, [%2]\n"
                              ^~
                              %w0

Fixes: 35c581015712 ("KVM: selftests: aarch64: Add aarch64/page_fault_test")
Cc: Ricardo Koller <ricarkol@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/aarch64/page_fault_test.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/aarch64/page_fault_test.c b/tools/testing/selftests/kvm/aarch64/page_fault_test.c
index 95d22cfb7b41..beb944fa6fd4 100644
--- a/tools/testing/selftests/kvm/aarch64/page_fault_test.c
+++ b/tools/testing/selftests/kvm/aarch64/page_fault_test.c
@@ -117,7 +117,7 @@ static void guest_cas(void)
 	GUEST_ASSERT(guest_check_lse());
 	asm volatile(".arch_extension lse\n"
 		     "casal %0, %1, [%2]\n"
-		     :: "r" (0), "r" (TEST_DATA), "r" (guest_test_memory));
+		     :: "r" (0ul), "r" (TEST_DATA), "r" (guest_test_memory));
 	val = READ_ONCE(*guest_test_memory);
 	GUEST_ASSERT_EQ(val, TEST_DATA);
 }
-- 
2.39.0.rc1.256.g54fd8350bd-goog

