Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 466C763E45E
	for <lists+kvm@lfdr.de>; Thu,  1 Dec 2022 00:10:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229776AbiK3XKB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Nov 2022 18:10:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229609AbiK3XJo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Nov 2022 18:09:44 -0500
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E7335C0C2
        for <kvm@vger.kernel.org>; Wed, 30 Nov 2022 15:09:43 -0800 (PST)
Received: by mail-pj1-x1049.google.com with SMTP id x17-20020a17090a8a9100b002196a3b190cso2696918pjn.6
        for <kvm@vger.kernel.org>; Wed, 30 Nov 2022 15:09:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=kawSfeiAQQiBaQdAeCS12WX5tLp3dBMfNzsm6MZMVDM=;
        b=FuPyDk5HrtCF5qsfcl43lYyhvkgSpcbbsM90YW/3vO3HUB6l7+MBsntxd3/q8gIxoj
         rdKuy8tsa4qXKw46UszgYe7A8/TdMyQmeCoF+YYW9dIEj0dViDiBTtgxBOSRXDRa96/f
         KliWaD9EYRQHMZlNfki4Q8T7/+zZVlwydZoPGCadpemWGxJB7IFN8q6Q93mpMbE0d+Tv
         Gf+jRZICWLnpxC3g1kbOTurVfxPkN8C+UYy/6R3UIEQErk2k3Er1Jkq5UmKt+OcBkjXI
         DwaZ1o75hI5oxdTAgGbi6NECIv+ulAm+Z4MzH2VhP/t3nIxcOzScSD0PtVDNJOMhMUZG
         LZUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=kawSfeiAQQiBaQdAeCS12WX5tLp3dBMfNzsm6MZMVDM=;
        b=k1z57aqvzHSdgUQIokI4Wu2y02I2L6RgW56h/ui0h0PUUoPMvqSvDSTIRwBfg8uohi
         z4s8VraIX1wIM+lNyWgxG/4j4QVvCBEKSQz0jaMw041hdYDBKVuYddJGq33OS1bCBS9L
         etV/xBZZgUZkPen15b07xngygISSolZFesX52J1bU9nbFx1qNs3AzmEZ760TyNZcuCsm
         9ZomdQtOisro9My7HS9O06maKGXTO2cveMSmQ9YUFNZbEVY+NDrXznJa8axC9C/BPBCi
         X1NJn4PxiJMDcTfAqjEK8tzNX4OOKmr5deSiuTt+UOC0WfdtLlGGO7+Gm+zwxp+6uDAI
         BZ7A==
X-Gm-Message-State: ANoB5pkV+1d7pspPBr1xp3FKRxTpAvn+3atcOwkkaRZeVqml2CAdjfL5
        RzsZh5J+zWV+JjvC/nxDlCrlN1Hgkmw=
X-Google-Smtp-Source: AA0mqf6wj4HWNV+5cP60rIX6ofADo44xPOiR/JXYf/UmKFCdE5+oZoM8ajSF5PuZFF+kh92E+ZGoi4VvFjg=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a62:82c7:0:b0:575:398:468c with SMTP id
 w190-20020a6282c7000000b005750398468cmr21072041pfd.23.1669849782508; Wed, 30
 Nov 2022 15:09:42 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed, 30 Nov 2022 23:08:47 +0000
In-Reply-To: <20221130230934.1014142-1-seanjc@google.com>
Mime-Version: 1.0
References: <20221130230934.1014142-1-seanjc@google.com>
X-Mailer: git-send-email 2.38.1.584.g0f3c55d4c2-goog
Message-ID: <20221130230934.1014142-4-seanjc@google.com>
Subject: [PATCH v2 03/50] KVM: Allocate cpus_hardware_enabled after arch
 hardware setup
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

Allocate cpus_hardware_enabled after arch hardware setup so that arch
"init" and "hardware setup" are called back-to-back and thus can be
combined in a future patch.  cpus_hardware_enabled is never used before
kvm_create_vm(), i.e. doesn't have a dependency with hardware setup and
only needs to be allocated before /dev/kvm is exposed to userspace.

Free the object before the arch hooks are invoked to maintain symmetry,
and so that arch code can move away from the hooks without having to
worry about ordering changes.

Signed-off-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Yuan Yao <yuan.yao@intel.com>
---
 virt/kvm/kvm_main.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 43e2e4f38151..ded88ad6c2d8 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -5862,15 +5862,15 @@ int kvm_init(void *opaque, unsigned vcpu_size, unsigned vcpu_align,
 	if (r)
 		return r;
 
+	r = kvm_arch_hardware_setup(opaque);
+	if (r < 0)
+		goto err_hw_setup;
+
 	if (!zalloc_cpumask_var(&cpus_hardware_enabled, GFP_KERNEL)) {
 		r = -ENOMEM;
 		goto err_hw_enabled;
 	}
 
-	r = kvm_arch_hardware_setup(opaque);
-	if (r < 0)
-		goto out_free_1;
-
 	c.ret = &r;
 	c.opaque = opaque;
 	for_each_online_cpu(cpu) {
@@ -5956,10 +5956,10 @@ int kvm_init(void *opaque, unsigned vcpu_size, unsigned vcpu_align,
 	unregister_reboot_notifier(&kvm_reboot_notifier);
 	cpuhp_remove_state_nocalls(CPUHP_AP_KVM_STARTING);
 out_free_2:
-	kvm_arch_hardware_unsetup();
-out_free_1:
 	free_cpumask_var(cpus_hardware_enabled);
 err_hw_enabled:
+	kvm_arch_hardware_unsetup();
+err_hw_setup:
 	kvm_arch_exit();
 	return r;
 }
@@ -5986,9 +5986,9 @@ void kvm_exit(void)
 	cpuhp_remove_state_nocalls(CPUHP_AP_KVM_STARTING);
 	on_each_cpu(hardware_disable_nolock, NULL, 1);
 	kvm_irqfd_exit();
+	free_cpumask_var(cpus_hardware_enabled);
 	kvm_arch_hardware_unsetup();
 	kvm_arch_exit();
-	free_cpumask_var(cpus_hardware_enabled);
 	kvm_vfio_ops_exit();
 }
 EXPORT_SYMBOL_GPL(kvm_exit);
-- 
2.38.1.584.g0f3c55d4c2-goog

