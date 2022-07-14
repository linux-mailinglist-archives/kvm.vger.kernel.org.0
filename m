Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89BC55740DA
	for <lists+kvm@lfdr.de>; Thu, 14 Jul 2022 03:13:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231769AbiGNBLe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Jul 2022 21:11:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231737AbiGNBLV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Jul 2022 21:11:21 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F2E220BD3
        for <kvm@vger.kernel.org>; Wed, 13 Jul 2022 18:11:20 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id i9-20020a258b09000000b0066efe437da6so365264ybl.5
        for <kvm@vger.kernel.org>; Wed, 13 Jul 2022 18:11:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:message-id:mime-version:subject:from:to:cc;
        bh=0hF6tID653Wj3gfhMGdt71PhFpkNsHCuIdaPZ9N7avk=;
        b=VdIRqVCRrKff6mYZG982d30mdg85GCCASxOzqnKGD6SIG1BDYD5Csh1GrHtAE1kgtN
         tsGu/bgawpMLO/NzphBybKGqYH85NWg6sbhbxf/UOs0MMfIhtZ1VgDT9lf5nUqFOAio0
         Gh8LkEX7e4JJf7XJJoy2/TZ874kAItjXy4tCYr7wKjOU0tOJhiJQTc0JbedfGmCh0qbX
         +0XjoFQ6hii9ALYRACAUkwASnGb6OyctwEc5Q4PmCqLpfr9o4aZLIY4G1D5nzlYzrINK
         gxYUOsvZuIDv4dFXvnFoTw3Y0O7L6LH4j9xJsoWGo5dcCpZhEojZgW/W6l41FCx3cVOG
         CVtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:message-id:mime-version:subject
         :from:to:cc;
        bh=0hF6tID653Wj3gfhMGdt71PhFpkNsHCuIdaPZ9N7avk=;
        b=DplhW+oMFM3PfgsB4oppVlY/lgMe2/YGKg6Q3zAJlAfythAZoSYZUim3O2b+fuomgI
         GL6ubSc+lX6eZUCltm6819fcoxMIQV7WQ7LuYM8LmAQC7MujjAGiHPMHA9/5/qdzKx8j
         e4oa6YGouWW5VRy/cU8YulwknqXHnHCOvH1I+WsCOo7qwgFKFdPFpfkDKyDhA2moy4zu
         42pdVwTad1unimVjtBRz7zSfVLtziR4pj4K/G0+K3nWbXxhfxGBR3N4LIGpm2dJgeM+u
         bDwLGvwsBi1+Ug1WoGB1Z6gnVzh19RDnCHzL0mXfaQAkXbmomoyL6F+cGOnUmwM68To4
         Y7Mg==
X-Gm-Message-State: AJIora+J3iNnR4x9IekNG+WYzCwwo11XUnQrF7NL4FQ9jfrOdyzhiPQx
        YYHaW+rDEdMmRUAc+arA4IR1HxV2ifA=
X-Google-Smtp-Source: AGRyM1uH0z+R05anGU3HrhqscXx5O45ExUEGXquffB8+WAd5hRzyYoLS+h9s+kmbdLyNMeszMGoVasfb9CA=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:3904:0:b0:310:cc3:15a2 with SMTP id
 g4-20020a813904000000b003100cc315a2mr7246667ywa.447.1657761079625; Wed, 13
 Jul 2022 18:11:19 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu, 14 Jul 2022 01:11:15 +0000
Message-Id: <20220714011115.3135828-1-seanjc@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.37.0.144.g8ac04bfd2-goog
Subject: [PATCH v2] KVM: selftests: Use "a" and "d" to set EAX/EDX for wrmsr_safe()
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vitaly Kuznetsov <vkuznets@redhat.com>
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

From: Vitaly Kuznetsov <vkuznets@redhat.com>

Do not use GCC's "A" constraint to load EAX:EDX in wrmsr_safe().  Per
GCC's documenation on x86-specific constraints, "A" will not actually
load a 64-bit value into EAX:EDX on x86-64.

  The a and d registers. This class is used for instructions that return
  double word results in the ax:dx register pair. Single word values will
  be allocated either in ax or dx. For example on i386 the following
  implements rdtsc:

  unsigned long long rdtsc (void)
  {
    unsigned long long tick;
    __asm__ __volatile__("rdtsc":"=A"(tick));
    return tick;
  }

  This is not correct on x86-64 as it would allocate tick in either ax or
  dx. You have to use the following variant instead:

  unsigned long long rdtsc (void)
  {
    unsigned int tickl, tickh;
    __asm__ __volatile__("rdtsc":"=a"(tickl),"=d"(tickh));
    return ((unsigned long long)tickh << 32)|tickl;
  }

Because a u64 fits in a single 64-bit register, using "A" for selftests,
which are 64-bit only, results in GCC loading the value into either RAX
or RDX instead of splitting it across EAX:EDX.

E.g.:

  kvm_exit:             reason MSR_WRITE rip 0x402919 info 0 0
  kvm_msr:              msr_write 40000118 = 0x60000000001 (#GP)
...

With "A":

  48 8b 43 08          	mov    0x8(%rbx),%rax
  49 b9 ba da ca ba 0a 	movabs $0xabacadaba,%r9
  00 00 00
  4c 8d 15 07 00 00 00 	lea    0x7(%rip),%r10        # 402f44 <guest_msr+0x34>
  4c 8d 1d 06 00 00 00 	lea    0x6(%rip),%r11        # 402f4a <guest_msr+0x3a>
  0f 30                 wrmsr

With "a"/"d":

  48 8b 53 08             mov    0x8(%rbx),%rdx
  89 d0                   mov    %edx,%eax
  48 c1 ea 20             shr    $0x20,%rdx
  49 b9 ba da ca ba 0a    movabs $0xabacadaba,%r9
  00 00 00
  4c 8d 15 07 00 00 00    lea    0x7(%rip),%r10        # 402fc3 <guest_msr+0xb3>
  4c 8d 1d 06 00 00 00    lea    0x6(%rip),%r11        # 402fc9 <guest_msr+0xb9>
  0f 30                   wrmsr

Fixes: 3b23054cd3f5 ("KVM: selftests: Add x86-64 support for exception fixup")
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Link: https://gcc.gnu.org/onlinedocs/gcc/Machine-Constraints.html#Machine-Constraints
[sean: use "& -1u", provide GCC blurb and link to documentation]
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/include/x86_64/processor.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/tools/testing/selftests/kvm/include/x86_64/processor.h
index 79dcf6be1b47..71e942ffac77 100644
--- a/tools/testing/selftests/kvm/include/x86_64/processor.h
+++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
@@ -612,7 +612,7 @@ static inline uint8_t rdmsr_safe(uint32_t msr, uint64_t *val)
 
 static inline uint8_t wrmsr_safe(uint32_t msr, uint64_t val)
 {
-	return kvm_asm_safe("wrmsr", "A"(val), "c"(msr));
+	return kvm_asm_safe("wrmsr", "a"(val & -1u), "d"(val >> 32), "c"(msr));
 }
 
 uint64_t vm_get_page_table_entry(struct kvm_vm *vm, struct kvm_vcpu *vcpu,

base-commit: b624ae35418ce9424f639f8ffa2568e7674c262b
-- 
2.37.0.144.g8ac04bfd2-goog

