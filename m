Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3101D488FD7
	for <lists+kvm@lfdr.de>; Mon, 10 Jan 2022 06:41:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238805AbiAJFlN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Jan 2022 00:41:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238757AbiAJFlM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Jan 2022 00:41:12 -0500
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CAABC06173F
        for <kvm@vger.kernel.org>; Sun,  9 Jan 2022 21:41:12 -0800 (PST)
Received: by mail-pj1-x1049.google.com with SMTP id y15-20020a17090a600f00b001b3501d9e7eso9541951pji.8
        for <kvm@vger.kernel.org>; Sun, 09 Jan 2022 21:41:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=P1aAJUJH4MNJA7hqf+LRqj2aY6nDmgn4ybYnyTkArAE=;
        b=DKYr9uQS09X33zIc7+1zVb3NQ0xRf8HBTMLLm3p4pinup+CxLE+HbHLqhHvzqvqAb3
         olhmXPyqbPsUCCdHiJUGtosE19JLvR49S1qjZI4NX924Y68uziCJNmqT7LElQs3CUgru
         ExwQbM7Qg6Bp7LwtNaXcprLPD7B9xYFoOVH2UWJDlxBXG+XmnTWYmM1BLt8KxaIs0Ln/
         W4dqLxfV+V9VxkGMAIITblVgrtK4ZoaKN54r589zJ60edJKeaDB8mrTHaHEhBl8zRdZ5
         R3D+YC4m8EYrXYfBL75jWzbnqUsG/7N57JvFqLytLroLG8h0FO7JdV6M7gHFF0CP0/Lb
         9J2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=P1aAJUJH4MNJA7hqf+LRqj2aY6nDmgn4ybYnyTkArAE=;
        b=byipa7fZXC81zhQfgzrf+QO60813s1OmoAYw8G2CydFAtMYLaEJn4Iw4v32yLyCaU3
         X3U0C407cvlBRKunePVLQSmq6W3u9RcnqjiUoXF57CU5mekFgDn6wfFrCvVXmQxWInsl
         99i1/Qy7f1RaJHU3q++TRWDwemziUejiqci73Y1dRj2hGH3mcjOQdyTfkjpX5YZqwKt3
         uzeAWh26XuizxTfbHVV+t47RyT5GQNaglzbMBmyAgd1rXwPvywwiEqCWxLu7tQ5kpbK5
         hcqpP5cpAevaQLUvlQPeNTFBkixf5qby2apw7O5n3yr8ylO71vvxN2m6h6jlgoWH8v2v
         3aNw==
X-Gm-Message-State: AOAM5321GpujtkA0LYmSdmS/tFL1HG5towjAKuHjNk4xCM8o8gly736v
        BUEnF4V48f2N96oowNMSC50MZFzryDc=
X-Google-Smtp-Source: ABdhPJy2ff3+Ra0eAAdVIR8qPPRFVBp537t4vFeJtOPbXf4dGRZKqRvR8mgwpxO5W3cOouanq7W4upyND6M=
X-Received: from reiji-vws-sp.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3d59])
 (user=reijiw job=sendgmr) by 2002:a05:6a00:d64:b0:4ba:cb6f:87e0 with SMTP id
 n36-20020a056a000d6400b004bacb6f87e0mr74125375pfv.72.1641793271719; Sun, 09
 Jan 2022 21:41:11 -0800 (PST)
Date:   Sun,  9 Jan 2022 21:40:41 -0800
Message-Id: <20220110054042.1079932-1-reijiw@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.34.1.575.g55b058a8bb-goog
Subject: [PATCH 1/2] KVM: arm64: mixed-width check should be skipped for
 uninitialized vCPUs
From:   Reiji Watanabe <reijiw@google.com>
To:     Marc Zyngier <maz@kernel.org>, kvmarm@lists.cs.columbia.edu
Cc:     kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Will Deacon <will@kernel.org>, Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Oliver Upton <oupton@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        Reiji Watanabe <reijiw@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

vcpu_allowed_register_width() checks if all the VCPUs are either
all 32bit or all 64bit.  Since the checking is done even for vCPUs
that are not initialized (KVM_ARM_VCPU_INIT has not been done) yet,
the non-initialized vCPUs are erroneously treated as 64bit vCPU,
which causes the function to incorrectly detect a mixed-width VM.

Fix vcpu_allowed_register_width() to skip the check for vCPUs that
are not initialized yet.

Fixes: 66e94d5cafd4 ("KVM: arm64: Prevent mixed-width VM creation")
Signed-off-by: Reiji Watanabe <reijiw@google.com>
---
 arch/arm64/kvm/reset.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
index 426bd7fbc3fd..ef78bbc7566a 100644
--- a/arch/arm64/kvm/reset.c
+++ b/arch/arm64/kvm/reset.c
@@ -180,8 +180,19 @@ static bool vcpu_allowed_register_width(struct kvm_vcpu *vcpu)
 	if (kvm_has_mte(vcpu->kvm) && is32bit)
 		return false;
 
+	/*
+	 * Make sure vcpu->arch.target setting is visible from others so
+	 * that the width consistency checking between two vCPUs is done
+	 * by at least one of them at KVM_ARM_VCPU_INIT.
+	 */
+	smp_mb();
+
 	/* Check that the vcpus are either all 32bit or all 64bit */
 	kvm_for_each_vcpu(i, tmp, vcpu->kvm) {
+		/* Skip if KVM_ARM_VCPU_INIT is not done for the vcpu yet */
+		if (tmp->arch.target == -1)
+			continue;
+
 		if (vcpu_has_feature(tmp, KVM_ARM_VCPU_EL1_32BIT) != is32bit)
 			return false;
 	}

base-commit: df0cc57e057f18e44dac8e6c18aba47ab53202f9
-- 
2.34.1.575.g55b058a8bb-goog

