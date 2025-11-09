Return-Path: <kvm+bounces-62415-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C2D1FC439B9
	for <lists+kvm@lfdr.de>; Sun, 09 Nov 2025 08:12:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 69E3B3AFB39
	for <lists+kvm@lfdr.de>; Sun,  9 Nov 2025 07:12:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C26AF245014;
	Sun,  9 Nov 2025 07:12:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dQQWJMin";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="OtwONP0E"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F9A3242D7D
	for <kvm@vger.kernel.org>; Sun,  9 Nov 2025 07:12:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762672356; cv=none; b=QL6ZvLm9Lp24xT446/6DZUz/VaDlSXfhuQx8KwT3FItySV4Ag/6OMIzaJ5wCggZ9gtqjA8hMmZ7oZf/0vGXoIWNgeFSc5r6J2tFe/W89pGTBOBJYWTzVdEX5kX8BBtYvm4RPHANKoe0IuNMJhrEtzXXfZTSiQtEK+l4V6FnOXDU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762672356; c=relaxed/simple;
	bh=AdHoQjrbJVFhbXbn4e53hG++/4NMIHDDh8uAXYDruqQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=QctlIJP+qUtmRt/t69bHlICh87O7S7yyRhvN9Cy0J7REk6TesSwZ69eTjV7+82G+TJVx++rBLjoNiXFCnSfQCsS+OvR+KeQek4D/0bwWwhO+sCFSlAbPPzT/LwYQ0SnfyQA5X0kEIA6lYNBgMKtgQFwd7O2dj+LVQK6y+KP/4qU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=dQQWJMin; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=OtwONP0E; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1762672354;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=m82cK3xRCUvbcWhZbxs+7WqSqZtr7xd6qiGXFqz/RDg=;
	b=dQQWJMin8BoFu9Iz8/O4zl1ZszWz+I8apNdzENFNDj7qX5t0VHWqOPQ8pP0HxUa+joPUug
	vx0Lg8RDN77MNIGfeJZY+iL1duaYfkXlLrJWNftgEOs7Iu4jT1P79gWspBRDMNuLWqulsW
	4dTC9pSVlen1tERg2zYRJt2907IPrZc=
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com
 [209.85.214.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-634-pFNbucxKOayFfDaWfLmb-w-1; Sun, 09 Nov 2025 02:12:32 -0500
X-MC-Unique: pFNbucxKOayFfDaWfLmb-w-1
X-Mimecast-MFC-AGG-ID: pFNbucxKOayFfDaWfLmb-w_1762672352
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-297d50cd8c4so38028615ad.0
        for <kvm@vger.kernel.org>; Sat, 08 Nov 2025 23:12:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1762672351; x=1763277151; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=m82cK3xRCUvbcWhZbxs+7WqSqZtr7xd6qiGXFqz/RDg=;
        b=OtwONP0Es+55TGk0aJEIkjpgaQ/DMVMlWXLwLBMHJfTv3apandFkzEAcqym3Ui8Jos
         NhrbT3w6CQ1ZBJs6gOzqNg9cyq7uQEaNc9isTC0tqemkCAYQQGMP+wolasoYWQ+ZQsfM
         qOrDV3+0dL83+BLPCYjt12n6ZuV4I/4pha0BivSod32mgJ7FCbyMZMsctnyUd64e+hUb
         sAI/DtmU6AC8WlKMcJkmG/mXbjDYYObyNAe41/g3rP0ih61iJI5mNHYqnPh0yiYZ12lV
         /52VqGq1+lrIdr9nuirgNrSPo5R+ND3/kMqqxPITYEtaMITjrX0TYqc3UF/kBH4Sc2BK
         ZJZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762672351; x=1763277151;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=m82cK3xRCUvbcWhZbxs+7WqSqZtr7xd6qiGXFqz/RDg=;
        b=c513Bpn0QlycQbODwc4twk/2xYXMcpUXqyIHJTZHD5tPEfno3v9UvzPss6XdpUhFuO
         uE44z707RlRfPxtup/JAwDdPYroBLE8MHEdyRCmooO/EWijCdNdpwWd/5/e8SwJVKdwf
         gnPdyR+hLzQtSeCFF0kbglOSX2fs/gtLKuKISXmLqp/NTj1BmULR0wwGqBW3qYwRbOrG
         CuVPhoSIjcHDaM7WLz2/E7dX/NUkg/Gy2rywlUSNAIDjGZ5wQoeJf0710oLUVSijzM8m
         d/XLphbTJMWT4szfn4PQoH6Ihr/EpKKugt4xpYzjzVG9Bf/Q9i+8bc6axjtJvxGqEZOQ
         2baQ==
X-Forwarded-Encrypted: i=1; AJvYcCUMNovJ6/3XrbFt6wo/jtCLXNMq0KUPQnwGhWN9w8rdevLAEIK1PadeVEhOIO9zRPRUYNk=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywe4zM45QATDlbTO5Rd8oph/bUys7rMdSNFRvDgQdGgRGUuDMx+
	xqDinbO6iOEH1Smcl4e6NPnThDD+3f6yfx+bNNnBw/BE20QynHH/azLaheigd+9pxJdZOgAhCx5
	Aan1IZGd6OS4DetVW0pophwYqFfMML58Du/E6nk3cT7eScyIqCq3hvcJIH0jpqgyVAkJNpJ4+XK
	9Eu/gc/7rowAyrMpTTpoaxkbdCOhs5
X-Gm-Gg: ASbGncsKLUWzp5jd9oG9eHeIhySY7zTWhvjdu9Jn7ZZyic7e6JHj2MX5IA31hVuV+BJ
	d6uvMoEbZ0kqHCL0x/eiOYPM39ao+pM12ZXPdoy/aFIIqn6pYXxSIgatp1R4cJQ/qvc3v5cQ2S7
	kX5xzXZ9nAlyhttRgpx2a913WG2nA4qWw2GBWEEBXar/XFKZyfsIMyTRAa6WNVe7jqEUMkpqYhP
	4Xv69ENvMJDfcxqqkXsdz/nx23O+4MRcNQj5KekmuJJ/96/xiW3J4xfXgQx
X-Received: by 2002:a17:902:e78f:b0:295:68df:da34 with SMTP id d9443c01a7336-297e5718086mr51623535ad.53.1762672351600;
        Sat, 08 Nov 2025 23:12:31 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGmxSGLvw4pgRZ8aTw3qCykYC8xSzISK8rwIn1R2Gkp0ELn8flQDD1U9o+r1UzqIM5FPkf2ioy3/4F0I7hTmD4=
X-Received: by 2002:a17:902:e78f:b0:295:68df:da34 with SMTP id
 d9443c01a7336-297e5718086mr51623375ad.53.1762672351274; Sat, 08 Nov 2025
 23:12:31 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251108120559.1201561-1-maz@kernel.org>
In-Reply-To: <20251108120559.1201561-1-maz@kernel.org>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Sun, 9 Nov 2025 08:12:17 +0100
X-Gm-Features: AWmQ_bkaJ1JaU0aGn42MK0o7nRRGD7HuTETuGXjvrbkmq0cZ5a-Jnj8bQX-Px3w
Message-ID: <CABgObfa2ShbRn-MctT7-y4joG85AgtjgKXM=OJA9_2FbDZ6XPQ@mail.gmail.com>
Subject: Re: [GIT PULL] KVM/arm64 fixes for 6.18, take #2
To: Marc Zyngier <maz@kernel.org>
Cc: Mark Brown <broonie@kernel.org>, Maximilian Dittgen <mdittgen@amazon.de>, 
	Oliver Upton <oupton@kernel.org>, Peter Maydell <peter.maydell@linaro.org>, 
	Sascha Bischoff <sascha.bischoff@arm.com>, Sebastian Ene <sebastianene@google.com>, 
	Sebastian Ott <sebott@redhat.com>, stable@vger.kernel.org, 
	Vincent Donnefort <vdonnefort@google.com>, Will Deacon <will@kernel.org>, 
	Zenghui Yu <yuzenghui@huawei.com>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Nov 8, 2025 at 1:06=E2=80=AFPM Marc Zyngier <maz@kernel.org> wrote:
>
> Paolo,
>
> Much later than expected, but here's the second set of fixes KVM/arm64
> for 6.18. The core changes are mostly fixes for a bunch of recent
> regressions, plus a couple that address the way pKVM deals with
> untrusted data. The rest address a couple of selftests, and Oliver's
> new email address.

Pulled, thanks.

Paolo

>
> Please pull,
>
>         M.
>
> The following changes since commit ca88ecdce5f51874a7c151809bd2c936ee0d38=
05:
>
>   arm64: Revamp HCR_EL2.E2H RES1 detection (2025-10-14 08:18:40 +0100)
>
> are available in the Git repository at:
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kv=
marm-fixes-6.18-2
>
> for you to fetch changes up to 4af235bf645516481a82227d82d1352b9788903a:
>
>   MAINTAINERS: Switch myself to using kernel.org address (2025-11-08 11:2=
1:20 +0000)
>
> ----------------------------------------------------------------
> KVM/arm654 fixes for 6.18, take #2
>
> * Core fixes
>
>   - Fix trapping regression when no in-kernel irqchip is present
>     (20251021094358.1963807-1-sascha.bischoff@arm.com)
>
>   - Check host-provided, untrusted ranges and offsets in pKVM
>     (20251016164541.3771235-1-vdonnefort@google.com)
>     (20251017075710.2605118-1-sebastianene@google.com)
>
>   - Fix regression restoring the ID_PFR1_EL1 register
>     (20251030122707.2033690-1-maz@kernel.org
>
>   - Fix vgic ITS locking issues when LPIs are not directly injected
>     (20251107184847.1784820-1-oupton@kernel.org)
>
> * Test fixes
>
>   - Correct target CPU programming in vgic_lpi_stress selftest
>     (20251020145946.48288-1-mdittgen@amazon.de)
>
>   - Fix exposure of SCTLR2_EL2 and ZCR_EL2 in get-reg-list selftest
>     (20251023-b4-kvm-arm64-get-reg-list-sctlr-el2-v1-1-088f88ff992a@kerne=
l.org)
>     (20251024-kvm-arm64-get-reg-list-zcr-el2-v1-1-0cd0ff75e22f@kernel.org=
)
>
> * Misc
>
>   - Update Oliver's email address
>     (20251107012830.1708225-1-oupton@kernel.org)
>
> ----------------------------------------------------------------
> Marc Zyngier (3):
>       KVM: arm64: Make all 32bit ID registers fully writable
>       KVM: arm64: Set ID_{AA64PFR0,PFR1}_EL1.GIC when GICv3 is configured
>       KVM: arm64: Limit clearing of ID_{AA64PFR0,PFR1}_EL1.GIC to userspa=
ce irqchip
>
> Mark Brown (2):
>       KVM: arm64: selftests: Add SCTLR2_EL2 to get-reg-list
>       KVM: arm64: selftests: Filter ZCR_EL2 in get-reg-list
>
> Maximilian Dittgen (1):
>       KVM: selftests: fix MAPC RDbase target formatting in vgic_lpi_stres=
s
>
> Oliver Upton (3):
>       KVM: arm64: vgic-v3: Reinstate IRQ lock ordering for LPI xarray
>       KVM: arm64: vgic-v3: Release reserved slot outside of lpi_xa's lock
>       MAINTAINERS: Switch myself to using kernel.org address
>
> Sascha Bischoff (1):
>       KVM: arm64: vgic-v3: Trap all if no in-kernel irqchip
>
> Sebastian Ene (1):
>       KVM: arm64: Check the untrusted offset in FF-A memory share
>
> Vincent Donnefort (1):
>       KVM: arm64: Check range args for pKVM mem transitions
>
>  .mailmap                                           |  3 +-
>  MAINTAINERS                                        |  2 +-
>  arch/arm64/kvm/hyp/nvhe/ffa.c                      |  9 ++-
>  arch/arm64/kvm/hyp/nvhe/mem_protect.c              | 28 +++++++++
>  arch/arm64/kvm/sys_regs.c                          | 71 ++++++++++++----=
------
>  arch/arm64/kvm/vgic/vgic-debug.c                   | 16 +++--
>  arch/arm64/kvm/vgic/vgic-init.c                    | 16 ++++-
>  arch/arm64/kvm/vgic/vgic-its.c                     | 18 +++---
>  arch/arm64/kvm/vgic/vgic-v3.c                      |  3 +-
>  arch/arm64/kvm/vgic/vgic.c                         | 23 ++++---
>  tools/testing/selftests/kvm/arm64/get-reg-list.c   |  3 +
>  tools/testing/selftests/kvm/lib/arm64/gic_v3_its.c |  9 ++-
>  12 files changed, 137 insertions(+), 64 deletions(-)
>


