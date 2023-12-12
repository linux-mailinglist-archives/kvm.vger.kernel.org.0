Return-Path: <kvm+bounces-4128-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 1ED4C80E1CD
	for <lists+kvm@lfdr.de>; Tue, 12 Dec 2023 03:30:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 94C46B2168B
	for <lists+kvm@lfdr.de>; Tue, 12 Dec 2023 02:30:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2D19046BB;
	Tue, 12 Dec 2023 02:28:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="W/eegcIN"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-x112f.google.com (mail-yw1-x112f.google.com [IPv6:2607:f8b0:4864:20::112f])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18875EB;
	Mon, 11 Dec 2023 18:28:15 -0800 (PST)
Received: by mail-yw1-x112f.google.com with SMTP id 00721157ae682-5d3c7ef7b31so50137907b3.3;
        Mon, 11 Dec 2023 18:28:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1702348093; x=1702952893; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0/w+UoxD/rATekKz3kzzyyo/gV2+D7OB+OCxe3PED0k=;
        b=W/eegcIN10Rnn2BviWHG0Zukugi4o/JFzdrwNGmFIvlsmT2w41ebE24natTUeeM9rp
         pU0FNrLWq8BrQHRD8il+n+0k+8LzVvkkHv5YA6Ic8AxEBF6cQw4SVcXwwlvd0NwCpIji
         WRjc0IvTUFw+QMLimpy9Mct3Jo+aBoRCo/8D+f5WtGEI4p1sKhMVFWnZTCtm24V1s+0T
         reWbxXABJTbONitmi11H0hFTTCM7AoARFr0FAJwjRhY1V7f70k1+zHNGwFUpEEo6Wuk5
         FMs23q7LGfErQdarDoKGNkPjY2+dBJ+VFj/JVJKF9ZwWxlAS8qDHUQpcjeJlUM6atWXi
         TWZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702348093; x=1702952893;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0/w+UoxD/rATekKz3kzzyyo/gV2+D7OB+OCxe3PED0k=;
        b=Iup93Thm2uxmYhB0QPMxBc2y0+d8Z0UL2TP8F4cdOdcdxlUx5nqMUDVK4/ZRBXhF11
         vrPCBJ8f/l++/CTjkf5NLiWYjI3NZjShxEXMXRoAmkYAjrrnvyai/bChlckrvuFMO6Pm
         1wiwNNTxd/Vzr+AP/wX8RACne80LLHAzZ3tjZ1W8mIiXbaHArQkaWC0QBAK2wQapZdSN
         82Muxjl3GFhEKh0y6AWD5uw1g9R6/gSXov8h91bxvmEScL0U0Dy/Btg7MfCkkRZ5o0zd
         XECakM6tGYAB7kTkGMNg3kyHDr7GHqW18fUkKu072tzJFmuKrkzUuEPo5atwhyxqkEZ/
         KdAA==
X-Gm-Message-State: AOJu0YzF5C21X5vz65DDhP5Nelq/QEd9WPfYf+TDQH7DEIV7ZurfGtSD
	4uYfa/FO92mEgeVgze6OdWZtRStTmzpwnQ==
X-Google-Smtp-Source: AGHT+IHET26fjcr/yQa1Q7ifmcXbI2D2kgfYmLSYnfbmSlFE4Qg2ZvcwqMAfWHDr3XMQSvwnLTacBg==
X-Received: by 2002:a0d:c907:0:b0:5d7:1941:3578 with SMTP id l7-20020a0dc907000000b005d719413578mr3549874ywd.95.1702348093356;
        Mon, 11 Dec 2023 18:28:13 -0800 (PST)
Received: from localhost ([2601:344:8301:57f0:38aa:1c88:df05:9b73])
        by smtp.gmail.com with ESMTPSA id c127-20020a0dc185000000b005d4035e6135sm3435201ywd.74.2023.12.11.18.28.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Dec 2023 18:28:12 -0800 (PST)
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
Subject: [PATCH v3 13/35] KVM: x86: hyper-v: optimize and cleanup kvm_hv_process_stimers()
Date: Mon, 11 Dec 2023 18:27:27 -0800
Message-Id: <20231212022749.625238-14-yury.norov@gmail.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20231212022749.625238-1-yury.norov@gmail.com>
References: <20231212022749.625238-1-yury.norov@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The function traverses stimer_pending_bitmap in a for-loop bit by bit.
Simplify it by using atomic find_and_set_bit().

While here, refactor the logic by decreasing indentation level.

CC: Sean Christopherson <seanjc@google.com>
Signed-off-by: Yury Norov <yury.norov@gmail.com>
Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/kvm/hyperv.c | 40 ++++++++++++++++++++--------------------
 1 file changed, 20 insertions(+), 20 deletions(-)

diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index 238afd7335e4..d541524ca49f 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -870,27 +870,27 @@ void kvm_hv_process_stimers(struct kvm_vcpu *vcpu)
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
+				    ARRAY_SIZE(hv_vcpu->stimer)) {
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
+		} else {
+			stimer_cleanup(stimer);
+		}
+	}
 }
 
 void kvm_hv_vcpu_uninit(struct kvm_vcpu *vcpu)
-- 
2.40.1


