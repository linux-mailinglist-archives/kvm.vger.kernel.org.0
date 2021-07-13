Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B990C3C74B9
	for <lists+kvm@lfdr.de>; Tue, 13 Jul 2021 18:36:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234103AbhGMQhI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Jul 2021 12:37:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234564AbhGMQgy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Jul 2021 12:36:54 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CCF7C061786
        for <kvm@vger.kernel.org>; Tue, 13 Jul 2021 09:34:01 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id x84-20020a2531570000b029055d47682463so26321223ybx.5
        for <kvm@vger.kernel.org>; Tue, 13 Jul 2021 09:34:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=+Nszryi/FBfiKvCS21S457SpsXLG0MQv2DcCak+yOfg=;
        b=dYSEg7/diIS9Cfak6cnpxdhGL0FSJKRng8fOxUiZH4b+JZquqrZU6RwapYCQ2b/WwQ
         Ql5679h0r51uwoi2GFoLh1gyv0COTeR6sm67Yz9DozbVn3azGAxAYEOxmnBnbkAlsiJO
         BTFeNCyI2qs1Q/LZmHbj88ZQGfmFPUrVTzC0ZhKXGvcgZf5nofq7AyInPrhRDsnRALtr
         ClnjS9VvZfRGJIAojOgna+w37eQubM9cior+bQJqIV3OCAvEXwSMnG3uG99rB5zzIG/7
         FPCVd2Cb2512mgJdZElaqqNbsMd5/zILNMk/j/IlxbRmn9pc04pf7Bzc0IGUf5QxiCym
         T/pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=+Nszryi/FBfiKvCS21S457SpsXLG0MQv2DcCak+yOfg=;
        b=ba/GBeGOjna1G9zFQa2OMCM6M2cUy3QyEiaGeo0TIoVALqC9xbayLQWQGoDBz5nq9u
         RAB5cgwoZsgbh71FdpnjzjxS034Zt4OvuQEuZNPJP/1iG2j7bCE95U7vPIe4+XKp+IkF
         YK3fJOVeBIhLloM5oD558eJhvT+XzZyJ/+GY3SQhpY4aUqUlniy4ngp7bwsszel938Ca
         Z5TiCasYCNYwn32Xozclg7nSxHaqXIVdE9VPA6rh5AeXfnzBZNOew7HRxT+04QeMB/aO
         jpt01bWSUTNsGe2IBwLMyOrku90kzp9fy4K+g5HMdoLKGjG1fZ5vagDsQrUHcTKsCZFQ
         xOug==
X-Gm-Message-State: AOAM530t4lHDLOTpeXewMf07Tn13wKUs8RLDw78zNb01rxjVGAr8PM9g
        rlHfYJDNkV27fgcnAYkZTYOTiGvo+kE=
X-Google-Smtp-Source: ABdhPJxffu2ahKXuQIo8OH4YIeYZkZ120VWwITlZ1im5RmpLKGGaQQboqVBU5fYWDnF0FGkKEQowlrh+Pds=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:90:200:825e:11a1:364b:8109])
 (user=seanjc job=sendgmr) by 2002:a25:6d43:: with SMTP id i64mr6948596ybc.252.1626194040788;
 Tue, 13 Jul 2021 09:34:00 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 13 Jul 2021 09:32:52 -0700
In-Reply-To: <20210713163324.627647-1-seanjc@google.com>
Message-Id: <20210713163324.627647-15-seanjc@google.com>
Mime-Version: 1.0
References: <20210713163324.627647-1-seanjc@google.com>
X-Mailer: git-send-email 2.32.0.93.g670b81a890-goog
Subject: [PATCH v2 14/46] KVM: x86: Don't force set BSP bit when local APIC is
 managed by userspace
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

Don't set the BSP bit in vcpu->arch.apic_base when the local APIC is
managed by userspace.  Forcing all vCPUs to be BSPs is non-sensical, and
was dead code when it was added by commit 97222cc83163 ("KVM: Emulate
local APIC in kernel").  At the time, kvm_lapic_set_base() was invoked
if and only if the local APIC was in-kernel (and it couldn't be called
before the vCPU created its APIC).

kvm_lapic_set_base() eventually gained generic usage, but the latent bug
escaped notice because the only true consumer would be the guest itself
in the form of an explicit RDMSRs on APs.  Out of Linux, SeaBIOS, and
EDK2/OVMF, only OVMF consumes the BSP bit from the APIC_BASE MSR.  For
the vast majority of usage in OVMF, BSP confusion would be benign.
OVMF's BSP election upon SMI rendezvous might be broken, but practically
no one runs KVM with an out-of-kernel local APIC, let alone does so while
utilizing SMIs with OVMF.

Fixes: 97222cc83163 ("KVM: Emulate local APIC in kernel")
Reviewed-by: Reiji Watanabe <reijiw@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/lapic.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index a24ce8fe93e5..acb201d16b5e 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -2268,9 +2268,6 @@ void kvm_lapic_set_base(struct kvm_vcpu *vcpu, u64 value)
 	u64 old_value = vcpu->arch.apic_base;
 	struct kvm_lapic *apic = vcpu->arch.apic;
 
-	if (!apic)
-		value |= MSR_IA32_APICBASE_BSP;
-
 	vcpu->arch.apic_base = value;
 
 	if ((old_value ^ value) & MSR_IA32_APICBASE_ENABLE)
-- 
2.32.0.93.g670b81a890-goog

