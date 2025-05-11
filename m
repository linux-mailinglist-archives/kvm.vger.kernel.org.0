Return-Path: <kvm+bounces-46119-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6BACBAB27E8
	for <lists+kvm@lfdr.de>; Sun, 11 May 2025 13:14:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 4A0EC7A9BD2
	for <lists+kvm@lfdr.de>; Sun, 11 May 2025 11:12:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B23941DDA18;
	Sun, 11 May 2025 11:13:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="G9fTw31E"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E72851D5178
	for <kvm@vger.kernel.org>; Sun, 11 May 2025 11:13:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746962033; cv=none; b=on3UrYikPFevRIlcIEcY/zNZLdJqiNwUplv3aw+8Oo3lNScf0WuSSyaRWQVhuceMCTkcQht3Aciujow4QEBaAn07b8e79sj4YpoCTwjBQE8xJu7/vTyHiR1lLVRDHwrch/FUQbK4Idd39B0k8qzvsSalmewHxhHvOLsp6QAIYWY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746962033; c=relaxed/simple;
	bh=b9I/zEXGQIc7hEokRw3SGv9msRQTW6TBrbYa5QahSTQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=XKxtkdRlT1QX3sVr1abzhclO1lUtqK0+aJl3AavKb+4nfD38LHC33l4Q7CnapWsdmYzlA0KbMoCt6mNUCIldV3j4c0HMP3S5t9nd9sk8FiS9k3as1bLbzesiJ5b7LR1zA4LcvzI+yI2NqdnUooTqckJrXwhSSOSTIxmDvfpbpgM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=G9fTw31E; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1746962029;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Airg4webqukAlFGEQw+CSdLqTsx5ThZe2jBG9nkZHPY=;
	b=G9fTw31EHP5rOO0hjLWTQ1SY6ld9q5+MzRQyxMF81de03jB5wQyVSHP+S2ireMUVvD4OmI
	1UeFoWYSHco9q9vRjJlpQj93DsTALSG7WarfqBLXONdCIhGQzNSguSX6WZo/7CwZXM0gsG
	OM6lhbWMqOSwXLF13XJV2m/EtBHGkB0=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-590-yKYyOFGWPuOZDzsh-Cp2KQ-1; Sun, 11 May 2025 07:13:47 -0400
X-MC-Unique: yKYyOFGWPuOZDzsh-Cp2KQ-1
X-Mimecast-MFC-AGG-ID: yKYyOFGWPuOZDzsh-Cp2KQ_1746962027
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-3a0b5c28f05so1829964f8f.2
        for <kvm@vger.kernel.org>; Sun, 11 May 2025 04:13:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746962026; x=1747566826;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Airg4webqukAlFGEQw+CSdLqTsx5ThZe2jBG9nkZHPY=;
        b=lg1w9dXOCmKU3sJkJtM7U8OFxiv9/Ps9l9ZoYcF38kXhASzseo/cN1RMvZLWsevjot
         66i7JoUoDdKY/W9iXaL6bk33xvG64CDUGWd5wXnRmsR/GkaVWeSuBHgc4Ig+CGiYOSZY
         AAfG/IBEXOVyoYyBUtQlOhZJ0jvB3LsFHAymX86ZXG8ma1oYk0b8wI//S2pJTGECddCx
         LC/qukDmTRIKe3lzz8WMhEJ2npE+Hs/9cdRV862CaU9mTHpKxLpc+wG0df3NHmGNRWAf
         /uNEm/jD/QPzM6ocM1EwpvL/pV7I3D73BWNFECH0m1l4oQh0wfwBUIKadpkrMesd7sXt
         0R2g==
X-Gm-Message-State: AOJu0Yxp3qCba30dJzUMs0MVa03yO5oMBuHdCXYEqVz7Dpdl9prTI9eW
	shsrNnVthGk1wPWmPLKPP+tEoy4oBzsrgko1QfIfD/kReqCd+fB0ehMlCvf39IjkLnrvsxZ42m/
	wKxl0TBa92p/VB9FbttzByYkx40gQ6pcWqIkN7LOlchZ3yj3j9M+ttG46nLusiqjfqz6BrlXhTP
	OB7W0Xcf+jC+4QPK2lCJcNArYK
X-Gm-Gg: ASbGnct+FiLSiPer4prtJfqOFodK2YwNve4f06I4B8rbkMiAXp4TgrQptNc2J6gpBPu
	te77/BoWsByy+xcXyZ1AvIS61ET3e1HTzgBXzGwxn4BPDxQgIYD8Xud0nLvJV/1SeFuOF
X-Received: by 2002:a05:6000:a83:b0:3a0:9dd5:5dc2 with SMTP id ffacd0b85a97d-3a1f64d1cd2mr6298349f8f.59.1746962026581;
        Sun, 11 May 2025 04:13:46 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFNuKTsKl3oRGcCkzR3cb5pXOsob8y4/sdGyAJENPTXcSA9xBtJkpAmGLE6sfC6oyC8lN+o2usBjNacCZNXpm8=
