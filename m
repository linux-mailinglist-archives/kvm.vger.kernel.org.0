Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BDEA653C2A3
	for <lists+kvm@lfdr.de>; Fri,  3 Jun 2022 04:13:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240287AbiFCApr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Jun 2022 20:45:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240110AbiFCAo4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Jun 2022 20:44:56 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C90E737A3F
        for <kvm@vger.kernel.org>; Thu,  2 Jun 2022 17:44:50 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id h11-20020a65638b000000b003fad8e1cc9bso3057099pgv.2
        for <kvm@vger.kernel.org>; Thu, 02 Jun 2022 17:44:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=xs7zziBFPUnsCTGm7/NQFFIgWUrWQHAsMOhvADp3chY=;
        b=rl3Ey5X+pvfZmP0YafbCZ1YBaxMiUlpGYAoWCQky5IBPRS8XQL55KEVqB8vmZMPwEb
         lQlpO7Tdrv9LJSiycqvOriabnPeFKD/JNRkGwyGDnSMjLAXd1mnCN0tnpZrrwjnAWdv6
         Ys1Wg1SCo0oAjJ2R7isgs62mlSMOk/1BqiitbuCSWjDpgZ/BPbeRL7BbBp9eRz7uq3T7
         PjxJ0IgWqCKjvr4RcwXxmLvzzjH+4+Y9CWwBm6jGAyG7/gVD/xa+pK1Jo1mGn3hRkeEb
         JsDm4v6tFHSbTsA9wVO0SIUR4FqSIzIjLmACEvQ5uA/+jfJas63VjSr51yVD9K7iu14L
         cXJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=xs7zziBFPUnsCTGm7/NQFFIgWUrWQHAsMOhvADp3chY=;
        b=sfqiZkeAG2ly6f2siUDDIH0QG+T+BShKF5jqWFFQxpXW8IcgQjFUhIfJLW3h5nF3Sf
         FPq/gzFSjvIfMNE2lXt3D0b9VS+2SBk10zR0Sazj2LZL1IGbmlyOT8TD+yoeZI5VLy2b
         1Mb8+BLhzrkPbD3/e8AIajfchyjTYxji+zGIdpdsW65Zv60WQO2Le2FqbQDHOYMYx6jO
         Oa5J1rJudd6el/8UKMrVlkVsQT9kkKGSlsuHc+ZNlZneVxAvz2jW+Fkp8iUUTE6I/jfY
         GAbe41swzMMihIcsn4FwGJZcLEEJji1h4/bCTrjpw03c/7o2O3bYg2qyh47Iqex6GbEO
         2/Mw==
X-Gm-Message-State: AOAM532dSe4XdE0FS2Sip3iLcdEex84hccjpC25vm6nu+uYZmI1w9Zpu
        XqF721xH3dSpr+GAbOUayfiqKwR2ddA=
X-Google-Smtp-Source: ABdhPJwfGI4TmKZs4F6NPxueYIX9bOmmw9nwbqRjsq1WitloPZSMHHmCU4XcFtjCu0oiTO01UHvA6FqlU/E=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:902:ebc8:b0:15f:3f5d:9d08 with SMTP id
 p8-20020a170902ebc800b0015f3f5d9d08mr7526106plg.121.1654217090220; Thu, 02
 Jun 2022 17:44:50 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri,  3 Jun 2022 00:41:47 +0000
In-Reply-To: <20220603004331.1523888-1-seanjc@google.com>
Message-Id: <20220603004331.1523888-41-seanjc@google.com>
Mime-Version: 1.0
References: <20220603004331.1523888-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.1.255.ge46751e96f-goog
Subject: [PATCH v2 040/144] KVM: selftests: Use vm_create_without_vcpus() in dirty_log_test
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

Use vm_create_without_vcpus() instead of open coding a rough equivalent.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/dirty_log_test.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/kvm/dirty_log_test.c b/tools/testing/selftests/kvm/dirty_log_test.c
index 9dfc861a3cf3..13962d107948 100644
--- a/tools/testing/selftests/kvm/dirty_log_test.c
+++ b/tools/testing/selftests/kvm/dirty_log_test.c
@@ -674,11 +674,8 @@ static struct kvm_vm *create_vm(enum vm_guest_mode mode, uint32_t vcpuid,
 
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
2.36.1.255.ge46751e96f-goog

