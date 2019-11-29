Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3ECAA10DB16
	for <lists+kvm@lfdr.de>; Fri, 29 Nov 2019 22:36:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387507AbfK2VgL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 Nov 2019 16:36:11 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:21280 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727428AbfK2VfY (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 29 Nov 2019 16:35:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575063322;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rb+6DP+izG5ltISMKHwwwOgrlsplIg1b9aT7OhqAVdI=;
        b=LxZkIhF12KpKao3v/6U+tXVfQtVQVUINEKQQkA+TYUszcP7PYTZdzK9UVoeWrVSmO7It1n
        g+YY8Wwr/gFdbzFWDTUsYAH76o+oslM/MSrr9IbO/IqKSI2kPMCcWlJYAeqB2A20jyc/A9
        R5HPIAfP37LJW9SbBXfJdPooqBEO7Dw=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-320-LMOSyk9AP0GrljO6M_F8zQ-1; Fri, 29 Nov 2019 16:35:21 -0500
Received: by mail-qt1-f198.google.com with SMTP id r9so8017206qtc.4
        for <kvm@vger.kernel.org>; Fri, 29 Nov 2019 13:35:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=TqT6uWauQhM+3HI2ETpe/nnUa6snC1aBt/hCGN1iX+A=;
        b=P7GHICwDRlNzl+dlxJK5/MSdBixpbA5rWC9D1cW5EiPjg5e05sxGHKQsRaTcQI4Pyq
         /n3/kNhWC5uYZNBq1jINZdLXBbujb+vHw05dlIoc11ewOV92+VvFaxXJxGMY8tG7V6VM
         yGPm0u7h1/Y2PRtgM5AQiamYSBB3oSNhYciQimB+OyfFDRdxnO4cBkgi3ivPvGhfNGHo
         peridKZS5R24N+5cqGATwlp9Wc2F3+2rDfde1/aD7KbUVby6tn8T3P2pY+QRq4ckyUEO
         4trHMKaELGfjZZPxq9UAHRYJfi2XN5Fyz1tKWHgv0YM1Sp3HC0LWCgbNGulitDYYALPr
         JedQ==
X-Gm-Message-State: APjAAAViz8aTAVbzDGWtGSlEOmBv+nohQrHD10f1qx9fRaiwM3UnwRTw
        TvA3LsJ/lqCFKtcb2khiEmQUBrhuI3t2ixSnZD461aNfwviESzUlC0FC6cVFvjrWqEQYMh2WgwS
        Xsk77YykHbN0J
X-Received: by 2002:ac8:4645:: with SMTP id f5mr6786383qto.38.1575063320072;
        Fri, 29 Nov 2019 13:35:20 -0800 (PST)
X-Google-Smtp-Source: APXvYqxiIQ1NW11IAZ9fWbWj6uQIg3tSGAXVrGfRP6H3jI30bN59TZ3wxfmGTTSHhx9icJnaJHMVaQ==
X-Received: by 2002:ac8:4645:: with SMTP id f5mr6786365qto.38.1575063319872;
        Fri, 29 Nov 2019 13:35:19 -0800 (PST)
Received: from xz-x1.yyz.redhat.com ([104.156.64.74])
        by smtp.gmail.com with ESMTPSA id h186sm10679046qkf.64.2019.11.29.13.35.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Nov 2019 13:35:18 -0800 (PST)
From:   Peter Xu <peterx@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>, peterx@redhat.com,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: [PATCH RFC 07/15] KVM: X86: Implement ring-based dirty memory tracking
Date:   Fri, 29 Nov 2019 16:34:57 -0500
Message-Id: <20191129213505.18472-8-peterx@redhat.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191129213505.18472-1-peterx@redhat.com>
References: <20191129213505.18472-1-peterx@redhat.com>
MIME-Version: 1.0
X-MC-Unique: LMOSyk9AP0GrljO6M_F8zQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: "Cao, Lei" <Lei.Cao@stratus.com>

Add new KVM exit reason KVM_EXIT_DIRTY_LOG_FULL and connect
KVM_REQ_DIRTY_LOG_FULL to it.

Signed-off-by: Lei Cao <lei.cao@stratus.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
[peterx: rebase, return 0 instead of -EINTR for user exits,
 emul_insn before exit to userspace]
Signed-off-by: Peter Xu <peterx@redhat.com>
---
 arch/x86/include/asm/kvm_host.h |  5 +++++
 arch/x86/include/uapi/asm/kvm.h |  1 +
 arch/x86/kvm/mmu/mmu.c          |  6 ++++++
 arch/x86/kvm/vmx/vmx.c          |  7 +++++++
 arch/x86/kvm/x86.c              | 12 ++++++++++++
 5 files changed, 31 insertions(+)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_hos=
t.h
index b79cd6aa4075..67521627f9e4 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -49,6 +49,8 @@
=20
 #define KVM_IRQCHIP_NUM_PINS  KVM_IOAPIC_NUM_PINS
=20
+#define KVM_DIRTY_RING_VERSION 1
+
 /* x86-specific vcpu->requests bit members */
 #define KVM_REQ_MIGRATE_TIMER=09=09KVM_ARCH_REQ(0)
 #define KVM_REQ_REPORT_TPR_ACCESS=09KVM_ARCH_REQ(1)
@@ -1176,6 +1178,7 @@ struct kvm_x86_ops {
 =09=09=09=09=09   struct kvm_memory_slot *slot,
 =09=09=09=09=09   gfn_t offset, unsigned long mask);
 =09int (*write_log_dirty)(struct kvm_vcpu *vcpu);
+=09int (*cpu_dirty_log_size)(void);
=20
 =09/* pmu operations of sub-arch */
 =09const struct kvm_pmu_ops *pmu_ops;
@@ -1661,4 +1664,6 @@ static inline int kvm_cpu_get_apicid(int mps_cpu)
 #define GET_SMSTATE(type, buf, offset)=09=09\
 =09(*(type *)((buf) + (offset) - 0x7e00))
=20
+int kvm_cpu_dirty_log_size(void);
+
 #endif /* _ASM_X86_KVM_HOST_H */
diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kv=
m.h
index 503d3f42da16..b59bf356c478 100644
--- a/arch/x86/include/uapi/asm/kvm.h
+++ b/arch/x86/include/uapi/asm/kvm.h
@@ -12,6 +12,7 @@
=20
 #define KVM_PIO_PAGE_OFFSET 1
 #define KVM_COALESCED_MMIO_PAGE_OFFSET 2
+#define KVM_DIRTY_LOG_PAGE_OFFSET 64
=20
 #define DE_VECTOR 0
 #define DB_VECTOR 1
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 6f92b40d798c..f7efb69b089e 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1818,7 +1818,13 @@ int kvm_arch_write_log_dirty(struct kvm_vcpu *vcpu)
 {
 =09if (kvm_x86_ops->write_log_dirty)
 =09=09return kvm_x86_ops->write_log_dirty(vcpu);
+=09return 0;
+}
=20
+int kvm_cpu_dirty_log_size(void)
+{
+=09if (kvm_x86_ops->cpu_dirty_log_size)
+=09=09return kvm_x86_ops->cpu_dirty_log_size();
 =09return 0;
 }
=20
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index d175429c91b0..871489d92d3c 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7710,6 +7710,7 @@ static __init int hardware_setup(void)
 =09=09kvm_x86_ops->slot_disable_log_dirty =3D NULL;
 =09=09kvm_x86_ops->flush_log_dirty =3D NULL;
 =09=09kvm_x86_ops->enable_log_dirty_pt_masked =3D NULL;
+=09=09kvm_x86_ops->cpu_dirty_log_size =3D NULL;
 =09}
