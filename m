Return-Path: <kvm+bounces-72279-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id UIedJhcEo2kJ8wQAu9opvQ
	(envelope-from <kvm+bounces-72279-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Sat, 28 Feb 2026 16:04:55 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 15FFC1C3CB2
	for <lists+kvm@lfdr.de>; Sat, 28 Feb 2026 16:04:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id C165A305FC73
	for <lists+kvm@lfdr.de>; Sat, 28 Feb 2026 15:04:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 488C644D006;
	Sat, 28 Feb 2026 15:04:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BXFjYUJe";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="BW/VGyHM"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0A1C44CF57
	for <kvm@vger.kernel.org>; Sat, 28 Feb 2026 15:04:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=170.10.129.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772291090; cv=pass; b=UzIM5KOREcRhgyGBrCiHERPFEh+TpL4NETO19qXURkhH3iEDQb/PEiXjZUPeeikuBHZgFmYwzLkkNvo89NDW8X2hqs7lFmoJjfO9W6mCc+lMs489ZSarbtdrx3ZahpniSq48PEu3A3/u6LZIWJCRshC36DpXFm9wMp6TmqApx84=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772291090; c=relaxed/simple;
	bh=SdKoZ3P29SBChdW2+DAlKUHQS957CCriW5kGfebxdJE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ro85GlBaO4ZHR6o95V2RDaBexQ4gdiWhJskaBIZ0DtRFuirb5J/GGQTS5TB42n40ajPiGFRPhMn4ZJ2vGaK29eIG4oU4XyCZ4vVdFNuUS9inLJbO3UNcBZrIIIK7NdEzMODetPzcKlfEfeI/6Ds+UBBSP778ggMgZ/V2GpKIaUU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=BXFjYUJe; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=BW/VGyHM; arc=pass smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1772291087;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zx/41eGZi0CJBh+Og8Z1FttBS/rIdtUYQz5ebE6xc1E=;
	b=BXFjYUJeEGR8mO00/IfIzaIJ8WK/1A1Bo7Dmb2SUQJTDkSkRIvkTtxrt3qxcxpSjltV0Xb
	9efz+Lyg2gOe8Y2ejkPLjYz50DB03ofUoRx5lgSrSz8bDJB75Hzv3/H+ykj+netBQ1U7WU
	ZIfalLV/K2nCvZEwBl36JtdDRV0SLCY=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-297-pJiDRSFIMiOxo0de2sSI8g-1; Sat, 28 Feb 2026 10:04:45 -0500
X-MC-Unique: pJiDRSFIMiOxo0de2sSI8g-1
X-Mimecast-MFC-AGG-ID: pJiDRSFIMiOxo0de2sSI8g_1772291084
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-4376e25bb4dso1749411f8f.0
        for <kvm@vger.kernel.org>; Sat, 28 Feb 2026 07:04:45 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772291082; cv=none;
        d=google.com; s=arc-20240605;
        b=EwD73Rb/uTwJk/Z1mU4FBOzhhDt0YAolQMIlZun0ZLdx0J/PtU6ct+7+xsrK3fSRpE
         +kzJTBgfkoyhMU1YTu8bHs288YIco11cLNsoHCXXkLF8AADDtY8z4pZPci2j2bsFn/+x
         PpEey97NSZr+6Borcz4P6R0RiTuUHnd+0Z83occflnm/MKEcvUuv+KeqCi1hGk/1IZhT
         oEhKZyKoguedhPreoXgQLlYnSukGYjHZRJkbN4fQnDrCRxNOFIfUNluAdTpzTgwfMAAT
         TMF9RoZVnBbD263RHiMSP5Q6FjiIhOZ/KqSHb7hi2YHHTsEy39AkJOgczfglNR8IDL/y
         ItwA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=zx/41eGZi0CJBh+Og8Z1FttBS/rIdtUYQz5ebE6xc1E=;
        fh=5Je8+aHFSc3ehuOq77CQlXH1G6aMtT1Ku01W1X/P/Gk=;
        b=A+GK/AdkfZRCzpxlyCpaQJkM1+6JVysv4pzbiBLqlDVNUdFowIUgwjsjcJgQzQZPxi
         05QO2/BMWW8uV1GIAl+StI2sgna4TlxkYFfO39UEsqF1pj1sIHLJ0Lce80/UFnODSeVF
         j6yA0hZ3OBMn0p6YdHBZp5eh702t7wbwvrxFDPXp/rSur5wTils3BMTJvoFHllUEW3i1
         eQibxAs98pW73Kctq8J368Rv3jw9gXH6V7PDaZHwhAvjqSQ4nNJmczbaa9NbsywcZ5gm
         yi67Urhr/NUarlAzYx4BZedhTYj9STcRLZkcuOITHfwrC9YfK91h7iVJq2aTSB8EMLSe
         NgBg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1772291082; x=1772895882; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zx/41eGZi0CJBh+Og8Z1FttBS/rIdtUYQz5ebE6xc1E=;
        b=BW/VGyHMStrfDP8arS8iPYMQsmZhR/LbGlcqLn7fYVVXGHYMpxwI/+qkEnL5AGvQj1
         7JWVrrFX3Wbuo1Etrb+rDLg3hWNyugs5jPXu77VUJdTdD1ho8H9f54qpmHXIg1vZcXc8
         EJUWa0BxI0XO39I7WiMOSwO2GR/inPy6Vb9j/ojnJnH6aTmGSIl1jYeDd/INzKHrk/sC
         Nj6hvvZbvLd+L5zWBruS5zXpo7STJgCTPC++5ML1iYygbF8V77iq1JJg8WOrcAB4S06Q
         zVseVEAOA5fj7wE0cPZCmLqfYUQNeGF2avV6cIu8uod9VACmRgeVurNW/Nd58365RdWd
         978Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772291082; x=1772895882;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=zx/41eGZi0CJBh+Og8Z1FttBS/rIdtUYQz5ebE6xc1E=;
        b=Ju4yt7srNLqXxy9yNulHRzDPfEu/lBXF3Wx2dXK5DYBzvHpYUzgk2Z6mMumk5TDygI
         jNSpdRdup+MLLe3/78k31ZMIkPdzKgO8SyFLm7Oh4NJ4VLef2Jfbruseomg0Uk8svDJe
         5X4NS4LZvYu3wqsmQ8z9dLxTWv/n4NRtlVxzcNj9u83Ugpj0ZiITAP6UAxoMZBDe3ihk
         fQXbanvClUMN4QrPUypA2uaeqCgbevdqVwoNI9lvEV7ax7nOS8bBI7t0Pt2WpGZ1M63Z
         luwySczX4/9PqKJi2nDMqycD3+ST0dkBw9Ew9vY1Zjm9kI+YumwlNuG4KGHdsJQY5Xkg
         wojg==
X-Forwarded-Encrypted: i=1; AJvYcCUjwOIhdZNOey3hIpIGQ6XpSaO9/elbUg3rXS6WIrwdtdktkV5yUDAs1g/G1qWEboAkZWE=@vger.kernel.org
X-Gm-Message-State: AOJu0YyRMx4k2w1743gqMqZ6wA3KINxdWBUQX5EJzUfgD3zlRQQxaL/Y
	Tt6vsDiYVAHwsx4dbviLnvHaYP0O5IF9SM2Xj3jjfgp+YuB5SuSyH2pQupci+RADJdWbNpquUDs
	X1ps5lacGUXhgfb5TuWKMiWbiNEar3/pOCPe8lezXV8ViSV5N770qWBfCQlRcNe7KGUMpflyEt0
	NKq9qKBMUNumN0t3k+Ry+9qbUzua12
X-Gm-Gg: ATEYQzyqYJ+M10ER969I7FzJ8eRYl7+LyvgzEARwewGULHze+RosP2Gxlki04ak+xsO
	DCkgxW9CFxBWAKEKtP0cFpF++r1O+oIzWMbLgS+SvQaudit5j/ERLa4+u5PDNl8haiFFlN+LguN
	Pk260YCHzOW30WBKDSTM1MyBsouwJQ8dTbb0QmjGpcxpPGLJSz6sfG+BjRZiEHCYKyn0TObUQop
	PbAPoVjsySVbl+BG8Jj2tyRQIRJAd9EYCh0oSdRQWRWfiSHOWPPJ1vkMRFSUk13PYmT5HhnTSnc
	C0j1etE=
X-Received: by 2002:a05:6000:26c6:b0:435:faa5:c15e with SMTP id ffacd0b85a97d-4399de28393mr11435480f8f.30.1772291081976;
        Sat, 28 Feb 2026 07:04:41 -0800 (PST)
X-Received: by 2002:a05:6000:26c6:b0:435:faa5:c15e with SMTP id
 ffacd0b85a97d-4399de28393mr11435430f8f.30.1772291081553; Sat, 28 Feb 2026
 07:04:41 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260226105048.28066-1-maz@kernel.org>
In-Reply-To: <20260226105048.28066-1-maz@kernel.org>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Sat, 28 Feb 2026 16:04:26 +0100
X-Gm-Features: AaiRm535mUPGGS-9UDvB7slsNDUQ3q2gpNPHAuAWbj3L_0kYm4R6oOTjJd7rRXg
Message-ID: <CABgObfZ=4+MwQt1axbAeDsstRUOi3nemmiXndV51POgMw7u=nw@mail.gmail.com>
Subject: Re: [GIT PULL] KVM/arm64 fixes for 7.0, take #1
To: Marc Zyngier <maz@kernel.org>
Cc: Fuad Tabba <tabba@google.com>, Joey Gouly <joey.gouly@arm.com>, 
	Jonathan Cameron <jonathan.cameron@huawei.com>, Kees Cook <kees@kernel.org>, 
	Mark Brown <broonie@kernel.org>, Sascha Bischoff <sascha.bischoff@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Oliver Upton <oupton@kernel.org>, 
	Zenghui Yu <yuzenghui@huawei.com>, kvmarm@lists.linux.dev, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[redhat.com,quarantine];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719,redhat.com:s=google];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-72279-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[13];
	DKIM_TRACE(0.00)[redhat.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	MISSING_XM_UA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[pbonzini@redhat.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,mail.gmail.com:mid]
X-Rspamd-Queue-Id: 15FFC1C3CB2
X-Rspamd-Action: no action

On Thu, Feb 26, 2026 at 11:51=E2=80=AFAM Marc Zyngier <maz@kernel.org> wrot=
e:
>
> Paolo,
>
> Here's the first set of KVM/arm64 fixes for 7.0. Most of it affects
> pKVM (feature set, MMU), but we also have a GICv5 fix and a couple of
> small cleanups. Details in the tag below.
>
> Note that there is a very minor conflict with Linus' tree due to Kees'
> patch having been applied to both trees. Whatever is in Linus' tree is
> the right thing.
>
> Please pull,

Pulled, thanks.

Paolo

>         M.
>
> The following changes since commit 6316366129d2885fae07c2774f4b7ae0a45fb5=
5d:
>
>   Merge branch kvm-arm64/misc-6.20 into kvmarm-master/next (2026-02-05 09=
:17:58 +0000)
>
> are available in the Git repository at:
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kv=
marm-fixes-7.0-1
>
> for you to fetch changes up to 54e367cb94d6bef941bbc1132d9959dc73bd4b6f:
>
>   KVM: arm64: Deduplicate ASID retrieval code (2026-02-25 12:19:33 +0000)
>
> ----------------------------------------------------------------
> KVM/arm64 fixes for 7.0, take #1
>
> - Make sure we don't leak any S1POE state from guest to guest when
>   the feature is supported on the HW, but not enabled on the host
>
> - Propagate the ID registers from the host into non-protected VMs
>   managed by pKVM, ensuring that the guest sees the intended feature set
>
> - Drop double kern_hyp_va() from unpin_host_sve_state(), which could
>   bite us if we were to change kern_hyp_va() to not being idempotent
>
> - Don't leak stage-2 mappings in protected mode
>
> - Correctly align the faulting address when dealing with single page
>   stage-2 mappings for PAGE_SIZE > 4kB
>
> - Fix detection of virtualisation-capable GICv5 IRS, due to the
>   maintainer being obviously fat fingered...
>
> - Remove duplication of code retrieving the ASID for the purpose of
>   S1 PT handling
>
> - Fix slightly abusive const-ification in vgic_set_kvm_info()
>
> ----------------------------------------------------------------
> Fuad Tabba (5):
>       KVM: arm64: Hide S1POE from guests when not supported by the host
>       KVM: arm64: Optimise away S1POE handling when not supported by host
>       KVM: arm64: Fix ID register initialization for non-protected pKVM g=
uests
>       KVM: arm64: Remove redundant kern_hyp_va() in unpin_host_sve_state(=
)
>       KVM: arm64: Revert accidental drop of kvm_uninit_stage2_mmu() for n=
on-NV VMs
>
> Kees Cook (1):
>       KVM: arm64: vgic: Handle const qualifier from gic_kvm_info allocati=
on type
>
> Marc Zyngier (2):
>       KVM: arm64: Fix protected mode handling of pages larger than 4kB
>       KVM: arm64: Deduplicate ASID retrieval code
>
> Sascha Bischoff (1):
>       irqchip/gic-v5: Fix inversion of IRS_IDR0.virt flag
>
>  arch/arm64/include/asm/kvm_host.h   |  3 +-
>  arch/arm64/include/asm/kvm_nested.h |  2 ++
>  arch/arm64/kvm/at.c                 | 27 ++--------------
>  arch/arm64/kvm/hyp/nvhe/pkvm.c      | 37 ++++++++++++++++++++--
>  arch/arm64/kvm/mmu.c                | 12 +++----
>  arch/arm64/kvm/nested.c             | 63 ++++++++++++++++++-------------=
------
>  arch/arm64/kvm/sys_regs.c           |  3 ++
>  arch/arm64/kvm/vgic/vgic-init.c     |  2 +-
>  drivers/irqchip/irq-gic-v5-irs.c    |  2 +-
>  9 files changed, 81 insertions(+), 70 deletions(-)
>


