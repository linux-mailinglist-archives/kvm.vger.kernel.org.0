Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72A6674FBA1
	for <lists+kvm@lfdr.de>; Wed, 12 Jul 2023 01:02:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232091AbjGKXBs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Jul 2023 19:01:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232054AbjGKXBn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Jul 2023 19:01:43 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFA701710
        for <kvm@vger.kernel.org>; Tue, 11 Jul 2023 16:01:42 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id d9443c01a7336-1b896096287so91165825ad.0
        for <kvm@vger.kernel.org>; Tue, 11 Jul 2023 16:01:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1689116502; x=1691708502;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=5/AE+ITsqvmioGa40XEXVYetYnCHAyNbSGcDIdfkEo0=;
        b=UGGyrEU2rRB+Omiva8nPATSlSEqaSxk63p3TInzxbWo+/6QMUITBxd8zKcCdqBQOgv
         ZvTdd4ljaWKsFJkcCTatWT46sovnTwclM3/vSjyjtmHtJXe6znNmbMjUusE9neFjUoLS
         rju2Mx09S26eioR9MSOvX+6ArkkP7bT0Fe9xCiK+OJw4y45IjAylZheoBTmlkqcUjpKK
         CkVn/r4bAFP2KnbOGhGWi2PXasUE0PPcGlwau50UwGsgu855fnirqWiooWSEhgOX5N0o
         LcJPUsnrx5OW/JMAi9yuRFoKReQL0RUmtSL7gKmnWL3uIoDU2UcuhPkyf1kgGdnpORmW
         Vt1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689116502; x=1691708502;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5/AE+ITsqvmioGa40XEXVYetYnCHAyNbSGcDIdfkEo0=;
        b=aY4QOzHPfD3Mr4s29QXrGpI16jDFKKgdOpHqzDE7n6Ce8fySxIyLR5gp96qcvjpTTZ
         Vwkz7XnGvevTqobPVmBcnD8r1hcQisJ0hleb3W9h9kjC8JGuUtgjwmAl5uX+QeERR4PB
         GXXESxf4ZQTqWc8OnW06qymOawr7LJ3OWW3AK1mh27Io4ZHhFZypf0/8tDADDSNKljdQ
         zZ8re1XmwM/JDDlyKhTGUKHV5QW9Ycd/vtillA6gMSNDz7lqx19FJ6BgVoaeHFJLMTtM
         1Bcnlsu9F00GFP5G3KkJxTCH5kpDtV1Aaq3WyEZsv7uTV8Ex0d1mAKvGcu3A9Wlm8aDe
         6Tuw==
X-Gm-Message-State: ABy/qLbzTC7hebtPzKX0Z0LAR+Buno8r0+ELzLtJJitwgoNl/yJpjRka
        NncZkgGePZrczOcxqqNKjg6OCZmFVfo=
X-Google-Smtp-Source: APBJJlFn9f27q2unG9NlnsNp+cUz++DpEnxoagI+8yGC0xjV9dz5nGMU5qsqNYDVIwOYj7tKo4m8T++oD5g=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:ee55:b0:1b8:2cee:946b with SMTP id
 21-20020a170902ee5500b001b82cee946bmr13684768plo.11.1689116502354; Tue, 11
 Jul 2023 16:01:42 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 11 Jul 2023 16:01:28 -0700
In-Reply-To: <20230711230131.648752-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230711230131.648752-1-seanjc@google.com>
X-Mailer: git-send-email 2.41.0.255.g8b1d071c50-goog
Message-ID: <20230711230131.648752-5-seanjc@google.com>
Subject: [PATCH 4/7] KVM: selftests: Explicitly free vcpus array in binary
 stats test
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Zheng Zhang <zheng.zhang@email.ucr.edu>,
        Kees Cook <keescook@chromium.org>,
        Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        USER_IN_DEF_DKIM_WL autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Explicitly free the all-encompassing vcpus array in the binary stats test
so that the test is consistent with respect to freeing all dynamically
allocated resources (versus letting them be freed on exit).

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/kvm_binary_stats_test.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/kvm/kvm_binary_stats_test.c b/tools/testing/selftests/kvm/kvm_binary_stats_test.c
index f02663711c90..874fa5092551 100644
--- a/tools/testing/selftests/kvm/kvm_binary_stats_test.c
+++ b/tools/testing/selftests/kvm/kvm_binary_stats_test.c
@@ -236,6 +236,7 @@ int main(int argc, char *argv[])
 	for (i = 0; i < max_vm; ++i)
 		kvm_vm_free(vms[i]);
 	free(vms);
+	free(vcpus);
 
 	ksft_finished();	/* Print results and exit() accordingly */
 }
-- 
2.41.0.255.g8b1d071c50-goog

