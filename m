Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CCDDB7977FC
	for <lists+kvm@lfdr.de>; Thu,  7 Sep 2023 18:39:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240037AbjIGQix (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Sep 2023 12:38:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236902AbjIGQhe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Sep 2023 12:37:34 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C6DB35A3
        for <kvm@vger.kernel.org>; Thu,  7 Sep 2023 09:26:07 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id d9443c01a7336-1bf703dd21fso15603305ad.3
        for <kvm@vger.kernel.org>; Thu, 07 Sep 2023 09:26:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1694103893; x=1694708693; darn=vger.kernel.org;
        h=cc:to:from:subject:mime-version:message-id:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=oAJvejQkP8HyG+gPbDyWclQAKXMlf/E8yZttByLJOOw=;
        b=VvMvKBX8UtAMxcyRSsY5BkGuV3l6kL2WoI4Ze98/3vOjcaH6Lv4aeLB1IpaLLSEcsk
         gA9IOxK3qnSI08FLKArOSM67uD29Li2PgOcm+A3cewHmOIC4oeSwIUqBuPJunSfcbvVK
         r7o4cz7vxK7+OTtr7ihHmN9e+J1xWyEwvvE9CkA2NnWxNe+lsQABTHoMq49p/TpknA6D
         OSBl0uKj5z4/5K0zk7NXVaCkduyfTT2G21l08bAxJGGF9Ibo0lvXTRqI86QVQ4+xU3MM
         6mSFSjoGxS/UKafbi95UH4UuXdsAa937uZCZ6Uz8i9QJcwt6siL8yJvrAruXRBwAZoRk
         1Wig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1694103893; x=1694708693;
        h=cc:to:from:subject:mime-version:message-id:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=oAJvejQkP8HyG+gPbDyWclQAKXMlf/E8yZttByLJOOw=;
        b=Aishb5h5e3g5rY0qFkG7AB6xssYzdyDuvktck4jCC4ok0h5WBRvhkmQD2OgAVgzg7c
         fDoiYRVdFusP2buJNV2V4t5PjtBkULsvId4U4v2KQ/pdYkOmr0a2IZwU7CtwtW8G/6LL
         /iFeixaEHFtNCtPqZfA4rZyM+Rquaujo8dB86jaEUPpBBDB179vxvm4pE0PM1YcFab/r
         NdJDXr0eB5sSXcOgZ2Oer4oaKKYqkppST3m6+eO8peK2kajwqvZicMn3UVUisNa9EA30
         XptPySqALR8I3vicPYOB/zkscQ7SULN1BJZ4PDvbS5A9mvgMSXgPKFyndvczvSpCMKxd
         eRSQ==
X-Gm-Message-State: AOJu0Yw1noy5Gf60RquhNrYEHr9HfFz1KP+MgZhgl0t0JES6sRY2pcOy
        ZxHxpKsZJfZJ5gFCmISugNi1oC6AmqmpV13QzHd1kUVEJJxIrbJjaKKP2t9o69Rm+GGAOV+sB4Y
        baVdAycEelXRp6Fu6XQjuPYhabtJ64tZXvYDPO6Q1Ps5IbaxrMSjynzK/Nw==
X-Google-Smtp-Source: AGHT+IE7SJ5e2Xx9+qwsR5zLU5cq4bwdrLUCIfdMrQWFAZGnipEekaQC5GzdIkcEbPI1oIcNljzA6+jLuZw=
X-Received: from pgonda1.kir.corp.google.com ([2620:0:1008:15:e95c:4a2a:4112:e68])
 (user=pgonda job=sendgmr) by 2002:a17:902:c950:b0:1c2:b50:c91d with SMTP id
 i16-20020a170902c95000b001c20b50c91dmr13946pla.10.1694103892924; Thu, 07 Sep
 2023 09:24:52 -0700 (PDT)
Date:   Thu,  7 Sep 2023 09:24:49 -0700
Message-Id: <20230907162449.1739785-1-pgonda@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.42.0.283.g2d96d420d3-goog
Subject: [PATCH V3] KVM: SEV: Update SEV-ES shutdown intercepts with more metadata
From:   Peter Gonda <pgonda@google.com>
To:     kvm@vger.kernel.org
Cc:     Peter Gonda <pgonda@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Joerg Roedel <joro@8bytes.org>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Currently if an SEV-ES VM shuts down userspace sees KVM_RUN struct with
only the INVALID_ARGUMENT. This is a very limited amount of information
to debug the situation. Instead KVM can return a
KVM_EXIT_SHUTDOWN to alert userspace the VM is shutting down and
is not usable any further.

Signed-off-by: Peter Gonda <pgonda@google.com>
Suggested-by: Sean Christopherson <seanjc@google.com>
Suggested-by: Tom Lendacky <thomas.lendacky@amd.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Cc: Joerg Roedel <joro@8bytes.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: x86@kernel.org
Cc: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 arch/x86/kvm/svm/svm.c | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 956726d867aa..114afc897465 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -2127,12 +2127,6 @@ static int shutdown_interception(struct kvm_vcpu *vcpu)
 	struct kvm_run *kvm_run = vcpu->run;
 	struct vcpu_svm *svm = to_svm(vcpu);
 
-	/*
-	 * The VM save area has already been encrypted so it
-	 * cannot be reinitialized - just terminate.
-	 */
-	if (sev_es_guest(vcpu->kvm))
-		return -EINVAL;
 
 	/*
 	 * VMCB is undefined after a SHUTDOWN intercept.  INIT the vCPU to put
@@ -2141,9 +2135,14 @@ static int shutdown_interception(struct kvm_vcpu *vcpu)
 	 * userspace.  At a platform view, INIT is acceptable behavior as
 	 * there exist bare metal platforms that automatically INIT the CPU
 	 * in response to shutdown.
+	 *
+	 * The VM save area for SEV-ES guests has already been encrypted so it
+	 * cannot be reinitialized, i.e. synthesizing INIT is futile.
 	 */
-	clear_page(svm->vmcb);
-	kvm_vcpu_reset(vcpu, true);
+	if (!sev_es_guest(vcpu->kvm)) {
+		clear_page(svm->vmcb);
+		kvm_vcpu_reset(vcpu, true);
+	}
 
 	kvm_run->exit_reason = KVM_EXIT_SHUTDOWN;
 	return 0;
-- 
2.42.0.283.g2d96d420d3-goog

