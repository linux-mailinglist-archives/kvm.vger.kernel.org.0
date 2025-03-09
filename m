Return-Path: <kvm+bounces-40523-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D7FCEA5816F
	for <lists+kvm@lfdr.de>; Sun,  9 Mar 2025 09:07:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B21063AAC5A
	for <lists+kvm@lfdr.de>; Sun,  9 Mar 2025 08:07:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 700D718CC1D;
	Sun,  9 Mar 2025 08:07:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="T8SiOuTQ"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C70202DF68
	for <kvm@vger.kernel.org>; Sun,  9 Mar 2025 08:07:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741507652; cv=none; b=uoK2vCj+RWW8TEU4ibueN2s6YUW23OtmBAcNBqVTzsMNAYrJ27lIk8BYEozogukV0umqlsEMHdBeXKIVBQE/tBvIaGP0FBG0kIKe/wrUO5k6RFyU8GKNch0NLaA8JRcKgfv/aGjeJvsfkmWrN/bJ2kL0js06NtfF7tDirxgoyCc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741507652; c=relaxed/simple;
	bh=99NEVqvBP5TRbaKk01Oc0W/ttk9cc30UFtifsXasBuM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=MZaKdZY0cI+7/iceAKzrZSx5c4XJBia1XxoFX5OF/t9r6iRzWANWouiBmDg4nnp1UdbvCSnQhhbNobsF6E+7uDFJ4hGWODONX6kYEX4xrXcrg1sle95mrclucAoMnkSDBi+DcAqG9AQuYKW3vl3eY27eMROopaS75FYExX5KY1g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=T8SiOuTQ; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1741507649;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bMxc923CRiMks37b+Jjb8HyITgLj/wOpsi581iiQzTY=;
	b=T8SiOuTQQ0T6Rb19uqgfHMwOjjxc0udWW/JB8b5Mxlnyzlo4dZUDH46pTkQxF3CtwxgH03
	wOXH8ZwbAY8V/RQYqKvGM8uAxgO2+n2JWNlM4Us5a3+bbtmHOO25aOupaLOrdRB7IDE2cj
	5xHqzo9Qush9bjNdyWqIt18Fsl5ZPx0=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-286-LDMkTRLvM_G-5HZA4Cd8ng-1; Sun, 09 Mar 2025 04:07:28 -0400
X-MC-Unique: LDMkTRLvM_G-5HZA4Cd8ng-1
X-Mimecast-MFC-AGG-ID: LDMkTRLvM_G-5HZA4Cd8ng_1741507647
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-3913f546dfbso488578f8f.1
        for <kvm@vger.kernel.org>; Sun, 09 Mar 2025 00:07:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741507645; x=1742112445;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bMxc923CRiMks37b+Jjb8HyITgLj/wOpsi581iiQzTY=;
        b=VBnUTfhwMs00mh24wmL6cwaCXvF8onL+H2Axw0Zm9NpYQk4gPVK9akvG1hHcs31vPf
         GOtP1eKFPPyeL1AZFmZ3w2SSvFp58aWcAADkQpob2ytWSyaEI4B38rNXFqSSskz2pHIa
         h2maaZqSjsI12wWONVZch1mYDvmxrpXtiIQ55IySzmLKUAqQR+Cmdf/U/tljl5/CJmv9
         efJ5YPWX1lZt+/6i/YHvoJXvdw0GZTYPIjrX0MdjjJixHo7xQWAiOQXpHrEaI0gsaNnV
         2/3DQ14o8ROuuv+NjWydqmz4uWCLR7kt5Y9P49bdtyLmb9YT58RmH9meHFgZ7zeAh+6y
         /6Qw==
X-Gm-Message-State: AOJu0YwWaCXYe0/CG2mJQV8uR/m1m8fPtujgliGke5mC9RV6u8XTAbSU
	gF2aqEFKZ7P9piaLcQ7KsuYHX1as7Cy2UpMRcPgbG+NKkVGLH8La2bXsRXx/teDiDcLLWykbSVQ
	bzjc+wMhmrG/9EZ3s00TKE70Dv6cJ4+JFbx97lYk2sNlaWbV70/lLb/txDJM3kouzXiSvUTXisJ
	mVw27X62EPf4GJ6MP4L7awMQV8+3D4J1QV44I=
X-Gm-Gg: ASbGncs5U+ca7dcJrtrfjRnErbn2NmISGnMcg/M55IyNNA2qslHMu7GVBbCQpLCGcPX
	h1HYRE/Cna0+5CA7bMoNyJqNdKReHFBTVkF5QBujz2+G1OshEo5Md4T9vWDyeQtKGMbco3J6Gyg
	==
X-Received: by 2002:a05:6000:4102:b0:391:487f:27e7 with SMTP id ffacd0b85a97d-391487f2b5amr87714f8f.55.1741507645471;
        Sun, 09 Mar 2025 00:07:25 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGhD/61rkcaEIdwMrtxevM0JBg/y05qGnnJvvH/bQYC44QrzoG0yv2gURYtI+KKv8IIxwg7AZ5hOgrh770quwo=
