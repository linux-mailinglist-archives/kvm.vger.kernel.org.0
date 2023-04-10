Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C96E6DC5EA
	for <lists+kvm@lfdr.de>; Mon, 10 Apr 2023 12:51:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229699AbjDJKvZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Apr 2023 06:51:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229682AbjDJKvV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Apr 2023 06:51:21 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC951422C;
        Mon, 10 Apr 2023 03:51:20 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id 98e67ed59e1d1-2465836870fso237127a91.2;
        Mon, 10 Apr 2023 03:51:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1681123880; x=1683715880;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=N4O1SVNaeIpkeBQIL0ko4BJ5hOU4NcStY8J8WtM3znA=;
        b=Wtupbb25ioOyNwtHyVTkt16CeL0UR0/pJT8FI03uFH95xYqAwbxuS1eYm9k7c4hkdF
         RCruyPz24OMnTJtdJJFnS4pD2QyDDuLQvrVpUd+juc0zI4ESVpNjaB72Z1Gayg3N287Q
         uiCHLNorjgeTuml3/Yx/qmM6veegG64jortK7TSq/yWvswP7SyXPjJwEhGAITmt01NjO
         +fgPhOIsAGnYle+akR3Gu7AE9zYpivwyDugRfKnY3gbuJWXM1KiqvZtWV8a7q6ttZo2U
         G03W7oTLQUln40Zfmr3/IgZSQdBKKNfdqitJ/FHyFlTh1eNDoeMX/Qd6/UNRIaMd2ky+
         RWxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681123880; x=1683715880;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=N4O1SVNaeIpkeBQIL0ko4BJ5hOU4NcStY8J8WtM3znA=;
        b=NFFBFR9kJZGecUnWEhe7tEzzpJlEi2UMUf9srHV9nzNqfLfH4iORyYpXNPi6TA0KGQ
         8WuVXRubYqPtqm0/OEJb7nvL03UFu7PhEMr3xGYQEemwssiopVaI4sWPCMmV5Y9lLJKR
         WmUhZ0MXgILy7CljPnI7DZSe+MMbI03cT8NpKflP1/zX2RISclEmBLAXYxzdhqGb64vc
         fgIMAhQhs0FB9ULFSmlQvJjRZ5MbeB3zuD6gmVe814Dl/sHFy2QTNT9OZjkutkPwssWV
         MiHa3nLVatyPZXrK8iXLr9OGIbvc7GSTHvK1U8bMyHD/5LnBTf7gRdVNChMkttmiqLgx
         0Cqg==
X-Gm-Message-State: AAQBX9c68Sofcho4xORGLaKhK3mZZbVzEDFAqBh5UlWi8sFb93Bet2Sf
        QtWhdx7afDo6cFuuPDDFxvg=
X-Google-Smtp-Source: AKy350ZE1g8CAlAYQRUulknJJE6+REtl9axKnaC2e3TK6/Y3g8DUW4wmRW/nZVBpLlmhoehPBf41Ig==
X-Received: by 2002:a62:6d81:0:b0:62d:d045:392 with SMTP id i123-20020a626d81000000b0062dd0450392mr10871889pfc.32.1681123880487;
        Mon, 10 Apr 2023 03:51:20 -0700 (PDT)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id h4-20020a056a00170400b0062e032b61a6sm7783252pfc.91.2023.04.10.03.51.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Apr 2023 03:51:20 -0700 (PDT)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH V5 02/10] KVM: x86/pmu: Return #GP if user sets the GLOBAL_STATUS reserved bits
Date:   Mon, 10 Apr 2023 18:50:48 +0800
Message-Id: <20230410105056.60973-3-likexu@tencent.com>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230410105056.60973-1-likexu@tencent.com>
References: <20230410105056.60973-1-likexu@tencent.com>
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
2.40.0

