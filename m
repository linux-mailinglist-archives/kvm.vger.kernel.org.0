Return-Path: <kvm+bounces-50130-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C2194AE2093
	for <lists+kvm@lfdr.de>; Fri, 20 Jun 2025 19:11:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CAE0E1BC6477
	for <lists+kvm@lfdr.de>; Fri, 20 Jun 2025 17:11:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D3B552E8E1D;
	Fri, 20 Jun 2025 17:10:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gsKmOPAg"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B45672630
	for <kvm@vger.kernel.org>; Fri, 20 Jun 2025 17:10:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750439459; cv=none; b=kqixWSTrntFiOc6W3vGnl//X6Pr2KWizS0C8yGc25KDtLZQDWE7x9RbgdCCHgLDpROUJfEA/oNAXpvEsSbg4HdqYBPfezZrgXFVB/YtPpQ1mMivEm9DsWA1XnqGOkdozNmaOuNwrCiqNlDwKvRqqJ5QKOG2+l+dTyP9gEHgvmp8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750439459; c=relaxed/simple;
	bh=O1FN+t9jZIBycusZ3Q/T1AKbU3YiywXzYlVXWllgfE8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=fsdYS394iw9K6JQ1o+BNZWytIIflevIxhdCWXlsKJVDDccpgf/rvSh9c42uDSxqS3LHyQyzykwS1Qq9fnK5OzRqycEYOtxyu2fximiKX67DYx+3UEXYZJNRI+lRWOtCjNlNGNYDXwvly7aSH/Mn1zj6Rdux8UJ9ukjj+0bAha8w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=gsKmOPAg; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1750439456;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=M1ekRqR8sclf5kjPGwfD2Er+4fHOBAml7GmI5iGuA8A=;
	b=gsKmOPAg/Do4SyEq7nAIZtIXbQefqDoOwtVtFLybgZFspV5OoyRTrwEriFrUHaIMVo7DRy
	3+D4xx8L2IeVsW8Kgw+u2cqamnVzIYONciwAAcrzHAIAQk7RZYHQ5LQE51d+HH4aHaSmco
	0bvDeJcpdjCddZWLoEvVkLyv28mMnXA=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-380-C0CURyy8NUOAI9xaEKbnwg-1; Fri, 20 Jun 2025 13:09:37 -0400
X-MC-Unique: C0CURyy8NUOAI9xaEKbnwg-1
X-Mimecast-MFC-AGG-ID: C0CURyy8NUOAI9xaEKbnwg_1750439376
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-4532514dee8so15669805e9.0
        for <kvm@vger.kernel.org>; Fri, 20 Jun 2025 10:09:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750439376; x=1751044176;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=M1ekRqR8sclf5kjPGwfD2Er+4fHOBAml7GmI5iGuA8A=;
        b=gbxVAybnrMs/J/WpRSWxAyUQ7E/bYDm4n5+7qt1hHdKyFpCrDT3DAzF+aBYfpyqwlB
         v3e4vp/zl4W2aVIDZzjO/j7A4d6C7Nvm6kxIRL3vvziNDavO7l95GF9g19U2MXUg9QFy
         sYVXKY5SsTE5J4YmC//tdFL1FvKj6C6wzsBCCOIGBgW4PXRv7xh4C5I01psUFacReriS
         ON5Jx6M7aFa9QuxIS4c4qW4THa84/1BZuB4Du+oiv1G34XFckPYfkf8nK+q/p7YIypMj
         S6FrKJvAXGrpkH9lnWSRUIcmwG1NZMN4YW5+rUpJ6BXpk7fC21QVdfjJHkRVcX8i8ShY
         AG3Q==
X-Forwarded-Encrypted: i=1; AJvYcCUyeKjxsWwsOkz97cocqRmoNVWqg+d8nH3ztPu4Ky2qka32zxTZ3wJMqyidKOLRWuQmElc=@vger.kernel.org
X-Gm-Message-State: AOJu0YxjVIFQN+HjOshzHHUCWjYg8PBxA9xgQPF/aLu+1Hz2G/66Q03N
	i+kOTqFEERsszQdRN0bhhnGP6eROZAHc1x27yTLMJq/VbXqG4uXOvM1seAMNCXu8TsiUeP504Tv
	0nnlaocxH/+mwDSOhk1F6mbr0xclFm0N6hEdmQwsFZEtbQ/XO7KCGtwEAJ64MF8nXGSWHpig/og
	dRfFZ6GgTovZAwty8WteAU/2cHmQrt
X-Gm-Gg: ASbGncuRZ2vbMqiFeYHEyJAlB54ogqBQyFBt5cbrrmep3UopM97MgNz/+p8Vpxr1Ajm
	DD+QaLLf3qkwwLIsWevoXPMUnzbkYxyej7dt/hKEn7vakah/j3MQnMmrUWPSwzt8AzyG46FHECr
	uXVLE=
X-Received: by 2002:a05:6000:481e:b0:3a4:fb33:85ce with SMTP id ffacd0b85a97d-3a6d130cb6cmr3215798f8f.46.1750439375691;
        Fri, 20 Jun 2025 10:09:35 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEIC2N1+6qyCY+73jGybmhqG2lkoyl7bI3OfwoPqdXTWp1p58WQ3hVSE1JBPnpkmVDoWah0q9odmoL6/U/X/s0=
