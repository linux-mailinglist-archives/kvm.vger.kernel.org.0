Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8D64D2D383
	for <lists+kvm@lfdr.de>; Wed, 29 May 2019 03:54:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726137AbfE2ByI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 May 2019 21:54:08 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:42739 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725828AbfE2ByI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 May 2019 21:54:08 -0400
Received: by ozlabs.org (Postfix, from userid 1003)
        id 45DDK91Jlvz9sBb; Wed, 29 May 2019 11:54:05 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ozlabs.org; s=201707;
        t=1559094845; bh=imLPVfI8pPH7045d2jFL+whAPxqGVNVVa01gDxyjly4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=PeqQSWxnR80D0WNCxxsXKhaUpdE59FnxBCfXoFoSa7Y4apu78HAMfTpnPUTlD6dxk
         1hN7SK2ndHGT9pUT24BJJhGl9Z1JdWd8gWCT2U7oeUVfHBXxEkztHXfH3WtZy1NqrH
         J4C40440uOHQROIurZMO36iqT7XFaV0Oj9iF0d5dPBiHiNnQi9WVG3YzOxVBniZeZE
         7YSHdLJSuXy8ntrDuO+TVbhvRwwaCIrbJHYcZsT0205tIQRa4fm42hC1+ego/OMyLa
         nu8o7hbAnB6Y0UExQKQsIfnjITaEzsbi5P/meNNHlz+EhCGuSf6pO1811c/rO6N766
         xJNxvABYdQhpg==
Date:   Wed, 29 May 2019 11:54:00 +1000
From:   Paul Mackerras <paulus@ozlabs.org>
To:     kvm@vger.kernel.org
Cc:     kvm-ppc@vger.kernel.org,
        =?iso-8859-1?Q?C=E9dric?= Le Goater <clg@kaod.org>
Subject: [PATCH v2 3/4] KVM: PPC: Book3S: Use new mutex to synchronize access
 to rtas token list
Message-ID: <20190529015400.GA16539@blackberry>
References: <20190523063424.GB19655@blackberry>
 <20190523063601.GE19655@blackberry>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190523063601.GE19655@blackberry>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Currently the Book 3S KVM code uses kvm->lock to synchronize access
to the kvm->arch.rtas_tokens list.  Because this list is scanned
inside kvmppc_rtas_hcall(), which is called with the vcpu mutex held,
taking kvm->lock cause a lock inversion problem, which could lead to
a deadlock.

To fix this, we add a new mutex, kvm->arch.rtas_token_lock, which nests
inside the vcpu mutexes, and use that instead of kvm->lock when
accessing the rtas token list.

This removes the lockdep_assert_held() in kvmppc_rtas_tokens_free().
At this point we don't hold the new mutex, but that is OK because
kvmppc_rtas_tokens_free() is only called when the whole VM is being
destroyed, and at that point nothing can be looking up a token in
the list.

Signed-off-by: Paul Mackerras <paulus@ozlabs.org>
---
 arch/powerpc/include/asm/kvm_host.h |  1 +
 arch/powerpc/kvm/book3s.c           |  1 +
 arch/powerpc/kvm/book3s_rtas.c      | 14 ++++++--------
 3 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/arch/powerpc/include/asm/kvm_host.h b/arch/powerpc/include/asm/kvm_host.h
