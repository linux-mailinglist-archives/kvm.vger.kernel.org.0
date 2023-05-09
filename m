Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB2B76FBD9B
	for <lists+kvm@lfdr.de>; Tue,  9 May 2023 05:24:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234000AbjEIDXz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 May 2023 23:23:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231311AbjEIDXx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 May 2023 23:23:53 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 779636581
        for <kvm@vger.kernel.org>; Mon,  8 May 2023 20:23:52 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 3f1490d57ef6-ba2b9ecfadaso3729806276.2
        for <kvm@vger.kernel.org>; Mon, 08 May 2023 20:23:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1683602631; x=1686194631;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dpR8Y6nIPqOi37Vpixye2m/ShUW0PmFinpaY55RFLko=;
        b=IynTJ+LrrQ/irCAS/yQpEIpoCR0SK5m22p9JNDAzBLi+UWDI2PIlonD9wh6D8TX1Gs
         koKXf9fpViApnKPuDBCww3vgPUI0gaeQDQuanMrmQl7bmK2BgkqVRuFpnBoz1AiRIQ7j
         /HhMcc981NAvCoQ5onPD7grsJuZeBQHH7eP6eTh/5zdItygwqC+98uKBtYwx/kt3Trna
         vFSWLbmTkeBfhC37qsMcECicf6fOUS9wqPTOq+rpybJo+2kiWs5kbT+GzYUQz0JmtPjH
         Vg6RD18kCPf0J3izsTE4eRl0qYBMuNSNWrl/yomA59dGbU92JeUxgbCiiz6sZT9FhT1P
         M6uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683602631; x=1686194631;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dpR8Y6nIPqOi37Vpixye2m/ShUW0PmFinpaY55RFLko=;
        b=ajjH65yGoI001QWOahKquTKuAi4D4Dsal0IZhMlG4H2N9Qt12IMe7mhqzqvwnYwuPy
         8te6Nw6/Pp9gtIZYq68zDSPc0fJDxRsCyWlEoPhUKozxi/TuqS/y2vnzlHYacHlMtiZL
         e2nxthUL0evj/xBEsADmSo1Vf1ShNNwpBIQAQSdq+B9DH4FossenglNYs4/F55rXhpR8
         9ettNOCn2VGpikFn2WP62jploMjumHjNBN17717OSiFRdA73c9WOcaJp+xHHvrkgJZyS
         zS1p4PYop1W10q9RecGGNiVXa4woewlbunW2SgksUagXJ1NyZSo5P7p4FE/pZjvlnRBQ
         69Vg==
X-Gm-Message-State: AC+VfDzZBGogksgFrMn+oFj+k23cJjxWox/KX4cksYVsgj4GZHgO2l6D
        d5B8PBGFXzSpggRXiSkEtjJPaHUxw7zD
X-Google-Smtp-Source: ACHHUZ4DVvfOHRSg1jmcddDMu9OZASQu5P2D/etnx7+IJsHUqHQnsef4mpRMPm5yxXYudr5pL7rKuPrHSgmK
X-Received: from mizhang-super.c.googlers.com ([35.247.89.60]) (user=mizhang
 job=sendgmr) by 2002:a25:d34b:0:b0:b8f:47c4:58ed with SMTP id
 e72-20020a25d34b000000b00b8f47c458edmr8078755ybf.9.1683602631765; Mon, 08 May
 2023 20:23:51 -0700 (PDT)
Reply-To: Mingwei Zhang <mizhang@google.com>
Date:   Tue,  9 May 2023 03:23:48 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.40.1.521.gf1e218fcd8-goog
Message-ID: <20230509032348.1153070-1-mizhang@google.com>
Subject: [PATCH v3] KVM: VMX: add MSR_IA32_TSX_CTRL into msrs_to_save
From:   Mingwei Zhang <mizhang@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jim Mattson <jmattson@google.com>,
        Mingwei Zhang <mizhang@google.com>
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

Add MSR_IA32_TSX_CTRL into msrs_to_save[] to explicitly tell userspace to
save/restore the register value during migration. Missing this may cause
userspace that relies on KVM ioctl(KVM_GET_MSR_INDEX_LIST) fail to port the
value to the target VM.

In addition, there is no need to add MSR_IA32_TSX_CTRL when
ARCH_CAP_TSX_CTRL_MSR is not supported in kvm_get_arch_capabilities(). So
add the checking in kvm_probe_msr_to_save().

Fixes: c11f83e0626b ("KVM: vmx: implement MSR_IA32_TSX_CTRL disable RTM functionality")
Reported-by: Jim Mattson <jmattson@google.com>
Signed-off-by: Mingwei Zhang <mizhang@google.com>
---
 arch/x86/kvm/x86.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 237c483b1230..c8accbd6c861 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1431,7 +1431,7 @@ static const u32 msrs_to_save_base[] = {
 #endif
 	MSR_IA32_TSC, MSR_IA32_CR_PAT, MSR_VM_HSAVE_PA,
 	MSR_IA32_FEAT_CTL, MSR_IA32_BNDCFGS, MSR_TSC_AUX,
-	MSR_IA32_SPEC_CTRL,
+	MSR_IA32_SPEC_CTRL, MSR_IA32_TSX_CTRL,
 	MSR_IA32_RTIT_CTL, MSR_IA32_RTIT_STATUS, MSR_IA32_RTIT_CR3_MATCH,
 	MSR_IA32_RTIT_OUTPUT_BASE, MSR_IA32_RTIT_OUTPUT_MASK,
 	MSR_IA32_RTIT_ADDR0_A, MSR_IA32_RTIT_ADDR0_B,
@@ -7077,6 +7077,10 @@ static void kvm_probe_msr_to_save(u32 msr_index)
 		if (!kvm_cpu_cap_has(X86_FEATURE_XFD))
 			return;
 		break;
+	case MSR_IA32_TSX_CTRL:
+		if (!(kvm_get_arch_capabilities() & ARCH_CAP_TSX_CTRL_MSR))
+			return;
+		break;
 	default:
 		break;
 	}
-- 
2.40.1.521.gf1e218fcd8-goog

