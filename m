Return-Path: <kvm+bounces-49099-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 75FE7AD5E11
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 20:26:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D99FD189CFBC
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 18:26:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E95D5224B06;
	Wed, 11 Jun 2025 18:25:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Bpo2y7fZ"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 907312E6128
	for <kvm@vger.kernel.org>; Wed, 11 Jun 2025 18:25:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749666355; cv=none; b=jYQKu3sNetWM2m1oW9s8bRu3BCLYGTMPTQU8vicwszVSBKAKlx5BZV361xbRvRr2O7ZTduRRDEWRpuyuv7dvC4lVpEEfUnbKIs+tmpK550wQ9zqporMtclhPU+sS3bh3uKE7tWnMTa3Ltg7/afLN9I73B/1w+HnB8H+cRX5b59s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749666355; c=relaxed/simple;
	bh=QGXUcJIhIQ30ANDc0g0NUebN9lT2jTMPVVFunQbRRKU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=EOrc2qnRRas1B3Wyj/fugNKQ8q26PIe2p2mxlRkSCJB+kOUpHaILHvPYSY1h0mdphhXQXXbjzRANtkVNiD0L4cJO69thXqyMmVgUx0xnmwtW08nqyP4nlAaXdNMSUxA9dkterTTANmuWa23DUboHQj1TaHwjD7PyFnPAz5EalDc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Bpo2y7fZ; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1749666352;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OOOIslp7Z9nXASpzhAXfaGcmmRlsRSek7f7fvNs7EhY=;
	b=Bpo2y7fZwjlIfMH5DBPIDfVZgRtEghb0WbH3foldo2TdYQOaFt5KYf/YjuqdTqnHwzVv97
	1mD3RI14Upa5UUqRlvsevZ5zgsXsziNFrYazYHIv64lWBM+bF7F7+43eA5/6guZRmGYaaC
	cz3UGX3Pvl0+k52O+ExRlSvfCxbbZEI=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-113-1gGf17upNsWBRDxpDSwitw-1; Wed, 11 Jun 2025 14:25:51 -0400
X-MC-Unique: 1gGf17upNsWBRDxpDSwitw-1
X-Mimecast-MFC-AGG-ID: 1gGf17upNsWBRDxpDSwitw_1749666350
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-3a4fabcafecso104527f8f.0
        for <kvm@vger.kernel.org>; Wed, 11 Jun 2025 11:25:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749666350; x=1750271150;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OOOIslp7Z9nXASpzhAXfaGcmmRlsRSek7f7fvNs7EhY=;
        b=j+6kSP3zK2vWGUSkV0wFJuVT/J8lA0K4HmB7dkFw7ypJHlaHXKnBjal4fhNMlrhrn7
         84LfAAbtRxPV1xP7dGG3GfdjIXU49rbYOQjAER/YghNe83lNdROzxg0mQpI9wuw56bGn
         nxrYk+t3vGuezMXDqoh8psJRJ4L6QXcIOyV+MLLo2eRH9zrBTnUvuN5YJJVEZ5ySBNNv
         79oTsOaCptRlnyLGD2Yl9L3pAj6JmnbvwNhKEs8KkevuW2lyPFKXw/soEpPV50tsZIJ0
         I3cMqthmnQRxbV+LICcI5rMgHuly4F/DWxdXQr9ZggNbVtMdmYDAfO7qjCNGODC04Qun
         g3mw==
X-Forwarded-Encrypted: i=1; AJvYcCXTWjtT50IF6l1Yy8K3hvbSkNzwWJ70p+vK2USB6WiIFvBimHDUursdfIAhVhLKo0moXSA=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzk6s23C/dUt+8jYOKrK7vjoljuKBBK09k61YkVcwHljOYQIFKW
	AhVH6Us2eSZgQ1HcmXVnJh5obm7w56Iy6M933nJLiU3VKM+IRhwG4ohNMiuLdVuoI86WWxcVQFH
	/sNC2kl5ckVhh0Gbpe8twKXnDB750Xmli+V0ZaK+VYpttZbZDR6TmRG6Z7xXroHUfLIPo4DKkms
	AC4Dw8114i4I+GRxvXc1p+6KRgdSoH
X-Gm-Gg: ASbGncurXgut0ZQQasT4yE2XOWA+BHYcmPawlp0Cd/C83ddTMW5CnSw88im67Pbyj0B
	xrTQH6ocj0pMSOUu3YxRRsckysa5lskC8OeKkV1G+kAQoa0gfcQ3Wxts+/whrfhZinQkWNAs7IN
	xbsw==
X-Received: by 2002:a05:6000:420f:b0:3a5:2f23:3783 with SMTP id ffacd0b85a97d-3a55869b8e1mr3427930f8f.24.1749666350210;
        Wed, 11 Jun 2025 11:25:50 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFw1W0p/OeOmX200drwAxajGEghfRNt/CGI93zVm1UqIQ+I2s8lkCVrViNK/rTG856Z88dFFfkE8v1yeaf2mxA=
