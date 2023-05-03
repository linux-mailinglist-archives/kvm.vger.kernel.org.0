Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 066426F52F3
	for <lists+kvm@lfdr.de>; Wed,  3 May 2023 10:16:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229826AbjECIQn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 May 2023 04:16:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229668AbjECIQl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 May 2023 04:16:41 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95D44133;
        Wed,  3 May 2023 01:16:40 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id 98e67ed59e1d1-24b725d6898so3219434a91.2;
        Wed, 03 May 2023 01:16:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683101800; x=1685693800;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pt6d2Jmrjanphi5K9FsZqei3BF1VkXGJynqoFhQrNAU=;
        b=A1PmfxYpF3qoblfNK97dC3AaNBpv8mzSiBzfJzOe/r/dDffJoz8dLm/L/rTuwNChSB
         i/T7vwAnfcPP8yMq+mzhD6kghQIgOpFyPZA/OuGh7jmZLGu95PfDBmHmzzZFca8l3T/H
         FrP/vINoqkv6RfCjTTb9/r3yH0cr2IJXKAsRYYm9ZKYElvgfK4HwAyTQTAiT+tgYoZeg
         GXiKODKDviOVVmBMDVqnsFni4VHqJB5lETxGX9rSXmVsuLEZk7h9uQi9vpeCNpH/aY6B
         j2X9eQcXUlgxDbQ5hNRNi5pRjqxPzQ7B5jr0Kh9xCcxofidqDzT84LloX1bQBdKRIyxG
         yznQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683101800; x=1685693800;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pt6d2Jmrjanphi5K9FsZqei3BF1VkXGJynqoFhQrNAU=;
        b=W6nh7NgFAVRrniODhisQeQEhT5rDIGtDLMJlXsK03UAWkLpxWTTOT2ffSPv1LzWjE2
         kf4pUJcxqSWTujJbLnmccckjOQ82ypOcDH5GiTdrMzEN6AdSovccrimVuX9TRSymQv9G
         lLQhntk3NWzZ9w33CWooDVTyeZiDfqyrL86MBbLhOydzGTafc9slMvIWxraCgb2laZ2n
         +GdtgW7XYuqPheIzix34Yn3TF31pKACe1rXUa5hlnV4VP6cybhVeBm77iT6Nf7vUKfZV
         8bsqJ3jsHuV1Ec78fxUilXujuhxEUMH533wuj5jBx8XZ2xX0gstBWaenJH4gN2w3mja9
         Vbmg==
X-Gm-Message-State: AC+VfDxqpH7Xo01nwhlhzguqOFFVv/DBZVQMHPMLo5ogg1Qjyv/S6c2w
        rlRyfz/BOJWXJshvLA+NewGO6uWZFeAU7A==
X-Google-Smtp-Source: ACHHUZ5c+uSXzzvsjjEu7IrVNqAZfNFOJtUWmm9R5rbVE3FpAuKkTLL7AHlscaEdbpoQoJHUqNgYUw==
X-Received: by 2002:a17:90a:8409:b0:246:82ac:b6cf with SMTP id j9-20020a17090a840900b0024682acb6cfmr20226075pjn.11.1683101799738;
        Wed, 03 May 2023 01:16:39 -0700 (PDT)
Received: from Dommie-Laptop.. (111-248-114-205.dynamic-ip.hinet.net. [111.248.114.205])
        by smtp.gmail.com with ESMTPSA id jx12-20020a17090b46cc00b0024e0141353dsm782148pjb.28.2023.05.03.01.16.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 May 2023 01:16:39 -0700 (PDT)
From:   Yan-Jie Wang <yanjiewtw@gmail.com>
To:     linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Jonathan Corbet <corbet@lwn.net>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Andre Przywara <andre.przywara@arm.com>,
        Avi Kivity <avi@redhat.com>,
        Yan-Jie Wang <yanjiewtw@gmail.com>,
        Ching-Chun Huang <jserv@ccns.ncku.edu.tw>, trivial@kernel.org,
        kvm@vger.kernel.org
Subject: [PATCH v2] docs: clarify KVM related kernel parameters' descriptions
Date:   Wed,  3 May 2023 16:15:31 +0800
Message-Id: <20230503081530.19956-1-yanjiewtw@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230502112502.14859-1-yanjiewtw@gmail.com>
References: <20230502112502.14859-1-yanjiewtw@gmail.com>
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

The descriptions of certain KVM related kernel parameters can be
confusing. They state "Disable ...," which may make people think that
setting them to 1 will disable the associated feature when in fact the
opposite is true.

This commit addresses this issue by revising the descriptions of these
parameters by using "Control..." rather than "Enable/Disable...".
1==enabled or 0==disabled can be communicated by the description of
default value such as "1 (enabled)" or "0 (disabled)".

