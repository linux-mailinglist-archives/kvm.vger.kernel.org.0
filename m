Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D5675E5622
	for <lists+kvm@lfdr.de>; Thu, 22 Sep 2022 00:13:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231158AbiIUWNY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Sep 2022 18:13:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230477AbiIUWNW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Sep 2022 18:13:22 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EFFBA7A88
        for <kvm@vger.kernel.org>; Wed, 21 Sep 2022 15:13:21 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id go6so7911470pjb.2
        for <kvm@vger.kernel.org>; Wed, 21 Sep 2022 15:13:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=jxDb2PQQp083SZ+8DQYQxmqpzie5/L1hGZiwQ6Jt/dw=;
        b=c1kfxGqaWCT0XZcmdXWHM7cH44sL3VxgcFcQsPcQaTqVEnXRcLtryRyAxM5tlCqL1N
         2yf7Wp9k39nCrPqRk4BhGdkYqlly5YLZTsVd5EkZFucGk+c5ddeqPxM4uveodQwH+hgP
         mUb2zqahvOIdmQd25S3cp9YGYKPZtCy8x06MwX+oz6Q77kDTqkJFjJx/ooctMmbSUEgZ
         00JOZa+pJpbxrW9313svl0nkYM8i62kg24CTFTpyrV1+H/h/mnI7KOPw+5zLYOgOmeAK
         X75EW8paDoSwjGdHtnKrn6uWMiI2hwZZiZDMvT2efEMmxEZ2kAj18pzkC5B30o0/pby6
         FjCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=jxDb2PQQp083SZ+8DQYQxmqpzie5/L1hGZiwQ6Jt/dw=;
        b=y+V0AHOr8juMyxU/Q6ESwBiTIXx4dXD8A8/RjeWZBObHgJrqN3WPxS+/6T4IzfQa3j
         VxBr/98fa1Evjsn/6mUkVgpP2gTurv81/K3e4xhq8cWMKwaO9x8p2rpxBqlO50Gn0IQf
         BjGR/ujE0kG3TI/S/fD8CVxAzl2lbxJJNPG4bgm0WQnncnqbOYWZQ9tkfJwcsfX7AnIX
         qJCPh3tkTIUTzlTm8DFeGln0wEWQklE10M0wPknUcwpbxfCTHhjMFgsQF4N89CWb0+iW
         SwDPT2DplR+yaAwmv9NpNtmhY5GYBKhn1QxtVOZK8EAFMdcx9f1nGENNKvuTaZ3Cd+Ip
         RPpA==
X-Gm-Message-State: ACrzQf3MrgvHrTHisTekfZ+F755T1q9BN27MmTFncBWxRNC04aCeO6LR
        o96EKjT6z0poBB7gRGLlaCKbDd22E+i9pg==
X-Google-Smtp-Source: AMsMyM5hwUhwrLmP/i2U0oQ94AXczjzNYmL0SX/E04t0Z8nwZiZhv2/WPpgVSkPmFLgBmbqoC1LRGw==
X-Received: by 2002:a17:902:bd85:b0:178:8e76:c77e with SMTP id q5-20020a170902bd8500b001788e76c77emr363506pls.38.1663798400646;
        Wed, 21 Sep 2022 15:13:20 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id 4-20020a170902c10400b00168dadc7354sm2531001pli.78.2022.09.21.15.13.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Sep 2022 15:13:20 -0700 (PDT)
Date:   Wed, 21 Sep 2022 22:13:16 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Siddharth Chandrasekaran <sidcha@amazon.de>,
        Yuan Yao <yuan.yao@linux.intel.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v10 29/39] KVM: selftests: Export
 _vm_get_page_table_entry()
Message-ID: <YyuMfG51iMMfa2mR@google.com>
References: <20220921152436.3673454-1-vkuznets@redhat.com>
 <20220921152436.3673454-30-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220921152436.3673454-30-vkuznets@redhat.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 21, 2022, Vitaly Kuznetsov wrote:
