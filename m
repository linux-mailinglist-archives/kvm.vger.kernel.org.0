Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAD333C74D8
	for <lists+kvm@lfdr.de>; Tue, 13 Jul 2021 18:36:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235397AbhGMQiH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Jul 2021 12:38:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235671AbhGMQhz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Jul 2021 12:37:55 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FE88C0617A6
        for <kvm@vger.kernel.org>; Tue, 13 Jul 2021 09:34:30 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id p63-20020a25d8420000b029055bc6fd5e5bso27638049ybg.9
        for <kvm@vger.kernel.org>; Tue, 13 Jul 2021 09:34:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=TAL/n8RnNwdD8AwDKd/laGABPuxqZ6wUJPdjHXeK3wU=;
        b=Tr7xd27FqJinXV9I+T++c9rT4QfnImlcAvns5MU0AaTRwComalb5fSUqdheriwG/7N
         NU0zoFwh7c2Aak7fekov/B3SRExinrkiNAINVwwZ//nqu4kWDT/nCxV1WYXPFAEiBfcO
         pOTfu7td7Rqwl88FOQK2db0Ul+VpOY3LMKpQNAhgjIggJvpv+uFkrhaMY3pSh0kBl+dH
         sYKkTSAFNm1ThFueKxi8XVz/4JyF3v2QptuyhYhFvPH1zx/OaMK3araEOz+zI0LCn9OK
         weA3k8XskRDIylCsLInLhe2sTI9Qfsd/JBZnzJCHzLZGqMVvYYOJzgI9RGE/15AJUBfo
         AY9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=TAL/n8RnNwdD8AwDKd/laGABPuxqZ6wUJPdjHXeK3wU=;
        b=mTpI/YSBXX+kStNYVj8IES3919pnKF+2eY194eRYAHUTUfRuwraXX54wzz7OW7k3YJ
         J8K+83Z1XwyYpfGmUnrgIzkU0eKreHodBOQvppu0qePkErwXg9jqxTVykZUzbLJJzSsZ
         XW4i4+2WjlrfcxiwthZr8JcPek6fUV6KSfC+INalHKGhOTvhc2JpBqwcyIsrpbbFEGcL
         U3EBcmOIznnmsb/miJXJG7mv+uPMnNhz2hNIu/VAy37DgvSR12Yez7flUlHKZMW3x11p
         fN2U3Fyp0pvj0BLEZFmcqS/MO5Dah/uVKL1MkFAOJVf4zKV8wSTcPg90gdleUmWrTBO4
         FKZA==
X-Gm-Message-State: AOAM533x04pxq9cFUSd9EQ+cgMr7Sh22aCFnxumEW1tRCrTeKI3bQjHG
        dOJHfSj4SdnsCsqaOLRjkVxbC3y6oOA=
X-Google-Smtp-Source: ABdhPJyCKJLetM0jt9gxVmJZdJLGtEJ5Zh7Ru2a2KvBCilNSVSWuC4qgRlH2IPTLc4+pXas/nnyBw8B+1w4=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:90:200:825e:11a1:364b:8109])
 (user=seanjc job=sendgmr) by 2002:a25:7c7:: with SMTP id 190mr7065632ybh.194.1626194069449;
 Tue, 13 Jul 2021 09:34:29 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 13 Jul 2021 09:33:07 -0700
