Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A0A744E432
	for <lists+kvm@lfdr.de>; Fri, 12 Nov 2021 10:51:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234859AbhKLJyo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Nov 2021 04:54:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234833AbhKLJyn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 Nov 2021 04:54:43 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2AD0C061766;
        Fri, 12 Nov 2021 01:51:52 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id x7so6251766pjn.0;
        Fri, 12 Nov 2021 01:51:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Xqw+uXnJ8YFsdiLIRJgGFtUeXTMcVMZ+IXvH1BdJFVA=;
        b=AhLgNzVKDy8dcajLZ9BX2TZhqDpMwrrdQK3tsf2YgexxICeGVEqEEUuZwVpJAf3xwG
         Nx+lUA1ijHUvYBoOh/chNNFj+iA/jIeL0LWHyC2fCy2Dlr8bOhv3k62AKlHqXAibDld3
         sNmVZk3xkhXuisU3hc7te4TrgfyCBLD7Ws7zGd4dol0cIfcF9cyDhD7O9ciq8sMXJAf/
         X1f1j8My4dc/GxQ6hxv3mUOZdNy6DmbEgMiY1umN8K4vVmElh1MYrIrh9IragRIVJoIR
         WriCh3kHDTb34npWhIndnZeZLYBGQXPKvVWrwv3k67slmvlz7PlqSEkwk2xVQzBy0tJU
         ynxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Xqw+uXnJ8YFsdiLIRJgGFtUeXTMcVMZ+IXvH1BdJFVA=;
        b=oW9f1rF3aZ7KK21JelP4xybdhgBaUW6dXRma1sIhxDOIq+cjP2l+v5BStTUcRZJnp3
         8Wgh322dZWL61L99jHppeAb/pzz7QASxdtQVeiDrkFth7oTpQuxSBbpPCRdP1hqp8xpm
         NOgsvyGyaIx5SCJOEXuBxOrXYgz1HkyCIsO1Dzh18/EKUsK9oepH/TePV9fp29QM4dUT
         w7O/m27J/jh0yFqbgvosFX1dmmhGDIftt511gNUr9pEb0jlal7hMmFgdnW7JGRSuKXCb
         hooCumCHuv6+A+kE5muwjlEDZi76+v5L9Q7f+4qXLXdsOgex25lQ0UF3xEnTdFof1YSu
         c/yw==
X-Gm-Message-State: AOAM532nW8gXSDBRzZqxdPZ6ETC8vEdasYkC3l098GODN1t8hTTLaJ+Q
        HKPqk7FGw2+CtjWd9MFjdJaDrz/mxwE=
X-Google-Smtp-Source: ABdhPJx3MB2QnMZjTzvN/sdlx/XHCbAPJGz5xxJ55UEAYw+OlVwWVPbfN5Bsn79Wbv0YWtboMv1UpA==
X-Received: by 2002:a17:90a:bb84:: with SMTP id v4mr35014154pjr.4.1636710712347;
        Fri, 12 Nov 2021 01:51:52 -0800 (PST)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id f3sm5799403pfg.167.2021.11.12.01.51.49
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 12 Nov 2021 01:51:51 -0800 (PST)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Like Xu <likexu@tencent.com>
Subject: [PATCH 1/7] KVM: x86/pmu: Make top-down.slots event unavailable in supported leaf
Date:   Fri, 12 Nov 2021 17:51:33 +0800
Message-Id: <20211112095139.21775-2-likexu@tencent.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211112095139.21775-1-likexu@tencent.com>
References: <20211112095139.21775-1-likexu@tencent.com>
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
 arch/x86/kvm/cpuid.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 2d70edb0f323..bbf8cf3f43b0 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -746,6 +746,20 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
 		eax.split.mask_length = cap.events_mask_len;
 
 		edx.split.num_counters_fixed = min(cap.num_counters_fixed, MAX_FIXED_COUNTERS);
+
+		/*
+		 * The 8th architectural event (top-down slots) will be supported
+		 * if the 4th fixed counter exists && EAX[31:24] > 7 && EBX[7] = 0.
+		 *
+		 * For now, KVM needs to make this event unavailable.
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
2.33.0

