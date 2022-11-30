Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 610A563E539
	for <lists+kvm@lfdr.de>; Thu,  1 Dec 2022 00:16:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230247AbiK3XQy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Nov 2022 18:16:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230095AbiK3XQK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Nov 2022 18:16:10 -0500
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 920DEA9CCF
        for <kvm@vger.kernel.org>; Wed, 30 Nov 2022 15:11:40 -0800 (PST)
Received: by mail-pj1-x104a.google.com with SMTP id x17-20020a17090a8a9100b002196a3b190cso2699784pjn.6
        for <kvm@vger.kernel.org>; Wed, 30 Nov 2022 15:11:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=feUvU0TLPbMF/Oljy4/vBwowA1Kv3aShJc2OjvbIIRg=;
        b=XCz6nxyHGgxyXLRmcMfZAC0EtbhsJIztANoSGpUb1GyxR0U89bx0wlthHvMKMPI0ma
         xTY/WZ7Fnj2wVoHKg3Vrqyc1suf4XCMLsHgGlIH3pS8IMgIqbDNn8Omsv3AOuHpjB+t4
         oJgjvYZQ+8fVUpIqLH/jYWFcOCZ826P4/OUhmmvNmOkV9CXcwA4ogZ7MlttInnuYA3IQ
         qZwoJRmoUlDf0X9EXI/DaNlV615GX7fyKck9fxTOKS6fYcbuWk1qBQZKq1fDAhiXHC8W
         oTikmOFUnyHawi/4Gg7a9PphvtU6rlpDzwiPDXnAHDvGYvOqtwCfNDpZ92x3xkT78SFn
         sWLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=feUvU0TLPbMF/Oljy4/vBwowA1Kv3aShJc2OjvbIIRg=;
        b=axIGVt9hkNB6bS/aGnLfmXM8jTPn2V849sUm3owflep/RFFLX2jVflAa6TGBt1S3xD
         fxFTqduE4NRcLBJtKN0neG/rgz9zgiSng8BMcG5vhxX/6UWsRrsM9Yug2xOswe5DhgkS
         vG/mOIyxgca/Q+y0N1/xtP3lQNfQwZ86B7uWX3mENZgo9AfNqMyRKdJaU+aR2XN8Tccv
         0lVp1vtPsi8B2098cOxbLD9wjDONtS8QFaGHHf3Gln5i6BkJLrTnDHBk6nKVY0RFU+WY
         i+0+eJYfwFmILUFYZzJACtL5MLHF2/iDFr5+KxizBpl0uTP2fG9kgX3pQblQisditajE
         jP3g==
X-Gm-Message-State: ANoB5pkL1tYRh9hWUYGOu+g4GTLGm4niyirrWfmUuDMF5ukfTCANIX8w
        r38ii2+CZOg3XGjpA7/oyo1RdORAVJ8=
X-Google-Smtp-Source: AA0mqf7uQUQw4xuwzzaB6cJbzF2qtgtcI8g7o82e8li02vBC7sSOacIeo1pVvgKatFPeZtczncyD3ypFXvs=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:903:268d:b0:189:a50d:2a23 with SMTP id
 jf13-20020a170903268d00b00189a50d2a23mr7180858plb.32.1669849855698; Wed, 30
 Nov 2022 15:10:55 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed, 30 Nov 2022 23:09:29 +0000
In-Reply-To: <20221130230934.1014142-1-seanjc@google.com>
Mime-Version: 1.0
References: <20221130230934.1014142-1-seanjc@google.com>
X-Mailer: git-send-email 2.38.1.584.g0f3c55d4c2-goog
Message-ID: <20221130230934.1014142-46-seanjc@google.com>
Subject: [PATCH v2 45/50] KVM: Remove on_each_cpu(hardware_disable_nolock) in kvm_exit()
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

From: Isaku Yamahata <isaku.yamahata@intel.com>

Drop the superfluous invocation of hardware_disable_nolock() during
kvm_exit(), as it's nothing more than a glorified nop.

KVM automatically disables hardware on all CPUs when the last VM is
destroyed, and kvm_exit() cannot be called until the last VM goes
away as the calling module is pinned by an elevated refcount of the fops
associated with /dev/kvm.  This holds true even on x86, where the caller
of kvm_exit() is not kvm.ko, but is instead a dependent module, kvm_amd.ko
or kvm_intel.ko, as kvm_chardev_ops.owner is set to the module that calls
kvm_init(), not hardcoded to the base kvm.ko module.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
[sean: rework changelog]
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 virt/kvm/kvm_main.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 6a8fb53b32f0..a27ded004644 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -5981,7 +5981,6 @@ void kvm_exit(void)
 	unregister_syscore_ops(&kvm_syscore_ops);
 	unregister_reboot_notifier(&kvm_reboot_notifier);
 	cpuhp_remove_state_nocalls(CPUHP_AP_KVM_ONLINE);
-	on_each_cpu(hardware_disable_nolock, NULL, 1);
 	kvm_irqfd_exit();
 	free_cpumask_var(cpus_hardware_enabled);
 }
-- 
2.38.1.584.g0f3c55d4c2-goog

