Return-Path: <kvm+bounces-18530-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 710FE8D6087
	for <lists+kvm@lfdr.de>; Fri, 31 May 2024 13:20:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 7127DB22A04
	for <lists+kvm@lfdr.de>; Fri, 31 May 2024 11:20:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0FDE4157469;
	Fri, 31 May 2024 11:20:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="heGP4H2y"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C067015575A
	for <kvm@vger.kernel.org>; Fri, 31 May 2024 11:20:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717154419; cv=none; b=Hlszfh80Fg1BPViXtG1OnVTCK66kDgSoMz0HYPDhoBJzzzjh47WEluPoNxnpNmS+vDhV605A+0ZtI8Ge81DPWYYLXUGZWhm2yYDwnXw7SMlMhXmQ7UZXa9dygJjksTL7N5bUFrenyIxq02iwfstjvvgjkGxbMYb9J1zR8td4m/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717154419; c=relaxed/simple;
	bh=1rZKSny5TZ5CLpKvgXjnGQRNKK+vvP+aT8AmsC9AaDc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=GlWgDh25voO1p1NddLROwQgtNTVlMhDiYJ2BaOu+mDQypNAsg7NLbG7yJnznhDQN9DnifX7h6v4CHhHYOp4gdI0ApT05FQmbeniCkT9KzacVMdrEpd4ozR/6sdVHGxK5nFrymdDMD5/kZrqKWNB+GvW7xkU4gUaay9MebxE6OTg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=heGP4H2y; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1717154416;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6S+C2lwFRABkA7b/yNrzv8UAxWC5/SnV83op21vezLg=;
	b=heGP4H2y8Bc6s231QQSJYtWywoqPWBFx1J635SenkfObYocyYIDcUokepEyZAZMKb5nQ5w
	J8NcCA2bP8qtHEtPtxAxFSWUHS727Mbn9xQwe2vkQrejyYVCmutCd84bwlVs0+3aQwXjrl
	RGuoWOlMXBZ7Sp/n+4uQu9xomdlJjlg=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-261-U4nKp5OGONqNgeOlnYIVHg-1; Fri, 31 May 2024 07:20:15 -0400
X-MC-Unique: U4nKp5OGONqNgeOlnYIVHg-1
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-3580f213373so1322082f8f.3
        for <kvm@vger.kernel.org>; Fri, 31 May 2024 04:20:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717154414; x=1717759214;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6S+C2lwFRABkA7b/yNrzv8UAxWC5/SnV83op21vezLg=;
        b=cDpjKoclO+eGgmA+l2lp7MQqK4xOyiqRqeXgWgccVYJUZ2c3nVETxtFfarBMn3FhrS
         M0vx82nSmxmKkCTvISAD1Vk6EA7VnxWdgjeIlrcGYRBnavP+9Pk8yqNOVcrhrWtv6yeT
         1v10IWMcK6y4KQN1oq+VwKqs/Bt5Op+UfhxRb+kXDS7B8NOazQ4WmgDbIKndztgaTrZ2
         CtgFgPab7u2ZkIk9mmpd9LzdQBKgNW2INlJGwvtkajsyhxJCzr9tDFs474W3Y6GaXLlS
         kiQ9D85Ba/hI1dYqLxg8kc1AfcYmchHaOjpcYh9hdFrqogBJsiMsxGM1vGhwrrkYuC0y
         CShQ==
X-Forwarded-Encrypted: i=1; AJvYcCWm3+d7zfoVpgHNOvfQNE6m43eVcxpFmLY+/H0Wfgc18SbwBAhINpLBrFwqIRwjtb5S25XLPf+qwWuFKkEaFlyZkWfd
X-Gm-Message-State: AOJu0Yxz+1Ky6wDilG136LQANs33yGicBlZ5sVKrgaXETZLR9gmKnS0B
	vmZLQKcrSsCMhewD4BE1AQ7/R+oN5NcmapDM0sNGvpvhsoe8mXWGtSiur+eqFH7xFT0UKaEW/5F
	Vv6MDzbCiIJFtuHOFvVOqr/bRN+8oeVleLcPllMIfn4UyhSGSBfYiHsNN76JKnRnLxl83NOTEto
	kgXn4O8TmTEnu3OZtJD9ZECH4b
X-Received: by 2002:a5d:5485:0:b0:354:f142:65b0 with SMTP id ffacd0b85a97d-35e0f28858fmr1309277f8f.37.1717154414318;
        Fri, 31 May 2024 04:20:14 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEYp6xUGQT7bi8LdHr2e9yWbwlbI5+B9hJbVUhizSshOYnjvKEPDgyMxtG7hIxlGQurdYpeKMkLSRIu2kER3AY=
