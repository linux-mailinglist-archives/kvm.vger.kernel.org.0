Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F485369E05
	for <lists+kvm@lfdr.de>; Sat, 24 Apr 2021 02:51:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244368AbhDXAuO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Apr 2021 20:50:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244352AbhDXAsg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 23 Apr 2021 20:48:36 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CB85C061358
        for <kvm@vger.kernel.org>; Fri, 23 Apr 2021 17:47:31 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id d89-20020a25a3620000b02904dc8d0450c6so26111233ybi.2
        for <kvm@vger.kernel.org>; Fri, 23 Apr 2021 17:47:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=j3nbddZ5OdcUiZfcbardrnX3JrHsR8vaFmvYceXtq5I=;
        b=dKe4MKRvLa5cRtsNK4gaIDmSYQHgrK6HZIpAsyjq5XO5C4inuSFTII5JMRUmVJzXO0
         8VHQBy2+xo8oZayRmPKItvDmKdNdRuIPJqQZa4cLnC5KscQ7Aq/LTCU8DVv7qb5GC+AD
         yjAcS3r0HGIWOCVN+ZRImA7MF0D83q5DRO6gY0W04w0E7NvJ3cFyeP0Jjs/voZ/cexGC
         MEQKa/YbcCUuHyQvaHqdr5TRD48KLW2xGxTTykCSAZaTcM1PI+JXSm8h+Fc9QVsHU1Si
         vIhnp66PtNcU98viffnLyGm3O/yFNILgnzPpqBDLNomM86ua6lhUrvaFQuKmv0gqm5dg
         eEWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=j3nbddZ5OdcUiZfcbardrnX3JrHsR8vaFmvYceXtq5I=;
        b=o7x0xJZoUq9BDYAwGEozot5dsvd7GHN8yF3JX6SrZPX6TIjyFCNeSQ1bzGRrxnQD8M
         oJFWsnjtuIcwRqeqMceo8EUxwjkrR40wnH8mOimZcPHTICyMBMGwPVYH0EgG0OG/M7xc
         QaaHgRiTQCnZ3/5pEd5USrI9FSKQdUylX1YM/LvorDg94dUSevCra/EnX+aBAx2ZNpde
         SMwtOk/ATPNb7l0nkkgYr5WClWVBww8LQw9Ils/Kr8B+JOAGRt33mmYI+SX/Sb1mk6Hu
         GRXbL/KRLaS9lzQ0AkRN2i31Onk9l7Ya7/K0XCT7KnGMA1fj1VftWMZDmuvAWsAPXuqi
         Lfxg==
X-Gm-Message-State: AOAM532se1NWTG98koq+H/e9XU+dKAaHGgA3cApW1zbwPwJqUSdoiAvN
        KB0+V7CQwUxRootZqAmIou4QJdBZCUU=
X-Google-Smtp-Source: ABdhPJyDQvjVL0RRlUvUPqCuXq5ryPDQ7vkxO0EQR2T+iSYbWrRdUteCU5Z+BZGctP9roBG4voJIlHKok7I=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:ad52:3246:e190:f070])
 (user=seanjc job=sendgmr) by 2002:a25:ae16:: with SMTP id a22mr7205063ybj.449.1619225250892;
 Fri, 23 Apr 2021 17:47:30 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 23 Apr 2021 17:46:16 -0700
In-Reply-To: <20210424004645.3950558-1-seanjc@google.com>
Message-Id: <20210424004645.3950558-15-seanjc@google.com>
Mime-Version: 1.0
References: <20210424004645.3950558-1-seanjc@google.com>
X-Mailer: git-send-email 2.31.1.498.g6c1eba8ee3d-goog
Subject: [PATCH 14/43] KVM: x86: Don't force set BSP bit when local APIC is
 managed by userspace
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Don't set the BSP bit in vcpu->arch.apic_base when the local APIC is
managed by userspace.  Forcing all vCPUs to be BSPs is non-sensical, and
was dead code when it was added by commit 97222cc83163 ("KVM: Emulate
local APIC in kernel").  At the time, kvm_lapic_set_base() was invoked
if and only if the local APIC was in-kernel (and it couldn't be called
before the vCPU created its APIC).

kvm_lapic_set_base() eventually gained generic usage, but the latent bug
escaped notice because the only true consumer would be the guest itself
in the form of an explicit RDMSRs on APs.  Out of Linux, SeaBIOS, and
EDK2/OVMF, only OVMF consume the BSP bit from the APIC_BASE MSR.  For
the vast majority of usage in OVMF, BSP confusion would be benign.
OVMF's BSP election upon SMI rendezvous might be broken, but practically
no one runs KVM with an out-of-kernel local APIC, let alone does so while
utilizing SMIs with OVMF.

Fixes: 97222cc83163 ("KVM: Emulate local APIC in kernel")
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/lapic.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index b99630c6d7fe..c11f23753a5b 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -2252,9 +2252,6 @@ void kvm_lapic_set_base(struct kvm_vcpu *vcpu, u64 value)
 	u64 old_value = vcpu->arch.apic_base;
 	struct kvm_lapic *apic = vcpu->arch.apic;
 
-	if (!apic)
-		value |= MSR_IA32_APICBASE_BSP;
-
 	vcpu->arch.apic_base = value;
 
 	if ((old_value ^ value) & MSR_IA32_APICBASE_ENABLE)
-- 
2.31.1.498.g6c1eba8ee3d-goog

