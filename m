Return-Path: <kvm+bounces-15262-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 43CDA8AAE07
	for <lists+kvm@lfdr.de>; Fri, 19 Apr 2024 14:05:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id AE9141F220D3
	for <lists+kvm@lfdr.de>; Fri, 19 Apr 2024 12:05:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5FD5684A2B;
	Fri, 19 Apr 2024 12:05:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="S+ZGp2GZ"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B10218121F
	for <kvm@vger.kernel.org>; Fri, 19 Apr 2024 12:05:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713528312; cv=none; b=mALG9zLWKZ19qy9Xn+sImdgDhI9jXKWNgpiGzbx6Wd2kFrIHMhPIFYXPrIw11t0ifIj2AT/CvEKFZJsHabNL9kAfkEZ7+I1EC2UG8H/28+Rf0umtMyIQnSGeO/WEUedoVojJG7S28Y/jwsw/bLoOK6Q1vv54+AdXF2SiLjGcvMs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713528312; c=relaxed/simple;
	bh=rRee0IGkVRICDEAwK0rlWKkcIuErxXFhhVq5STWU3SU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Z2M+PTSp1EEtmZDXMDwWYy5ZJOqhDQDjQZwvnasPbzlK/pWzx5H+kraceuhYzeGxPN2fiEb5ARPyjPdi7ploCnkoCZqjHb7U9lyP05l0XkpqwzAidG3GLDrj/0RFpZ668gIaomCTEprz/MiDV4KXZLWnV2f1Gyo4301hMlnZCBE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=S+ZGp2GZ; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1713528309;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5rIVMkIQfOPxV6zFFJqS4Fp0MVkB/uNbMJoip00moG4=;
	b=S+ZGp2GZIWvGpalitpqTtYs10t161dUTstKawYUEWA12iwtdIQphTIK1gVMw5LRe51oIO6
	e7m6ECLNzVuRDPeoCu+jdNEPE1CSpzca/JMstymewVidJztjlRgfifv9dCQ+Sxdz5cAflu
	6/r7mkN2OHNi/M6V/jaZnBr9iMUS5uo=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-78-EJVHyu8MOI6CEe8obxSg5g-1; Fri, 19 Apr 2024 08:05:08 -0400
X-MC-Unique: EJVHyu8MOI6CEe8obxSg5g-1
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-416a844695dso11241075e9.2
        for <kvm@vger.kernel.org>; Fri, 19 Apr 2024 05:05:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713528307; x=1714133107;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5rIVMkIQfOPxV6zFFJqS4Fp0MVkB/uNbMJoip00moG4=;
        b=S30hS81XNjy2nvaj8pylAmDVcb4/edUruZaBt6f7x7F1FnNzFS20P3a0T0S3TNGhlV
         twsRamiOLUoxnyWlpKjuQq/hBGDR8bnF3Kgb0fDrKanUydZnZKTTy+DDLVqZ5JxVofkF
         U4P3HrywJ9hkoQpBrh8aXNJIFyBjnHma3t6qeJ20Tjdvp9VOJZ1vDY9pircIhqE63l8E
         hzGwfJxkcZuqnV31NJCy8tk8ej5na+7HA6TFSC3HVgX9qdw3pK9b90kSzpCIls1pJEH5
         4ZgIUcKmFmHSpqDiy5eAatJ27ZFw+huWAAR61PPXWGjg7B/BwFwUCtUphXSzHx79BnzL
         Zqqw==
X-Gm-Message-State: AOJu0YwRnJZiOd4NBQnlgNMb0WKIUj2BmXPZk+ENHOD9cOun9XLzx9QL
	ve4bxMd0n5R8CPGjOBRUAjMZhuAqfqXi2RV4xFeuA2fg3yaDZA9PthnyDmVEVXkgh7EI52EXB8f
	Of9NcMgkYCHG+rc8E2Xh1Kt227IQiKDBTieo0bYy4KNtQ/lVYl+PxRz+wmLK8wBL3jelUUS1VlG
	MqjPPzYewllbcz+Zcjl8OrsYnN
X-Received: by 2002:a05:600c:4ec9:b0:416:af4d:e3dc with SMTP id g9-20020a05600c4ec900b00416af4de3dcmr1641948wmq.12.1713528306940;
        Fri, 19 Apr 2024 05:05:06 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGMDACeW6KYVVEC7SztOXweilwyZW0Yai9tufHIxzh0/3BTXWEvtCxpTYK8XwSmcrIXyTlGgqz4+VG3ZnO1ZRE=
X-Received: by 2002:a05:600c:4ec9:b0:416:af4d:e3dc with SMTP id
 g9-20020a05600c4ec900b00416af4de3dcmr1641910wmq.12.1713528306373; Fri, 19 Apr
 2024 05:05:06 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240418194133.1452059-1-michael.roth@amd.com>
