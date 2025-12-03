Return-Path: <kvm+bounces-65202-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 4D9A1C9F100
	for <lists+kvm@lfdr.de>; Wed, 03 Dec 2025 14:07:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 0EC333471D7
	for <lists+kvm@lfdr.de>; Wed,  3 Dec 2025 13:07:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6AFD92EFD9C;
	Wed,  3 Dec 2025 13:07:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nghZQGWr"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 838062D7388;
	Wed,  3 Dec 2025 13:07:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764767254; cv=none; b=aaPx9SEPG625sHPYURDaDL4RvFdWepXVdWjJuPenLaiveIjzfYg9Umk97swqwEkeMkdlcE+fU0ucc+UkcusCGVnAG5dWavFEsFABPz3EvP+hP/WTZCZCmgZn7SHChEd05Tg9sphX60V2owUOvOBhPYScUZ76tyURFKKJ3kihOBY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764767254; c=relaxed/simple;
	bh=koIqVoPCNoSSBELSuKez6+jsD0Huo5gXJNd6cEO+SQU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bM/siW2TZsO1ulLgOfAEtqh5PD7JyR4E6DGvDEmGFdTp+KG3Ung6xQo0vjWR7FqbeDNVXiIw4EdxeeqJ5VdpTXp84tYydeNP+VO6f8/8F/v6TiC/iVb3tlDHQ23PfDClgYjrfv7japx1cEcjfRZixowXX9rgA10P93OdDrLeWfg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nghZQGWr; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FB54C4CEFB;
	Wed,  3 Dec 2025 13:07:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764767254;
	bh=koIqVoPCNoSSBELSuKez6+jsD0Huo5gXJNd6cEO+SQU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=nghZQGWrVfRJDfhj52HGuxi1cpXSY3rAPbzxCPNLT94Rn87O16TS+Fyh9b3p8uj+P
	 gntB3TxDuWFQH6Mn3UMOhVrZz5KUZN3H7zfqP8ZdVIz1Jzxf4s6YEMeQ4yDfVFs737
	 o/ILkJhghS3cCRexsWwHwgja84Zo785bxowNq77UO6X/JGtTsbgI600Y1GAADOAbmR
	 3RfppgE95PQMOWfAh1AQkmA50Ij00u+SZNksSmFsT+njoekRqg9tqN53eiwW0hdyK2
	 6fYqbNSborzZuz6pbtZ8Xm8i2LPU0onopDp9SQ/hlcSVbyNzCdLMFXjYH1YToKSkIM
	 e4GGUBM8uJfJA==
Date: Wed, 3 Dec 2025 18:34:29 +0530
From: Naveen N Rao <naveen@kernel.org>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Peter Gonda <pgonda@google.com>, 
	Michael Roth <michael.roth@amd.com>, Vishal Annapurve <vannapurve@google.com>, 
	Ackerly Tng <ackerleytng@google.com>, Nikunj A Dadhania <nikunj@amd.com>, 
	Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [PATCH 01/22] KVM: x86: Disallow read-only memslots for SEV-ES
 and SEV-SNP (and TDX)
Message-ID: <fcqjl5a7m27f2mfpblnhgmozbipdjmvpdyk3m5hhzwcenp4cpg@m2ooa7ykrcvs>
References: <20240809190319.1710470-1-seanjc@google.com>
 <20240809190319.1710470-2-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240809190319.1710470-2-seanjc@google.com>

Hi Sean,

