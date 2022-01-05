Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8387484D41
	for <lists+kvm@lfdr.de>; Wed,  5 Jan 2022 06:07:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236154AbiAEFHX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Jan 2022 00:07:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232448AbiAEFHW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Jan 2022 00:07:22 -0500
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BDDCC061761;
        Tue,  4 Jan 2022 21:07:22 -0800 (PST)
Received: by mail-pj1-x102f.google.com with SMTP id g11-20020a17090a7d0b00b001b2c12c7273so2839689pjl.0;
        Tue, 04 Jan 2022 21:07:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=HtUTiGpsTde1X5A1jivBo6b68WjtAAtIn2n2cSL/Q6E=;
        b=UhGqUlTLbLLlPrm9lgrdVcv8PlnfubKVVaRa5RUkPAKP0LPR56oy8D+Aldm5gikNNM
         nol2O4pxt+inNh3zD4SNYpARfZFqyXpZVHm61Y88c/zF78Or8PlUK+k+GCkRoP5FS2x9
         +uxsWvU47Ua37qXysTaLcdjPA5KdLwROjXLIkSsbppX7Mk5cMCdgYy70vbwcuxlqYYWu
         NduC8ZgSLXmVdpg802Ucm9n1z8JVVHXNY947GrC/WNriu1/ZykGP5zmUZykEkKJo1WyA
         +floNGFWQONvKXBmGRoTTjZsIKSGjoGRjDUiTP+Z+Z36yIIIZCuZkoxLD0hxzpGfEfiK
         499w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=HtUTiGpsTde1X5A1jivBo6b68WjtAAtIn2n2cSL/Q6E=;
        b=LJirXa0DLWYoIkPtFXWalXnMIGT3OpqKMfTDKZJgR0BvNh8PnL/Hb3UXfDVxGDNv6f
         aioeOjwXx1kkN2LGlVq+k+CYhnWeZ9/fpHpC4nLqZyZ7WKuM1Dr5geK9xblRDcj9ajXc
         QUfFIQsq2CgqUHkaAPiLYhszlmXvf/ZiFcBX8o/z8yUvJ782NicUP+Z7L0SmKHMJdnBO
         vYD7zxHfxTn4SmnU8io9+B+v7zLpEwDiBnV0jYMty1r1zHRrD+Gf/unfKT4XnRcy+PyL
         PSwOh3JZG/+ZVPqNVoUMGSTYxUemFrqu0iDw40YEc0kdbjpkbZ8f4SmorqAeXvySheX7
         Tqaw==
X-Gm-Message-State: AOAM533FZ4T0JI4FKBBFp3eY+D+cjFG6BzSs/eb1nJIp5Pj7qriWX5bq
        j4TFSdEuNXV2VDeeGlMau2M=
X-Google-Smtp-Source: ABdhPJyqdHf3V2rCKUBmS28AK9K1wA49eo7hlul6hZIn9Eh6HzYfiUOW1MsNmXwZtYCO6Hf0elhZuQ==
X-Received: by 2002:a17:903:11c9:b0:149:bef4:2d7d with SMTP id q9-20020a17090311c900b00149bef42d7dmr10950329plh.48.1641359241623;
        Tue, 04 Jan 2022 21:07:21 -0800 (PST)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id 93sm976441pjo.26.2022.01.04.21.07.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Jan 2022 21:07:21 -0800 (PST)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH RESEND] KVM: x86/pmu: Make top-down.slots event unavailable in supported leaf
Date:   Wed,  5 Jan 2022 13:07:11 +0800
Message-Id: <20220105050711.67280-1-likexu@tencent.com>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Like Xu <likexu@tencent.com>

When we choose to disable the fourth fixed counter TOPDOWN.SLOTS,
we need to also reduce the length of the 0AH.EBX bit vector, which
enumerates architecture performance monitoring events, and set
0AH.EBX.[bit 7] to 1 if the new value of EAX[31:24] is still > 7.

Fixes: 2e8cd7a3b8287 ("kvm: x86: limit the maximum number of vPMU fixed counters to 3")
Signed-off-by: Like Xu <likexu@tencent.com>
---
 arch/x86/kvm/cpuid.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 0b920e12bb6d..1f0131145296 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -782,6 +782,21 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
 		eax.split.mask_length = cap.events_mask_len;
 
 		edx.split.num_counters_fixed = min(cap.num_counters_fixed, MAX_FIXED_COUNTERS);
+
+		/*
+		 * The 8th Intel pre-defined architectural event (Topdown Slots) will be supported
+		 * if the 4th fixed counter exists && EAX[31:24] > 7 && EBX[7] = 0.
+		 *
+		 * Currently, KVM needs to set EAX[31:24] < 8 or EBX[7] == 1
+		 * to make this event unavailable in a consistent way.
+		 */
+		if (edx.split.num_counters_fixed < 4) {
+			if (eax.split.mask_length > 7)
+				eax.split.mask_length--;
+			if (eax.split.mask_length > 7)
+				cap.events_mask |= BIT_ULL(7);
+		}
+
 		edx.split.bit_width_fixed = cap.bit_width_fixed;
 		if (cap.version)
 			edx.split.anythread_deprecated = 1;
-- 
2.33.1

