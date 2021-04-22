Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C7EF36823A
	for <lists+kvm@lfdr.de>; Thu, 22 Apr 2021 16:12:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236943AbhDVOMj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Apr 2021 10:12:39 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:38375 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236357AbhDVOMi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Apr 2021 10:12:38 -0400
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <colin.king@canonical.com>)
        id 1lZa3F-0007PO-FD; Thu, 22 Apr 2021 14:11:29 +0000
From:   Colin King <colin.king@canonical.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H . Peter Anvin" <hpa@zytor.com>,
        kvm@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH][next] KVM: x86: simplify zero'ing of entry->ebx
Date:   Thu, 22 Apr 2021 15:11:29 +0100
Message-Id: <20210422141129.250525-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

Currently entry->ebx is being zero'd by masking itself with zero.
Simplify this by just assigning zero, cleans up static analysis
warning.

Addresses-Coverity: ("Bitwise-and with zero")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 arch/x86/kvm/cpuid.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 57744a5d1bc2..9bcc2ff4b232 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -851,7 +851,7 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
 		entry->eax &= SGX_ATTR_DEBUG | SGX_ATTR_MODE64BIT |
 			      SGX_ATTR_PROVISIONKEY | SGX_ATTR_EINITTOKENKEY |
 			      SGX_ATTR_KSS;
-		entry->ebx &= 0;
+		entry->ebx = 0;
 		break;
 	/* Intel PT */
 	case 0x14:
-- 
2.30.2

