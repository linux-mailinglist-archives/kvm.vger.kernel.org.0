Return-Path: <kvm+bounces-23270-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A0F9F9485AD
	for <lists+kvm@lfdr.de>; Tue,  6 Aug 2024 00:56:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C3BD91C20FDB
	for <lists+kvm@lfdr.de>; Mon,  5 Aug 2024 22:56:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CCCC416E877;
	Mon,  5 Aug 2024 22:56:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="a29bvxtW"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D47A14EC51
	for <kvm@vger.kernel.org>; Mon,  5 Aug 2024 22:56:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722898613; cv=none; b=UHWB0XvywPWj6d855zta7o+jnCBi7wZd6iSZj/y0+0bgYikuIxuYg3unex9tD9IHOMlZ6Pv9RQT+EtmnIgtfpIEyNdOrliM7jwqWtiSDiJ67JKxWSRzkITAE/Aj1rTNBWo8wA7dyH2d25/Wi5ensHCwP2SpwIXudaxHffR6tpvU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722898613; c=relaxed/simple;
	bh=sn0BWT1RLULVmUgfRsG6NoLlaNP+PkEL86j2AeRBgdU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=CmOXJR5kSqOWF6OsyywmhNuE4fNHhb9Tl14wNqd3z4EF7rUyYFLrmeQOIlq6MlFxZ+mQ/cSHW7kzHRMNTIc5oQ8ORNB7PS30fCLpyFzQjtXK4w8mEAdg64PLYhENTi7fM3IrhWhRqSeTY7CQXwOh6/JMUkXP+gm5t2iJwbqm5nc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=a29bvxtW; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-1fc4e03a885so93251755ad.2
        for <kvm@vger.kernel.org>; Mon, 05 Aug 2024 15:56:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722898611; x=1723503411; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=IDWgyjsH45NVEgZyg18i/C/FIL++a8gaLVuK3tZHbm4=;
        b=a29bvxtWYj9Ja6JjSPZJDWoPePNz7TpKH067VO6cYCmaspUNpGgw7wg45nBBTvXj3Y
         aJ5XlNFzDohM2fvymUNIwEi5aqHz0536dPqWEqe2w40bDP0+h2NhLvqh1EFXFL0UcpzM
         fPFJlyjhtQcucPbnKHZvF/UTPL0E2yF19kt/5NTMYyjB4myDtFvKuuL47nN6p9aV0X+J
         7oYt/qf/Tqzryar+Eye2RF3bbPyuT/SYxWu3iF88vwigfTQmvzPxlZnfNDww1B3v9EyR
         7QbsLQbSduQs9KrG4fzgcxAU6l/cgJcQ3t3EGOVG3PMJIqglc/xV81+bK52FnmQBUckw
         Vqqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722898611; x=1723503411;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=IDWgyjsH45NVEgZyg18i/C/FIL++a8gaLVuK3tZHbm4=;
        b=R3EB+0Ig2heFUfktaTeW7R/1jg2DjYEfmwEX5BQuljZb7Nm9fmcUd0lIRn+MOoq6KV
         wbAmW6Z1w9yDgtcyA6f5QrgnAQ+ORssztsRu2LrlvWI1Ls7KLNafbn2gHOxkFnUXfxTR
         M/awiL/1uOsclPRNNapPaP2bK0OZse1y3cmOynwqdVV17HFvauZyWlweXyU2vFiZsz8q
         eIBqZhxA4SQUP4P3F8/7+tfFuiLO4dZliMndFdUTqd7DhQ8XKOmy7hBHUgxRqBA9mdqO
         TyRRHcgand1ks1lYauGkxCzc11/m6O4j8gDKykXkgzqs+hvBLRynvxAmgkHe75QYyx6n
         ZWSQ==
X-Forwarded-Encrypted: i=1; AJvYcCW/hPnDqjHErCkSrrl2TikhbA9s4eCtsThM1P3GWfLRIM43LdmT7Gm5Qt6TWUsBYLtWfk0lZie8c0TClQlHqGE+CseV
X-Gm-Message-State: AOJu0YyzOi/XS3bilwRdEUF+YlhEo+KU1kLksBZdwaGqLgLDKvortAQM
	L8C0/Cb4vgtWSOwjkLw/57cTFrrQrpNwb0ZvNuyoIDXesVwodzqG7UXwNERcloNiueoEArFkC2Q
	HTg==
X-Google-Smtp-Source: AGHT+IGQexEmm27AzoGH3anORPtQZrXawJzpbk+oTyTSXnOYC11+L1WFY4txX6zASCpgbESs03OW1CF70tE=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:e743:b0:1fb:54d9:ebb3 with SMTP id
 d9443c01a7336-1ff57309939mr8340285ad.6.1722898610647; Mon, 05 Aug 2024
 15:56:50 -0700 (PDT)
