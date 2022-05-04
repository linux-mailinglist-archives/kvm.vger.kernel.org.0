Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37AAD51B30D
	for <lists+kvm@lfdr.de>; Thu,  5 May 2022 01:25:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379637AbiEDW44 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 May 2022 18:56:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379448AbiEDWyG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 May 2022 18:54:06 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3218C5FA6
        for <kvm@vger.kernel.org>; Wed,  4 May 2022 15:50:25 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id z16-20020a17090a015000b001dbc8da29a1so1315971pje.7
        for <kvm@vger.kernel.org>; Wed, 04 May 2022 15:50:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=7yAH+5mQpivzXrDqX+vptjX+TeCwxFtk+nD3YIQO4p4=;
        b=KVITuzeGhJ+UUEfBbPkSfGR5qfMLN+KscCoiz27xYGMTaDb5voK/y/F+uIDP/eoRsQ
         TCi0G/3DApU9l2g35Mc7lgx6Z+bW4XRBRL09tzTe6csI9J+jX/LaRWYBchyXmgr2Idr9
         Pk0MSHC7JnDaGJWUkmeiFJ8MgY4w2MeAyBacLwFmCFvyPPmHUB0n58EdXV0z+BQUSWjR
         Wm1K64JteYWWMJHQuABbrUvEfYpJl2Uuj2EwL8m5L4OD+GtDeke49752ABAnPq4FIrIj
         zqvAqz8Osbg6KExI9xcgn5Gn5M230eM0eYDa475HjRjCr9DoCNgYqJAipNS46dKeSCGd
         tyCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=7yAH+5mQpivzXrDqX+vptjX+TeCwxFtk+nD3YIQO4p4=;
        b=IQrgnzJflrTMoPWJxS84GeiZw4uhFLdy58jxkPMxztW4y84ebnFA7iGvA4H+UViiRe
         535hQ8hUpuCMRiBARJBjdtWwyvr9U0PIhkdFSwtK0Az/6suOLnNdMaIECAtKHJFJ5EbD
         c3gsi3xjZhZgTjiZAdmQrj1tLq8rQ6ny36eZ3Lt+moGsPCx4ejchKxTyAo3JgwrbUHB4
         lEDr/JRCDMcmJZmUUq3yfsKQ5/gjzYxfLukHX3plWJQ/PmIVkbIhSlxw/RH4UDF/k4cr
         v0ZpBFnhbmIFgRCwdMyFckoUq2lHNh7GIT3OQOm2CR7CPMgC6w/8w17XQ4gBGHYtX5dN
         YXsg==
X-Gm-Message-State: AOAM530TKVtiTQTLCMXEzg+DAWLVx1IKi2FnDqfrp63GYmgVQqvZ03/M
        RuLtMFZHZYxwe+vX4X72aBiIAB3rnxI=
X-Google-Smtp-Source: ABdhPJxbBMWiw7LrwCKAOBZkuqtVq1rOjNrD9JMGQpEhqBmv14TyW0x3pj7ac/dKTvGaAsX90nhMUZiPYmM=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:846:b0:50d:f02f:bb46 with SMTP id
 q6-20020a056a00084600b0050df02fbb46mr15595775pfk.74.1651704625067; Wed, 04
 May 2022 15:50:25 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed,  4 May 2022 22:47:37 +0000
In-Reply-To: <20220504224914.1654036-1-seanjc@google.com>
Message-Id: <20220504224914.1654036-32-seanjc@google.com>
Mime-Version: 1.0
References: <20220504224914.1654036-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.0.464.gb9c8b46e94-goog
Subject: [PATCH 031/128] KVM: selftests: Use vm_create_without_vcpus() in set_boot_cpu_id
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
2.36.0.464.gb9c8b46e94-goog

