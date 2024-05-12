Return-Path: <kvm+bounces-17267-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 9FDB58C3540
	for <lists+kvm@lfdr.de>; Sun, 12 May 2024 09:14:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0EF0E1F215F3
	for <lists+kvm@lfdr.de>; Sun, 12 May 2024 07:14:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2A88910949;
	Sun, 12 May 2024 07:14:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="N5QloUeS"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 992E0E56C
	for <kvm@vger.kernel.org>; Sun, 12 May 2024 07:14:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715498081; cv=none; b=pp91qwo3c6wzPcCficInVhwM5lt5KLUwRjr7fL4Iro37e963G/MoFll9l7hHnqAd4EL86FUenFBXj9U9O2RZ/6qrIkyDG/T6uMx/YcaXubLaZjpKg02DAGQxh6Sv+cfpIHqBllya7PdoBxnzhplDRQTHjEN6b2EgJnp6HYj4Yi0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715498081; c=relaxed/simple;
	bh=xmGK9+ltbB1dd+0WpcC/iVsOMU10rWtj6TTQRHJPdMI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=iZBFCQ9D/mgUZdP//A3yWSWCDkzPgXJcOFOYP+eTOTfdTV9pyC9eczJmxZU58TZCSYhxTzWZ4UwAdiffW86Xq4Wm30a9Q4xjnywV6qUowvhwocB0t/xCfFsx+JIi1ifghBTB/ydjsRY7jRAk5salhvu1VEHiD5ZNKmwn+43UoHE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=N5QloUeS; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1715498078;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Z0Gt8ejjg+ir2Gwxhz9RzL//kwRLUT3dCdns47wQNqQ=;
	b=N5QloUeS2IZN1YYUiAKJYip2+kNf7YA3XLEjc6DiqTRwzYBms4sbTI3PrW2sWR2YeCrcND
	yV3MT/t9RO8R0wmHV/s2BdxFQ5AsJwnv/cEjVzzbh38u11njJwh/fV/qYfV1YUO8OdWyu9
	3o/5ep2HpZlgedaYYz7/xCjuYKRGj5A=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-557-ZHJ8R7QFNwGc8LAfa0utrA-1; Sun, 12 May 2024 03:14:35 -0400
X-MC-Unique: ZHJ8R7QFNwGc8LAfa0utrA-1
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-34f7618a1f2so2116853f8f.1
        for <kvm@vger.kernel.org>; Sun, 12 May 2024 00:14:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715498075; x=1716102875;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Z0Gt8ejjg+ir2Gwxhz9RzL//kwRLUT3dCdns47wQNqQ=;
        b=AJT9kHtulYWvzpDsUF77sF9ERcQfJ9v+slf+j039gyGY/a+v3OgpFlY2K90UaH3/tX
         ogchdCWlgCLvN1pfH+a4Kfxo4UTLTIG0NZP4xwocwMzsB07FElt6ut+MRCmGb1Chb3bH
         Sln+kSiIZjdCI4R+2v7BjMnWGmAZitYSUEVMbImQgQXancSN9ss53Fz15t7nX6/++QoH
         Fx8I6Vb422LYQde3YENgVFlnry8zsDEebiu3HmgtUQ9LhPxZq99hp7Qnla3uXGem5eBf
         nLIwRyXoQSi56/5jnuKEv/lPmhSKY//KIxFbd0Vuu518f9a3oHPpRaZEZn0gG5pqF9Nd
         fdQA==
X-Gm-Message-State: AOJu0Yx6exiTt5RMyQ77R5gKdImC3Yx0I+GEpSY+m8IXspSK5JtpzEe7
	Eb7oDpHU1IkSZUt0WMYkuJm4BdVtd+HoKTOTvE5UVuOf28OW1J0hxjSRfflVaU4vMM+siUt/t1b
	21coIw8Cbo3E3tD0VFWZW2ukmK0v4BT6dCwlpOF/33chP+LdZEkQTb9N2J50ZXf1x0xs0J1HonZ
	JUTne9BJdNd6BIHVO3hTfpYMik
X-Received: by 2002:a05:6000:4ed:b0:34d:ae34:1c14 with SMTP id ffacd0b85a97d-35018285324mr8360779f8f.18.1715498074833;
        Sun, 12 May 2024 00:14:34 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFZC9mYAP3CAxXRAmZA1Z2rLfLZuScPs3Cpn0JZevBEpUmMfcCCjfCnWBDDJN8ySXSEqSQPGFZQ7gYTgsq9VTk=
X-Received: by 2002:a05:6000:4ed:b0:34d:ae34:1c14 with SMTP id
 ffacd0b85a97d-35018285324mr8360755f8f.18.1715498074309; Sun, 12 May 2024
 00:14:34 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240510211024.556136-1-michael.roth@amd.com>
