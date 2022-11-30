Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D55DF63E4EB
	for <lists+kvm@lfdr.de>; Thu,  1 Dec 2022 00:14:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230060AbiK3XOB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Nov 2022 18:14:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229782AbiK3XNP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Nov 2022 18:13:15 -0500
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21FAD9D82A
        for <kvm@vger.kernel.org>; Wed, 30 Nov 2022 15:10:43 -0800 (PST)
Received: by mail-pf1-x44a.google.com with SMTP id b13-20020a056a000a8d00b0057348c50123so159633pfl.18
        for <kvm@vger.kernel.org>; Wed, 30 Nov 2022 15:10:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=sCL5nUY5jVECdqbz+DtfaNancd0JoKLrDsCNzQeZ4VM=;
        b=FdJXVaCerL0aYXlSKCNZGaBsvhStCr0raOxBeYIkp4Eahw58g8dUGOpjjTZmNCmTe0
         mkfDd/jmN5dDwhAszOU5fy3Z2W7/1AljlI0GNy9pf8gtw1DfpMPRyWAgaw/dH7x/k+e6
         ElYy/YZxg7mPUT8eVlsbEwMxRfjFKCESq4lpHqyvLKLyNyU3+0kw+OatGoe/LZdK65Gm
         iDCtq/GyihCca4Nix9chWcnsGAukForJwZUR0+JY1L+Pf5Gk3bKEFqAVQzlBFWu3/frk
         9DcYaRLE/q/y1bYN4asBB9T511P9HVDAxCLbepbuuyEkNPOgwPqEFTJkjpVg81LSfjfV
         pvJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=sCL5nUY5jVECdqbz+DtfaNancd0JoKLrDsCNzQeZ4VM=;
        b=xMbjBuauBZCuumyguh39+JyxexODJq2zjxHTiu7Y+6+Mx0PZQK/517Qmic643BvP4I
         ej6E4/xrGX5MQMXjCLx20FK0ai09rvOr/em74AT9xWzIB4NVv68CUB8v7ua0nNbgAaCE
         AUMdyeF4DqpwWdLCYQqjdPR0WnVCWubTOhY+YJo4HFGfURydimn6pjfrT3clDVPOpImb
         llMNGCxdrz/iQw5ukqPzRDChs6OGtitCrwyunj16ZVIggu3cDUglgj4HINhp8TSYebPU
         jhZhUdkSHtuRnLkEY9H5ZRxTmptePhhYQpyO64aMrT+Z/qZ2uoKs+webHZqy4c5osVvx
         u7Tw==
X-Gm-Message-State: ANoB5pnwhM3dMONcddQXkIhxEeayFQIApDHvnF/nDJxn4YHsgx/G4foK
        zKM5yCUrNo3mWJoJf2vc/GLNTqoU80Q=
X-Google-Smtp-Source: AA0mqf5VFykTikxn6Nmxzh1/iLDcJ+DMZWcjAIIeDPd3Nna5HVSkx0xzOx2E3cTUFx7HQ+ZbJkQjtPKQzYw=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:aa7:8493:0:b0:563:8d32:abdc with SMTP id
 u19-20020aa78493000000b005638d32abdcmr44676437pfn.47.1669849820421; Wed, 30
 Nov 2022 15:10:20 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed, 30 Nov 2022 23:09:09 +0000
In-Reply-To: <20221130230934.1014142-1-seanjc@google.com>
Mime-Version: 1.0
References: <20221130230934.1014142-1-seanjc@google.com>
X-Mailer: git-send-email 2.38.1.584.g0f3c55d4c2-goog
Message-ID: <20221130230934.1014142-26-seanjc@google.com>
Subject: [PATCH v2 25/50] KVM: RISC-V: Tag init functions and data with
 __init, __ro_after_init
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
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Paul Durrant <paul@xen.org>
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
        linux-kernel@vger.kernel.org, Yuan Yao <yuan.yao@intel.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Isaku Yamahata <isaku.yamahata@intel.com>,
        "=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?=" <philmd@linaro.org>,
        Fabiano Rosas <farosas@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Kai Huang <kai.huang@intel.com>, Chao Gao <chao.gao@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>
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

Now that KVM setup is handled directly in riscv_kvm_init(), tag functions
and data that are used/set only during init with __init/__ro_after_init.

