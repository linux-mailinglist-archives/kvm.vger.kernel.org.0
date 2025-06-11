Return-Path: <kvm+bounces-49103-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id BD453AD5F8E
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 21:56:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6AD931BC22E4
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 19:57:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1B6CD2BD5A7;
	Wed, 11 Jun 2025 19:56:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="DQYYHQ81"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66E6228853E
	for <kvm@vger.kernel.org>; Wed, 11 Jun 2025 19:56:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749671793; cv=none; b=pAS98TtM/0bBZM8XadccjsSYB3oGcjzfdn15bsADuYkZBB9IhEIVqo31eiEkPkj79RPmGiCVYENptFhcztjZO+LMKIZJXX1vmg89ii5gE/4wERYXVMCyropPLIPDAmBWD/EEQB++nQaWdG9zeh/lBxR2EPycXPfb3y2KKam2ANQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749671793; c=relaxed/simple;
	bh=K+B8CuXm/VmQ/C6kU8hO0Yo82Qfv+13GMs82YCd1Rfs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=X4x9aAhzFp7WrTd6Ue9i/JXJwpdPGiM2fO6V8GLrvLjghw9qQDBo4obZCtZYpS0bHyyiHQPlTg220uN0LNSl6B/1JR4/htaPsGaHbOSnhOJ/aHttjq8cSdbtVtUgYZEn81aHZQ9co63rGXc8guprZxQ96IDWQkg3G9V2OkzVmso=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=DQYYHQ81; arc=none smtp.client-ip=209.85.160.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f173.google.com with SMTP id d75a77b69052e-4a5ac8fae12so97941cf.0
        for <kvm@vger.kernel.org>; Wed, 11 Jun 2025 12:56:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749671790; x=1750276590; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=J3K+mcHKGGXBkrel0kGvelLSyBHoHEmSGPV+Mb/f88g=;
        b=DQYYHQ81SJJElyE/5owBRXzxGNcFViJdyXbb6W8iBaozrteueY7/uA5Mg8pa92Sf+T
         DLDfMSAuF1qV954noaBWDHq4gz8Eit4nnUvepOiYBPFhiDvpfhhEJb1PwN04XsuzZX0Q
         X0y9Vy+mDp/2AaChh538cR1MnKasLFNDNJ86adqCZvltAX3NGHg1+w7VCP+LIjwoEuhl
         pLcy7R1oO67t/Oz0DRVa3wIH6TGJP4DWVoar2CQiepX2ySw8WEBlZJkyAiN97sdIPobg
         EUhIzLRfK+tM/oQJZDV85Un0ZUqkFXFfF3JJmyw24VUwOJWZxybr6iGo8m3kuubB3ONe
         YKSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749671790; x=1750276590;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=J3K+mcHKGGXBkrel0kGvelLSyBHoHEmSGPV+Mb/f88g=;
        b=uDc0W0V5ehiFbTduKaT3aVJefCbtsDrdbOGfucO8veZLDU8sKV94iE1iz7hcL2TL0m
         /X0i8PskevHHgloP4oEPQt8BH1FEzJhzrZwV7TG0+MI7im9BnGzrGvh9DYHo8VfbLPd7
         kRrYfFfA7uhcyT2DD+j7H4lqZvr4dWhacK/P3gPDdvyxBCzG2Ts1PlikNLwpoW75bTJu
         x5sWVQiWyMAnKV5rKgwglzNVi6XxQSSevkLMdY9C9OxcHXfrMwgfLIvSVZaX/KEI9Tp2
         piu/TqlxTrvz2vVIpaU4wRM8jjqhy1g30grcTpxT+wsQDV/EEsGplryr4ETwcMzqVl5V
         W6vw==
