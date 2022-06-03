Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B7AD53C25C
	for <lists+kvm@lfdr.de>; Fri,  3 Jun 2022 04:12:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240357AbiFCAqV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Jun 2022 20:46:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240149AbiFCAoz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Jun 2022 20:44:55 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80BDC37A3A
        for <kvm@vger.kernel.org>; Thu,  2 Jun 2022 17:44:46 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id c191-20020a621cc8000000b0051bd765ffc5so897845pfc.21
        for <kvm@vger.kernel.org>; Thu, 02 Jun 2022 17:44:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=2V4R3DmFXt5+6CqfKg8Az1wm17KtvGgb3jxI6xyMuyw=;
        b=mncGi7QGRUiFpwVPv+JrkoqIs+Sb5wG30Uc2+1n3Wf/sFo3XqlBfdNaCmrKgQYkgh+
         S2wwkG/hHqricTFWNmkXYYWG62tj1pgK+xgbfr00jU79O1MaZvJaN38SKsoD9f6SNl8l
         SfOAifDADJ8fRVZgKSaePKvvzxYa0pYTupP263tqvo6e2SwiMcKErMl0M38ok9dkq49P
         2zKKHjMCY0Or/Sssu+pD9qngBjyUO6MnxCfUbPKFOwx/TANo20AgfdxZZ8au5P+xSupz
         dh5GGQrH955+Nc0guHv6zLbOcS7c/egaIZ3KnUEDigec3atlcbb3gbpmHE3FX/IwJsvu
         SWHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=2V4R3DmFXt5+6CqfKg8Az1wm17KtvGgb3jxI6xyMuyw=;
        b=6rJquaaRvLxM1CQITJZRIpLnqtDRxTqc6Brxa6R3QCmfP0eMERFWuQPNY/MWSc9sQx
         Mg7LzAHSrhUfRt2pZVpMe4rrtlXtscuW+XvBahot6gxtMmhtBjYZKEHOjKGFx1DiPEL0
         n+zMf+Dhb1gtKROgbbirFSUbqJlzo5q4XvqYIcLpD4uoqSUm8JN6n8B1sJfspEKdbA53
         D+caXx6bxe7AxAoKvyyATuAljW/T8S7rzm/gbbmgZXaTxtIZHPyD+/q+8izlUT02aI62
         iS8Bzbxgz6Pux91LdXkPXNAU4+dcZ9+jxuj5Gz4f+mrsaxmFqjg61eqqxlAiSFGp63aE
         CrWA==
X-Gm-Message-State: AOAM533qiKUIIzA8l99US2QVZ3uW+THjlADaiYbqsbmQIXzCvG+nDcab
        1TA6vDZECGcaZfxoeIPTy14tRNkM7T8=
X-Google-Smtp-Source: ABdhPJwCO++fxWmXvhDMlLk6g06ZaTINDmu8iWjYidy97P2kM3TMUuq9Be1nt9NwrFUj4K/NZD2I6Y7rDhQ=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:90a:249:b0:1e0:a8a3:3c6c with SMTP id
 t9-20020a17090a024900b001e0a8a33c6cmr307295pje.0.1654217085607; Thu, 02 Jun
 2022 17:44:45 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri,  3 Jun 2022 00:41:45 +0000
In-Reply-To: <20220603004331.1523888-1-seanjc@google.com>
Message-Id: <20220603004331.1523888-39-seanjc@google.com>
Mime-Version: 1.0
References: <20220603004331.1523888-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.1.255.ge46751e96f-goog
Subject: [PATCH v2 038/144] KVM: selftests: Push vm_adjust_num_guest_pages()
 into "w/o vCPUs" helper
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
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Move the call to vm_adjust_num_guest_pages() from vm_create_with_vcpus()
down into vm_create_without_vcpus().  This will allow a future patch to
make the "w/o vCPUs" variant the common inner helper, e.g. so that the
"with_vcpus" helper calls the "without_vcpus" helper, instead of having
them be separate paths.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/lib/kvm_util.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 1c5caf2ddca4..6b0b65c26d4d 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -282,6 +282,8 @@ struct kvm_vm *vm_create_without_vcpus(enum vm_guest_mode mode, uint64_t pages)
 {
 	struct kvm_vm *vm;
 
+	pages = vm_adjust_num_guest_pages(VM_MODE_DEFAULT, pages);
+
 	vm = __vm_create(mode, pages);
 
 	kvm_vm_elf_load(vm, program_invocation_name);
@@ -341,8 +343,6 @@ struct kvm_vm *vm_create_with_vcpus(enum vm_guest_mode mode, uint32_t nr_vcpus,
 		    "nr_vcpus = %d too large for host, max-vcpus = %d",
 		    nr_vcpus, kvm_check_cap(KVM_CAP_MAX_VCPUS));
 
-	pages = vm_adjust_num_guest_pages(mode, pages);
-
 	vm = vm_create_without_vcpus(mode, pages);
 
 	for (i = 0; i < nr_vcpus; ++i) {
-- 
2.36.1.255.ge46751e96f-goog

