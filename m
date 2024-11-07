Return-Path: <kvm+bounces-31171-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9CC099C0F79
	for <lists+kvm@lfdr.de>; Thu,  7 Nov 2024 20:56:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5C6242820A8
	for <lists+kvm@lfdr.de>; Thu,  7 Nov 2024 19:56:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 93F71218315;
	Thu,  7 Nov 2024 19:56:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="CywPTRSb"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 219F9217F47
	for <kvm@vger.kernel.org>; Thu,  7 Nov 2024 19:56:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731009396; cv=none; b=OoI+vB2dXlKrhjm9GhND3CIa84JL8mBNhVYLW6hl++jMCq9zIwLUNZwJjoHgmwsnOukxdIWZ2fVMqSDqRpVXA1YsrqlT4AWOHoDROReDYdXg1DwDMRWdFPhcVqKoyuOSP3zeCymarqwKxSFAjO50I2Zq43dERwvNURXaoRW6i5Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731009396; c=relaxed/simple;
	bh=s9PQaqYy7gUAKaokyD0EQQVp3ndmKgWBymJlUQ5NQT4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ZyPLhx9P/HMD51rNlF0wQIOhm8OskGcLvTMwfndBQ1Izg6bW9JUXTUkeg+v3oXtKJSP7I9u/BHqa3MnFsDZq4XbQed4ms2Fp1001Y4q5kPJ9Yhao5S4SGMbxbL5PpUso7SxFbMbBQ2Q3TcP8wH1FzU5eobliNMTGquQo0x5lOmE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=CywPTRSb; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-6e59dc7df64so17539787b3.1
        for <kvm@vger.kernel.org>; Thu, 07 Nov 2024 11:56:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1731009394; x=1731614194; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=zBP9cQn+CUeDWqPutci2y0fBryOwyk4gwuh+LOyRfGQ=;
        b=CywPTRSbOXBS11s4dkLz6eRgFRlZv2m+lfQDQwQ+ELJtu40hXlFbqtl418JvbUHIRD
         RPo6LCUcd4Re+0kgY96DXSQLu25EmDY+aHuLydwGWT++ob/8C1O+eccFMHE4BnyUVLDN
         aggT/w4W9K0oIVQv51zFGf7T0N2LrJm4lYqMMnpmRn9sUp0PPJDAgxyahBj9cyJam2Hw
         7pPSWUPWwMnEz4n3/Y/2l9pfjwRh07g2+1F79M5j29pMG/MuyDV9ZCaM+Y0EbpFGMwFk
         IJ4TtT/IA4I23kVFroiJ+s9T4dw8Tk5VDhRpazi2Qf6O4QtSPHEFOJEYsenC/5/ogr5Q
         /E4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731009394; x=1731614194;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zBP9cQn+CUeDWqPutci2y0fBryOwyk4gwuh+LOyRfGQ=;
        b=M7kC/FvWqYNOWAbI9jx2DODpyOiyQGCHIXUZAfIzRIMkYqEElNZY0smIT6edkGAS4Y
         Z9dXeS8z1nIcxCQcw7IDXOT/k8apupolD0Vl3PzOzqOImZyr5k93Qfs8ZTlOZ/xMkH/c
         Uw4ieUeyAYTfQu6nKvZagTBYpfN6xduSAecWL6Wk75YL6fqdK/NJ6dCAU0EI5HcbhZ6f
         XvcT4+s+msU7HgQxxsr5Ek6I5KroOwTqIQA+Riv+nDbGMIC/omDymmpmN2iTxmflejyj
         eB5fqaBU4oNrI3tQ6Lj4XXad2SPmJJrhgurhaFyGvJMxdMjZPu85wDAgo0vZEtMwLamV
         o+Gg==
X-Forwarded-Encrypted: i=1; AJvYcCW6lzd3e4ZhJUjN4LMzW7+7CjHHgwl2mqHGeWjzwhcC8+ebdGnY2jV0C6pcqbFkLUhiFgk=@vger.kernel.org
X-Gm-Message-State: AOJu0YwtXqvJCOSQRAdhNVC49XYX/qUkPPQ1vA49s3pMkkEAnMCTQIKt
	a9I670XxhD/6rOpmIpS/ZWyq09k0Xw0rHG+0AAwjbj5/PDV833VzndGV8GtQaijfciJxecFZRYZ
	G4Q==
X-Google-Smtp-Source: AGHT+IHGhu8mNxNsq1le3Y88bQEMRwpMbJOW7Gcai6EHqyvmqmAaHws+50k8OfTLl4697j16Z9tv7t+ZxG8=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a0d:ef05:0:b0:6ea:881b:b545 with SMTP id
 00721157ae682-6eade535166mr647b3.4.1731009394112; Thu, 07 Nov 2024 11:56:34
 -0800 (PST)
Date: Thu, 7 Nov 2024 11:56:32 -0800
In-Reply-To: <Zy0QFhFsICeNt8kF@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241107094000.70705-1-eric.auger@redhat.com> <20241107094000.70705-3-eric.auger@redhat.com>
 <Zyz_KGtoXt0gnMM8@google.com> <Zy0QFhFsICeNt8kF@linux.dev>
