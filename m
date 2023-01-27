Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFCCD67DC60
	for <lists+kvm@lfdr.de>; Fri, 27 Jan 2023 03:53:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233689AbjA0CxB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Jan 2023 21:53:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233034AbjA0Cw4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Jan 2023 21:52:56 -0500
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B489230EE
        for <kvm@vger.kernel.org>; Thu, 26 Jan 2023 18:52:53 -0800 (PST)
Received: by mail-ej1-x62e.google.com with SMTP id ss4so10141444ejb.11
        for <kvm@vger.kernel.org>; Thu, 26 Jan 2023 18:52:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=profian-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CddQErLZQUqzJ4JuQJZGKMscCAWt3xyB51w0UB/F/4Y=;
        b=kH4oY/ZOQrOobQ3B+Bf8tsG32rmCOtx/7K7LHHHprtnCAiu9QnEy5ayScTxTU9NgQA
         /7F9kZcxLnZT+DZzpPzOMzdFTTjrGvdED4EoCCa4qfw/xoFeSPg1E0B1nJCgjgd80sLy
         r5OHm6I+Fs3WXGMxWHpBXdGqkH7JamSjcCFJf/krHryU2s/W9rBfuDQOgvsPLKBzECD5
         lCLFoWq/ZsRNve7bStPfCkxTjHBJqMIP4Sl1ZYeo1kMO9KoroYkncuLsLY508VsNUzYX
         yGSg4vgUv7khqAH9zXxwuGBCyGp37fulsHXbrvUFkxgcbF1GulTzNcr6CVRlww746PsO
         w80Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CddQErLZQUqzJ4JuQJZGKMscCAWt3xyB51w0UB/F/4Y=;
        b=tVP81u0TR7/LEmuYePc5rCIbxj8/rxSQhP6yb7Jz3k1Z+Fs19BTBxNOpHc4uz4yjrC
         oANakeUq1nzpFj+T9lzfB0N9DTw77XomOpJgCw9v734gJ1HGi68qoi+7C6yg1uRZTLjr
         a+VUgapsST6aisSvjwGcC3R4CY44aAv96uUYpJN/4AKJKi8VqWfjjHObkbl4DXtxFaCD
         R/Q8V+F8Tlu19VpLnz5tetp/euGq0KaUErpfHC0r2mp88FulcNHQSiENeiTJmD9KMVg9
         KHb9TSfwQIv/HhMPwNRPOPRAHLYzNSC4lYU7ruHnmbJdeQ8ySOhl4nOulDqsFsUUDGdD
         uOpQ==
X-Gm-Message-State: AFqh2ko6ZyzUEl1r29vgrXx5rXfK/VleHcj5xUQn5//UREc0EOusuX0e
        X2vFSFa4BieNc8FEgKgmXLFFog==
X-Google-Smtp-Source: AMrXdXuAWQzArAbvAAsLkye6IlD5SsOaf47lxDv75lwS+5kpdSS3xwCz3jSPIgVGsFJ6/mgm8SfYqA==
X-Received: by 2002:a17:906:b317:b0:84e:d302:1551 with SMTP id n23-20020a170906b31700b0084ed3021551mr40573780ejz.37.1674787972093;
        Thu, 26 Jan 2023 18:52:52 -0800 (PST)
Received: from localhost (88-113-101-73.elisa-laajakaista.fi. [88.113.101.73])
        by smtp.gmail.com with ESMTPSA id kk4-20020a170907766400b0087943d525e1sm619768ejc.215.2023.01.26.18.52.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Jan 2023 18:52:51 -0800 (PST)
From:   Jarkko Sakkinen <jarkko@profian.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>
Cc:     Harald Hoyer <harald@profian.com>, Tom Dohrmann <erbse.13@gmx.de>,
        Ashish Kalra <ashish.kalra@amd.com>,
        Michael Roth <michael.roth@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Jarkko Sakkinen <jarkko@profian.com>,
        kvm@vger.kernel.org (open list:KERNEL VIRTUAL MACHINE FOR X86 (KVM/x86)),
        linux-kernel@vger.kernel.org (open list:X86 ARCHITECTURE (32-BIT AND
        64-BIT))
Subject: [PATCH RFC 4/8] KVM: SVM: fix: add separate error for missing slot
Date:   Fri, 27 Jan 2023 02:52:33 +0000
Message-Id: <20230127025237.269680-5-jarkko@profian.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230127025237.269680-1-jarkko@profian.com>
References: <20230127025237.269680-1-jarkko@profian.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Tom Dohrmann <erbse.13@gmx.de>

The next error message uses slot assuming that it's not NULL, but that's not
always true. A separate error message is used when slot is NULL.

This can be triggered by a malicious guest that sends an
`SVM_VMGEXIT_AP_CREATE` ap creation event that points to an invalid AP VMSA
address (one that isn't mapped). Currently the kernel just copies the values
provided by the guest into `snp_vmsa_gpa` (see arch/x86/kvm/svm/sev.c:3930).
This value is directly passed into `gfn_to_pfn_restricted` in
`__sev_snp_update_protected_guest_state` (see arch/x86/kvm/svm/sev.c:3792).

Signed-off-by: Tom Dohrmann <erbse.13@gmx.de>
Signed-off-by: Jarkko Sakkinen <jarkko@profian.com>
---
 arch/x86/kvm/svm/sev.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 4a8e552d8cfe..d76127f1499a 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -3745,6 +3745,11 @@ static kvm_pfn_t gfn_to_pfn_restricted(struct kvm *kvm, gfn_t gfn)
 	int order = 0;
 
 	slot = gfn_to_memslot(kvm, gfn);
+	if (!slot) {
+		pr_err("SEV: Failure retrieving memslot for GFN 0x%llx\n", gfn);
+		return INVALID_PAGE;
+	}
+
 	if (!kvm_slot_can_be_private(slot)) {
 		pr_err("SEV: Failure retrieving restricted memslot for GFN 0x%llx, flags 0x%x, userspace_addr: 0x%lx\n",
 		       gfn, slot->flags, slot->userspace_addr);
-- 
2.38.1