> Make it possible for tests to mangle guest's page table entries in
> addition to just getting them (available with vm_get_page_table_entry()).
> 
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> ---
>  tools/testing/selftests/kvm/include/x86_64/processor.h | 2 ++
>  tools/testing/selftests/kvm/lib/x86_64/processor.c     | 5 ++---
>  2 files changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/tools/testing/selftests/kvm/include/x86_64/processor.h
> index 1c7805de8c27..500d711eb989 100644
> --- a/tools/testing/selftests/kvm/include/x86_64/processor.h
> +++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
> @@ -827,6 +827,8 @@ static inline uint8_t wrmsr_safe(uint32_t msr, uint64_t val)
>  	return kvm_asm_safe("wrmsr", "a"(val & -1u), "d"(val >> 32), "c"(msr));
>  }
>  
> +uint64_t *_vm_get_page_table_entry(struct kvm_vm *vm, struct kvm_vcpu *vcpu,
> +				   uint64_t vaddr);
>  uint64_t vm_get_page_table_entry(struct kvm_vm *vm, struct kvm_vcpu *vcpu,
>  				 uint64_t vaddr);
>  void vm_set_page_table_entry(struct kvm_vm *vm, struct kvm_vcpu *vcpu,
> diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c b/tools/testing/selftests/kvm/lib/x86_64/processor.c
> index 2e6e61bbe81b..5c135f896ada 100644
> --- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
> +++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
> @@ -214,9 +214,8 @@ void virt_arch_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr)
>  	__virt_pg_map(vm, vaddr, paddr, PG_LEVEL_4K);
>  }
>  
> -static uint64_t *_vm_get_page_table_entry(struct kvm_vm *vm,
> -					  struct kvm_vcpu *vcpu,
> -					  uint64_t vaddr)
> +uint64_t *_vm_get_page_table_entry(struct kvm_vm *vm, struct kvm_vcpu *vcpu,
> +				   uint64_t vaddr)

Ugh, obviously not your fault, but this is a terrible name.  Aside from using a
single underscore, it's semantically very different than vm_get_page_table_entry(),
i.e. violates the stand "double underscores is an inner helper".

The innards of vm_{g,s}et_page_table_entry() are quite hilarious too as they cast
a "uint64_t *" to  "uint64_t*" now that KVM no longer uses structs to manage PTEs
(commit f18b4aebe107 ("kvm: selftests: do not use bitfields larger than 32-bits
for PTEs")).

And looking at the sole usage in emulator_error_test.c, provide get+set helpers
is silly.

Rather than expose this weirdness, what about slotting in the below to drop the
wrappers and just let tests modify PTEs directly?

---
From: Sean Christopherson <seanjc@google.com>
Date: Wed, 21 Sep 2022 15:08:49 -0700
Subject: [PATCH] KVM: selftests: Drop helpers to read/write page table entries

Drop vm_{g,s}et_page_table_entry() and instead expose the "inner"
helper (was _vm_get_page_table_entry()) that returns a _pointer_ to the
PTE, i.e. let tests directly modify PTEs instead of bouncing through
helpers that just make life difficult.

Opportunsitically use BIT_ULL() in emulator_error_test, and use the
MAXPHYADDR define to set the "rogue" GPA bit instead of open coding the
same value.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/include/x86_64/processor.h  |  6 ++----
 .../selftests/kvm/lib/x86_64/processor.c      | 21 ++-----------------
 .../kvm/x86_64/emulator_error_test.c          |  6 ++++--
 3 files changed, 8 insertions(+), 25 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/tools/testing/selftests/kvm/include/x86_64/processor.h
index 0cbc71b7af50..5999e974a150 100644
--- a/tools/testing/selftests/kvm/include/x86_64/processor.h
+++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
@@ -825,10 +825,8 @@ static inline uint8_t wrmsr_safe(uint32_t msr, uint64_t val)
 	return kvm_asm_safe("wrmsr", "a"(val & -1u), "d"(val >> 32), "c"(msr));
 }
 
-uint64_t vm_get_page_table_entry(struct kvm_vm *vm, struct kvm_vcpu *vcpu,
-				 uint64_t vaddr);
-void vm_set_page_table_entry(struct kvm_vm *vm, struct kvm_vcpu *vcpu,
-			     uint64_t vaddr, uint64_t pte);
+uint64_t *vm_get_page_table_entry(struct kvm_vm *vm, struct kvm_vcpu *vcpu,
+				  uint64_t vaddr);
 
 uint64_t kvm_hypercall(uint64_t nr, uint64_t a0, uint64_t a1, uint64_t a2,
 		       uint64_t a3);
diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c b/tools/testing/selftests/kvm/lib/x86_64/processor.c
index 2e6e61bbe81b..5e4bbe71dbff 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
@@ -214,9 +214,8 @@ void virt_arch_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr)
 	__virt_pg_map(vm, vaddr, paddr, PG_LEVEL_4K);
 }
 
