Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5DE348644A
	for <lists+kvm@lfdr.de>; Thu,  6 Jan 2022 13:21:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238780AbiAFMVE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Jan 2022 07:21:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238475AbiAFMVD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Jan 2022 07:21:03 -0500
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB473C061245;
        Thu,  6 Jan 2022 04:21:03 -0800 (PST)
Received: by mail-pg1-x534.google.com with SMTP id 200so2400336pgg.3;
        Thu, 06 Jan 2022 04:21:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id;
        bh=As/WjEKqZAy9F1nGpQ4wmkL2ydVFs9ke/kDtTsLl3ko=;
        b=fgfMaPlTT/8Blrv/OqQ/yZSJfsN0vxrYUY9J2/BGcF8fbAVz0doYCXy/sDKxBDhGSJ
         b1kk/JmEv3pW6qya4XIJ0eHfJAzvuRCNsf24LLSb+pVFJ4KoIrYtx5eNaO39a/HmB2yQ
         NRKAMMX390p00lskO6FFLUVKoqLXjK9jId7zdIp8XQV4rWtq3VX512L+jAGfrbkiE2H7
         UQA96Ezq22gYI1c7whHu/v52WCRJt/jhSRT335oElYFsoPZO70PQCv/tUW+2XsteLi8z
         iDL51bqZeN3y5JhGDYqC5TNzDbzlCfv8pNKZiRcADZiM7e1NqNtaxnIPZwxZlv9fkefc
         DoZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=As/WjEKqZAy9F1nGpQ4wmkL2ydVFs9ke/kDtTsLl3ko=;
        b=qrqBkgdJgxWabNyvyoVgHtwvCnb0XeZ5ADVfTNQHx1Fe6MBkYv7uhBxw3NFkNhBejm
         3+/wom4ZynZpRK1caAqvhywav2P2gsOn/AfWgBE9+U2uIP7P030emQjNOcHJCNKHySYB
         t6SCPnOTKa0mOu1vUd4+IJWeOlL24Ensj2l3LO3YumM+6oYO+YYqIulem2zL29LSfHTr
         DPslC52mewmh+MJCyKQ4D+cLfrwwnQs1iFeiw20Rsnyl9HYFgpsGPlBlTfxMnvmAJG5r
         Ctoip13zc74zWnEEx6yV8onerWEMNgHtJBSJOgqlFhCnqvmgSYAGAZmSwB0xA5b2yhOz
         K/Yw==
X-Gm-Message-State: AOAM532JWYQdPQSqL3M0uAeU4lp7W8MNIrXcGoPgUCyUE/7QBz3/e2a9
        YMF2dfFPWXPivd7E+dUPwTlMNGH4R3oKAA==
X-Google-Smtp-Source: ABdhPJwVewV3z8nurVP0GLH6N1Gf3aznKRES4C3kmjNaG8WzE/y43HvRgUrHdLmwP/0sx4lECsG8MQ==
X-Received: by 2002:a63:6687:: with SMTP id a129mr51265949pgc.477.1641471662936;
        Thu, 06 Jan 2022 04:21:02 -0800 (PST)
Received: from localhost.localdomain ([203.205.141.111])
        by smtp.googlemail.com with ESMTPSA id my5sm2859974pjb.5.2022.01.06.04.21.00
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 06 Jan 2022 04:21:02 -0800 (PST)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, Aili Yao <yaoaili@kingsoft.com>
Subject: [PATCH v2] KVM: LAPIC: Enable timer posted-interrupt when mwait/hlt is advertised
Date:   Thu,  6 Jan 2022 04:20:12 -0800
Message-Id: <1641471612-34483-1-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Wanpeng Li <wanpengli@tencent.com>

As commit 0c5f81dad46 (KVM: LAPIC: Inject timer interrupt via posted interrupt) 
mentioned that the host admin should well tune the guest setup, so that vCPUs 
are placed on isolated pCPUs, and with several pCPUs surplus for *busy* housekeeping.
It is better to disable mwait/hlt/pause vmexits to keep the vCPUs in non-root 
mode. However, we may isolate pCPUs for other purpose like DPDK or we can make 
some guests isolated and others not, we may lose vmx preemption timer/timer fastpath 
due to not well tuned setup, and the checking in kvm_can_post_timer_interrupt() 
is not enough. Let's guarantee mwait/hlt is advertised before enabling posted-interrupt 
interrupt. vmx preemption timer/timer fastpath can continue to work if both of them 
are not advertised.

Reported-by: Aili Yao <yaoaili@kingsoft.com>
Cc: Aili Yao <yaoaili@kingsoft.com>
Cc: Sean Christopherson <seanjc@google.com>
Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
---
v1 -> v2:
 * also check kvm_hlt_in_guest since sometime mwait is disabled on host

 arch/x86/kvm/lapic.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index f206fc3..fdb7c81 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -113,7 +113,8 @@ static inline u32 kvm_x2apic_id(struct kvm_lapic *apic)
 
 static bool kvm_can_post_timer_interrupt(struct kvm_vcpu *vcpu)
 {
-	return pi_inject_timer && kvm_vcpu_apicv_active(vcpu);
+	return pi_inject_timer && kvm_vcpu_apicv_active(vcpu) &&
+		(kvm_mwait_in_guest(vcpu->kvm) || kvm_hlt_in_guest(vcpu->kvm));
 }
 
 bool kvm_can_use_hv_timer(struct kvm_vcpu *vcpu)
-- 
2.7.4

