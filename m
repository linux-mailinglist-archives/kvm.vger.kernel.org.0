Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 105D427614
	for <lists+kvm@lfdr.de>; Thu, 23 May 2019 08:36:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727466AbfEWGgq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 May 2019 02:36:46 -0400
Received: from ozlabs.org ([203.11.71.1]:34359 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726385AbfEWGgp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 May 2019 02:36:45 -0400
Received: by ozlabs.org (Postfix, from userid 1003)
        id 458ft353Lrz9sBV; Thu, 23 May 2019 16:36:43 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ozlabs.org; s=201707;
        t=1558593403; bh=XqYcC2hfPVNyLaizCQlvjY5iInJ3OLoLBVpPVN8v8LU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=pnayADD3fDzj8vJX/tLcCYRdJwDw6tWApdyWE5oEFWXOPxNJxSuWp5d+ty16mEAuo
         Mw4B1rMAjWXRxUL+EMVQDivCDRpxGl6Wsrh84MnKGJ6KDYJ11z364cyiKURxPTVF6z
         Ddwn7xqP0fIrzv0gVM3EHjstnWfbInkoF48YeEPrLXIlWyKDnyHULm32iVd3WuNTtY
         WcOnwBsIiTTFiL98nCsnYCzxTxOJWUNleGfBl4AMFb7j1KAPJsXh4m+bPTQgb+cq6x
         ZBaZZI2uNSB877cKB7VnqUMFTudqsczK+guPMRCW16efIlzqCEJP97qYJbyuUQkoTL
         OMexRWIStWG9Q==
Date:   Thu, 23 May 2019 16:36:32 +1000
From:   Paul Mackerras <paulus@ozlabs.org>
To:     kvm@vger.kernel.org
Cc:     kvm-ppc@vger.kernel.org,
        =?iso-8859-1?Q?C=E9dric?= Le Goater <clg@kaod.org>
Subject: [PATCH 4/4] KVM: PPC: Book3S HV: Don't take kvm->lock around
 kvm_for_each_vcpu
Message-ID: <20190523063632.GF19655@blackberry>
References: <20190523063424.GB19655@blackberry>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190523063424.GB19655@blackberry>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Currently the HV KVM code takes the kvm->lock around calls to
kvm_for_each_vcpu() and kvm_get_vcpu_by_id() (which can call
kvm_for_each_vcpu() internally).  However, that leads to a lock
order inversion problem, because these are called in contexts where
the vcpu mutex is held, but the vcpu mutexes nest within kvm->lock
according to Documentation/virtual/kvm/locking.txt.  Hence there
is a possibility of deadlock.

To fix this, we simply don't take the kvm->lock mutex around these
calls.  This is safe because the implementations of kvm_for_each_vcpu()
and kvm_get_vcpu_by_id() have been designed to be able to be called
locklessly.

Signed-off-by: Paul Mackerras <paulus@ozlabs.org>
---
 arch/powerpc/kvm/book3s_hv.c | 9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index b1c0a9b..27054d3 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -446,12 +446,7 @@ static void kvmppc_dump_regs(struct kvm_vcpu *vcpu)
 
 static struct kvm_vcpu *kvmppc_find_vcpu(struct kvm *kvm, int id)
 {
-	struct kvm_vcpu *ret;
-
-	mutex_lock(&kvm->lock);
-	ret = kvm_get_vcpu_by_id(kvm, id);
-	mutex_unlock(&kvm->lock);
-	return ret;
+	return kvm_get_vcpu_by_id(kvm, id);
 }
 
 static void init_vpa(struct kvm_vcpu *vcpu, struct lppaca *vpa)
@@ -1583,7 +1578,6 @@ static void kvmppc_set_lpcr(struct kvm_vcpu *vcpu, u64 new_lpcr,
 	struct kvmppc_vcore *vc = vcpu->arch.vcore;
 	u64 mask;
 
-	mutex_lock(&kvm->lock);
 	spin_lock(&vc->lock);
 	/*
 	 * If ILE (interrupt little-endian) has changed, update the
@@ -1623,7 +1617,6 @@ static void kvmppc_set_lpcr(struct kvm_vcpu *vcpu, u64 new_lpcr,
 		mask &= 0xFFFFFFFF;
 	vc->lpcr = (vc->lpcr & ~mask) | (new_lpcr & mask);
 	spin_unlock(&vc->lock);
-	mutex_unlock(&kvm->lock);
 }
 
 static int kvmppc_get_one_reg_hv(struct kvm_vcpu *vcpu, u64 id,
-- 
2.7.4