Signed-off-by: Sean Christopherson <seanjc@google.com>
Acked-by: Anup Patel <anup@brainfault.org>
---
 arch/riscv/include/asm/kvm_host.h |  6 +++---
 arch/riscv/kvm/mmu.c              | 12 ++++++------
 arch/riscv/kvm/vmid.c             |  4 ++--
 3 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/arch/riscv/include/asm/kvm_host.h b/arch/riscv/include/asm/kvm_host.h
index 8c771fc4f5d2..778ff0f282b7 100644
--- a/arch/riscv/include/asm/kvm_host.h
+++ b/arch/riscv/include/asm/kvm_host.h
@@ -295,11 +295,11 @@ int kvm_riscv_gstage_map(struct kvm_vcpu *vcpu,
 int kvm_riscv_gstage_alloc_pgd(struct kvm *kvm);
 void kvm_riscv_gstage_free_pgd(struct kvm *kvm);
 void kvm_riscv_gstage_update_hgatp(struct kvm_vcpu *vcpu);
-void kvm_riscv_gstage_mode_detect(void);
-unsigned long kvm_riscv_gstage_mode(void);
+void __init kvm_riscv_gstage_mode_detect(void);
+unsigned long __init kvm_riscv_gstage_mode(void);
 int kvm_riscv_gstage_gpa_bits(void);
 
-void kvm_riscv_gstage_vmid_detect(void);
+void __init kvm_riscv_gstage_vmid_detect(void);
 unsigned long kvm_riscv_gstage_vmid_bits(void);
 int kvm_riscv_gstage_vmid_init(struct kvm *kvm);
 bool kvm_riscv_gstage_vmid_ver_changed(struct kvm_vmid *vmid);
diff --git a/arch/riscv/kvm/mmu.c b/arch/riscv/kvm/mmu.c
index 3620ecac2fa1..f42a34c7879a 100644
--- a/arch/riscv/kvm/mmu.c
+++ b/arch/riscv/kvm/mmu.c
@@ -20,12 +20,12 @@
 #include <asm/pgtable.h>
 
 #ifdef CONFIG_64BIT
-static unsigned long gstage_mode = (HGATP_MODE_SV39X4 << HGATP_MODE_SHIFT);
-static unsigned long gstage_pgd_levels = 3;
+static unsigned long gstage_mode __ro_after_init = (HGATP_MODE_SV39X4 << HGATP_MODE_SHIFT);
+static unsigned long gstage_pgd_levels __ro_after_init = 3;
 #define gstage_index_bits	9
 #else
-static unsigned long gstage_mode = (HGATP_MODE_SV32X4 << HGATP_MODE_SHIFT);
-static unsigned long gstage_pgd_levels = 2;
+static unsigned long gstage_mode __ro_after_init = (HGATP_MODE_SV32X4 << HGATP_MODE_SHIFT);
+static unsigned long gstage_pgd_levels __ro_after_init = 2;
 #define gstage_index_bits	10
 #endif
 
@@ -760,7 +760,7 @@ void kvm_riscv_gstage_update_hgatp(struct kvm_vcpu *vcpu)
 		kvm_riscv_local_hfence_gvma_all();
 }
 
-void kvm_riscv_gstage_mode_detect(void)
+void __init kvm_riscv_gstage_mode_detect(void)
 {
 #ifdef CONFIG_64BIT
 	/* Try Sv57x4 G-stage mode */
@@ -784,7 +784,7 @@ void kvm_riscv_gstage_mode_detect(void)
 #endif
 }
 
-unsigned long kvm_riscv_gstage_mode(void)
+unsigned long __init kvm_riscv_gstage_mode(void)
 {
 	return gstage_mode >> HGATP_MODE_SHIFT;
 }
diff --git a/arch/riscv/kvm/vmid.c b/arch/riscv/kvm/vmid.c
index 6cd93995fb65..5246da1c9167 100644
--- a/arch/riscv/kvm/vmid.c
+++ b/arch/riscv/kvm/vmid.c
@@ -17,10 +17,10 @@
 
 static unsigned long vmid_version = 1;
 static unsigned long vmid_next;
-static unsigned long vmid_bits;
+static unsigned long vmid_bits __ro_after_init;
 static DEFINE_SPINLOCK(vmid_lock);
 
-void kvm_riscv_gstage_vmid_detect(void)
+void __init kvm_riscv_gstage_vmid_detect(void)
 {
 	unsigned long old;
 
-- 
2.38.1.584.g0f3c55d4c2-goog

