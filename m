Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1960E4D3007
	for <lists+kvm@lfdr.de>; Wed,  9 Mar 2022 14:35:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233183AbiCINf5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Mar 2022 08:35:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233182AbiCINfz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Mar 2022 08:35:55 -0500
Received: from mail-wm1-x349.google.com (mail-wm1-x349.google.com [IPv6:2a00:1450:4864:20::349])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4EC913CA0C
        for <kvm@vger.kernel.org>; Wed,  9 Mar 2022 05:34:56 -0800 (PST)
Received: by mail-wm1-x349.google.com with SMTP id o21-20020a05600c511500b003818c4b98b5so823093wms.0
        for <kvm@vger.kernel.org>; Wed, 09 Mar 2022 05:34:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=oKAagiS3UYpwunP7Sy4zMqHeUF02cL/iWA5aLyx3lIw=;
        b=MXdznXMrTKgJapa66ALe2iN+O4g+c09cCPDfsR3Hsd8bZFctAWDhWUAbOU6v66A39H
         9EGViijeHT+7U9/QUwWjXo7Oi5nPBaspi8F+nn1OVmTsZlUy/oakFJaXUNvDuHLeyHMY
         /lZ/U3d5qm6ycg4aVZDKpHK3vO7eH53CKtA9W2dur7JlYERL+eY2KuxcHlFbHDOYV/8u
         xK9eqgr+J505+NGiMqrErDXFWI0PL25qr/q86m4nT+WVHzL/LQDZhjcVFkFg1EABa5rM
         Fe/tL2uViXOLpQxDM5XgoZJTKM7tcF8LHj+aFapV7GNduttrAxZCDnd5vrus+eybqWvJ
         KorA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=oKAagiS3UYpwunP7Sy4zMqHeUF02cL/iWA5aLyx3lIw=;
        b=yh/977CSS8qNv4E4P6/ng8/Ili0GAfE2UqDJeBt/QWsOWJmxK1QTn6EWZa6brLQvXt
         RYuRCswwxQL8ensLtFN0h0BpqAHpn/53k7IM0DUlqH5HgzGXB8eJ/MOIySs6DmbrGSwj
         DuMn9m8swIAlunXT/Gw3d3ssWSwSN1prb5YDbHNkn4yuksiOxqioLH8EBvRe0qj+h3g/
         8CuA7lxUyyqzhPvy4Me0sa+Fn6IOFsmg1InRIuKhQZgPZTuzc0015gvbctwSp/2lHu7X
         R+TH2RIJttpNZjEhjxY8RFK9Teqg6XURa6ZN38pU4N0592fPQjoSlczRe4BiRV92KNoK
         6P8Q==
X-Gm-Message-State: AOAM532/YOcd2yZx9laWzCbgQEb4UvGuuMmAMnZkaKYI4sccFDP0XJ7y
        MFggasWQk69vfsPqNZ4OS59MHy2hz9jLKawGB2j/eFqeyOgN6I+p/XDjr6LkJYf5YN0scMKAYXh
        015FbtPZmuTZVmTPcAamBGeAKgVRTKnIqzO2ATog/Mr0vN2K5DW4rDKU+5O/WDXBBIU2O693hFg
        ==
X-Google-Smtp-Source: ABdhPJxsh5zoNB+VgfKe4CI6uoxwNzwsaENxHsbYTeb6/niL81/XMRFtTFhMIaYaQiyHPw6vaLPz1xHSTbLmhYbpmsg=
X-Received: from sene.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:27c4])
 (user=sebastianene job=sendgmr) by 2002:a05:600c:a06:b0:37b:fdd8:4f8 with
 SMTP id z6-20020a05600c0a0600b0037bfdd804f8mr7715217wmp.41.1646832895295;
 Wed, 09 Mar 2022 05:34:55 -0800 (PST)
Date:   Wed,  9 Mar 2022 13:34:22 +0000
In-Reply-To: <20220309133422.2432649-1-sebastianene@google.com>
Message-Id: <20220309133422.2432649-2-sebastianene@google.com>
Mime-Version: 1.0
References: <20220309133422.2432649-1-sebastianene@google.com>
X-Mailer: git-send-email 2.35.1.616.g0bdcbb4464-goog
Subject: [PATCH kvmtool v10 1/3] aarch64: Populate the vCPU struct before target->init()
From:   Sebastian Ene <sebastianene@google.com>
To:     kvm@vger.kernel.org
Cc:     qperret@google.com, maz@kernel.org, kvmarm@lists.cs.columbia.edu,
        will@kernel.org, julien.thierry.kdev@gmail.com,
        Sebastian Ene <sebastianene@google.com>
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

Move the vCPU structure initialisation before the target->init() call to
 keep a reference to the kvm structure during init().
This is required by the pvtime peripheral to reserve a memory region
while the vCPU is beeing initialised.

Reviewed-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Sebastian Ene <sebastianene@google.com>
---
 arm/kvm-cpu.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/arm/kvm-cpu.c b/arm/kvm-cpu.c
index 6a2408c..84ac1e9 100644
--- a/arm/kvm-cpu.c
+++ b/arm/kvm-cpu.c
@@ -116,6 +116,13 @@ struct kvm_cpu *kvm_cpu__arch_init(struct kvm *kvm, unsigned long cpu_id)
 			die("Unable to find matching target");
 	}
 
+	/* Populate the vcpu structure. */
+	vcpu->kvm		= kvm;
+	vcpu->cpu_id		= cpu_id;
+	vcpu->cpu_type		= vcpu_init.target;
+	vcpu->cpu_compatible	= target->compatible;
+	vcpu->is_running	= true;
+
 	if (err || target->init(vcpu))
 		die("Unable to initialise vcpu");
 
@@ -125,13 +132,6 @@ struct kvm_cpu *kvm_cpu__arch_init(struct kvm *kvm, unsigned long cpu_id)
 		vcpu->ring = (void *)vcpu->kvm_run +
 			     (coalesced_offset * PAGE_SIZE);
 
-	/* Populate the vcpu structure. */
-	vcpu->kvm		= kvm;
-	vcpu->cpu_id		= cpu_id;
-	vcpu->cpu_type		= vcpu_init.target;
-	vcpu->cpu_compatible	= target->compatible;
-	vcpu->is_running	= true;
-
 	if (kvm_cpu__configure_features(vcpu))
 		die("Unable to configure requested vcpu features");
 
-- 
2.35.1.616.g0bdcbb4464-goog

