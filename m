Return-Path: <kvm+bounces-46114-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 28E69AB243D
	for <lists+kvm@lfdr.de>; Sat, 10 May 2025 17:10:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B4AB5A04BF0
	for <lists+kvm@lfdr.de>; Sat, 10 May 2025 15:10:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E9C4F235054;
	Sat, 10 May 2025 15:10:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="O02CA1xx"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65E601DD0C7
	for <kvm@vger.kernel.org>; Sat, 10 May 2025 15:10:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746889852; cv=none; b=DryWgSjPJ/uVNuYdIk+fz4OKeTJ3fP0Dagw2H4haEu5qeNNe8X3ZeN+jwrshgS+I/eagZw0lX3PT1M4cbbqFrfDTbD3pgUYRbNLdwBtaT+63q2mOv8WDu/UrlMkcfS4MKIWQghnSy7/uzn8nDzwL6jC+i/2ZmqKZq9fcbNHi1YI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746889852; c=relaxed/simple;
	bh=qYJP1ocqOK8g0mqYCUIs+XsDUGAWsQBa4ZFg2UrZ58s=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=XPSN8TaT+AreVFPFVAVTTjjPW/6TFhzn+epzDlGDyKnbqGfRHLZEG1+hQAnneLC7caUkx8yVgvzHLBToVnrzVwTprQkL/YxjwzynQt30eFyXQhQtT5chE6Fq552JimgGsrrqFZ4anWumQ10iQ0xow57vX5OnVDWD4p5VNidyP54=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=O02CA1xx; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1746889849;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gYQJSjKMBtphEcdVsSmytVmx16FTbMzDliH0NXBgKhQ=;
	b=O02CA1xxhGcq3GjVC+QruDNvDs70Vs3a4dWze5/f+knxfnmAZ9qhefbr96g+oYvL0EMika
	oNgGyVLHewC975O6giqxtTvCB1Jg8i3ZR2wec+EuG3/53AcpXp4T+5Inag/BW40MYqZe6+
	cyJItQotpbA9PQlrsXrOik0HpJ3vj6U=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-85-GLiojgGmM5iH8TNaRKBTHg-1; Sat, 10 May 2025 11:10:48 -0400
X-MC-Unique: GLiojgGmM5iH8TNaRKBTHg-1
X-Mimecast-MFC-AGG-ID: GLiojgGmM5iH8TNaRKBTHg_1746889847
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-3a1c86b62e8so877878f8f.1
        for <kvm@vger.kernel.org>; Sat, 10 May 2025 08:10:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746889844; x=1747494644;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gYQJSjKMBtphEcdVsSmytVmx16FTbMzDliH0NXBgKhQ=;
        b=GMTI7r6PFVDvCcwcyimYTNXLI3DVb9EBp0vsFLh8iFB+qc70Tg3xliid1jUSwSMnTN
         NgzA0sHuO0Yizt9MLjQXnjtjma524bfYZ6SnIuBOKV0mvLWV7XjtbTplOtnPnaBAb/ra
         H8+z0mv59NOnVFvWBUybz47BB0eikwG/SBgMrpM8JLC3s0UWAs1WqJrtXI41psggTQfN
         8DH27rkkad9o9oWvBzl6+SID9fSYagXSF0ZPxwzNhWQuhwpstNGr/F1SBoFD4hPCJKG6
         Pa3sleEJUSt1baih0CKfo2n9qT8VlDmH1E2h2jQB296ntdX7rarxWJPPPErAli3wXbOS
         9quQ==
X-Forwarded-Encrypted: i=1; AJvYcCXoHjAWfuZSo5J124CdFl84zulU8H6DR89hHGoUBtfF3/cybIR+UoRCQITl53YyilitdVE=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw15fhEMDJC+je21Z1FKLcyCL80q+EGQSmCqoGI/RR6v+dQHa72
	kzk82W9qGxuCE/gLDrVtPo2srT5waLvJRez47LE9h8nUPz18Q3rFD4A9mnonIlJtZPvOcAAe3kE
	jqVvgRcX5LdgXzWsa/77NbD9Xh+0LSICxdxS1ZyxzI/b9pmb8zEy0OoIQxUylfD0JX4vC6f+dx2
	1WGR213Ixjtr26wRfJqtIRzdE8ljvSCYmt5gk=
X-Gm-Gg: ASbGnctfEp1p1teOxYrvwKq//TaHELvP3Je51z/WIrAbPDqY7LY7Tqs8ksv9B5HpecE
	DboCHUte3RuKn58rbR88TGggpdaLMxI1BPcGqBcUkxm1wd2jatOsTU16aPwDl18rAdBFx
