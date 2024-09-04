Return-Path: <kvm+bounces-25912-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C558C96C94E
	for <lists+kvm@lfdr.de>; Wed,  4 Sep 2024 23:11:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EAD351C255E1
	for <lists+kvm@lfdr.de>; Wed,  4 Sep 2024 21:11:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 42DA7156225;
	Wed,  4 Sep 2024 21:08:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CEksFbgQ"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6308913D516;
	Wed,  4 Sep 2024 21:08:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725484113; cv=none; b=VB0IkpWGpZ7XwBsxmKZL32cCzuukZ/TtjaJL8SafcbEFH/MYT7rqctb2XqNNIEgE7f53BeqbG1biTCdVkke2z11NNCMbSFfwKw/yj3J9VGy0Je9/zjxvT7BeAubdOgJvNcxrb6a0knlhTCkrc7rsiBRaVw8ncRotTdIWiU13uzc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725484113; c=relaxed/simple;
	bh=j39n7HMXYSdWvCK+sacpXRMJepgp+GKhtUwav+NXleA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JFTdWnAaPXx7fqC54+SLVRY3JM+zAp0fVSky7YBnXBJZ7NGuCxySiB/ww+F+sF5YtTKtzqGWnKZP8V6/Gfg3+87nT+lFmKN+bJ41MjbrtwKnMHwYenN2CltLfqEjdTNPowGeVKVXERezs3VjJ+FURsUdm2CuJqqwG/r6Ky4eUj8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CEksFbgQ; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6463EC4CEC2;
	Wed,  4 Sep 2024 21:08:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725484112;
	bh=j39n7HMXYSdWvCK+sacpXRMJepgp+GKhtUwav+NXleA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=CEksFbgQZObZLDnqWJkwWCj0+wXpAN4FFzwndFABiKSNtYHdHb6BNlmVVhf3cZg40
	 MsCEUJStaXtasB2CJVScv2P1KR4w78YEpqcIqiyNb2H174B9z+8LDQFOGAIG7Q6Rh0
	 xfVxK300sSeAYRgj4y5Q7Wrc31YB2Fn6kT6hlROZjCEu/kWbMJk/GolQVXgbfDJSj3
	 za+pzJJWvsZZP9Q45feH4udETnBsEGNgFA9yTnXnlmW3bfq05gXz21UByX7HfnMqiB
	 3wUHJpYNpeApqLJ/unnnZruAI59JA44c7mqBWRGzn+/lFbpfLCv1OAvqJFd6bdvp9G
	 V+7NCiEc2MyQg==
Date: Wed, 4 Sep 2024 14:08:30 -0700
From: Nathan Chancellor <nathan@kernel.org>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, Chao Gao <chao.gao@intel.com>,
	Zeng Guang <guang.zeng@intel.com>
Subject: Re: [PATCH 1/6] KVM: nVMX: Get to-be-acknowledge IRQ for nested
 VM-Exit at injection site
Message-ID: <20240904210830.GA1229985@thelio-3990X>
References: <20240720000138.3027780-1-seanjc@google.com>
 <20240720000138.3027780-2-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240720000138.3027780-2-seanjc@google.com>

Hi Sean,

