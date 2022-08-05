Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07A1958A82E
	for <lists+kvm@lfdr.de>; Fri,  5 Aug 2022 10:38:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240362AbiHEIiZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Aug 2022 04:38:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240323AbiHEIiS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 5 Aug 2022 04:38:18 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 913821573A;
        Fri,  5 Aug 2022 01:38:15 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id u133so1654359pfc.10;
        Fri, 05 Aug 2022 01:38:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=tWL9Jm/bpwdH+2kthrf64sjurZaAu1v9jeTRfOFzaRk=;
        b=gmYB/lbt52jMbEuG3Zdd/bgE/4p37nTSEKKAqy2XsPflvi7dgFsQju6tru82mGz6bi
         KdayvIZN9EWGeXYWngWnueZWPq1SHLUc5VXhnDaVNpCOSgFEoLMFZcGRDRdUSIeJXySb
         5Je7TRD9H15bjMLKUfM0IoPBhPkxLNsAE0QCbjCtIAKKT4pSwhff6ucrG8nvQ/cfp4SS
         qB56Nhib44SgQ+z5EAAFGpoNOtBQegQKjcFlA1mnsEkwnuoUhK6neeZxXvxr6A+ghqWf
         vTC6HVBg+xKtumZZRPhifpeaa3zl679v12dYr3l00lITNca8qHCbGvLQYIuyP4vn3j5K
         AREw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=tWL9Jm/bpwdH+2kthrf64sjurZaAu1v9jeTRfOFzaRk=;
        b=qJsU2thxqSJkGCj/xGk6TQk0ARxHoK3MIgbzoufWCUMbro8flI1NSRD8ZU9JrSyXsY
         W1jgH+EVj1qGmLAsXp0odmJnkLv+mNI/ckvSLExHMn0JF7IIrRqXpLDKZHptoRrytbVd
         c1cnowNZyBsSQO+XZvY/6DVNKr50blwX8VZ/DyMlayWeyA/e6SvZ31YbDzdtzSkJoJO4
         qgnsUpvgbkR7ovqs7AXcAACPcKhk9gJOMUAc4jLqxI99/7HSixwUQ7YWEbUmnKQSvycq
         9zkkxpBJEI57C3Ex8K6+2FXu371Wr+QE4EwJateuia2ZOUz852h/+7mfednv+lGMTVXy
         ttOw==
X-Gm-Message-State: ACgBeo3E0wrig4UZ9qky8F2RrDwwDxHeKMYg6NkgyQw1n+GmMvGS1RkH
        MudfrkXeTN2/HDDHNKNio+MltgaU76Q7iQ==
X-Google-Smtp-Source: AA6agR696WotLrZ+yJrQxzh6qi+rXKVpa2DKo6vyDlWmOoIPB7SaESu/twbumMOmGjTsQ6qGkVHfWQ==
X-Received: by 2002:a17:903:234d:b0:16f:3e9:491b with SMTP id c13-20020a170903234d00b0016f03e9491bmr5762810plh.89.1659688684410;
        Fri, 05 Aug 2022 01:38:04 -0700 (PDT)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id c126-20020a621c84000000b005289627ae6asm2347686pfc.187.2022.08.05.01.38.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Aug 2022 01:38:04 -0700 (PDT)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] KVM: x86: Reject writes to PERF_CAPABILITIES feature MSR after KVM_RUN
Date:   Fri,  5 Aug 2022 16:37:43 +0800
Message-Id: <20220805083744.78767-2-likexu@tencent.com>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220805083744.78767-1-likexu@tencent.com>
References: <20220805083744.78767-1-likexu@tencent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Like Xu <likexu@tencent.com>

KVM may do the "wrong" thing if userspace changes PERF_CAPABILITIES
after running the vCPU, i.e. after KVM_RUN. Similar to disallowing CPUID
changes after KVM_RUN, KVM should also disallow changing the feature MSRs
(conservatively starting from PERF_CAPABILITIES) after KVM_RUN to prevent
unexpected behavior.

Applying the same logic to most feature msrs in do_set_msr() may
reduce the flexibility (one odd but reasonable user space may want
per-vcpu control, feature by feature) and also increases the overhead.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Like Xu <likexu@tencent.com>
---
 arch/x86/kvm/x86.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 33560bfa0cac..3fb933bfb3bd 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3540,6 +3540,9 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 
 		if (!msr_info->host_initiated)
 			return 1;
+		if (vcpu->arch.last_vmentry_cpu != -1 &&
+		    vcpu->arch.perf_capabilities != data)
+			return 1;
 		if (kvm_get_msr_feature(&msr_ent))
 			return 1;
 		if (data & ~msr_ent.data)
-- 
2.37.1

