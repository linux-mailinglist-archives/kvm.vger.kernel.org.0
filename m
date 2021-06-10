Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B41593A36C0
	for <lists+kvm@lfdr.de>; Fri, 11 Jun 2021 00:00:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230169AbhFJWC2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Jun 2021 18:02:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229941AbhFJWC1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Jun 2021 18:02:27 -0400
Received: from mail-qt1-x84a.google.com (mail-qt1-x84a.google.com [IPv6:2607:f8b0:4864:20::84a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 353E4C061574
        for <kvm@vger.kernel.org>; Thu, 10 Jun 2021 15:00:31 -0700 (PDT)
Received: by mail-qt1-x84a.google.com with SMTP id q6-20020a05622a04c6b0290247f5436033so756483qtx.5
        for <kvm@vger.kernel.org>; Thu, 10 Jun 2021 15:00:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:message-id:mime-version:subject:from:to:cc;
        bh=fTHDCTOCzh3+8vlgdKlO2bk/FzpOiX702RoIRhgDioU=;
        b=Rhx6iMKttAorqypz04NWFeorw+YWh/kRgjPm92dJG1CdaSELTx9NJuondiaS4ziEKx
         qSda2osGmw/cXyoRkGaFVZ/QUEQEBvYZmEm738Z4KFmE/JydJVH8bXNBGlSutn3dEjTR
         3TpqqXPC9RVXlS/5f2NVYd0ZB9Qiy6RSu1Y1hXE4r/DjJAYqfSV3K2BtmQSfqxlhiDs4
         5CFcetIIEg3XsWiqu6e0o2FePtEDtDzEpKgmZEF/9+XzEr33VaUXR48kUDm8/8bW1fJZ
         1kihSjwuEQTvC0udWXTDNceuKRsKBF/iWA+XfKHryi7VDtqiYQuo6sldjyiEY9bGRcIS
         VEEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:message-id:mime-version:subject
         :from:to:cc;
        bh=fTHDCTOCzh3+8vlgdKlO2bk/FzpOiX702RoIRhgDioU=;
        b=YvtRGY/24ZzpCXKd9jwhzXgiQpp9ZdE5XAfJBvGy5nbtzS8kEbpC9rZDIXU+AFCmir
         IfDHycms9c69eSVRxcIXYSR4bXcSu6E5h3i2CneY8XPiL7gr2NpGOreHptLvqH46o2Y8
         kj6GFN1huLaL5rtfVlqwi+lZ87mLDR0weDDYbV5q6g2V5A0A2MzznXVU/NBcDN0MlRWa
         0TkQMTUsvE0CE0nKn9IayipXmw0q0w1nCNYFQU1TH8Ukx4ThCtJKgZsCBAf6BXhDCr5t
         2xc2UHlARa0QB+HUaxZM7oXHAKcQ9vJ7hBXc18qdHQFA/k2Ly2p/+x9Yd6JPHldal0SP
         giZw==
X-Gm-Message-State: AOAM531tRvYMqlYo6NEiikBcuL9jr/oMDzXMZ6jSrv2Q05028fee3mmz
        nBZr0ljRsZkJwuIKoVDCjl02coaScgE=
X-Google-Smtp-Source: ABdhPJzZdcpeczUBEKhHH7eLgrtq0E/FrXF8OfzUeDcWd/qy/HeZhzo1/0qq57KS03Yv6k9+wKtIIaGESWE=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:e1b6:674d:effd:6798])
 (user=seanjc job=sendgmr) by 2002:a0c:c709:: with SMTP id w9mr1801446qvi.37.1623362430127;
 Thu, 10 Jun 2021 15:00:30 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu, 10 Jun 2021 15:00:26 -0700
Message-Id: <20210610220026.1364486-1-seanjc@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.32.0.272.g935e593368-goog
Subject: [PATCH] KVM: x86/mmu: Calculate and check "full" mmu_role for nested MMU
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

Calculate and check the full mmu_role when initializing the MMU context
for the nested MMU, where "full" means the bits and pieces of the role
that aren't handled by kvm_calc_mmu_role_common().  While the nested MMU
isn't used for shadow paging, things like the number of levels in the
guest's page tables are surprisingly important when walking the guest
page tables.  Failure to reinitialize the nested MMU context if L2's
paging mode changes can result in unexpected and/or missed page faults,
and likely other explosions.

