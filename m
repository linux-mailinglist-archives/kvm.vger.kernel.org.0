Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E3E3663E467
	for <lists+kvm@lfdr.de>; Thu,  1 Dec 2022 00:10:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229759AbiK3XKF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Nov 2022 18:10:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229760AbiK3XKA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Nov 2022 18:10:00 -0500
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4F6397019
        for <kvm@vger.kernel.org>; Wed, 30 Nov 2022 15:09:46 -0800 (PST)
Received: by mail-pg1-x54a.google.com with SMTP id n11-20020a634d4b000000b00477c4f50b79so49310pgl.22
        for <kvm@vger.kernel.org>; Wed, 30 Nov 2022 15:09:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=4d3Yt8bltpBTGQfRvysGuV0Qwes6q1E1oAAkIYt6v1U=;
        b=R2EUvQh/d5tOiXan3raQzQlRv7gR1ONI/pTsvNFLPNlIvb1HQkPh0aZeDhUMSwPjU6
         WmKXxIVdA8mWbdpdJ9mQWSFS0GaxhUMED8VA7z9aivgbFGgRyi5KO45SYxDJSk//Lrmi
         TvHQq/KXHoU6IG02YXxnz+VoMPrjzvItFwl89sStfSe8vLDomvkTbOfZZylixHCAfv3w
         Jgwxv2s/jYVL/cbZz1XyHU/++UQYcJaWUXGIWbWEnIOtbM+sQTznmLBg+6U7bpNOdsk9
         JFaEVxGzY3mhCDrcWoTbsIO4wRxo80HsCG5wPORw/u3RxuNka0IHsD1GSswNFX6QovYX
         0b5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4d3Yt8bltpBTGQfRvysGuV0Qwes6q1E1oAAkIYt6v1U=;
        b=r574e3RpA3qDT0TZNruhyFrq8IcI2Rv6wq2iaGGiIfWtU4vEbTP+sN2yPgfTI+5Wyd
         hZTA7foOUPwV3F9ZnAeL+6COE/sVdbEi0HZ+PhAz+MhWQ+T0JnvPtfQmm3m0oZ/tPA4l
         G/spb06owZW8CLZMeo5E4aJ4x317WFlnkOuflBS4fMiR17lQYSxpRO6Loh+NtmdVMw/I
         E11ZNDgXgoYGv2VAR2tCIyA9i/0HxbHaLQ8MxlMLjMbIl/6K3t7uLGClK1QtB0WMMskR
         /wqUuG4yALxPsjdIOJOV8uDuFaIkuxR8zgAlw+biTXMzXjImKlXtHgh85qk5CkNdKt0a
         dtEQ==
X-Gm-Message-State: ANoB5pl2V/xGVz+dQShYl33UxJeWZrPYxlWTjSVldMy8yauomSKDEHsN
        Jjk8b+dDTDxWumMoIfZsFSYuKbYqEcs=
X-Google-Smtp-Source: AA0mqf6cW2WJ5WC9E3zUsYjnyVQVpmP5HVamx7IIHapO1XeJ3XE2sYBO0ex7mjdiJNAJDhKt2nf1vvfpKec=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:d58d:b0:188:ff21:e76b with SMTP id
 k13-20020a170902d58d00b00188ff21e76bmr9022156plh.60.1669849786225; Wed, 30
 Nov 2022 15:09:46 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed, 30 Nov 2022 23:08:49 +0000
In-Reply-To: <20221130230934.1014142-1-seanjc@google.com>
Mime-Version: 1.0
References: <20221130230934.1014142-1-seanjc@google.com>
X-Mailer: git-send-email 2.38.1.584.g0f3c55d4c2-goog
Message-ID: <20221130230934.1014142-6-seanjc@google.com>
Subject: [PATCH v2 05/50] KVM: s390: Unwind kvm_arch_init() piece-by-piece()
 if a step fails
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
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In preparation for folding kvm_arch_hardware_setup() into kvm_arch_init(),
unwind initialization one step at a time instead of simply calling
kvm_arch_exit().  Using kvm_arch_exit() regardless of which initialization
step failed relies on all affected state playing nice with being undone
even if said state wasn't first setup.  That holds true for state that is
currently configured by kvm_arch_init(), but not for state that's handled
by kvm_arch_hardware_setup(), e.g. calling gmap_unregister_pte_notifier()
without first registering a notifier would result in list corruption due
to attempting to delete an entry that was never added to the list.

Signed-off-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Eric Farman <farman@linux.ibm.com>
---
 arch/s390/kvm/kvm-s390.c | 21 ++++++++++++++-------
 1 file changed, 14 insertions(+), 7 deletions(-)

diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index e4890e04b210..221481a09742 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -498,11 +498,11 @@ int kvm_arch_init(void *opaque)
 
 	kvm_s390_dbf_uv = debug_register("kvm-uv", 32, 1, 7 * sizeof(long));
 	if (!kvm_s390_dbf_uv)
-		goto out;
+		goto err_kvm_uv;
 
 	if (debug_register_view(kvm_s390_dbf, &debug_sprintf_view) ||
 	    debug_register_view(kvm_s390_dbf_uv, &debug_sprintf_view))
-		goto out;
+		goto err_debug_view;
 
 	kvm_s390_cpu_feat_init();
 
@@ -510,25 +510,32 @@ int kvm_arch_init(void *opaque)
 	rc = kvm_register_device_ops(&kvm_flic_ops, KVM_DEV_TYPE_FLIC);
 	if (rc) {
 		pr_err("A FLIC registration call failed with rc=%d\n", rc);
-		goto out;
+		goto err_flic;
 	}
 
 	if (IS_ENABLED(CONFIG_VFIO_PCI_ZDEV_KVM)) {
 		rc = kvm_s390_pci_init();
 		if (rc) {
 			pr_err("Unable to allocate AIFT for PCI\n");
-			goto out;
+			goto err_pci;
 		}
 	}
 
 	rc = kvm_s390_gib_init(GAL_ISC);
 	if (rc)
-		goto out;
+		goto err_gib;
 
 	return 0;
 
-out:
-	kvm_arch_exit();
+err_gib:
+	if (IS_ENABLED(CONFIG_VFIO_PCI_ZDEV_KVM))
+		kvm_s390_pci_exit();
+err_pci:
+err_flic:
+err_debug_view:
+	debug_unregister(kvm_s390_dbf_uv);
+err_kvm_uv:
+	debug_unregister(kvm_s390_dbf);
 	return rc;
 }
 
-- 
2.38.1.584.g0f3c55d4c2-goog

