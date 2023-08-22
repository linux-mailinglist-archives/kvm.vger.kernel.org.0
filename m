Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64C0A783798
	for <lists+kvm@lfdr.de>; Tue, 22 Aug 2023 03:51:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232135AbjHVBvb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Aug 2023 21:51:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230404AbjHVBv3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Aug 2023 21:51:29 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFFAD131;
        Mon, 21 Aug 2023 18:51:26 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id ffacd0b85a97d-31c615eb6feso140518f8f.3;
        Mon, 21 Aug 2023 18:51:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1692669085; x=1693273885;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=uiFpBHoaEuu/0InEgqXHitiB2+iHl6O899b6CViVW50=;
        b=TisyrKIPpKr49QCb0EWTaAOvkXrkg9JM5UPqbUMcC5PMPWq/PxdWIiwoiuSQ2k16NG
         au/d1ODbzpAfp+9gQ3rFZA93Da24vUYXg27GrEY3gU0ozmSMk0BOMxwaztAddPhQzvBp
         yjVyXEF/ZfNTaqXg1KtXUPc8tuBi295zGbEGpK0nJmsILJBHlxKt6vKs9Zb8HR1EvqD4
         wTSXFiNZE+XgMjq28TxTSAop2I3LfUpXFEzxeaKZrEDYqEoU3l1/HJu3D+HjSTE/RQRl
         SZ3RueFGdUE1V61syIM2nVZENWVUQ+RIeFQTvnl7PXIZmMaybIErXZYYzrrdeIAMi0nK
         +vmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692669085; x=1693273885;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=uiFpBHoaEuu/0InEgqXHitiB2+iHl6O899b6CViVW50=;
        b=heWzwnNgrRIkdQ74Pw/18JAk+BqzAc4bJ1JFhYauto/gzwQNLUNaVOlXWuFRMoIwI7
         niQIPKX1lDQRpkQcBVu5lEpjKpClRbaFJkSt+dhnMFkJ6SL0vFeY3W26u1TKQioOF2Ny
         bq5rJvwy0r0wBNsz55DJCIEMKW1CKpgw07WKCieV673AByydpcKONpLUbcuDo109+x4A
         Qk0pfkR6H+TvxH4f4vWkngU5GQneQi587Wrq4rCh9fy0vshzESeE3M+1yYJ7UzAk1b0B
         dC9WZ2HdC44BkXAKAGWsQ4E5Riic4CQkgHoHWo03UW7l3PvqSie+CraqSlTnyC6xfJTW
         fucg==
X-Gm-Message-State: AOJu0Yw0LkkD2L/59ek2Oqovw0lkYteG3LHszoJkDsDh00Nn9o+rV77L
        PWT+n/4UoNznCbvNKARZsb6GELxO48Hge0nm0x0=
X-Google-Smtp-Source: AGHT+IEaJsn0RNiLuyt8jjfxcA/GDJ7kaqfzFB+enHSSlkMp2DPufNWbajHVNFtgxafxrQ6qHYwzipJiLcUX7L08138=
X-Received: by 2002:adf:fa47:0:b0:319:6e74:1637 with SMTP id
 y7-20020adffa47000000b003196e741637mr5406224wrr.27.1692669085108; Mon, 21 Aug
 2023 18:51:25 -0700 (PDT)
MIME-Version: 1.0
From:   Hao Peng <flyingpenghao@gmail.com>
Date:   Tue, 22 Aug 2023 09:51:13 +0800
Message-ID: <CAPm50aL0Dv13EAUx3QAdVAv+Ucq2QqtVgGGnEC6t07FDn4+n5g@mail.gmail.com>
Subject: [PATCH] KVM: X86: Reduce size of kvm_vcpu_arch structure when CONFIG_KVM_XEN=n
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Peng Hao <flyingpeng@tencent.com>

When CONFIG_KVM_XEN=n, the size of kvm_vcpu_arch can be reduced
from 5100+ to 4400+ by adding macro control.

Signed-off-by: Peng Hao <flyingpeng@tencent.com>
---
 arch/x86/include/asm/kvm_host.h | 5 ++++-
 arch/x86/kvm/cpuid.c            | 2 ++
 arch/x86/kvm/x86.c              | 2 ++
 3 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 3bc146dfd38d..7e85016a8a0d 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -680,6 +680,7 @@ struct kvm_hypervisor_cpuid {
        u32 limit;
 };

+#ifdef CONFIG_KVM_XEN
 /* Xen HVM per vcpu emulation context */
 struct kvm_vcpu_xen {
        u64 hypercall_rip;
@@ -702,6 +703,7 @@ struct kvm_vcpu_xen {
        struct timer_list poll_timer;
        struct kvm_hypervisor_cpuid cpuid;
 };
+#endif

 struct kvm_queued_exception {
        bool pending;
@@ -912,8 +914,9 @@ struct kvm_vcpu_arch {

        bool hyperv_enabled;
        struct kvm_vcpu_hv *hyperv;
+#ifdef CONFIG_KVM_XEN
        struct kvm_vcpu_xen xen;
-
+#endif
        cpumask_var_t wbinvd_dirty_mask;

        unsigned long last_retry_eip;
diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 7f4d13383cf2..f70a5e7db123 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -422,7 +422,9 @@ static int kvm_set_cpuid(struct kvm_vcpu *vcpu,
struct kvm_cpuid_entry2 *e2,
        vcpu->arch.cpuid_nent = nent;

        vcpu->arch.kvm_cpuid = kvm_get_hypervisor_cpuid(vcpu, KVM_SIGNATURE);
+#ifdef CONFIG_KVM_XEN
        vcpu->arch.xen.cpuid = kvm_get_hypervisor_cpuid(vcpu, XEN_SIGNATURE);
+#endif
        kvm_vcpu_after_set_cpuid(vcpu);

        return 0;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 278dbd37dab2..f5238b2e6cb8 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3231,11 +3231,13 @@ static int kvm_guest_time_update(struct kvm_vcpu *v)

        if (vcpu->pv_time.active)
                kvm_setup_guest_pvclock(v, &vcpu->pv_time, 0);
+#ifdef CONFIG_KVM_XEN
        if (vcpu->xen.vcpu_info_cache.active)
                kvm_setup_guest_pvclock(v, &vcpu->xen.vcpu_info_cache,
                                        offsetof(struct
compat_vcpu_info, time));
        if (vcpu->xen.vcpu_time_info_cache.active)
                kvm_setup_guest_pvclock(v, &vcpu->xen.vcpu_time_info_cache, 0);
+#endif
        kvm_hv_setup_tsc_page(v->kvm, &vcpu->hv_clock);
        return 0;
 }
--
2.31.1
