Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9DBC351B270
	for <lists+kvm@lfdr.de>; Thu,  5 May 2022 00:51:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379290AbiEDWzH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 May 2022 18:55:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379475AbiEDWyI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 May 2022 18:54:08 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 970AFE4F
        for <kvm@vger.kernel.org>; Wed,  4 May 2022 15:50:30 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id bj12-20020a170902850c00b0015adf30aaccso1365050plb.15
        for <kvm@vger.kernel.org>; Wed, 04 May 2022 15:50:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=1aNRK/v5PJV+kxqA6liInwVdvDu0u370B7s4ZQwy8dY=;
        b=o2163Irn7XxC//LJc+Tjo7pLivoUvw3p/c5fGf8IovDvdplxbQFlL9ZQp6ypiU51U4
         jKbAIWMkpgoc0q8VVUR9uT9eznXfUsPDHdpEdLU8zpCfpaIzwf6XuiKzHAx3kDnLIJf1
         yQxNaxFXU/M9JNhKAats9oXfLZOo68wofk4EMPxk+fGzLNKnO++MADnZr1qDY546e46y
         9J1RHybWx95zGWf6bEh0IJ5DHNBwTzgZhr5/+5uBT3bE39FKxfVVqlsYIVWkxn27CDoD
         m42nouqq34Q/NRFVtCyptDtloXsFyZSnsPn1iQJaalrVLJyHBECRyX1pS+6WQHrC+Fpp
         xkkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=1aNRK/v5PJV+kxqA6liInwVdvDu0u370B7s4ZQwy8dY=;
        b=KpIiIzOLyZYN1iRgljzAjp8t6AfSp34oH0Rop2JOL+JTWYFQR1NC5H+pNoaPheCDuP
         eSY2kV9YNjKOoIg0a6YDt8aBk7eP2PR3R5FowCDgXMoSu/50UV40AZ/4cgeRg3KKW+GM
         2XQC+00ziQHAG7+bJbJ1q1CnIiqRnKnTzjbxh2ngbj214gw/4Y4hQKaT+9mOdjtakdLH
         8kNMfQbWW4XqwkmXp4OufJZy0YKLTCWhoup00a9sXonVc0MgkUbRd6LHDLmVBakPiY0m
         XifTtUJfDbGYBtaclhj9EtuZJtlnfjolWmtsEVDdGWUwEGMoejyKdrVednaY+DeEYFpx
         xLlw==
X-Gm-Message-State: AOAM531xDWoXnclNFEa8F1/Pg2Irau7X3Vx036zzqy8to/BZf5AfctJx
        boLyT8jpID3wS4CUHWAj2uSQ1VvX118=
X-Google-Smtp-Source: ABdhPJyiJRX6wi6I/Yfk/jzv+rbmknQ3xM/rsEhoAMsjXeMRkrqbQWi8O9GK5F8UZH2jawvA2g3f0YE9xgc=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:2484:b0:50e:68e:d5a5 with SMTP id
 c4-20020a056a00248400b0050e068ed5a5mr11922192pfv.47.1651704630068; Wed, 04
 May 2022 15:50:30 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed,  4 May 2022 22:47:40 +0000
In-Reply-To: <20220504224914.1654036-1-seanjc@google.com>
Message-Id: <20220504224914.1654036-35-seanjc@google.com>
Mime-Version: 1.0
References: <20220504224914.1654036-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.0.464.gb9c8b46e94-goog
Subject: [PATCH 034/128] KVM: selftests: Use vm_create_without_vcpus() in psci_cpu_on_test
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>,
        Oliver Upton <oupton@google.com>,
        Sean Christopherson <seanjc@google.com>
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
in psci_cpu_on_test.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/aarch64/psci_cpu_on_test.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/tools/testing/selftests/kvm/aarch64/psci_cpu_on_test.c b/tools/testing/selftests/kvm/aarch64/psci_cpu_on_test.c
index bde7bae20a6e..b4b0fa5d7c21 100644
--- a/tools/testing/selftests/kvm/aarch64/psci_cpu_on_test.c
+++ b/tools/testing/selftests/kvm/aarch64/psci_cpu_on_test.c
@@ -76,8 +76,7 @@ int main(void)
 	struct kvm_vm *vm;
 	struct ucall uc;
 
-	vm = vm_create(DEFAULT_GUEST_PHY_PAGES);
-	kvm_vm_elf_load(vm, program_invocation_name);
+	vm = vm_create_without_vcpus(VM_MODE_DEFAULT, DEFAULT_GUEST_PHY_PAGES);
 	ucall_init(vm, NULL);
 
 	vm_ioctl(vm, KVM_ARM_PREFERRED_TARGET, &init);
-- 
2.36.0.464.gb9c8b46e94-goog

