Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7F6551F9C6
	for <lists+kvm@lfdr.de>; Mon,  9 May 2022 12:26:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229896AbiEIK06 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 May 2022 06:26:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230495AbiEIK04 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 May 2022 06:26:56 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B74661E82E6;
        Mon,  9 May 2022 03:22:23 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id c1-20020a17090a558100b001dca2694f23so12260506pji.3;
        Mon, 09 May 2022 03:22:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=GpexFT3cmOpZS03q8Gk3wk4dGtIN5IPvNZieqnqQxgE=;
        b=fm6AP48k7Syr3gtiKAoNERuqbBnT2obwNYpuQpOJ8lE6VOL1uefilnWUStVkPOyX+8
         SmNDcy/T6dMTpWFTT4AzFXGYDRM8mCzQEr4+dn1XSQD+/SqksIlqnevPSXgqtzqKhTON
         +XLczgSnMIWgXbeBdh/JK1GkKmuKxtL4L80srpHQFceCHJuzdhG+6bi2aFm7qWNqU1Z5
         REMMfIDbSzAKjQ1m/ealTfWS/O9slmj0xUHrj0f2clhnJF5XCksDY84kDtwMxvSYICk2
         WGF9miG6Z88uX+G4FW2cTWSgJkaiRvZCHq1jFI/BILev1rzAyO4bljyAO2T1ad8OuwlD
         6lVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=GpexFT3cmOpZS03q8Gk3wk4dGtIN5IPvNZieqnqQxgE=;
        b=Umuv1P5sbVAEJehd+qo1Rj7g0PNIPIuB9S/mJ/w0Yyya9z04I+r9eIYQL/HNJM1X7T
         nhQT6zUEnditWrb1sowEDTbKPCb+f1yUhFco2/zKDdF7q9yFvrUGCzT7A3b4xm9c8Lb0
         lEUQBJOMFIDe42DtfTmx7WobBde6Le2bdmiWuSUQSc40Fo38iF6xFMl7XVt5cE+e6xzB
         A6Os+Lnp2BN5MGdP7MDCu+FrsOyTGFxKd1OXa5jj1ncrUfut849WQrMX01I+DsFlskim
         Jq7Pk1yIGOwhAypgp45llF/s4pXDerytLXzxnA7rZSBsDHat4gLk0bEztTZgieSZTdtw
         1Ngw==
X-Gm-Message-State: AOAM530g1Z789nkZIJMrFwqxYApFckcSJE27AN5wK0zAdbQvRmFA05DX
        4Kr/Bp5EMMMUC49BEzpYbMk=
X-Google-Smtp-Source: ABdhPJyGme3e7qug68sji3gWYynenUI6rZaZfqCl6PpR+bfc1b9x7PgiEsGIYzW5dxX8efgS7jL/7Q==
X-Received: by 2002:a17:903:210:b0:15e:f139:f901 with SMTP id r16-20020a170903021000b0015ef139f901mr13948009plh.66.1652091741845;
        Mon, 09 May 2022 03:22:21 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.83])
        by smtp.gmail.com with ESMTPSA id p17-20020a170902b09100b0015ee985a54csm6688891plr.56.2022.05.09.03.22.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 May 2022 03:22:21 -0700 (PDT)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Jim Mattson <jmattson@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] KVM: x86/pmu: Drop redundant-clumsy-asymmetric PERFCTR_CORE MSRs handling
Date:   Mon,  9 May 2022 18:22:04 +0800
Message-Id: <20220509102204.62389-3-likexu@tencent.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220509102204.62389-1-likexu@tencent.com>
References: <20220509102204.62389-1-likexu@tencent.com>
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

In commit c51eb52b8f98 ("KVM: x86: Add support for AMD Core Perf Extension
in guest"), the entry "case MSR_F15H_PERF_CTL0 ... MSR_F15H_PERF_CTR5 " is
introduced asymmetrically into kvm_get_msr_common(), ignoring the set part.

The missing guest PERFCTR_CORE cpuid check from the above commit leads to
the commit c28fa560c5bb ("KVM: x86/vPMU: Forbid reading from MSR_F15H_PERF
MSRs when guest doesn't have X86_FEATURE_PERFCTR_CORE"), but it simply
duplicates the default entry at the end of the switch statement explicitly.

Removing the PERFCTR_CORE MSRs entry in kvm_get_msr_common() thoroughly
would be more maintainable, as we did for the same group of MSRs in the
kvm_set_msr_common() at the very beginning when the feature was enabled.

Signed-off-by: Like Xu <likexu@tencent.com>
---
 arch/x86/kvm/x86.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 4790f0d7d40b..2b9089701ef5 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3841,13 +3841,6 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	case MSR_DRAM_ENERGY_STATUS:	/* DRAM controller */
 		msr_info->data = 0;
 		break;
-	case MSR_F15H_PERF_CTL0 ... MSR_F15H_PERF_CTR5:
-		if (kvm_pmu_is_valid_msr(vcpu, msr_info->index))
-			return kvm_pmu_get_msr(vcpu, msr_info);
-		if (!msr_info->host_initiated)
-			return 1;
-		msr_info->data = 0;
-		break;
 	case MSR_K7_EVNTSEL0 ... MSR_K7_EVNTSEL3:
 	case MSR_K7_PERFCTR0 ... MSR_K7_PERFCTR3:
 	case MSR_P6_PERFCTR0 ... MSR_P6_PERFCTR1:
-- 
2.36.1

