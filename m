Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60EC479A358
	for <lists+kvm@lfdr.de>; Mon, 11 Sep 2023 08:12:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234415AbjIKGMu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Sep 2023 02:12:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234483AbjIKGMs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Sep 2023 02:12:48 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88441133
        for <kvm@vger.kernel.org>; Sun, 10 Sep 2023 23:12:39 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-59b56dab74bso27663737b3.2
        for <kvm@vger.kernel.org>; Sun, 10 Sep 2023 23:12:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1694412758; x=1695017558; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7TmZKUi7joPDE6kB7XAptfCpZOVZe17TuZCxxDSv6qw=;
        b=peC+f6C79T2XaI1mkhCEMBKt35R/URpN0x30QhNOmp9NlchgPmGpoQX/5X9EAgYKuV
         U8CURBI60SsWIN1G2BP/aLSPaTDDuybk0CkQD1sS4XuUbnwG4HPbJbfIz3uKOYlnkO8w
         DZtxEUOGdk24h464VGLhx4xbIVxdCc+wGaDTOV+iXvssz3BZF0SPjDFNSTbTwTOMquYB
         9fxFtgb534IQNBw3DQruhb0q/qsCD2VfgkYeDe2TgRhqDOpQPgN5JwxlVjhdigoqIljp
         k4zgv6JiA3RLADGb9htzudHpyXHflRHlvRB4BPDeOtI5cLeIlc2xtArrCx3eWpq4hPW3
         RXTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694412758; x=1695017558;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7TmZKUi7joPDE6kB7XAptfCpZOVZe17TuZCxxDSv6qw=;
        b=xAQ315iL+ttDP3zPgwYeu7PCRUvSVIosPH3D/qZ+G5WamSfW1sbtF4CYgn98/j182M
         p4ar+oy9Hx023C0f6CrJpzdbxWqTEKJ+O2nXYCOMYAlQ4JOJcbTdweH2xpbFRcuZ7tmT
         VLfHfT2RxZwcXsaGshDqEmQnveNYRcrLK+h4NfxMrOEEWN+7rOjEblrUyv+MK4Rt/tkl
         PjuxY+YR5RIyIzxcRF7hW2U8RTqyXG+DXGXeK6X3ivg+OeXY8pKaw4FsxLg8NlOJWBaI
         f2y8s71Lf5AzC/03SVBU2zpSxZtNjWtV7ciIHtPIeDQYnmu0BpQbqzb2OvRHy1uk76or
         FZ5Q==
X-Gm-Message-State: AOJu0YynEZAtbe3cz6aHeia6E+RR0bk/afbA1BxtTFO8Q/qClpF3KQHE
        268kUm/UYFdWgESHCrE7IFr8HJ2kuNRY
X-Google-Smtp-Source: AGHT+IHOm4Vt5ylpeQ7mK4G/lgjg2kpXi/jjt1cOb8Fy4swtwzyLIVVMnwvE0ZpGlRK/hK8pbCTjsRjcJDF9
X-Received: from mizhang-super.c.googlers.com ([35.247.89.60]) (user=mizhang
 job=sendgmr) by 2002:a81:b65c:0:b0:583:a8dc:1165 with SMTP id
 h28-20020a81b65c000000b00583a8dc1165mr259591ywk.10.1694412758662; Sun, 10 Sep
 2023 23:12:38 -0700 (PDT)
Reply-To: Mingwei Zhang <mizhang@google.com>
Date:   Mon, 11 Sep 2023 06:11:47 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.42.0.283.g2d96d420d3-goog
Message-ID: <20230911061147.409152-1-mizhang@google.com>
Subject: [PATCH] KVM: vPMU: Use atomic bit operations for global_status
From:   Mingwei Zhang <mizhang@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Mingwei Zhang <mizhang@google.com>,
        Dapeng Mi <dapeng1.mi@intel.com>,
        Jim Mattson <jmattson@google.com>, Like Xu <likexu@tencent.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Use atomic bit operations for pmu->global_status because it may suffer from
race conditions between emulated overflow in KVM vPMU and PEBS overflow in
host PMI handler.

Fixes: f331601c65ad ("KVM: x86/pmu: Don't generate PEBS records for emulated instructions")
Signed-off-by: Mingwei Zhang <mizhang@google.com>
---
 arch/x86/kvm/pmu.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index edb89b51b383..00b48f25afdb 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -117,11 +117,11 @@ static inline void __kvm_perf_overflow(struct kvm_pmc *pmc, bool in_pmi)
 			skip_pmi = true;
 		} else {
 			/* Indicate PEBS overflow PMI to guest. */
-			skip_pmi = __test_and_set_bit(GLOBAL_STATUS_BUFFER_OVF_BIT,
-						      (unsigned long *)&pmu->global_status);
+			skip_pmi = test_and_set_bit(GLOBAL_STATUS_BUFFER_OVF_BIT,
+						    (unsigned long *)&pmu->global_status);
 		}
 	} else {
-		__set_bit(pmc->idx, (unsigned long *)&pmu->global_status);
+		set_bit(pmc->idx, (unsigned long *)&pmu->global_status);
 	}
 
 	if (!pmc->intr || skip_pmi)

base-commit: e2013f46ee2e721567783557c301e5c91d0b74ff
-- 
2.42.0.283.g2d96d420d3-goog

