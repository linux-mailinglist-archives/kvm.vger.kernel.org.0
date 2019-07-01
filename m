Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D4B7FFEE1
	for <lists+kvm@lfdr.de>; Tue, 30 Apr 2019 19:33:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726102AbfD3Rdb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Apr 2019 13:33:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52750 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725930AbfD3Rdb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Apr 2019 13:33:31 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 01AFC3087945;
        Tue, 30 Apr 2019 17:33:31 +0000 (UTC)
Received: from vitty.brq.redhat.com (ovpn-204-104.brq.redhat.com [10.40.204.104])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 69A8662926;
        Tue, 30 Apr 2019 17:33:29 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [PATCH] x86/kvm/mmu: reset MMU context when 32-bit guest switches PAE
Date:   Tue, 30 Apr 2019 19:33:26 +0200
Message-Id: <20190430173326.1956-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.45]); Tue, 30 Apr 2019 17:33:31 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Commit 47c42e6b4192 ("KVM: x86: fix handling of role.cr4_pae and rename it
to 'gpte_size'") introduced a regression: 32-bit PAE guests stopped
working. The issue appears to be: when guest switches (enables) PAE we need
to re-initialize MMU context (set context->root_level, do
reset_rsvds_bits_mask(), ...) but init_kvm_tdp_mmu() doesn't do that
because we threw away is_pae(vcpu) flag from mmu role. Restore it to
kvm_mmu_extended_role (as we now don't need it in base role) to fix
the issue.

Fixes: 47c42e6b4192 ("KVM: x86: fix handling of role.cr4_pae and rename it to 'gpte_size'")
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
- RFC: it was proven multiple times that mmu code is more complex than it
  appears (at least to me) :-)
---
 arch/x86/include/asm/kvm_host.h | 1 +
 arch/x86/kvm/mmu.c              | 1 +
 2 files changed, 2 insertions(+)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index a9d03af34030..c79abe7ca093 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -295,6 +295,7 @@ union kvm_mmu_extended_role {
 		unsigned int valid:1;
 		unsigned int execonly:1;
 		unsigned int cr0_pg:1;
+		unsigned int cr4_pae:1;
 		unsigned int cr4_pse:1;
 		unsigned int cr4_pke:1;
 		unsigned int cr4_smap:1;
diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index e10962dfc203..d9c7b45d231f 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -4781,6 +4781,7 @@ static union kvm_mmu_extended_role kvm_calc_mmu_role_ext(struct kvm_vcpu *vcpu)
 	union kvm_mmu_extended_role ext = {0};
 
 	ext.cr0_pg = !!is_paging(vcpu);
+	ext.cr4_pae = !!is_pae(vcpu);
 	ext.cr4_smep = !!kvm_read_cr4_bits(vcpu, X86_CR4_SMEP);
 	ext.cr4_smap = !!kvm_read_cr4_bits(vcpu, X86_CR4_SMAP);
 	ext.cr4_pse = !!is_pse(vcpu);
-- 
2.20.1

