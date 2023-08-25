Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24B70787D9A
	for <lists+kvm@lfdr.de>; Fri, 25 Aug 2023 04:24:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234684AbjHYCYM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Aug 2023 22:24:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232292AbjHYCYD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Aug 2023 22:24:03 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FDDA1BE5
        for <kvm@vger.kernel.org>; Thu, 24 Aug 2023 19:24:01 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 3f1490d57ef6-d74a0f88457so540757276.2
        for <kvm@vger.kernel.org>; Thu, 24 Aug 2023 19:24:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692930241; x=1693535041;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=q394Ar5VGXqRlzD/NOIbDeE7m1nz83tkHb6zDhW+OcY=;
        b=AREqEKG77fow5gLN288m8+5PgrXZDGnPkjkz/MhIL4sXOI5/b98+arPqseArPrdnuA
         VYdil6Y4mRyydkQz6r4hxjE7DhwQ1BqxHSg1aam7d6iThWpe7LLwJ7w6mfLome0aZGqt
         CiFrXkk1P33R/JZT6Hf5YZ8l5bIdqNGhZaFlRX3kKZuqAhEEqdCJmsLEhh+timjnJK+s
         ANPv/T8KWgyPFHA39S60ov5IqwRy21ki7qiXq/dkE3szFqmZQQMgAPD0tv8UbtRvHQHy
         ogvdGILJen5nMNuyly6aH7XNRAnrKf2j45Ukr5/bZWbu2i3S7vPK+F1Vm1C/jymcWYRQ
         QH/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692930241; x=1693535041;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=q394Ar5VGXqRlzD/NOIbDeE7m1nz83tkHb6zDhW+OcY=;
        b=R1fspJsEQJMCXsn1jJdBuDDMgJqiNVftORuwPUh8mwQGpN8ZvYIKy5+xtmuE8LW2RG
         UoQ/XRisyp5+Mtv75BGSJL0sP5P+f/DSimMcGn7FOSVQZGHX1o8/PIb1NhmCj7HHscKY
         ubinY57oILSJr/hojlwktqkde9ODfKnBffN0j5lW/otSstqMMQZjOPDWADpoTTxMYrd2
         O3Gc69cZSiO5HBFNocOMLjrUot/zDfLQY3sJnHf3uk4K6/QEbvLO89zKwSPvqpGRNx0H
         kCbS6zPDy74hwAFBUoBRJtGymd7dF2191Odc4A6jrEPussbEK77NgxXgvt22VFIM9Je2
         ADMA==
X-Gm-Message-State: AOJu0Ywrf7MBU3wNli05YTvOjQWtSOfzlTuLuVJdNA4m8t1/yTmELNq2
        g7U1wLLN4M08mrvapywmZmHRB5ZE8iM=
X-Google-Smtp-Source: AGHT+IH4Zo1Gu1BLnxnojSCV6KHCOezP9EJuBkVATQO+/bUOmJwM/V4Q7F91c9SlK+gQ/GYpdyMME4el8FA=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:8211:0:b0:d4f:d7a5:ba3b with SMTP id
 q17-20020a258211000000b00d4fd7a5ba3bmr346930ybk.8.1692930240827; Thu, 24 Aug
 2023 19:24:00 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu, 24 Aug 2023 19:23:55 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.42.0.rc2.253.gd59a3bf2b4-goog
Message-ID: <20230825022357.2852133-1-seanjc@google.com>
Subject: [PATCH 0/2] KVM: SVM: Fix SEV-ES intrahost migration
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Peter Gonda <pgonda@google.com>
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

Fix two fatal bugs in SEV-ES intrahost migration, found by running
sev_migrate_tests (:shocked-pikachu:).

IIRC, for some reason our platforms haven't played nice with SEV-ES on
upstream kernels for a while, i.e. the test hasn't been run as part of my
usual testing. 

Sean Christopherson (2):
  KVM: SVM: Get source vCPUs from source VM for SEV-ES intrahost
    migration
  KVM: SVM: Skip VMSA init in sev_es_init_vmcb() if pointer is NULL

 arch/x86/kvm/svm/sev.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)


base-commit: fff2e47e6c3b8050ca26656693caa857e3a8b740
-- 
2.42.0.rc2.253.gd59a3bf2b4-goog

