Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3D5836FF1E
	for <lists+kvm@lfdr.de>; Fri, 30 Apr 2021 19:03:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230478AbhD3REQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Apr 2021 13:04:16 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:38233 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229750AbhD3REP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Apr 2021 13:04:15 -0400
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <colin.king@canonical.com>)
        id 1lcWXf-0001yL-Cp; Fri, 30 Apr 2021 17:03:03 +0000
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
        Nathan Tempelman <natet@google.com>, kvm@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH][next] KVM: x86: Fix potential fput on a null source_kvm_file
Date:   Fri, 30 Apr 2021 18:03:03 +0100
Message-Id: <20210430170303.131924-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

The fget can potentially return null, so the fput on the error return
path can cause a null pointer dereference. Fix this by checking for
a null source_kvm_file before doing a fput.

Addresses-Coverity: ("Dereference null return")
Fixes: 54526d1fd593 ("KVM: x86: Support KVM VMs sharing SEV context")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 arch/x86/kvm/svm/sev.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 1356ee095cd5..8b11c711a0e4 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -1764,7 +1764,8 @@ int svm_vm_copy_asid_from(struct kvm *kvm, unsigned int source_fd)
 e_source_unlock:
 	mutex_unlock(&source_kvm->lock);
 e_source_put:
-	fput(source_kvm_file);
+	if (source_kvm_file)
+		fput(source_kvm_file);
 	return ret;
 }
 
-- 
2.30.2