Also update the description of KVM's default value for kvm-intel.nested
as it is enabled by default.

Signed-off-by: Yan-Jie Wang <yanjiewtw@gmail.com>
---
Changes in v2:
- Revise the descriptions based on Sean's suggesstion.
- Fix the wrong default value of kvm-intel.nested
---
 .../admin-guide/kernel-parameters.txt         | 53 ++++++++++---------
 1 file changed, 29 insertions(+), 24 deletions(-)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index 9e5bab29685f..450c9d3af3ed 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -2551,12 +2551,13 @@
 			If the value is 0 (the default), KVM will pick a period based
 			on the ratio, such that a page is zapped after 1 hour on average.
 
-	kvm-amd.nested=	[KVM,AMD] Allow nested virtualization in KVM/SVM.
-			Default is 1 (enabled)
+	kvm-amd.nested=	[KVM,AMD] Control nested virtualization feature in
+			KVM/SVM. Default is 1 (enabled).
 
-	kvm-amd.npt=	[KVM,AMD] Disable nested paging (virtualized MMU)
-			for all guests.
-			Default is 1 (enabled) if in 64-bit or 32-bit PAE mode.
+	kvm-amd.npt=	[KVM,AMD] Control KVM's use of Nested Page Tables,
+			a.k.a. Two-Dimensional Page Tables. Default is 1
+			(enabled). Disable by KVM if hardware lacks support
+			for NPT.
 
 	kvm-arm.mode=
 			[KVM,ARM] Select one of KVM/arm64's modes of operation.
@@ -2602,30 +2603,33 @@
 			Format: <integer>
 			Default: 5
 
-	kvm-intel.ept=	[KVM,Intel] Disable extended page tables
-			(virtualized MMU) support on capable Intel chips.
-			Default is 1 (enabled)
+	kvm-intel.ept=	[KVM,Intel] Control KVM's use of Extended Page Tables,
+			a.k.a. Two-Dimensional Page Tables.  Default is 1
+			(enabled). Disable by KVM if hardware lacks support
+			for EPT.
 
 	kvm-intel.emulate_invalid_guest_state=
-			[KVM,Intel] Disable emulation of invalid guest state.
-			Ignored if kvm-intel.enable_unrestricted_guest=1, as
-			guest state is never invalid for unrestricted guests.
-			This param doesn't apply to nested guests (L2), as KVM
-			never emulates invalid L2 guest state.
-			Default is 1 (enabled)
+			[KVM,Intel] Control whether to emulate invalid guest
+			state. Ignored if kvm-intel.enable_unrestricted_guest=1,
+			as guest state is never invalid for unrestricted
+			guests. This param doesn't apply to nested guests (L2),
+			as KVM never emulates invalid L2 guest state.
+			Default is 1 (enabled).
 
 	kvm-intel.flexpriority=
-			[KVM,Intel] Disable FlexPriority feature (TPR shadow).
-			Default is 1 (enabled)
+			[KVM,Intel] Control KVM's use of FlexPriority feature
+			(TPR shadow). Default is 1 (enabled). Disalbe by KVM if
+			hardware lacks support for it.
 
 	kvm-intel.nested=
-			[KVM,Intel] Enable VMX nesting (nVMX).
-			Default is 0 (disabled)
+			[KVM,Intel] Control nested virtualization feature in
+			KVM/VMX. Default is 1 (enabled).
 
 	kvm-intel.unrestricted_guest=
-			[KVM,Intel] Disable unrestricted guest feature
-			(virtualized real and unpaged mode) on capable
-			Intel chips. Default is 1 (enabled)
+			[KVM,Intel] Control KVM's use of unrestricted guest
+			feature (virtualized real and unpaged mode). Default
+			is 1 (enabled). Disable by KVM if EPT is disabled or
+			hardware lacks support for it.
 
 	kvm-intel.vmentry_l1d_flush=[KVM,Intel] Mitigation for L1 Terminal Fault
 			CVE-2018-3620.
@@ -2639,9 +2643,10 @@
 
 			Default is cond (do L1 cache flush in specific instances)
 
-	kvm-intel.vpid=	[KVM,Intel] Disable Virtual Processor Identification
-			feature (tagged TLBs) on capable Intel chips.
-			Default is 1 (enabled)
+	kvm-intel.vpid=	[KVM,Intel] Control KVM's use of Virtual Processor
+			Identification feature (tagged TLBs). Default is 1
+			(enabled). Disable by KVM if hardware lacks support
+			for it.
 
 	l1d_flush=	[X86,INTEL]
 			Control mitigation for L1D based snooping vulnerability.

base-commit: 865fdb08197e657c59e74a35fa32362b12397f58
-- 
2.34.1

