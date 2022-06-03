Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C81C53C1F3
	for <lists+kvm@lfdr.de>; Fri,  3 Jun 2022 04:12:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240447AbiFCAs2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Jun 2022 20:48:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240160AbiFCAo4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Jun 2022 20:44:56 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A3BB33887
        for <kvm@vger.kernel.org>; Thu,  2 Jun 2022 17:44:53 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id s204-20020a632cd5000000b003fc8fd3c242so3053374pgs.7
        for <kvm@vger.kernel.org>; Thu, 02 Jun 2022 17:44:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=7A8GiPLt6EoF/z44Q/QbLAgMh/pfSDViGpWaAyP0lNo=;
        b=B1KfeW2a9/1TfkltckkoZ60LPG+bawSDqzkpC489MqN1H8fWcdo5nFZJzzK4cmQ8l/
         hKDM9nR3vfGYS9nNw/J8+JwhOjn6BIYTb+uu7nM90EfN8s+RETfp0Atr7zD8PQpXd2T9
         /s+rYdvuPEDo/qWZoUJIHtEGNUbpKVNIj3kIDiOrJtNfr8mzD9HaKGG/dH7J32EAfs/6
         ujGbGYjJONRdCwkqLLpZsdBa+GBtSMvWBqQ8PDLk987uYfxcvX085Edv0dTB0CbTbLHe
         zADgKWxBEPNvk4jg98bcmtD+0r2+SO4IkFkAsRGDs0ixUQCx9zrwWkAyBSQB6O1TcgqS
         WafA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=7A8GiPLt6EoF/z44Q/QbLAgMh/pfSDViGpWaAyP0lNo=;
        b=uHO2khQl1lgpRQqoJHJ66AS9EHqg0ieG+gb1QggY8Yhia28yTTehP/ppmqg1LyCKOj
         ZteH2dl/RPyhLqfSpzi94NV2tS/jKvpDWbowryNPTd7PGBuiuhguXhgsON20LDS7E+kN
         yj+TMlzqj4znkB+6Ok5czDsBHtpH4eQDVWHNfWXK3j50nNO2tC9f5TAljfCqlEwVBOzo
         LhiKwGPnQLHjrtcUbbzCh2bLPtNqKuLoU8iKXU9WiSDwG+xZLN0Uo65O6rKnb8ePJ6FP
         TO8Utvm7TDnoka+KEq73rFMDp7zyENRH9R8vwUTi6d8C7j2tSXnGnGN9b02CC8vEIv+J
         iqmQ==
X-Gm-Message-State: AOAM533iLHKozjozGXcaUFaemdQSkZiDmcomjc9atQRzq/RbvUonC/3S
        PgpgSQm8jlCeX5odNNDlVEIKpdUCzEk=
X-Google-Smtp-Source: ABdhPJyqULkt9W5iKgiGsrs4OX7xQlTTQ/jv+FTiHMuIzKb8AbQnx5geegletFi/oRSJteP8T4rrDu0rwFE=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:90a:249:b0:1e0:a8a3:3c6c with SMTP id
 t9-20020a17090a024900b001e0a8a33c6cmr307297pje.0.1654217092129; Thu, 02 Jun
 2022 17:44:52 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri,  3 Jun 2022 00:41:48 +0000
In-Reply-To: <20220603004331.1523888-1-seanjc@google.com>
Message-Id: <20220603004331.1523888-42-seanjc@google.com>
Mime-Version: 1.0
References: <20220603004331.1523888-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.1.255.ge46751e96f-goog
Subject: [PATCH v2 041/144] KVM: selftests: Use vm_create_without_vcpus() in hardware_disable_test
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Vitaly Kuznetsov <vkuznets@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>,
        Oliver Upton <oupton@google.com>, linux-kernel@vger.kernel.org
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

Use vm_create_without_vcpus() instead of open coding a rough equivalent
in hardware_disable_test.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/hardware_disable_test.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/tools/testing/selftests/kvm/hardware_disable_test.c b/tools/testing/selftests/kvm/hardware_disable_test.c
index 81ba8645772a..32837207fe4e 100644
--- a/tools/testing/selftests/kvm/hardware_disable_test.c
+++ b/tools/testing/selftests/kvm/hardware_disable_test.c
@@ -104,9 +104,7 @@ static void run_test(uint32_t run)
 	for (i = 0; i < VCPU_NUM; i++)
 		CPU_SET(i, &cpu_set);
 
-	vm = vm_create(DEFAULT_GUEST_PHY_PAGES);
-	kvm_vm_elf_load(vm, program_invocation_name);
-	vm_create_irqchip(vm);
+	vm  = vm_create_without_vcpus(VM_MODE_DEFAULT, DEFAULT_GUEST_PHY_PAGES);
 
 	pr_debug("%s: [%d] start vcpus\n", __func__, run);
 	for (i = 0; i < VCPU_NUM; ++i) {
-- 
2.36.1.255.ge46751e96f-goog