X-Received: by 2002:a05:6000:481e:b0:3a4:fb33:85ce with SMTP id
 ffacd0b85a97d-3a6d130cb6cmr3215780f8f.46.1750439375305; Fri, 20 Jun 2025
 10:09:35 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250619130049.3133524-1-maz@kernel.org>
In-Reply-To: <20250619130049.3133524-1-maz@kernel.org>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Fri, 20 Jun 2025 19:09:23 +0200
X-Gm-Features: Ac12FXyeUmiA3r9jYilzHr01DzOSd5DLfk5ROg5WkKSbcqmWMU5McoHSJ-zkNws
Message-ID: <CABgObfZ=9ZEJ8ouESTVfRiRLrQpyURo7pe04OBDgfwbjz6q9eQ@mail.gmail.com>
Subject: Re: [GIT PULL] KVM/arm64 fixes, take #3
To: Marc Zyngier <maz@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>, Fuad Tabba <tabba@google.com>, 
	Mark Brown <broonie@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
	Miguel Luis <miguel.luis@oracle.com>, Oliver Upton <oliver.upton@linux.dev>, 
	Sean Christopherson <seanjc@google.com>, Sebastian Ott <sebott@redhat.com>, 
	Wei-Lin Chang <r09922117@csie.ntu.edu.tw>, Will Deacon <will@kernel.org>, 
	Zenghui Yu <yuzenghui@huawei.com>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, kvmarm@lists.linux.dev, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 19, 2025 at 3:01=E2=80=AFPM Marc Zyngier <maz@kernel.org> wrote=
:
>
> Paolo,
>
> Here's the third set of KVM/arm64 fixes for 6.16. The most notable
> thing is yet another batch of FP/SVE fixes from Mark, this time
> addressing NV, and additionally plugging some missing synchronisation.
> The rest is a mix of interrupt stuff (routing change, mishandling of
> shadow LRs) and selftest fixes.
>
> Please pull,

Done, thanks.

Paolo

>         M.
>
> The following changes since commit e04c78d86a9699d136910cfc0bdcf01087e326=
7e:
>
>   Linux 6.16-rc2 (2025-06-15 13:49:41 -0700)
>
> are available in the Git repository at:
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kv=
marm-fixes-6.16-3
>
> for you to fetch changes up to 04c5355b2a94ff3191ce63ab035fb7f04d036869:
>
>   KVM: arm64: VHE: Centralize ISBs when returning to host (2025-06-19 13:=
34:59 +0100)
>
> ----------------------------------------------------------------
> KVM/arm64 fixes for 6.16, take #3
>
> - Fix another set of FP/SIMD/SVE bugs affecting NV, and plugging some
>   missing synchronisation
>
> - A small fix for the irqbypass hook fixes, tightening the check and
>   ensuring that we only deal with MSI for both the old and the new
>   route entry
>
> - Rework the way the shadow LRs are addressed in a nesting
>   configuration, plugging an embarrassing bug as well as simplifying
>   the whole process
>
> - Add yet another fix for the dreaded arch_timer_edge_cases selftest
>
> ----------------------------------------------------------------
> Marc Zyngier (1):
>       KVM: arm64: nv: Fix tracking of shadow list registers
>
> Mark Rutland (7):
>       KVM: arm64: VHE: Synchronize restore of host debug registers
>       KVM: arm64: VHE: Synchronize CPTR trap deactivation
>       KVM: arm64: Reorganise CPTR trap manipulation
>       KVM: arm64: Remove ad-hoc CPTR manipulation from fpsimd_sve_sync()
>       KVM: arm64: Remove ad-hoc CPTR manipulation from kvm_hyp_handle_fps=
imd()
>       KVM: arm64: Remove cpacr_clear_set()
>       KVM: arm64: VHE: Centralize ISBs when returning to host
>
> Sean Christopherson (1):
>       KVM: arm64: Explicitly treat routing entry type changes as changes
>
> Zenghui Yu (1):
>       KVM: arm64: selftests: Close the GIC FD in arch_timer_edge_cases
>
>  arch/arm64/include/asm/kvm_emulate.h               |  62 ---------
>  arch/arm64/include/asm/kvm_host.h                  |   6 +-
>  arch/arm64/kvm/arm.c                               |   3 +-
>  arch/arm64/kvm/hyp/include/hyp/switch.h            | 147 +++++++++++++++=
++++--
>  arch/arm64/kvm/hyp/nvhe/hyp-main.c                 |   5 +-
>  arch/arm64/kvm/hyp/nvhe/switch.c                   |  59 ---------
>  arch/arm64/kvm/hyp/vhe/switch.c                    | 107 ++-------------
>  arch/arm64/kvm/vgic/vgic-v3-nested.c               |  81 ++++++------
>  .../selftests/kvm/arm64/arch_timer_edge_cases.c    |  16 ++-
>  9 files changed, 215 insertions(+), 271 deletions(-)
>


