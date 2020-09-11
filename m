Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46352265E85
	for <lists+kvm@lfdr.de>; Fri, 11 Sep 2020 13:08:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725785AbgIKLHz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Sep 2020 07:07:55 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:37556 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725710AbgIKLHy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Sep 2020 07:07:54 -0400
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <colin.king@canonical.com>)
        id 1kGgtu-0006tV-Hl; Fri, 11 Sep 2020 11:07:30 +0000
From:   Colin King <colin.king@canonical.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org (maintainer:X86 ARCHITECTURE),
        "H . Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH][next] KVM: SVM: nested: fix free of uninitialized pointers save and ctl
Date:   Fri, 11 Sep 2020 12:07:30 +0100
Message-Id: <20200911110730.24238-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

Currently the error exit path to outt_set_gif will kfree on uninitialized
pointers save and ctl.  Fix this by ensuring these pointers are
inintialized to NULL to avoid garbage pointer freeing.

Addresses-Coverity: ("Uninitialized pointer read")
Fixes: 6ccbd29ade0d ("KVM: SVM: nested: Don't allocate VMCB structures on stack")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 arch/x86/kvm/svm/nested.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 28036629abf8..2b15f49f9e5a 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -1060,8 +1060,8 @@ static int svm_set_nested_state(struct kvm_vcpu *vcpu,
 	struct vmcb *hsave = svm->nested.hsave;
 	struct vmcb __user *user_vmcb = (struct vmcb __user *)
 		&user_kvm_nested_state->data.svm[0];
-	struct vmcb_control_area *ctl;
-	struct vmcb_save_area *save;
+	struct vmcb_control_area *ctl = NULL;
+	struct vmcb_save_area *save = NULL;
 	int ret;
 	u32 cr0;
 
-- 
2.27.0

