Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 247FC6D594C
	for <lists+kvm@lfdr.de>; Tue,  4 Apr 2023 09:18:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233810AbjDDHSW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Apr 2023 03:18:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233352AbjDDHSV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Apr 2023 03:18:21 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52AE6E5C;
        Tue,  4 Apr 2023 00:18:20 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id p13-20020a17090a284d00b0023d2e945aebso1141671pjf.0;
        Tue, 04 Apr 2023 00:18:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680592700;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=FCygZmbLng0ooUwO0+yqIAuXoXe7sopWyBe6SH2VVnk=;
        b=ZeMFSm3rQ6boGlvBEEikmhbKoCXYmSQtt3VyzhkSUgIwMcYPQKiBFXZfHz8c6eYzXl
         C5F1Tkc+cw2H4bv9V5Z/LbduzoSEaNw8cpEmktwc/TNnDuIDAZIPBoVQz3zac+vZhAXJ
         N1rICkWE50isRzhk9UczFSOEkRqtPczf/FBY6x9Ssk5ecBc4W4l45srX/2xABNY2e2Zn
         iuyq7N9M4+um+a6cIpLp6PIOpCBqyPFJfWDiA1xduvXqQz93YprKBnxV6oFfGMh4SMxQ
         OSYAyHhTqnyWej9te7u4yQujwj9+/h2T11rfmjah6ahMpmHkz7i+IuBDYYM9TDrkaKPF
         f31g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680592700;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=FCygZmbLng0ooUwO0+yqIAuXoXe7sopWyBe6SH2VVnk=;
        b=QPzEXxtpShuMv+ml6xvm4Tgm2MnsutaTJXoZSgzZKG3GDIHZ3gXb9KX4/M//pO33Ly
         x5Ha/yOBjv7pY4b+FFJ3iGdNiM2uQse+ADLzL7soKMwqTTnijV1E9N/egxtNp1CJGeZd
         X6JWZqv7vREt/c1nZhI8Zsl0dON+UGLNL3Tay4aULHF4i0TOPoOxbfm8HSwTm01O77gD
         57/j34bmc+rOWoWG9P4PYO2myLRBUkmnUJ9zHuLhsRSf0TypS/dedJdDf5haJAXHwNpz
         qBUodAPRClJm/7N7gxh2tgJciL7WqF3DGIeyfHcEDA753dKNhR8fkvsquq0ZQm/Wtf0X
         ZRpg==
X-Gm-Message-State: AAQBX9dkbtIeO0ZR0Lzj9Qw5bTUV2HrT3W3lkmgdS/0Vf01QKN1Cogtj
        SssJwawLKAqqc1Zbx6MESNc=
X-Google-Smtp-Source: AKy350YLCpuWAmtNpRSOJMnwdRDQeprw0LJ2hzLlggSqbqkCKHXtDOwUjJRO9vMJBzQrDsbmx0U6uQ==
X-Received: by 2002:a17:90a:1902:b0:240:5c43:7766 with SMTP id 2-20020a17090a190200b002405c437766mr1918658pjg.4.1680592699721;
        Tue, 04 Apr 2023 00:18:19 -0700 (PDT)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id gp11-20020a17090adf0b00b002376d85844dsm7269164pjb.51.2023.04.04.00.18.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Apr 2023 00:18:19 -0700 (PDT)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] KVM: x86/pmu: Zero out pmu->all_valid_pmc_idx each time it's refreshed
Date:   Tue,  4 Apr 2023 15:17:59 +0800
Message-Id: <20230404071759.75376-1-likexu@tencent.com>
X-Mailer: git-send-email 2.40.0
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

From: Like Xu <likexu@tencent.com>

The kvm_pmu_refresh() may be called repeatedly (e.g. configure guest
CPUID repeatedly or update MSR_IA32_PERF_CAPABILITIES) and each
call will use the last pmu->all_valid_pmc_idx value, with the residual
bits introducing additional overhead later in the vPMU emulation.

Fixes: b35e5548b411 ("KVM: x86/vPMU: Add lazy mechanism to release perf_event per vPMC")
Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Like Xu <likexu@tencent.com>
---
 arch/x86/kvm/pmu.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index 612e6c70ce2e..29492c2a0c82 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -589,6 +589,7 @@ int kvm_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
  */
 void kvm_pmu_refresh(struct kvm_vcpu *vcpu)
 {
+	bitmap_zero(vcpu_to_pmu(vcpu)->all_valid_pmc_idx, X86_PMC_IDX_MAX);
 	static_call(kvm_x86_pmu_refresh)(vcpu);
 }
 
-- 
2.40.0

