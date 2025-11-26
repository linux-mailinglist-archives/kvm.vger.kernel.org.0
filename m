Return-Path: <kvm+bounces-64628-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 670B4C88C3F
	for <lists+kvm@lfdr.de>; Wed, 26 Nov 2025 09:53:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 8DCCB4EC187
	for <lists+kvm@lfdr.de>; Wed, 26 Nov 2025 08:53:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E976831BCA7;
	Wed, 26 Nov 2025 08:51:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="U8N1NCG/";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="E5LWZV4I"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C1F231A56C
	for <kvm@vger.kernel.org>; Wed, 26 Nov 2025 08:51:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764147111; cv=none; b=fsxux9c8S0ZIAAjMZIQp9iLP6ttOFGJ9TnDzvWhl1BBMwXZ/A51PeNsvUoBegJisEGO9WyPFreYzRTJZ4zCrR+lOjoIrNwSiq6TMiYbpERwNM4VhFTU/Rx4r+N9AZsBMDM9bIlcQ6nshcVFO3UhOhagSoVOIQjbHtGM9+XM1DU4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764147111; c=relaxed/simple;
	bh=NWIXXAd0AsCq8D/Bf6rVqiEuxucumLs8aLQgOHznb4g=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=QpcuYF0DPxYkf2p61WpgucJ4QkEwQDc0TkK+wN5irAx8VoGbAhJc8JUatD7OXLDNQ6ZsG+kn/phfoFhwYutyN5QhXt8LZouZ7teQm8UY1vquzzY4484cQwrl6mdQY117sCV5/Z+r3AmsKQxmlCQ3EKaD5ZzoQHEb/DuiehkGbaY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=U8N1NCG/; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=E5LWZV4I; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764147108;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SOyvoqkk9UFppQOun6ompHVRWctQkRb5nZd6ey6j320=;
	b=U8N1NCG/x+Z63sd1cxLT+LNXxTtk8UmowuMko4ZrfCCFpbQMj3+CGCIra3MMyNepFFcV45
	Wq3kZPxyjYHpzXGzbXAlppmJwgXcDPBiMkNE8cQtKRB8tCysNQwIPfXebnWp4W0TFJnmI7
	dXbhoOXZTUyABONtLNL4Qy2xPizYpHc=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-541-Bj19XWeaNwW36z-Qf-vjvg-1; Wed, 26 Nov 2025 03:51:43 -0500
X-MC-Unique: Bj19XWeaNwW36z-Qf-vjvg-1
X-Mimecast-MFC-AGG-ID: Bj19XWeaNwW36z-Qf-vjvg_1764147102
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-42b2e448bd9so5309169f8f.1
        for <kvm@vger.kernel.org>; Wed, 26 Nov 2025 00:51:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1764147102; x=1764751902; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SOyvoqkk9UFppQOun6ompHVRWctQkRb5nZd6ey6j320=;
        b=E5LWZV4IMN3H4JxzUySEFpneY7BYGeT3hwZv/AdWJdn7gmM7Ai9oCNQjKiAATGAfyG
         N17NQh2si4fvAKWzEriu1vHMZbO7VxL6VHElitVS7T8O57KcZkq1s62p7U+kUsHDt7xW
         BVxbK3Y5OWbPDWlsfkzUtpnWV0LaFsMWVINzXJ62d7IoZy2qWclUUvssCUm8zIWgwxRk
         tk5pTGDH26orsGzH+9T7FUD8aIC3SOd1pSS550JrCUyfnqtejkgJNbHkDWgQfwaxDJpB
         jaAz3XZE9RR6a5ZzQ+hae59c9FoCgq+YzbYBN5Gniua6VyPReoYqtEJBbfKLwko3mRez
         iY4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764147102; x=1764751902;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=SOyvoqkk9UFppQOun6ompHVRWctQkRb5nZd6ey6j320=;
        b=ECkmb11G6yJx16liE7RwD31DlHoCrENQwIHdWQIDgiyFv/LQ/3QTpPeupO0fhwSFQ6
         zvc7tKadZGTQZn6HE66f1mIog/M86DaRnrCwvetVTt4qfLuC2mSSslvpax6OX69eTPqm
         3PXlvZqWzhsi6eXglFGPwYtDMBarzfrAGYmWKmIlXK371mgbc5ReBHoCoGT9WSgYLzJl
         MX21xHJHIyIbUV6VTwBERc4CQAu6t7GH2l1TUcMyu+C1NX1yTlUHZEtdiDnPvDoC+YY8
         wBTs049h8/v577IVQRxrNtNFclkY8iGHpVPJeK9grkCY7f2J1I1LxzXjtWlrRqLhvg5A
         Iy1A==
