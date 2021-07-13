Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37EEF3C74E1
	for <lists+kvm@lfdr.de>; Tue, 13 Jul 2021 18:36:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235184AbhGMQi0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Jul 2021 12:38:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234677AbhGMQiN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Jul 2021 12:38:13 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEB36C0613AA
        for <kvm@vger.kernel.org>; Tue, 13 Jul 2021 09:34:39 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id p63-20020a25d8420000b029055bc6fd5e5bso27638673ybg.9
        for <kvm@vger.kernel.org>; Tue, 13 Jul 2021 09:34:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=skFR+CsoOPtmRzhI0uP937m12Z4yOYLQ+FONgUtSivg=;
        b=VUNyEnJAv35fM9G5xqTp30Qf15uHEjgktioN/MXNnOgqOjgJyiLtOthrNo4CVzFWOq
         7FR+Pn31WLI7alKgLgS/XhMvOfGAxaHe4IpK9ljxYyt3+SKc1idY430RXnjcELjuIXVD
         sbBtVq8I51qkeIQANBerUbKhsae8izm7tPGNzxndhYKXxC8DobNsKY5xbUiwWfW4OLEa
         pmlxZoO9XW0evRHpDwEDCPodNs+K2b9LyydThD520BX4vFv3xRVwDVj5lLAlkcQCfCBe
         D5rpSDfu6aWIfZXmj0y2PWCz6Ni50PEaTJUukiQh+IPNpu+Wn33QsKFOPTQuWPp+yua6
         tvKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=skFR+CsoOPtmRzhI0uP937m12Z4yOYLQ+FONgUtSivg=;
        b=UiYc2esTMOPU8JG1l2G9DcDLOqwIzo47qYYANAz1gTbPUuxzyeFGcMStVnqh8Qoegd
         2j+hK258zYpN8dBdv+qhp+qzZG5k6OB47DUhCGGLccDSllPiZKGwjhsSEuxExYBuGItj
         MvOs/uXcZnYfGu1UCKLtp/jpCoPlZAtXCmk+LcEZX7+F1A+7Ee62qMsYI+ZlDpq/3tye
         3xMaHKBJVzVSw7cED7nGE3olQBSmjGth+xFr+fy2y8Cpd7Gw/YGNoj7idGHhcjURqrGy
         +WSbi1jiOySLJzgnV/mfmIzXQbW7h41xjQt8iDVzD24dERarsVDbKZfUxPuyvKxDo0IM
         0IyQ==
X-Gm-Message-State: AOAM531r9zCOQpPs3WtAYRVFDEzBNx1bXFqHGyRW5UvlWZovMkJVy2Qt
        XyLjzpaU5LUe+xFphVrCXSpwIucONu0=
X-Google-Smtp-Source: ABdhPJwlFJn49OqshcuieT77PrsL//3oCmHnYyTpJeaMJp1u9tGGcgfRO0Sx7zmlRsDLItNxd9fVZcFPeOc=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:90:200:825e:11a1:364b:8109])
 (user=seanjc job=sendgmr) by 2002:a25:2e49:: with SMTP id b9mr7359056ybn.250.1626194078968;
 Tue, 13 Jul 2021 09:34:38 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 13 Jul 2021 09:33:12 -0700
In-Reply-To: <20210713163324.627647-1-seanjc@google.com>
Message-Id: <20210713163324.627647-35-seanjc@google.com>
Mime-Version: 1.0
References: <20210713163324.627647-1-seanjc@google.com>
X-Mailer: git-send-email 2.32.0.93.g670b81a890-goog
Subject: [PATCH v2 34/46] KVM: VMX: Refresh list of user return MSRs after
 setting guest CPUID
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

After a CPUID update, refresh the list of user return MSRs that are
loaded into hardware when running the vCPU.  This is necessary to handle
the oddball case where userspace exposes X86_FEATURE_RDTSCP to the guest
after the vCPU is running.

Fixes: 0023ef39dc35 ("kvm: vmx: Set IA32_TSC_AUX for legacy mode guests")
Fixes: 4e47c7a6d714 ("KVM: VMX: Add instruction rdtscp support for guest")
Reviewed-by: Reiji Watanabe <reijiw@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/vmx.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index d7a4db15a169..3045daa3ec30 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7159,6 +7159,8 @@ static void vmx_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
 	/* xsaves_enabled is recomputed in vmx_compute_secondary_exec_control(). */
 	vcpu->arch.xsaves_enabled = false;
 
+	vmx_setup_uret_msrs(vmx);
+
 	if (cpu_has_secondary_exec_ctrls()) {
 		vmx_compute_secondary_exec_control(vmx);
 		vmcs_set_secondary_exec_control(vmx);
-- 
2.32.0.93.g670b81a890-goog

