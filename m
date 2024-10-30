Return-Path: <kvm+bounces-30113-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E10B69B6EBD
	for <lists+kvm@lfdr.de>; Wed, 30 Oct 2024 22:23:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 190FB1C217D0
	for <lists+kvm@lfdr.de>; Wed, 30 Oct 2024 21:23:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BC4E621745A;
	Wed, 30 Oct 2024 21:22:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="zQayDFTf"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D4351E0489
	for <kvm@vger.kernel.org>; Wed, 30 Oct 2024 21:22:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730323368; cv=none; b=JTAsW027iKFIDGmJOTy/rgeSvqho9VDvaHzZmlSVaGHgRMUACD59cdWtW9RLzaEGDOtXSfktPYNenCquElCqGyaPNB77FvGTFA0WS3hwqgErlCGqq5hK7CnQzonCHQ+ZBo6BbNtvEMkppTsvylTl7yblSE8ETpwu+RK7ItilKpc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730323368; c=relaxed/simple;
	bh=daCn9Zmrz+ByMSuRpsqlpxCU+Lz/HcHlR2nvMTXULSQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=nEtD2AFlbKNaGDLjDWtZKYi9hC4vU4wvNCoP7OL0ssVsNMimB0kNYiyc9NslM0fT/us8G+L/OUgncm3i70TkPbV0wDh5W0DJF29J+XGer8yg6iUzwgvIL6xa4qRUjEcQBc9mymyhrK8yB3P/e9twyYBLqKxrjJiNjDUB/ymw4yc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=zQayDFTf; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-20c70cc9d27so2568205ad.2
        for <kvm@vger.kernel.org>; Wed, 30 Oct 2024 14:22:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1730323365; x=1730928165; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=uD1I7n518ep0y1/IcygTlaTa6BQftuCZvZqhANK+tG8=;
        b=zQayDFTfMrGlOb9QhQPScWq/MgWBC2fVbZT05CbQFM83cHw80qBOmNB630Zf/S9PCj
         C4S6Ltpxxjcx4ybDa261Q3KyQ0nnNNEaMVLdztykEes67XpU+6UtuThKJhKx9kmrfbHp
         a/AvkkET+0+yGqO/OdezzQxGWazAB3tMU6sY8FX+UtAp5Czn1dKNHkOR7fJFlswaOojA
         cHr4gYobjoz5ZJMrP6+2U1WiQLgJw3ykp6e6UQJ9y7+aavLj2h5/Cazkwxh5Advmf4NO
         DEXfq1hQHhicDiY3nlMazEJzao5m3CF/G8P94fMtWguZOQ+gTPgFBO90bBTr8pHoaCmt
         Y39Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730323365; x=1730928165;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=uD1I7n518ep0y1/IcygTlaTa6BQftuCZvZqhANK+tG8=;
        b=BBZWCX8KxB3uPrka6uPONwGghsYaPzt9Xtf3WNN7y4wZYddYPmwDlCPWRPWUTiFbBe
         DvG7EgDFdGzMDz8abjCTp2EbuB4OZKoq/+xf2VXrSuw4DgZ24K5UhNtNOogs4Z/em7oe
         AdKq9dyn6gE8vFz9VK42VxOaWxrx22rA5DgQNtxCeEfRDYq2sYOYr0JhODYVDsQotpXt
         8WIvZYTTKm13RRP6GyoF8TZpNaktn1BYJubQtb5BAJm4ZL1Yi9SANSCc0YGrg6iYdIuX
         uYjk6jsD09bOR3u9SeU3CM6Wgw0RSVZV/k2/uqbrn/W9E6o2BYUHreczNtv0Si5Y4/Bb
         P8ug==
X-Gm-Message-State: AOJu0Yy09haTrrv8vSJ+g+UuIGZWPWFJ23fwEhUgaGCBC94hSOLhW0gU
	x/t0tdMIuNw5AYpgGzRSFAy9AwQ34ozQIiBe6tuXyHi1vPOv6BNGSDn4vMVL4xHEd/9CkXm25Gs
	lrQ==