X-Gm-Message-State: AOJu0YznUqZfhaiH3t79VnGe4WWq4tppeI1aiH1oBf3/grm7nyaCBIwM
	gui7MJSrC4dKBkVB9hDmISEuW4obZDgnF3ebcMIHFQn1v93/GJzMxe+SEvrde4bjfu1EhYerXlF
	wcJR/hF1rmW6uHPoV4METr9OTZtJQpEzfZCpDlXgdD+3umwrOFk7boMA5aCig3z70apN+Orpoay
	/Ha9afK1pvXh5UpJEpLwdNTzOvyyMC
X-Gm-Gg: ASbGncvIDDnWmRMzGdNp2IKALUZ2oKlIFleNliWrOBXHIAtnK1Zvm9RhGuHHgLpLuZ5
	Ym1uNJ64Kb/5I1LhroyTZLg4Sf+ZCygkgbJrJYCwoQkfbgifpcdE5f/X08greD65Yl4Yl9Ftfab
	KAJa48AFD8w9XOGi1iyKdMiXlaWmH0k/qiWmrmLMcANzFEl+IiI9BB2xlcOPf+DkUxd5RRXuNUc
	9bNSGwuhBUTE0H9o1NBDtqKxDUK1YGz2KNc85uA/egQ+2r5TcGIrE6yFxTY2ziee0ysK24=
X-Received: by 2002:a05:6000:1889:b0:42b:3ab7:b8b9 with SMTP id ffacd0b85a97d-42e0f21e8c6mr6288662f8f.20.1764147102114;
        Wed, 26 Nov 2025 00:51:42 -0800 (PST)
X-Google-Smtp-Source: AGHT+IE9bsjrAIAdt2de4p4PYRXMAhzhDmsnAr9c1eHWXz1kC2WCjpRhNZ8ZGhWdZTsTcB2P3zkGMcD0lywMAtW+sUE=
X-Received: by 2002:a05:6000:1889:b0:42b:3ab7:b8b9 with SMTP id
 ffacd0b85a97d-42e0f21e8c6mr6288635f8f.20.1764147101684; Wed, 26 Nov 2025
 00:51:41 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251126014455.788131-1-seanjc@google.com> <20251126014455.788131-6-seanjc@google.com>
In-Reply-To: <20251126014455.788131-6-seanjc@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Wed, 26 Nov 2025 09:51:29 +0100
X-Gm-Features: AWmQ_blkEpEspDd74Pq8URMu41Mld6_5OicZsgsXr_eU4nvR7G0dfBeBx7wP5Sk
Message-ID: <CABgObfa+cVCi=+++BCY9cYXJtXZgXBG3FnzHH47aPuHP_uhMEw@mail.gmail.com>
Subject: Re: [GIT PULL] KVM: x86: Selftests changes for 6.19
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 26, 2025 at 2:45=E2=80=AFAM Sean Christopherson <seanjc@google.=
com> wrote:
>
> The highlights are Jim's LA57 nested VMX test, and Yosry's many changes t=
o
> extend nested VMX tests to also cover nested SVM.
>
> The following changes since commit 211ddde0823f1442e4ad052a2f30f050145cca=
da:
>
>   Linux 6.18-rc2 (2025-10-19 15:19:16 -1000)
>
> are available in the Git repository at:
>
>   https://github.com/kvm-x86/linux.git tags/kvm-x86-selftests-6.19
>
> for you to fetch changes up to d2e50389ab44acfa05e72604d701a70b234f9938:
>
>   KVM: selftests: Make sure vm->vpages_mapped is always up-to-date (2025-=
11-21 10:17:05 -0800)

Pulled, thanks.

Paolo