In-Reply-To: <20210713163324.627647-1-seanjc@google.com>
Message-Id: <20210713163324.627647-30-seanjc@google.com>
Mime-Version: 1.0
References: <20210713163324.627647-1-seanjc@google.com>
X-Mailer: git-send-email 2.32.0.93.g670b81a890-goog
Subject: [PATCH v2 29/46] KVM: nVMX: Don't evaluate "emulation required" on
 nested VM-Exit
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Reiji Watanabe <reijiw@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Use the "internal" variants of setting segment registers when stuffing
state on nested VM-Exit in order to skip the "emulation required"
updates.  VM-Exit must always go to protected mode, and all segments are
mostly hardcoded (to valid values) on VM-Exit.  The bits of the segments
that aren't hardcoded are explicitly checked during VM-Enter, e.g. the
selector RPLs must all be zero.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/nested.c | 16 ++++++++--------
 arch/x86/kvm/vmx/vmx.c    |  6 ++----
 arch/x86/kvm/vmx/vmx.h    |  2 +-
 3 files changed, 11 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 7f8184f432b4..a77cfc8bcf11 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -4267,7 +4267,7 @@ static void load_vmcs12_host_state(struct kvm_vcpu *vcpu,
 		seg.l = 1;
 	else
 		seg.db = 1;
-	vmx_set_segment(vcpu, &seg, VCPU_SREG_CS);
+	__vmx_set_segment(vcpu, &seg, VCPU_SREG_CS);
 	seg = (struct kvm_segment) {
 		.base = 0,
 		.limit = 0xFFFFFFFF,
@@ -4278,17 +4278,17 @@ static void load_vmcs12_host_state(struct kvm_vcpu *vcpu,
 		.g = 1
 	};
 	seg.selector = vmcs12->host_ds_selector;
-	vmx_set_segment(vcpu, &seg, VCPU_SREG_DS);
+	__vmx_set_segment(vcpu, &seg, VCPU_SREG_DS);
 	seg.selector = vmcs12->host_es_selector;
-	vmx_set_segment(vcpu, &seg, VCPU_SREG_ES);
+	__vmx_set_segment(vcpu, &seg, VCPU_SREG_ES);
 	seg.selector = vmcs12->host_ss_selector;
-	vmx_set_segment(vcpu, &seg, VCPU_SREG_SS);
+	__vmx_set_segment(vcpu, &seg, VCPU_SREG_SS);
 	seg.selector = vmcs12->host_fs_selector;
 	seg.base = vmcs12->host_fs_base;
-	vmx_set_segment(vcpu, &seg, VCPU_SREG_FS);
+	__vmx_set_segment(vcpu, &seg, VCPU_SREG_FS);
 	seg.selector = vmcs12->host_gs_selector;
 	seg.base = vmcs12->host_gs_base;
-	vmx_set_segment(vcpu, &seg, VCPU_SREG_GS);
+	__vmx_set_segment(vcpu, &seg, VCPU_SREG_GS);
 	seg = (struct kvm_segment) {
 		.base = vmcs12->host_tr_base,
 		.limit = 0x67,
@@ -4296,11 +4296,11 @@ static void load_vmcs12_host_state(struct kvm_vcpu *vcpu,
 		.type = 11,
 		.present = 1
 	};
-	vmx_set_segment(vcpu, &seg, VCPU_SREG_TR);
+	__vmx_set_segment(vcpu, &seg, VCPU_SREG_TR);
 
 	memset(&seg, 0, sizeof(seg));
 	seg.unusable = 1;
-	vmx_set_segment(vcpu, &seg, VCPU_SREG_LDTR);
+	__vmx_set_segment(vcpu, &seg, VCPU_SREG_LDTR);
 
 	kvm_set_dr(vcpu, 7, 0x400);
 	vmcs_write64(GUEST_IA32_DEBUGCTL, 0);
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 7ab493708b06..a1e5706fd27b 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2719,8 +2719,6 @@ static __init int alloc_kvm_area(void)
 	return 0;
 }
 
-static void __vmx_set_segment(struct kvm_vcpu *vcpu, struct kvm_segment *var, int seg);
-
 static void fix_pmode_seg(struct kvm_vcpu *vcpu, int seg,
 		struct kvm_segment *save)
 {
@@ -3293,7 +3291,7 @@ static u32 vmx_segment_access_rights(struct kvm_segment *var)
 	return ar;
 }
 
-static void __vmx_set_segment(struct kvm_vcpu *vcpu, struct kvm_segment *var, int seg)
+void __vmx_set_segment(struct kvm_vcpu *vcpu, struct kvm_segment *var, int seg)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 	const struct kvm_vmx_segment_field *sf = &kvm_vmx_segment_fields[seg];
@@ -3330,7 +3328,7 @@ static void __vmx_set_segment(struct kvm_vcpu *vcpu, struct kvm_segment *var, in
 	vmcs_write32(sf->ar_bytes, vmx_segment_access_rights(var));
 }
 
-void vmx_set_segment(struct kvm_vcpu *vcpu, struct kvm_segment *var, int seg)
+static void vmx_set_segment(struct kvm_vcpu *vcpu, struct kvm_segment *var, int seg)
 {
 	__vmx_set_segment(vcpu, var, seg);
 
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 3979a947933a..b584e41bed44 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -373,7 +373,7 @@ void vmx_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4);
 void set_cr4_guest_host_mask(struct vcpu_vmx *vmx);
 void ept_save_pdptrs(struct kvm_vcpu *vcpu);
 void vmx_get_segment(struct kvm_vcpu *vcpu, struct kvm_segment *var, int seg);
-void vmx_set_segment(struct kvm_vcpu *vcpu, struct kvm_segment *var, int seg);
+void __vmx_set_segment(struct kvm_vcpu *vcpu, struct kvm_segment *var, int seg);
 u64 construct_eptp(struct kvm_vcpu *vcpu, hpa_t root_hpa, int root_level);
 
 bool vmx_guest_inject_ac(struct kvm_vcpu *vcpu);
-- 
2.32.0.93.g670b81a890-goog