Message-ID: <Zy0bcM0m-N18gAZz@google.com>
Subject: Re: [PATCH  2/3] KVM: selftests: Introduce kvm_vm_dead_free
From: Sean Christopherson <seanjc@google.com>
To: Oliver Upton <oliver.upton@linux.dev>
Cc: Eric Auger <eric.auger@redhat.com>, eric.auger.pro@gmail.com, broonie@kernel.org, 
	maz@kernel.org, kvmarm@lists.linux.dev, kvm@vger.kernel.org, 
	joey.gouly@arm.com, shuah@kernel.org, pbonzini@redhat.com
Content-Type: text/plain; charset="us-ascii"

On Thu, Nov 07, 2024, Oliver Upton wrote:
> On Thu, Nov 07, 2024 at 09:55:52AM -0800, Sean Christopherson wrote:
> > On Thu, Nov 07, 2024, Eric Auger wrote:
> > > In case a KVM_REQ_VM_DEAD request was sent to a VM, subsequent
> > > KVM ioctls will fail and cause test failure. This now happens
> > > with an aarch64 vgic test where the kvm_vm_free() fails. Let's
> > > add a new kvm_vm_dead_free() helper that does all the deallocation
> > > besides the KVM_SET_USER_MEMORY_REGION2 ioctl.
> > 
> > Please no.  I don't want to bleed the kvm->vm_dead behavior all over selftests.
> > The hack in __TEST_ASSERT_VM_VCPU_IOCTL() is there purely to provide users with
> > a more helpful error message, it is most definitely not intended to be an "official"
> > way to detect and react to the VM being dead.
> > 
> > IMO, tests that intentionally result in a dead VM should assert that subsequent
> > VM/vCPU ioctls return -EIO, and that's all.  Attempting to gracefully free
> > resources adds complexity and pollutes the core selftests APIs, with very little
> > benefit.
> 
> Encouraging tests to explicitly leak resources to fudge around assertions
> in the selftests library seems off to me.

I don't disagree, but I really, really don't want to add vm_dead().

> IMO, the better approach would be to provide a helper that gives the
> impression of freeing the VM but implicitly leaks it, paired with some
> reasoning for it.

Actually, duh.  There's no need to manually delete KVM memslots for *any* VM,
dead or alive.  Just skip that unconditionally when freeing the VM, and then the
vGIC test just needs to assert on -EIO instead -ENXIO/-EBUSY.

---
From: Sean Christopherson <seanjc@google.com>
Date: Thu, 7 Nov 2024 11:39:59 -0800
Subject: [PATCH] KVM: selftests: Don't bother deleting memslots in KVM when
 freeing VMs

When freeing a VM, don't call into KVM to manually remove each memslot,
simply cleanup and free any userspace assets associated with the memory
region.  KVM is ultimately responsible for ensuring kernel resources are
freed when the VM is destroyed, deleting memslots one-by-one is
unnecessarily slow, and unless a test is already leaking the VM fd, the
VM will be destroyed when kvm_vm_release() is called.

Not deleting KVM's memslot also allows cleaning up dead VMs without having
to care whether or not the to-be-freed VM is dead or alive.

Reported-by: Eric Auger <eric.auger@redhat.com>
Reported-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/lib/kvm_util.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 6b3161a0990f..33fefeb3ca44 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -720,9 +720,6 @@ static void __vm_mem_region_delete(struct kvm_vm *vm,
 	rb_erase(&region->hva_node, &vm->regions.hva_tree);
 	hash_del(&region->slot_node);
 
-	region->region.memory_size = 0;
-	vm_ioctl(vm, KVM_SET_USER_MEMORY_REGION2, &region->region);
-
 	sparsebit_free(&region->unused_phy_pages);
 	sparsebit_free(&region->protected_phy_pages);
 	ret = munmap(region->mmap_start, region->mmap_size);
@@ -1197,7 +1194,12 @@ void vm_mem_region_move(struct kvm_vm *vm, uint32_t slot, uint64_t new_gpa)
  */
 void vm_mem_region_delete(struct kvm_vm *vm, uint32_t slot)
 {
-	__vm_mem_region_delete(vm, memslot2region(vm, slot));
+	struct userspace_mem_region *region = memslot2region(vm, slot);
+
+	region->region.memory_size = 0;
+	vm_ioctl(vm, KVM_SET_USER_MEMORY_REGION2, &region->region);
+
+	__vm_mem_region_delete(vm, region);
 }
 
 void vm_guest_mem_fallocate(struct kvm_vm *vm, uint64_t base, uint64_t size,

base-commit: c88416ba074a8913cf6d61b789dd834bbca6681c
-- 


> > Marking a VM dead should be a _very_ rare event; it's not something that I think
> > we should encourage, i.e. we shouldn't make it easier to deal with.  Ideally,
> > use of kvm_vm_dead() should be limited to things like sev_vm_move_enc_context_from(),
> > where KVM needs to prever accessing the source VM to protect the host.  IMO, the
> > vGIC case and x86's enter_smm() are hacks.  E.g. I don't see any reason why the
> > enter_smm() case can't synthesize a triple fault.
> 
> The VGIC case is at least better than the alternative of slapping
> bandaids all over the shop to cope with a half-baked VM and ensure we
> tear it down correctly. Userspace is far up shit creek at the point the
> VM is marked as dead, so I don't see any value in hobbling along
> afterwards.

Again, I don't disagree, but I don't want to normalize shooting the VM on errors.

