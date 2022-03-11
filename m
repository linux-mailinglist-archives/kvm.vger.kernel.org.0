Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 966D64D682A
	for <lists+kvm@lfdr.de>; Fri, 11 Mar 2022 18:57:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350549AbiCKR6x (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Mar 2022 12:58:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350472AbiCKR6t (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Mar 2022 12:58:49 -0500
Received: from mail-io1-xd4a.google.com (mail-io1-xd4a.google.com [IPv6:2607:f8b0:4864:20::d4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C62F972D8
        for <kvm@vger.kernel.org>; Fri, 11 Mar 2022 09:57:43 -0800 (PST)
Received: by mail-io1-xd4a.google.com with SMTP id g11-20020a056602072b00b00645cc0735d7so6791052iox.1
        for <kvm@vger.kernel.org>; Fri, 11 Mar 2022 09:57:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=BxxrnSwrIA4lSZ5dK5jxyr2r2tLhZUFOrxcbnlilois=;
        b=fa5WoWeDUYBwu4AqAKpVBlulmdk6ITEQVYZONtJ2u9pcPIxaUyOx/pOBQgOFg52Yd/
         wSfGcWikT539Mu8oowRqbz3fzCMwnwM2i5FeKo6/JzeMJsuGnlAwC+RArs0TelINjAXJ
         YiiylZhsdD+TKZvFRp2bvcQju/VH3KxGC+y7ml99Qp85+xH7mQOVUVbQSpIhRWsaekAN
         zUx51OPbUCnvBVDxI6VrdMmWwvrjuDqtvEB+rxlLXPR1SULdF0qUS6NAVJnqAB18H1g1
         DwvvD2Doyg3jUEWe2BlVwIkjcpUQlP74u15eK66wr6aSPlw3R/xOQ6q7VbMENibsurOl
         iEYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=BxxrnSwrIA4lSZ5dK5jxyr2r2tLhZUFOrxcbnlilois=;
        b=oCaFnXkZTcvsy6nvd5E1DtANhgZ8YXZ2BLaBeI8AuqJvZ5hBDVJAntnrnaC5vG8Rwf
         ZSohyXBka6k05fgQtUDTeGO7RYoBsPR2fCt1p/ZSuP5snasvsx9GlPa4UBwr2yvCGmrX
         NKzFsmZyKK8yfYukE934B9ev0NLpdTlsJalDHxG2EMLJdVJD6rNAWcMaWUZ/CwpFKicK
         jBiQouwSRjvR2cGNW2nRHTGkhzbn7YVomdHukc3pDcnEEg0Ywn9/d5+3XKFK+Dlga9bb
         tnA/PNsMssVK7FHVdppm9xEYRSG51dYfUelkKr+YXZK/IZM5yMyDG8oD2tJIxfYSNjVz
         CYow==
X-Gm-Message-State: AOAM533sdKZ6rWX+9AAKR6TsZ27TLloPGtvIIVQD+rbgctZxExPbdETD
        xOXEl3eOfqNJnk+qke8rj0IZPacea7A=
X-Google-Smtp-Source: ABdhPJwX1T89M6pC5yjyrmOZYn4413egwXefNOi34Uw2IPjEjKr6OBMM3S5JvF/Oiv1+jz9CqWb3dK8SDTQ=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a05:6638:2388:b0:314:1ec0:b012 with SMTP id
 q8-20020a056638238800b003141ec0b012mr9295720jat.224.1647021462801; Fri, 11
 Mar 2022 09:57:42 -0800 (PST)
Date:   Fri, 11 Mar 2022 17:57:15 +0000
In-Reply-To: <20220311175717.616958-1-oupton@google.com>
Message-Id: <20220311175717.616958-4-oupton@google.com>
Mime-Version: 1.0
References: <20220311174001.605719-1-oupton@google.com> <20220311175717.616958-1-oupton@google.com>
X-Mailer: git-send-email 2.35.1.723.g4982287a31-goog
Subject: [RFC PATCH kvmtool 3/5] ARM: Stash vcpu_init in the vCPU structure
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
        Will Deacon <will@kernel.org>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Oliver Upton <oupton@google.com>
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

A subsequent change to kvmtool will require that a vCPU be reset more
than once. Derive a valid target/feature set exactly once and stash that
for later use.

Signed-off-by: Oliver Upton <oupton@google.com>
---
 arm/include/arm-common/kvm-cpu-arch.h | 18 +++++++++---------
 arm/kvm-cpu.c                         |  2 +-
 2 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/arm/include/arm-common/kvm-cpu-arch.h b/arm/include/arm-common/kvm-cpu-arch.h
index 923d2c4..4027afe 100644
--- a/arm/include/arm-common/kvm-cpu-arch.h
+++ b/arm/include/arm-common/kvm-cpu-arch.h
@@ -10,18 +10,18 @@ struct kvm;
 struct kvm_cpu {
 	pthread_t	thread;
 
-	unsigned long	cpu_id;
-	unsigned long	cpu_type;
-	const char	*cpu_compatible;
+	unsigned long		cpu_id;
+	struct kvm_vcpu_init	init;
+	const char		*cpu_compatible;
 
-	struct kvm	*kvm;
-	int		vcpu_fd;
-	struct kvm_run	*kvm_run;
+	struct kvm		*kvm;
+	int			vcpu_fd;
+	struct kvm_run		*kvm_run;
 	struct kvm_cpu_task	*task;
 
-	u8		is_running;
-	u8		paused;
-	u8		needs_nmi;
+	u8			is_running;
+	u8			paused;
+	u8			needs_nmi;
 
 	struct kvm_coalesced_mmio_ring	*ring;
 
diff --git a/arm/kvm-cpu.c b/arm/kvm-cpu.c
index 6a2408c..1ea56bb 100644
--- a/arm/kvm-cpu.c
+++ b/arm/kvm-cpu.c
@@ -128,7 +128,7 @@ struct kvm_cpu *kvm_cpu__arch_init(struct kvm *kvm, unsigned long cpu_id)
 	/* Populate the vcpu structure. */
 	vcpu->kvm		= kvm;
 	vcpu->cpu_id		= cpu_id;
-	vcpu->cpu_type		= vcpu_init.target;
+	vcpu->init		= vcpu_init;
 	vcpu->cpu_compatible	= target->compatible;
 	vcpu->is_running	= true;
 
-- 
2.35.1.723.g4982287a31-goog

