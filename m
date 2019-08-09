Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 725B287F4A
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2019 18:15:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437164AbfHIQPp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Aug 2019 12:15:45 -0400
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:53024 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2437126AbfHIQPH (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 9 Aug 2019 12:15:07 -0400
Received: from smtp.bitdefender.com (smtp02.buh.bitdefender.net [10.17.80.76])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id 728133031EC3;
        Fri,  9 Aug 2019 19:01:32 +0300 (EEST)
Received: from localhost.localdomain (unknown [89.136.169.210])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id 74CD0305B7A4;
        Fri,  9 Aug 2019 19:01:31 +0300 (EEST)
From:   =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
To:     kvm@vger.kernel.org
Cc:     linux-mm@kvack.org, virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Tamas K Lengyel <tamas@tklengyel.com>,
        Mathieu Tarral <mathieu.tarral@protonmail.com>,
        =?UTF-8?q?Samuel=20Laur=C3=A9n?= <samuel.lauren@iki.fi>,
        Patrick Colp <patrick.colp@oracle.com>,
        Jan Kiszka <jan.kiszka@siemens.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Weijiang Yang <weijiang.yang@intel.com>, Zhang@vger.kernel.org,
        Yu C <yu.c.zhang@intel.com>,
        =?UTF-8?q?Mihai=20Don=C8=9Bu?= <mdontu@bitdefender.com>,
        =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
Subject: [RFC PATCH v6 69/92] kvm: x86: keep the page protected if tracked by the introspection tool
Date:   Fri,  9 Aug 2019 19:00:24 +0300
Message-Id: <20190809160047.8319-70-alazar@bitdefender.com>
In-Reply-To: <20190809160047.8319-1-alazar@bitdefender.com>
References: <20190809160047.8319-1-alazar@bitdefender.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch might be obsolete thanks to single-stepping.

Signed-off-by: Adalbert Lazăr <alazar@bitdefender.com>
---
 arch/x86/kvm/x86.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 2c06de73a784..06f44ce8ed07 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -6311,7 +6311,8 @@ static bool reexecute_instruction(struct kvm_vcpu *vcpu, gva_t cr2,
 		indirect_shadow_pages = vcpu->kvm->arch.indirect_shadow_pages;
 		spin_unlock(&vcpu->kvm->mmu_lock);
 
-		if (indirect_shadow_pages)
+		if (indirect_shadow_pages
+		    && !kvmi_tracked_gfn(vcpu, gpa_to_gfn(gpa)))
 			kvm_mmu_unprotect_page(vcpu->kvm, gpa_to_gfn(gpa));
 
 		return true;
@@ -6322,7 +6323,8 @@ static bool reexecute_instruction(struct kvm_vcpu *vcpu, gva_t cr2,
 	 * and it failed try to unshadow page and re-enter the
 	 * guest to let CPU execute the instruction.
 	 */
-	kvm_mmu_unprotect_page(vcpu->kvm, gpa_to_gfn(gpa));
+	if (!kvmi_tracked_gfn(vcpu, gpa_to_gfn(gpa)))
+		kvm_mmu_unprotect_page(vcpu->kvm, gpa_to_gfn(gpa));
 
 	/*
 	 * If the access faults on its page table, it can not
@@ -6374,6 +6376,9 @@ static bool retry_instruction(struct x86_emulate_ctxt *ctxt,
 	if (!vcpu->arch.mmu->direct_map)
 		gpa = kvm_mmu_gva_to_gpa_write(vcpu, cr2, NULL);
 
+	if (kvmi_tracked_gfn(vcpu, gpa_to_gfn(gpa)))
+		return false;
+
 	kvm_mmu_unprotect_page(vcpu->kvm, gpa_to_gfn(gpa));
 
 	return true;
