Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00E4349023F
	for <lists+kvm@lfdr.de>; Mon, 17 Jan 2022 08:00:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233130AbiAQHAJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Jan 2022 02:00:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232184AbiAQHAI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Jan 2022 02:00:08 -0500
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA5F1C061574;
        Sun, 16 Jan 2022 23:00:07 -0800 (PST)
Received: by mail-pj1-x1032.google.com with SMTP id l21-20020a17090b079500b001b49df5c4dfso2749853pjz.2;
        Sun, 16 Jan 2022 23:00:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=IJGYiOOL+6CUqrzL1DWyP6i538pdaiTRGXfMxIypbx4=;
        b=SQOmKzE5qLd9atEF7c6ICsVd/f5pZySXamSt5bexMkFZxDX8MPWRQ8iyBNR3y4r8YJ
         T28OGncW226NldDD+N3pS6Sfp1ROGEcVKoeumFtoVRbxHaaeCpgNpLn7K6z0wsB/h2m8
         bOSZIW+WnM7/erCzYmkbF2CcBuJKmCJ5a5jiz+TaYqU0GybF3ne52Df8RbF91EnZldIu
         zg2Tum8yvOL9K5RvbuKAafOyl8rXxoRY+BKiPNzwq8deqivzL11NWe39DnGQKbwp7eDq
         XcsOQqFXQL6cDjhI8GUlhTXwsolsy1KVWYzUmfYLWaA5sdUpT2nfQM+tJdwlghNsm5SV
         5RTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=IJGYiOOL+6CUqrzL1DWyP6i538pdaiTRGXfMxIypbx4=;
        b=GThgX0tV/y/PQXXheVsSQh9Hlr0ZRi7wCLFO7W8RNyCgpN0Zw+ZpPIxy1JLKp/oHzU
         72+sVPHGCTSNI5LUoCHIKNfKbr56eP6ngfnTS7eaKNWaY85h7h96BHlHBahhGV1n2Sp1
         9Uw/8K3upUpzACzqo7Kx46yd9VDz/ibtLGDFLqkriV1Lycbf+DTIQGgIkkVtJAiKoqGe
         xxCCDUOZItpicAvlHldQMAry0X4T3PaMRJiJ6JN+/1IosH757sbmHc70QZWeKbYzG5Gi
         8WZA8eqquYOOdxfahZLQCxRqaK/93QUexMN3l14ugiiZ5eMrF/XBOPmMLsfe2hs1NkM9
         IFaw==
X-Gm-Message-State: AOAM530NTBzhmHeTTcxBVImAVQGjeWiOJZnr4KhHR6ygYjaPt8n6Xg8M
        IUsSh5JaWhcQ4uNl0UxfUss=
X-Google-Smtp-Source: ABdhPJyr1guEKgMePOqMXuJjqjUjwbfxwr+ht7XFTzzRRD5eavXA8v2bvVaiMaXLsySekzmV+ZQpIA==
X-Received: by 2002:a17:90a:156:: with SMTP id z22mr32537539pje.191.1642402807498;
        Sun, 16 Jan 2022 23:00:07 -0800 (PST)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id t25sm10752959pgv.9.2022.01.16.23.00.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 16 Jan 2022 23:00:07 -0800 (PST)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Jing Liu <jing2.liu@intel.com>,
        Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] KVM: x86/cpuid: Stop exposing unknown AMX Tile Palettes and accelerator units
Date:   Mon, 17 Jan 2022 14:59:57 +0800
Message-Id: <20220117065957.65335-1-likexu@tencent.com>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Like Xu <likexu@tencent.com>

Guest enablement of Intel AMX requires a good co-work from both host and
KVM, which means that KVM should take a more safer approach to avoid
the accidental inclusion of new unknown AMX features, even though it's
designed to be an extensible architecture.

Per current spec, Intel CPUID Leaf 1EH sub-leaf 1 and above are reserved,
other bits in leaves 0x1d and 0x1e marked as "Reserved=0" shall be strictly
limited by definition for reporeted KVM_GET_SUPPORTED_CPUID.

Fixes: 690a757d610e ("kvm: x86: Add CPUID support for Intel AMX")
Signed-off-by: Like Xu <likexu@tencent.com>
---
 arch/x86/kvm/cpuid.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index c55e57b30e81..3fde6610d314 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -661,7 +661,6 @@ static struct kvm_cpuid_entry2 *do_host_cpuid(struct kvm_cpuid_array *array,
 	case 0x17:
 	case 0x18:
 	case 0x1d:
-	case 0x1e:
 	case 0x1f:
 	case 0x8000001d:
 		entry->flags |= KVM_CPUID_FLAG_SIGNIFCANT_INDEX;
@@ -936,21 +935,26 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
 		break;
 	/* Intel AMX TILE */
 	case 0x1d:
+		entry->ebx = entry->ecx = entry->edx = 0;
 		if (!kvm_cpu_cap_has(X86_FEATURE_AMX_TILE)) {
-			entry->eax = entry->ebx = entry->ecx = entry->edx = 0;
+			entry->eax = 0;
 			break;
 		}
 
+		entry->eax = min(entry->eax, 1u);
 		for (i = 1, max_idx = entry->eax; i <= max_idx; ++i) {
 			if (!do_host_cpuid(array, function, i))
 				goto out;
 		}
 		break;
-	case 0x1e: /* TMUL information */
+	/* TMUL Information */
+	case 0x1e:
+		entry->eax = entry->ecx = entry->edx = 0;
 		if (!kvm_cpu_cap_has(X86_FEATURE_AMX_TILE)) {
-			entry->eax = entry->ebx = entry->ecx = entry->edx = 0;
+			entry->ebx = 0;
 			break;
 		}
+		entry->ebx &= 0xffffffu;
 		break;
 	case KVM_CPUID_SIGNATURE: {
 		const u32 *sigptr = (const u32 *)KVM_SIGNATURE;
-- 
2.33.1

