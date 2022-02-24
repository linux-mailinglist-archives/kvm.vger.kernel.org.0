Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4AD674C3252
	for <lists+kvm@lfdr.de>; Thu, 24 Feb 2022 17:56:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229834AbiBXQ4O (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Feb 2022 11:56:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229805AbiBXQ4M (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Feb 2022 11:56:12 -0500
Received: from mail-wm1-x349.google.com (mail-wm1-x349.google.com [IPv6:2a00:1450:4864:20::349])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E16CB205C4
        for <kvm@vger.kernel.org>; Thu, 24 Feb 2022 08:55:42 -0800 (PST)
Received: by mail-wm1-x349.google.com with SMTP id l31-20020a05600c1d1f00b00380e3425ba7so89347wms.9
        for <kvm@vger.kernel.org>; Thu, 24 Feb 2022 08:55:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=jRWeKy2DF55SrlhxS1tpavQsfSfBDLtoM+yorrperzg=;
        b=eepCKKpstRrUT4TBeh0EwpjpdU4YhLWO4IRwZnr7/fOmHogjdbclficzyLr6hJNQN1
         eFqBdJCnfOaqmK02W1/Ih60n+RDQvvZpLPM61MkpuwJFvkryVlYe39JN9lDjoCDb+QkY
         tc0Ex4WSb4XBXO2nUN2nislHw0Lb3NsdqnI3ZOv0uKXf6RAhLD+zxV4Spi798xi2jsTE
         bNNibvS/X/0vslpeHVWIg5GPKuYUw/yGfePWEm9paBVo5JjI2jU3mbBesmcejE91HG15
         2P/lvS82SHwhUV4/fV+T6WDWDSnru2Oj3ZrOVjH6ZV2RugWsvFwmAkrwoa2IGkYl2EO+
         G+KQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=jRWeKy2DF55SrlhxS1tpavQsfSfBDLtoM+yorrperzg=;
        b=Ru5SVJ9ZWZWszveZGx8lwKeV/OUvRvsyhDaItFFBeUPzEjzsqzFhAERzN9ZLmuxevF
         SeHN/v0Aw9yPIsmDse1h7YHwosqhSwcWOH+6ErmOwGNXHXMS1Oq4Ltd+MoYVnjX+JrMg
         7CdCKTTP9GBMpsxrMugipGN8lJvUnRl0zzd9nmvkzai4tkOc9fCDJTUig4eNrBjlR8EA
         X8hIzcJpTXTZ3foaWHMYcuXNmqpNH4lbHT56sor4vUc4+9KLa2zvabM9I1k9o34RvmMb
         PLwNcssWdldcniRfMgBfO4U35FpVwlMz8At5bEhV/1ugWkqbW3c3xYkEZsMHHjC9oemW
         W3HQ==
X-Gm-Message-State: AOAM532aFSOAEt0DuVYEGZ77mHazKFdIBikqGCadO/JsWO3fMbVr7NWr
        mhBTCZrzzIK7cgLrNVf+WcMUel8zpbLhjIoscle2teNM4qnnLFaHY/QErcL85kBB1aUGkEDj/Ha
        jCbP+u4DJapeWwRtpLVVIyGRgol+05i4yPXTmfTLPWEh4i36TjT1YWDWtW9yFDJ374QIjfwl+Pg
        ==
X-Google-Smtp-Source: ABdhPJy8VNK2No603tfy4Digp9AM+zjrddzxLevnc+p8D96pwuTl1GNWQqjDY04BtWPC3KSa4IAfV25Wtc9kaTnZfrI=
X-Received: from sene.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:27c4])
 (user=sebastianene job=sendgmr) by 2002:a5d:560b:0:b0:1ed:af2b:d41e with SMTP
 id l11-20020a5d560b000000b001edaf2bd41emr2873710wrv.499.1645721741480; Thu,
 24 Feb 2022 08:55:41 -0800 (PST)
Date:   Thu, 24 Feb 2022 16:51:04 +0000
In-Reply-To: <20220224165103.1157358-1-sebastianene@google.com>
Message-Id: <20220224165103.1157358-3-sebastianene@google.com>
Mime-Version: 1.0
References: <20220224165103.1157358-1-sebastianene@google.com>
X-Mailer: git-send-email 2.35.1.473.g83b2b277ed-goog
Subject: [PATCH kvmtool v4 2/3] aarch64: Populate the vCPU struct before target->init()
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
2.35.1.473.g83b2b277ed-goog

