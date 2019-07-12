Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3A208669B9
	for <lists+kvm@lfdr.de>; Fri, 12 Jul 2019 11:13:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726050AbfGLJNk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Jul 2019 05:13:40 -0400
Received: from mout.kundenserver.de ([217.72.192.73]:55529 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725987AbfGLJNk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 Jul 2019 05:13:40 -0400
Received: from threadripper.lan ([149.172.19.189]) by mrelayeu.kundenserver.de
 (mreue107 [212.227.15.145]) with ESMTPA (Nemesis) id
 1M9Evp-1hsCKR1COV-006PUz; Fri, 12 Jul 2019 11:12:52 +0200
From:   Arnd Bergmann <arnd@arndb.de>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org
Cc:     Arnd Bergmann <arnd@arndb.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Junaid Shahid <junaids@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Lan Tianyu <Tianyu.Lan@microsoft.com>,
        Wei Yang <richard.weiyang@gmail.com>,
        Kai Huang <kai.huang@linux.intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, clang-built-linux@googlegroups.com
Subject: [PATCH 2/2] x86: kvm: avoid constant-conversion warning
Date:   Fri, 12 Jul 2019 11:12:30 +0200
Message-Id: <20190712091239.716978-2-arnd@arndb.de>
X-Mailer: git-send-email 2.20.0
In-Reply-To: <20190712091239.716978-1-arnd@arndb.de>
References: <20190712091239.716978-1-arnd@arndb.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:Lplw8L9pjitxjn8uvfCtJoBisPCqjfQiaYB9KiT+KGN1cMhK+5D
 n/9/tW1nGJzdBVxSoYqav3BS7V4RGgkHR9YN1LINgAaPvva1Qx26lH9nTlTY0zHaSxEilMg
 7BtKZwd+0GWrh2mAZH3cn8oejeDl9a8Z3+ymWV/e/eayCEFlWogVmsUcdOYdm5qnm+NBhsR
 n2mHbJLBE2Pxwf82SAbNg==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:2gJTX7oQrfo=:8iwkhuTEo+aTunqSalJZf8
 Q6TlLUW7RDKJjjaEFe/LtwCj+w+S1LIDwMgftl5hzuEmGu78NLrJ6rjNPQ+PCnv3x8M01DBtJ
 kr4jFC1wHR+yZRHhnM1cO/JxZY4WiHPAj4iolh6XhfxmFuBsAH5SustbQ0CTas3HLR2ALH9tZ
 wV3WWWK98AxQbfA4C8/6ZucpZUhlALfb830BGO2VDlJVhIzksURR6aIJnoVTUJ1CBsOzyk8O1
 gdTnbaTyC/pzW0jBPGZQWF3bXlkT7f82LtTKK6+zItWA32Da5/WZKUiaFSkGnReQLZwtgQR2J
 eYo/ybJzbKOWiMxJ7qafwBu//eoIUIE47EMpmM6xk3ePWbYYVGXSWQlJMoQEazPt7et24kda5
 h9rdQMTI5qzrTyPLKIm4SE9K05jqIzfvkEGRrUs0XlUp6KmZYaSXUj3TSu08dNpuQRSUL6ra2
 C/qoXTHIUtajn2IxHWyVRwTlL98MM0ocEzNAW68X9CMNU3Y5crQdfYXGxbbb89nFjow0SmSMo
 IS9pp53s0pu1u/X7zy/lfNDCs5F+7sQgxedbE26LcuBQ4ystfEEsSfQdnzpUPKH3XM6q66aoc
 YyLVPpYXg5CPjZTBhr/XxuupeehfNOZXyvpQvMbzqRQqHHvdoRoGG/ylPLIbYlD0iuCVbkeTr
 QoWLFKMVmb1pNQfR71sQpUzCa7E8YTn/4DH7TvvaqHWcdoMOrCLPwQ7zRADZWuZkoTH0vOSXg
 tLUPwuZbP10mwEDPt4R8TKxhIgimKY9b1Q+pAg==
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

clang finds a contruct suspicious that converts an unsigned
character to a signed integer and back, causing an overflow:

arch/x86/kvm/mmu.c:4605:39: error: implicit conversion from 'int' to 'u8' (aka 'unsigned char') changes value from -205 to 51 [-Werror,-Wconstant-conversion]
                u8 wf = (pfec & PFERR_WRITE_MASK) ? ~w : 0;
                   ~~                               ^~
arch/x86/kvm/mmu.c:4607:38: error: implicit conversion from 'int' to 'u8' (aka 'unsigned char') changes value from -241 to 15 [-Werror,-Wconstant-conversion]
                u8 uf = (pfec & PFERR_USER_MASK) ? ~u : 0;
                   ~~                              ^~
arch/x86/kvm/mmu.c:4609:39: error: implicit conversion from 'int' to 'u8' (aka 'unsigned char') changes value from -171 to 85 [-Werror,-Wconstant-conversion]
                u8 ff = (pfec & PFERR_FETCH_MASK) ? ~x : 0;
                   ~~                               ^~

Add an explicit cast to tell clang that everything works as
intended here.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 arch/x86/kvm/mmu.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 17ece7b994b1..aea7f969ecb8 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -4602,11 +4602,11 @@ static void update_permission_bitmask(struct kvm_vcpu *vcpu,
 		 */
 
 		/* Faults from writes to non-writable pages */
-		u8 wf = (pfec & PFERR_WRITE_MASK) ? ~w : 0;
+		u8 wf = (pfec & PFERR_WRITE_MASK) ? (u8)~w : 0;
 		/* Faults from user mode accesses to supervisor pages */
-		u8 uf = (pfec & PFERR_USER_MASK) ? ~u : 0;
+		u8 uf = (pfec & PFERR_USER_MASK) ? (u8)~u : 0;
 		/* Faults from fetches of non-executable pages*/
-		u8 ff = (pfec & PFERR_FETCH_MASK) ? ~x : 0;
+		u8 ff = (pfec & PFERR_FETCH_MASK) ? (u8)~x : 0;
 		/* Faults from kernel mode fetches of user pages */
 		u8 smepf = 0;
 		/* Faults from kernel mode accesses of user pages */
-- 
2.20.0