X-Received: by 2002:a05:6000:401e:b0:390:f9d0:5e3 with SMTP id ffacd0b85a97d-3a1f6429791mr5829582f8f.1.1746889844238;
        Sat, 10 May 2025 08:10:44 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG3HAv56tpX1CVaBoQBHwxapjvoQVSypdQHF0GsehA9SFm4L6nv5dBcvq0VTg87PrzIKt2S+xyvjaQizn1+piQ=
X-Received: by 2002:a05:6000:401e:b0:390:f9d0:5e3 with SMTP id
 ffacd0b85a97d-3a1f6429791mr5829571f8f.1.1746889843894; Sat, 10 May 2025
 08:10:43 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <aBsSAKYrVPjj4tSa@linux.dev>
In-Reply-To: <aBsSAKYrVPjj4tSa@linux.dev>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Sat, 10 May 2025 17:10:31 +0200
X-Gm-Features: AX0GCFu_zV9DLgki4e7TIUuAajYpsko6TKJilQU7WBzDjLLovkGTjsKLw2ynZBA
Message-ID: <CABgObfY4AHK-LFzfaMM0ydHghwEKsfiegqJ9FdfcsPXFYCtwRw@mail.gmail.com>
Subject: Re: [GIT PULL] KVM/arm64 fixes for 6.15, round #3
To: Oliver Upton <oliver.upton@linux.dev>
Cc: Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, May 7, 2025 at 9:56=E2=80=AFAM Oliver Upton <oliver.upton@linux.dev=
> wrote:
>
> Hi Paolo,
>
> This is probably the last batch of fixes I have for 6.15. The bug in
> user_mem_abort() getting fixed is likely to bite some folks. On top of
> that, Marc snuck in another erratum fix for AmpereOne with more to come
> on that front...
>
> Please pull.
>
> The following changes since commit b4432656b36e5cc1d50a1f2dc15357543add53=
0e:
>
>   Linux 6.15-rc4 (2025-04-27 15:19:23 -0700)

Done, thanks.

Paolo

> are available in the Git repository at:
>
>   https://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git/ tags=
/kvmarm-fixes-6.15-3
>
> for you to fetch changes up to 3949e28786cd0afcd96a46ce6629245203f629e5:
>
>   KVM: arm64: Fix memory check in host_stage2_set_owner_locked() (2025-05=
-07 00:17:05 -0700)
>
> ----------------------------------------------------------------
> KVM/arm64 fixes for 6.15, round #3
>
>  - Avoid use of uninitialized memcache pointer in user_mem_abort()
>
>  - Always set HCR_EL2.xMO bits when running in VHE, allowing interrupts
>    to be taken while TGE=3D0 and fixing an ugly bug on AmpereOne that
>    occurs when taking an interrupt while clearing the xMO bits
>    (AC03_CPU_36)
>
>  - Prevent VMMs from hiding support for AArch64 at any EL virtualized by
>    KVM
>
>  - Save/restore the host value for HCRX_EL2 instead of restoring an
>    incorrect fixed value
>
>  - Make host_stage2_set_owner_locked() check that the entire requested
>    range is memory rather than just the first page
>
> ----------------------------------------------------------------
> Marc Zyngier (5):
>       KVM: arm64: Force HCR_EL2.xMO to 1 at all times in VHE mode
>       KVM: arm64: Prevent userspace from disabling AArch64 support at any=
 virtualisable EL
>       KVM: arm64: selftest: Don't try to disable AArch64 support
>       KVM: arm64: Properly save/restore HCRX_EL2
>       KVM: arm64: Kill HCRX_HOST_FLAGS
>
> Mostafa Saleh (1):
>       KVM: arm64: Fix memory check in host_stage2_set_owner_locked()
>
> Sebastian Ott (1):
>       KVM: arm64: Fix uninitialized memcache pointer in user_mem_abort()
>
>  arch/arm64/include/asm/el2_setup.h              |  2 +-
>  arch/arm64/include/asm/kvm_arm.h                |  3 +--
>  arch/arm64/kvm/hyp/include/hyp/switch.h         | 13 +++++----
>  arch/arm64/kvm/hyp/nvhe/mem_protect.c           |  2 +-
>  arch/arm64/kvm/hyp/vgic-v3-sr.c                 | 36 ++++++++++++++-----=
------
>  arch/arm64/kvm/mmu.c                            | 13 +++++----
>  arch/arm64/kvm/sys_regs.c                       |  6 +++++
>  tools/testing/selftests/kvm/arm64/set_id_regs.c |  8 +++---
>  8 files changed, 48 insertions(+), 35 deletions(-)
>


