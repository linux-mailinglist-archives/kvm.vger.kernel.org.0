Return-Path: <kvm+bounces-16903-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 802518BEB14
	for <lists+kvm@lfdr.de>; Tue,  7 May 2024 20:05:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 36B7B287CD9
	for <lists+kvm@lfdr.de>; Tue,  7 May 2024 18:05:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B701816D319;
	Tue,  7 May 2024 18:05:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="htFkgRkH"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1FD216C870
	for <kvm@vger.kernel.org>; Tue,  7 May 2024 18:05:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715105109; cv=none; b=uf3WNAnXEATJS3l9zhfgT4yjj0Abu1NIFyspF9GA0y4iL1mpNgktlOcnKl+liYb0KdGj6yoGUh0iyaGZ5sscQZNG1pzo1Zp1KeZdwW18szSiXwBAIwM/NoboYBKR6HpHmYUB6U/usGLg/2BDfL1gI4W3c0UjRIWkErG68v9/qbo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715105109; c=relaxed/simple;
	bh=l3V+S602q7cDQcY4RJE4Wto4FM5wKpnL8UmOgtoTOj0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=MQa/08Gce6JHX0v3IrXozEsVg/C1KrJJ4xYaSueJZ2rbDvu79Sm+xk4KZtrx7SsIbpgcP1U9na/4S1Q8HQJs3zkKj+JjZPo4PnqSBq403VwfiF/di9VJegwGH5ye1Ns2crBGY6WGCPl8Dti/ZTWj0DbzJQjrs6lZLH11e8MoAEY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=htFkgRkH; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1715105106;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2ZvOghE1Dhea0BipflZ72Ub6RjTb1rByhCbKR7I/+Ms=;
	b=htFkgRkHsF4zP9KZJIJB4UuejQOE6C0KTjzv4sFJWx1NOffz2WuUdhD0RGxnnkKdxNqWKX
	jykixedhMbxlvEXbAWjepnAoW51MYhg1HYjnfkpX4gCdBtKluHyzgJAB4hhmqgnx+LW9PC
	JkSG5BFWuMNAU8jnINmS75Bb7MxyFtY=
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com
 [209.85.215.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-557-f4lyMoV6M6iMJQo38P6M7g-1; Tue, 07 May 2024 14:05:05 -0400
X-MC-Unique: f4lyMoV6M6iMJQo38P6M7g-1
Received: by mail-pg1-f199.google.com with SMTP id 41be03b00d2f7-5cfd6ba1c11so3237588a12.0
        for <kvm@vger.kernel.org>; Tue, 07 May 2024 11:05:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715105104; x=1715709904;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2ZvOghE1Dhea0BipflZ72Ub6RjTb1rByhCbKR7I/+Ms=;
        b=SEaMrI1tF21U75Uj26oec4oAjiZoOaHQSQXfCfCpdX0Q7bfS4BRBVSlmmRcFaPArnM
         rSqnrKj+yPS3Z89fscUAeLJLFMoczDjkI9+koSOYuhHEB/1CI4M8n0yqHI16mwiXrhbY
         v1HfGQrqAttJ4k/LpW7lRDUIsbVBp7cZfEmYy1YKBgA4nLpBJIZJ7bdCiTcB6nHAcINX
         eMb46eZHA28cmFaXrlg7iJ5MYR6j22h8Tryq14BrrDWHHoFSgxbZYfTW004DeVPoS3/m
         avOHOt8hf9MWf5p4ufoQgAnkjJUUx4UZe+7pwSW6AP3yS1P9HzSz1P5Y9iCIFAGD6a1o
         spMw==
X-Gm-Message-State: AOJu0YxQZBy+VkdXdZa290RL6QagnwuO01pKZWWRWOVq3jax6H9vCk7h
	0vyGTN3YdDS7MCTQtfIFvvzUuuEuGgjfkvF8AOJEBH4UN52RZoGxJGjKv3EeGsCk9MdFRRp5KE0
	UtGqeUkjLR20PNm7hTEhlxUxEv99SAey8T/jn3mCF2F3I6NB5RBk6D9HVD6VZk+kdywuoaZC0NT
	XWV9DlMD5waPZI1IXwNTSMe/KT
X-Received: by 2002:a05:6a20:d04e:b0:1ac:e07f:e3aa with SMTP id adf61e73a8af0-1afc8dea276mr553790637.48.1715105104102;
        Tue, 07 May 2024 11:05:04 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG1z+P+Qf5q1W61ATzl53+/9TWtc+HlbekP6Z4sPSjK7ZdTrpbg/UxZ+v/G7N6UDDHa5mZcOpvw4KQFO9cVYAA=
X-Received: by 2002:a05:6a20:d04e:b0:1ac:e07f:e3aa with SMTP id
 adf61e73a8af0-1afc8dea276mr553714637.48.1715105103540; Tue, 07 May 2024
 11:05:03 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240501085210.2213060-1-michael.roth@amd.com>
In-Reply-To: <20240501085210.2213060-1-michael.roth@amd.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Tue, 7 May 2024 20:04:50 +0200
Message-ID: <CABgObfbvAU-hGzO59x1ucjOGqx0Yor0HovQBNBR2sysngmk4=Q@mail.gmail.com>
Subject: Re: [PATCH v15 00/20] Add AMD Secure Nested Paging (SEV-SNP)
 Hypervisor Support
To: Michael Roth <michael.roth@amd.com>
Cc: kvm@vger.kernel.org, linux-coco@lists.linux.dev, linux-mm@kvack.org, 
	linux-crypto@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org, 
	tglx@linutronix.de, mingo@redhat.com, jroedel@suse.de, 
	thomas.lendacky@amd.com, hpa@zytor.com, ardb@kernel.org, seanjc@google.com, 
	vkuznets@redhat.com, jmattson@google.com, luto@kernel.org, 
	dave.hansen@linux.intel.com, slp@redhat.com, pgonda@google.com, 
	peterz@infradead.org, srinivas.pandruvada@linux.intel.com, 
	rientjes@google.com, dovmurik@linux.ibm.com, tobin@ibm.com, bp@alien8.de, 
	vbabka@suse.cz, kirill@shutemov.name, ak@linux.intel.com, tony.luck@intel.com, 
	sathyanarayanan.kuppuswamy@linux.intel.com, alpergun@google.com, 
	jarkko@kernel.org, ashish.kalra@amd.com, nikunj.dadhania@amd.com, 
	pankaj.gupta@amd.com, liam.merwick@oracle.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, May 1, 2024 at 11:03=E2=80=AFAM Michael Roth <michael.roth@amd.com>=
 wrote:
>
> This patchset is also available at:
>
>   https://github.com/amdese/linux/commits/snp-host-v15
>
> and is based on top of the series:
>
>   "Add SEV-ES hypervisor support for GHCB protocol version 2"
>   https://lore.kernel.org/kvm/20240501071048.2208265-1-michael.roth@amd.c=
om/
>   https://github.com/amdese/linux/commits/sev-init2-ghcb-v1
>
> which in turn is based on commit 20cc50a0410f (just before v14 SNP patche=
s):
>
>   https://git.kernel.org/pub/scm/virt/kvm/kvm.git/log/?h=3Dkvm-coco-queue

I have mostly reviewed this, with the exception of the
snp_begin/complete_psc parts.

I am not sure about removing all the pr_debug() - I am sure it will be
a bit more painful for userspace developers to figure out what exactly
has gone wrong in some cases. But we can add them later, if needed -
I'm certainly not going to make a fuss about it.

Paolo


> Patch Layout
> ------------
>
> 01-02: These patches revert+replace the existing .gmem_validate_fault hoo=
k
>        with a similar .private_max_mapping_level as suggested by Sean[1]
>
> 03-04: These patches add some basic infrastructure and introduces a new
>        KVM_X86_SNP_VM vm_type to handle differences verses the existing
>        KVM_X86_SEV_VM and KVM_X86_SEV_ES_VM types.
>
> 05-07: These implement the KVM API to handle the creation of a
>        cryptographic launch context, encrypt/measure the initial image
>        into guest memory, and finalize it before launching it.
>
> 08-12: These implement handling for various guest-generated events such
>        as page state changes, onlining of additional vCPUs, etc.
>
> 13-16: These implement the gmem/mmu hooks needed to prepare gmem-allocate=
d
>        pages before mapping them into guest private memory ranges as
>        well as cleaning them up prior to returning them to the host for
>        use as normal memory. Because this supplants certain activities
>        like issued WBINVDs during KVM MMU invalidations, there's also
>        a patch to avoid duplicating that work to avoid unecessary
>        overhead.
>
> 17:    With all the core support in place, the patch adds a kvm_amd modul=
e
>        parameter to enable SNP support.
>
> 18-20: These patches all deal with the servicing of guest requests to han=
dle
>        things like attestation, as well as some related host-management
>        interfaces.
>
> [1] https://lore.kernel.org/kvm/ZimnngU7hn7sKoSc@google.com/#t
>
>
> Testing
> -------
>
> For testing this via QEMU, use the following tree:
>
>   https://github.com/amdese/qemu/commits/snp-v4-wip3c
>
> A patched OVMF is also needed due to upstream KVM no longer supporting MM=
IO
> ranges that are mapped as private. It is recommended you build the AmdSev=
X64
> variant as it provides the kernel-hashing support present in this series:
>
>   https://github.com/amdese/ovmf/commits/apic-mmio-fix1d
>
> A basic command-line invocation for SNP would be:
>
>  qemu-system-x86_64 -smp 32,maxcpus=3D255 -cpu EPYC-Milan-v2
>   -machine q35,confidential-guest-support=3Dsev0,memory-backend=3Dram1
>   -object memory-backend-memfd,id=3Dram1,size=3D4G,share=3Dtrue,reserve=
=3Dfalse
>   -object sev-snp-guest,id=3Dsev0,cbitpos=3D51,reduced-phys-bits=3D1,id-a=
uth=3D
>   -bios OVMF_CODE-upstream-20240410-apic-mmio-fix1d-AmdSevX64.fd
>
> With kernel-hashing and certificate data supplied:
>
>  qemu-system-x86_64 -smp 32,maxcpus=3D255 -cpu EPYC-Milan-v2
>   -machine q35,confidential-guest-support=3Dsev0,memory-backend=3Dram1
>   -object memory-backend-memfd,id=3Dram1,size=3D4G,share=3Dtrue,reserve=
=3Dfalse
>   -object sev-snp-guest,id=3Dsev0,cbitpos=3D51,reduced-phys-bits=3D1,id-a=
uth=3D,certs-path=3D/home/mroth/cert.blob,kernel-hashes=3Don
>   -bios OVMF_CODE-upstream-20240410-apic-mmio-fix1d-AmdSevX64.fd
>   -kernel /boot/vmlinuz-$ver
>   -initrd /boot/initrd.img-$ver
>   -append "root=3DUUID=3Dd72a6d1c-06cf-4b79-af43-f1bac4f620f9 ro console=
=3DttyS0,115200n8"
>
> With standard X64 OVMF package with separate image for persistent NVRAM:
>
>  qemu-system-x86_64 -smp 32,maxcpus=3D255 -cpu EPYC-Milan-v2
>   -machine q35,confidential-guest-support=3Dsev0,memory-backend=3Dram1
>   -object memory-backend-memfd,id=3Dram1,size=3D4G,share=3Dtrue,reserve=
=3Dfalse
>   -object sev-snp-guest,id=3Dsev0,cbitpos=3D51,reduced-phys-bits=3D1,id-a=
uth=3D
>   -bios OVMF_CODE-upstream-20240410-apic-mmio-fix1d.fd
>   -drive if=3Dpflash,format=3Draw,unit=3D0,file=3DOVMF_VARS-upstream-2024=
0410-apic-mmio-fix1d.fd,readonly=3Doff
>
>
> Known issues / TODOs
> --------------------
>
>  * Base tree in some cases reports "Unpatched return thunk in use. This s=
hould
>    not happen!" the first time it runs an SVM/SEV/SNP guests. This a rece=
nt
>    regression upstream and unrelated to this series:
>
>      https://lore.kernel.org/linux-kernel/CANpmjNOcKzEvLHoGGeL-boWDHJobwf=
wyVxUqMq2kWeka3N4tXA@mail.gmail.com/T/
>
>  * 2MB hugepage support has been dropped pending discussion on how we pla=
n to
>    re-enable it in gmem.
>
>  * Host kexec should work, but there is a known issue with host kdump sup=
port
>    while SNP guests are running that will be addressed as a follow-up.
>
>  * SNP kselftests are currently a WIP and will be included as part of SNP
>    upstreaming efforts in the near-term.
>
>
> SEV-SNP Overview
> ----------------
>
> This part of the Secure Encrypted Paging (SEV-SNP) series focuses on the
> changes required to add KVM support for SEV-SNP. This series builds upon
> SEV-SNP guest support, which is now in mainline, and and SEV-SNP host
> initialization support, which is now in linux-next.
>
> While series provides the basic building blocks to support booting the
> SEV-SNP VMs, it does not cover all the security enhancement introduced by
> the SEV-SNP such as interrupt protection, which will added in the future.
>
> With SNP, when pages are marked as guest-owned in the RMP table, they are
> assigned to a specific guest/ASID, as well as a specific GFN with in the
> guest. Any attempts to map it in the RMP table to a different guest/ASID,
> or a different GFN within a guest/ASID, will result in an RMP nested page
> fault.
>
> Prior to accessing a guest-owned page, the guest must validate it with a
> special PVALIDATE instruction which will set a special bit in the RMP tab=
le
> for the guest. This is the only way to set the validated bit outside of t=
he
> initial pre-encrypted guest payload/image; any attempts outside the guest=
 to
> modify the RMP entry from that point forward will result in the validated
> bit being cleared, at which point the guest will trigger an exception if =
it
> attempts to access that page so it can be made aware of possible tamperin=
g.
>
> One exception to this is the initial guest payload, which is pre-validate=
d
> by the firmware prior to launching. The guest can use Guest Message reque=
sts
> to fetch an attestation report which will include the measurement of the
> initial image so that the guest can verify it was booted with the expecte=
d
> image/environment.
>
> After boot, guests can use Page State Change requests to switch pages
> between shared/hypervisor-owned and private/guest-owned to share data for
> things like DMA, virtio buffers, and other GHCB requests.
>
> In this implementation of SEV-SNP, private guest memory is managed by a n=
ew
> kernel framework called guest_memfd (gmem). With gmem, a new
> KVM_SET_MEMORY_ATTRIBUTES KVM ioctl has been added to tell the KVM
> MMU whether a particular GFN should be backed by shared (normal) memory o=
r
> private (gmem-allocated) memory. To tie into this, Page State Change
> requests are forward to userspace via KVM_EXIT_VMGEXIT exits, which will
> then issue the corresponding KVM_SET_MEMORY_ATTRIBUTES call to set the
> private/shared state in the KVM MMU.
>
> The gmem / KVM MMU hooks implemented in this series will then update the =
RMP
> table entries for the backing PFNs to set them to guest-owned/private whe=
n
> mapping private pages into the guest via KVM MMU, or use the normal KVM M=
MU
> handling in the case of shared pages where the corresponding RMP table
> entries are left in the default shared/hypervisor-owned state.
>
> Feedback/review is very much appreciated!
>
> -Mike
>
>
> Changes since v14:
>
>  * switch to vendor-agnostic KVM_HC_MAP_GPA_RANGE exit for forwarding
>    page-state change requests to userspace instead of an SNP-specific exi=
t
>    (Sean)
>  * drop SNP_PAUSE_ATTESTATION/SNP_RESUME_ATTESTATION interfaces, instead
>    add handling in KVM_EXIT_VMGEXIT so that VMMs can implement their own
>    mechanisms for keeping userspace-supplied certificates in-sync with
>    firmware's TCB/endorsement key (Sean)
>  * carve out SEV-ES-specific handling for GHCB protocol 2, add control of
>    the protocol version, and post as a separate prereq patchset (Sean)
>  * use more consistent error-handling in snp_launch_{start,update,finish}=
,
>    simplify logic based on review comments (Sean)
>  * rename .gmem_validate_fault to .private_max_mapping_level and rework
>    logic based on review suggestions (Sean)
>  * reduce number of pr_debug()'s in series, avoid multiple WARN's in
>    succession (Sean)
>  * improve documentation and comments throughout
>
> Changes since v13:
>
>  * rebase to new kvm-coco-queue and wire up to PFERR_PRIVATE_ACCESS (Paol=
o)
>  * handle setting kvm->arch.has_private_mem in same location as
>    kvm->arch.has_protected_state (Paolo)
>  * add flags and additional padding fields to
>    snp_launch{start,update,finish} APIs to address alignment and
>    expandability (Paolo)
>  * update snp_launch_update() to update input struct values to reflect
>    current progress of command in situations where mulitple calls are
>    needed (Paolo)
>  * update snp_launch_update() to avoid copying/accessing 'src' parameter
>    when dealing with zero pages. (Paolo)
>  * update snp_launch_update() to use u64 as length input parameter instea=
d
>    of u32 and adjust padding accordingly
>  * modify ordering of SNP_POLICY_MASK_* definitions to be consistent with
>    bit order of corresponding flags
>  * let firmware handle enforcement of policy bits corresponding to
>    user-specified minimum API version
>  * add missing "0x" prefixs in pr_debug()'s for snp_launch_start()
>  * fix handling of VMSAs during in-place migration (Paolo)
>
> Changes since v12:
>
>  * rebased to latest kvm-coco-queue branch (commit 4d2deb62185f)
>  * add more input validation for SNP_LAUNCH_START, especially for handlin=
g
>    things like MBO/MBZ policy bits, and API major/minor minimums. (Paolo)
>  * block SNP KVM instances from being able to run legacy SEV commands (Pa=
olo)
>  * don't attempt to measure VMSA for vcpu 0/BSP before the others, let
>    userspace deal with the ordering just like with SEV-ES (Paolo)
>  * fix up docs for SNP_LAUNCH_FINISH (Paolo)
>  * introduce svm->sev_es.snp_has_guest_vmsa flag to better distinguish
>    handling for guest-mapped vs non-guest-mapped VMSAs, rename
>    'snp_ap_create' flag to 'snp_ap_waiting_for_reset' (Paolo)
>  * drop "KVM: SEV: Use a VMSA physical address variable for populating VM=
CB"
>    as it is no longer needed due to above VMSA rework
>  * replace pr_debug_ratelimited() messages for RMP #NPFs with a single tr=
ace
>    event
>  * handle transient PSMASH_FAIL_INUSE return codes in kvm_gmem_invalidate=
(),
>    switch to WARN_ON*()'s to indicate remaining error cases are not expec=
ted
>    and should not be seen in practice. (Paolo)
>  * add a cond_resched() in kvm_gmem_invalidate() to avoid soft lock-ups w=
hen
>    cleaning up large guest memory ranges.
>  * rename VLEK_REQUIRED to VCEK_DISABLE. it's be more applicable if anoth=
er
>    key type ever gets added.
>  * don't allow attestation to be paused while an attestation request is
>    being processed by firmware (Tom)
>  * add missing Documentation entry for SNP_VLEK_LOAD
>  * collect Reviewed-by's from Paolo and Tom
>
>
> ----------------------------------------------------------------
> Ashish Kalra (1):
>       KVM: SEV: Avoid WBINVD for HVA-based MMU notifications for SNP
>
> Brijesh Singh (8):
>       KVM: SEV: Add initial SEV-SNP support
>       KVM: SEV: Add KVM_SEV_SNP_LAUNCH_START command
>       KVM: SEV: Add KVM_SEV_SNP_LAUNCH_UPDATE command
>       KVM: SEV: Add KVM_SEV_SNP_LAUNCH_FINISH command
>       KVM: SEV: Add support to handle GHCB GPA register VMGEXIT
>       KVM: SEV: Add support to handle RMP nested page faults
>       KVM: SVM: Add module parameter to enable SEV-SNP
>       KVM: SEV: Provide support for SNP_GUEST_REQUEST NAE event
>
> Michael Roth (10):
>       Revert "KVM: x86: Add gmem hook for determining max NPT mapping lev=
el"
>       KVM: x86: Add hook for determining max NPT mapping level
>       KVM: SEV: Select KVM_GENERIC_PRIVATE_MEM when CONFIG_KVM_AMD_SEV=3D=
y
>       KVM: SEV: Add support to handle MSR based Page State Change VMGEXIT
>       KVM: SEV: Add support to handle Page State Change VMGEXIT
>       KVM: SEV: Implement gmem hook for initializing private pages
>       KVM: SEV: Implement gmem hook for invalidating private pages
>       KVM: x86: Implement hook for determining max NPT mapping level
>       KVM: SEV: Provide support for SNP_EXTENDED_GUEST_REQUEST NAE event
>       crypto: ccp: Add the SNP_VLEK_LOAD command
>
> Tom Lendacky (1):
>       KVM: SEV: Support SEV-SNP AP Creation NAE event
>
>  Documentation/virt/coco/sev-guest.rst              |   19 +
>  Documentation/virt/kvm/api.rst                     |   87 ++
>  .../virt/kvm/x86/amd-memory-encryption.rst         |  110 +-
>  arch/x86/include/asm/kvm-x86-ops.h                 |    2 +-
>  arch/x86/include/asm/kvm_host.h                    |    5 +-
>  arch/x86/include/asm/sev-common.h                  |   25 +
>  arch/x86/include/asm/sev.h                         |    3 +
>  arch/x86/include/asm/svm.h                         |    9 +-
>  arch/x86/include/uapi/asm/kvm.h                    |   48 +
>  arch/x86/kvm/Kconfig                               |    3 +
>  arch/x86/kvm/mmu.h                                 |    2 -
>  arch/x86/kvm/mmu/mmu.c                             |   27 +-
>  arch/x86/kvm/svm/sev.c                             | 1538 ++++++++++++++=
+++++-
>  arch/x86/kvm/svm/svm.c                             |   44 +-
>  arch/x86/kvm/svm/svm.h                             |   52 +
>  arch/x86/kvm/trace.h                               |   31 +
>  arch/x86/kvm/x86.c                                 |   17 +
>  drivers/crypto/ccp/sev-dev.c                       |   36 +
>  include/linux/psp-sev.h                            |    4 +-
>  include/uapi/linux/kvm.h                           |   23 +
>  include/uapi/linux/psp-sev.h                       |   27 +
>  include/uapi/linux/sev-guest.h                     |    9 +
>  virt/kvm/guest_memfd.c                             |    4 +-
>  23 files changed, 2081 insertions(+), 44 deletions(-)
>


