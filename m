Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3320C203A71
	for <lists+kvm@lfdr.de>; Mon, 22 Jun 2020 17:14:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729296AbgFVPOr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Jun 2020 11:14:47 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:51864 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729199AbgFVPOq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Jun 2020 11:14:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592838885;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=NIQCA5ZckTuLuocOtdMBGLUU2Sj+VfxVeRxU4kvLvWg=;
        b=PndyeTcrL8jquNZf4pLLLz3+hxIW6+xKHp7LjOtmNl+LFIASh1SGH+VWnb+cKKa/xDJypT
        b/6w1KVbtiMVQFPnkzsIxGrqEhENIjY63sIcR4qdiwiFB1q0BPNZzbo66QSB5tyhxmzZei
        UOKjKnP6JgHnO3p6dRYRmaKLfozGKjQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-19-9ya5N6rCP0iHAeJJWgqevw-1; Mon, 22 Jun 2020 11:14:40 -0400
X-MC-Unique: 9ya5N6rCP0iHAeJJWgqevw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E5F3C107ACF6;
        Mon, 22 Jun 2020 15:14:38 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.195.104])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2551B60BE2;
        Mon, 22 Jun 2020 15:14:36 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] KVM: x86/mmu: Avoid mixing gpa_t with gfn_t in walk_addr_generic()
Date:   Mon, 22 Jun 2020 17:14:35 +0200
Message-Id: <20200622151435.752560-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

translate_gpa() returns a GPA, assigning it to 'real_gfn' seems obviously
wrong. There is no real issue because both 'gpa_t' and 'gfn_t' are u64 and
we don't use the value in 'real_gfn' as a GFN, we do

 real_gfn = gpa_to_gfn(real_gfn);

instead. 'If you see a "buffalo" sign on an elephant's cage, do not trust
your eyes', but let's fix it for good.

No functional change intended.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/kvm/mmu/paging_tmpl.h | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index a6d484ea110b..58234bfaca07 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -360,7 +360,6 @@ static int FNAME(walk_addr_generic)(struct guest_walker *walker,
 	++walker->level;
 
 	do {
-		gfn_t real_gfn;
 		unsigned long host_addr;
 
 		pt_access = pte_access;
@@ -375,7 +374,7 @@ static int FNAME(walk_addr_generic)(struct guest_walker *walker,
 		walker->table_gfn[walker->level - 1] = table_gfn;
 		walker->pte_gpa[walker->level - 1] = pte_gpa;
 
-		real_gfn = mmu->translate_gpa(vcpu, gfn_to_gpa(table_gfn),
+		real_gpa = mmu->translate_gpa(vcpu, gfn_to_gpa(table_gfn),
 					      nested_access,
 					      &walker->fault);
 
@@ -389,12 +388,10 @@ static int FNAME(walk_addr_generic)(struct guest_walker *walker,
 		 * information to fix the exit_qualification or exit_info_1
 		 * fields.
 		 */
-		if (unlikely(real_gfn == UNMAPPED_GVA))
+		if (unlikely(real_gpa == UNMAPPED_GVA))
 			return 0;
 
-		real_gfn = gpa_to_gfn(real_gfn);
-
-		host_addr = kvm_vcpu_gfn_to_hva_prot(vcpu, real_gfn,
+		host_addr = kvm_vcpu_gfn_to_hva_prot(vcpu, gpa_to_gfn(real_gpa),
 					    &walker->pte_writable[walker->level - 1]);
 		if (unlikely(kvm_is_error_hva(host_addr)))
 			goto error;
-- 
2.25.4