In-Reply-To: <20240510211024.556136-1-michael.roth@amd.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Sun, 12 May 2024 09:14:22 +0200
Message-ID: <CABgObfZxeqfNB4tETpH4PqPTnTi0C4pGmCST73a5cTdRWLO9Yw@mail.gmail.com>
Subject: Re: [PULL 00/19] KVM: Add AMD Secure Nested Paging (SEV-SNP)
 Hypervisor Support
To: Michael Roth <michael.roth@amd.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Sean Christopherson <seanjc@google.com>, linux-coco@lists.linux.dev, jroedel@suse.de, 
	thomas.lendacky@amd.com, vkuznets@redhat.com, pgonda@google.com, 
	rientjes@google.com, tobin@ibm.com, bp@alien8.de, vbabka@suse.cz, 
	alpergun@google.com, ashish.kalra@amd.com, nikunj.dadhania@amd.com, 
	pankaj.gupta@amd.com, liam.merwick@oracle.com, papaluri@amd.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, May 10, 2024 at 11:17=E2=80=AFPM Michael Roth <michael.roth@amd.com=
> wrote:
>
> Hi Paolo,
>
> This pull request contains v15 of the KVM SNP support patchset[1] along
> with fixes and feedback from you and Sean regarding PSC request processin=
g,
> fast_page_fault() handling for SNP/TDX, and avoiding uncessary
> PSMASH/zapping for KVM_EXIT_MEMORY_FAULT events. It's also been rebased
> on top of kvm/queue (commit 1451476151e0), and re-tested with/without
> 2MB gmem pages enabled.

Pulled into kvm-coco-queue, thanks (and sorry for the sev_complete_psc
mess up - it seemed too good to be true that the PSC changes were all
fine...).

Paolo

> Thanks!
>
> -Mike
>
> [1] https://lore.kernel.org/kvm/20240501085210.2213060-1-michael.roth@amd=
.com/
>
> The following changes since commit 1451476151e08e1e83ff07ce69dd0d1d025e97=
6e:
>
>   Merge commit 'kvm-coco-hooks' into HEAD (2024-05-10 13:20:42 -0400)
>
> are available in the Git repository at:
>
>   https://github.com/mdroth/linux.git tags/tags/kvm-queue-snp
>
> for you to fetch changes up to 4b3f0135f759bb1a54bb28d644c38a7780150eda:
>
>   crypto: ccp: Add the SNP_VLEK_LOAD command (2024-05-10 14:44:31 -0500)
>
> ----------------------------------------------------------------
> Base x86 KVM support for running SEV-SNP guests:
>
>  - add some basic infrastructure and introduces a new KVM_X86_SNP_VM
>    vm_type to handle differences versus the existing KVM_X86_SEV_VM and
>    KVM_X86_SEV_ES_VM types.
>
>  - implement the KVM API to handle the creation of a cryptographic
>    launch context, encrypt/measure the initial image into guest memory,
>    and finalize it before launching it.
>
>  - implement handling for various guest-generated events such as page
>    state changes, onlining of additional vCPUs, etc.
>
>  - implement the gmem/mmu hooks needed to prepare gmem-allocated pages
>    before mapping them into guest private memory ranges as well as
>    cleaning them up prior to returning them to the host for use as
>    normal memory. Because those cleanup hooks supplant certain
>    activities like issuing WBINVDs during KVM MMU invalidations, avoid
>    duplicating that work to avoid unecessary overhead.
>
>  - add support for the servicing of guest requests to handle things like
>    attestation, as well as some related host-management interfaces to
>    handle updating firmware's signing key for attestation requests
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
> Michael Roth (9):
>       KVM: MMU: Disable fast path if KVM_EXIT_MEMORY_FAULT is needed
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
>  arch/x86/include/asm/kvm_host.h                    |    2 +
>  arch/x86/include/asm/sev-common.h                  |   25 +
>  arch/x86/include/asm/sev.h                         |    3 +
>  arch/x86/include/asm/svm.h                         |    9 +-
>  arch/x86/include/uapi/asm/kvm.h                    |   48 +
>  arch/x86/kvm/Kconfig                               |    3 +
>  arch/x86/kvm/mmu.h                                 |    2 -
>  arch/x86/kvm/mmu/mmu.c                             |   25 +-
>  arch/x86/kvm/svm/sev.c                             | 1546 ++++++++++++++=
+++++-
>  arch/x86/kvm/svm/svm.c                             |   37 +-
>  arch/x86/kvm/svm/svm.h                             |   52 +
>  arch/x86/kvm/trace.h                               |   31 +
>  arch/x86/kvm/x86.c                                 |   17 +
>  drivers/crypto/ccp/sev-dev.c                       |   36 +
>  include/linux/psp-sev.h                            |    4 +-
>  include/uapi/linux/kvm.h                           |   23 +
>  include/uapi/linux/psp-sev.h                       |   27 +
>  include/uapi/linux/sev-guest.h                     |    9 +
>  virt/kvm/guest_memfd.c                             |    4 +-
>  22 files changed, 2086 insertions(+), 33 deletions(-)
>