X-Received: by 2002:a05:6000:a83:b0:3a0:9dd5:5dc2 with SMTP id
 ffacd0b85a97d-3a1f64d1cd2mr6298334f8f.59.1746962026122; Sun, 11 May 2025
 04:13:46 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250509190108.1582362-1-seanjc@google.com>
In-Reply-To: <20250509190108.1582362-1-seanjc@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Sun, 11 May 2025 13:13:33 +0200
X-Gm-Features: AX0GCFt6COEoqchgrJJ27SkGNJFtfxEjqyYPA--QXU7uz3ASU9I3N4-OVIu1PQo
Message-ID: <CABgObfbKCRggZm7kbeVkAykxO1tEi1v7q=emcSxWWgMLX20WPA@mail.gmail.com>
Subject: Re: [GIT PULL] KVM: x86: Fixes for 6.15-rcN
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, May 9, 2025 at 9:01=E2=80=AFPM Sean Christopherson <seanjc@google.c=
om> wrote:
> Please pull a random variety of fixes for 6.15.  The SRSO change is the
> most urgent fix, everything else has either existed for some time, or isn=
't
> actively causing problems.

Cool, thanks; pulled.

Paolo

> The following changes since commit 2d7124941a273c7233849a7a2bbfbeb7e28f1c=
aa:
>
>   Merge tag 'kvmarm-fixes-6.15-2' of https://git.kernel.org/pub/scm/linux=
/kernel/git/kvmarm/kvmarm into HEAD (2025-04-24 13:28:53 -0400)
>
> are available in the Git repository at:
>
>   https://github.com/kvm-x86/linux.git tags/kvm-x86-fixes-6.15-rcN
>
> for you to fetch changes up to e3417ab75ab2e7dca6372a1bfa26b1be3ac5889e:
>
>   KVM: SVM: Set/clear SRSO's BP_SPEC_REDUCE on 0 <=3D> 1 VM count transit=
ions (2025-05-08 07:17:10 -0700)
>
> ----------------------------------------------------------------
> KVM x86 fixes for 6.15-rcN
>
>  - Forcibly leave SMM on SHUTDOWN interception on AMD CPUs to avoid causi=
ng
>    problems due to KVM stuffing INIT on SHUTDOWN (KVM needs to sanitize t=
he
>    VMCB as its state is undefined after SHUTDOWN, emulating INIT is the
>    least awful choice).
>
>  - Track the valid sync/dirty fields in kvm_run as a u64 to ensure KVM
>    KVM doesn't goof a sanity check in the future.
>
>  - Free obsolete roots when (re)loading the MMU to fix a bug where
>    pre-faulting memory can get stuck due to always encountering a stale
>    root.
>
>  - When dumping GHCB state, use KVM's snapshot instead of the raw GHCB pa=
ge
>    to print state, so that KVM doesn't print stale/wrong information.
>
>  - When changing memory attributes (e.g. shared <=3D> private), add poten=
tial
>    hugepage ranges to the mmu_invalidate_range_{start,end} set so that KV=
M
>    doesn't create a shared/private hugepage when the the corresponding
>    attributes will become mixed (the attributes are commited *after* KVM
>    finishes the invalidation).
>
>  - Rework the SRSO mitigation to enable BP_SPEC_REDUCE only when KVM has =
at
>    least one active VM.  Effectively BP_SPEC_REDUCE when KVM is loaded le=
d
>    to very measurable performance regressions for non-KVM workloads.
>
> ----------------------------------------------------------------
> Dan Carpenter (1):
>       KVM: x86: Check that the high 32bits are clear in kvm_arch_vcpu_ioc=
tl_run()
>
> Mikhail Lobanov (1):
>       KVM: SVM: Forcibly leave SMM mode on SHUTDOWN interception
>
> Sean Christopherson (2):
>       KVM: x86/mmu: Prevent installing hugepages when mem attributes are =
changing
>       KVM: SVM: Set/clear SRSO's BP_SPEC_REDUCE on 0 <=3D> 1 VM count tra=
nsitions
>
> Tom Lendacky (1):
>       KVM: SVM: Update dump_ghcb() to use the GHCB snapshot fields
>
> Yan Zhao (1):
>       KVM: x86/mmu: Check and free obsolete roots in kvm_mmu_reload()
>
>  arch/x86/kvm/mmu.h     |  3 ++
>  arch/x86/kvm/mmu/mmu.c | 70 +++++++++++++++++++++++++++++++++++---------=
--
>  arch/x86/kvm/smm.c     |  1 +
>  arch/x86/kvm/svm/sev.c | 32 ++++++++++++---------
>  arch/x86/kvm/svm/svm.c | 75 ++++++++++++++++++++++++++++++++++++++++++++=
++----
>  arch/x86/kvm/svm/svm.h |  2 ++
>  arch/x86/kvm/x86.c     |  4 +--
>  7 files changed, 150 insertions(+), 37 deletions(-)
>