In-Reply-To: <20240418194133.1452059-1-michael.roth@amd.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Fri, 19 Apr 2024 14:04:54 +0200
Message-ID: <CABgObfZsY_0-DbPbOSLQ8uSbaWSh-PJZfBKc2TbHiKb2YYJh+w@mail.gmail.com>
Subject: Re: [PATCH v13 00/26] Add AMD Secure Nested Paging (SEV-SNP)
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

On Thu, Apr 18, 2024 at 9:42=E2=80=AFPM Michael Roth <michael.roth@amd.com>=
 wrote:
>
> This patchset is also available at:
>
>   https://github.com/amdese/linux/commits/snp-host-v13
>
> and is based on commit 4d2deb62185f (as suggested by Paolo) from:
>
>   https://git.kernel.org/pub/scm/virt/kvm/kvm.git/log/?h=3Dkvm-coco-queue

This is pretty much ready to go into kvm-coco-queue. Let me know if
you want to do a quick v14 with the few changes I suggested, or I can
do them too.

Then the next steps are:

1) get the mm acks

2) figure out the state of patches 1-3

3) wait for more reviews of course

4) merge everything into kvm/next.

Seems in good shape for a 6.10 target.

Paolo

>
> Patch Layout
> ------------
>
> 01-03: These patches are minor dependencies for this series and are alrea=
dy
>        included in both tip/master and mainline, so are only included her=
e
>        as a stop-gap until merged from one of those trees. These are need=
ed
>        by patch #8 in this series which makes use of CC_ATTR_HOST_SEV_SNP
>
> 04:    This is a small general fix-up for guest_memfd that can be applied
>        independently of this series.
>
> 05-08: These patches add some basic infrastructure and introduces a new
>        KVM_X86_SNP_VM vm_type to handle differences verses the existing
>        KVM_X86_SEV_VM and KVM_X86_SEV_ES_VM types.
>
> 09-11: These implement the KVM API to handle the creation of a
>        cryptographic launch context, encrypt/measure the initial image
>        into guest memory, and finalize it before launching it.
>
> 12-17: These implement handling for various guest-generated events such
>        as page state changes, onlining of additional vCPUs, etc.
>
> 18-21: These implement the gmem hooks needed to prepare gmem-allocated
>        pages before mapping them into guest private memory ranges as
>        well as cleaning them up prior to returning them to the host for
>        use as normal memory. Because this supplants certain activities
>        like issued WBINVDs during KVM MMU invalidations, there's also
>        a patch to avoid duplicating that work to avoid unecessary
>        overhead.
>
> 22:    With all the core support in place, the patch adds a kvm_amd modul=
e
>        parameter to enable SNP support.
>
> 23-26: These patches all deal with the servicing of guest requests to han=
dle
>        things like attestation, as well as some related host-management
>        interfaces.
>
>
> Testing
> -------
>
> For testing this via QEMU, use the following tree:
>
>   https://github.com/amdese/qemu/commits/snp-v4-wip3
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
>  * SEV-ES guests may trigger the following warning:
>
>      WARNING: CPU: 151 PID: 4003 at arch/x86/kvm/mmu/mmu.c:5855 kvm_mmu_p=
age_fault+0x33b/0x860 [kvm]
>
>    It is assumed here that these will be resolved once the transition to
>    PFERR_PRIVATE_ACCESS is fully completed, but if that's not the case le=
t me
>    know and will investigate further.
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
> Changes since v11:
>
>  * Rebase series on kvm-coco-queue and re-work to leverage more
>    infrastructure between SNP/TDX series.
>  * Drop KVM_SNP_INIT in favor of the new KVM_SEV_INIT2 interface introduc=
ed
>    here (Paolo):
>      https://lore.kernel.org/lkml/20240318233352.2728327-1-pbonzini@redha=
t.com/
>  * Drop exposure API fields related to things like VMPL levels, migration
>    agents, etc., until they are actually supported/used (Sean)
>  * Rework KVM_SEV_SNP_LAUNCH_UPDATE handling to use a new
>    kvm_gmem_populate() interface instead of copying data directly into
>    gmem-allocated pages (Sean)
>  * Add support for SNP_LOAD_VLEK, rework the SNP_SET_CONFIG_{START,END} t=
o
>    have simpler semantics that are applicable to management of SNP_LOAD_V=
LEK
>    updates as well, rename interfaces to the now more appropriate
>    SNP_{PAUSE,RESUME}_ATTESTATION
>  * Fix up documentation wording and do print warnings for
>    userspace-triggerable failures (Peter, Sean)
>  * Fix a race with AP_CREATION wake-up events (Jacob, Sean)
>  * Fix a memory leak with VMSA pages (Sean)
>  * Tighten up handling of RMP page faults to better distinguish between r=
eal
>    and spurious cases (Tom)
>  * Various patch/documentation rewording, cleanups, etc.
>
>
> ----------------------------------------------------------------
> Ashish Kalra (1):
>       KVM: SEV: Avoid WBINVD for HVA-based MMU notifications for SNP
>
> Borislav Petkov (AMD) (3):
>       [TEMP] x86/kvm/Kconfig: Have KVM_AMD_SEV select ARCH_HAS_CC_PLATFOR=
M
>       [TEMP] x86/cc: Add cc_platform_set/_clear() helpers
>       [TEMP] x86/CPU/AMD: Track SNP host status with cc_platform_*()
>
> Brijesh Singh (10):
>       KVM: SEV: Add GHCB handling for Hypervisor Feature Support requests
>       KVM: SEV: Add KVM_SEV_SNP_LAUNCH_START command
>       KVM: SEV: Add KVM_SEV_SNP_LAUNCH_UPDATE command
>       KVM: SEV: Add KVM_SEV_SNP_LAUNCH_FINISH command
>       KVM: SEV: Add support to handle GHCB GPA register VMGEXIT
>       KVM: SEV: Add support to handle MSR based Page State Change VMGEXIT
>       KVM: SEV: Add support to handle Page State Change VMGEXIT
>       KVM: SEV: Add support to handle RMP nested page faults
>       KVM: SVM: Add module parameter to enable SEV-SNP
>       KVM: SEV: Provide support for SNP_GUEST_REQUEST NAE event
>
> Michael Roth (10):
>       KVM: guest_memfd: Fix PTR_ERR() handling in __kvm_gmem_get_pfn()
>       KVM: SEV: Select KVM_GENERIC_PRIVATE_MEM when CONFIG_KVM_AMD_SEV=3D=
y
>       KVM: SEV: Add initial SEV-SNP support
>       KVM: SEV: Add support for GHCB-based termination requests
>       KVM: SEV: Implement gmem hook for initializing private pages
>       KVM: SEV: Implement gmem hook for invalidating private pages
>       KVM: x86: Implement gmem hook for determining max NPT mapping level
>       crypto: ccp: Add the SNP_VLEK_LOAD command
>       crypto: ccp: Add the SNP_{PAUSE,RESUME}_ATTESTATION commands
>       KVM: SEV: Provide support for SNP_EXTENDED_GUEST_REQUEST NAE event
>
> Tom Lendacky (2):
>       KVM: SEV: Add support to handle AP reset MSR protocol
>       KVM: SEV: Support SEV-SNP AP Creation NAE event
>
>  Documentation/virt/coco/sev-guest.rst              |   69 +-
>  Documentation/virt/kvm/api.rst                     |   73 +
>  .../virt/kvm/x86/amd-memory-encryption.rst         |   88 +-
>  arch/x86/coco/core.c                               |   52 +
>  arch/x86/include/asm/kvm_host.h                    |    2 +
>  arch/x86/include/asm/sev-common.h                  |   22 +-
>  arch/x86/include/asm/sev.h                         |   19 +-
>  arch/x86/include/asm/svm.h                         |    9 +-
>  arch/x86/include/uapi/asm/kvm.h                    |   39 +
>  arch/x86/kernel/cpu/amd.c                          |   38 +-
>  arch/x86/kernel/cpu/mtrr/generic.c                 |    2 +-
>  arch/x86/kernel/sev.c                              |   10 -
>  arch/x86/kvm/Kconfig                               |    4 +
>  arch/x86/kvm/mmu.h                                 |    2 -
>  arch/x86/kvm/mmu/mmu.c                             |    1 +
>  arch/x86/kvm/svm/sev.c                             | 1444 ++++++++++++++=
+++++-
>  arch/x86/kvm/svm/svm.c                             |   39 +-
>  arch/x86/kvm/svm/svm.h                             |   50 +
>  arch/x86/kvm/trace.h                               |   31 +
>  arch/x86/kvm/x86.c                                 |   19 +-
>  arch/x86/virt/svm/sev.c                            |  106 +-
>  drivers/crypto/ccp/sev-dev.c                       |   85 +-
>  drivers/iommu/amd/init.c                           |    4 +-
>  include/linux/cc_platform.h                        |   12 +
>  include/linux/psp-sev.h                            |    4 +-
>  include/uapi/linux/kvm.h                           |   28 +
>  include/uapi/linux/psp-sev.h                       |   39 +
>  include/uapi/linux/sev-guest.h                     |    9 +
>  virt/kvm/guest_memfd.c                             |    8 +-
>  29 files changed, 2229 insertions(+), 79 deletions(-)
>
>


