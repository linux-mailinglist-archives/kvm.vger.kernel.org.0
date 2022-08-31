Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 849165A7985
	for <lists+kvm@lfdr.de>; Wed, 31 Aug 2022 10:54:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231600AbiHaIx5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 Aug 2022 04:53:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231499AbiHaIxx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 Aug 2022 04:53:53 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01E98C9EA1;
        Wed, 31 Aug 2022 01:53:51 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id v4so12941802pgi.10;
        Wed, 31 Aug 2022 01:53:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=cdByzgdS6GVsCXzYCxwV/Q4bVr0REmGp0IsegOGQh7g=;
        b=C/p/nHPybikK8PwRKe3rnCgXVe4NS0OrPhhTuNSZV6vETUkIbw26XyE8Jzd+jwyui3
         yg5N+fFiHieDqVmtLKjW1brF+5aCi3sorhnCfq9cD/4dtpI8jczJKhsEBhbPxHCbf9Vg
         97iwH+0+KFqCFBirejw070jTwtdTuyP6Fob4DJMDxBjGWVxlapTF/P11QEjzYyXIK1PD
         f8Ww8Nl9d59AFD8bLJWPjuaALu+BnZ2dpX8PIXnT3MDbN+yqbTzvqfZucQibScWwZiQx
         IWEp8UTDGcq1u/X4gm708+N+TkEtbAJ30ErWHZldRt2hYUGUlkie986bM7McR+N9Sz0i
         pWPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=cdByzgdS6GVsCXzYCxwV/Q4bVr0REmGp0IsegOGQh7g=;
        b=Rq59VWHuhqW1N3LBOfMMD3aLX5bgFLHIV1f1PCnuq6/dqpojE1G/ABmUD5STQmy8+h
         EZav0UgbgIsSZkLwSgL4Jejn2coqwwy92yj6FOJE9YSwQkqNWjdo9eyGW0ExrK4Pugum
         Q8PwsgDAEsAI2zfVJBCaDEUe54CDoxT9MxPRDVFFYskDWhDcvyOU0U6rb+CpP1WWxPTZ
         R6jM3wuVIrbZjz6Jr8/r9nBmU5Gs6igZKGgPay9+EF1NpmtymXJBaqTKC5zs7KpKCSx9
         Mq8XkDunZQeuNnbarKAziWPgN1nS473ZlUW+4/LCFuHkkozA/mBDP8NywDjEj5DtHQBn
         iubA==
X-Gm-Message-State: ACgBeo3m+dysm+jReubHY7ui0RpxpF9NH3F6bWQ36iVC0J/AySsvpSgB
        z+Eoz1KkpZM5xM0nsbMT6BuTFbRXso9OlJxu
X-Google-Smtp-Source: AA6agR6PR5h52Q2dB62cd2N+8kBgBRCMeVozKK5VtWbzkZ+ZTQeNQ+FIIpAMYTPU2wCOMRDiUS70SA==
X-Received: by 2002:a63:7d58:0:b0:42b:484c:979f with SMTP id m24-20020a637d58000000b0042b484c979fmr21397692pgn.7.1661936030265;
        Wed, 31 Aug 2022 01:53:50 -0700 (PDT)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id 26-20020a17090a1a1a00b001fab208523esm868772pjk.3.2022.08.31.01.53.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 31 Aug 2022 01:53:50 -0700 (PDT)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3 2/7] KVM: x86/pmu: Don't generate PEBS records for emulated instructions
Date:   Wed, 31 Aug 2022 16:53:23 +0800
Message-Id: <20220831085328.45489-3-likexu@tencent.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220831085328.45489-1-likexu@tencent.com>
References: <20220831085328.45489-1-likexu@tencent.com>
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

KVM will accumulate an enabled counter for at least INSTRUCTIONS or
BRANCH_INSTRUCTION hw event from any KVM emulated instructions,
generating emulated overflow interrupt on counter overflow, which
in theory should also happen when the PEBS counter overflows but
it currently lacks this part of the underlying support (e.g. through
software injection of records in the irq context or a lazy approach).

In this case, KVM skips the injection of this BUFFER_OVF PMI (effectively
dropping one PEBS record) and let the overflow counter move on. The loss
of a single sample does not introduce a loss of accuracy, but is easily
noticeable for certain specific instructions.

This issue is expected to be addressed along with the issue
of PEBS cross-mapped counters with a slow-path proposal.

Fixes: 79f3e3b58386 ("KVM: x86/pmu: Reprogram PEBS event to emulate guest PEBS counter")
Signed-off-by: Like Xu <likexu@tencent.com>
---
 arch/x86/kvm/pmu.c | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index 02f9e4f245bd..390d697efde1 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -106,9 +106,19 @@ static inline void __kvm_perf_overflow(struct kvm_pmc *pmc, bool in_pmi)
 		return;
 
 	if (pmc->perf_event && pmc->perf_event->attr.precise_ip) {
-		/* Indicate PEBS overflow PMI to guest. */
-		skip_pmi = __test_and_set_bit(GLOBAL_STATUS_BUFFER_OVF_BIT,
-					      (unsigned long *)&pmu->global_status);
+		if (!in_pmi) {
+			/*
+			 * TODO: KVM is currently _choosing_ to not generate records
+			 * for emulated instructions, avoiding BUFFER_OVF PMI when
+			 * there are no records. Strictly speaking, it should be done
+			 * as well in the right context to improve sampling accuracy.
+			 */
+			skip_pmi = true;
+		} else {
+			/* Indicate PEBS overflow PMI to guest. */
+			skip_pmi = __test_and_set_bit(GLOBAL_STATUS_BUFFER_OVF_BIT,
+						      (unsigned long *)&pmu->global_status);
+		}
 	} else {
 		__set_bit(pmc->idx, (unsigned long *)&pmu->global_status);
 	}
-- 
2.37.3

