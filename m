Return-Path: <kvm+bounces-18880-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E3C6B8FC984
	for <lists+kvm@lfdr.de>; Wed,  5 Jun 2024 12:57:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0592D1C23A10
	for <lists+kvm@lfdr.de>; Wed,  5 Jun 2024 10:57:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 47226192B8D;
	Wed,  5 Jun 2024 10:57:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="irZU1eH/"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDE351922FC
	for <kvm@vger.kernel.org>; Wed,  5 Jun 2024 10:57:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717585025; cv=none; b=FYLJ7wDsSMQkIbWATWeDxcHM4808u0h17bs25dXRRGY1vUBFJHnxuyetmGryWdToOjIiMO2R3NojHdGduiFgNcGWYTsmEXtlB9LOk+Y9Ku4V5kBvDaVZQNk6cwLMnI3ntGjgUYvhmIp/hFbYTnibIXjKIMEcAOui6U2JO/pPhCg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717585025; c=relaxed/simple;
	bh=HWMjxp+RxNBuI/o1uEUzAUvOejnBEHtc/yTHKRJvOH0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=tAfpfqybc62048IrGaEGyCfLtaLtAmsBCb/AuHhCcWp2o11mPaF82ZocNT975NwDW3+7Mn2+La8lrAczzoCK9WTb5YRJMWSfD2pBXysG9nKbyzsOGYOw9KgCNapw5YrIFJLG6LmJzEaPod4sCGF1zv9MMiXa/ftqJVitKxD9sHk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=irZU1eH/; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1717585022;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RpjR3tYu4gNEZK9rQflRkM9ZdMjt1RHla3f80fxVLo8=;
	b=irZU1eH/DTAS34LeeinaFdn1Tpz1yrmPM683OssyqIMqkLksIV36DHpHELJ7+WVOURTLVC
	phXVnos/ml56XLMZFkuaouxF9bLn6reqQMOVpUKoKeSQeQJ/LJEZ/zWtlgIK+bPToXH0iH
	0Ue6DCu3WSS9KzEsbzULWTaO5qwvwog=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-484-8SRBfHT4MAuRMcvXofuyBQ-1; Wed, 05 Jun 2024 06:57:01 -0400
X-MC-Unique: 8SRBfHT4MAuRMcvXofuyBQ-1
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-35dcd39c6ebso483359f8f.1
        for <kvm@vger.kernel.org>; Wed, 05 Jun 2024 03:57:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717585020; x=1718189820;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RpjR3tYu4gNEZK9rQflRkM9ZdMjt1RHla3f80fxVLo8=;
        b=v4uByb8n0NS3Okl9rwxLlNsRVJ+5/drcLjEnPg9ZQ6bFuVjFrgobDFR1qXyAmYto5/
         90FYEn/KPYZdz5ljOdsvEw9nyHNbBaTIs6y1zvWlS4XDk2t95SFMzuCQ4WXEzISrLxF7
         Kd9xRIx2vsM1VFq32O57V8lcUdhviWAU/10a4OQ+6m/yoHjXC5V4H/aXT+oTkW2cDqjT
         qRNAOmfOhwYnGHCFtCpW6HFm61VkJ0ISE5AYS68Wx7jm9Uz9d3VPdJTmiIXMyNJZSa0k
         HDUxY12AcFwU766ixi03wrX09tTJPKFBGkO84siezIL7qfGr+B3qJMb2B7UIkg5n/gZF
         TMDg==
X-Forwarded-Encrypted: i=1; AJvYcCUq7cn2frcWDJHHBpjtIr3rUiRNZ5mImMuLeV2eA6tndfdfOOOaJqh5RBo/RQxBC1WvNPx5adkZQVyTOTvPZrQGuGDD
X-Gm-Message-State: AOJu0YzeuHNi/AZhBSn0TBltHMLqMOuwaFZwcnHax/KKjaounisN6wtR
	HaxNxT5Q7o4qZGXSZmKdGD8HISWtvb7dtqIy8oy/0MPhFvKckp8yXnR/J2bv5noa+K4M9BppkG8
	GSwCuQhYhv45e+WJ4vnvnB2DNrbMkOD9TTY+H89B+5bHI23FGMBM1qwWJg3ufJyw8hk+OtTYMaN
	WDLn/OaAgT+3zHcbnU6WPMJMxW
X-Received: by 2002:adf:f452:0:b0:35e:543a:a930 with SMTP id ffacd0b85a97d-35e7c541a2cmr4826034f8f.18.1717585020457;
        Wed, 05 Jun 2024 03:57:00 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFFFw1b+GVtnS7jeDa02eHpqG5fFDZGNtrsTEvV0zGWUjM6JqKW31D5SQOYe+/s7ZnChxXMbZ8B4zkNjusKkC8=
X-Received: by 2002:adf:f452:0:b0:35e:543a:a930 with SMTP id
 ffacd0b85a97d-35e7c541a2cmr4826013f8f.18.1717585020051; Wed, 05 Jun 2024
 03:57:00 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240605072808.1039636-1-maz@kernel.org>
