Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9841268A79B
	for <lists+kvm@lfdr.de>; Sat,  4 Feb 2023 02:46:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233285AbjBDBqI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Feb 2023 20:46:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231165AbjBDBqE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Feb 2023 20:46:04 -0500
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE4FCA779C
        for <kvm@vger.kernel.org>; Fri,  3 Feb 2023 17:46:00 -0800 (PST)
Received: by mail-pg1-x54a.google.com with SMTP id k16-20020a635a50000000b0042986056df6so3237720pgm.2
        for <kvm@vger.kernel.org>; Fri, 03 Feb 2023 17:46:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=sK9fCHOjSKyHIh+9UN6lsnk5tQ2QvRukVyGEesqGDFI=;
        b=Ne0/c5nYli8A8YARILFynyC9hZ935JyXYB6DrRE7im9kDJtHvj3vGJoSSOGCcdIYpH
         0Z879s/LyTnhsPL0ByVE8/WKKHxbY+xXrPifBZHtJgIJKMw5TdYlt6gqg9gsiMh2O1Ie
         gaS0QN6nDEHXZm3Lj40cxq1dHx6tmLZvxmtr60XmW0w2SRN+V75Uw1Z2z1hurE/5PI1R
         z9JHfqYzDh4QfFYkWA3j8KpXBkAKQcRab4rzg/XsMXqfUzZPzSbHG1/e8+DBBvj5CO7f
         3Ghj3eMsnLqs3ZpCiQedw49VFBZemU0Q3t7r8f4q58jYqdKuMwu24DnlC98R382fSKf4
         oEqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=sK9fCHOjSKyHIh+9UN6lsnk5tQ2QvRukVyGEesqGDFI=;
        b=dBIitknalrl8omxJgzc2n0GlQnp5b2bJ9e4dGdKqpz9vMPSkDbfKv6pPojXNttZuB1
         J7sQ8vEBubWXYm/cjV4nsKbQ2tEfMeIcVHmckSG/e4U+M3oT2zOSmF0FCPByY5/5k5cT
         MgjDlSRvGcOlg2j+G8YyY9R0hInauUKCMwIdZoAxsuzaVlzmuN5Bg/Jzbe76H48SKmkF
         lSfRy58oTELGBQb2yAVVOiFHkWGqUJK8tizDRy7XMOWUFe3NVqXl35jcgZc63MAfvsLl
         IHopEz7uW25mG10ohrgGDVdChZSfEz6LRyIW77LyYXVLcvyg4y8iVqJYsGoctf2snZLI
         4lTQ==
X-Gm-Message-State: AO0yUKU17Xv1PNBhRvbWxo3HIRF+HD5x5+kGIfGyRhaWLusIzcLTSvm6
        IP2+Cs21725lya0F4xdvVCTz4RiiX/Zf
X-Google-Smtp-Source: AK7set/DXsNXXKmR3W8P/zntCNkzjBACzoHPKLF2bCvwQAuGzTlayHGK6luIrJTqjl6Qeaay4dTCp24MGQF9
X-Received: from vipin.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:479f])
 (user=vipinsh job=sendgmr) by 2002:a62:d41e:0:b0:592:4543:162c with SMTP id
 a30-20020a62d41e000000b005924543162cmr2771003pfh.33.1675475160132; Fri, 03
 Feb 2023 17:46:00 -0800 (PST)
Date:   Fri,  3 Feb 2023 17:45:46 -0800
In-Reply-To: <20230204014547.583711-1-vipinsh@google.com>
Mime-Version: 1.0
References: <20230204014547.583711-1-vipinsh@google.com>
X-Mailer: git-send-email 2.39.1.519.gcb327c4b5f-goog
Message-ID: <20230204014547.583711-4-vipinsh@google.com>
Subject: [Patch v2 3/4] KVM: selftests: Add macro to generate KVM exit reason strings
From:   Vipin Sharma <vipinsh@google.com>
To:     seanjc@google.com, pbonzini@redhat.com, maz@kernel.org,
        james.morse@arm.com, suzuki.poulose@arm.com,
        oliver.upton@linux.dev, yuzenghui@huawei.com,
        borntraeger@linux.ibm.com, frankja@linux.ibm.com,
        imbrenda@linux.ibm.com, david@redhat.com
Cc:     dmatlack@google.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
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

From: Sean Christopherson <seanjc@google.com>

