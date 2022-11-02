Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A357D61722B
	for <lists+kvm@lfdr.de>; Thu,  3 Nov 2022 00:22:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231140AbiKBXWr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Nov 2022 19:22:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230311AbiKBXUs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Nov 2022 19:20:48 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC0DE25F8
        for <kvm@vger.kernel.org>; Wed,  2 Nov 2022 16:19:58 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id 125-20020a630283000000b0046e9babe7b3so90786pgc.11
        for <kvm@vger.kernel.org>; Wed, 02 Nov 2022 16:19:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=w/Q7bH8THgyaKP3B1ctDp6/bth9WI6Zn0uJypuG9eac=;
        b=hkPOoen/pyqZsKi1YCSawLdA3GEp9C4f3mv9W0KoQWrN/JmnscJ/7nrSl0bhgo5kc/
         284CZWTN6cQtZyS3BcYl1rO3d2JXX3uptOp6QgDDXHKKXwZWYnEXXtfdURHWu0sgST7b
         SR2jmNv70MkTjk45xUfHV7CREolEUHHjBimLzgCj57Qvy29dchlrARjt1C82JrSjtdvz
         CjPyz+19dEzhNchjZdr/kuW84eKlMR1llHgovF4ZVnGabG/rB0khgL15izrPpgwurgg8
         AnCmcr2wDk7Yyae3uT31jet5RZCDh/LNmD6fqF7lWW4xFuTB9UT2b6Ep4Ac5WXcUuWtP
         s9ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=w/Q7bH8THgyaKP3B1ctDp6/bth9WI6Zn0uJypuG9eac=;
        b=MP+bt3mHdTgtjiEeYczSrDkzRaIysoaQlLrNhofRImXTWdkj216YXsstz8qiuEEVEa
         iaDJYmxbF/W6h+PbPbk+45U6hs5LV1jjv14qeyLCmuOqxIyBkuIGxtb5juXOpk3VhxI/
         J6F+4Gow04yzmI3XVSAecmxxVpSE+0BaNNJA3Sy5Zn+NjgMfc2hVoOY9outVRDEm2Fa8
         cOjvH8Daf/m4emOEfp2GGaYPd9omrM6hicBytPvAst1xXQ+HlcsWiZ/GhM2nzuofH5lp
         3HU3DYm5IoPupx2eOvqHBK2sXlbbsjQulXzqBfYXlmUpwM9cqddb29VEJTb/je2sNC5P
         cdnQ==
X-Gm-Message-State: ACrzQf289wrQglyiePNWREAAriFgSrWLsHMD98VYKm/2xAsqm4vGU8sK
        FPoUh93wqNofDA3IySwglIrovRLclY0=
X-Google-Smtp-Source: AMsMyM52tU6iRK0I4Ec35KUAzBrT1sghmvSrKR24lxi1BsrlBLfXrWc/1+j2917tMPr6x8h/JqOXwdenWAg=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:852:b0:56d:e2bc:1978 with SMTP id
 q18-20020a056a00085200b0056de2bc1978mr8835032pfk.47.1667431198455; Wed, 02
 Nov 2022 16:19:58 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed,  2 Nov 2022 23:18:53 +0000
In-Reply-To: <20221102231911.3107438-1-seanjc@google.com>
Mime-Version: 1.0
References: <20221102231911.3107438-1-seanjc@google.com>
X-Mailer: git-send-email 2.38.1.431.g37b22c650d-goog
Message-ID: <20221102231911.3107438-27-seanjc@google.com>
Subject: [PATCH 26/44] KVM: s390: Mark __kvm_s390_init() and its descendants
 as __init
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Anup Patel <anup@brainfault.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Atish Patra <atishp@atishpatra.org>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        kvmarm@lists.cs.columbia.edu, linux-mips@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org,
        linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Isaku Yamahata <isaku.yamahata@intel.com>,
        Fabiano Rosas <farosas@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Chao Gao <chao.gao@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Yuan Yao <yuan.yao@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Tag __kvm_s390_init() and its unique helpers as __init.  These functions
