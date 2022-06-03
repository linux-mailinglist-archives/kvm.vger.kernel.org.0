Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E13753C1BF
	for <lists+kvm@lfdr.de>; Fri,  3 Jun 2022 04:12:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232198AbiFCAqJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Jun 2022 20:46:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240094AbiFCAoz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Jun 2022 20:44:55 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EDF437A8A
        for <kvm@vger.kernel.org>; Thu,  2 Jun 2022 17:44:49 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id u22-20020a170902a61600b0016363cdfe84so3470590plq.10
        for <kvm@vger.kernel.org>; Thu, 02 Jun 2022 17:44:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=wQLAGjAqmxLboPvfqpTswhDnNIA7VCg/qN9ZJA18oL0=;
        b=r+UGGry7PA8bg8fHD/ts0BmiEwktP6IhSxPX/CeREtTRGA6MK4pf8d1SqSovn3gtUR
         7Ng9Rmg4XaqNwsD9gd+wXfdCn23ThCJjlDT+AN+5BmzOgYgg9lgVlWSbuoz2xaLdkkx4
         ryQooK9br2NOiekmeDPgFUHrATRBoniZeT5Az0s+HLQ7ipYZeURfFubtcY9g5ZYqO7hc
         kslqKNjUX7UiIXAhXHSh+F/xT16fveZsBBfcy5DxGQ9A2uEwOuec8vIUBQ2Sn/waeA/l
         mDZ1NIDcldOngMKU5xytWZdxfz8K/9A56KQYBVljwVv+/YiUAhXJ1CDieHsFvvzLlQuv
         Mezw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=wQLAGjAqmxLboPvfqpTswhDnNIA7VCg/qN9ZJA18oL0=;
        b=JABGW4foMFQ4bgrTWv4uqfc9Hyqj6gmn5IgGGuJeDM18S9WpCUFbzM3q30az5LuXot
         UyB9j5rmLNtWTjV8OHzRwVNYFE3adAKZkbP9rDIh9If+EZdG5cBXtO0I+uQhSqzLXtcB
         ePqqk2SFjKfesji4bwGeAZoNC99bpGuiJ7JUNOudVDAipbMHpyUUtJQvi/xSf3zFyPmg
         wdDddiXU+26fxZ7t8+tcMMQc0V438qJbU6BR3kyEHlP/7y+Cj0jHLXzgrUAhW8BsOwwh
         gJNMWnwr4p17e5PxU5tsF721wcwyYU6AGapJygakrFWgerwU8OvN9/wMATOO48S99SEr
         BN7A==
X-Gm-Message-State: AOAM532gM7tuqxQC1VVWMabOww1m8t7sV+hcmHHgF+GDUmj3PXh+7bHL
        mKHdXoVjVV6UNuajkltp+i2nSomKlkU=
X-Google-Smtp-Source: ABdhPJwEPJE1FOhLw5UYnX4IybA0niwEsHTQcrpf3IXCJsiaLNWO9SBRfoC2+YZUFay4L1IJGuiiQ+Xggw4=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:90a:178f:b0:1e3:3ba:c185 with SMTP id
 q15-20020a17090a178f00b001e303bac185mr305565pja.1.1654217087484; Thu, 02 Jun
 2022 17:44:47 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri,  3 Jun 2022 00:41:46 +0000
In-Reply-To: <20220603004331.1523888-1-seanjc@google.com>
Message-Id: <20220603004331.1523888-40-seanjc@google.com>
Mime-Version: 1.0
References: <20220603004331.1523888-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.1.255.ge46751e96f-goog
Subject: [PATCH v2 039/144] KVM: selftests: Use vm_create_without_vcpus() in set_boot_cpu_id
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

Use vm_create_without_vcpus() in set_boot_cpu_id instead of open coding
the equivlant now that the "without_vcpus" variant does
vm_adjust_num_guest_pages().

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/x86_64/set_boot_cpu_id.c | 9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86_64/set_boot_cpu_id.c b/tools/testing/selftests/kvm/x86_64/set_boot_cpu_id.c
index b4da92ddc1c6..4c5775a8de6a 100644
--- a/tools/testing/selftests/kvm/x86_64/set_boot_cpu_id.c
+++ b/tools/testing/selftests/kvm/x86_64/set_boot_cpu_id.c
@@ -82,18 +82,11 @@ static void run_vcpu(struct kvm_vm *vm, uint32_t vcpuid)
 
 static struct kvm_vm *create_vm(void)
 {
-	struct kvm_vm *vm;
 	uint64_t vcpu_pages = (DEFAULT_STACK_PGS) * 2;
 	uint64_t extra_pg_pages = vcpu_pages / PTES_PER_MIN_PAGE * N_VCPU;
 	uint64_t pages = DEFAULT_GUEST_PHY_PAGES + vcpu_pages + extra_pg_pages;
 
-	pages = vm_adjust_num_guest_pages(VM_MODE_DEFAULT, pages);
-	vm = vm_create(pages);
-
-	kvm_vm_elf_load(vm, program_invocation_name);
-	vm_create_irqchip(vm);
-
-	return vm;
+	return vm_create_without_vcpus(VM_MODE_DEFAULT, pages);
 }
 
 static void add_x86_vcpu(struct kvm_vm *vm, uint32_t vcpuid, bool bsp_code)
-- 
2.36.1.255.ge46751e96f-goog