=20
 =09if (!cpu_has_vmx_preemption_timer())
@@ -7774,6 +7775,11 @@ static __exit void hardware_unsetup(void)
 =09free_kvm_area();
 }
=20
+static int vmx_cpu_dirty_log_size(void)
+{
+=09return enable_pml ? PML_ENTITY_NUM : 0;
+}
+
 static struct kvm_x86_ops vmx_x86_ops __ro_after_init =3D {
 =09.cpu_has_kvm_support =3D cpu_has_kvm_support,
 =09.disabled_by_bios =3D vmx_disabled_by_bios,
@@ -7896,6 +7902,7 @@ static struct kvm_x86_ops vmx_x86_ops __ro_after_init=
 =3D {
 =09.flush_log_dirty =3D vmx_flush_log_dirty,
 =09.enable_log_dirty_pt_masked =3D vmx_enable_log_dirty_pt_masked,
 =09.write_log_dirty =3D vmx_write_pml_buffer,
+=09.cpu_dirty_log_size =3D vmx_cpu_dirty_log_size,
=20
 =09.pre_block =3D vmx_pre_block,
 =09.post_block =3D vmx_post_block,
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 3ed167e039e5..03ff34783fa1 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8094,6 +8094,18 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 =09=09 */
 =09=09if (kvm_check_request(KVM_REQ_HV_STIMER, vcpu))
 =09=09=09kvm_hv_process_stimers(vcpu);
+
+=09=09if (kvm_check_request(KVM_REQ_DIRTY_RING_FULL, vcpu)) {
+=09=09=09vcpu->run->exit_reason =3D KVM_EXIT_DIRTY_RING_FULL;
+=09=09=09/*
+=09=09=09 * If this is requested, it means that we've
+=09=09=09 * marked the dirty bit in the dirty ring BUT
+=09=09=09 * we've not written the date.  Do it now.
+=09=09=09 */
+=09=09=09r =3D kvm_emulate_instruction(vcpu, 0);
+=09=09=09r =3D r >=3D 0 ? 0 : r;
+=09=09=09goto out;
+=09=09}
 =09}
=20
 =09if (kvm_check_request(KVM_REQ_EVENT, vcpu) || req_int_win) {
--=20
2.21.0

