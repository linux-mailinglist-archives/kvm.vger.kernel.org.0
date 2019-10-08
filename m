Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BDA97CFCF1
	for <lists+kvm@lfdr.de>; Tue,  8 Oct 2019 16:57:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727695AbfJHO5U (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Oct 2019 10:57:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55290 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725939AbfJHO5U (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Oct 2019 10:57:20 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id CC763300C22E;
        Tue,  8 Oct 2019 14:57:19 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.43.2.155])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7B4C419C69;
        Tue,  8 Oct 2019 14:57:18 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Jim Mattson <jmattson@google.com>
Subject: [PATCH RFC] selftests: kvm: fix sync_regs_test with newer gccs
Date:   Tue,  8 Oct 2019 16:57:17 +0200
Message-Id: <20191008145717.17841-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.47]); Tue, 08 Oct 2019 14:57:19 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Commit 204c91eff798a ("KVM: selftests: do not blindly clobber registers in
 guest asm") was intended to make test more gcc-proof, however, the result
is exactly the opposite: on newer gccs (e.g. 8.2.1)  the test breaks with

==== Test Assertion Failure ====
  x86_64/sync_regs_test.c:168: run->s.regs.regs.rbx == 0xBAD1DEA + 1
  pid=14170 tid=14170 - Invalid argument
     1	0x00000000004015b3: main at sync_regs_test.c:166 (discriminator 6)
     2	0x00007f413fb66412: ?? ??:0
     3	0x000000000040191d: _start at ??:?
  rbx sync regs value incorrect 0x1.

Disassembly show the following:

00000000004019e0 <guest_code>:
  4019e0:       55                      push   %rbp
  4019e1:       89 dd                   mov    %ebx,%ebp
  4019e3:       53                      push   %rbx
  4019e4:       48 83 ec 08             sub    $0x8,%rsp
  4019e8:       0f 1f 84 00 00 00 00    nopl   0x0(%rax,%rax,1)
  4019ef:       00
  4019f0:       31 c9                   xor    %ecx,%ecx
  4019f2:       ba 10 90 40 00          mov    $0x409010,%edx
  4019f7:       be 02 00 00 00          mov    $0x2,%esi
  4019fc:       31 c0                   xor    %eax,%eax
  4019fe:       bf 01 00 00 00          mov    $0x1,%edi
  401a03:       83 c5 01                add    $0x1,%ebp
  401a06:       e8 15 2b 00 00          callq  404520 <ucall>
  401a0b:       89 eb                   mov    %ebp,%ebx
  401a0d:       eb e1                   jmp    4019f0 <guest_code+0x10>
  401a0f:       90                      nop

and apparently this is broken. If we add 'volatile' qualifier to 'stage'
we get the following code:

00000000004019e0 <guest_code>:
  4019e0:       53                      push   %rbx
  4019e1:       0f 1f 80 00 00 00 00    nopl   0x0(%rax)
  4019e8:       31 c9                   xor    %ecx,%ecx
  4019ea:       ba 10 90 40 00          mov    $0x409010,%edx
  4019ef:       be 02 00 00 00          mov    $0x2,%esi
  4019f4:       31 c0                   xor    %eax,%eax
  4019f6:       bf 01 00 00 00          mov    $0x1,%edi
  4019fb:       83 c3 01                add    $0x1,%ebx
  4019fe:       e8 1d 2b 00 00          callq  404520 <ucall>
  401a03:       eb e3                   jmp    4019e8 <guest_code+0x8>
  401a05:       66 66 2e 0f 1f 84 00    data16 nopw %cs:0x0(%rax,%rax,1)
  401a0c:       00 00 00 00

and everything seems to work. The only problem is that I now get a new
warning from gcc:

x86_64/sync_regs_test.c: In function ‘guest_code’:
x86_64/sync_regs_test.c:25:6: warning: optimization may eliminate reads
 and/or writes to register variables [-Wvolatile-register-var]

checkpatch.pl doesn't like me either:

"WARNING: Use of volatile is usually wrong: see
 Documentation/process/volatile-considered-harmful.rst"

I can think of an 'ultimate' solution to open code ucall() in a single
asm block making sure the register we need is preserved but this looks
like an overkill.

Fixes: 204c91eff798a ("KVM: selftests: do not blindly clobber registers in guest asm")
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 tools/testing/selftests/kvm/x86_64/sync_regs_test.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/x86_64/sync_regs_test.c b/tools/testing/selftests/kvm/x86_64/sync_regs_test.c
index 11c2a70a7b87..25c54250d591 100644
--- a/tools/testing/selftests/kvm/x86_64/sync_regs_test.c
+++ b/tools/testing/selftests/kvm/x86_64/sync_regs_test.c
@@ -28,7 +28,7 @@ void guest_code(void)
 	 * use a callee-save register, otherwise the compiler
 	 * saves it around the call to GUEST_SYNC.
 	 */
-	register u32 stage asm("rbx");
+	register volatile u32 stage asm("rbx");
 	for (;;) {
 		GUEST_SYNC(0);
 		stage++;
-- 
2.20.1