X-Forwarded-Encrypted: i=1; AJvYcCUxfMn0HS/1oYx2fWSNnlV169gM/6hZ2ET56u3VnJWBHa3zm/jCPd7RmHGDqLGggSk/aL0=@vger.kernel.org
X-Gm-Message-State: AOJu0YwlkqaZwAxCbQBHlKNsGqir7Mf02CGWmazT6rCn0YhR8aZ+edJf
	1Mx6d7i8wmuj2qlZKF+gDujgqvsgKGyZbafwoECT4RzmE+7OYYSSgwYJd0WAKQlBDBMhGpsGXn1
	DqpdZA7SzihPGDC3EMPHabVsHvD9u3c/MUesxU8Mb
X-Gm-Gg: ASbGncsyGiaQ1B5CuiqTPcfnttPt9WGjDnN6WwNRtAWGlphKuUvikEvlB7JvoQvg/A0
	reiLiTVeUa/FvL7SHea6i2JTQvG0CFBgX6u99cmJ/3cDR+ndDYVcIKukDM4N6HI5DQpuTgJ7vCH
	6LBRBL3bdS3CPrSHC8y1bZVZGfpvn1EhWeheU4vCZ4QlTXEVjD4++2pt12ED6LqVSyHcc0l7Trc
	MQwhHmyw0IVzA==
X-Google-Smtp-Source: AGHT+IHnw6Rim9zVk16rHZURinDBa6Etb/jZuDGiu5RYkmCwknCXOrl2MzqjpJZgvqAdKsXB34ec6Rn0119SwGKrC9w=
X-Received: by 2002:a05:622a:204:b0:4a6:907e:61ca with SMTP id
 d75a77b69052e-4a724289264mr321151cf.12.1749671789994; Wed, 11 Jun 2025
 12:56:29 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250523095322.88774-1-chao.gao@intel.com>
In-Reply-To: <20250523095322.88774-1-chao.gao@intel.com>
From: Sagi Shahar <sagis@google.com>
Date: Wed, 11 Jun 2025 14:56:19 -0500
X-Gm-Features: AX0GCFunCmVYS_s1OapPfIzQoyibyE9XgRJCoT6E6oUhPxQJfbCODoBK-DLB6po
Message-ID: <CAAhR5DF2PhB-usQBzWuUZAd=y8tWursMOnBOzNiGEBAnkqxutA@mail.gmail.com>
Subject: Re: [RFC PATCH 00/20] TD-Preserving updates
To: Chao Gao <chao.gao@intel.com>
Cc: linux-coco@lists.linux.dev, x86@kernel.org, kvm@vger.kernel.org, 
	seanjc@google.com, pbonzini@redhat.com, eddie.dong@intel.com, 
	kirill.shutemov@intel.com, dave.hansen@intel.com, dan.j.williams@intel.com, 
	kai.huang@intel.com, isaku.yamahata@intel.com, elena.reshetova@intel.com, 
	rick.p.edgecombe@intel.com, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>, 
	Ingo Molnar <mingo@redhat.com>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, 
	linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, May 23, 2025 at 4:53=E2=80=AFAM Chao Gao <chao.gao@intel.com> wrote=