index 013c76a..fb7d363 100644
--- a/arch/powerpc/include/asm/kvm_host.h
+++ b/arch/powerpc/include/asm/kvm_host.h
@@ -309,6 +309,7 @@ struct kvm_arch {
 #ifdef CONFIG_PPC_BOOK3S_64
 	struct list_head spapr_tce_tables;
 	struct list_head rtas_tokens;
+	struct mutex rtas_token_lock;
 	DECLARE_BITMAP(enabled_hcalls, MAX_HCALL_OPCODE/4 + 1);
 #endif
 #ifdef CONFIG_KVM_MPIC
diff --git a/arch/powerpc/kvm/book3s.c b/arch/powerpc/kvm/book3s.c
index 61a212d..ac56648 100644
--- a/arch/powerpc/kvm/book3s.c
+++ b/arch/powerpc/kvm/book3s.c
@@ -902,6 +902,7 @@ int kvmppc_core_init_vm(struct kvm *kvm)
 #ifdef CONFIG_PPC64
 	INIT_LIST_HEAD_RCU(&kvm->arch.spapr_tce_tables);
 	INIT_LIST_HEAD(&kvm->arch.rtas_tokens);
+	mutex_init(&kvm->arch.rtas_token_lock);
 #endif
 
 	return kvm->arch.kvm_ops->init_vm(kvm);
diff --git a/arch/powerpc/kvm/book3s_rtas.c b/arch/powerpc/kvm/book3s_rtas.c
index 4e178c4..b7ae3df 100644
--- a/arch/powerpc/kvm/book3s_rtas.c
+++ b/arch/powerpc/kvm/book3s_rtas.c
@@ -146,7 +146,7 @@ static int rtas_token_undefine(struct kvm *kvm, char *name)
 {
 	struct rtas_token_definition *d, *tmp;
 
-	lockdep_assert_held(&kvm->lock);
+	lockdep_assert_held(&kvm->arch.rtas_token_lock);
 
 	list_for_each_entry_safe(d, tmp, &kvm->arch.rtas_tokens, list) {
 		if (rtas_name_matches(d->handler->name, name)) {
@@ -167,7 +167,7 @@ static int rtas_token_define(struct kvm *kvm, char *name, u64 token)
 	bool found;
 	int i;
 
-	lockdep_assert_held(&kvm->lock);
+	lockdep_assert_held(&kvm->arch.rtas_token_lock);
 
 	list_for_each_entry(d, &kvm->arch.rtas_tokens, list) {
 		if (d->token == token)
@@ -206,14 +206,14 @@ int kvm_vm_ioctl_rtas_define_token(struct kvm *kvm, void __user *argp)
 	if (copy_from_user(&args, argp, sizeof(args)))
 		return -EFAULT;
 
-	mutex_lock(&kvm->lock);
+	mutex_lock(&kvm->arch.rtas_token_lock);
 
 	if (args.token)
 		rc = rtas_token_define(kvm, args.name, args.token);
 	else
 		rc = rtas_token_undefine(kvm, args.name);
 
-	mutex_unlock(&kvm->lock);
+	mutex_unlock(&kvm->arch.rtas_token_lock);
 
 	return rc;
 }
@@ -245,7 +245,7 @@ int kvmppc_rtas_hcall(struct kvm_vcpu *vcpu)
 	orig_rets = args.rets;
 	args.rets = &args.args[be32_to_cpu(args.nargs)];
 
-	mutex_lock(&vcpu->kvm->lock);
+	mutex_lock(&vcpu->kvm->arch.rtas_token_lock);
 
 	rc = -ENOENT;
 	list_for_each_entry(d, &vcpu->kvm->arch.rtas_tokens, list) {
@@ -256,7 +256,7 @@ int kvmppc_rtas_hcall(struct kvm_vcpu *vcpu)
 		}
 	}
 
-	mutex_unlock(&vcpu->kvm->lock);
+	mutex_unlock(&vcpu->kvm->arch.rtas_token_lock);
 
 	if (rc == 0) {
 		args.rets = orig_rets;
@@ -282,8 +282,6 @@ void kvmppc_rtas_tokens_free(struct kvm *kvm)
 {
 	struct rtas_token_definition *d, *tmp;
 
-	lockdep_assert_held(&kvm->lock);
-
 	list_for_each_entry_safe(d, tmp, &kvm->arch.rtas_tokens, list) {
 		list_del(&d->list);
 		kfree(d);
-- 
2.7.4

