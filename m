Return-Path: <kvm+bounces-13162-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 238D1892D8D
	for <lists+kvm@lfdr.de>; Sat, 30 Mar 2024 22:44:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A0BCF1F21ED6
	for <lists+kvm@lfdr.de>; Sat, 30 Mar 2024 21:44:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BF5064C62E;
	Sat, 30 Mar 2024 21:44:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="jPSRLNX5"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19F69482D8
	for <kvm@vger.kernel.org>; Sat, 30 Mar 2024 21:44:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711835060; cv=none; b=AgnkYl6BU177pCC/42kaXTPOxme34RVEfw+OO09sG84Ecnxxnxd4c4AEr1Yp1t45L9ZOEYGWFjXsmonvBPHldMbAAHkyAWgiqmrztlEpePcYuVg92tp0dQSyD6oSAjZuVbJQeU3nd7xRv92DX0d+7qbFNXb/FcMDtKjRP0+h3I0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711835060; c=relaxed/simple;
	bh=RMUAwxfBL6v+GOWep6RijyAhN1Eu1x5xeC0TGBvfsN8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=l1VELV71pSE+pitUxO6PZDLwfBWcKxg+NZBKgmvamMpNZDTWNVWFUNDJILdvT1WUWRcMgnNMdbsW48UzMaEtXGJbeN0Tp4hXRMD1kCBTUYfZ8luyvnqc+VHEPXo0CX9cJUVQcGY2C58L3O8/I+J53S+vh89JdFcw8bXSEaqFfq8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=jPSRLNX5; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1711835057;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=izlk5zYEPtQtitZfD1Xa4239xlrb4zQaz31TSnSFbO8=;
	b=jPSRLNX5ioNiCLGGFgYa15v3rMLzyZj3JtGI5TQBGjZ4f04KM7UUddGP6/ukYlPmaWPi7N
	vzZf0Y1EtVEI+HAzpoUQZSzLmOJV0LsGKdM/VgPmskY3R5zEhJTda9f6E3Z90q/XYPayyK
	oYRnDncI3scGlF57yfr0bQjdbSy+dWA=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-377-eyReanA0Oci9pe1XY5ST0w-1; Sat, 30 Mar 2024 17:44:15 -0400
X-MC-Unique: eyReanA0Oci9pe1XY5ST0w-1
Received: by mail-ej1-f72.google.com with SMTP id a640c23a62f3a-a4e4cebd1c0so52249266b.0
        for <kvm@vger.kernel.org>; Sat, 30 Mar 2024 14:44:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711835054; x=1712439854;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=izlk5zYEPtQtitZfD1Xa4239xlrb4zQaz31TSnSFbO8=;
        b=wPo0hV7gI77ohVHzuRa2x3ggHAOaO57sbiBTMmyPqHZrNKpQ0wbnqt9C+5885Lyvrj
         0Z5E2EeypFBtau8chKJveYjL/ByPJxESpNlHrYagztCO6B+8w4g+0WAE4Qsmua0SBl90
         ec3a+bmfHljQ+x+Gw9RTue7vxFykijh4CL13k1FawNDFLYVU2GHXTBxWCnDVin+/fRLa
         oTnpSWB/wTjLNcgdWWtvY9sp+rVg6hHkpt533cTizLendTizqj0oob6mN4qm2lzc9+XZ
         YF6+xdzp2Rl2wcH5yjPPdoUc3JZ0QMTiMAmdGVRPeN7S2j1VpTg7pkMhIZLfkkG5usm1
         psAQ==
X-Forwarded-Encrypted: i=1; AJvYcCWuPKEfpFiMb2kP1lRzLIhqFlEdlHC/mc+Qt0mYNDhfLu7CgCmhPLDMMLBAoMhJSwdt5NcPUAD2kNk9+YosPY5D6MkC
X-Gm-Message-State: AOJu0YyBlVPXurOLfhiHoLFnIYzDNnBlgejFQzqmj7BgcVznlkI872oL
	/W8o/viNFLoJ3WCVobaYT33e+Az1TA8IpW2jgOETYtj7jbgnqxqUYz6iotJJD3+DSyi/ULv9Pgb
	rXyqw2fgHu7ZNtr+2QjLceb/1bf0Mz3kGj3COXOhXCiQ4EAFVuw==
