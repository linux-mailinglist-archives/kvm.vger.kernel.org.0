Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 99413123EB8
	for <lists+kvm@lfdr.de>; Wed, 18 Dec 2019 06:11:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726212AbfLRFLk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Dec 2019 00:11:40 -0500
Received: from ozlabs.org ([203.11.71.1]:51191 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725797AbfLRFLk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Dec 2019 00:11:40 -0500
Received: by ozlabs.org (Postfix, from userid 1003)
        id 47d35Q0Hx6z9sRl; Wed, 18 Dec 2019 16:11:37 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ozlabs.org; s=201707;
        t=1576645898; bh=93N8VOo8SCifT0RoMTSN2PKiLco93mZr6cUDSYI7iGY=;
        h=Date:From:To:Subject:From;
        b=Sf+V97fQIP+xjVTfXjs7QkPY6KUzLk6WUv1oXQAOBYy6EjkoxncqrxBgGe8uyoqlO
         zOHjE/FaRl3eVq1L0RC82EYbBbDI3TSkYmR3ehw59Ux9gptGj06yuK8nepILjhsXQP
         OrplO34urCMEM1VWcqzH12kTWwvEP6YLzPguMCznTb4EDf5W7SKrI7n3QsZ/XJbBkS
         QkvYcuSYaiiUZAw3cPpQEwoVzFFaUYkunNGIMGAEqA0blCcrC5FtZZAj9B3vvvjGWy
         Xotr5chWd51m+6TB3oyyGN9jkq73n0jqo783Hk4dMccFwZtcoRG9/6/MbAaXllELIG
         mMvqpTcqK2dGA==
Date:   Wed, 18 Dec 2019 16:11:30 +1100
From:   Paul Mackerras <paulus@ozlabs.org>
To:     kvm@vger.kernel.org, kvm-ppc@vger.kernel.org
Subject: [PATCH] KVM: PPC: Book3S HV: Don't do ultravisor calls on systems
 without ultravisor
Message-ID: <20191218051130.GA29890@oak.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Commit 22945688acd4 ("KVM: PPC: Book3S HV: Support reset of secure
guest") added a call to uv_svm_terminate, which is an ultravisor
call, without any check that the guest is a secure guest or even that
the system has an ultravisor.  On a system without an ultravisor,
the ultracall will degenerate to a hypercall, but since we are not
in KVM guest context, the hypercall will get treated as a system
call, which could have random effects depending on what happens to
be in r0, and could also corrupt the current task's kernel stack.
Hence this adds a test for the guest being a secure guest before
doing uv_svm_terminate().

Fixes: 22945688acd4 ("KVM: PPC: Book3S HV: Support reset of secure guest")
Signed-off-by: Paul Mackerras <paulus@ozlabs.org>
---
 arch/powerpc/kvm/book3s_hv.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index dc53578193ee..6ff3f896d908 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -4983,7 +4983,8 @@ static void kvmppc_core_destroy_vm_hv(struct kvm *kvm)
 		if (nesting_enabled(kvm))
 			kvmhv_release_all_nested(kvm);
 		kvm->arch.process_table = 0;
-		uv_svm_terminate(kvm->arch.lpid);
+		if (kvm->arch.secure_guest)
+			uv_svm_terminate(kvm->arch.lpid);
 		kvmhv_set_ptbl_entry(kvm->arch.lpid, 0, 0);
 	}
 
-- 
2.20.1

