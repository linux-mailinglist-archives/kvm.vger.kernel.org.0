Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D29D79F609
	for <lists+kvm@lfdr.de>; Thu, 14 Sep 2023 02:59:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233219AbjINA7m (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Sep 2023 20:59:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230033AbjINA7l (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Sep 2023 20:59:41 -0400
Received: from mail-qk1-x72a.google.com (mail-qk1-x72a.google.com [IPv6:2607:f8b0:4864:20::72a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BAF3193;
        Wed, 13 Sep 2023 17:59:37 -0700 (PDT)
Received: by mail-qk1-x72a.google.com with SMTP id af79cd13be357-770ef353b8fso30046585a.0;
        Wed, 13 Sep 2023 17:59:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1694653176; x=1695257976; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=vyIG8qUqPmvNMJFb0g0C2IH+k5z0grkX4aoQRyFdC1Y=;
        b=oltzm7sljHBOyvYSIRtFywtOZoY7txcSUutSw2t/nKvKlCY9lErxRENfFUYZe7kQRZ
         9/Uryql6tf6sj6CT5TxF9sp4rIaPUf9DA+QHTJ+FA1stemXgjR1w1AEUgNrd6IublwmG
         eLze11gaVHkUpXGGCPEKa29LUiNEyhFQLYGmN1D64sR9M9GN53v833/jXt17/dh/00aA
         KWtkl3tvsl7l45DVHLKaflnyuQDH0RN3i82eUL+5akwyK0TLvKZtyAOqjLXCRyQUk1iI
         4QK7FaBpzFw9HbT4DYdO82AHWNQQaU9bZGICGEVzt+O0IuLZHZ1TKTtWaLxVD5eRg8v8
         Mnug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694653176; x=1695257976;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vyIG8qUqPmvNMJFb0g0C2IH+k5z0grkX4aoQRyFdC1Y=;
        b=ZmrDsCfwA7XGjRh2F6hZPrtsqpwrCFcO0wTotwz4Bf19s6x6x8U6pvGlCJUlSQmpU9
         hqyUZV6JXw5Jo9sOOEOkVNturAQiiJyXMhzbNheXjsZ2aBAgxG/1qXez0wVn01Oo3olt
         jxYI+6aWtrbMmM9UzX+zi7ZwJ25RgoLqUd0M7zis6D46dwju2PfvozIyPk8VXTGv5Quc
         Ed6/9FMBFv1CCVbwTQ7teY1REu6euWZX+AwrYUNxGyvP9MFFEbghLjGIqnxDB3UK/zX+
         bpWDN/e92QYZarbbu3FU6aX3OjUCjrmRWepLHpSBjWFCbflKMTEdHM1dIqB7qtaApsk4
         RZZw==
X-Gm-Message-State: AOJu0Yyp7wfJdHgILJw8ZV2q8MfjsSUCnwjajo+xAsIzAdBzW2oOD+BA
        yC13c50Xd5vlYXVzHa811gzUlzeeRTxd8Q==
X-Google-Smtp-Source: AGHT+IH7nYN8HUUE1tDJ1zKgrYEuoVMOzTW7sQMoU3G7v6Ssx0u3efjFLCR8GbJ/oGCM0r/C+lPytA==
X-Received: by 2002:a05:620a:2a11:b0:767:18b5:f6d6 with SMTP id o17-20020a05620a2a1100b0076718b5f6d6mr5087220qkp.2.1694653175909;
        Wed, 13 Sep 2023 17:59:35 -0700 (PDT)
Received: from luigi.stachecki.net (pool-108-14-234-238.nycmny.fios.verizon.net. [108.14.234.238])
        by smtp.gmail.com with ESMTPSA id cz7-20020a05620a36c700b0076cda7eab11sm122794qkb.133.2023.09.13.17.59.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Sep 2023 17:59:35 -0700 (PDT)
From:   Tyler Stachecki <stachecki.tyler@gmail.com>
X-Google-Original-From: Tyler Stachecki <tstachecki@bloomberg.net>
To:     kvm@vger.kernel.org
Cc:     stachecki.tyler@gmail.com, leobras@redhat.com, seanjc@google.com,
        pbonzini@redhat.com, dgilbert@redhat.com, tglx@linutronix.de,
        mingo@redhat.com, dave.hansen@linux.intel.com, bp@alien8.de,
        Tyler Stachecki <tstachecki@bloomberg.net>,
        stable@vger.kernel.org
Subject: [PATCH] x86/kvm: Account for fpstate->user_xfeatures changes
Date:   Wed, 13 Sep 2023 21:00:03 -0400
Message-Id: <20230914010003.358162-1-tstachecki@bloomberg.net>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Live-migrations under qemu result in guest corruption when
the following three conditions are all met:

  * The source host CPU has capabilities that itself
    extend that of the guest CPU fpstate->user_xfeatures

  * The source kernel emits guest_fpu->user_xfeatures
    with respect to the host CPU (i.e. it *does not* have
    the "Fixes:" commit)

  * The destination kernel enforces that the xfeatures
    in the buffer given to KVM_SET_IOCTL are compatible
    with the guest CPU (i.e., it *does* have the "Fixes:"
    commit)

When these conditions are met, the semantical changes to
fpstate->user_features trigger a subtle bug in qemu that
results in qemu failing to put the XSAVE architectural
state into KVM.

qemu then both ceases to put the remaining (non-XSAVE) x86
architectural state into KVM and makes the fateful mistake
of resuming the guest anyways. This usually results in
immediate guest corruption, silent or not.

Due to the grave nature of this qemu bug, attempt to
retain behavior of old kernels by clamping the xfeatures
specified in the buffer given to KVM_SET_IOCTL such that
it aligns with the guests fpstate->user_xfeatures instead
of returning an error.

Fixes: ad856280ddea ("x86/kvm/fpu: Limit guest user_xfeatures to supported bits of XCR0")
Cc: stable@vger.kernel.org
Cc: Leonardo Bras <leobras@redhat.com>
Signed-off-by: Tyler Stachecki <tstachecki@bloomberg.net>
---
 arch/x86/kvm/x86.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 6c9c81e82e65..baad160b592f 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5407,11 +5407,21 @@ static void kvm_vcpu_ioctl_x86_get_xsave2(struct kvm_vcpu *vcpu,
 static int kvm_vcpu_ioctl_x86_set_xsave(struct kvm_vcpu *vcpu,
 					struct kvm_xsave *guest_xsave)
 {
+	union fpregs_state *ustate = (union fpregs_state *) guest_xsave->region;
+	u64 user_xfeatures = vcpu->arch.guest_fpu.fpstate->user_xfeatures;
+
 	if (fpstate_is_confidential(&vcpu->arch.guest_fpu))
 		return 0;
 
-	return fpu_copy_uabi_to_guest_fpstate(&vcpu->arch.guest_fpu,
-					      guest_xsave->region,
+	/*
+	 * In previous kernels, kvm_arch_vcpu_create() set the guest's fpstate
+	 * based on what the host CPU supported. Recent kernels changed this
+	 * and only accept ustate containing xfeatures that the guest CPU is
+	 * capable of supporting.
+	 */
+	ustate->xsave.header.xfeatures &= user_xfeatures;
+
+	return fpu_copy_uabi_to_guest_fpstate(&vcpu->arch.guest_fpu, ustate,
 					      kvm_caps.supported_xcr0,
 					      &vcpu->arch.pkru);
 }
-- 
2.30.2