X-Received: by 2002:a17:906:24d7:b0:a4e:1aef:2d03 with SMTP id f23-20020a17090624d700b00a4e1aef2d03mr3493126ejb.69.1711835054363;
        Sat, 30 Mar 2024 14:44:14 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEB4hhnolDV2VDW9ProjEjPrZSmimTTGsoO1Kt1nnLoSJpgttSbznq+JYF5W8Ur6uv2Wrybrg==
X-Received: by 2002:a17:906:24d7:b0:a4e:1aef:2d03 with SMTP id f23-20020a17090624d700b00a4e1aef2d03mr3493096ejb.69.1711835053917;
        Sat, 30 Mar 2024 14:44:13 -0700 (PDT)
Received: from [192.168.10.4] ([151.95.49.219])
        by smtp.googlemail.com with ESMTPSA id d6-20020a1709063ec600b00a474c3c2f9dsm3458900ejj.38.2024.03.30.14.44.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 30 Mar 2024 14:44:13 -0700 (PDT)
Message-ID: <8153674b-1b66-4416-a3b8-b6b7867e77f4@redhat.com>
Date: Sat, 30 Mar 2024 22:44:10 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v12 00/29] Add AMD Secure Nested Paging (SEV-SNP)
 Hypervisor Support
To: Michael Roth <michael.roth@amd.com>, kvm@vger.kernel.org
Cc: linux-coco@lists.linux.dev, linux-mm@kvack.org,
 linux-crypto@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org,
 tglx@linutronix.de, mingo@redhat.com, jroedel@suse.de,
 thomas.lendacky@amd.com, hpa@zytor.com, ardb@kernel.org, seanjc@google.com,
 vkuznets@redhat.com, jmattson@google.com, luto@kernel.org,
 dave.hansen@linux.intel.com, slp@redhat.com, pgonda@google.com,
 peterz@infradead.org, srinivas.pandruvada@linux.intel.com,
 rientjes@google.com, dovmurik@linux.ibm.com, tobin@ibm.com, bp@alien8.de,
 vbabka@suse.cz, kirill@shutemov.name, ak@linux.intel.com,
 tony.luck@intel.com, sathyanarayanan.kuppuswamy@linux.intel.com,
 alpergun@google.com, jarkko@kernel.org, ashish.kalra@amd.com,
 nikunj.dadhania@amd.com, pankaj.gupta@amd.com, liam.merwick@oracle.com
