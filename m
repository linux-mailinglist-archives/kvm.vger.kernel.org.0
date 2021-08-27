Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AEF743F97FC
	for <lists+kvm@lfdr.de>; Fri, 27 Aug 2021 12:18:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244889AbhH0KRR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Aug 2021 06:17:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244890AbhH0KRQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Aug 2021 06:17:16 -0400
Received: from mail-qt1-x84a.google.com (mail-qt1-x84a.google.com [IPv6:2607:f8b0:4864:20::84a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6845EC061757
        for <kvm@vger.kernel.org>; Fri, 27 Aug 2021 03:16:27 -0700 (PDT)
Received: by mail-qt1-x84a.google.com with SMTP id k4-20020ac85fc4000000b0029e6247e3edso481953qta.19
        for <kvm@vger.kernel.org>; Fri, 27 Aug 2021 03:16:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=7Wr1c8QdaWfV4IkzMvbq8rsuOgcUfrUVwpNW94s4KlQ=;
        b=jqTiY84bDwyDnYgeOBntMKkUrRKsSuLdDybsls1ckTi72mQrqU9MJHyU/YHjN3RicM
         ZdnuhjDg9QBmBra4754W5lwhvDbBm5+6q4dtreCVPQlcr/1npGJ/RdxdozMwZE5TVDHu
         p1EUx7UVsQ+e7DHonBMh4dsY5MxbNWsVuhYebKjcE227rS5y4YezB0dZ2lpPnvdYd0tI
         IEIcprf4+8WRH4GN0BLj1D3OY3mj4nRF+nmpLQegsaK6y0Jpq80xbPSDmYQA7HTAAwtS
         vBSdw4thyzmlWvQH2nzcCVNdKvdw+CBLxDOs8SBqeBvjE8M7yvIwhDakTm4Qbzhn+Z/W
         nmsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=7Wr1c8QdaWfV4IkzMvbq8rsuOgcUfrUVwpNW94s4KlQ=;
        b=PI595KKnIhk5sQ7JUySCOJFFQlLeKsraLhkFeXD5TmXEpn5+e3kMDpvCyzJp+oKnsa
         GeCgzC2+P8TWlFoiouaIGZIlZh0N86BAqY0StB5cINvCdj9LQ1TcN9SzGSNCdKh7DJB+
         5ioGftyX6LqRFbbKyACsGr5yn7Lsl0ycldK/1qMc5R0aegLTUhlho6UsqqH/9xNfbBq3
         GzTBJewvbrJxk4uUt6Bau36hCysOJdQ2q3pRGEAQnaLwqTVzmA1olFSTrrEOTLLMnG3s
         qDHS0nBwSbpHWeUlnPrN+PgeUjIq7QHmpx/bjywjET0HhjSmrasOc2HIiu11pZyt0ZaD
         ek1A==
X-Gm-Message-State: AOAM531+dXF7EddJCXKXk5zd5zn6bp91MfNGd9oRcfTJXHFlTMwl1cvv
        cb/u2c5EgcxmBWL4nZlwdMIgABU7Rw==
X-Google-Smtp-Source: ABdhPJxr+OmFFSWemlsehudkURr3Vn6uvi0dUeFRBVF03SxZL/KBLtu9Ua2mp8cnp0Y5EA20Atj1oYsufg==
X-Received: from tabba.c.googlers.com ([fda3:e722:ac3:10:28:9cb1:c0a8:482])
 (user=tabba job=sendgmr) by 2002:a0c:aac3:: with SMTP id g3mr9077497qvb.14.1630059386604;
 Fri, 27 Aug 2021 03:16:26 -0700 (PDT)
Date:   Fri, 27 Aug 2021 11:16:08 +0100
In-Reply-To: <20210827101609.2808181-1-tabba@google.com>
Message-Id: <20210827101609.2808181-8-tabba@google.com>
Mime-Version: 1.0
References: <20210827101609.2808181-1-tabba@google.com>
X-Mailer: git-send-email 2.33.0.259.gc128427fd7-goog
Subject: [PATCH v5 7/8] KVM: arm64: Trap access to pVM restricted features
From:   Fuad Tabba <tabba@google.com>
To:     kvmarm@lists.cs.columbia.edu
Cc:     maz@kernel.org, will@kernel.org, james.morse@arm.com,
        alexandru.elisei@arm.com, suzuki.poulose@arm.com,
        mark.rutland@arm.com, christoffer.dall@arm.com,
        pbonzini@redhat.com, drjones@redhat.com, oupton@google.com,
        qperret@google.com, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kernel-team@android.com,
        tabba@google.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Trap accesses to restricted features for VMs running in protected
mode.

Access to feature registers are emulated, and only supported
features are exposed to protected VMs.

Accesses to restricted registers as well as restricted
instructions are trapped, and an undefined exception is injected
into the protected guests, i.e., with EC = 0x0 (unknown reason).
This EC is the one used, according to the Arm Architecture
Reference Manual, for unallocated or undefined system registers
or instructions.

Only affects the functionality of protected VMs. Otherwise,
should not affect non-protected VMs when KVM is running in
protected mode.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/hyp/nvhe/switch.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/switch.c
index 41f05bf88f61..fe0c3833ec66 100644
--- a/arch/arm64/kvm/hyp/nvhe/switch.c
+++ b/arch/arm64/kvm/hyp/nvhe/switch.c
@@ -171,8 +171,23 @@ static const exit_handler_fn hyp_exit_handlers[] = {
 	[ESR_ELx_EC_PAC]		= kvm_hyp_handle_ptrauth,
 };
 
+static const exit_handler_fn pvm_exit_handlers[] = {
+	[0 ... ESR_ELx_EC_MAX]		= NULL,
+	[ESR_ELx_EC_CP15_32]		= kvm_hyp_handle_cp15,
+	[ESR_ELx_EC_CP15_64]		= kvm_hyp_handle_cp15,
+	[ESR_ELx_EC_SYS64]		= kvm_handle_pvm_sys64,
+	[ESR_ELx_EC_SVE]		= kvm_handle_pvm_restricted,
+	[ESR_ELx_EC_FP_ASIMD]		= kvm_handle_pvm_fpsimd,
+	[ESR_ELx_EC_IABT_LOW]		= kvm_hyp_handle_iabt_low,
+	[ESR_ELx_EC_DABT_LOW]		= kvm_hyp_handle_dabt_low,
+	[ESR_ELx_EC_PAC]		= kvm_hyp_handle_ptrauth,
+};
+
 const exit_handler_fn *kvm_get_exit_handler_array(struct kvm *kvm)
 {
+	if (unlikely(kvm_vm_is_protected(kvm)))
+		return pvm_exit_handlers;
+
 	return hyp_exit_handlers;
 }
 
-- 
2.33.0.259.gc128427fd7-goog

