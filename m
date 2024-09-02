Return-Path: <kvm+bounces-25683-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EDC64968A7E
	for <lists+kvm@lfdr.de>; Mon,  2 Sep 2024 16:59:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 51BB92836B6
	for <lists+kvm@lfdr.de>; Mon,  2 Sep 2024 14:59:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 11C2B1CB539;
	Mon,  2 Sep 2024 14:56:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VoUWw/Es"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB4811CB517
	for <kvm@vger.kernel.org>; Mon,  2 Sep 2024 14:56:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725288983; cv=none; b=H46IdvWkhwAQ8gnP0XVijAQNlSvVQCrjsDhRkT5KDi9IB6ADT0gpJwKKzYxcAaUAhsKm3M0R+MoQcfi+JnFuZ9/1lrF/bT5bSypWey4COfdYcOhyytn5cyjIN92yvNTOoyFXaStFs0ClAKK8uVkhs2rcrdiOdLz1wN0g+qO28xA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725288983; c=relaxed/simple;
	bh=edZNdlPqu0BH4DMZBrBUAZom0Aq31Tn1hxdPEW/9kz8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=I7D7SfZSjrAkLxn6UItcohwfKL4p2s7Gt+tfADGcO1/GxDCuykF2d6X+kEmuLRrXZsmO+aZf+WcBu9KIt5jFHNCfSQZYWuSrRb3rhWhcWZzHev40wBxeF8Gk4bhrtRO9Cjna4mtLMDYlRy8zxbHZsBuHs1LMvUN2BeurNBOhYao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=VoUWw/Es; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1725288979;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=DXMmeBaYJlR4uzCw7PqYk4KRB/yDtlvfzyZX5wr1+OQ=;
	b=VoUWw/EsWD3NgACoLcL1BYMuB8StqG7DMQh7a0eiBi2/+Eh1+9+9lspQozwZchDkMOJHud
	bMYb9Q/jy+qKIiFh+jbJa+LwquwJKpPKI6nW10NuQm/kZu1XpUDzjCXxEzzuyevh0K5LKe
	DTKnSyb83sSQ8pNEpQkw0NXr7iymsAo=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-251-B74KVkwhNlCLRRr95J7l1Q-1; Mon, 02 Sep 2024 10:56:18 -0400
X-MC-Unique: B74KVkwhNlCLRRr95J7l1Q-1
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-374bb1e931cso1114438f8f.0
        for <kvm@vger.kernel.org>; Mon, 02 Sep 2024 07:56:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725288977; x=1725893777;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DXMmeBaYJlR4uzCw7PqYk4KRB/yDtlvfzyZX5wr1+OQ=;
        b=ZtZWup+RbQrNd+uRoqUqlk0hax02bHwkU1PgDltLWHZuuJ9oh4RBVkaQQv/4cR95rH
         mhGg0W22rLbHMXAR4BXhdFTuLKHytDSq5gp+hmfpKJU3yM/WAjAv8TnceMvRK0S2pBU7
         1RW5/e+E8F23o2OvG2eLwZmFDCYbRxdWs324kZzqbhdrvdUM5AXZ3lE1JU9SYuUEb+Ay
         w83qdDs8Hcjmj+oxnwu/a3UyJXYnV63zfoEoycloqSPVuUdUgeHEp6r9mcUc4/TXkroV
         +TPAJEeMZ9RbYJYDrH0gxsUQcIUiKyExGBCn3DBPRmYSTnPA321tjStIrhgI/XQGOP/w
         LhhA==
X-Gm-Message-State: AOJu0Yymaf9L5T4lRXTLur+NYWpJa4mVful3SeaP30m9HDP8+QNzMGQs
	LnvUokVMlEp0onRrGgteDVkO4jBXlfs2x1jWl4cJprElRjvRWQc2YA/5PjjhJpuJ1uoYkEtpfmg
	v2XJt+nBOWKJHKj5IztvAjAsROMeVrD9pXVN0pl/ahzz14PIdBj9ME+BnZz71NbF8Og392ZbdjW
	DMz+hjCofD2JWdkyDxM8KHkGFcg6f0LPri4oY=
