Return-Path: <kvm+bounces-14964-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B2D908A8365
	for <lists+kvm@lfdr.de>; Wed, 17 Apr 2024 14:48:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6DB5A282B40
	for <lists+kvm@lfdr.de>; Wed, 17 Apr 2024 12:48:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9CC6613D602;
	Wed, 17 Apr 2024 12:48:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="M+BHf5uJ"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BE607FBB2
	for <kvm@vger.kernel.org>; Wed, 17 Apr 2024 12:48:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713358108; cv=none; b=W8n5fxZPPp/wR0Qds5qikoao73pnj0dtpWhZM1gtZQkzaHhezndVi8q8fJeh/dutSPielhbgb+3TImHlWocWgi792Fr7yIJdST6CfUtiSoJD1Tm/ll939f6E0lJcQRwrXp4fSNm2Mc2LTBDczwgo0CWsV7x+r514eXsS9gLW9kU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713358108; c=relaxed/simple;
	bh=+rBnuoxv9VlVOrTjCie1no0lsCBuIakPwhY4YqzQ+JQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=bY6GBrYEtY1G/X65zcXgGoyV7B4Ee+1PEf9KF8dm4oyGzUpuFiagAJFxRcENk3mM//nvHNdqk11joUJ9D9fR3+XHXAv1wA5RH99AvhKuZpkhSuJ2LkrH+3WqMMCSp1E9Y7pqKQ4ls1WsFAs5fu+8/Qob0XztoLzozoMuAorlDzw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=M+BHf5uJ; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1713358106;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6XsYlRw5sh/Id3XxML2Zd3Q4eq9CQ2fiMXrzcUrmGHw=;
	b=M+BHf5uJBpECw5PDnxer6CWNttO0QZsJ3i8XZOmynA4MSET3ppl6V/XouQFykdga8vVBKw
	dkMniwFNg8SCBDVDo8+/Zb108hKo1qR2IjCsKp2OZQDtb/9UtRmQBJvpVSoqmopMwosdfd
	0znaldAjKfnmFvDC81TCvzDKgm4EGDQ=
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com
 [209.85.210.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-120-7MEGbsi6PmirMcM4ZND5lQ-1; Wed, 17 Apr 2024 08:48:24 -0400
X-MC-Unique: 7MEGbsi6PmirMcM4ZND5lQ-1
Received: by mail-pf1-f200.google.com with SMTP id d2e1a72fcca58-6ed03216b70so3687971b3a.3
        for <kvm@vger.kernel.org>; Wed, 17 Apr 2024 05:48:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713358103; x=1713962903;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6XsYlRw5sh/Id3XxML2Zd3Q4eq9CQ2fiMXrzcUrmGHw=;
        b=C8lB7tbUSoeFpID8MoPJ6yihrIktF2zwlv58Aq10y+9iYaO6rr7n5CFpw+UdE0Kal6
         6aRpQphJ+9cHOl4fO8g8HQlr9nqi37jyjBncH8pDX8bzyCckWjEpCDgvjJckxy4YIiQb
         RBPXrn/4aOeOZ774PhPIqjGjn2l6X5JqoskEKjfzhbtCKye6iq/zGGNNoLEmXc6IwmRH
         NDr6Ns5FCVqH+ARZ9QAHFOq+FknepW+247UmtWdK5f/EGrwaNdfRtVzx54k+35D5ShBA
         sQjnBezLd0Maymxv/wpVqqWNvvt9QodpEirI7bzLzHoE0OlMhA0/MH82/hc/YZo1saD4
         Bi4g==
X-Gm-Message-State: AOJu0YzhD4QV3Njx2GN+cG8qp60QX2Esfa0pkeoLGabF/CXLBwD2ov/7
	joDtRU6R5/Q4OxcJcHV1NzttH8fkgCGD8Vq8zDusk/5WM3IlCSOGkTC4zdRvWL9JN79Oel4ycBF
	kUYQEmLqgXMRoWXKNGqUiy+X5/D7WdHohNO4kOSDzii9LB+G2SXFiMu5tzYQnroQrb2xAujKD4B
	95ze8cUNZp+wSkzWHxpdf6aArX
X-Received: by 2002:a05:6a00:1145:b0:6ed:60a4:777b with SMTP id b5-20020a056a00114500b006ed60a4777bmr13933273pfm.8.1713358102766;
        Wed, 17 Apr 2024 05:48:22 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGPWJ+3fFWpa9zfgX/yDQECXGExCP4Uxebsr47vLufIZ/BxxkIR9X35cFdJB6vwM4FQuq7CNfopgDLTm8yH2o4=
X-Received: by 2002:a05:6a00:1145:b0:6ed:60a4:777b with SMTP id
 b5-20020a056a00114500b006ed60a4777bmr13933250pfm.8.1713358102404; Wed, 17 Apr
 2024 05:48:22 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240228024147.41573-1-seanjc@google.com>
In-Reply-To: <20240228024147.41573-1-seanjc@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Wed, 17 Apr 2024 14:48:08 +0200
Message-ID: <CABgObfaS7RhUPe_FYS9SCuDzOfFw4X9P8XOhJSspVdzsYeoX2A@mail.gmail.com>
Subject: Re: [PATCH 00/16] KVM: x86/mmu: Page fault and MMIO cleanups
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Yan Zhao <yan.y.zhao@intel.com>, Isaku Yamahata <isaku.yamahata@intel.com>, 
	Michael Roth <michael.roth@amd.com>, Yu Zhang <yu.c.zhang@linux.intel.com>, 
	Chao Peng <chao.p.peng@linux.intel.com>, Fuad Tabba <tabba@google.com>, 
	David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Feb 28, 2024 at 3:41=E2=80=AFAM Sean Christopherson <seanjc@google.=
com> wrote:
>
> This is a combination of prep work for TDX and SNP, and a clean up of the
> page fault path to (hopefully) make it easier to follow the rules for
> private memory, noslot faults, writes to read-only slots, etc.
>
> Paolo, this is the series I mentioned in your TDX/SNP prep work series.
> Stating the obvious, these
>
>   KVM: x86/mmu: Pass full 64-bit error code when handling page faults
>   KVM: x86: Move synthetic PFERR_* sanity checks to SVM's #NPF handler
>
> are the drop-in replacements.

Applied to kvm-coco-queue, thanks, and these to kvm/queue as well:

 KVM: x86/mmu: Exit to userspace with -EFAULT if private fault hits emulati=
on
 KVM: x86: Remove separate "bit" defines for page fault error code masks
 KVM: x86: Define more SEV+ page fault error bits/flags for #NPF
 KVM: x86: Move synthetic PFERR_* sanity checks to SVM's #NPF handler
 KVM: x86/mmu: Pass full 64-bit error code when handling page faults
 KVM: x86/mmu: WARN if upper 32 bits of legacy #PF error code are non-zero

I have made a little hack for kvm-coco-queue, preserving for now the
usage of PFERR_GUEST_ENC_MASK in case people were relying on the
branch, to limit the rebase pain.

The remaining parts are split into a "[TO SQUASH] KVM: x86/mmu: Use
synthetic page fault error code to indicate private faults" commit at
the end of the branch.

Paolo

> Isaku Yamahata (1):
>   KVM: x86/mmu: Pass full 64-bit error code when handling page faults
>
> Sean Christopherson (15):
>   KVM: x86/mmu: Exit to userspace with -EFAULT if private fault hits
>     emulation
>   KVM: x86: Remove separate "bit" defines for page fault error code
>     masks
>   KVM: x86: Define more SEV+ page fault error bits/flags for #NPF
>   KVM: x86/mmu: Use synthetic page fault error code to indicate private
>     faults
>   KVM: x86/mmu: WARN if upper 32 bits of legacy #PF error code are
>     non-zero
>   KVM: x86: Move synthetic PFERR_* sanity checks to SVM's #NPF handler
>   KVM: x86/mmu: WARN and skip MMIO cache on private, reserved page
>     faults
>   KVM: x86/mmu: Move private vs. shared check above slot validity checks
>   KVM: x86/mmu: Don't force emulation of L2 accesses to non-APIC
>     internal slots
>   KVM: x86/mmu: Explicitly disallow private accesses to emulated MMIO
>   KVM: x86/mmu: Move slot checks from __kvm_faultin_pfn() to
>     kvm_faultin_pfn()
>   KVM: x86/mmu: Handle no-slot faults at the beginning of
>     kvm_faultin_pfn()
>   KVM: x86/mmu: Set kvm_page_fault.hva to KVM_HVA_ERR_BAD for "no slot"
>     faults
>   KVM: x86/mmu: Initialize kvm_page_fault's pfn and hva to error values
>   KVM: x86/mmu: Sanity check that __kvm_faultin_pfn() doesn't create
>     noslot pfns
>
>  arch/x86/include/asm/kvm_host.h |  45 ++++-----
>  arch/x86/kvm/mmu.h              |   4 +-
>  arch/x86/kvm/mmu/mmu.c          | 159 +++++++++++++++++++-------------
>  arch/x86/kvm/mmu/mmu_internal.h |  24 ++++-
>  arch/x86/kvm/mmu/mmutrace.h     |   2 +-
>  arch/x86/kvm/svm/svm.c          |   9 ++
>  6 files changed, 151 insertions(+), 92 deletions(-)
>
>
> base-commit: ec1e3d33557babed2c2c2c7da6e84293c2f56f58
> --
> 2.44.0.278.ge034bb2e1d-goog
>


