Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 423C249746D
	for <lists+kvm@lfdr.de>; Sun, 23 Jan 2022 19:40:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239660AbiAWSkO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 23 Jan 2022 13:40:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239653AbiAWSkK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 23 Jan 2022 13:40:10 -0500
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EDADC06174E;
        Sun, 23 Jan 2022 10:40:08 -0800 (PST)
Received: by mail-pl1-x631.google.com with SMTP id d1so13469511plh.10;
        Sun, 23 Jan 2022 10:40:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=fXTatFQVxk5Bi3xsp9CFfQ0rYZTcQkLIFRbBZJuCKTo=;
        b=KYb54rPHkbyc69CRDBpNpVXaOnbgnehqVIcw6Q5nYZrUJqD8fYG2PdedR79iLsupu1
         0gdBCwGbPIeYyZXmni9s7ZZpmKmo/Qkt6ciMlPncE4deOuznLGJzZl1K94T185JjDU1/
         0BM4tN7Pc3cUFGARdyGOI4WjOia7CvHbWBmFiJQomUMYAPygd6mJY/DqSogM2u5pn9Al
         mLIiLcJHMr9gmdThRmWN027YvK50UezK0LFgIFkLjtOSJtI19b+k2G8Scgm6vJnRW1yL
         NAcnbU0VWi26fHR+siKm19tyEpaeiFoGlNWzQNa+ac8t06cAXMt05iN57RqKTVDHGZd7
         reYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=fXTatFQVxk5Bi3xsp9CFfQ0rYZTcQkLIFRbBZJuCKTo=;
        b=gY2zTaPAOGGcOun3NSiwPOGJJ71sZn0VRWIwu4ehkfUYSLlm9lX6hzhRmXopTkHBSV
         qAsRnBOZ9cGxvlZKTur/+fnlQsthSgp0296bMII2f86EZzmLQMQHe3sf1ntRzx3CAjSH
         aTcknjGC6qF+x1j5+uPQIgVQKGUbA3Hdf6CNvJvcQP79WRYLXWbjcfNegz7n8wnnQG8D
         QP/M7fdwCdfrNS7+CGO2VnGBT9+yYmY791KTkiOL4QFoLmi3/Sjal3YGD+XiK1XJHQYZ
         iQLrfZDXsUT7oQHYWGCgN7Ki+SXoX4xaRHRqyzV6Jawghnk7NXk8JzgKycd5w3UvyNzw
         E6/Q==
X-Gm-Message-State: AOAM532QpD+NZ2y4UuKCqTBZ7ylfKMylbzsETBYsinYE4V8QnB31PXEJ
        IV1OYbB1nxkKQOw7cmtcqNU=
X-Google-Smtp-Source: ABdhPJxGmwUYVMRzODasTSE+4WExw7bWOf9Gl61W4KWfE3KrsgTh2yrUpg0D0gJG15OcPQdnUHlrww==
X-Received: by 2002:a17:902:7844:b0:14a:9cff:66c7 with SMTP id e4-20020a170902784400b0014a9cff66c7mr11824524pln.14.1642963207648;
        Sun, 23 Jan 2022 10:40:07 -0800 (PST)
Received: from localhost (searspoint.nvidia.com. [216.228.112.21])
        by smtp.gmail.com with ESMTPSA id m13sm10828821pjl.39.2022.01.23.10.40.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 Jan 2022 10:40:07 -0800 (PST)
From:   Yury Norov <yury.norov@gmail.com>
To:     Yury Norov <yury.norov@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Andrew Morton <akpm@linux-foundation.org>,
        =?UTF-8?q?Micha=C5=82=20Miros=C5=82aw?= <mirq-linux@rere.qmqm.pl>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        David Laight <David.Laight@aculab.com>,
        Joe Perches <joe@perches.com>, Dennis Zhou <dennis@kernel.org>,
        Emil Renner Berthing <kernel@esmil.dk>,
        Nicholas Piggin <npiggin@gmail.com>,
        Matti Vaittinen <matti.vaittinen@fi.rohmeurope.com>,
        Alexey Klimov <aklimov@redhat.com>,
        linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        kvm@vger.kernel.org
Subject: [PATCH 06/54] x86/kvm: replace bitmap_weight with bitmap_empty where appropriate
Date:   Sun, 23 Jan 2022 10:38:37 -0800
Message-Id: <20220123183925.1052919-7-yury.norov@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220123183925.1052919-1-yury.norov@gmail.com>
References: <20220123183925.1052919-1-yury.norov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In some places kvm/hyperv.c code calls bitmap_weight() to check if any bit
of a given bitmap is set. It's better to use bitmap_empty() in that case
because bitmap_empty() stops traversing the bitmap as soon as it finds
first set bit, while bitmap_weight() counts all bits unconditionally.

Signed-off-by: Yury Norov <yury.norov@gmail.com>
---
 arch/x86/kvm/hyperv.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index 6e38a7d22e97..2c3400dea4b3 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -90,7 +90,7 @@ static void synic_update_vector(struct kvm_vcpu_hv_synic *synic,
 {
 	struct kvm_vcpu *vcpu = hv_synic_to_vcpu(synic);
 	struct kvm_hv *hv = to_kvm_hv(vcpu->kvm);
-	int auto_eoi_old, auto_eoi_new;
+	bool auto_eoi_old, auto_eoi_new;
 
 	if (vector < HV_SYNIC_FIRST_VALID_VECTOR)
 		return;
@@ -100,16 +100,16 @@ static void synic_update_vector(struct kvm_vcpu_hv_synic *synic,
 	else
 		__clear_bit(vector, synic->vec_bitmap);
 
-	auto_eoi_old = bitmap_weight(synic->auto_eoi_bitmap, 256);
+	auto_eoi_old = bitmap_empty(synic->auto_eoi_bitmap, 256);
 
 	if (synic_has_vector_auto_eoi(synic, vector))
 		__set_bit(vector, synic->auto_eoi_bitmap);
 	else
 		__clear_bit(vector, synic->auto_eoi_bitmap);
 
-	auto_eoi_new = bitmap_weight(synic->auto_eoi_bitmap, 256);
+	auto_eoi_new = bitmap_empty(synic->auto_eoi_bitmap, 256);
 
-	if (!!auto_eoi_old == !!auto_eoi_new)
+	if (auto_eoi_old == auto_eoi_new)
 		return;
 
 	down_write(&vcpu->kvm->arch.apicv_update_lock);
-- 
2.30.2

