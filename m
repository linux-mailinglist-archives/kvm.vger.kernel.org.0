Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94D5A6DDB96
	for <lists+kvm@lfdr.de>; Tue, 11 Apr 2023 15:04:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230222AbjDKNET (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Apr 2023 09:04:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230294AbjDKNEM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Apr 2023 09:04:12 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48F625273;
        Tue, 11 Apr 2023 06:03:50 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id e18-20020a17090ac21200b00246952d917fso6316050pjt.4;
        Tue, 11 Apr 2023 06:03:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1681218229;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=DGPsZgWveJxj8Dn+JY/R3MDE1ywwia78QYoiL5Lim/Y=;
        b=dnHqZC/0oeXGXGbNKCR7IbA/S6vUmwRZaRKhzBcG1vfikiAjudQRVgFqtxioPYu1LL
         WGeLVQQPYB7XI410D0VdxKEUvJcokUk6KuphqI7LS/AeTPcgFAapd1wh2Q1njd+AYev0
         CY6Bk+csVKlHGKjPDjUD/5C8Nbj5Viu47keO9ZP5lJs68c1QBbVdGglhHGZF0YkGm8tr
         T2+JSgOUzM/8lo+He0SfgLmKdd9lgqMObh0fIyEhuI8Sk2F1DPB7vzt9Svf4OHzPvC+X
         gAhWNgL1ibAumkfqrHR1nEKD7/AgiZgJpurznrCVQ5ctKxIXUj1hHr5FRhWraGFS6EHy
         frkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681218229;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=DGPsZgWveJxj8Dn+JY/R3MDE1ywwia78QYoiL5Lim/Y=;
        b=QjwVZmzti056NgNZNYtZjCF1qSw0ZP1FTeSdEIVOVSGTOkW8davqjXMMruozJoi9R4
         buf3ylZIhQ70ii5/OqAUtj+Klo9tYzS0n68q6jthGNrBac2LbGzxxhk7WA4oOK1TdeqS
         a8SknJ1kK6ZmDVdfLqSHJeTKm+HxNat99aQhY+VnE3Ugd+/RapGX5szS34n+CDpBom+N
         mOpc8fSP55uztGuv9WxExi+VGxhZ5L9yxq4argUu9z4bTvP+H+lR7pIsK0iBeZSDV0xL
         /0/5fxlp4paAHzdj28OMLSETFCVslsdMJWNxxXj90w6RJLcSenHxqpqwkTX2GLW1PdcN
         75yQ==
X-Gm-Message-State: AAQBX9dhHZS10ggi57rTjT9HrFMC0qdyrV4UWXEVp2i9gmgPk2ZFQAk+
        cu4bjbY7dfkJWh/ZvSzo7C8=
X-Google-Smtp-Source: AKy350aKCsAD2r5D8fmvW4B6NhiTUAp74QYcGu/SmHvcLWzuncyduCGC2UAXTfkU4oNJbZ1KI8Q6UQ==
X-Received: by 2002:a17:902:d40d:b0:1a6:4b2f:9a2f with SMTP id b13-20020a170902d40d00b001a64b2f9a2fmr4470258ple.59.1681218229492;
        Tue, 11 Apr 2023 06:03:49 -0700 (PDT)
Received: from CLOUDLIANG-MB2.tencent.com ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id c9-20020a170902724900b001a060007fcbsm9598506pll.213.2023.04.11.06.03.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Apr 2023 06:03:49 -0700 (PDT)
From:   Jinrong Liang <ljr.kernel@gmail.com>
X-Google-Original-From: Jinrong Liang <cloudliang@tencent.com>
To:     Sean Christopherson <seanjc@google.com>,
        Like Xu <like.xu.linux@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] KVM: x86/pmu: Remove redundant check for MSR_IA32_DS_AREA set handler
Date:   Tue, 11 Apr 2023 21:03:38 +0800
Message-Id: <20230411130338.8592-1-cloudliang@tencent.com>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Jinrong Liang <cloudliang@tencent.com>

After commit 2de154f541fc ("KVM: x86/pmu: Provide "error" semantics
for unsupported-but-known PMU MSRs"), the guest_cpuid_has(DS) check
is not necessary any more since if the guest supports X86_FEATURE_DS,
it never returns 1. And if the guest does not support this feature,
the set_msr handler will get false from kvm_pmu_is_valid_msr() before
reaching this point. Therefore, the check will not be true in all cases
and can be safely removed, which also simplifies the code and improves
its readability.

Signed-off-by: Jinrong Liang <cloudliang@tencent.com>
---
 arch/x86/kvm/vmx/pmu_intel.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index e8a3be0b9df9..b0d70a8b7613 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -443,8 +443,6 @@ static int intel_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		}
 		break;
 	case MSR_IA32_DS_AREA:
-		if (msr_info->host_initiated && data && !guest_cpuid_has(vcpu, X86_FEATURE_DS))
-			return 1;
 		if (is_noncanonical_address(data, vcpu))
 			return 1;
 		pmu->ds_area = data;
-- 
2.31.1