:
>
> Hi Reviewers,
>
> This series adds support for runtime TDX module updates that preserve
> running TDX guests (a.k.a, TD-Preserving updates). The goal is to gather
> feedback on the feature design. Please pay attention to the following ite=
ms:
>
> 1. TD-Preserving updates are done in stop_machine() context. it copy-past=
es
>    part of multi_cpu_stop() to guarantee step-locked progress on all CPUs=
.
>    But, there are a few differences between them. I am wondering whether
>    these differences have reached a point where abstracting a common
>    function might do more harm than good. See more details in patch 10.
>
> 2. P-SEAMLDR seamcalls (specificially SEAMRET from P-SEAMLDR) clear curre=
nt
>    VMCS pointers, which may disrupt KVM. To prevent VMX instructions in I=
RQ
>    context from encountering NULL current-VMCS pointers, P-SEAMLDR
>    seamcalls are called with IRQ disabled. I'm uncertain if NMIs could
>    cause a problem, but I believe they won't. See more information in pat=
ch 3.
>
> 3. Two helpers, cpu_vmcs_load() and cpu_vmcs_store(), are added in patch =
3
>    to save and restore the current VMCS. KVM has a variant of cpu_vmcs_lo=
ad(),
>    i.e., vmcs_load(). Extracting KVM's version would cause a lot of code
>    churn, and I don't think that can be justified for reducing ~16 LoC
>    duplication. Please let me know if you disagree.
>
> =3D=3D Background =3D=3D
>
> Intel TDX isolates Trusted Domains (TDs), or confidential guests, from th=
e
> host. A key component of Intel TDX is the TDX module, which enforces
> security policies to protect the memory and CPU states of TDs from the
> host. However, the TDX module is software that require updates, it is not
> device firmware in the typical sense.
>
> =3D=3D Problems =3D=3D
>
> Currently, the TDX module is loaded by the BIOS at boot time, and the onl=
y
> way to update it is through a reboot, which results in significant system
> downtime. Users expect the TDX module to be updatable at runtime without
> disrupting TDX guests.
>
> =3D=3D Solution =3D=3D
>
> On TDX platforms, P-SEAMLDR[1] is a component within the protected SEAM
> range. It is loaded by the BIOS and provides the host with functions to
> install a TDX module at runtime.
>
> Implement a TDX Module update facility via the fw_upload mechanism. Given
> that there is variability in which module update to load based on feature=
s,
> fix levels, and potentially reloading the same version for error recovery
> scenarios, the explicit userspace chosen payload flexibility of fw_upload
> is attractive.
>
> This design allows the kernel to accept a bitstream instead of loading a
> named file from the filesystem, as the module selection and policy
> enforcement for TDX modules are quite complex (see more in patch 8). By
> doing so, much of this complexity is shifted out of the kernel. The kerne=
l
> need to expose information, such as the TDX module version, to userspace.
> The userspace tool must understand the TDX module versioning scheme and
> update policy to select the appropriate TDX module (see "TDX Module
> Versioning" below).
>
> In the unlikely event the update fails, for example userspace picks an
> incompatible update image, or the image is otherwise corrupted, all TDs
> will experience SEAMCALL failures and be killed. The recovery of TD
> operation from that event requires a reboot.
>
> Given there is no mechanism to quiesce SEAMCALLs, the TDs themselves must
> pause execution over an update. The most straightforward way to meet the
> 'pause TDs while update executes' constraint is to run the update in
> stop_machine() context. All other evaluated solutions export more
> complexity to KVM, or exports more fragility to userspace.
>
> =3D=3D How to test this series =3D=3D
>
>  # git clone https://github.com/intel/tdx-module-binaries
>  # cd tdx-module-binaries
>  # python version_select_and_load.py --update
>
>
> This series is based on Sean's kvm-x86/next branch
>
>   https://github.com/kvm-x86/linux.git next
>
>
> =3D=3D Other information relevant to TD-Preserving updates =3D=3D
>
> =3D=3D=3D TDX module versioning =3D=3D=3D
>
> Each TDX module is assigned a version number x.y.z, where x represents th=
e
> "major" version, y the "minor" version, and z the "update" version.
>
> TD-Preserving updates are restricted to Z-stream releases.
>
> Note that Z-stream releases do not necessarily guarantee compatibility. A
> new release may not be compatible with all previous versions. To address =
this,
> Intel provides a separate file containing compatibility information, whic=
h
> specifies the minimum module version required for a particular update. Th=
is
> information is referenced by the tool to determine if two modules are
> compatible.
>
> =3D=3D=3D TCB Stability =3D=3D=3D
>
> Updates change the TCB as viewed by attestation reports. In TDX there is =
a
> distinction between launch-time version and current version where TD-pres=
erving
> updates cause that latter version number to change, subject to Z-stream
> constraints. The need for runtime updates and the implications of that ve=
rsion
> change in the attestation was previously discussed in [3].
>
> =3D=3D=3D TDX Module Distribution Model =3D=3D=3D
>
> At a high level, Intel publishes all TDX modules on the github [2], along=
 with
> a mapping_file.json which documents the compatibility information about e=
ach
> TDX module and a script to install the TDX module. OS vendors can package
> these modules and distribute them. Administrators install the package and
> use the script to select the appropriate TDX module and install it via th=
e
> interfaces exposed by this series.
>
> [1]: https://cdrdv2.intel.com/v1/dl/getContent/733584
> [2]: https://github.com/intel/tdx-module-binaries
> [3]: https://lore.kernel.org/all/5d1da767-491b-4077-b472-2cc3d73246d6@ama=
zon.com/
>
>
> Chao Gao (20):
>   x86/virt/tdx: Print SEAMCALL leaf numbers in decimal
>   x86/virt/tdx: Prepare to support P-SEAMLDR SEAMCALLs
>   x86/virt/seamldr: Introduce a wrapper for P-SEAMLDR SEAMCALLs
>   x86/virt/tdx: Introduce a "tdx" subsystem and "tsm" device
>   x86/virt/tdx: Export tdx module attributes via sysfs
>   x86/virt/seamldr: Add a helper to read P-SEAMLDR information
>   x86/virt/tdx: Expose SEAMLDR information via sysfs
>   x86/virt/seamldr: Implement FW_UPLOAD sysfs ABI for TD-Preserving
>     Updates
>   x86/virt/seamldr: Allocate and populate a module update request
>   x86/virt/seamldr: Introduce skeleton for TD-Preserving updates
>   x86/virt/seamldr: Abort updates if errors occurred midway
>   x86/virt/seamldr: Shut down the current TDX module
>   x86/virt/tdx: Reset software states after TDX module shutdown
>   x86/virt/seamldr: Install a new TDX module
>   x86/virt/seamldr: Handle TD-Preserving update failures
>   x86/virt/seamldr: Do TDX cpu init after updates
>   x86/virt/tdx: Establish contexts for the new module
>   x86/virt/tdx: Update tdx_sysinfo and check features post-update
>   x86/virt/seamldr: Verify availability of slots for TD-Preserving
>     updates
>   x86/virt/seamldr: Enable TD-Preserving Updates
>
>  Documentation/ABI/testing/sysfs-devices-tdx |  32 ++
>  MAINTAINERS                                 |   1 +
>  arch/x86/Kconfig                            |  12 +
>  arch/x86/include/asm/tdx.h                  |  20 +-
>  arch/x86/include/asm/tdx_global_metadata.h  |  12 +
>  arch/x86/virt/vmx/tdx/Makefile              |   1 +
>  arch/x86/virt/vmx/tdx/seamldr.c             | 443 ++++++++++++++++++++
>  arch/x86/virt/vmx/tdx/seamldr.h             |  16 +
>  arch/x86/virt/vmx/tdx/tdx.c                 | 248 ++++++++++-
>  arch/x86/virt/vmx/tdx/tdx.h                 |  12 +
>  arch/x86/virt/vmx/tdx/tdx_global_metadata.c |  29 ++
>  arch/x86/virt/vmx/vmx.h                     |  40 ++
>  12 files changed, 862 insertions(+), 4 deletions(-)
>  create mode 100644 Documentation/ABI/testing/sysfs-devices-tdx
>  create mode 100644 arch/x86/virt/vmx/tdx/seamldr.c
>  create mode 100644 arch/x86/virt/vmx/tdx/seamldr.h
>  create mode 100644 arch/x86/virt/vmx/vmx.h
>
> --
> 2.47.1
>
>

Tested-by: Sagi Shahar <sagis@google.com>

I was able to update the module while several VMs were running on the
machine using a modified version of the tdx selftests. Measuring the
update time shows less than 10ms for update regardless of the number
of VMs running.