-static uint64_t *_vm_get_page_table_entry(struct kvm_vm *vm,
-					  struct kvm_vcpu *vcpu,
-					  uint64_t vaddr)
+uint64_t *vm_get_page_table_entry(struct kvm_vm *vm, struct kvm_vcpu *vcpu,
+				  uint64_t vaddr)
 {
 	uint16_t index[4];
 	uint64_t *pml4e, *pdpe, *pde;
@@ -286,22 +285,6 @@ static uint64_t *_vm_get_page_table_entry(struct kvm_vm *vm,
 	return &pte[index[0]];
 }
 
-uint64_t vm_get_page_table_entry(struct kvm_vm *vm, struct kvm_vcpu *vcpu,
-				 uint64_t vaddr)
-{
-	uint64_t *pte = _vm_get_page_table_entry(vm, vcpu, vaddr);
-
-	return *(uint64_t *)pte;
-}
-
-void vm_set_page_table_entry(struct kvm_vm *vm, struct kvm_vcpu *vcpu,
-			     uint64_t vaddr, uint64_t pte)
-{
-	uint64_t *new_pte = _vm_get_page_table_entry(vm, vcpu, vaddr);
-
-	*(uint64_t *)new_pte = pte;
-}
-
 void virt_arch_dump(FILE *stream, struct kvm_vm *vm, uint8_t indent)
 {
 	uint64_t *pml4e, *pml4e_start;
diff --git a/tools/testing/selftests/kvm/x86_64/emulator_error_test.c b/tools/testing/selftests/kvm/x86_64/emulator_error_test.c
index 236e11755ba6..bde247f3c8a1 100644
--- a/tools/testing/selftests/kvm/x86_64/emulator_error_test.c
+++ b/tools/testing/selftests/kvm/x86_64/emulator_error_test.c
@@ -152,8 +152,9 @@ int main(int argc, char *argv[])
 {
 	struct kvm_vcpu *vcpu;
 	struct kvm_vm *vm;
-	uint64_t gpa, pte;
+	uint64_t *pte;
 	uint64_t *hva;
+	uint64_t gpa;
 	int rc;
 
 	/* Tell stdout not to buffer its content */
@@ -178,8 +179,9 @@ int main(int argc, char *argv[])
 	virt_map(vm, MEM_REGION_GVA, MEM_REGION_GPA, 1);
 	hva = addr_gpa2hva(vm, MEM_REGION_GPA);
 	memset(hva, 0, PAGE_SIZE);
+
 	pte = vm_get_page_table_entry(vm, vcpu, MEM_REGION_GVA);
-	vm_set_page_table_entry(vm, vcpu, MEM_REGION_GVA, pte | (1ull << 36));
+	*pte |= BIT_ULL(MAXPHYADDR);
 
 	vcpu_run(vcpu);
 	process_exit_on_emulation_error(vcpu);

base-commit: 3b69d246e2f1eef553508c79f5d3b2dfc4978bc1
-- 