X-Received: by 2002:a5d:4fc6:0:b0:374:bb1a:eebb with SMTP id ffacd0b85a97d-374bb1aefe4mr4354484f8f.25.1725288977226;
        Mon, 02 Sep 2024 07:56:17 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEf3CScUz921srbnKmcoQAzxvzkfVVn9ngrMaqrnTH6hMEI3EI7azowMppFVEEFNggqR1/cZ7zf+tUQqROs1Ts=
X-Received: by 2002:a5d:4fc6:0:b0:374:bb1a:eebb with SMTP id
 ffacd0b85a97d-374bb1aefe4mr4354473f8f.25.1725288976740; Mon, 02 Sep 2024
 07:56:16 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240830234042.322988-1-seanjc@google.com>
In-Reply-To: <20240830234042.322988-1-seanjc@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Mon, 2 Sep 2024 16:56:05 +0200
Message-ID: <CABgObfaE9G30bz8oarCiWmr+LqGMjGa4dijkOLLRoXjra6VecA@mail.gmail.com>
Subject: Re: [GIT PULL] KVM: x86: Fixes for 6.11-rcN
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Aug 31, 2024 at 1:40=E2=80=AFAM Sean Christopherson <seanjc@google.=
com> wrote:
>
> Please pull a handful of random fixes.  Details in the tag and changelogs=
.
>
> The following changes since commit 47ac09b91befbb6a235ab620c32af719f82083=
99:
>
>   Linux 6.11-rc4 (2024-08-18 13:17:27 -0700)
>
> are available in the Git repository at:
>
>   https://github.com/kvm-x86/linux.git tags/kvm-x86-fixes-6.11-rcN
>
> for you to fetch changes up to 5fa9f0480c7985e44e6ec32def0a395b768599cc:
>
>   KVM: SEV: Update KVM_AMD_SEV Kconfig entry and mention SEV-SNP (2024-08=
-28 05:46:25 -0700)

Pulled, thanks.

Paolo

> ----------------------------------------------------------------
> KVM x86 fixes for 6.11
>
>  - Fixup missed comments from the REMOVED_SPTE=3D>FROZEN_SPTE rename.
>
>  - Ensure a root is successfully loaded when pre-faulting SPTEs.
>
>  - Grab kvm->srcu when handling KVM_SET_VCPU_EVENTS to guard against acce=
ssing
>    memslots if toggling SMM happens to force a VM-Exit.
>
>  - Emulate MSR_{FS,GS}_BASE on SVM even though interception is always dis=
abled,
>    so that KVM does the right thing if KVM's emulator encounters {RD,WR}M=
SR.
>
>  - Explicitly clear BUS_LOCK_DETECT from KVM's caps on AMD, as KVM doesn'=
t yet
>    virtualize BUS_LOCK_DETECT on AMD.
>
>  - Cleanup the help message for CONFIG_KVM_AMD_SEV, and call out that KVM=
 now
>    supports SEV-SNP too.
>
> ----------------------------------------------------------------
> Maxim Levitsky (1):
>       KVM: SVM: fix emulation of msr reads/writes of MSR_FS_BASE and MSR_=
GS_BASE
>
> Ravi Bangoria (1):
>       KVM: SVM: Don't advertise Bus Lock Detect to guest if SVM support i=
s missing
>
> Sean Christopherson (2):
>       KVM: x86/mmu: Check that root is valid/loaded when pre-faulting SPT=
Es
>       KVM: x86: Acquire kvm->srcu when handling KVM_SET_VCPU_EVENTS
>
> Vitaly Kuznetsov (1):
>       KVM: SEV: Update KVM_AMD_SEV Kconfig entry and mention SEV-SNP
>
> Yan Zhao (1):
>       KVM: x86/mmu: Fixup comments missed by the REMOVED_SPTE=3D>FROZEN_S=
PTE rename
>
>  arch/x86/kvm/Kconfig       |  6 ++++--
>  arch/x86/kvm/mmu/mmu.c     |  4 +++-
>  arch/x86/kvm/mmu/spte.c    |  6 +++---
>  arch/x86/kvm/mmu/spte.h    |  2 +-
>  arch/x86/kvm/mmu/tdp_mmu.c |  8 ++++----
>  arch/x86/kvm/svm/svm.c     | 15 +++++++++++++++
>  arch/x86/kvm/x86.c         |  2 ++
>  7 files changed, 32 insertions(+), 11 deletions(-)
>