X-Google-Smtp-Source: AGHT+IG5X+boI+x3N+fKSDre8no68V3qBwE5Al2ZhcBN3LVJgc3XFIT5bb+3v+iN1DK1T2sVKEucIdNQ2hs=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a17:902:d504:b0:20c:9ed7:673d with SMTP id
 d9443c01a7336-210c6731a2fmr356745ad.0.1730323365350; Wed, 30 Oct 2024
 14:22:45 -0700 (PDT)
Date: Wed, 30 Oct 2024 14:22:43 -0700
In-Reply-To: <c6594c5f040eedc7e5b3cb001aac1bcfcb6782cd.camel@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240906221824.491834-1-mlevitsk@redhat.com> <c6594c5f040eedc7e5b3cb001aac1bcfcb6782cd.camel@redhat.com>
Message-ID: <ZyKjo-XpaNjIkMdA@google.com>
Subject: Re: [PATCH v4 0/4] Relax canonical checks on some arch msrs
From: Sean Christopherson <seanjc@google.com>
To: Maxim Levitsky <mlevitsk@redhat.com>
Cc: kvm@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>, 
	Paolo Bonzini <pbonzini@redhat.com>, Ingo Molnar <mingo@redhat.com>, 
	Vitaly Kuznetsov <vkuznets@redhat.com>, linux-kernel@vger.kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>
Content-Type: text/plain; charset="us-ascii"

On Wed, Oct 30, 2024, Maxim Levitsky wrote:
> On Fri, 2024-09-06 at 18:18 -0400, Maxim Levitsky wrote:
> > Recently we came up upon a failure where likely the guest writes
> > 0xff4547ceb1600000 to MSR_KERNEL_GS_BASE and later on, qemu
> > sets this value via KVM_PUT_MSRS, and is rejected by the
> > kernel, likely due to not being canonical in 4 level paging.
> > 
> > One of the way to trigger this is to make the guest enter SMM,
> > which causes paging to be disabled, which SMM bios re-enables
> > but not the whole 5 level. MSR_KERNEL_GS_BASE on the other
> > hand continues to contain old value.
> > 
> > I did some reverse engineering and to my surprise I found out
> > that both Intel and AMD indeed ignore CR4.LA57 when doing
> > canonical checks on this and other msrs and/or other arch
> > registers (like GDT base) which contain linear addresses.
> > 
> > V2: addressed a very good feedback from Chao Gao. Thanks!
> > 
> > V3: also fix the nested VMX, and also fix the
> > MSR_IA32_SYSENTER_EIP / MSR_IA32_SYSENTER_ESP
> > 
> > V4:
> >   - added PT and PEBS msrs
> >   - corrected emulation of SGDT/SIDT/STR/SLDT instructions
> >   - corrected canonical checks for TLB invalidation instructions
> > 
> > Best regards,
> > 	Maxim Levitsky
> > 
> > Maxim Levitsky (4):
> >   KVM: x86: drop x86.h include from cpuid.h
> >   KVM: x86: implement emul_is_noncanonical_address using
> >     is_noncanonical_address
> >   KVM: x86: model canonical checks more precisely
> >   KVM: nVMX: fix canonical check of vmcs12 HOST_RIP
> > 
> >  arch/x86/kvm/cpuid.h         |  1 -
> >  arch/x86/kvm/emulate.c       | 15 ++++++-----
> >  arch/x86/kvm/kvm_emulate.h   |  5 ++++
> >  arch/x86/kvm/mmu.h           |  1 +
> >  arch/x86/kvm/mmu/mmu.c       |  2 +-
> >  arch/x86/kvm/vmx/hyperv.c    |  1 +
> >  arch/x86/kvm/vmx/nested.c    | 35 +++++++++++++++++---------
> >  arch/x86/kvm/vmx/pmu_intel.c |  2 +-
> >  arch/x86/kvm/vmx/sgx.c       |  5 ++--
> >  arch/x86/kvm/vmx/vmx.c       |  4 +--
> >  arch/x86/kvm/x86.c           | 13 +++++++---
> >  arch/x86/kvm/x86.h           | 49 ++++++++++++++++++++++++++++++++++--
> >  12 files changed, 102 insertions(+), 31 deletions(-)
> > 
> > -- 
> > 2.26.3
> > 
> > 
> 
> Hi,
> A very gentle ping on this patch series.

Heh, good timing, I literally (like, 2 seconds ago) applied this (still need to
test before you'll see a "thank you" email).