X-Received: by 2002:a5d:5485:0:b0:354:f142:65b0 with SMTP id
 ffacd0b85a97d-35e0f28858fmr1309244f8f.37.1717154413770; Fri, 31 May 2024
 04:20:13 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240530111643.1091816-1-pankaj.gupta@amd.com>
In-Reply-To: <20240530111643.1091816-1-pankaj.gupta@amd.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Fri, 31 May 2024 13:20:02 +0200
Message-ID: <CABgObfYFryXwEtVkMH-F6kw8hrivpQD6USMQ9=7fVikn5-mAhQ@mail.gmail.com>
Subject: Re: [PATCH v4 00/31] Add AMD Secure Nested Paging (SEV-SNP) support
To: Pankaj Gupta <pankaj.gupta@amd.com>
Cc: qemu-devel@nongnu.org, brijesh.singh@amd.com, dovmurik@linux.ibm.com, 
	armbru@redhat.com, michael.roth@amd.com, xiaoyao.li@intel.com, 
	thomas.lendacky@amd.com, isaku.yamahata@intel.com, berrange@redhat.com, 
	kvm@vger.kernel.org, anisinha@redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, May 30, 2024 at 1:16=E2=80=AFPM Pankaj Gupta <pankaj.gupta@amd.com>=
 wrote:
>
> These patches implement SEV-SNP base support along with CPUID enforcement
> support for QEMU, and are also available at:
>
> https://github.com/pagupta/qemu/tree/snp_v4
>
> Latest version of kvm changes are posted here [2] and also queued in kvm/=
next.
>
> Patch Layout
> ------------
> 01-03: 'error_setg' independent fix, kvm/next header sync & patch from
>        Xiaoyao's TDX v5 patchset.
> 04-29: Introduction of sev-snp-guest object and various configuration
>        requirements for SNP. Support for creating a cryptographic "launch=
" context
>        and populating various OVMF metadata pages, BIOS regions, and vCPU=
/VMSA
>        pages with the initial encrypted/measured/validated launch data pr=
ior to
>        launching the SNP guest.
> 30-31: Handling for KVM_HC_MAP_GPA_RANGE hypercall for userspace VMEXIT.

These patches are more or less okay, with only a few nits, and I can
queue them already:

i386/sev: Replace error_report with error_setg
linux-headers: Update to current kvm/next
i386/sev: Introduce "sev-common" type to encapsulate common SEV state
i386/sev: Move sev_launch_update to separate class method
i386/sev: Move sev_launch_finish to separate class method
i386/sev: Introduce 'sev-snp-guest' object
i386/sev: Add a sev_snp_enabled() helper
i386/sev: Add sev_kvm_init() override for SEV class
i386/sev: Add snp_kvm_init() override for SNP class
i386/cpu: Set SEV-SNP CPUID bit when SNP enabled
i386/sev: Don't return launch measurements for SEV-SNP guests
i386/sev: Add a class method to determine KVM VM type for SNP guests
i386/sev: Update query-sev QAPI format to handle SEV-SNP
i386/sev: Add the SNP launch start context
i386/sev: Add handling to encrypt/finalize guest launch data
i386/sev: Set CPU state to protected once SNP guest payload is finalized
hw/i386/sev: Add function to get SEV metadata from OVMF header
i386/sev: Add support for populating OVMF metadata pages
i386/sev: Add support for SNP CPUID validation
i386/sev: Invoke launch_updata_data() for SEV class
i386/sev: Invoke launch_updata_data() for SNP class
i386/kvm: Add KVM_EXIT_HYPERCALL handling for KVM_HC_MAP_GPA_RANGE
i386/sev: Enable KVM_HC_MAP_GPA_RANGE hcall for SNP guests
i386/sev: Extract build_kernel_loader_hashes
i386/sev: Reorder struct declarations
i386/sev: Allow measured direct kernel boot on SNP
hw/i386/sev: Add support to encrypt BIOS when SEV-SNP is enabled
memory: Introduce memory_region_init_ram_guest_memfd()

These patches need a small prerequisite that I'll post soon:

hw/i386/sev: Use guest_memfd for legacy ROMs
hw/i386: Add support for loading BIOS using guest_memfd

This one definitely requires more work:

hw/i386/sev: Allow use of pflash in conjunction with -bios


Paolo


