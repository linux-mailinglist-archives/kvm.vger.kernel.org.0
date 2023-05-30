Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C70A1715543
	for <lists+kvm@lfdr.de>; Tue, 30 May 2023 08:05:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230202AbjE3GEv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 May 2023 02:04:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230184AbjE3GEt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 May 2023 02:04:49 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 309B9B0;
        Mon, 29 May 2023 23:04:48 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id d2e1a72fcca58-64d604cc0aaso3158452b3a.2;
        Mon, 29 May 2023 23:04:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685426687; x=1688018687;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PLWGy0NbpiEOq7RoGuVnbCHs52CWitnw7+cWqMmaFzU=;
        b=cnfzWvyjaVXGEsCzTRmjUUerQ8p5hKysClEghTF6JPK56uzzQRV73I1Al1DWlTL+3i
         wKa1/UIsNa4nrYhGJY7AcdpBw/rHqqPt3IrkzqaTPAWZD3S8xYCQXG9Rk8wUdJobp/fC
         jkVjb6fplPtRF8vosKiKKrPYlLvSmQGnc6CdrOVKT3okUEoLKwVYbUMX9nPQqveC3R1U
         DJGldDcHT06izbWERjsv+9qLxBqGjBUOK2MzojVNvI/S/c/6XHvd+EasKYLEch3CY/0f
         Mv4gLZJOCBwGJAa9/Vi0fuEKiWDocl9lns7RaBr3ZmnrNHFgEr5/3cI5KqURFaq4vxDA
         M3lQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685426687; x=1688018687;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PLWGy0NbpiEOq7RoGuVnbCHs52CWitnw7+cWqMmaFzU=;
        b=PE6WEmiRaS2l8MvYsqOEbb3mx6iZOnQh0f3azQm8I3Q1iD6qpjTFu4qowVKJPVpMHY
         pp/vVrLZjwzvxFFMohcQsJ7HAnuH2Rs7gEh4xFinCXh5DqCqUuxmRzWJldDlGfn8vnIl
         NRyIOUgVV2nFYtRD0bfnkgroDvbcGlyvoACkoUItr0VV/RRtkmdG6+1SH75Rlx1dT1fj
         +crcJCLMwEVGhGQWEkm4BPW9rsock+vmaBjQsFdLUz6SeO8WvjivXYzjjPcUDvP5lhki
         SGxoFISfOmSU5kqR+3fu/7/vIoOSiHPdphEhNBVztiru7sjWgQK4+c1TUI/x3jw6gBds
         bjjA==
X-Gm-Message-State: AC+VfDwVP4EKH8fhyfG4eV6lhqROloNQ5h+GHpALstiIZqx/MMnHpvIE
        4av+DdfkNdkgOj4gjUcHlw0=
X-Google-Smtp-Source: ACHHUZ74T2llfDzhpjvpI7NWlLKt1fCSEpBcSILOHw/XULlc+VvaBlc4aFZs4WaVI9yzhvk86bw/Yg==
X-Received: by 2002:a05:6a20:4290:b0:10c:5802:fce4 with SMTP id o16-20020a056a20429000b0010c5802fce4mr1506790pzj.48.1685426687617;
        Mon, 29 May 2023 23:04:47 -0700 (PDT)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id gw8-20020a17090b0a4800b00256b67208b1sm638072pjb.56.2023.05.29.23.04.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 May 2023 23:04:47 -0700 (PDT)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v6 02/10] KVM: x86/pmu: Return #GP if user sets the GLOBAL_STATUS reserved bits
Date:   Tue, 30 May 2023 14:04:15 +0800
Message-Id: <20230530060423.32361-3-likexu@tencent.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230530060423.32361-1-likexu@tencent.com>
References: <20230530060423.32361-1-likexu@tencent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Like Xu <likexu@tencent.com>

Return #GP if KVM user space attempts to set a reserved bit for guest.
If the user space sets reserved bits when restoring the MSR_CORE_
PERF_GLOBAL_STATUS register, these bits will be accidentally returned
when the guest runs a read access to this register, and cannot be cleared
up inside the guest, which makes the guest's PMI handler very confused.

Note, reusing global_ovf_ctrl_mask as global_status_mask will be broken
if KVM supports higher versions of Intel arch pmu.

Signed-off-by: Like Xu <likexu@tencent.com>
---
 arch/x86/kvm/vmx/pmu_intel.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index 1f9c3e916a21..343b3182b7f4 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -399,7 +399,11 @@ static int intel_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 			reprogram_fixed_counters(pmu, data);
 		break;
 	case MSR_CORE_PERF_GLOBAL_STATUS:
-		if (!msr_info->host_initiated)
+		/*
+		 * Caution, the assumption here is that some of the bits (such as
+		 * ASCI, CTR_FREEZE, and LBR_FREEZE) are not yet supported by KVM.
+		 */
+		if (!msr_info->host_initiated || (data & pmu->global_ovf_ctrl_mask))
 			return 1; /* RO MSR */
 
 		pmu->global_status = data;
-- 
2.40.1

