Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4091AA0E54
	for <lists+kvm@lfdr.de>; Thu, 29 Aug 2019 01:41:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727096AbfH1Xls (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Aug 2019 19:41:48 -0400
Received: from mail-qk1-f201.google.com ([209.85.222.201]:53736 "EHLO
        mail-qk1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727059AbfH1Xls (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Aug 2019 19:41:48 -0400
Received: by mail-qk1-f201.google.com with SMTP id b13so1706970qkk.20
        for <kvm@vger.kernel.org>; Wed, 28 Aug 2019 16:41:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=VgFcL2Mp1HeiHIyPdxyskzuYNm1GUXARDoKyzvhJObs=;
        b=TyjIpEEsRJDwqQpv+dZADAMH0Va0clQ2rEVIbnMWkoAeMqabLiNXCTQXe3mxPdsy7o
         GHHoZErTY+lYLC0z/g4UZi0Y4UL+s0bGgnLgb5jK36TIiOzHifZzrP/ZRX+wk4q9VzU4
         Okx8OjntS4P3/Swavxplr/p+m5Bij7XjXzG1lr5vuREt9Wk9at3SM2sV3ap1mlg68jA/
         Z4o/Jo7pSXbeJ/j0LLE5zeuAJic9aAym8adpWTSH1iyYbzaRhWg8PbrnKbjl4PSVzZg/
         hJgXGAs0DP8vjeaiyZ7lPGx/sbv56+AW8M8XRKFxVBf81rAzujFD8rPWiZ7ljtq32U1j
         8iRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=VgFcL2Mp1HeiHIyPdxyskzuYNm1GUXARDoKyzvhJObs=;
        b=O0oxHqpRpHKgOFpLhoYdHSImM9bt1vCEVPPT+EPPKfX0IqPWBCbwkw92ZymH6/E0MQ
         1gfLR2B3IFhY0+U5u5NHNCeMceI4IY9MzHMEzYt8FaMhZEcVgGirbsJIh3pa3dck+9hN
         Zrudz0pBEpAM/Bs4h70zbj2kI2/3M7y1uxtYb/YFotyb7hSwSNoddI0qstvoiLRn32nG
         AgrdFsAmWl9yOzdBqo1vcZt1mPAaLZXAPWVsOklkURfDfmJ1ZbbItNjcnj++gwPef21j
         wCp8E6ciHZmIhMrv4ZbfSS8bbqNc2CNT/gIrIEGTO/C3Jl0/r2tH8zMt3IxBG7pzlueY
         a47w==
X-Gm-Message-State: APjAAAX9L0RxduDA9+rGCIhZbGaKDK42JAP89B6vIvPk/JXPb7g9lC4J
        zffQIl5e5Dx6+5Ocn2L51WgVXxZzKoR3KZzPrZMg8/PEJEMwJzFk6ai/INWTygCMDQLckl8ONUZ
        6TspLwFI2q9izwPxhcbSMDnxt+V/YlDGYLSh+FAAsPTDXfwmgl2tx2Wy9UA==
X-Google-Smtp-Source: APXvYqyhniYGmQ+vzgIUBH0MezN+/SIj7g+sxG58psYEMQ6BCNn5R8qq2DArqQqByVcBwOtHbmKj9/nlZ6c=
X-Received: by 2002:a37:624b:: with SMTP id w72mr7095091qkb.368.1567035706970;
 Wed, 28 Aug 2019 16:41:46 -0700 (PDT)
Date:   Wed, 28 Aug 2019 16:41:30 -0700
In-Reply-To: <20190828234134.132704-1-oupton@google.com>
Message-Id: <20190828234134.132704-4-oupton@google.com>
Mime-Version: 1.0
References: <20190828234134.132704-1-oupton@google.com>
X-Mailer: git-send-email 2.23.0.187.g17f5b7556c-goog
Subject: [PATCH 3/7] KVM: VMX: Add helper to check reserved bits in MSR_CORE_PERF_GLOBAL_CTRL
From:   Oliver Upton <oupton@google.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        "=?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?=" <rkrcmar@redhat.com>
Cc:     Jim Mattson <jmattson@google.com>, Peter Shier <pshier@google.com>,
        Oliver Upton <oupton@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Creating a helper function to check the validity of the
{HOST,GUEST}_IA32_PERF_GLOBAL_CTRL wrt the PMU's global_ctrl_mask.

Suggested-by: Jim Mattson <jmattson@google.com>
Signed-off-by: Oliver Upton <oupton@google.com>
---
 arch/x86/kvm/pmu.h | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
index 58265f761c3b..b7d9efff208d 100644
--- a/arch/x86/kvm/pmu.h
+++ b/arch/x86/kvm/pmu.h
@@ -79,6 +79,17 @@ static inline bool pmc_is_enabled(struct kvm_pmc *pmc)
 	return kvm_x86_ops->pmu_ops->pmc_is_enabled(pmc);
 }
 
+static inline bool kvm_is_valid_perf_global_ctrl(struct kvm_vcpu *vcpu,
+						 u64 global_ctrl)
+{
+	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
+
+	if (pmu->global_ctrl_mask & global_ctrl)
+		return false;
+
+	return true;
+}
+
 /* returns general purpose PMC with the specified MSR. Note that it can be
  * used for both PERFCTRn and EVNTSELn; that is why it accepts base as a
  * paramenter to tell them apart.
-- 
2.23.0.187.g17f5b7556c-goog

