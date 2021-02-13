Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF9BC31A948
	for <lists+kvm@lfdr.de>; Sat, 13 Feb 2021 02:09:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232338AbhBMBHI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Feb 2021 20:07:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232242AbhBMBGv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 Feb 2021 20:06:51 -0500
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FC09C0617A9
        for <kvm@vger.kernel.org>; Fri, 12 Feb 2021 17:05:42 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id 11so1566414ybl.21
        for <kvm@vger.kernel.org>; Fri, 12 Feb 2021 17:05:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=3xHEuJTQ8VLRaUFklswJjFu0PeXqCwd63ebUwadXbKc=;
        b=EVeU7iVBUs5OZCWOqhc8sKWFTxPAeC9DRuEOUGY1jV014ehcyPoLiTq8xzzfMtNFoA
         NATJifNRk4owfCjJHNWGHFygbK6Idcga74AzDNDVwyfiQp2B7Wu6BIZArhBUCeO9D4ct
         RDb0IopIymEdhJeUnEE8X5PlUVBwa7aQJwjzgGkgj5VwsDPQG9MXmlHkMnkqa+V54eP/
         tUiVrPGiplFWiUYkFfvzMYG4kwsu6EIMqsQxU6xnoPIB6cg0ATlnpOfO+8WfeMfFr5bG
         ukNfDDv2zScXa+qnp2IiyTJK7DIZqYTInPyfsyIxqNxYYO4d+BP9LAnbC99DON6cOVGO
         ETxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=3xHEuJTQ8VLRaUFklswJjFu0PeXqCwd63ebUwadXbKc=;
        b=j2O0mJkFV9lg2sO924raNKwe8QX3dBULfRrm6KOaSgvZdz0ad1wuaqGckOcwSut6wR
         hGBe5xvarkXmhqaBr3oxqAMoqz5K1uaAsfB8XPQu3NfMOL9YpbEshZeKL3yxN8O568yp
         mEVmy1qsCKq4AjMRZFpR3EyReYxHuBTFUcsnT4yS0b2bWObG3uIWx+csAkIr535+4hGd
         9TkKpGE2mTyxKjssd1skmIIKe4APyTg8mqiOf7vU9I2QDNjNClEpA0cUKsGtTwrXpMWL
         Nz62UrpM+ErPqX+t9ihk6m0QTEJ/VRX/IL9jivaSHpKxxAEwmFBM23BRW6yb/QoNAA+s
         xrRw==
X-Gm-Message-State: AOAM531yTcnXNSYBiDHc3b1PjCGWe0S90K6IgJyA82bJgnWYifx/gDKT
        uK7vKrCAH0O/uVanb8LFC0knWMrh13g=
X-Google-Smtp-Source: ABdhPJyy5TPJAO2Y7pIDCH20WbQR26WzIdg1RrpGoRQoBMnvsrTMuS9QUQNA7Uk6QdtC8C7Ja8FoF87zq4s=
Sender: "seanjc via sendgmr" <seanjc@seanjc798194.pdx.corp.google.com>
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:b407:1780:13d2:b27])
 (user=seanjc job=sendgmr) by 2002:a05:6902:6af:: with SMTP id
 j15mr8196259ybt.229.1613178341828; Fri, 12 Feb 2021 17:05:41 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 12 Feb 2021 17:05:15 -0800
In-Reply-To: <20210213010518.1682691-1-seanjc@google.com>
Message-Id: <20210213010518.1682691-7-seanjc@google.com>
Mime-Version: 1.0
References: <20210213010518.1682691-1-seanjc@google.com>
X-Mailer: git-send-email 2.30.0.478.g8a0d178c01-goog
Subject: [PATCH 6/9] KVM: nVMX: Truncate base/index GPR value on address calc
 in !64-bit
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Babu Moger <babu.moger@amd.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        David Woodhouse <dwmw@amazon.co.uk>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Drop bits 63:32 of the base and/or index GPRs when calculating the
effective address of a VMX instruction memory operand.  Outside of 64-bit
mode, memory encodings are strictly limited to E*X and below.

Fixes: 064aea774768 ("KVM: nVMX: Decoding memory operands of VMX instructions")
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/nested.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index d6c892ea551c..a02d8744ca66 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -4601,9 +4601,9 @@ int get_vmx_mem_address(struct kvm_vcpu *vcpu, unsigned long exit_qualification,
 	else if (addr_size == 0)
 		off = (gva_t)sign_extend64(off, 15);
 	if (base_is_valid)
-		off += kvm_register_read(vcpu, base_reg);
+		off += kvm_register_readl(vcpu, base_reg);
 	if (index_is_valid)
-		off += kvm_register_read(vcpu, index_reg) << scaling;
+		off += kvm_register_readl(vcpu, index_reg) << scaling;
 	vmx_get_segment(vcpu, &s, seg_reg);
 
 	/*
-- 
2.30.0.478.g8a0d178c01-goog