> ----------------------------------------------------------------
> KVM selftests changes for 6.19:
>
>  - Fix a math goof in mmu_stress_test when running on a single-CPU system=
/VM.
>
>  - Forcefully override ARCH from x86_64 to x86 to play nice with specifyi=
ng
>    ARCH=3Dx86_64 on the command line.
>
>  - Extend a bunch of nested VMX to validate nested SVM as well.
>
>  - Add support for LA57 in the core VM_MODE_xxx macro, and add a test to
>    verify KVM can save/restore nested VMX state when L1 is using 5-level
>    paging, but L2 is not.
>
>  - Clean up the guest paging code in anticipation of sharing the core log=
ic for
>    nested EPT and nested NPT.
>
> ----------------------------------------------------------------
> Brendan Jackman (1):
>       KVM: selftests: Don't fall over in mmu_stress_test when only one CP=
U is present
>
> Jim Mattson (4):
>       KVM: selftests: Use a loop to create guest page tables
>       KVM: selftests: Use a loop to walk guest page tables
>       KVM: selftests: Change VM_MODE_PXXV48_4K to VM_MODE_PXXVYY_4K
>       KVM: selftests: Add a VMX test for LA57 nested state
>
> Sean Christopherson (2):
>       KVM: selftests: Forcefully override ARCH from x86_64 to x86
>       KVM: selftests: Use "gpa" and "gva" for local variable names in pre=
-fault test
>
> Yosry Ahmed (9):
>       KVM: selftests: Extend vmx_close_while_nested_test to cover SVM
>       KVM: selftests: Extend vmx_nested_tsc_scaling_test to cover SVM
>       KVM: selftests: Move nested invalid CR3 check to its own test
>       KVM: selftests: Extend nested_invalid_cr3_test to cover SVM
>       KVM: selftests: Extend vmx_tsc_adjust_test to cover SVM
>       KVM: selftests: Stop hardcoding PAGE_SIZE in x86 selftests
>       KVM: selftests: Remove the unused argument to prepare_eptp()
>       KVM: selftests: Stop using __virt_pg_map() directly in tests
>       KVM: selftests: Make sure vm->vpages_mapped is always up-to-date
>
>  tools/testing/selftests/kvm/Makefile               |   2 +-
>  tools/testing/selftests/kvm/Makefile.kvm           |   8 +-
>  tools/testing/selftests/kvm/include/kvm_util.h     |   5 +-
>  .../testing/selftests/kvm/include/x86/processor.h  |   2 +-
>  tools/testing/selftests/kvm/include/x86/vmx.h      |   3 +-
>  tools/testing/selftests/kvm/lib/arm64/processor.c  |   2 +-
>  tools/testing/selftests/kvm/lib/kvm_util.c         |  33 +++---
>  tools/testing/selftests/kvm/lib/x86/memstress.c    |   2 +-
>  tools/testing/selftests/kvm/lib/x86/processor.c    |  84 ++++++-------
>  tools/testing/selftests/kvm/lib/x86/vmx.c          |   9 +-
>  tools/testing/selftests/kvm/mmu_stress_test.c      |  10 +-
>  .../testing/selftests/kvm/pre_fault_memory_test.c  |  32 +++--
>  tools/testing/selftests/kvm/x86/hyperv_features.c  |   2 +-
>  tools/testing/selftests/kvm/x86/hyperv_ipi.c       |  18 +--
>  tools/testing/selftests/kvm/x86/hyperv_tlb_flush.c |   2 +-
>  ...while_nested_test.c =3D> nested_close_kvm_test.c} |  42 +++++--
>  .../selftests/kvm/x86/nested_invalid_cr3_test.c    | 116 +++++++++++++++=
+++
>  ..._tsc_adjust_test.c =3D> nested_tsc_adjust_test.c} |  73 +++++++-----
>  ...sc_scaling_test.c =3D> nested_tsc_scaling_test.c} |  48 +++++++-
>  tools/testing/selftests/kvm/x86/sev_smoke_test.c   |   2 +-
>  tools/testing/selftests/kvm/x86/state_test.c       |   2 +-
>  .../testing/selftests/kvm/x86/userspace_io_test.c  |   2 +-
>  .../testing/selftests/kvm/x86/vmx_dirty_log_test.c |  12 +-
>  .../selftests/kvm/x86/vmx_nested_la57_state_test.c | 132 +++++++++++++++=
++++++
>  24 files changed, 479 insertions(+), 164 deletions(-)
>  rename tools/testing/selftests/kvm/x86/{vmx_close_while_nested_test.c =
=3D> nested_close_kvm_test.c} (64%)
>  create mode 100644 tools/testing/selftests/kvm/x86/nested_invalid_cr3_te=
st.c
>  rename tools/testing/selftests/kvm/x86/{vmx_tsc_adjust_test.c =3D> neste=
d_tsc_adjust_test.c} (61%)
>  rename tools/testing/selftests/kvm/x86/{vmx_nested_tsc_scaling_test.c =
=3D> nested_tsc_scaling_test.c} (83%)
>  create mode 100644 tools/testing/selftests/kvm/x86/vmx_nested_la57_state=
_test.c
>