X-Received: by 2002:a05:6000:4102:b0:391:487f:27e7 with SMTP id
 ffacd0b85a97d-391487f2b5amr87696f8f.55.1741507645022; Sun, 09 Mar 2025
 00:07:25 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250308010347.1014779-1-seanjc@google.com>
In-Reply-To: <20250308010347.1014779-1-seanjc@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Sun, 9 Mar 2025 09:06:54 +0100
X-Gm-Features: AQ5f1JoolazH4jL0h1xGLNNnbKtztmE1g0HsqhOFa3fHrQo1Y-uGVjTz1XGfUfY
Message-ID: <CABgObfYO8tEYYTDfmf+F-GA3aOCrRn6_Os6uhry9EJ4F3QHkUw@mail.gmail.com>
Subject: Re: [GIT PULL] KVM: x86: Fixes for 6.14-rcN
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Mar 8, 2025 at 2:03=E2=80=AFAM Sean Christopherson <seanjc@google.c=
om> wrote:
>
> Please pull a handful of fixes for 6.14.  The DEBUGCTL changes are the mo=
st
> urgent, as they fix a bug that was introduced in 6.13 that results in Ste=
am
> (and other applications) getting killed due to unexpected #DBs.
>
> The following changes since commit c2fee09fc167c74a64adb08656cb993ea47519=
7e:
>
>   KVM: x86: Load DR6 with guest value only before entering .vcpu_run() lo=
op (2025-02-12 08:59:38 -0800)
>
> are available in the Git repository at:
>
>   https://github.com/kvm-x86/linux.git tags/kvm-x86-fixes-6.14-rcN.2
>
> for you to fetch changes up to f9dc8fb3afc968042bdaf4b6e445a9272071c9f3:
>
>   KVM: x86: Explicitly zero EAX and EBX when PERFMON_V2 isn't supported b=
y KVM (2025-03-04 09:19:18 -0800)

Pulled, thanks.

Paolo

> ----------------------------------------------------------------
> KVM x86 fixes for 6.14-rcN #2
>
>  - Set RFLAGS.IF in C code on SVM to get VMRUN out of the STI shadow.
>
>  - Ensure DEBUGCTL is context switched on AMD to avoid running the guest =
with
>    the host's value, which can lead to unexpected bus lock #DBs.
>
>  - Suppress DEBUGCTL.BTF on AMD (to match Intel), as KVM doesn't properly
>    emulate BTF.  KVM's lack of context switching has meant BTF has always=
 been
>    broken to some extent.
>
>  - Always save DR masks for SNP vCPUs if DebugSwap is *supported*, as the=
 guest
>    can enable DebugSwap without KVM's knowledge.
>
>  - Fix a bug in mmu_stress_tests where a vCPU could finish the "writes to=
 RO
>    memory" phase without actually generating a write-protection fault.
>
>  - Fix a printf() goof in the SEV smoke test that causes build failures w=
ith
>    -Werror.
>
>  - Explicitly zero EAX and EBX in CPUID.0x8000_0022 output when PERFMON_V=
2
>    isn't supported by KVM.
>
> ----------------------------------------------------------------
> Sean Christopherson (11):
>       KVM: SVM: Set RFLAGS.IF=3D1 in C code, to get VMRUN out of the STI =
shadow
>       KVM: selftests: Assert that STI blocking isn't set after event inje=
ction
>       KVM: SVM: Drop DEBUGCTL[5:2] from guest's effective value
>       KVM: SVM: Suppress DEBUGCTL.BTF on AMD
>       KVM: x86: Snapshot the host's DEBUGCTL in common x86
>       KVM: SVM: Manually context switch DEBUGCTL if LBR virtualization is=
 disabled
>       KVM: x86: Snapshot the host's DEBUGCTL after disabling IRQs
>       KVM: SVM: Save host DR masks on CPUs with DebugSwap
>       KVM: SVM: Don't rely on DebugSwap to restore host DR0..DR3
>       KVM: selftests: Ensure all vCPUs hit -EFAULT during initial RO stag=
e
>       KVM: selftests: Fix printf() format goof in SEV smoke test
>
> Xiaoyao Li (1):
>       KVM: x86: Explicitly zero EAX and EBX when PERFMON_V2 isn't support=
ed by KVM
>
>  arch/x86/include/asm/kvm_host.h                    |  1 +
>  arch/x86/kvm/cpuid.c                               |  2 +-
>  arch/x86/kvm/svm/sev.c                             | 24 +++++++----
>  arch/x86/kvm/svm/svm.c                             | 49 ++++++++++++++++=
++++++
>  arch/x86/kvm/svm/svm.h                             |  2 +-
>  arch/x86/kvm/svm/vmenter.S                         | 10 +----
>  arch/x86/kvm/vmx/vmx.c                             |  8 +---
>  arch/x86/kvm/vmx/vmx.h                             |  2 -
>  arch/x86/kvm/x86.c                                 |  2 +
>  tools/testing/selftests/kvm/mmu_stress_test.c      | 21 ++++++----
>  .../selftests/kvm/x86/nested_exceptions_test.c     |  2 +
>  tools/testing/selftests/kvm/x86/sev_smoke_test.c   |  3 +-
>  12 files changed, 91 insertions(+), 35 deletions(-)
>


