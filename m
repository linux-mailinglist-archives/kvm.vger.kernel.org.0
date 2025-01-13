Return-Path: <kvm+bounces-35296-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0096EA0BC24
	for <lists+kvm@lfdr.de>; Mon, 13 Jan 2025 16:36:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0EB53163FEB
	for <lists+kvm@lfdr.de>; Mon, 13 Jan 2025 15:36:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0D1B21C5D6A;
	Mon, 13 Jan 2025 15:35:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KZ/4OyvG"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30389240225;
	Mon, 13 Jan 2025 15:35:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736782552; cv=none; b=GXBs65q7rnV80fB5e6NHeD1U4+IpZ291pSJyBz423ebIH1MJsoJxBdkMhOgB63gyyAxZGdbg0o2diLbvhriGTQ+fM558aTVZL6Q2Rof6J/YDyb0yIkBxqF77bjGXVpvIXvjZg97TJuUdwpXZ/y+9ZeZgIO6JvQqQCr+VVUEdrOw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736782552; c=relaxed/simple;
	bh=kflShctdzzNw+IkBOi2kw5ELJr3LYgkxoxHIz8+7Vak=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=r/x668vD+sxPE2TrgiDPjhuhELC9Jwkgnpx6UO7ImcaLl8HaQiVifkQAymxGvTAejdpzfJ0Yy5OSPtsLAjxL01DDd75ZA4pJqaF4qZw0+QuJWsmsnoB1p/ebcErFtE/ziWd/JR8bjncLwAaN/MMBqvsOLSr4SxZHy2y+Vmf7tdE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KZ/4OyvG; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BE6BC4CEE2;
	Mon, 13 Jan 2025 15:35:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1736782551;
	bh=kflShctdzzNw+IkBOi2kw5ELJr3LYgkxoxHIz8+7Vak=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=KZ/4OyvG0iqsSepxnR8n3z4mifQILsCZp1IOhJm6FtjsPlQVQfc3QVejhRYyTV/So
	 kdVmYXnIPHhWgH2bwX8aFQFdYqmx3yI5EgM8qmVUKGFCCvLlEik8sxToryv4nQaQlf
	 sA7Op8ZxRbD4RUeQENzZSODtEFFPjfvDO0KY+MGPiGkkbAFTOjaLX9EDdevY/IKXXT
	 LfjUE0Q46KyQT2U88Ngh+hP+q1D+L6rfTZARBoa5jenzEcAeNFEv5pC+UZGNcPnCyO
	 35d3PR8EaEzKD+RCiMzFXbfYH/PvVpxxfMte/dFScFUmRUWsTcbWb+40Iys0sJLPgH
	 /D+7cEmQefpSw==
Date: Mon, 13 Jan 2025 08:35:49 -0700
From: Keith Busch <kbusch@kernel.org>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
	michael.christie@oracle.com, Tejun Heo <tj@kernel.org>,
	Luca Boccassi <bluca@debian.org>
Subject: Re: [PATCH] KVM: x86: switch hugepage recovery thread to vhost_task
Message-ID: <Z4Uy1beVh78KoBqN@kbusch-mbp>
References: <20241108130737.126567-1-pbonzini@redhat.com>
 <Z2RYyagu3phDFIac@kbusch-mbp.dhcp.thefacebook.com>
 <fdb5aac8-a657-40ec-9e0b-5340bc144b7b@redhat.com>
 <Z2RhNcJbP67CRqaM@kbusch-mbp.dhcp.thefacebook.com>
 <CABgObfYUztpGfBep4ewQXUVJ2vqG_BLrn7c19srBoiXbV+O3+w@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CABgObfYUztpGfBep4ewQXUVJ2vqG_BLrn7c19srBoiXbV+O3+w@mail.gmail.com>

