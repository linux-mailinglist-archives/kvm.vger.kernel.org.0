Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C5224DE1E3
	for <lists+kvm@lfdr.de>; Fri, 18 Mar 2022 20:39:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240384AbiCRTkO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Mar 2022 15:40:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240371AbiCRTkL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Mar 2022 15:40:11 -0400
Received: from mail-io1-xd4a.google.com (mail-io1-xd4a.google.com [IPv6:2607:f8b0:4864:20::d4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B70EB10CF36
        for <kvm@vger.kernel.org>; Fri, 18 Mar 2022 12:38:52 -0700 (PDT)
Received: by mail-io1-xd4a.google.com with SMTP id z10-20020a056602080a00b00645b9fdc630so5699007iow.5
        for <kvm@vger.kernel.org>; Fri, 18 Mar 2022 12:38:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=wuK4ueNqZP0GzZsEOqe508HJuzt+R9wh2IWRVsBTI30=;
        b=DX/hQhQIL3T3in9mXK43MOUUG88eK+JlLFCWRmC0FpLYM4vyGZCwfBMTRtYjlueoDI
         cCntMu+NW9lzYQeW6XlbliSnyHGflRbaI44DbHPEKkHgRduAcBd9eaqAZA7S5/vBBusF
         UUzoE/U+TtgoeRR7xGpRiuKpA+Ggx1ybZWjgBcpsLUHkXNfBKg04wA5ho5dCPF+g/zj6
         04DCrGzhgUTStF/M0Zkx9/UzD6t70s33hNUXCT6V8au2ICW7TPX4vcQ9p5vluvLLgbXA
         KHSK/BfpfyQFOYHVdpXVDR/IoWYwnAhaBsuYeFGY+XVCOzdOenH2mSnWeNwg0VYZf8la
         yYxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=wuK4ueNqZP0GzZsEOqe508HJuzt+R9wh2IWRVsBTI30=;
        b=F0NI3fRw4pX1tr4CuZMhSzZNVv5q/q/VQt8DOvZ7D6Q5G1WGgZ6i5H7i7b0T1po3fm
         kfkifahsTBfyyr2liGxwiAXKLd3pxzY4UK4cv/EUhENdSG/nVyx7TrStRCvRFY0oDBp+
         zmhC0+w5MyLOD4Fk8BYRYBd58bjozoar3PgEeJxznf2YmhrRaYUmCMKQj5zSyrWG0wMe
         fOXBkigOgB4PKic2AJOGpE41KWPaEi/V+yeTHibm7Sdd3ssIQ+6yDtM0NV0uWrcb95GP
         f1E2C2ppupF3h7iquT1Z1NfnosAk958ISzp4FgKm88a3Gn9Lj0dmOlPr51xAEfnjTbbj
         5Lpg==
X-Gm-Message-State: AOAM531lJD1bqU/f80RC5HWiGJ8lAvXuR23E7kX2e9WSC+0e8vbGEJ0c
        Udu8FtdH0wNUmKkE3KqH2Bfrljncpak=
X-Google-Smtp-Source: ABdhPJz9kr+l6ckzIE00y1HiGRsJeWLm1xQMEM8JkI13iYPFP4zi1a2CA2eGif9AMiNeTCZHstmnwiHQldE=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a92:7106:0:b0:2c6:3167:ce83 with SMTP id
 m6-20020a927106000000b002c63167ce83mr5228453ilc.138.1647632332153; Fri, 18
 Mar 2022 12:38:52 -0700 (PDT)
Date:   Fri, 18 Mar 2022 19:38:31 +0000
In-Reply-To: <20220318193831.482349-1-oupton@google.com>
Message-Id: <20220318193831.482349-3-oupton@google.com>
Mime-Version: 1.0
References: <20220318193831.482349-1-oupton@google.com>
X-Mailer: git-send-email 2.35.1.894.gb6a874cedc-goog
Subject: [PATCH 2/2] KVM: arm64: Actually prevent SMC64 SYSTEM_RESET2 from AArch32
From:   Oliver Upton <oupton@google.com>
To:     kvmarm@lists.cs.columbia.edu
Cc:     kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-arm-kernel@lists.infradead.org,
        Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Will Deacon <will@kernel.org>, Oliver Upton <oupton@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The SMCCC does not allow the SMC64 calling convention to be used from
AArch32. While KVM checks to see if the calling convention is allowed in
PSCI_1_0_FN_PSCI_FEATURES, it does not actually prevent calls to
unadvertised PSCI v1.0+ functions.

Check to see if the requested function is allowed from the guest's
execution state. Deny the call if it is not.

Fixes: d43583b890e7 ("KVM: arm64: Expose PSCI SYSTEM_RESET2 call to the guest")
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Oliver Upton <oupton@google.com>
---
 arch/arm64/kvm/psci.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/arm64/kvm/psci.c b/arch/arm64/kvm/psci.c
index cd3ee947485f..0d771468b708 100644
--- a/arch/arm64/kvm/psci.c
+++ b/arch/arm64/kvm/psci.c
@@ -318,6 +318,10 @@ static int kvm_psci_1_x_call(struct kvm_vcpu *vcpu, u32 minor)
 	if (minor > 1)
 		return -EINVAL;
 
+	val = kvm_psci_check_allowed_function(vcpu, psci_fn);
+	if (val)
+		goto out;
+
 	switch(psci_fn) {
 	case PSCI_0_2_FN_PSCI_VERSION:
 		val = minor == 0 ? KVM_ARM_PSCI_1_0 : KVM_ARM_PSCI_1_1;
@@ -378,6 +382,7 @@ static int kvm_psci_1_x_call(struct kvm_vcpu *vcpu, u32 minor)
 		return kvm_psci_0_2_call(vcpu);
 	}
 
+out:
 	smccc_set_retval(vcpu, val, 0, 0, 0);
 	return ret;
 }
-- 
2.35.1.894.gb6a874cedc-goog

