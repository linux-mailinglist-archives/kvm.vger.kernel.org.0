Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F0E5D62A06A
	for <lists+kvm@lfdr.de>; Tue, 15 Nov 2022 18:33:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229776AbiKORdz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Nov 2022 12:33:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229681AbiKORdx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Nov 2022 12:33:53 -0500
Received: from mail-io1-xd49.google.com (mail-io1-xd49.google.com [IPv6:2607:f8b0:4864:20::d49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DF212AC5
        for <kvm@vger.kernel.org>; Tue, 15 Nov 2022 09:33:53 -0800 (PST)
Received: by mail-io1-xd49.google.com with SMTP id x21-20020a5d9455000000b006bc1172e639so7573388ior.18
        for <kvm@vger.kernel.org>; Tue, 15 Nov 2022 09:33:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=nIe3yT1+HQrBXVuFKNmxwY54abkZvrfWb4oRBBUIi6c=;
        b=f6nWNyAY8iv7Er5o0ZUs5xFpPd0j/lV+VqSyALWfpVpH1GR4IG54wR1HDoRUjlVxIk
         oY5TmA5Ojiy5XWHafVPq2zf9Opr3YelgVI9t+t0bsq9D7Xx6MBAWE+EOlXuJlzweXXZS
         MwLYVfe+KrEz8tmgg6DKAKbzVEbPRbiDNYUkBlAoSi6I1PxTFGLUy+wwAUwVumtt3yGU
         c81TAd5V2evzwuDo/MdOiKeEFZ3lmM6vm11bBM6WpMycPm8p8UTJFD9FCbMdWMkzim6d
         +GDLQ26WnTT9I/M9q/IvWmQ/yyEPws2eIlQPmhtFnXwymfGaFZIE+TIVeHfh/DK7ptQS
         eqUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=nIe3yT1+HQrBXVuFKNmxwY54abkZvrfWb4oRBBUIi6c=;
        b=BPilMu9GpoMftEVkICKPq7kSO/HzFux/G+E2nYA/EcYJlq4TkJYJ7YRIrD7cs6JE7X
         Nomrul9ShmZo7LSn+beYNgGgDoWdAIpNjTs0vf8CnC0LGlH/eEYqGWGuQHrbxaP/kqGY
         nDfkr2ySKXkZTh4/6/gpfOgyvedcMduZ0sMSm1QWCL3teAOCODD/DLxMDy8NSo1cJx12
         mfOpF0WBjIhK9CjKFOTE42uuUHKjWFtirb7WIPeBS/zdNwIxe36jEbNQ6Y02QlMS6Q2d
         FYVr7tA3UzGTWqBv5xhdVq12syZPpXdZVxm0lzbhFmuzdECRRq+CQUkfF7aZFokuUHlv
         WpFw==
X-Gm-Message-State: ANoB5pkUvhpFUB7RM1aPZWp+UlXxpq6TxK5T7dPXvN25XTfmpiFPgg2C
        C0DnvYC6SXWPr5D6xr9qMe7legVD9YJcmen5Mife3ytg4QaLkkuxICf2ynb8Q5PXzFjms1GEH2x
        iywT2iwb6x4gCcGrta8JfHfaskat72vVOdXOM0UAo9CtSPqdOXjxwkCgr8o7Nrg/Gs57m9D4=
X-Google-Smtp-Source: AA0mqf7SoW/9t9M0PaxItqq9ZeuwWfk81QOHgGiVJKbVoo1O6KusDq5ecqdH0XT+UHgfNt8RBLip+4GQJRlq31b18A==
X-Received: from coltonlewis-kvm.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:14ce])
 (user=coltonlewis job=sendgmr) by 2002:a5d:9757:0:b0:6de:45c0:a077 with SMTP
 id c23-20020a5d9757000000b006de45c0a077mr1265812ioo.104.1668533632482; Tue,
 15 Nov 2022 09:33:52 -0800 (PST)
Date:   Tue, 15 Nov 2022 17:32:55 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.38.1.431.g37b22c650d-goog
Message-ID: <20221115173258.2530923-1-coltonlewis@google.com>
Subject: [PATCH 0/3] Calculate memory access latency stats
From:   Colton Lewis <coltonlewis@google.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, maz@kernel.org, dmatlack@google.com,
        seanjc@google.com, bgardon@google.com, oupton@google.com,
        ricarkol@google.com, Colton Lewis <coltonlewis@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sample the latency of memory accesses in dirty_log_perf_test and
report summary stats to give a picture of the latency
distribution. Specifically, focus on the right tail with the 50th,
90th, and 99th percentile reported in ns.

This patch depends on my previous dirty_log_perf_test patch adding the
ability to randomize memory accesses. It needs the pRNG to do random
sampling.

https://lore.kernel.org/kvm/20221107182208.479157-1-coltonlewis@google.com/

Colton Lewis (3):
  KVM: selftests: Allocate additional space for latency samples
  KVM: selftests: Collect memory access latency samples
  KVM: selftests: Print summary stats of memory latency distribution

 .../selftests/kvm/dirty_log_perf_test.c       |   2 +
 .../selftests/kvm/include/perf_test_util.h    |   2 +
 .../selftests/kvm/lib/perf_test_util.c        | 103 +++++++++++++++++-
 3 files changed, 104 insertions(+), 3 deletions(-)

--
2.38.1.431.g37b22c650d-goog