On Thu, Dec 19, 2024 at 09:30:16PM +0100, Paolo Bonzini wrote:
> On Thu, Dec 19, 2024 at 7:09 PM Keith Busch <kbusch@kernel.org> wrote:
> > > Is crosvm trying to do anything but exec?  If not, it should probably use the
> > > flag.
> >
> > Good point, and I'm not sure right now. I don't think I know any crosvm
> > developer experts but I'm working on that to get a better explanation of
> > what's happening,
> 
> Ok, I found the code and it doesn't exec (e.g.
> https://github.com/google/crosvm/blob/b339d3d7/src/crosvm/sys/linux/jail_warden.rs#L122),
> so that's not an option. Well, if I understand correctly from a
> cursory look at the code, crosvm is creating a jailed child process
> early, and then spawns further jails through it; so it's just this
> first process that has to cheat.
> 
> One possibility on the KVM side is to delay creating the vhost_task
> until the first KVM_RUN. I don't like it but...

This option is actually kind of appealing in that we don't need to
change any application side to filter out kernel tasks, as well as not
having a new kernel dependency to even report these types of tasks as
kernel threads.

I gave it a quick try. I'm not very familiar with the code here, so not
sure if this is thread safe or not, but it did successfully get crosvm
booting again.

---
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 2401606db2604..422b6b06de4fe 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -7415,6 +7415,8 @@ int kvm_mmu_post_init_vm(struct kvm *kvm)
 {
 	if (nx_hugepage_mitigation_hard_disabled)
 		return 0;
+	if (kvm->arch.nx_huge_page_recovery_thread)
+		return 0;
 
 	kvm->arch.nx_huge_page_last = get_jiffies_64();
 	kvm->arch.nx_huge_page_recovery_thread = vhost_task_create(
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index c79a8cc57ba42..263363c46626b 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -11463,6 +11463,10 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 	struct kvm_run *kvm_run = vcpu->run;
 	int r;
 
+	r = kvm_mmu_post_init_vm(vcpu->kvm);
+	if (r)
+		return r;
+
 	vcpu_load(vcpu);
 	kvm_sigset_activate(vcpu);
 	kvm_run->flags = 0;
@@ -12740,11 +12744,6 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 	return ret;
 }
 
-int kvm_arch_post_init_vm(struct kvm *kvm)
-{
-	return kvm_mmu_post_init_vm(kvm);
-}
-
 static void kvm_unload_vcpu_mmu(struct kvm_vcpu *vcpu)
 {
 	vcpu_load(vcpu);
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 401439bb21e3e..a219bd2d8aec8 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1596,7 +1596,6 @@ int kvm_arch_vcpu_should_kick(struct kvm_vcpu *vcpu);
 bool kvm_arch_dy_runnable(struct kvm_vcpu *vcpu);
 bool kvm_arch_dy_has_pending_interrupt(struct kvm_vcpu *vcpu);
 bool kvm_arch_vcpu_preempted_in_kernel(struct kvm_vcpu *vcpu);
-int kvm_arch_post_init_vm(struct kvm *kvm);
 void kvm_arch_pre_destroy_vm(struct kvm *kvm);
 void kvm_arch_create_vm_debugfs(struct kvm *kvm);
 
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index de2c11dae2316..adacc6eaa7d9d 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1065,15 +1065,6 @@ static int kvm_create_vm_debugfs(struct kvm *kvm, const char *fdname)
 	return ret;
 }
 
-/*
- * Called after the VM is otherwise initialized, but just before adding it to
- * the vm_list.
- */
-int __weak kvm_arch_post_init_vm(struct kvm *kvm)
-{
-	return 0;
-}
-
 /*
  * Called just after removing the VM from the vm_list, but before doing any
  * other destruction.
@@ -1194,10 +1185,6 @@ static struct kvm *kvm_create_vm(unsigned long type, const char *fdname)
 	if (r)
 		goto out_err_no_debugfs;
 
-	r = kvm_arch_post_init_vm(kvm);
-	if (r)
-		goto out_err;
-
 	mutex_lock(&kvm_lock);
 	list_add(&kvm->vm_list, &vm_list);
 	mutex_unlock(&kvm_lock);
@@ -1207,8 +1194,6 @@ static struct kvm *kvm_create_vm(unsigned long type, const char *fdname)
 
 	return kvm;
 
-out_err:
-	kvm_destroy_vm_debugfs(kvm);
 out_err_no_debugfs:
 	kvm_coalesced_mmio_free(kvm);
 out_no_coalesced_mmio:
--