Date: Mon, 5 Aug 2024 15:56:49 -0700
In-Reply-To: <07987fc3-5c47-4e77-956c-dae4bdf4bc2b@rbox.co>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240730155646.1687-1-will@kernel.org> <ccd40ae1-14aa-454e-9620-b34154f03e53@rbox.co>
 <Zql3vMnR86mMvX2w@google.com> <20240731133118.GA2946@willie-the-truck>
 <3e5f7422-43ce-44d4-bff7-cc02165f08c0@rbox.co> <Zqpj8M3xhPwSVYHY@google.com>
 <20240801124131.GA4730@willie-the-truck> <07987fc3-5c47-4e77-956c-dae4bdf4bc2b@rbox.co>
Message-ID: <ZrFYsSPaDWUHOl0N@google.com>
Subject: Re: [PATCH] KVM: Fix error path in kvm_vm_ioctl_create_vcpu() on
 xa_store() failure
From: Sean Christopherson <seanjc@google.com>
To: Michal Luczaj <mhal@rbox.co>
Cc: Will Deacon <will@kernel.org>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Paolo Bonzini <pbonzini@redhat.com>, Alexander Potapenko <glider@google.com>, Marc Zyngier <maz@kernel.org>
Content-Type: text/plain; charset="us-ascii"

