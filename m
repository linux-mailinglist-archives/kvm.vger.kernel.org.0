Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B55822A095D
	for <lists+kvm@lfdr.de>; Fri, 30 Oct 2020 16:14:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726875AbgJ3POS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Oct 2020 11:14:18 -0400
Received: from mx2.suse.de ([195.135.220.15]:58886 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726806AbgJ3POS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Oct 2020 11:14:18 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id A9BB9ADE8;
        Fri, 30 Oct 2020 15:14:16 +0000 (UTC)
From:   Takashi Iwai <tiwai@suse.de>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Joerg Roedel <jroedel@suse.de>
Subject: [PATCH] KVM: x86: Fix NULL dereference at kvm_msr_ignored_check()
Date:   Fri, 30 Oct 2020 16:14:14 +0100
Message-Id: <20201030151414.20165-1-tiwai@suse.de>
X-Mailer: git-send-email 2.16.4
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The newly introduced kvm_msr_ignored_check() tries to print error or
debug messages via vcpu_*() macros, but those may cause Oops when NULL
vcpu is passed for KVM_GET_MSRS ioctl.

Fix it by replacing the print calls with kvm_*() macros.

(Note that this will leave vcpu argument completely unused in the
 function, but I didn't touch it to make the fix as small as
 possible.  A clean up may be applied later.)

Fixes: 12bc2132b15e ("KVM: X86: Do the same ignore_msrs check for feature msrs")
BugLink: https://bugzilla.suse.com/show_bug.cgi?id=1178280
Cc: <stable@vger.kernel.org>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
---

Alternatively, we may fix all vcpu_*() macros to handle NULL vcpu
object, too, as mentioned in the bugzilla entry above.
If that's a preferred change, let me know.  Thanks!

 arch/x86/kvm/x86.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 397f599b20e5..f5ede41bf9e6 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -265,13 +265,13 @@ static int kvm_msr_ignored_check(struct kvm_vcpu *vcpu, u32 msr,
 
 	if (ignore_msrs) {
 		if (report_ignored_msrs)
-			vcpu_unimpl(vcpu, "ignored %s: 0x%x data 0x%llx\n",
-				    op, msr, data);
+			kvm_pr_unimpl("ignored %s: 0x%x data 0x%llx\n",
+				      op, msr, data);
 		/* Mask the error */
 		return 0;
 	} else {
-		vcpu_debug_ratelimited(vcpu, "unhandled %s: 0x%x data 0x%llx\n",
-				       op, msr, data);
+		kvm_debug_ratelimited("unhandled %s: 0x%x data 0x%llx\n",
+				      op, msr, data);
 		return -ENOENT;
 	}
 }
-- 
2.16.4