On Fri, Aug 09, 2024 at 12:02:58PM -0700, Sean Christopherson wrote:
> Disallow read-only memslots for SEV-{ES,SNP} VM types, as KVM can't
> directly emulate instructions for ES/SNP, and instead the guest must
> explicitly request emulation.  Unless the guest explicitly requests
> emulation without accessing memory, ES/SNP relies on KVM creating an MMIO
> SPTE, with the subsequent #NPF being reflected into the guest as a #VC.
> 
> But for read-only memslots, KVM deliberately doesn't create MMIO SPTEs,
> because except for ES/SNP, doing so requires setting reserved bits in the
> SPTE, i.e. the SPTE can't be readable while also generating a #VC on
> writes.  Because KVM never creates MMIO SPTEs and jumps directly to
> emulation, the guest never gets a #VC.  And since KVM simply resumes the
> guest if ES/SNP guests trigger emulation, KVM effectively puts the vCPU
> into an infinite #NPF loop if the vCPU attempts to write read-only memory.
> 
> Disallow read-only memory for all VMs with protected state, i.e. for
> upcoming TDX VMs as well as ES/SNP VMs.  For TDX, it's actually possible
> to support read-only memory, as TDX uses EPT Violation #VE to reflect the
> fault into the guest, e.g. KVM could configure read-only SPTEs with RX
> protections and SUPPRESS_VE=0.  But there is no strong use case for
> supporting read-only memslots on TDX, e.g. the main historical usage is
> to emulate option ROMs, but TDX disallows executing from shared memory.
> And if someone comes along with a legitimate, strong use case, the
> restriction can always be lifted for TDX.
> 
> Don't bother trying to retroactively apply the restriction to SEV-ES
> VMs that are created as type KVM_X86_DEFAULT_VM.  Read-only memslots can't
> possibly work for SEV-ES, i.e. disallowing such memslots is really just
> means reporting an error to userspace instead of silently hanging vCPUs.
> Trying to deal with the ordering between KVM_SEV_INIT and memslot creation
> isn't worth the marginal benefit it would provide userspace.
> 
> Fixes: 26c44aa9e076 ("KVM: SEV: define VM types for SEV and SEV-ES")
> Fixes: 1dfe571c12cf ("KVM: SEV: Add initial SEV-SNP support")
> Cc: Peter Gonda <pgonda@google.com>
> Cc: Michael Roth <michael.roth@amd.com>
> Cc: Vishal Annapurve <vannapurve@google.com>
> Cc: Ackerly Tng <ackerleytng@google.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/include/asm/kvm_host.h | 2 ++
>  include/linux/kvm_host.h        | 7 +++++++
>  virt/kvm/kvm_main.c             | 5 ++---
>  3 files changed, 11 insertions(+), 3 deletions(-)

As discussed in one of the previous PUCK calls, this is causing Qemu to 
throw an error when trying to enable debug-swap for a SEV-ES guest when 
using a pflash drive for OVMF. Sample qemu invocation (*):
  qemu-system-x86_64 ... \
    -drive if=pflash,format=raw,unit=0,file=/path/to/OVMF_CODE.fd,readonly=on \
    -drive if=pflash,format=raw,unit=1,file=/path/to/OVMF_VARS.fd \
    -machine q35,confidential-guest-support=sev0 \
    -object sev-guest,id=sev0,policy=0x5,cbitpos=51,reduced-phys-bits=1,debug-swap=on

This is expected since enabling debug-swap requires use of 
KVM_SEV_INIT2, which implies a VM type of KVM_X86_SEV_ES_VM. However, 
SEV-ES VMs that do not enable any VMSA SEV features (and are hence 
KVM_X86_DEFAULT_VM type) are allowed to continue to launch though they 
are also susceptible to this issue.

One of the suggestions in the call was to consider returning an error to 
userspace instead. Is this close to what you had in mind:

diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index 73cdcbccc89e..19e27ed27e17 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -387,8 +387,10 @@ static inline int kvm_mmu_do_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
         * they can fix it by changing memory to shared, or they can
         * provide a better error.
         */
-       if (r == RET_PF_EMULATE && fault.is_private) {
-               pr_warn_ratelimited("kvm: unexpected emulation request on private memory\n");
+       if (r == RET_PF_EMULATE && (fault.is_private ||
+           (!fault.map_writable && fault.write && vcpu->arch.guest_state_protected))) {
+               if (fault.is_private)
+                       pr_warn_ratelimited("kvm: unexpected emulation request on private memory\n");
                kvm_mmu_prepare_memory_fault_exit(vcpu, &fault);
                return -EFAULT;
        }

This seems to work though Qemu seems to think we are asking it to 
convert the memory to shared (so we probably need to signal this error 
some other way?):
  qemu-system-x86_64: Convert non guest_memfd backed memory region (0xf0000 ,+ 0x1000) to shared

Thoughts?


Thanks,
Naveen

--
(*) This requires below patches for Qemu, unless using IGVM:
https://lore.kernel.org/qemu-devel/cover.1761648149.git.naveen@kernel.org/