X-Received: by 2002:a05:6000:420f:b0:3a5:2f23:3783 with SMTP id
 ffacd0b85a97d-3a55869b8e1mr3427915f8f.24.1749666349830; Wed, 11 Jun 2025
 11:25:49 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250606094350.1318309-1-maz@kernel.org>
In-Reply-To: <20250606094350.1318309-1-maz@kernel.org>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Wed, 11 Jun 2025 20:25:37 +0200
X-Gm-Features: AX0GCFsgTrXBmCEi1cZ9vmBCByY8mT5dVXknZ_pqZHoWTAQJcrp5JqwyhfcBkUo
Message-ID: <CABgObfbd=Jx4UdXKXyCb+8bQotLk-rc8P_BD-Aafx_rttgHMYA@mail.gmail.com>
Subject: Re: [GIT PULL] KVM/arm64 fixes for 6.16, take #2
To: Marc Zyngier <maz@kernel.org>
Cc: Miguel Luis <miguel.luis@oracle.com>, Oliver Upton <oliver.upton@linux.dev>, 
	Sebastian Ott <sebott@redhat.com>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 6, 2025 at 11:44=E2=80=AFAM Marc Zyngier <maz@kernel.org> wrote=
:
>
> Paolo,
>
> Here the second batch of fixes for 6.16. We have a significant rework
> of our system register accessors so that the RES0/RES1 sanitisation
> gets applied at the right time, and a bunch of fixes for a single
> selftest that really *never* worked.
>
> Please pull,

Pulled, thanks.

Paolo

>         M.
>
> The following changes since commit 4d62121ce9b58ea23c8d62207cbc604e98ecdc=
0a:
>
>   KVM: arm64: vgic-debug: Avoid dereferencing NULL ITE pointer (2025-05-3=
0 10:24:49 +0100)
>
> are available in the Git repository at:
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kv=
marm-fixes-6.16-2
>
> for you to fetch changes up to fad4cf944839da7f5c3376243aa353295c88f588:
>
>   KVM: arm64: selftests: Determine effective counter width in arch_timer_=
edge_cases (2025-06-05 14:28:44 +0100)
>
> ----------------------------------------------------------------
> KVM/arm64 fixes for 6.16, take #2
>
> - Rework of system register accessors for system registers that are
>   directly writen to memory, so that sanitisation of the in-memory
>   value happens at the correct time (after the read, or before the
>   write). For convenience, RMW-style accessors are also provided.
>
> - Multiple fixes for the so-called "arch-timer-edge-cases' selftest,
>   which was always broken.
>
> ----------------------------------------------------------------
> Marc Zyngier (4):
>       KVM: arm64: Add assignment-specific sysreg accessor
>       KVM: arm64: Add RMW specific sysreg accessor
>       KVM: arm64: Don't use __vcpu_sys_reg() to get the address of a sysr=
eg
>       KVM: arm64: Make __vcpu_sys_reg() a pure rvalue operand
>
> Sebastian Ott (4):
>       KVM: arm64: selftests: Fix help text for arch_timer_edge_cases
>       KVM: arm64: selftests: Fix thread migration in arch_timer_edge_case=
s
>       KVM: arm64: selftests: Fix xVAL init in arch_timer_edge_cases
>       KVM: arm64: selftests: Determine effective counter width in arch_ti=
mer_edge_cases
>
>  arch/arm64/include/asm/kvm_host.h                  | 32 ++++++++++--
>  arch/arm64/kvm/arch_timer.c                        | 18 +++----
>  arch/arm64/kvm/debug.c                             |  4 +-
>  arch/arm64/kvm/fpsimd.c                            |  4 +-
>  arch/arm64/kvm/hyp/exception.c                     |  4 +-
>  arch/arm64/kvm/hyp/include/hyp/switch.h            |  4 +-
>  arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h         |  6 +--
>  arch/arm64/kvm/hyp/nvhe/hyp-main.c                 |  4 +-
>  arch/arm64/kvm/hyp/vhe/switch.c                    |  4 +-
>  arch/arm64/kvm/hyp/vhe/sysreg-sr.c                 | 48 ++++++++--------=
-
>  arch/arm64/kvm/nested.c                            |  2 +-
>  arch/arm64/kvm/pmu-emul.c                          | 24 ++++-----
>  arch/arm64/kvm/sys_regs.c                          | 60 +++++++++++-----=
------
>  arch/arm64/kvm/sys_regs.h                          |  4 +-
>  arch/arm64/kvm/vgic/vgic-v3-nested.c               | 10 ++--
>  .../selftests/kvm/arm64/arch_timer_edge_cases.c    | 39 +++++++++-----
>  16 files changed, 151 insertions(+), 116 deletions(-)
>


