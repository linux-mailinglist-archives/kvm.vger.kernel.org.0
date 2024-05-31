Return-Path: <kvm+bounces-18546-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A0A198D6830
	for <lists+kvm@lfdr.de>; Fri, 31 May 2024 19:34:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 29D451F264AE
	for <lists+kvm@lfdr.de>; Fri, 31 May 2024 17:34:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8D15D17BB06;
	Fri, 31 May 2024 17:34:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="V7a9c9Qo"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0403F2E3F2
	for <kvm@vger.kernel.org>; Fri, 31 May 2024 17:34:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717176861; cv=none; b=YC7tE2U551b9TEEluKQoc1wgt2cOuZXNViN8ZRHd2Ibpq7gFeN4Qb9Dk/6MNGQb9+cVXCCtOq9kNkBfLPU7JrzHKDTqkiwlhPqH0d7SoEu8j5E/cabskZ97YbuEG+IkkyBVR47h6Fa890OxqsktulWtAEnwz/cWPWMCCeAqOoGI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717176861; c=relaxed/simple;
	bh=BtQWntqO2+VPslYQy5+seZGfl9lfpWIcy0yrtY9jO+M=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=mHFVx5tZQqqPcwWGmLsjbw9+tjnV5dSDgxUcsuDmL5lmdSS/hPJXh9zg8DyyaudwceFAVo5a8aH6GtN+38iT2VfxwM+LzdDpO4892g1jKWhmmCGRzHiPzOj8btGhDP/rnSrIYkTbqDPzZiHwiHA/qf/qdFs1D1CK+xgFRGNURng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=V7a9c9Qo; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1717176858;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rTQBsLoLFyr/bsxrazI3Wdm6raiglGew9Gxd8uS7dnE=;
	b=V7a9c9QoMGkInrMKnHBUe7K65RuvsOUFnJEGeolAzwr7ZZ4vjwp2Vh6FsrqdjVL4VNRa4u
	NEDYCX/TXJx4L79k6lfEI2kN04AbfE1oo3AMQ4E9dejthwIflDhXROBBF/5Oo6E/qBWPh8
	vHbJ19FN7Ty+GgPBYJ7M6yCBrghO6b4=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-582-0QtICl9TMXCr54W7s0Priw-1; Fri, 31 May 2024 13:34:16 -0400
X-MC-Unique: 0QtICl9TMXCr54W7s0Priw-1
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-35dcb3f1ab3so1164142f8f.0
        for <kvm@vger.kernel.org>; Fri, 31 May 2024 10:34:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717176855; x=1717781655;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rTQBsLoLFyr/bsxrazI3Wdm6raiglGew9Gxd8uS7dnE=;
        b=GJ5mWMnsdK/yuFBseYyNnecupwojthgbk0MAQf5JTS9ONyvwrbaGJncutQjVulHy44
         4GOTIrkfFLGsQek7noR+jfEFbXVfapJKynpQsDGVB1ALHH/sOa6nDlldvrEoxhy9vGUQ
         cBi9KE4wkKtPfAszRm6PBTLN8soMC1CuFgylw0JZ3/s/5HKxyJHm3R9FbzYHpGkwGaTq
         Oog7uu6agrUVW2XMRESpkemOuozzhBspWgE3Kv3dnNrXVIcyv5Hw3Ex3SvOCMogV508M
         n4p94+wOCJnbDDDwi6XItCRPBl1hmpLrrtjEWDkwUZnmDNL6/CFTclrKKmKqgbdk4MNm
         A4tQ==
X-Forwarded-Encrypted: i=1; AJvYcCUgetTIqn0RJdFSR5hPZ4oXM2EHHejrdZPbNNQCyIPzW1aRRfdeLo6m6qHBy5SfO9UdC+Dl3vjFysDg8canJC2FP5//
X-Gm-Message-State: AOJu0Ywj5b2/1w4rJO4jZAKw2mnREmyIEI6E4+LmFvK0d0O2u8ATSit5
	EeBefOOOHmYHFRhm8BZH2N4zk4uMyOvmMZpcpXwvXUQ4sU9aNmkLzXLAUfhZJohQFDxEMTND6mX
	p2t8LgjYe0Njpue5cdobBGlp089cBlziBFfbR0JJ//Yn+Qme/o0Zvkglbxq9ITeBAM4QodSRrH+
	D6/GrVvvXtNgu+AwObh1sZpe2m
X-Received: by 2002:adf:f44d:0:b0:343:ef64:e0fd with SMTP id ffacd0b85a97d-35e0f30a89dmr1803389f8f.52.1717176855026;
        Fri, 31 May 2024 10:34:15 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGGDV1OH7Fl/Fo5KeMbK3huL5FBB8TDYOad1c8EHRVl8vG5i24CYXQ+/f0EkiCdmKIbgXwxYY1z1V3BGTcSQEs=