E.g. if an L1 vCPU is running both a 32-bit PAE L2 and a 64-bit L2, the
"common" role calculation will yield the same role for both L2s.  If the
64-bit L2 is run after the 32-bit PAE L2, L0 will fail to reinitialize
the nested MMU context, ultimately resulting in a bad walk of L2's page
tables as the MMU will still have a guest root_level of PT32E_ROOT_LEVEL.

  WARNING: CPU: 4 PID: 167334 at arch/x86/kvm/vmx/vmx.c:3075 ept_save_pdptrs+0x15/0xe0 [kvm_intel]
  Modules linked in: kvm_intel]
  CPU: 4 PID: 167334 Comm: CPU 3/KVM Not tainted 5.13.0-rc1-d849817d5673-reqs #185
  Hardware name: ASUS Q87M-E/Q87M-E, BIOS 1102 03/03/2014
  RIP: 0010:ept_save_pdptrs+0x15/0xe0 [kvm_intel]
  Code: <0f> 0b c3 f6 87 d8 02 00f
  RSP: 0018:ffffbba702dbba00 EFLAGS: 00010202
  RAX: 0000000000000011 RBX: 0000000000000002 RCX: ffffffff810a2c08
  RDX: ffff91d7bc30acc0 RSI: 0000000000000011 RDI: ffff91d7bc30a600
  RBP: ffff91d7bc30a600 R08: 0000000000000010 R09: 0000000000000007
  R10: 0000000000000000 R11: 0000000000000000 R12: ffff91d7bc30a600
  R13: ffff91d7bc30acc0 R14: ffff91d67c123460 R15: 0000000115d7e005
  FS:  00007fe8e9ffb700(0000) GS:ffff91d90fb00000(0000) knlGS:0000000000000000
  CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
  CR2: 0000000000000000 CR3: 000000029f15a001 CR4: 00000000001726e0
  Call Trace:
   kvm_pdptr_read+0x3a/0x40 [kvm]
   paging64_walk_addr_generic+0x327/0x6a0 [kvm]
   paging64_gva_to_gpa_nested+0x3f/0xb0 [kvm]
   kvm_fetch_guest_virt+0x4c/0xb0 [kvm]
   __do_insn_fetch_bytes+0x11a/0x1f0 [kvm]
   x86_decode_insn+0x787/0x1490 [kvm]
   x86_decode_emulated_instruction+0x58/0x1e0 [kvm]
   x86_emulate_instruction+0x122/0x4f0 [kvm]
   vmx_handle_exit+0x120/0x660 [kvm_intel]
   kvm_arch_vcpu_ioctl_run+0xe25/0x1cb0 [kvm]
   kvm_vcpu_ioctl+0x211/0x5a0 [kvm]
   __x64_sys_ioctl+0x83/0xb0
   do_syscall_64+0x40/0xb0
   entry_SYSCALL_64_after_hwframe+0x44/0xae

Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: stable@vger.kernel.org
Fixes: bf627a928837 ("x86/kvm/mmu: check if MMU reconfiguration is needed in init_kvm_nested_mmu()")
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 26 +++++++++++++++++++++++++-
 1 file changed, 25 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 0144c40d09c7..8d5876dfc6b7 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4739,9 +4739,33 @@ static void init_kvm_softmmu(struct kvm_vcpu *vcpu)
 	context->inject_page_fault = kvm_inject_page_fault;
 }
 
+static union kvm_mmu_role kvm_calc_nested_mmu_role(struct kvm_vcpu *vcpu)
+{
+	union kvm_mmu_role role = kvm_calc_shadow_root_page_role_common(vcpu, false);
+
+	/*
+	 * Nested MMUs are used only for walking L2's gva->gpa, they never have
+	 * shadow pages of their own and so "direct" has no meaning.   Set it
+	 * to "true" to try to detect bogus usage of the nested MMU.
+	 */
+	role.base.direct = true;
+
+	if (!is_paging(vcpu))
+		role.base.level = 0;
+	else if (is_long_mode(vcpu))
+		role.base.level = is_la57_mode(vcpu) ? PT64_ROOT_5LEVEL :
+						       PT64_ROOT_4LEVEL;
+	else if (is_pae(vcpu))
+		role.base.level = PT32E_ROOT_LEVEL;
+	else
+		role.base.level = PT32_ROOT_LEVEL;
+
+	return role;
+}
+
 static void init_kvm_nested_mmu(struct kvm_vcpu *vcpu)
 {
-	union kvm_mmu_role new_role = kvm_calc_mmu_role_common(vcpu, false);
+	union kvm_mmu_role new_role = kvm_calc_nested_mmu_role(vcpu);
 	struct kvm_mmu *g_context = &vcpu->arch.nested_mmu;
 
 	if (new_role.as_u64 == g_context->mmu_role.as_u64)
-- 
2.32.0.272.g935e593368-goog

