Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB8FD53C2C8
	for <lists+kvm@lfdr.de>; Fri,  3 Jun 2022 04:13:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240292AbiFCApx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Jun 2022 20:45:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240159AbiFCAo4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Jun 2022 20:44:56 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B4462250E
        for <kvm@vger.kernel.org>; Thu,  2 Jun 2022 17:44:54 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id v9-20020a17090a00c900b001df693b4588so3396910pjd.8
        for <kvm@vger.kernel.org>; Thu, 02 Jun 2022 17:44:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=hnhNz3Ofe6LEPVXH+Amyp+XINRrzOMpsHHCdOeUGVmg=;
        b=kTTX6shv/RmLvPSjjFRuP0FKoEB6fBja5N2hjLlvRl9c4lVLzxZHmFC3V1+jOAwAUH
         y3OHKXroMxXps81s19DFEZa4UCkblB0rWVyo5MEL2YE1IT7o7478ZsDpaAFlwxcywCa1
         L7sRfI+w+lhmd9Z3WDoOTfRX+48xPt3tX3bJ0iG4jSn25uyP79YJ6LxtIpKCrrXk5jTy
         Ut2Z/S47K9RezDu/W+b5981Ahi67oIouC/sCNjpUE4STwLt8yhyg8D0Xl564af1IZFgz
         lFFNA8bfrz7Vu7uWax1JLzE0uWb13xLgneXbWIJeBtAVEpqVlTD2oPOx19RNx6KF/Pty
         pNbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=hnhNz3Ofe6LEPVXH+Amyp+XINRrzOMpsHHCdOeUGVmg=;
        b=0I5qJiOudAcU2cEMXU48EfWdN5H6B7/L9ZTZ72m2hrD3zQWGknf73PNHAGZkDmETl/
         xTzh/4Ax7XIf8hWRcWBbQcSxgU4GavcZBKY4/N7scaamXAV/+O2e2EkSra+h/OwF4TXv
         zMzK8iGFCUwiDXWFbNOddZPazY+JcKZ8rvwvhwvtT7Fzsy3dKDQ6dhwNBQx+fvRgmNkj
         2EFxtY5cSltLpm8dVk8TGN4wU7gzANnsMCYjpKSnd/BUddJoDxwXsorz1CzPfYeXdUKk
         9tjvomg7duq/Fz2T2jl9DZhmdfRaNtWazCuQVAtBEF7rZWyAgYP1ALKFRJF3aNv9SbeL
         ezGw==
X-Gm-Message-State: AOAM533UfzmiJoKJqj6KoJPMl7d8OFn7u5yIINaiQMKhADjGo0wu7/m3
        zKrfxACNmI6QVSw4nX+/2ojpJClvPGk=
X-Google-Smtp-Source: ABdhPJw8pu/Nf51rsweJnU5stWxffZj9igryX7G6VP1K81DCh4dmzRq0Q5Szzb/vxWxRDLUWN9nTXEEobUg=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a65:6250:0:b0:3c6:8a09:249 with SMTP id
 q16-20020a656250000000b003c68a090249mr6575731pgv.389.1654217094111; Thu, 02
 Jun 2022 17:44:54 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri,  3 Jun 2022 00:41:49 +0000
In-Reply-To: <20220603004331.1523888-1-seanjc@google.com>
Message-Id: <20220603004331.1523888-43-seanjc@google.com>
Mime-Version: 1.0
References: <20220603004331.1523888-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.1.255.ge46751e96f-goog
Subject: [PATCH v2 042/144] KVM: selftests: Use vm_create_without_vcpus() in psci_test
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
in psci_test.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/aarch64/psci_test.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/tools/testing/selftests/kvm/aarch64/psci_test.c b/tools/testing/selftests/kvm/aarch64/psci_test.c
index 1485d0b05b66..c9b82c0cc8d5 100644
--- a/tools/testing/selftests/kvm/aarch64/psci_test.c
+++ b/tools/testing/selftests/kvm/aarch64/psci_test.c
@@ -78,8 +78,7 @@ static struct kvm_vm *setup_vm(void *guest_code)
 	struct kvm_vcpu_init init;
 	struct kvm_vm *vm;
 
-	vm = vm_create(DEFAULT_GUEST_PHY_PAGES);
-	kvm_vm_elf_load(vm, program_invocation_name);
+	vm = vm_create_without_vcpus(VM_MODE_DEFAULT, DEFAULT_GUEST_PHY_PAGES);
 	ucall_init(vm, NULL);
 
 	vm_ioctl(vm, KVM_ARM_PREFERRED_TARGET, &init);
-- 
2.36.1.255.ge46751e96f-goog

