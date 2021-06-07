Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F5BF39D5DF
	for <lists+kvm@lfdr.de>; Mon,  7 Jun 2021 09:22:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230251AbhFGHXs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Jun 2021 03:23:48 -0400
Received: from mail-pl1-f175.google.com ([209.85.214.175]:45929 "EHLO
        mail-pl1-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230241AbhFGHXr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Jun 2021 03:23:47 -0400
Received: by mail-pl1-f175.google.com with SMTP id 11so8118811plk.12;
        Mon, 07 Jun 2021 00:21:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=JlYRWlvh6yimKDHghpsT5yQcW80e6PQ1qpgXZSEcu00=;
        b=SuMgAOHZp76X857sJzJcNiqw/cdz/fnKJzIepU6ZLQ+95HLwH2mw+pgKNabPqUd1F9
         uTfbIznknW6JhnPxC1AWwOO1H/pNm3/2xayiWPKKegAXEpDpN7c8voyGKaUcYmcOVDa9
         bHPQCJPslQkqNvKfwyLGVHndtetoUtlewlY95Z81A62NcKhzesWXvAQImnqr2ibU3aOQ
         oe63rn9XDaPCGvBTU2Pv9geQrDgaRZfZJiDK93iIiFQo8KxocsajevbdpmCsRxKR6N+c
         H9aV8M2Ag6eK/bq49ECvAVR9xvrt/j1JSkk2TSAxQdTa06B9SWyTdiMaOdtKm138GOa8
         lSxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=JlYRWlvh6yimKDHghpsT5yQcW80e6PQ1qpgXZSEcu00=;
        b=oojvVQgiEV4i06kEixxnQrLxt0k9ZS+GxCs/2wIghbhU6i7t2wINS9fKAT/f2A/ZBW
         y9PjmClsqN4KLKD8RG/L3Ox7ISKcYjmu7jTtnZ46fGhTWZE8PWu8yzEIUKh8nCKh3Qk6
         5ISihnWYhXJh7ilODGmDPJ6JsMikzB9xt7MTzbdf/DYtdUmz5fIkiONTN2LxXeMC3SCU
         1dDTkPiemmSZ7gVZhSsaXMGNSVgChdl23wohPPkkVvCESdp1rMhNQPis3J8H3Ud0Ndu3
         FP96F7gEGxzajDDhI4DpK7ug0KCNFWXFueSeZIxIZKexjB/HME+MCDLmmHzzC300nngf
         yD/A==
X-Gm-Message-State: AOAM530DLVgMmOyjjwZMkd82VIu9aqP16PBQA8J1ovTmVQvLVT+4s3oe
        53DBLZZu/ziIi5iAihCWD4tPbazac0k=
X-Google-Smtp-Source: ABdhPJwOi+0Czpk9oqjZ4RSqN0WhlFSW4KTQxw8WwDA3Rkxf4IhmuPlZar+Bzs1iKEbvGMBR4YSEhQ==
X-Received: by 2002:a17:90b:4ad2:: with SMTP id mh18mr18317159pjb.148.1623050440048;
        Mon, 07 Jun 2021 00:20:40 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.61])
        by smtp.googlemail.com with ESMTPSA id f3sm10797137pjo.3.2021.06.07.00.20.37
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 07 Jun 2021 00:20:39 -0700 (PDT)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: [PATCH v2 2/3] KVM: LAPIC: Reset TMCCT during vCPU reset
Date:   Mon,  7 Jun 2021 00:19:44 -0700
Message-Id: <1623050385-100988-2-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1623050385-100988-1-git-send-email-wanpengli@tencent.com>
References: <1623050385-100988-1-git-send-email-wanpengli@tencent.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Wanpeng Li <wanpengli@tencent.com>

The value of the current counter register after reset is 0 for both 
Intel and AMD, let's do it in kvm, though, the TMCCT is always computed
on-demand and never directly readable.

Reviewed-by: Jim Mattson <jmattson@google.com>
Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
---
v1 -> v2:
 * update patch description

 arch/x86/kvm/lapic.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 6d72d8f..cbfdecd 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -2352,6 +2352,7 @@ void kvm_lapic_reset(struct kvm_vcpu *vcpu, bool init_event)
 	kvm_lapic_set_reg(apic, APIC_ICR2, 0);
 	kvm_lapic_set_reg(apic, APIC_TDCR, 0);
 	kvm_lapic_set_reg(apic, APIC_TMICT, 0);
+	kvm_lapic_set_reg(apic, APIC_TMCCT, 0);
 	for (i = 0; i < 8; i++) {
 		kvm_lapic_set_reg(apic, APIC_IRR + 0x10 * i, 0);
 		kvm_lapic_set_reg(apic, APIC_ISR + 0x10 * i, 0);
-- 
2.7.4