are only ever called during module_init(), but could not be tagged
accordingly while they were invoked from the common kvm_arch_init(),
which is not __init because of x86.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/s390/kvm/interrupt.c | 2 +-
 arch/s390/kvm/kvm-s390.c  | 4 ++--
 arch/s390/kvm/kvm-s390.h  | 2 +-
 arch/s390/kvm/pci.c       | 2 +-
 arch/s390/kvm/pci.h       | 2 +-
 5 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/s390/kvm/interrupt.c b/arch/s390/kvm/interrupt.c
index ab569faf0df2..bf9d55fbc21a 100644
--- a/arch/s390/kvm/interrupt.c
+++ b/arch/s390/kvm/interrupt.c
@@ -3416,7 +3416,7 @@ void kvm_s390_gib_destroy(void)
 	gib = NULL;
 }
 
-int kvm_s390_gib_init(u8 nisc)
+int __init kvm_s390_gib_init(u8 nisc)
 {
 	int rc = 0;
 
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index e1c9980aae78..f6ae845bc1c1 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -358,7 +358,7 @@ static __always_inline void __insn32_query(unsigned int opcode, u8 *query)
 #define INSN_SORTL 0xb938
 #define INSN_DFLTCC 0xb939
 
-static void kvm_s390_cpu_feat_init(void)
+static void __init kvm_s390_cpu_feat_init(void)
 {
 	int i;
 
@@ -461,7 +461,7 @@ static void kvm_s390_cpu_feat_init(void)
 	 */
 }
 
-static int __kvm_s390_init(void)
+static int __init __kvm_s390_init(void)
 {
 	int rc = -ENOMEM;
 
diff --git a/arch/s390/kvm/kvm-s390.h b/arch/s390/kvm/kvm-s390.h
index f6fd668f887e..e7f6166129eb 100644
--- a/arch/s390/kvm/kvm-s390.h
+++ b/arch/s390/kvm/kvm-s390.h
@@ -467,7 +467,7 @@ void kvm_s390_gisa_clear(struct kvm *kvm);
 void kvm_s390_gisa_destroy(struct kvm *kvm);
 void kvm_s390_gisa_disable(struct kvm *kvm);
 void kvm_s390_gisa_enable(struct kvm *kvm);
-int kvm_s390_gib_init(u8 nisc);
+int __init kvm_s390_gib_init(u8 nisc);
 void kvm_s390_gib_destroy(void);
 
 /* implemented in guestdbg.c */
diff --git a/arch/s390/kvm/pci.c b/arch/s390/kvm/pci.c
index c50c1645c0ae..60548791c077 100644
--- a/arch/s390/kvm/pci.c
+++ b/arch/s390/kvm/pci.c
@@ -670,7 +670,7 @@ int kvm_s390_pci_zpci_op(struct kvm *kvm, struct kvm_s390_zpci_op *args)
 	return r;
 }
 
-int kvm_s390_pci_init(void)
+int __init kvm_s390_pci_init(void)
 {
 	zpci_kvm_hook.kvm_register = kvm_s390_pci_register_kvm;
 	zpci_kvm_hook.kvm_unregister = kvm_s390_pci_unregister_kvm;
diff --git a/arch/s390/kvm/pci.h b/arch/s390/kvm/pci.h
index 486d06ef563f..ff0972dd5e71 100644
--- a/arch/s390/kvm/pci.h
+++ b/arch/s390/kvm/pci.h
@@ -60,7 +60,7 @@ void kvm_s390_pci_clear_list(struct kvm *kvm);
 
 int kvm_s390_pci_zpci_op(struct kvm *kvm, struct kvm_s390_zpci_op *args);
 
-int kvm_s390_pci_init(void);
+int __init kvm_s390_pci_init(void);
 void kvm_s390_pci_exit(void);
 
 static inline bool kvm_s390_pci_interp_allowed(void)
-- 
2.38.1.431.g37b22c650d-goog

