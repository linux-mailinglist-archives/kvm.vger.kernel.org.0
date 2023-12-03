Return-Path: <kvm+bounces-3276-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 99DF98026E1
	for <lists+kvm@lfdr.de>; Sun,  3 Dec 2023 20:34:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4EDCD1F21209
	for <lists+kvm@lfdr.de>; Sun,  3 Dec 2023 19:34:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7AF9418049;
	Sun,  3 Dec 2023 19:33:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dIC9loic"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-x1130.google.com (mail-yw1-x1130.google.com [IPv6:2607:f8b0:4864:20::1130])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3533410CA;
	Sun,  3 Dec 2023 11:33:32 -0800 (PST)
Received: by mail-yw1-x1130.google.com with SMTP id 00721157ae682-5d77a1163faso7152077b3.0;
        Sun, 03 Dec 2023 11:33:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1701632010; x=1702236810; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=N0ENozNhFAYXy95QOP67o+1Q/NjaSepiL+2VBtFDfqQ=;
        b=dIC9loicucdFENmmAmt92k0snb4vECSYixG9ygscz/qOq7EHETJmRimzD2GpRgoP/f
         fmSLrCujgHzUY9cAKzVXur5sNce8P0z+sv1ByqbC95lizX+EBlKbWJPxEKZ6l4+v729X
         UVQMNGTSjQ2aVm4pxyI8pMqMUJZ37TyjORrxaKfUrNZZXpx6czd/27W5Wk4dSHNjPpWA
         rvavajiBshneLWs4zG/a8fvThpRDCs64wN0soAQqVoEN5FSYdN7LSIyvJyd6tozFfHpW
         G8XHC+QVBg338wlibSwqLA0vvFYte8VIQabnxuv26lS/zfgcmKeYujg43qUwtxHXEKHw
         QIgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701632010; x=1702236810;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=N0ENozNhFAYXy95QOP67o+1Q/NjaSepiL+2VBtFDfqQ=;
        b=FPZkmYY/jViZEp9i4XHeN0to3GUQiyiXidPrAcfDgS2YhUzFhQ8biFM3J9HHDBLeHO
         B2OiSRUb2sAr306zJzPN/sO2RTqZi2bKbazAyo/hH44UD46g5GyM8U/AJzhVmf6/FNT8
         aEWkV/s2+2tGL9D6/YGkzV6D5EvbWs0E/aCBLhLTKLWilpj1ZtUjlN+Um/CW2SNywLjc
         ZjnfnnflHGq+LnTToTY0ltcdH3tt/70gV8JqUggSNZdVZvCRlHNLaAfDnx6EkI847zDo
         /gQMTF60IaZkZYLSiROvuCUgEF2RgIBwdxGnrD5PWlFHowW+z5rwhDRFc3rVmnhe7yht
         j1Pw==
X-Gm-Message-State: AOJu0YyyHEeDULGeQ16MY+zIHlUCTFVLDrzbLSVndP9ethXsk0v4HqUC
	GQl4ZgcyAt6APLBDVHkT65mOremBC0eMww==
X-Google-Smtp-Source: AGHT+IFsa29FuZD2EyCxt56gKIcChYiQoi8nrh3wlT62dLHTdHub4SbmeuKDhwKW6xenxt4zPuMFfg==
X-Received: by 2002:a05:690c:734:b0:5d7:1940:3eec with SMTP id bt20-20020a05690c073400b005d719403eecmr1874045ywb.29.1701632010491;
        Sun, 03 Dec 2023 11:33:30 -0800 (PST)
Received: from localhost ([2601:344:8301:57f0:cb98:c3e:57c:8191])
        by smtp.gmail.com with ESMTPSA id v136-20020a81488e000000b005d8bb479c51sm43551ywa.11.2023.12.03.11.33.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 03 Dec 2023 11:33:29 -0800 (PST)
From: Yury Norov <yury.norov@gmail.com>
To: linux-kernel@vger.kernel.org,
	Vitaly Kuznetsov <vkuznets@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	kvm@vger.kernel.org
Cc: Yury Norov <yury.norov@gmail.com>,
	Jan Kara <jack@suse.cz>,
	Mirsad Todorovac <mirsad.todorovac@alu.unizg.hr>,
	Matthew Wilcox <willy@infradead.org>,
	Rasmus Villemoes <linux@rasmusvillemoes.dk>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Maxim Kuvyrkov <maxim.kuvyrkov@linaro.org>,
	Alexey Klimov <klimov.linux@gmail.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Sergey Shtylyov <s.shtylyov@omp.ru>
Subject: [PATCH v2 13/35] KVM: x86: hyper-v: optimize and cleanup kvm_hv_process_stimers()
Date: Sun,  3 Dec 2023 11:32:45 -0800
Message-Id: <20231203193307.542794-12-yury.norov@gmail.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20231203193307.542794-1-yury.norov@gmail.com>
References: <20231203192422.539300-1-yury.norov@gmail.com>
 <20231203193307.542794-1-yury.norov@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The function traverses stimer_pending_bitmap in a for-loop bit by bit.
We can do it faster by using atomic find_and_set_bit().

While here, refactor the logic by decreasing indentation level.

CC: Vitaly Kuznetsov <vkuznets@redhat.com>
Signed-off-by: Yury Norov <yury.norov@gmail.com>
---
 arch/x86/kvm/hyperv.c | 39 +++++++++++++++++++--------------------
 1 file changed, 19 insertions(+), 20 deletions(-)

diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index 238afd7335e4..a0e45d20d451 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -870,27 +870,26 @@ void kvm_hv_process_stimers(struct kvm_vcpu *vcpu)
 	if (!hv_vcpu)
 		return;
 
-	for (i = 0; i < ARRAY_SIZE(hv_vcpu->stimer); i++)
-		if (test_and_clear_bit(i, hv_vcpu->stimer_pending_bitmap)) {
-			stimer = &hv_vcpu->stimer[i];
-			if (stimer->config.enable) {
-				exp_time = stimer->exp_time;
-
-				if (exp_time) {
-					time_now =
-						get_time_ref_counter(vcpu->kvm);
-					if (time_now >= exp_time)
-						stimer_expiration(stimer);
-				}
-
-				if ((stimer->config.enable) &&
-				    stimer->count) {
-					if (!stimer->msg_pending)
-						stimer_start(stimer);
-				} else
-					stimer_cleanup(stimer);
-			}
+	for_each_test_and_clear_bit(i, hv_vcpu->stimer_pending_bitmap,
+					ARRAY_SIZE(hv_vcpu->stimer)) {
+		stimer = &hv_vcpu->stimer[i];
+		if (!stimer->config.enable)
+			continue;
+
+		exp_time = stimer->exp_time;
+
+		if (exp_time) {
+			time_now = get_time_ref_counter(vcpu->kvm);
+			if (time_now >= exp_time)
+				stimer_expiration(stimer);
 		}
+
+		if (stimer->config.enable && stimer->count) {
+			if (!stimer->msg_pending)
+				stimer_start(stimer);
+		} else
+			stimer_cleanup(stimer);
+	}
 }
 
 void kvm_hv_vcpu_uninit(struct kvm_vcpu *vcpu)
-- 
2.40.1


