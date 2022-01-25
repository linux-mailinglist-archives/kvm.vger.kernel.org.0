Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8388849B36B
	for <lists+kvm@lfdr.de>; Tue, 25 Jan 2022 13:01:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1386609AbiAYL5U (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Jan 2022 06:57:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1386558AbiAYLwi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Jan 2022 06:52:38 -0500
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDDBEC061401;
        Tue, 25 Jan 2022 03:52:34 -0800 (PST)
Received: by mail-pf1-x436.google.com with SMTP id i17so2015685pfq.13;
        Tue, 25 Jan 2022 03:52:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=6ah5l1D0e53j/TNN2l2oD6uzzld/ChKHxACn/WjMnXw=;
        b=ZUOZzEiiIeoBmuueZJlIyuA5Yyl8fzNEoPX6viN5ap+oULD+C8EhJs5uKlNYvKIvVS
         NVtVp9Kxo/vEGUCXjjnQ5n4cBlRCmueBWheMhdXbTV7W4wLoaxL3cbrbSOag7TAq9yuP
         xkArWofc5Ajhx7SNuO85atzhs0P9rqljxgupnGeCnuKR9IBjVN+HbrW3OJX8MYo4WEif
         ydv4p1ehnYkKoWLom+SiOK794lgMXt+ONiANqxg+2vpd4Dm37sgAgRWgSpQYL4FY9kpd
         /FzilJ7tGPFpWuzs0Cnz/TEVPPxaO2MEyTcpyiMsQdbQnNQNLs18JWDnfjpOfyy1Ue4G
         thNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=6ah5l1D0e53j/TNN2l2oD6uzzld/ChKHxACn/WjMnXw=;
        b=uFaZWJdCNc1REiaebaPvf7eYbkimYzekvo64ZFnoo9ZWdG0mhXDkFiXF0lFXNfFvXP
         W4wrKoSiqHrouH9i7uPF2fJJNSjL4jisH32Sky6MPYCZVvPwz3Ep15WLu4YqaeYqr5OT
         +Z1TPXxmGV6cpvQu9Oj1nW9wk1dvIJ758SpUEJwwuw3pK9Iw1ZLfblp5ZFc6DjXHnq8n
         mvFx/IJCsZYkjqwbWyf49K9wBxwevRKFxrMqaCoGkKq4dwiomU/gFGIDyehSkFOj+WwU
         WJa/NJr04c7BvzRi9D2YYnuvxfUwkH1Xqb224IV+38ghQLUPr5B0JlZM+z3AAGd1GOZe
         UAkg==
X-Gm-Message-State: AOAM530ScspVgIW0XcNba7c0SgOAIwe31TOng/7c1YIfHZtY3l8FaQuT
        +4KI8LlkbLV46YP5+eg1t2cU/yvISQEMJQ==
X-Google-Smtp-Source: ABdhPJwSI5Uxzhc1kA5HdaNpZMdx4vlj5nYn1XV49bP01FNKLHZ+tYqXagIi8HvyIq2DGKUqlXoSXw==
X-Received: by 2002:a63:114:: with SMTP id 20mr8114462pgb.524.1643111554401;
        Tue, 25 Jan 2022 03:52:34 -0800 (PST)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id b4sm14353030pgq.75.2022.01.25.03.52.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Jan 2022 03:52:33 -0800 (PST)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Tian Kevin <kevin.tian@intel.com>,
        Jim Mattson <jmattson@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2] KVM: x86/cpuid: Exclude unpermitted xfeatures sizes at KVM_GET_SUPPORTED_CPUID
Date:   Tue, 25 Jan 2022 19:52:23 +0800
Message-Id: <20220125115223.33707-1-likexu@tencent.com>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Like Xu <likexu@tencent.com>

With the help of xstate_get_guest_group_perm(), KVM can exclude unpermitted
xfeatures in cpuid.0xd.0.eax, in which case the corresponding xfeatures
sizes should also be matched to the permitted xfeatures.

To fix this inconsistency, the permitted_xcr0 and permitted_xss are defined
consistently, which implies 'supported' plus certain permissions for this
task, and it also fixes cpuid.0xd.1.ebx and later leaf-by-leaf queries.

Fixes: 445ecdf79be0 ("kvm: x86: Exclude unpermitted xfeatures at KVM_GET_SUPPORTED_CPUID")
Signed-off-by: Like Xu <likexu@tencent.com>
---
v1 -> v2 Changelog:
- Drop the use of shadow variable; (Paolo)
- Define permitted_xss consistently; (Kevin)

Previous:
https://lore.kernel.org/kvm/20220124080251.60558-1-likexu@tencent.com/

 arch/x86/kvm/cpuid.c | 25 +++++++++++++------------
 1 file changed, 13 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 3902c28fb6cb..07844d15dfdf 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -887,13 +887,14 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
 		}
 		break;
 	case 0xd: {
-		u64 guest_perm = xstate_get_guest_group_perm();
+		u64 permitted_xcr0 = supported_xcr0 & xstate_get_guest_group_perm();
+		u64 permitted_xss = supported_xss;
 
-		entry->eax &= supported_xcr0 & guest_perm;
-		entry->ebx = xstate_required_size(supported_xcr0, false);
+		entry->eax &= permitted_xcr0;
+		entry->ebx = xstate_required_size(permitted_xcr0, false);
 		entry->ecx = entry->ebx;
-		entry->edx &= (supported_xcr0 & guest_perm) >> 32;
-		if (!supported_xcr0)
+		entry->edx &= permitted_xcr0 >> 32;
+		if (!permitted_xcr0)
 			break;
 
 		entry = do_host_cpuid(array, function, 1);
@@ -902,20 +903,20 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
 
 		cpuid_entry_override(entry, CPUID_D_1_EAX);
 		if (entry->eax & (F(XSAVES)|F(XSAVEC)))
-			entry->ebx = xstate_required_size(supported_xcr0 | supported_xss,
+			entry->ebx = xstate_required_size(permitted_xcr0 | permitted_xss,
 							  true);
 		else {
-			WARN_ON_ONCE(supported_xss != 0);
+			WARN_ON_ONCE(permitted_xss != 0);
 			entry->ebx = 0;
 		}
-		entry->ecx &= supported_xss;
-		entry->edx &= supported_xss >> 32;
+		entry->ecx &= permitted_xss;
+		entry->edx &= permitted_xss >> 32;
 
 		for (i = 2; i < 64; ++i) {
 			bool s_state;
-			if (supported_xcr0 & BIT_ULL(i))
+			if (permitted_xcr0 & BIT_ULL(i))
 				s_state = false;
-			else if (supported_xss & BIT_ULL(i))
+			else if (permitted_xss & BIT_ULL(i))
 				s_state = true;
 			else
 				continue;
@@ -929,7 +930,7 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
 			 * invalid sub-leafs.  Only valid sub-leafs should
 			 * reach this point, and they should have a non-zero
 			 * save state size.  Furthermore, check whether the
-			 * processor agrees with supported_xcr0/supported_xss
+			 * processor agrees with permitted_xcr0/permitted_xss
 			 * on whether this is an XCR0- or IA32_XSS-managed area.
 			 */
 			if (WARN_ON_ONCE(!entry->eax || (entry->ecx & 0x1) != s_state)) {
-- 
2.33.1

