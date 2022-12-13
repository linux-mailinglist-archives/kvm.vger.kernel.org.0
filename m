Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B304164AC22
	for <lists+kvm@lfdr.de>; Tue, 13 Dec 2022 01:17:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234040AbiLMARL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Dec 2022 19:17:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234068AbiLMARD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Dec 2022 19:17:03 -0500
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76A9D1B1D4
        for <kvm@vger.kernel.org>; Mon, 12 Dec 2022 16:17:02 -0800 (PST)
Received: by mail-pl1-x649.google.com with SMTP id z3-20020a170903018300b0018fb8ca1688so1075591plg.5
        for <kvm@vger.kernel.org>; Mon, 12 Dec 2022 16:17:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=VfLoNklydv1Rx7BbDoYbdEShyybLFjnrLL1BXeied2s=;
        b=Np8Pq4oyEyyT2NyWGRKhWCpWIKtgc9sp8/et+JS0meGK40iG694E/NYaxXnGXI0TeV
         pAqfSNQC9vcFF79zhXWsirFoGVcn/ax8QgBGxRa1cPYoIDxMNNUz5Jy5AAULOm6SCGAc
         A2EcZLEvvZLS7jcBAxKT7lr/7OJrXxxqMEoWAQweL0OpkQpBF4AL+mTwyhLSigeUVQn6
         9Uvgy3sr74Bmqei662+yAOCZ0l8TL9YTXwynudahz8OX6nc2S0ETlzEpyU5P3RT68+za
         4pvvwlntGLripZEbM1cWf+TCuKTaMguNXMxoTUo9YXqHgb5qZ0Tn/RXjzCP4PZWndVdL
         rjEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=VfLoNklydv1Rx7BbDoYbdEShyybLFjnrLL1BXeied2s=;
        b=yQdZA9jDu76XqJ6tnZrr7Gw8EGPhmBYMD+CCDBqg8c2hd2e8NMFZUf+YGM+n3jQOW/
         yKJNcXNAQQ5RQG1hLwNpo1yHGVDgWiHQddUXXv7XECYHhJPgnkwDmuF2PkKlYvpiu990
         9YBqCoyN3wXofyPExEvmF/T0/Ado+t/xKRN7kfXbJMRMOCXz9WQ51rxVNhS63h/Il2wl
         tju8IgPyC7OonYgplylzxrmsA4/U0bHpIEsJqgRSIq28f7GyNZh8/kDD1k8mE+Ha82Sn
         h/zE/ArKF8fv0m3JGz7CgJ0bQo71SWVjIAcWDRbFe6oH7edZ2xc8MckcFq1H1d/8DtLO
         dXEg==
X-Gm-Message-State: ANoB5pnJiJ4jNSktyp3ZoXGCTcvmOp5029rM+wOZACwyNZAOoe8DlO2P
        MXZC1VyF/7w0bJRb66Bqoraq+2xi4jQ=
X-Google-Smtp-Source: AA0mqf7S5eF8bMFJxVX+zccSnQS8wrFbP/BiB/u3t9DV1AwKakqfaO4vcQavHYooXhlu853wx6mxrrDMel4=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90b:1010:b0:219:1d0a:34a6 with SMTP id
 gm16-20020a17090b101000b002191d0a34a6mr4049pjb.1.1670890621685; Mon, 12 Dec
 2022 16:17:01 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 13 Dec 2022 00:16:42 +0000
In-Reply-To: <20221213001653.3852042-1-seanjc@google.com>
Mime-Version: 1.0
References: <20221213001653.3852042-1-seanjc@google.com>
X-Mailer: git-send-email 2.39.0.rc1.256.g54fd8350bd-goog
Message-ID: <20221213001653.3852042-4-seanjc@google.com>
Subject: [PATCH 03/14] KVM: selftests: Fix divide-by-zero bug in memslot_perf_test
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>
Cc:     James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Tom Rix <trix@redhat.com>, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        kvmarm@lists.cs.columbia.edu, linux-riscv@lists.infradead.org,
        llvm@lists.linux.dev, linux-kernel@vger.kernel.org,
        Ricardo Koller <ricarkol@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Aaron Lewis <aaronlewis@google.com>,
        Raghavendra Rao Ananta <rananta@google.com>
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

Check that the number of pages per slot is non-zero in get_max_slots()
prior to computing the remaining number of pages.  clang generates code
that uses an actual DIV for calculating the remaining, which causes a #DE
if the total number of pages is less than the number of slots.

  traps: memslot_perf_te[97611] trap divide error ip:4030c4 sp:7ffd18ae58f0
         error:0 in memslot_perf_test[401000+cb000]

Fixes: a69170c65acd ("KVM: selftests: memslot_perf_test: Report optimal memory slots")
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/memslot_perf_test.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/tools/testing/selftests/kvm/memslot_perf_test.c b/tools/testing/selftests/kvm/memslot_perf_test.c
index e698306bf49d..e6587e193490 100644
--- a/tools/testing/selftests/kvm/memslot_perf_test.c
+++ b/tools/testing/selftests/kvm/memslot_perf_test.c
@@ -265,6 +265,9 @@ static uint64_t get_max_slots(struct vm_data *data, uint32_t host_page_size)
 	slots = data->nslots;
 	while (--slots > 1) {
 		pages_per_slot = mempages / slots;
+		if (!pages_per_slot)
+			continue;
+
 		rempages = mempages % pages_per_slot;
 		if (check_slot_pages(host_page_size, guest_page_size,
 				     pages_per_slot, rempages))
-- 
2.39.0.rc1.256.g54fd8350bd-goog

