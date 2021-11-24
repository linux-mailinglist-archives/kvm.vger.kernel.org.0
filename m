Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3981F45C40A
	for <lists+kvm@lfdr.de>; Wed, 24 Nov 2021 14:43:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349427AbhKXNpL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Nov 2021 08:45:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353742AbhKXNoA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Nov 2021 08:44:00 -0500
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C653C0698DB;
        Wed, 24 Nov 2021 04:21:49 -0800 (PST)
Received: by mail-pl1-x636.google.com with SMTP id b13so1715217plg.2;
        Wed, 24 Nov 2021 04:21:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=i5bNnZoC1LpYO9iHguFLaJo4uTQOtNzWZkDr+ggBDuk=;
        b=muFGqxdu0qcsGB4QhQonCDLmAtvZblArP5w/iZ4qLVyR1cg5FoSXbPCidl/M/HtgjP
         tVMUi79fGZrHQoR80W0Q2kFeT8ZdcDjADUqv0AuP/4icjSDoUsnHvorVpzN8psXd6mHC
         9SZpC6AbZeHfn3jnXXrvHHGAqSXm6Cay22hTVknuqIx5+35op7vzmV6yNT2BVHsymOh4
         kVPSvNRgtQ+/jU0ALYldW/Pl7MeX8RySYeg5/7xTH8CIs84AV1il9PdsEmKGNZvrnEsa
         ItNfdE8xbuYbVpr6Eez1FYxDrIrWSbQnPS+MDiVh060GyderMf1x8hhtK/K1Gs0KtWE8
         0NOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=i5bNnZoC1LpYO9iHguFLaJo4uTQOtNzWZkDr+ggBDuk=;
        b=7K0ioHtcRdtE7V2yPeeJrvuQQfX+1JVosV7W3zlktAaanTxhzmoLpdql5r7Tv3Mbtv
         e8fFNSsOl5/1nkS++Z59wYHapZ3oHUtknIeXlf+sGAMTwimYmbnNqjsil2S6aONY3oa+
         VJFbnw7BN2Pq4QeiXwW+Mz0lDBRVz4/xqjg5VflcvSaIfsKTlobGHgWSj9v0+OfyIq+y
         s1S+/w5B/5QNfaxx12KvZ8JC8Wd7Xws1Djh/lomO82Oysrzf0rNCU0FFyj6/ZJf/q0Rn
         9+DfOvr8WuEq67uSyUuhUyhIDifiHI8/aHXcmP0kiF9sxhFUpCVuhTkq5sHTjKkza1nG
         Uwxg==
X-Gm-Message-State: AOAM531hN+q4KlI3iZNVxpqkAnBl64aPcVoCpyRh7c7yCHTQNJvZKCTY
        gHyN30VLpw+cut93WGj6NiPslv0qBUI=
X-Google-Smtp-Source: ABdhPJzDLfzbLlfx7al7H+hWUiyBHMgVLNLXobHny+0OmoqrXTS5IQ3bmMW60+KpC/5t31yZOYZIbQ==
X-Received: by 2002:a17:90b:1185:: with SMTP id gk5mr8157520pjb.113.1637756508683;
        Wed, 24 Nov 2021 04:21:48 -0800 (PST)
Received: from localhost ([198.11.178.15])
        by smtp.gmail.com with ESMTPSA id n16sm4546847pja.46.2021.11.24.04.21.47
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 24 Nov 2021 04:21:48 -0800 (PST)
From:   Lai Jiangshan <jiangshanlai@gmail.com>
To:     linux-kernel@vger.kernel.org
Cc:     kvm@vger.kernel.org, Lai Jiangshan <laijs@linux.alibaba.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH 08/12] KVM: VMX: Use ept_caps_to_lpage_level() in hardware_setup()
Date:   Wed, 24 Nov 2021 20:20:50 +0800
Message-Id: <20211124122055.64424-9-jiangshanlai@gmail.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
In-Reply-To: <20211124122055.64424-1-jiangshanlai@gmail.com>
References: <20211124122055.64424-1-jiangshanlai@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Lai Jiangshan <laijs@linux.alibaba.com>

Using ept_caps_to_lpage_level is simpler.

Signed-off-by: Lai Jiangshan <laijs@linux.alibaba.com>
---
 arch/x86/kvm/vmx/vmx.c | 12 ++----------
 1 file changed, 2 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index c6d9c50ea5d4..3b07f5bd86b1 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7693,7 +7693,7 @@ static __init int hardware_setup(void)
 {
 	unsigned long host_bndcfgs;
 	struct desc_ptr dt;
-	int r, ept_lpage_level;
+	int r;
 
 	store_idt(&dt);
 	host_idt_base = dt.address;
@@ -7790,16 +7790,8 @@ static __init int hardware_setup(void)
 		kvm_mmu_set_ept_masks(enable_ept_ad_bits,
 				      cpu_has_vmx_ept_execute_only());
 
-	if (!enable_ept)
-		ept_lpage_level = 0;
-	else if (cpu_has_vmx_ept_1g_page())
-		ept_lpage_level = PG_LEVEL_1G;
-	else if (cpu_has_vmx_ept_2m_page())
-		ept_lpage_level = PG_LEVEL_2M;
-	else
-		ept_lpage_level = PG_LEVEL_4K;
 	kvm_configure_mmu(enable_ept, 0, vmx_get_max_tdp_level(),
-			  ept_lpage_level);
+			  ept_caps_to_lpage_level(vmx_capability.ept));
 
 	/*
 	 * Only enable PML when hardware supports PML feature, and both EPT
-- 
2.19.1.6.gb485710b