In-Reply-To: <20240605072808.1039636-1-maz@kernel.org>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Wed, 5 Jun 2024 12:56:47 +0200
Message-ID: <CABgObfZLV01WqLVX5EGqyibomYmdtjOBD=UuSDhpgKuLrJM7NQ@mail.gmail.com>
Subject: Re: [GIT PULL] KVM/arm64 fixes for 6.10, take #1
To: Marc Zyngier <maz@kernel.org>
Cc: Fuad Tabba <tabba@google.com>, Joey Gouly <joey.gouly@arm.com>, 
	Mark Brown <broonie@kernel.org>, Nina Schoetterl-Glausch <nsg@linux.ibm.com>, 
	Oliver Upton <oliver.upton@linux.dev>, James Morse <james.morse@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 5, 2024 at 9:28=E2=80=AFAM Marc Zyngier <maz@kernel.org> wrote:
>
> Paolo,
>
> Here's a large-ish set of fixes for 6.10, the bulk of it addressing
> the sorry state of pKVM's handling of FP/SVE (kudos to Fuad for sticking
> with it and getting the series in shape).
>
> The rest is a more esoteric set of AArch32 and NV fixes, details in the
> tag as usual.
>
> Please pull,

Pulled, thanks.

Paolo

>
>         M.
>
> The following changes since commit 1613e604df0cd359cf2a7fbd9be7a0bcfacfab=
d0:
>
>   Linux 6.10-rc1 (2024-05-26 15:20:12 -0700)
>
> are available in the Git repository at:
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kv=
marm-fixes-6.10-1
>
> for you to fetch changes up to afb91f5f8ad7af172d993a34fde1947892408f53:
>
>   KVM: arm64: Ensure that SME controls are disabled in protected mode (20=
24-06-04 15:06:33 +0100)
>
> ----------------------------------------------------------------
> KVM/arm64 fixes for 6.10, take #1
>
> - Large set of FP/SVE fixes for pKVM, addressing the fallout
>   from the per-CPU data rework and making sure that the host
>   is not involved in the FP/SVE switching any more
>
> - Allow FEAT_BTI to be enabled with NV now that FEAT_PAUTH
>   is copletely supported
>
> - Fix for the respective priorities of Failed PAC, Illegal
>   Execution state and Instruction Abort exceptions
>
> - Fix the handling of AArch32 instruction traps failing their
>   condition code, which was broken by the introduction of
>   ESR_EL2.ISS2
>
> - Allow vpcus running in AArch32 state to be restored in
>   System mode
>
> - Fix AArch32 GPR restore that would lose the 64 bit state
>   under some conditions
>
> ----------------------------------------------------------------
> Fuad Tabba (9):
>       KVM: arm64: Reintroduce __sve_save_state
>       KVM: arm64: Fix prototype for __sve_save_state/__sve_restore_state
>       KVM: arm64: Abstract set/clear of CPTR_EL2 bits behind helper
>       KVM: arm64: Specialize handling of host fpsimd state on trap
>       KVM: arm64: Allocate memory mapped at hyp for host sve state in pKV=
M
>       KVM: arm64: Eagerly restore host fpsimd/sve state in pKVM
>       KVM: arm64: Consolidate initializing the host data's fpsimd_state/s=
ve in pKVM
>       KVM: arm64: Refactor CPACR trap bit setting/clearing to use ELx for=
mat
>       KVM: arm64: Ensure that SME controls are disabled in protected mode
>
> Marc Zyngier (5):
>       KVM: arm64: Fix AArch32 register narrowing on userspace write
>       KVM: arm64: Allow AArch32 PSTATE.M to be restored as System mode
>       KVM: arm64: AArch32: Fix spurious trapping of conditional instructi=
ons
>       KVM: arm64: nv: Fix relative priorities of exceptions generated by =
ERETAx
>       KVM: arm64: nv: Expose BTI and CSV_frac to a guest hypervisor
>
>  arch/arm64/include/asm/el2_setup.h      |  6 +--
>  arch/arm64/include/asm/kvm_arm.h        |  6 +++
>  arch/arm64/include/asm/kvm_emulate.h    | 71 ++++++++++++++++++++++++++-=
-
>  arch/arm64/include/asm/kvm_host.h       | 25 +++++++++-
>  arch/arm64/include/asm/kvm_hyp.h        |  4 +-
>  arch/arm64/include/asm/kvm_pkvm.h       |  9 ++++
>  arch/arm64/kvm/arm.c                    | 76 +++++++++++++++++++++++++++=
++
>  arch/arm64/kvm/emulate-nested.c         | 21 +++++----
>  arch/arm64/kvm/fpsimd.c                 | 11 +++--
>  arch/arm64/kvm/guest.c                  |  3 +-
>  arch/arm64/kvm/hyp/aarch32.c            | 18 ++++++-
>  arch/arm64/kvm/hyp/fpsimd.S             |  6 +++
>  arch/arm64/kvm/hyp/include/hyp/switch.h | 36 +++++++-------
>  arch/arm64/kvm/hyp/include/nvhe/pkvm.h  |  1 -
>  arch/arm64/kvm/hyp/nvhe/hyp-main.c      | 84 +++++++++++++++++++++++++++=
++----
>  arch/arm64/kvm/hyp/nvhe/pkvm.c          | 17 ++-----
>  arch/arm64/kvm/hyp/nvhe/setup.c         | 25 +++++++++-
>  arch/arm64/kvm/hyp/nvhe/switch.c        | 24 ++++++++--
>  arch/arm64/kvm/hyp/vhe/switch.c         | 12 +++--
>  arch/arm64/kvm/nested.c                 |  6 ++-
>  arch/arm64/kvm/reset.c                  |  3 ++
>  21 files changed, 391 insertions(+), 73 deletions(-)
>