References: <20240329225835.400662-1-michael.roth@amd.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Content-Language: en-US
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
In-Reply-To: <20240329225835.400662-1-michael.roth@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/29/24 23:58, Michael Roth wrote:
> This patchset is also available at:
> 
>    https://github.com/amdese/linux/commits/snp-host-v12
> 
> and is based on top of the following series:
> 
>    [PATCH gmem 0/6] gmem fix-ups and interfaces for populating gmem pages
>    https://lore.kernel.org/kvm/20240329212444.395559-1-michael.roth@amd.com/
> 
> which in turn is based on:
> 
>    https://git.kernel.org/pub/scm/virt/kvm/kvm.git/log/?h=kvm-coco-queue
> 
> 
> Patch Layout
> ------------
> 
> 01-04: These patches are minor dependencies for this series and will
>         eventually make their way upstream through other trees. They are
>         included here only temporarily.
> 
> 05-09: These patches add some basic infrastructure and introduces a new
>         KVM_X86_SNP_VM vm_type to handle differences verses the existing
>         KVM_X86_SEV_VM and KVM_X86_SEV_ES_VM types.
> 
> 10-12: These implement the KVM API to handle the creation of a
>         cryptographic launch context, encrypt/measure the initial image
>         into guest memory, and finalize it before launching it.
> 
> 13-20: These implement handling for various guest-generated events such
>         as page state changes, onlining of additional vCPUs, etc.
> 
> 21-24: These implement the gmem hooks needed to prepare gmem-allocated
>         pages before mapping them into guest private memory ranges as
>         well as cleaning them up prior to returning them to the host for
>         use as normal memory. Because this supplants certain activities
>         like issued WBINVDs during KVM MMU invalidations, there's also
>         a patch to avoid duplicating that work to avoid unecessary
>         overhead.
> 
> 25:    With all the core support in place, the patch adds a kvm_amd module
>         parameter to enable SNP support.
> 
> 26-29: These patches all deal with the servicing of guest requests to handle
>         things like attestation, as well as some related host-management
>         interfaces.
> 
> 
> Testing
> -------
> 
> For testing this via QEMU, use the following tree:
> 
>    https://github.com/amdese/qemu/commits/snp-v4-wip2
> 
> A patched OVMF is also needed due to upstream KVM no longer supporting MMIO
> ranges that are mapped as private. It is recommended you build the AmdSevX64
> variant as it provides the kernel-hashing support present in this series:
> 
>    https://github.com/amdese/ovmf/commits/apic-mmio-fix1c
> 
> A basic command-line invocation for SNP would be:
> 
>   qemu-system-x86_64 -smp 32,maxcpus=255 -cpu EPYC-Milan-v2
>    -machine q35,confidential-guest-support=sev0,memory-backend=ram1
>    -object memory-backend-memfd,id=ram1,size=4G,share=true,reserve=false
>    -object sev-snp-guest,id=sev0,cbitpos=51,reduced-phys-bits=1,id-auth=
>    -bios /home/mroth/ovmf/OVMF_CODE-upstream-20240228-apicfix-1c-AmdSevX64.fd
> 
> With kernel-hashing and certificate data supplied:
> 
>   qemu-system-x86_64 -smp 32,maxcpus=255 -cpu EPYC-Milan-v2
>    -machine q35,confidential-guest-support=sev0,memory-backend=ram1
>    -object memory-backend-memfd,id=ram1,size=4G,share=true,reserve=false
>    -object sev-snp-guest,id=sev0,cbitpos=51,reduced-phys-bits=1,id-auth=,certs-path=/home/mroth/cert.blob,kernel-hashes=on
>    -bios /home/mroth/ovmf/OVMF_CODE-upstream-20240228-apicfix-1c-AmdSevX64.fd
>    -kernel /boot/vmlinuz-6.8.0-snp-host-v12-wip40+
>    -initrd /boot/initrd.img-6.8.0-snp-host-v12-wip40+
>    -append "root=UUID=d72a6d1c-06cf-4b79-af43-f1bac4f620f9 ro console=ttyS0,115200n8"
> 
> 
> Known issues / TODOs
> --------------------
> 
>   * Base tree in some cases reports "Unpatched return thunk in use. This should
>     not happen!" the first time it runs an SVM/SEV/SNP guests. This a recent
>     regression upstream and unrelated to this series:
> 
>       https://lore.kernel.org/linux-kernel/CANpmjNOcKzEvLHoGGeL-boWDHJobwfwyVxUqMq2kWeka3N4tXA@mail.gmail.com/T/
> 
>   * 2MB hugepage support has been dropped pending discussion on how we plan
>     to re-enable it in gmem.
> 
>   * Host kexec should work, but there is a known issue with handling host
>     kdump while SNP guests are running which will be addressed as a follow-up.
> 
>   * SNP kselftests are currently a WIP and will be included as part of SNP
>     upstreaming efforts in the near-term.
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
> special PVALIDATE instruction which will set a special bit in the RMP table
> for the guest. This is the only way to set the validated bit outside of the
> initial pre-encrypted guest payload/image; any attempts outside the guest to
> modify the RMP entry from that point forward will result in the validated
> bit being cleared, at which point the guest will trigger an exception if it
> attempts to access that page so it can be made aware of possible tampering.
> 
> One exception to this is the initial guest payload, which is pre-validated
> by the firmware prior to launching. The guest can use Guest Message requests
> to fetch an attestation report which will include the measurement of the
> initial image so that the guest can verify it was booted with the expected
> image/environment.
> 
> After boot, guests can use Page State Change requests to switch pages
> between shared/hypervisor-owned and private/guest-owned to share data for
> things like DMA, virtio buffers, and other GHCB requests.
> 
> In this implementation of SEV-SNP, private guest memory is managed by a new
> kernel framework called guest_memfd (gmem). With gmem, a new
> KVM_SET_MEMORY_ATTRIBUTES KVM ioctl has been added to tell the KVM
> MMU whether a particular GFN should be backed by shared (normal) memory or
> private (gmem-allocated) memory. To tie into this, Page State Change
> requests are forward to userspace via KVM_EXIT_VMGEXIT exits, which will
> then issue the corresponding KVM_SET_MEMORY_ATTRIBUTES call to set the
> private/shared state in the KVM MMU.
> 
> The gmem / KVM MMU hooks implemented in this series will then update the RMP
> table entries for the backing PFNs to set them to guest-owned/private when
> mapping private pages into the guest via KVM MMU, or use the normal KVM MMU
> handling in the case of shared pages where the corresponding RMP table
> entries are left in the default shared/hypervisor-owned state.
> 
> Feedback/review is very much appreciated!
> 
> -Mike
> 
> Changes since v11:
> 
>   * Rebase series on kvm-coco-queue and re-work to leverage more
>     infrastructure between SNP/TDX series.
>   * Drop KVM_SNP_INIT in favor of the new KVM_SEV_INIT2 interface introduced
>     here (Paolo):
>       https://lore.kernel.org/lkml/20240318233352.2728327-1-pbonzini@redhat.com/
>   * Drop exposure API fields related to things like VMPL levels, migration
>     agents, etc., until they are actually supported/used (Sean)
>   * Rework KVM_SEV_SNP_LAUNCH_UPDATE handling to use a new
>     kvm_gmem_populate() interface instead of copying data directly into
>     gmem-allocated pages (Sean)
>   * Add support for SNP_LOAD_VLEK, rework the SNP_SET_CONFIG_{START,END} to
>     have simpler semantics that are applicable to management of SNP_LOAD_VLEK
>     updates as well, rename interfaces to the now more appropriate
>     SNP_{PAUSE,RESUME}_ATTESTATION
>   * Fix up documentation wording and do print warnings for
>     userspace-triggerable failures (Peter, Sean)
>   * Fix a race with AP_CREATION wake-up events (Jacob, Sean)
>   * Fix a memory leak with VMSA pages (Sean)
>   * Tighten up handling of RMP page faults to better distinguish between real
>     and spurious cases (Tom)
>   * Various patch/documentation rewording, cleanups, etc.

I skipped a few patches that deal mostly with AMD ABIs.  Here are the 
ones that have nontrivial remarks, that are probably be worth a reply 
before sending v13:

- patch 10: some extra checks on input parameters, and possibly 
forbidding SEV/SEV-ES ioctls for SEV-SNP guests?

- patch 12: a (hopefully) simple question on boot_vcpu_handled

- patch 18: see Sean's objections at 
https://lore.kernel.org/lkml/ZeCqnq7dLcJI41O9@google.com/

- patch 22: question on ignoring PSMASH failures and possibly adding a 
kvm_arch_gmem_invalidate_begin() API.

With respect to the six preparatory patches, I'll merge them in 
kvm-coco-queue early next week.  However I'll explode the arguments to 
kvm_gmem_populate(), while also removing "memslot" and merging "src" 
with "do_memcpy".  I'll post my version very early.

Paolo


