Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC18B51B259
	for <lists+kvm@lfdr.de>; Thu,  5 May 2022 00:51:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379565AbiEDWzE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 May 2022 18:55:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379462AbiEDWyH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 May 2022 18:54:07 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 342581D0D8
        for <kvm@vger.kernel.org>; Wed,  4 May 2022 15:50:27 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id f7-20020a6547c7000000b003c600995546so780948pgs.5
        for <kvm@vger.kernel.org>; Wed, 04 May 2022 15:50:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=NtspSlUg4ML5uMJ7vjR/+OVkX26xwVVuotNivGjDjEw=;
        b=i8p9S2Q1YB++zvCiyZcgldBtm/WJw9SzZVcpnlekEf4KNcXr57t+cI2f9o5y/+bouz
         hD3fCxoTJpO5y9V2EzM/7R69ywUoevXk1abQq/HM9nkCdKIe4TVijfS0UNDXifnnpzzq
         uSm2bEf1r2cKU34QG5U9TK6Kp2LkoTvd1PyHpZFJM0qshIwz/IfxjMUIgFSa2hdETFW3
         oZdOHglDbZJckyotMHLZJW9AD6sTY1QZ+4kFZe9iuaYB8345EP8ET8P8dJvxYYt+yu+7
         w6Yn10lgUwLSQwS+7zSLiigBIbryXfcgT+F5dt/hTPRABsc8OigVmItPBCOYYOWe2KMp
         LlCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=NtspSlUg4ML5uMJ7vjR/+OVkX26xwVVuotNivGjDjEw=;
        b=hubjMpDoby2em24z7xVkCsGWoLV0J1SEogWtSKudUwNkzAT6N/4hYkHcap7mv+tawZ
         ZoLEHCf8WG9bwYtrk4FR1Fs0TFXD9ZDzkd+hOkDmXzPJa9JptYurbVZz8Mf3dMhJKG45
         +X1mosMNUmxoXXaU7Ug0G5IaOqCzHq/k6m8DeE5kN+Bk4T5eis3TlRKSQFna2Fw/Nfka
         3WsZ4NCYTGksBcKGYiHULr0Fbnwg/qrIYDYOSjreyJAvBC7HzVIyXxFNSSRRaK4xO/tm
         U8RyHLR1zyX9ggU8tH76ZrvacxKWiI7t1aTTDF15J2u98apC4ntIJb/n/vtKKIBiMXej
         TX2A==
X-Gm-Message-State: AOAM5315nb4tuB7qB9ikRvPmV9UXsy6ACwo99WnQPivweOig5wHs+6GB
        zMKJMsm4Uxh4quChmjyZTB9MP3KLTNM=
X-Google-Smtp-Source: ABdhPJxP1o0Y315OZJ5ArQVikvoycdcvFzlcnlwt1FfAgnv3BEg3jUo17c3+V0ncJnPB8bB7WS9S+77NCuY=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:902:7d81:b0:14f:e18b:2b9e with SMTP id
 a1-20020a1709027d8100b0014fe18b2b9emr23642359plm.160.1651704626657; Wed, 04
 May 2022 15:50:26 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed,  4 May 2022 22:47:38 +0000
In-Reply-To: <20220504224914.1654036-1-seanjc@google.com>
Message-Id: <20220504224914.1654036-33-seanjc@google.com>
Mime-Version: 1.0
References: <20220504224914.1654036-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.0.464.gb9c8b46e94-goog
Subject: [PATCH 032/128] KVM: selftests: Use vm_create_without_vcpus() in dirty_log_test
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

Use vm_create_without_vcpus() instead of open coding a rough equivalent.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/dirty_log_test.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/kvm/dirty_log_test.c b/tools/testing/selftests/kvm/dirty_log_test.c
index 5752486764c9..74dcac0c22c5 100644
--- a/tools/testing/selftests/kvm/dirty_log_test.c
+++ b/tools/testing/selftests/kvm/dirty_log_test.c
@@ -677,11 +677,8 @@ static struct kvm_vm *create_vm(enum vm_guest_mode mode, uint32_t vcpuid,
 
 	pr_info("Testing guest mode: %s\n", vm_guest_mode_string(mode));
 
-	vm = __vm_create(mode, DEFAULT_GUEST_PHY_PAGES + extra_pg_pages);
-	kvm_vm_elf_load(vm, program_invocation_name);
-#ifdef __x86_64__
-	vm_create_irqchip(vm);
-#endif
+	vm = vm_create_without_vcpus(mode, DEFAULT_GUEST_PHY_PAGES + extra_pg_pages);
+
 	log_mode_create_vm_done(vm);
 	vm_vcpu_add_default(vm, vcpuid, guest_code);
 	return vm;
-- 
2.36.0.464.gb9c8b46e94-goog

