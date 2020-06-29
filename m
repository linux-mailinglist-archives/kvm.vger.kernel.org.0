Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF20420E26E
	for <lists+kvm@lfdr.de>; Tue, 30 Jun 2020 00:00:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390105AbgF2VFP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 Jun 2020 17:05:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731102AbgF2TMo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 29 Jun 2020 15:12:44 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E02BEC008611;
        Mon, 29 Jun 2020 03:26:41 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id b16so7696154pfi.13;
        Mon, 29 Jun 2020 03:26:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=ZaXV5svWea/pmwM7hzMGgBPV83SPmfUEW0Ej1s60jmc=;
        b=iEytamTkwbkYbE5TzWpiBqob8St2uHARoRQkWmGEvGjGM/sM00TS1/InbzaCXu8Mb9
         40VNJ3jWWKf9OKd7Jxu+jPDaf0I+bUWkWe+NFnofOk6kt7cs7eYv0LuY6ddVGj1Lgs8X
         JG2Ts5p49DPgfZwCIS7Z6q877zeCpSInQkgsN7iBxHuxeqwkMmALV6JMnoJ7313+g6j1
         EEsZMBPM9CMTZ4ZnBeJMMIB1sojjIOsh3jHBRsHGRZH6Jlc3lhSnQtyrY8mYqQT8Vw/i
         pS8oP1mH7MtGwk+lm5R63oIERNZoYwRalDxKTq4VRYXpzkVpTsJl23SWnh+qA6gvORk6
         DmvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=ZaXV5svWea/pmwM7hzMGgBPV83SPmfUEW0Ej1s60jmc=;
        b=YOD2s1tDZd1e8se2Em8K28Wv3CeHAufN5LvTDWprQqKEpM6oko5Fvx4fqnM8CwsxSK
         ZGCgvDZxdIj65vF7inTib1OY4jYKlDUbOzWUsIx6VA0DM9G34sEcBU8Tnh81kWPrB19Y
         vzg9S+cp0+6zlV8uq8FUQnHEvZ3aBM1tEfjVQ5DKPNKtx66xkicrdNjboGM8aIYESnQ7
         ZeeMggq5ewf2QlqelWxaPNldSlUDe3Ueq5jjius1A5gOmT+ywL7W8F71CVn/L0oUnoUL
         wXWiubmQUyZyyuEC+VpomtSS62jayZX1FH8MD/chopQEX2pc5+2bBneoEAR019IIYg3Q
         gXkQ==
X-Gm-Message-State: AOAM532bpN27d3+joLNHUJikUMdpqWQnjoklrHn6KyLRUGtiSBzsQsGB
        YxrZg3Z+oXR1hC1hHrR/jrsyDDkg
X-Google-Smtp-Source: ABdhPJzcRu4J4/PMWF7WlwCJADHEUVQICiGl6R7X5TQXcMQk5fnwdXbNxuHGqxuZ6mGYS4Vh/B1oHg==
X-Received: by 2002:a63:5863:: with SMTP id i35mr7436682pgm.390.1593426401185;
        Mon, 29 Jun 2020 03:26:41 -0700 (PDT)
Received: from localhost.localdomain ([103.7.29.6])
        by smtp.googlemail.com with ESMTPSA id 22sm15400181pfx.94.2020.06.29.03.26.38
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 29 Jun 2020 03:26:40 -0700 (PDT)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: [PATCH] KVM: X86: Fix async pf caused null-ptr-deref
Date:   Mon, 29 Jun 2020 18:26:31 +0800
Message-Id: <1593426391-8231-1-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Wanpeng Li <wanpengli@tencent.com>

Syzbot reported that:

  CPU: 1 PID: 6780 Comm: syz-executor153 Not tainted 5.7.0-syzkaller #0
  Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
  RIP: 0010:__apic_accept_irq+0x46/0xb80
  Call Trace:
   kvm_arch_async_page_present+0x7de/0x9e0
   kvm_check_async_pf_completion+0x18d/0x400
   kvm_arch_vcpu_ioctl_run+0x18bf/0x69f0
   kvm_vcpu_ioctl+0x46a/0xe20
   ksys_ioctl+0x11a/0x180
   __x64_sys_ioctl+0x6f/0xb0
   do_syscall_64+0xf6/0x7d0
   entry_SYSCALL_64_after_hwframe+0x49/0xb3
 
The testcase enables APF mechanism in MSR_KVM_ASYNC_PF_EN with ASYNC_PF_INT 
enabled w/o setting MSR_KVM_ASYNC_PF_INT before, what's worse, interrupt 
based APF 'page ready' event delivery depends on in kernel lapic, however, 
we didn't bail out when lapic is not in kernel during guest setting 
MSR_KVM_ASYNC_PF_EN which causes the null-ptr-deref in host later. 
This patch fixes it.

Reported-by: syzbot+1bf777dfdde86d64b89b@syzkaller.appspotmail.com
Fixes: 2635b5c4a0 (KVM: x86: interrupt based APF 'page ready' event delivery)
Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
---
 arch/x86/kvm/x86.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 00c88c2..1c0b4f5 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2693,6 +2693,9 @@ static int kvm_pv_enable_async_pf(struct kvm_vcpu *vcpu, u64 data)
 	if (data & 0x30)
 		return 1;
 
+	if (!lapic_in_kernel(vcpu))
+		return 1;
+
 	vcpu->arch.apf.msr_en_val = data;
 
 	if (!kvm_pv_async_pf_enabled(vcpu)) {
-- 
2.7.4

