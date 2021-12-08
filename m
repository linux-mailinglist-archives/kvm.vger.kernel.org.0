Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACEAC46CA82
	for <lists+kvm@lfdr.de>; Wed,  8 Dec 2021 02:55:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243459AbhLHB6q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Dec 2021 20:58:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243320AbhLHB6b (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Dec 2021 20:58:31 -0500
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5D86C061B38
        for <kvm@vger.kernel.org>; Tue,  7 Dec 2021 17:55:00 -0800 (PST)
Received: by mail-pl1-x649.google.com with SMTP id l3-20020a170902f68300b00142892d0a86so271798plg.13
        for <kvm@vger.kernel.org>; Tue, 07 Dec 2021 17:55:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=Y0QMANkJxI2glAsK9IA64IH6P6lAaThDPE5dh7pbbb0=;
        b=qxN7OH5XsEStC6fU9PcDLD5FmeauGir9Ufc9wpseLEk09vsdVA9CNv8R3lYl/+PAU1
         PjwhLJaLgkDzWb1C6kQ/++cGLl3queGaDz/B7l9Bny8v5wuft2Qj1mlocVXs2qlpkvPn
         Vn6E3GvsfvZd84P2V1/sqmMj2uPksI7lpm+aNjNzP6AywbLriR+HvhCWV8nphWzMgIoZ
         xn0e2ks6gEKgkb3DUU1vFkQPtW7vkRMyAzMBIuY/IPGWMSEpb9MOVnZfZ8IDrElyxpIc
         KBmKhwent59Pw2D94aIdPWGKsGq6NmlX7FAEstBomhCpfSknPX8Cmd0pW34ZqLQdsuwN
         +gMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=Y0QMANkJxI2glAsK9IA64IH6P6lAaThDPE5dh7pbbb0=;
        b=ul4uelTzWYQT4YciuXidubnVA/lsMHKe1dv+vWe8woj7NL4vs+uVSXyl+7Zm89BwAx
         8QHUS7XVrgUgG95j4GGLkbWMKGfROpbzCROMV3fq5Uy9j+4wfqkbt5qjrxvjpbabxN5z
         fmBL/lI1LPnnPlaTxbUrFawcFi+ljAau/U1znMRXdfvLl5YghXodbQWKgrdPiWNkVv/r
         PDxiQpcQ4I4Dwyz4uuhLbxqZK7Rumq/ywFX8i1j8uv+2N2FBZHw6A3VyAjgFNF2t0L+k
         lA40bnlwe53yneDOOVS/iHshNQ2GW9SRVBGMHxR8EzEkSTvsJHQdAMCE+6IpmCULjqqI
         s7Mw==
X-Gm-Message-State: AOAM530u1ZAYCMkExhf+rXIsd8vAa4WmRsZ3IGKHSQa0omEIJz2iehuk
        vRSpYh0qESgtMBSkiHfKHB0p71UyLHA=
X-Google-Smtp-Source: ABdhPJy6J8AgABZjKxA/fW5ow4o7SwNrge1ufnjwXJ/xhru5AumNEfY4EXs6Drt37icnUrTEV63NfM8nTSk=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:902:9882:b0:143:91ca:ca6e with SMTP id
 s2-20020a170902988200b0014391caca6emr56006763plp.64.1638928500452; Tue, 07
 Dec 2021 17:55:00 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed,  8 Dec 2021 01:52:18 +0000
In-Reply-To: <20211208015236.1616697-1-seanjc@google.com>
Message-Id: <20211208015236.1616697-9-seanjc@google.com>
Mime-Version: 1.0
References: <20211208015236.1616697-1-seanjc@google.com>
X-Mailer: git-send-email 2.34.1.400.ga245620fadb-goog
Subject: [PATCH v3 08/26] KVM: x86: Unexport LAPIC's switch_to_{hv,sw}_timer() helpers
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, Joerg Roedel <joro@8bytes.org>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        kvm@vger.kernel.org, iommu@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, Maxim Levitsky <mlevitsk@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Unexport switch_to_{hv,sw}_timer() now that common x86 handles the
transitions.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kvm/lapic.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 40270d7bc597..d4d875cbf05c 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -1947,7 +1947,6 @@ void kvm_lapic_switch_to_hv_timer(struct kvm_vcpu *vcpu)
 {
 	restart_apic_timer(vcpu->arch.apic);
 }
-EXPORT_SYMBOL_GPL(kvm_lapic_switch_to_hv_timer);
 
 void kvm_lapic_switch_to_sw_timer(struct kvm_vcpu *vcpu)
 {
@@ -1959,7 +1958,6 @@ void kvm_lapic_switch_to_sw_timer(struct kvm_vcpu *vcpu)
 		start_sw_timer(apic);
 	preempt_enable();
 }
-EXPORT_SYMBOL_GPL(kvm_lapic_switch_to_sw_timer);
 
 void kvm_lapic_restart_hv_timer(struct kvm_vcpu *vcpu)
 {
-- 
2.34.1.400.ga245620fadb-goog

