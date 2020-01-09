Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AF7E313639C
	for <lists+kvm@lfdr.de>; Fri, 10 Jan 2020 00:06:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729305AbgAIXGr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Jan 2020 18:06:47 -0500
Received: from mga11.intel.com ([192.55.52.93]:54670 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728866AbgAIXGl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Jan 2020 18:06:41 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 09 Jan 2020 15:06:41 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,414,1571727600"; 
   d="scan'208";a="396242474"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by orsmga005.jf.intel.com with ESMTP; 09 Jan 2020 15:06:41 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        David Laight <David.Laight@ACULAB.COM>,
        Arvind Sankar <nivedita@alum.mit.edu>
Subject: [PATCH v2 1/2] KVM: x86/mmu: Reorder the reserved bit check in prefetch_invalid_gpte()
Date:   Thu,  9 Jan 2020 15:06:39 -0800
Message-Id: <20200109230640.29927-2-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200109230640.29927-1-sean.j.christopherson@intel.com>
References: <20200109230640.29927-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Move the !PRESENT and !ACCESSED checks in FNAME(prefetch_invalid_gpte)
above the call to is_rsvd_bits_set().  For a well behaved guest, the
!PRESENT and !ACCESSED are far more likely to evaluate true than the
reserved bit checks, and they do not require additional memory accesses.

Before:
 Dump of assembler code for function paging32_prefetch_invalid_gpte:
   0x0000000000044240 <+0>:     callq  0x44245 <paging32_prefetch_invalid_gpte+5>
   0x0000000000044245 <+5>:     mov    %rcx,%rax
   0x0000000000044248 <+8>:     shr    $0x7,%rax
   0x000000000004424c <+12>:    and    $0x1,%eax
   0x000000000004424f <+15>:    lea    0x0(,%rax,4),%r8
   0x0000000000044257 <+23>:    add    %r8,%rax
   0x000000000004425a <+26>:    mov    %rcx,%r8
   0x000000000004425d <+29>:    and    0x120(%rsi,%rax,8),%r8
   0x0000000000044265 <+37>:    mov    0x170(%rsi),%rax
   0x000000000004426c <+44>:    shr    %cl,%rax
   0x000000000004426f <+47>:    and    $0x1,%eax
   0x0000000000044272 <+50>:    or     %rax,%r8
   0x0000000000044275 <+53>:    jne    0x4427c <paging32_prefetch_invalid_gpte+60>
   0x0000000000044277 <+55>:    test   $0x1,%cl
   0x000000000004427a <+58>:    jne    0x4428a <paging32_prefetch_invalid_gpte+74>
   0x000000000004427c <+60>:    mov    %rdx,%rsi
   0x000000000004427f <+63>:    callq  0x44080 <drop_spte>
   0x0000000000044284 <+68>:    mov    $0x1,%eax
   0x0000000000044289 <+73>:    retq
   0x000000000004428a <+74>:    xor    %eax,%eax
   0x000000000004428c <+76>:    and    $0x20,%ecx
   0x000000000004428f <+79>:    jne    0x44289 <paging32_prefetch_invalid_gpte+73>
   0x0000000000044291 <+81>:    mov    %rdx,%rsi
   0x0000000000044294 <+84>:    callq  0x44080 <drop_spte>
   0x0000000000044299 <+89>:    mov    $0x1,%eax
   0x000000000004429e <+94>:    jmp    0x44289 <paging32_prefetch_invalid_gpte+73>
 End of assembler dump.

After:
 Dump of assembler code for function paging32_prefetch_invalid_gpte:
   0x0000000000044240 <+0>:     callq  0x44245 <paging32_prefetch_invalid_gpte+5>
   0x0000000000044245 <+5>:     test   $0x1,%cl
   0x0000000000044248 <+8>:     je     0x4424f <paging32_prefetch_invalid_gpte+15>
   0x000000000004424a <+10>:    test   $0x20,%cl
   0x000000000004424d <+13>:    jne    0x4425d <paging32_prefetch_invalid_gpte+29>
   0x000000000004424f <+15>:    mov    %rdx,%rsi
   0x0000000000044252 <+18>:    callq  0x44080 <drop_spte>
   0x0000000000044257 <+23>:    mov    $0x1,%eax
   0x000000000004425c <+28>:    retq
   0x000000000004425d <+29>:    mov    %rcx,%rax
   0x0000000000044260 <+32>:    mov    (%rsi),%rsi
   0x0000000000044263 <+35>:    shr    $0x7,%rax
   0x0000000000044267 <+39>:    and    $0x1,%eax
   0x000000000004426a <+42>:    lea    0x0(,%rax,4),%r8
   0x0000000000044272 <+50>:    add    %r8,%rax
   0x0000000000044275 <+53>:    mov    %rcx,%r8
   0x0000000000044278 <+56>:    and    0x120(%rsi,%rax,8),%r8
   0x0000000000044280 <+64>:    mov    0x170(%rsi),%rax
   0x0000000000044287 <+71>:    shr    %cl,%rax
   0x000000000004428a <+74>:    and    $0x1,%eax
   0x000000000004428d <+77>:    mov    %rax,%rcx
   0x0000000000044290 <+80>:    xor    %eax,%eax
   0x0000000000044292 <+82>:    or     %rcx,%r8
   0x0000000000044295 <+85>:    je     0x4425c <paging32_prefetch_invalid_gpte+28>
   0x0000000000044297 <+87>:    mov    %rdx,%rsi
   0x000000000004429a <+90>:    callq  0x44080 <drop_spte>
   0x000000000004429f <+95>:    mov    $0x1,%eax
   0x00000000000442a4 <+100>:   jmp    0x4425c <paging32_prefetch_invalid_gpte+28>
 End of assembler dump.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/mmu/paging_tmpl.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index b53bed3c901c..1fde6a1c506d 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -175,9 +175,6 @@ static bool FNAME(prefetch_invalid_gpte)(struct kvm_vcpu *vcpu,
 				  struct kvm_mmu_page *sp, u64 *spte,
 				  u64 gpte)
 {
-	if (is_rsvd_bits_set(vcpu->arch.mmu, gpte, PT_PAGE_TABLE_LEVEL))
-		goto no_present;
-
 	if (!FNAME(is_present_gpte)(gpte))
 		goto no_present;
 
@@ -186,6 +183,9 @@ static bool FNAME(prefetch_invalid_gpte)(struct kvm_vcpu *vcpu,
 	    !(gpte & PT_GUEST_ACCESSED_MASK))
 		goto no_present;
 
+	if (is_rsvd_bits_set(vcpu->arch.mmu, gpte, PT_PAGE_TABLE_LEVEL))
+		goto no_present;
+
 	return false;
 
 no_present:
-- 
2.24.1

