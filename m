Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 17C294D01A7
	for <lists+kvm@lfdr.de>; Mon,  7 Mar 2022 15:43:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243335AbiCGOoT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Mar 2022 09:44:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243338AbiCGOoQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Mar 2022 09:44:16 -0500
Received: from mail-wr1-x449.google.com (mail-wr1-x449.google.com [IPv6:2a00:1450:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D74746B1F
        for <kvm@vger.kernel.org>; Mon,  7 Mar 2022 06:43:21 -0800 (PST)
Received: by mail-wr1-x449.google.com with SMTP id h11-20020a5d430b000000b001f01a35a86fso4608328wrq.4
        for <kvm@vger.kernel.org>; Mon, 07 Mar 2022 06:43:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=AEhqnN4KTy6FPofpGdBFugJSZ01sGgYi75EWboeVOHI=;
        b=IMVmV+H3PofMHB9PeFURsxfc4TH7mzyYcd98ZUSMfuYOiYSjRH4meT+9velODpceJD
         S0jUQmw+3bT8vH38ey/2yBwYe/n1+GOlvQs36/wi8WTOis0loDS63VxQOqf32hui/Eh7
         q+Qf3sbJ07M6VUBg89BwnzCFOCCJlGLdqsDc6Yu7id4LxsPgRTZ/Az6zRV0eEXz+Pb7O
         V9Hkg2IqDG0hYOMAgpmJEmhhpQgDfo6PByKbISRMC39d51e1sfYJUBL7ykbniNrjhlHQ
         gd0w7DYO/rZx1uF9BgiWDBfqosfLW9pbZk9FshKi5jLTBgWdHKsQpu/qhTlsz9Oy3/SL
         uJaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=AEhqnN4KTy6FPofpGdBFugJSZ01sGgYi75EWboeVOHI=;
        b=0y0Hea1R0M/XkcstvCQibrYicbdbBtrY99VTowl3KCSBvlo9hOcfEwLvpQ+3+2mMxi
         Yw13pURmcYyj1iZyFqhpC0A09uNnMmnBOV7jjXyNUz7XYuZyRk7fdKX0JAx62aMYU3Xh
         EQ5rR8Far4m2Jm2ZiCb5h28kG9uzxElTVaHNceE2WTOUuKNEX29Dk/UbB8eX0SsiXp36
         rOiTFSsjv3xjaFP3bUFv5/Eg4YghLk8OHl0P3yF8gPzXDtSHUPVLZ+j2xsT8YaZe2++y
         Pkm4IXGS21Z5Q0fMRDqHHhNNm4r+DURp6wq8C9Vo/v8HvB5NxGU5fxyY/nI7toKO02Yb
         pw5w==
X-Gm-Message-State: AOAM530LLIQqdNY5O32d/J5OeLIglInhETuzk/R5VGvZwyZICfTM9r5l
        +fbOjPiX78ACPk4t/lpvNBI4+Ef+vorI9sWg4ieoeOTVld+CilZuBcKf6C7RWV9aEElQGmzrAKu
        dm+ivSpvksrptyiw5O/KJBQgfuI+oIJQqud9uYTP5SPXdW9bcUWB0GmNpz94aXsZ5AOnKecin1A
        ==
X-Google-Smtp-Source: ABdhPJziMiHw6LmCbzxXV7rrB75EYFeYsMaeJXlW9zCnK7xxglGhARbFJvFR7paXFSKWoYnDg8dRy/b745R2JaCg8wg=
X-Received: from sene.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:27c4])
 (user=sebastianene job=sendgmr) by 2002:a7b:c759:0:b0:389:82c6:ac44 with SMTP
 id w25-20020a7bc759000000b0038982c6ac44mr12407217wmk.168.1646664199739; Mon,
 07 Mar 2022 06:43:19 -0800 (PST)
Date:   Mon,  7 Mar 2022 14:42:42 +0000
In-Reply-To: <20220307144243.2039409-1-sebastianene@google.com>
Message-Id: <20220307144243.2039409-2-sebastianene@google.com>
Mime-Version: 1.0
References: <20220307144243.2039409-1-sebastianene@google.com>
X-Mailer: git-send-email 2.35.1.616.g0bdcbb4464-goog
Subject: [PATCH kvmtool v8 1/3] aarch64: Populate the vCPU struct before target->init()
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