X-Received: by 2002:adf:f44d:0:b0:343:ef64:e0fd with SMTP id
 ffacd0b85a97d-35e0f30a89dmr1803373f8f.52.1717176854663; Fri, 31 May 2024
 10:34:14 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240530111643.1091816-1-pankaj.gupta@amd.com> <CABgObfYFryXwEtVkMH-F6kw8hrivpQD6USMQ9=7fVikn5-mAhQ@mail.gmail.com>
In-Reply-To: <CABgObfYFryXwEtVkMH-F6kw8hrivpQD6USMQ9=7fVikn5-mAhQ@mail.gmail.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Fri, 31 May 2024 19:34:03 +0200
Message-ID: <CABgObfbwr6CJK1XCmmVhp83AsC2YcQfSsfuPFWDuxzCB_R4GoQ@mail.gmail.com>
Subject: Re: [PATCH v4 00/31] Add AMD Secure Nested Paging (SEV-SNP) support
To: Pankaj Gupta <pankaj.gupta@amd.com>
Cc: qemu-devel@nongnu.org, brijesh.singh@amd.com, dovmurik@linux.ibm.com, 
	armbru@redhat.com, michael.roth@amd.com, xiaoyao.li@intel.com, 
	thomas.lendacky@amd.com, isaku.yamahata@intel.com, berrange@redhat.com, 
	kvm@vger.kernel.org, anisinha@redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, May 31, 2024 at 1:20=E2=80=AFPM Paolo Bonzini <pbonzini@redhat.com>=
 wrote:
>
> On Thu, May 30, 2024 at 1:16=E2=80=AFPM Pankaj Gupta <pankaj.gupta@amd.co=
m> wrote:
> >
> > These patches implement SEV-SNP base support along with CPUID enforceme=
nt
> > support for QEMU, and are also available at:
> >
> > https://github.com/pagupta/qemu/tree/snp_v4
> >
> > Latest version of kvm changes are posted here [2] and also queued in kv=
m/next.
> >
> > Patch Layout
> > ------------
> > 01-03: 'error_setg' independent fix, kvm/next header sync & patch from
> >        Xiaoyao's TDX v5 patchset.
> > 04-29: Introduction of sev-snp-guest object and various configuration
> >        requirements for SNP. Support for creating a cryptographic "laun=
ch" context
> >        and populating various OVMF metadata pages, BIOS regions, and vC=
PU/VMSA
> >        pages with the initial encrypted/measured/validated launch data =
prior to
> >        launching the SNP guest.
> > 30-31: Handling for KVM_HC_MAP_GPA_RANGE hypercall for userspace VMEXIT=
.
>
> These patches are more or less okay, with only a few nits, and I can
> queue them already:

Hey,

please check if branch qemu-coco-queue of
https://gitlab.com/bonzini/qemu works for you!

I tested it successfully on CentOS 9 Stream with kernel from kvm/next
and firmware from edk2-ovmf-20240524-1.fc41.noarch.

Paolo

> i386/sev: Replace error_report with error_setg
> linux-headers: Update to current kvm/next
> i386/sev: Introduce "sev-common" type to encapsulate common SEV state
> i386/sev: Move sev_launch_update to separate class method
> i386/sev: Move sev_launch_finish to separate class method
> i386/sev: Introduce 'sev-snp-guest' object
> i386/sev: Add a sev_snp_enabled() helper
> i386/sev: Add sev_kvm_init() override for SEV class
> i386/sev: Add snp_kvm_init() override for SNP class
> i386/cpu: Set SEV-SNP CPUID bit when SNP enabled
> i386/sev: Don't return launch measurements for SEV-SNP guests
> i386/sev: Add a class method to determine KVM VM type for SNP guests
> i386/sev: Update query-sev QAPI format to handle SEV-SNP
> i386/sev: Add the SNP launch start context
> i386/sev: Add handling to encrypt/finalize guest launch data
> i386/sev: Set CPU state to protected once SNP guest payload is finalized
> hw/i386/sev: Add function to get SEV metadata from OVMF header
> i386/sev: Add support for populating OVMF metadata pages
> i386/sev: Add support for SNP CPUID validation
> i386/sev: Invoke launch_updata_data() for SEV class
> i386/sev: Invoke launch_updata_data() for SNP class
> i386/kvm: Add KVM_EXIT_HYPERCALL handling for KVM_HC_MAP_GPA_RANGE
> i386/sev: Enable KVM_HC_MAP_GPA_RANGE hcall for SNP guests
> i386/sev: Extract build_kernel_loader_hashes
> i386/sev: Reorder struct declarations
> i386/sev: Allow measured direct kernel boot on SNP
> hw/i386/sev: Add support to encrypt BIOS when SEV-SNP is enabled
> memory: Introduce memory_region_init_ram_guest_memfd()
>
> These patches need a small prerequisite that I'll post soon:
>
> hw/i386/sev: Use guest_memfd for legacy ROMs
> hw/i386: Add support for loading BIOS using guest_memfd
>
> This one definitely requires more work:
>
> hw/i386/sev: Allow use of pflash in conjunction with -bios
>
>
> Paolo