Add and use a macro to generate the KVM exit reason strings array
instead of relying on developers to correctly copy+paste+edit each
string.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/lib/kvm_util.c | 52 +++++++++++-----------
 1 file changed, 27 insertions(+), 25 deletions(-)

diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 56d5ea949cbb..2413ce511d20 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -1815,37 +1815,39 @@ void vm_dump(FILE *stream, struct kvm_vm *vm, uint8_t indent)
 		vcpu_dump(stream, vcpu, indent + 2);
 }
 
+#define KVM_EXIT_STRING(x) {KVM_EXIT_##x, #x}
+
 /* Known KVM exit reasons */
 static struct exit_reason {
 	unsigned int reason;
 	const char *name;
 } exit_reasons_known[] = {
-	{KVM_EXIT_UNKNOWN, "UNKNOWN"},
-	{KVM_EXIT_EXCEPTION, "EXCEPTION"},
-	{KVM_EXIT_IO, "IO"},
-	{KVM_EXIT_HYPERCALL, "HYPERCALL"},
-	{KVM_EXIT_DEBUG, "DEBUG"},
-	{KVM_EXIT_HLT, "HLT"},
-	{KVM_EXIT_MMIO, "MMIO"},
-	{KVM_EXIT_IRQ_WINDOW_OPEN, "IRQ_WINDOW_OPEN"},
-	{KVM_EXIT_SHUTDOWN, "SHUTDOWN"},
-	{KVM_EXIT_FAIL_ENTRY, "FAIL_ENTRY"},
-	{KVM_EXIT_INTR, "INTR"},
-	{KVM_EXIT_SET_TPR, "SET_TPR"},
-	{KVM_EXIT_TPR_ACCESS, "TPR_ACCESS"},
-	{KVM_EXIT_S390_SIEIC, "S390_SIEIC"},
-	{KVM_EXIT_S390_RESET, "S390_RESET"},
-	{KVM_EXIT_DCR, "DCR"},
-	{KVM_EXIT_NMI, "NMI"},
-	{KVM_EXIT_INTERNAL_ERROR, "INTERNAL_ERROR"},
-	{KVM_EXIT_OSI, "OSI"},
-	{KVM_EXIT_PAPR_HCALL, "PAPR_HCALL"},
-	{KVM_EXIT_DIRTY_RING_FULL, "DIRTY_RING_FULL"},
-	{KVM_EXIT_X86_RDMSR, "RDMSR"},
-	{KVM_EXIT_X86_WRMSR, "WRMSR"},
-	{KVM_EXIT_XEN, "XEN"},
+	KVM_EXIT_STRING(UNKNOWN),
+	KVM_EXIT_STRING(EXCEPTION),
+	KVM_EXIT_STRING(IO),
+	KVM_EXIT_STRING(HYPERCALL),
+	KVM_EXIT_STRING(DEBUG),
+	KVM_EXIT_STRING(HLT),
+	KVM_EXIT_STRING(MMIO),
+	KVM_EXIT_STRING(IRQ_WINDOW_OPEN),
+	KVM_EXIT_STRING(SHUTDOWN),
+	KVM_EXIT_STRING(FAIL_ENTRY),
+	KVM_EXIT_STRING(INTR),
+	KVM_EXIT_STRING(SET_TPR),
+	KVM_EXIT_STRING(TPR_ACCESS),
+	KVM_EXIT_STRING(S390_SIEIC),
+	KVM_EXIT_STRING(S390_RESET),
+	KVM_EXIT_STRING(DCR),
+	KVM_EXIT_STRING(NMI),
+	KVM_EXIT_STRING(INTERNAL_ERROR),
+	KVM_EXIT_STRING(OSI),
+	KVM_EXIT_STRING(PAPR_HCALL),
+	KVM_EXIT_STRING(DIRTY_RING_FULL),
+	KVM_EXIT_STRING(X86_RDMSR),
+	KVM_EXIT_STRING(X86_WRMSR),
+	KVM_EXIT_STRING(XEN),
 #ifdef KVM_EXIT_MEMORY_NOT_PRESENT
-	{KVM_EXIT_MEMORY_NOT_PRESENT, "MEMORY_NOT_PRESENT"},
+	KVM_EXIT_STRING(MEMORY_NOT_PRESENT),
 #endif
 };
 
-- 
2.39.1.519.gcb327c4b5f-goog

