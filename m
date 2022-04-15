Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0740502FA8
	for <lists+kvm@lfdr.de>; Fri, 15 Apr 2022 22:17:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351201AbiDOUSX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Apr 2022 16:18:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345497AbiDOUSU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Apr 2022 16:18:20 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 456423B287
        for <kvm@vger.kernel.org>; Fri, 15 Apr 2022 13:15:51 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id n10-20020a25da0a000000b0064149e56ecaso7500485ybf.2
        for <kvm@vger.kernel.org>; Fri, 15 Apr 2022 13:15:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=C00yhYhZJTIznYJGDu1kufq84AOu9nR23r5srBdqR58=;
        b=hZSGBh4QeBitpIRiMTt4RYNSsHhcsxGXnYBEULXcOW1qRzaJyrjHBNl7LwqkNYWO4P
         9W60VTXkTaIfZsjKvzQ+OqkL33rmPplyGQfLqqEvZKTrKmZqlbr2bl25VwCZNjG+3TfJ
         TFDhp67zqYCZZ+LX3PRuzY4sZqXJF1uNFgW3dlTcLVl0wqlS8AapjC3+b7kod41pNCU6
         wOxSdaSae1XuUNA23ITwGNFvmgS93/HdY4gKFhwJGQrCQ966NY+DbG8kmtJrwLqHA0f3
         APo3hvlfxCaAfg4DtBhrEQhe0XDtJWkI0imVYc1U4QpPMo9nB/nr+LLQmOEqVOhBCc1r
         p8YA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=C00yhYhZJTIznYJGDu1kufq84AOu9nR23r5srBdqR58=;
        b=zG6hXHCRb4zr/Arb5dPVTAaaOVFs0k35s61/fYmQyZhpr0/9lK3jX8Q7CWMQTe8yFt
         KMq2ZSVBV/TCR8E2W8FQXNw/0RrNWeC2kVApAHdt/PO9K+K5J0jjtoVsg9kroYXPmsqw
         xdmko+5ty+6YR0zPWTTSz6zWqNAnCgGDTIqLf4q+Kyyna2H67xec2bMGQHh9mLctU/qt
         BldTjWYP1x06GpYewcYuRkcZ5qUz0Ixf2pdFnPpnMQ4w3eZw3frnqpIaW9pw3o8VdB4S
         RZmEOTpsVYN/2LHgPR/jKHaa6+E/jap99cp3yi5K3nC/jszLVKMlsTvf8SKCVKqoEgal
         f88A==
X-Gm-Message-State: AOAM533R6qWngdUEN0hhYw2yJX5n7kDsjqsxZuZHHA1+W3todh8Dhpx4
        0oOS1zKHWHx7htFLcSzIpTn0jF4464Z94dIEwe3tgNdf02mrV1D9pvkkxt9asHfl5n7XH5eFM/z
        c4IA9LI28KwTOoi4huTcFaz6LChyrjInujiHKw1KQevQCG/dhBkipYPc88w==
X-Google-Smtp-Source: ABdhPJyOcGCkIqp1pWjden0iCg5PcvHYAwXsxyQf+onwNk21j4c99OIyx6MfRpZuBe3x8E/mhQdI78SlKG4=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a25:1ec5:0:b0:641:1bf5:d4ba with SMTP id
 e188-20020a251ec5000000b006411bf5d4bamr835196ybe.410.1650053750363; Fri, 15
 Apr 2022 13:15:50 -0700 (PDT)
Date:   Fri, 15 Apr 2022 20:15:39 +0000
In-Reply-To: <20220415201542.1496582-1-oupton@google.com>
Message-Id: <20220415201542.1496582-3-oupton@google.com>
Mime-Version: 1.0
References: <20220415201542.1496582-1-oupton@google.com>
X-Mailer: git-send-email 2.36.0.rc0.470.gd361397f0d-goog
Subject: [PATCH 2/5] KVM: Shove vcpu stats_id init into kvm_vcpu_create_debugfs()
From:   Oliver Upton <oupton@google.com>
To:     kvm@vger.kernel.org
Cc:     seanjc@google.com, pbonzini@redhat.com, maz@kernel.org,
        kvmarm@vger.kernel.org, Oliver Upton <oupton@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Again, the stats_id is only ever used by the stats code; put it where it
belongs with the rest of the stats initialization.

No functional change intended.

Signed-off-by: Oliver Upton <oupton@google.com>
---
 virt/kvm/kvm_main.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index ec9c6aad041b..aaf8de62b897 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -3711,6 +3711,10 @@ static void kvm_create_vcpu_debugfs(struct kvm_vcpu *vcpu)
 	struct dentry *debugfs_dentry;
 	char dir_name[ITOA_MAX_LEN * 2];
 
+	/* Fill the stats id string for the vcpu */
+	snprintf(vcpu->stats_id, sizeof(vcpu->stats_id), "kvm-%d/vcpu-%d",
+		 task_pid_nr(current), vcpu->vcpu_id);
+
 	if (!debugfs_initialized())
 		return;
 
@@ -3786,10 +3790,6 @@ static int kvm_vm_ioctl_create_vcpu(struct kvm *kvm, u32 id)
 	if (r)
 		goto unlock_vcpu_destroy;
 
-	/* Fill the stats id string for the vcpu */
-	snprintf(vcpu->stats_id, sizeof(vcpu->stats_id), "kvm-%d/vcpu-%d",
-		 task_pid_nr(current), id);
-
 	/* Now it's all set up, let userspace reach it */
 	kvm_get_kvm(kvm);
 	r = create_vcpu_fd(vcpu);
-- 
2.36.0.rc0.470.gd361397f0d-goog