On Sun, Aug 04, 2024, Michal Luczaj wrote:
> On 8/1/24 14:41, Will Deacon wrote:
> > On Wed, Jul 31, 2024 at 09:18:56AM -0700, Sean Christopherson wrote:
> >> [...]
> >> Ya, the basic problem is that we have two ways of publishing the vCPU, fd and
> >> vcpu_array, with no way of setting both atomically.  Given that xa_store() should
> >> never fail, I vote we do the simple thing and deliberately leak the memory.
> > 
> > I'm inclined to agree. This conversation did momentarily get me worried
> > about the window between the successful create_vcpu_fd() and the
> > xa_store(), but it looks like 'kvm->online_vcpus' protects that.
> > 
> > I'll spin a v2 leaking the vCPU, then.
> 
> But perhaps you're right. The window you've described may be an issue.
> For example:
> 
> static u64 get_time_ref_counter(struct kvm *kvm)
> {
> 	...
> 	vcpu = kvm_get_vcpu(kvm, 0); // may still be NULL
> 	tsc = kvm_read_l1_tsc(vcpu, rdtsc());
> 	return mul_u64_u64_shr(tsc, hv->tsc_ref.tsc_scale, 64)
> 		+ hv->tsc_ref.tsc_offset;
> }
> 
> u64 kvm_read_l1_tsc(struct kvm_vcpu *vcpu, u64 host_tsc)
> {
> 	return vcpu->arch.l1_tsc_offset +
> 		kvm_scale_tsc(host_tsc, vcpu->arch.l1_tsc_scaling_ratio);
> }
> 
> After stuffing msleep() between fd install and vcpu_array store:
> 
> [  125.296110] BUG: kernel NULL pointer dereference, address: 0000000000000b38
> [  125.296203] #PF: supervisor read access in kernel mode
> [  125.296266] #PF: error_code(0x0000) - not-present page
> [  125.296327] PGD 12539e067 P4D 12539e067 PUD 12539d067 PMD 0
> [  125.296392] Oops: Oops: 0000 [#1] PREEMPT SMP NOPTI
> [  125.296454] CPU: 12 UID: 1000 PID: 1179 Comm: a.out Not tainted 6.11.0-rc1nokasan+ #19
> [  125.296521] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Arch Linux 1.16.3-1-1 04/01/2014
> [  125.296585] RIP: 0010:kvm_read_l1_tsc+0x6/0x50 [kvm]
> [  125.297376] Call Trace:
> [  125.297430]  <TASK>
> [  125.297919]  get_time_ref_counter+0x70/0x90 [kvm]
> [  125.298039]  kvm_hv_get_msr_common+0xc1/0x7d0 [kvm]
> [  125.298150]  __kvm_get_msr+0x72/0xf0 [kvm]
> [  125.298421]  do_get_msr+0x16/0x50 [kvm]
> [  125.298531]  msr_io+0x9d/0x110 [kvm]
> [  125.298626]  kvm_arch_vcpu_ioctl+0xdc5/0x19c0 [kvm]
> [  125.299345]  kvm_vcpu_ioctl+0x6cc/0x920 [kvm]
> [  125.299540]  __x64_sys_ioctl+0x90/0xd0
> [  125.299582]  do_syscall_64+0x93/0x180
> [  125.300206]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
> [  125.300243] RIP: 0033:0x7f2d64aded2d
> 
> So, is get_time_ref_counter() broken (with a trivial fix) or should it be
> considered a regression after commit afb2acb2e3a3
> ("KVM: Fix vcpu_array[0] races")?

The latter, though arguably afb2acb2e3a3 isn't really a regression since it
essentially just reverts back to the pre-Xarray code, i.e. the bug was always
there, it was just temporarily masked by a worst bug.

I don't think we want to go down the path of declaring get_time_ref_counter()
broken, because that is going to result in an impossible programming model.

Ha!  We can kill two birds with one stone.  If we take vcpu->mutex before installing
the file descriptor, and hold it until online_vcpus is bumped, userspace

Argh, so close, kvm_arch_vcpu_async_ioctl() throws a wrench in that idea.  Double
argh, whether or not an ioctl is async is buried in arch code.

I still think it makes sense to grab vcpu->mutex for synchronous ioctls.  That
way there's no vibisle change to userspace, and we can lean on that code to reject
the async ioctls, as I can't imagine there's a practical use case for emitting an
an async ioctl without first doing a synchronous ioctl.  E.g. in addition to the
below patch, plus changes to add kvm_arch_is_async_vcpu_ioctl():

	/*
	 * Some architectures have vcpu ioctls that are asynchronous to vcpu
	 * execution; mutex_lock() would break them.  Disallow asynchronous
	 * ioctls until the vCPU is fully online.  This can only happen if
	 * userspace has *never* a done a synchronous ioctl, as acquiring the
	 * vCPU's mutex ensures the vCPU is online, i.e. isn't a restriction
	 * for any practical use case.
	 */
	if (kvm_arch_is_async_vcpu_ioctl(ioctl)) {
		if (vcpu->vcpu_idx < atomic_read(&kvm->online_vcpus))
			return -EINVAL;
		return kvm_vcpu_async_ioctl(filp, ioctl, arg);
	}

Alternatively, we could go for the super simple change and cross our fingers that
no "real" VMM emits vCPU ioctls before KVM_CREATE_VCPU returns.

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index d0788d0a72cc..9ae9022a015f 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -4450,6 +4450,9 @@ static long kvm_vcpu_ioctl(struct file *filp,
        if (unlikely(_IOC_TYPE(ioctl) != KVMIO))
                return -EINVAL;
 
+       if (unlikely(vcpu->vcpu_idx < atomic_read(&kvm->online_vcpus)))
+               return -EINVAL;
+
        /*
         * Some architectures have vcpu ioctls that are asynchronous to vcpu
         * execution; mutex_lock() would break them.



The mutex approach, sans async ioctl support:

---
 virt/kvm/kvm_main.c | 28 +++++++++++++++++++---------
 1 file changed, 19 insertions(+), 9 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index d0788d0a72cc..0a9c390b18a3 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -4269,12 +4269,6 @@ static int kvm_vm_ioctl_create_vcpu(struct kvm *kvm, unsigned long id)
 
 	mutex_lock(&kvm->lock);
 
-#ifdef CONFIG_LOCKDEP
-	/* Ensure that lockdep knows vcpu->mutex is taken *inside* kvm->lock */
-	mutex_lock(&vcpu->mutex);
-	mutex_unlock(&vcpu->mutex);
-#endif
-
 	if (kvm_get_vcpu_by_id(kvm, id)) {
 		r = -EEXIST;
 		goto unlock_vcpu_destroy;
@@ -4285,15 +4279,29 @@ static int kvm_vm_ioctl_create_vcpu(struct kvm *kvm, unsigned long id)
 	if (r)
 		goto unlock_vcpu_destroy;
 
-	/* Now it's all set up, let userspace reach it */
+	/*
+	 * Now it's all set up, let userspace reach it.  Grab the vCPU's mutex
+	 * so that userspace can't invoke vCPU ioctl()s until the vCPU is fully
+	 * visibile (per online_vcpus), e.g. so that KVM doesn't get tricked
+	 * into a NULL-pointer dereference because KVM thinks the _current_
+	 * vCPU doesn't exist.  As a bonus, taking vcpu->mutex ensures lockdep
+	 * knows it's taken *inside* kvm->lock.
+	 */
+	mutex_lock(&vcpu->mutex);
 	kvm_get_kvm(kvm);
 	r = create_vcpu_fd(vcpu);
 	if (r < 0)
 		goto kvm_put_xa_release;
 
+	/*
+	 * xa_store() should never fail, see xa_reserve() above.  Leak the vCPU
+	 * if the impossible happens, as userspace already has access to the
+	 * vCPU, i.e. freeing the vCPU before userspace puts its file reference
+	 * would trigger a use-after-free.
+	 */
 	if (KVM_BUG_ON(xa_store(&kvm->vcpu_array, vcpu->vcpu_idx, vcpu, 0), kvm)) {
-		r = -EINVAL;
-		goto kvm_put_xa_release;
+		mutex_unlock(&vcpu->mutex);
+		return -EINVAL;
 	}
 
 	/*
@@ -4302,6 +4310,7 @@ static int kvm_vm_ioctl_create_vcpu(struct kvm *kvm, unsigned long id)
 	 */
 	smp_wmb();
 	atomic_inc(&kvm->online_vcpus);
+	mutex_unlock(&vcpu->mutex);
 
 	mutex_unlock(&kvm->lock);
 	kvm_arch_vcpu_postcreate(vcpu);
@@ -4309,6 +4318,7 @@ static int kvm_vm_ioctl_create_vcpu(struct kvm *kvm, unsigned long id)
 	return r;
 
 kvm_put_xa_release:
+	mutex_unlock(&vcpu->mutex);
 	kvm_put_kvm_no_destroy(kvm);
 	xa_release(&kvm->vcpu_array, vcpu->vcpu_idx);
 unlock_vcpu_destroy:

base-commit: 332d2c1d713e232e163386c35a3ba0c1b90df83f
-- 

