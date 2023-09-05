Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B56D792803
	for <lists+kvm@lfdr.de>; Tue,  5 Sep 2023 18:42:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237478AbjIEQEW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Sep 2023 12:04:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243976AbjIEBHZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Sep 2023 21:07:25 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57A731B8;
        Mon,  4 Sep 2023 18:07:22 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id ffacd0b85a97d-307d20548adso1688779f8f.0;
        Mon, 04 Sep 2023 18:07:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1693876041; x=1694480841; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Z+16TEVlvXNl9SnUfTt8eBduwj6W82MKg2E06SgE0R0=;
        b=AHHiN5ITyg3MXDlKNBNn4LtDszVNOGGaCTYk+xHI03Sx6d9gNw/xO0HQ69UfG8xilV
         CI5mgXJh0oyKWkqxkevFNCaXpFKZVpelN394p6k+xHW/dyhoAPGksndK4c2uxEWxA0Df
         hSc582j83XvPrgPTqjj3l0m5GpHwkJtEAYZWLCIHCftO2Qlu1JVDN+0Oymai6LDFyP3u
         QAtEiVTipuMwW/QfYKeRCDjdq2Uq6jTALnFhYfS7tT91eCTvNScPE7md8xe8iU0ysjct
         bKTz+JIQ8xRO/ESwyCFsR7wZ+1iTS8nJbtLMHsANIp1OF0aM9+jbtnpTIbRawT4PlkfS
         +qfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693876041; x=1694480841;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Z+16TEVlvXNl9SnUfTt8eBduwj6W82MKg2E06SgE0R0=;
        b=IIs30utBr1/IgfoZB6rTqVceSWxn+qHztJStL1YdxDPbIhoFYzzXoPcX/sm6PTBugY
         b+v5iJny0VPvNJV6Ws1C7RqN/7vrjxCV08BFrrj4U/8mSPMB5Tw7frJVnx5nVbqBksM8
         9OE3I4RvEv4+KqzPeOu7X9naeRBqnW7r9VXlxBjqnuaCB18gdI16olBdZ2PtEa3swN8b
         lsD4jMljaLzn8uHT7pVIwOfYjm9jKlUV2eumc7C2UlratYc0srUucP/LxC1VvP8Jd+GV
         YYO0dT6fmgiMrCnq5xZZUo59tgIvmas0KX+hHpIFBSZaEmOv82JjJylU1iU8Wg9Y86Pi
         35mw==
X-Gm-Message-State: AOJu0YyG8tYawKghN8eCUHTgpvCXlOQ+oUSYoe2fHK8anfNazOigwzkh
        6XKUVpJdTcc8pND0fcUWcQ+61Tb/dG3lsA85W4Y=
X-Google-Smtp-Source: AGHT+IECKEvy4ioFjDYfBrbouO8QNOerugEHbXrl2j/pbKhV9wRY+NKO3rLtbVBkaMj079zoHTIhXik4kI/AcIVQBpo=
X-Received: by 2002:a5d:5482:0:b0:31a:d5fa:d710 with SMTP id
 h2-20020a5d5482000000b0031ad5fad710mr9474704wrv.2.1693876040560; Mon, 04 Sep
 2023 18:07:20 -0700 (PDT)
MIME-Version: 1.0
From:   Hao Peng <flyingpenghao@gmail.com>
Date:   Tue, 5 Sep 2023 09:07:09 +0800
Message-ID: <CAPm50aKwbZGeXPK5uig18Br8CF1hOS71CE2j_dLX+ub7oJdpGg@mail.gmail.com>
Subject: [PATCH RESEND] KVM: X86: Reduce size of kvm_vcpu_arch structure when CONFIG_KVM_XEN=n
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
index 1a4def36d5bb..9320019708f9 100644
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
@@ -930,8 +932,9 @@ struct kvm_vcpu_arch {

        bool hyperv_enabled;
        struct kvm_vcpu_hv *hyperv;
+#ifdef CONFIG_KVM_XEN
        struct kvm_vcpu_xen xen;
-
+#endif
        cpumask_var_t wbinvd_dirty_mask;

        unsigned long last_retry_eip;
diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 0544e30b4946..48f5308c4556 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -456,7 +456,9 @@ static int kvm_set_cpuid(struct kvm_vcpu *vcpu,
struct kvm_cpuid_entry2 *e2,
        vcpu->arch.cpuid_nent = nent;

        vcpu->arch.kvm_cpuid = kvm_get_hypervisor_cpuid(vcpu, KVM_SIGNATURE);
+#ifdef CONFIG_KVM_XEN
        vcpu->arch.xen.cpuid = kvm_get_hypervisor_cpuid(vcpu, XEN_SIGNATURE);
+#endif
        kvm_vcpu_after_set_cpuid(vcpu);

        return 0;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 6c9c81e82e65..4fd08a5e0e98 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3232,11 +3232,13 @@ static int kvm_guest_time_update(struct kvm_vcpu *v)

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
