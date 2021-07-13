Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 125843C74E7
	for <lists+kvm@lfdr.de>; Tue, 13 Jul 2021 18:36:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235797AbhGMQih (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Jul 2021 12:38:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235620AbhGMQiZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Jul 2021 12:38:25 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77C2CC0613BA
        for <kvm@vger.kernel.org>; Tue, 13 Jul 2021 09:34:46 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id p63-20020a25d8420000b029055bc6fd5e5bso27640224ybg.9
        for <kvm@vger.kernel.org>; Tue, 13 Jul 2021 09:34:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=7TYutvwiNQ0wwwZfy6Csacs/gOXz4YtFws186782Baw=;
        b=lDyzSVB8js2o047UWN71BM8/WfEwkxLDHVzimxp2ThMT2lJuStsKlT+8jU2eCOZsds
         QMg5A/eVoPNOz8SnG7Q2cVoIqjg1ogQ+J1uOiMvosgh36iDIbPvrD/bnc2m0hcDB8rXW
         dSqJGy9m0qz1snNWlrUIDNrzkz1lQF3FjDbYGJVVnh/YWgPr2d0Lzj/nvpbHBoWJd1U5
         LaCNIzT4bg8aU41wtyJ1KJhtpwuVH+47X4IGWDmmAX61avOIr1HPfrEv1RupNhbX22Dv
         Hra7g6Fa9nSbPEn8at8DuI6trY91NfsboK1n0d/Z9N4Id/cjLBga1SEXXnJ+UVmBB7Y5
         j8KA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=7TYutvwiNQ0wwwZfy6Csacs/gOXz4YtFws186782Baw=;
        b=K8HZWlD0quzoJq1S0ZK4mQFvS8MiWCsvI77lNlO7ik63irSmaeavphpEmkMTXdSZAx
         n5DDY2bwphZdeuJqcS0I+N9Q08Iysq+2aEy18esAA9YXnmW5WqL996pMP7dOgh7nFWj3
         OU2AoniAKhwvRv7kK3vZ1inP2e9kzl/OBpY4JvbxJhb8rPFeSfdoiG6+GNHUpjDiRAfz
         Oem2vi5e/yVGx+bgJNMWgzb+ArGRDq5d2JF4V21xw213i+beaYbT78h14ft2uRa01uTN
         1HPPX3XX/TjDBBS63kiJwePxirM1W3NIWNGdpOvUoszAOA7Je1K4W70OIY9ztn28rvje
         464g==
X-Gm-Message-State: AOAM530+J5iu2kCgs28peFsrK2CCHUM7hms6OOeIxSowmPKUQvpMRW2g
        VI1IVAXhSOVXnHiIa/R0de7mo2zaHiE=
X-Google-Smtp-Source: ABdhPJz9BrOtOdA4tipcZJ7RCVOjdwjB2CaLZaXT0dUnSI2USqQTlYZpY3sNb/D4smdOz4Iwe7qjAKTP/zk=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:90:200:825e:11a1:364b:8109])
 (user=seanjc job=sendgmr) by 2002:a25:38c7:: with SMTP id f190mr7076549yba.5.1626194085652;
 Tue, 13 Jul 2021 09:34:45 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 13 Jul 2021 09:33:15 -0700
In-Reply-To: <20210713163324.627647-1-seanjc@google.com>
Message-Id: <20210713163324.627647-38-seanjc@google.com>
Mime-Version: 1.0
References: <20210713163324.627647-1-seanjc@google.com>
X-Mailer: git-send-email 2.32.0.93.g670b81a890-goog
Subject: [PATCH v2 37/46] KVM: VMX: Remove obsolete MSR bitmap refresh at vCPU RESET/INIT
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

Remove an unnecessary MSR bitmap refresh during vCPU RESET/INIT.  In both
cases, the MSR bitmap already has the desired values and state.

At RESET, the vCPU is guaranteed to be running with x2APIC disabled, the
x2APIC MSRs are guaranteed to be intercepted due to the MSR bitmap being
initialized to all ones by alloc_loaded_vmcs(), and vmx->msr_bitmap_mode
is guaranteed to be zero, i.e. reflecting x2APIC disabled.

At INIT, the APIC_BASE MSR is not modified, thus there can't be any
change in x2APIC state.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/vmx.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index ef92ec40d3d9..7e99535a4cbb 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -4466,9 +4466,6 @@ static void vmx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
 	if (kvm_mpx_supported())
 		vmcs_write64(GUEST_BNDCFGS, 0);
 
-	if (cpu_has_vmx_msr_bitmap())
-		vmx_update_msr_bitmap(&vmx->vcpu);
-
 	vmcs_write32(VM_ENTRY_INTR_INFO_FIELD, 0);  /* 22.2.1 */
 
 	if (cpu_has_vmx_tpr_shadow() && !init_event) {
-- 
2.32.0.93.g670b81a890-goog

