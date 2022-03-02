Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B9AF04CA6F9
	for <lists+kvm@lfdr.de>; Wed,  2 Mar 2022 15:04:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242551AbiCBOEz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Mar 2022 09:04:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241616AbiCBOEx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Mar 2022 09:04:53 -0500
Received: from mail-wr1-x449.google.com (mail-wr1-x449.google.com [IPv6:2a00:1450:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20BF27EDBD
        for <kvm@vger.kernel.org>; Wed,  2 Mar 2022 06:04:09 -0800 (PST)
Received: by mail-wr1-x449.google.com with SMTP id ay18-20020a5d6f12000000b001efe36eb038so676864wrb.17
        for <kvm@vger.kernel.org>; Wed, 02 Mar 2022 06:04:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=gRdzjUKFCpuFZPsm9KFd7MbCyuJUNKRJi1HCnRctsnI=;
        b=WTotb9A2RoMjWhLf8XQUpZG4gHzu04COfESZrJ2a44gmpP1C7bzxTp4V+wYsbobq2d
         oM4XNvAcO59R2iaj1uUVp0BVW8AxY6KH02LsRB4vsmF+VnsbQxkgcJVPJ1payyezIsss
         uOmdEBuw5N5IyvOXXVCgTT7HgOqRTSg4LvlbSkAFSs8cd3Oln1vDLjugTlHQV0aaXazM
         RHUTKMJw2+zYZbjOhaHXkG975ZYbcCOMl2wDx0lJ0pg2fRITICknNVE1b6HD9QGD2hEl
         24U303CG2KsvtiJDhBJFsX89sSIcN+VP/SFH8x8O9pTa20fjnmas3MRKb8lHM0RVFoGO
         8PCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=gRdzjUKFCpuFZPsm9KFd7MbCyuJUNKRJi1HCnRctsnI=;
        b=RANjqvNIJwy+IqcjdrkR93IDsnC0tScY9jFXk0UZJNoz94BX6A9KIaxBoKYNtlgKgV
         rFWSP2xsGvAYPWOYmkyFedET2RUtXQU5JCM1tcpPHdqQazgsPxENQ8OHCtQNdo22f7Y2
         lSEcscW8jLVJv8RlRUWkfG7IGG7OS8m/PNazokKffINPT/ijEyRDXuwULkJVF4Z+poWo
         n0H1vfLNoTGY7ayCHuHJ2hixZUbtryUlMcvMnN++a5bQ/wblMzcwHnXAPt2jjKyVcSIE
         a26gR5OoM/CLmq8Bfn8psmhdVUv6ToUKe+YvRBLogumnrj6lB7cRoMVQCsBTI3c2Wr3l
         eDxQ==
X-Gm-Message-State: AOAM530ocJ+w7Sl5CK50TGykg1hzf0MvMjEjtUIyYty7cFf0abmjHxX7
        pX4zvri3BZxh/yANDT/eKQImqJLbc52/NyoPyShyoXWs8PUO7rCC+iewx9vax6bDVT8zHxe3iNj
        9xP/FGr0xDCImJbRuVkKKBL+gx/qX4qdzWDxl2f/9+3FlJLLcBkwzIW/DOFICJeTdtGvSxuminA
        ==
X-Google-Smtp-Source: ABdhPJwz6/e0yNgNPotGI5uubbcL5r6LQ9YMOmlDj1hWLk7K/P/c94xIA9Yx4p1Z7fucZntamCmKMkMSP/Kpu97RqA8=
X-Received: from sene.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:27c4])
 (user=sebastianene job=sendgmr) by 2002:a05:600c:3787:b0:386:aa15:7117 with
 SMTP id o7-20020a05600c378700b00386aa157117mr135669wmr.113.1646229847624;
 Wed, 02 Mar 2022 06:04:07 -0800 (PST)
Date:   Wed,  2 Mar 2022 14:03:23 +0000
In-Reply-To: <20220302140324.1010891-1-sebastianene@google.com>
Message-Id: <20220302140324.1010891-2-sebastianene@google.com>
Mime-Version: 1.0
References: <20220302140324.1010891-1-sebastianene@google.com>
X-Mailer: git-send-email 2.35.1.574.g5d30c73bfb-goog
Subject: [PATCH kvmtool v6 1/3] aarch64: Populate the vCPU struct before target->init()
From:   Sebastian Ene <sebastianene@google.com>
To:     kvm@vger.kernel.org
Cc:     qperret@google.com, maz@kernel.org, kvmarm@lists.cs.columbia.edu,
        will@kernel.org, julien.thierry.kdev@gmail.com,
        Sebastian Ene <sebastianene@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-10.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
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
2.35.1.574.g5d30c73bfb-goog