On Fri, Jul 19, 2024 at 05:01:33PM -0700, Sean Christopherson wrote:
> Move the logic to get the to-be-acknowledge IRQ for a nested VM-Exit from
> nested_vmx_vmexit() to vmx_check_nested_events(), which is subtly the one
> and only path where KVM invokes nested_vmx_vmexit() with
> EXIT_REASON_EXTERNAL_INTERRUPT.  A future fix will perform a last-minute
> check on L2's nested posted interrupt notification vector, just before
> injecting a nested VM-Exit.  To handle that scenario correctly, KVM needs
> to get the interrupt _before_ injecting VM-Exit, as simply querying the
> highest priority interrupt, via kvm_cpu_has_interrupt(), would result in
> TOCTOU bug, as a new, higher priority interrupt could arrive between
> kvm_cpu_has_interrupt() and kvm_cpu_get_interrupt().
> 
> Opportunistically convert the WARN_ON() to a WARN_ON_ONCE().  If KVM has
> a bug that results in a false positive from kvm_cpu_has_interrupt(),
> spamming dmesg won't help the situation.
> 
> Note, nested_vmx_reflect_vmexit() can never reflect external interrupts as
> they are always "wanted" by L0.
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/vmx/nested.c | 25 ++++++++++++++++---------
>  1 file changed, 16 insertions(+), 9 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index 2392a7ef254d..b3e17635f7e3 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -4284,11 +4284,26 @@ static int vmx_check_nested_events(struct kvm_vcpu *vcpu)
>  	}
>  
>  	if (kvm_cpu_has_interrupt(vcpu) && !vmx_interrupt_blocked(vcpu)) {
> +		u32 exit_intr_info;
> +
>  		if (block_nested_events)
>  			return -EBUSY;
>  		if (!nested_exit_on_intr(vcpu))
>  			goto no_vmexit;
> -		nested_vmx_vmexit(vcpu, EXIT_REASON_EXTERNAL_INTERRUPT, 0, 0);
> +
> +		if (nested_exit_intr_ack_set(vcpu)) {
> +			int irq;
> +
> +			irq = kvm_cpu_get_interrupt(vcpu);
> +			WARN_ON_ONCE(irq < 0);
> +
> +			exit_intr_info = INTR_INFO_VALID_MASK | INTR_TYPE_EXT_INTR | irq;
> +		} else {
> +			exit_intr_info = 0;
> +		}
> +
> +		nested_vmx_vmexit(vcpu, EXIT_REASON_EXTERNAL_INTERRUPT,
> +				  exit_intr_info, 0);
>  		return 0;
>  	}
>  
> @@ -4969,14 +4984,6 @@ void nested_vmx_vmexit(struct kvm_vcpu *vcpu, u32 vm_exit_reason,
>  	vcpu->arch.mp_state = KVM_MP_STATE_RUNNABLE;
>  
>  	if (likely(!vmx->fail)) {
> -		if ((u16)vm_exit_reason == EXIT_REASON_EXTERNAL_INTERRUPT &&
> -		    nested_exit_intr_ack_set(vcpu)) {
> -			int irq = kvm_cpu_get_interrupt(vcpu);
> -			WARN_ON(irq < 0);
> -			vmcs12->vm_exit_intr_info = irq |
> -				INTR_INFO_VALID_MASK | INTR_TYPE_EXT_INTR;
> -		}
> -
>  		if (vm_exit_reason != -1)
>  			trace_kvm_nested_vmexit_inject(vmcs12->vm_exit_reason,
>  						       vmcs12->exit_qualification,
> -- 
> 2.45.2.1089.g2a221341d9-goog
> 

I bisected (log below) an issue with starting a nested guest that
appears on two of my newer Intel test machines (but not a somewhat old
laptop) when this change as commit 6f373f4d941b ("KVM: nVMX: Get
to-be-acknowledge IRQ for nested VM-Exit at injection site") in -next is
present in the host kernel.

I start a virtual machine with a full distribution using QEMU then start
a nested virtual machine using QEMU with the same kernel and a much
simpler Buildroot initrd, just to test the ability to run a nested
guest. After this change, starting a nested guest results in no output
from the nested guest and eventually the first guest restarts, sometimes
printing a lockup message that appears to be caused from qemu-system-x86

My command for the first guest on the host (in case it matters):

  $ qemu-system-x86_64 \
      -display none \
      -serial mon:stdio \
      -nic user,model=virtio-net-pci,hostfwd=tcp::8022-:22 \
      -object rng-random,filename=/dev/urandom,id=rng0 \
      -device virtio-rng-pci \
      -chardev socket,id=char0,path=$VM_FOLDER/x86_64/arch/vfsd.sock \
      -device vhost-user-fs-pci,queue-size=1024,chardev=char0,tag=host \
      -object memory-backend-memfd,id=mem,share=on,size=16G \
      -numa node,memdev=mem \
      -m 16G \
      -device virtio-balloon \
      -smp 8 \
      -drive if=pflash,format=raw,file=$VM_FOLDER/x86_64/arch/efi.img,readonly=on \
      -drive if=pflash,format=raw,file=$VM_FOLDER/x86_64/arch/efi_vars.img \
      -cpu host \
      -enable-kvm \
      -M q35 \
      -drive if=virtio,format=qcow2,file=$VM_FOLDER/x86_64/arch/disk.img

My commands in the first guest to spawn the nested guest:

  $ cd $(mktemp -d)

  $ curl -LSs https://archive.archlinux.org/packages/l/linux/linux-6.10.8.arch1-1-x86_64.pkg.tar.zst | tar --zstd -xf -

  $ curl -LSs https://github.com/ClangBuiltLinux/boot-utils/releases/download/20230707-182910/x86_64-rootfs.cpio.zst | zstd -d >rootfs.cpio

  $ qemu-system-x86_64 \
      -display none \
      -nodefaults \
      -M q35 \
      -d unimp,guest_errors \
      -append 'console=ttyS0 earlycon=uart8250,io,0x3f8 loglevel=7' \
      -kernel usr/lib/modules/6.10.8-arch1-1/vmlinuz \
      -initrd rootfs.cpio \
      -cpu host \
      -enable-kvm \
      -m 512m \
      -smp 8 \
      -serial mon:stdio

If there is any additional information I can provide or patches I can
test, I am more than happy to do so.

Cheers,
Nathan

# bad: [6804f0edbe7747774e6ae60f20cec4ee3ad7c187] Add linux-next specific files for 20240903
# good: [67784a74e258a467225f0e68335df77acd67b7ab] Merge tag 'ata-6.11-rc7' of git://git.kernel.org/pub/scm/linux/kernel/git/libata/linux
git bisect start '6804f0edbe7747774e6ae60f20cec4ee3ad7c187' '67784a74e258a467225f0e68335df77acd67b7ab'
# good: [6b63f16410fa86f6a2e9f52c9cb52ba94c363f3e] Merge branch 'master' of git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth-next.git
git bisect good 6b63f16410fa86f6a2e9f52c9cb52ba94c363f3e
# good: [194eaf7dd63eef7cee974daeb4df01a3e6b144fe] Merge branch 'for-next' of git://git.kernel.org/pub/scm/linux/kernel/git/sre/linux-power-supply.git
git bisect good 194eaf7dd63eef7cee974daeb4df01a3e6b144fe
# bad: [a8f65643f59dac67451d09ff298fa7f6e7917794] Merge branch 'next' of git://git.kernel.org/pub/scm/linux/kernel/git/westeri/thunderbolt.git
git bisect bad a8f65643f59dac67451d09ff298fa7f6e7917794
# good: [f80eff5b9f33c4f8d86ba046f3ee54c4f2224454] Merge branch 'timers/drivers/next' of https://git.linaro.org/people/daniel.lezcano/linux.git
git bisect good f80eff5b9f33c4f8d86ba046f3ee54c4f2224454
# bad: [a93e40d038ccd17e6cf691e1b8fec8821998baf2] Merge branch 'for-next' of git://git.kernel.org/pub/scm/linux/kernel/git/dennis/percpu.git
git bisect bad a93e40d038ccd17e6cf691e1b8fec8821998baf2
# good: [500b6c92524183f97e3a3c8e6c56f8af69429ba4] Merge branch 'non-rcu/next' of git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-rcu.git
git bisect good 500b6c92524183f97e3a3c8e6c56f8af69429ba4
# bad: [642613182efa0927c8bd4d4ef2c6b8350554b6ad] Merge branches 'fixes', 'generic', 'misc', 'mmu', 'pat_vmx_msrs', 'selftests', 'svm' and 'vmx'
git bisect bad 642613182efa0927c8bd4d4ef2c6b8350554b6ad
# good: [1876dd69dfe8c29e249070b0e4dc941fc15ac1e4] KVM: x86: Add fastpath handling of HLT VM-Exits
git bisect good 1876dd69dfe8c29e249070b0e4dc941fc15ac1e4
# bad: [44518120c4ca569cfb9c6199e94c312458dc1c07] KVM: nVMX: Detect nested posted interrupt NV at nested VM-Exit injection
git bisect bad 44518120c4ca569cfb9c6199e94c312458dc1c07
# good: [2ab637df5f68d4e0cfa9becd10f43400aee785b3] KVM: VMX: hyper-v: Prevent impossible NULL pointer dereference in evmcs_load()
git bisect good 2ab637df5f68d4e0cfa9becd10f43400aee785b3
# bad: [f729851189d5741e7d1059e250422611028657f8] KVM: x86: Don't move VMX's nested PI notification vector from IRR to ISR
git bisect bad f729851189d5741e7d1059e250422611028657f8
# bad: [cb14e454add0efc9bc461c1ad30d9c950c406fab] KVM: nVMX: Suppress external interrupt VM-Exit injection if there's no IRQ
git bisect bad cb14e454add0efc9bc461c1ad30d9c950c406fab
# bad: [6f373f4d941bf79f06e9abd4a827288ad1de6399] KVM: nVMX: Get to-be-acknowledge IRQ for nested VM-Exit at injection site
git bisect bad 6f373f4d941bf79f06e9abd4a827288ad1de6399
# first bad commit: [6f373f4d941bf79f06e9abd4a827288ad1de6399] KVM: nVMX: Get to-be-acknowledge IRQ for nested VM-Exit at injection site

