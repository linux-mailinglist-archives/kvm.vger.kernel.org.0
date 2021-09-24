Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1312417583
	for <lists+kvm@lfdr.de>; Fri, 24 Sep 2021 15:24:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345831AbhIXNZV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Sep 2021 09:25:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344160AbhIXNYx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Sep 2021 09:24:53 -0400
Received: from mail-wr1-x44a.google.com (mail-wr1-x44a.google.com [IPv6:2a00:1450:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65619C08EAF3
        for <kvm@vger.kernel.org>; Fri, 24 Sep 2021 05:54:20 -0700 (PDT)
Received: by mail-wr1-x44a.google.com with SMTP id x2-20020a5d54c2000000b0015dfd2b4e34so7997907wrv.6
        for <kvm@vger.kernel.org>; Fri, 24 Sep 2021 05:54:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=gAyjNp3rW7TPfI7//eqCH4vOMM/PWKliQsJ25oNVe/Q=;
        b=Mtapfc+tk4ahVVDoTy22nyqa+M+lz+QDn+kzdiAfRLfPa2zdGHqMbcoY8BzxnnT4Ce
         cWum2sC4qzxNiAgDgN71HY0fc+KrGPIdKsmx7vvfZMJZsyzXStHuKXPDLgBEQBtzZo1g
         nPsZmTTFPMZ14TmrBHdBoW8H21JEKZa6+PIstkjoUe2sPE8VjIIt/1QrqI1Fyry3T3so
         Y5Ktxzq+xh00yhwaDrMW1n9KcfbArC+SN8UsAc9PskULI7RXut4Jq6alNNq4sbo4IrwU
         NgwauBKAv5Xu2CQoPPkiCDedlkfh/ESAHLGwHqOMNyFIAj6sIFg5yUH+TRCyNYyRwJaO
         EGfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=gAyjNp3rW7TPfI7//eqCH4vOMM/PWKliQsJ25oNVe/Q=;
        b=f5sWP80cwXPpZJQ82CwtWUWhfDkluDcuPhSLMjpSL+GVOW/8CP7NohdgELOKKVfHEX
         ovCRM31UUMibypE/iLoAtR9smn8VTEVoHJFW3lylNY/kbWLIZOzNdM0M5TXntqsMgAEE
         ll+6KjKfnjb8tJrywG4FC/0c7sJV5/L/xFkIn4gdCU79PoZzrQhqQYwA056XDi8oCStp
         aFvIo3mCz+a0W8hBEJwtTEd/5JVB6OEq6MMY4MRWhiGsbw+6GD2oapGRy3IUhWJ2x4Ut
         dU0OAp0YUeyGamd5y2JlkPgKKbLaokQYhWdXL7IBkaUR+2QjIIRUBqAsiY2iXs6EvGe6
         HfOQ==
X-Gm-Message-State: AOAM531SdMTFnWqrIw7zgH84ePXd40XoqjBk/ckbGR1nWe6SY1T4uFvh
        A0HAkrRlaLqNNlBW3nIOELq/BFhgjw==
X-Google-Smtp-Source: ABdhPJxVUcAxVdEdzqLvk3tG7+vsf8Jt1WEATen5QyS1LkA6oMHpdXD0zU5b5uRnwhULCsb+glF03ab0xA==
X-Received: from tabba.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:482])
 (user=tabba job=sendgmr) by 2002:a05:600c:4642:: with SMTP id
 n2mr1902362wmo.39.1632488058999; Fri, 24 Sep 2021 05:54:18 -0700 (PDT)
Date:   Fri, 24 Sep 2021 13:53:37 +0100
In-Reply-To: <20210924125359.2587041-1-tabba@google.com>
Message-Id: <20210924125359.2587041-9-tabba@google.com>
Mime-Version: 1.0
References: <20210924125359.2587041-1-tabba@google.com>
X-Mailer: git-send-email 2.33.0.685.g46640cef36-goog
Subject: [RFC PATCH v1 08/30] KVM: arm64: add hypervisor state accessors
From:   Fuad Tabba <tabba@google.com>
To:     kvmarm@lists.cs.columbia.edu
Cc:     maz@kernel.org, will@kernel.org, james.morse@arm.com,
        alexandru.elisei@arm.com, suzuki.poulose@arm.com,
        mark.rutland@arm.com, christoffer.dall@arm.com, drjones@redhat.com,
        qperret@google.com, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kernel-team@android.com,
        tabba@google.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Part of the state in vcpu_arch is hypervisor-specific. To isolate
that state in future patches, start by creating accessors for
this state rather than by dereferencing vcpu.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/include/asm/kvm_host.h | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 097e5f533af9..280ee23dfc5a 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -373,6 +373,13 @@ struct kvm_vcpu_arch {
 	} steal;
 };
 
+/* Accessors for vcpu parameters related to the hypervistor state. */
+#define vcpu_hcr_el2(vcpu) (vcpu)->arch.hcr_el2
+#define vcpu_mdcr_el2(vcpu) (vcpu)->arch.mdcr_el2
+#define vcpu_vsesr_el2(vcpu) (vcpu)->arch.vsesr_el2
+#define vcpu_fault(vcpu) (vcpu)->arch.fault
+#define vcpu_flags(vcpu) (vcpu)->arch.flags
+
 /* Pointer to the vcpu's SVE FFR for sve_{save,load}_state() */
 #define vcpu_sve_pffr(vcpu) (kern_hyp_va((vcpu)->arch.sve_state) +	\
 			     sve_ffr_offset((vcpu)->arch.sve_max_vl))
-- 
2.33.0.685.g46640cef36-goog

