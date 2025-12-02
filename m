Return-Path: <kvm+bounces-65161-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 47851C9C68E
	for <lists+kvm@lfdr.de>; Tue, 02 Dec 2025 18:35:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8BA633A5B3E
	for <lists+kvm@lfdr.de>; Tue,  2 Dec 2025 17:35:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 006FB2C15BA;
	Tue,  2 Dec 2025 17:35:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hkerblN/";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="k9m46LfK"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98F5E2BF3CA
	for <kvm@vger.kernel.org>; Tue,  2 Dec 2025 17:35:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764696902; cv=none; b=OCSmUnbJWnEwJIV3g8OroAl6c9C1NTRj0rw5odCPIiIOkkmJusBzywnxw8q//jusHzJY2oB5eCD6sKQZCpFDCvQEWUMh94xVDV7l/lICi0UKzpaQg2N+Kn/t9up+SENXwIu4M+52reSBJBNSXRH0usu3SjVLfdxu9EYxSSkE1vc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764696902; c=relaxed/simple;
	bh=nC6UNMpAbeJikqHkCNZ3XU3AGBNNIuEaIvJO+uh8gGY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ao01WnTQfCaFdXvBV2ts739Y3JOLmgh066vAaKPGSXtMdNJ6oeM3RJAZM+Y3XnYGOPa0kdRaHbQIPdOeLIRH3qiaEc4jmbAa8HcXjbOyI7SRJraeHmP1H65Pbz1ATpL+9Her9JgXeRHdBF3VxGNFl3fXcrrMYWX0DIPkNYRgGzA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=hkerblN/; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=k9m46LfK; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764696899;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=W1q6VCvh0fvJAUYdl0dEiYHPLaemZQ8x5yGo7cBIMHE=;
	b=hkerblN/F3hMbqxkCarHQ4YCUJ2tY4UXyx+AqlwcRZkikJ9RPEH+2+PRCo6hXumt2oSvWR
	4Qx4uTGujzPTkwPJQpZwLltSHG5kQ4UrSEVvELDl9D8GURrcJKUFh31thlZxlZLx+h1FFO
	V/kHK1V/LJe63vMxweqJTddN1DUi1Ws=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-543-_sFRtY0vOfSDUT3SCMVD-Q-1; Tue, 02 Dec 2025 12:34:56 -0500
X-MC-Unique: _sFRtY0vOfSDUT3SCMVD-Q-1
X-Mimecast-MFC-AGG-ID: _sFRtY0vOfSDUT3SCMVD-Q_1764696895
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-4779b3749a8so50383815e9.1
        for <kvm@vger.kernel.org>; Tue, 02 Dec 2025 09:34:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1764696895; x=1765301695; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=W1q6VCvh0fvJAUYdl0dEiYHPLaemZQ8x5yGo7cBIMHE=;
        b=k9m46LfKXrUYvqdlumxM+zBvHWDZrwgrlOPbHivFiBcJjv/FK3B5ZmZr6dudefcSpX
         1oQWcOomG8/6m3JvNR+bM2zmYZMNlIeEdmmSshiGkU8m3VrB63ulRbXcfp9MhKQckKgB
         LReG91fBhZwoe4HfX+SGbeUDVflroFEKGJPVMjKfsu7C89n1fDGSWHvC2LFJIMrRuEuL
         0giz5HC+Ibidi0xtUye0w5GqPkQCpFjOLlr/U0CPJFc08Tt6nokv9J+iTRUpsUKKPmMY
         md3ZyZLAz/3bM5oh+ymY+ysv70UB044cUGtjx3ew5PleXbWEOVQtoktaU3Z62Zjn377c
         W4gA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764696895; x=1765301695;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=W1q6VCvh0fvJAUYdl0dEiYHPLaemZQ8x5yGo7cBIMHE=;
        b=i68RrxUCqiJdDZmFZLjJuq1AN61LIQPtEyVNqpa4oL54wgPEG5/hpVFA3OFzD8cS6H
         GwoFfENzLTvl0uZj1u9uG/PAbWoBAI536gL8eSbjD8c7tD8Nwp8QZl1pB4eV0u7f+XZ3
         koujUkxHb9OAkwOdsfv/cOe1/bA2iUjZweS0r7wQH0WQw7hvSBk4mg+q/vCLsKaeLUzL
         9AV0jY1zkwwznjP8DXz1woRm6L2tfL9dQ5aiQrSYRozEUXlssAMm080H+G+MxqKE7LmA
         pdrYiBTRFYzFu5eIV7bVH5ddpTLaGTl3ijJ6qQLdWAhow2ZjhjF1aEFnsXb+8sxKB1hO
         U+Ow==
X-Forwarded-Encrypted: i=1; AJvYcCWGwQ+ZL5uLUSTrx+Futobb/FDFGRFTdNHIsE//9+q7pOqSbl5U9qCQkip2f/29hoauats=@vger.kernel.org
X-Gm-Message-State: AOJu0YwNEt7ySzaDQajos8nNdaYPQaEV/KhezNQHkEN8U0ohJ0Gg1Y2q
	nmtJTNTWZx4ZD0NTe/B57MUOhodtVKQMbZ1NbHbOejRRZvletVnp/FaBfdS2I673VEQiaQV9LTc
	yorsjBG02HAsdVca6eSBS3QhnpRLIHvA/UkNGAIqZch+ShZW4R/apjRBRkcZAUmwbYa22Vug+v0
	lt6MW3oDcdHBRzlsUB9HT5Th2GI8RP
X-Gm-Gg: ASbGncuiy9ru165RtKjWTxx6noZLq26zAevF8YM8c7kSgsIUzJwCgk7pPqDN2+ekLdE
	BTru28oR1TQD8JKRXfjPOTo9bw7Zvq87buaXzlqjvHtdTBI52BdYwXJN2Y6uGf8/kDlHXi9ptbB
	g4OvSNgCyr0AGa9+17PQShZl+hQ7VvMStPHezold435534sF0lXgxw5v56Er+tq9vUmTyop6l7v
	IGrFpQyTCeypKlKf638jS/FI+uSdyVhW04wIp4Xx69y4wg6k6NfhSJybe3xrVNHN9edwHc=
X-Received: by 2002:a05:6000:2f81:b0:429:bc68:6c95 with SMTP id ffacd0b85a97d-42cc1d520camr50812842f8f.47.1764696895012;
        Tue, 02 Dec 2025 09:34:55 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGEjjM/4gYFdGngCSraq+eLKLFPw2/LoE8KfxUt7snwDvBtfylPl35Ufw8QDh8qpyVhfKf6YbZVKCmrLOrGVC0=
X-Received: by 2002:a05:6000:2f81:b0:429:bc68:6c95 with SMTP id
 ffacd0b85a97d-42cc1d520camr50812822f8f.47.1764696894629; Tue, 02 Dec 2025
 09:34:54 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251128094343.621879-1-chenhuacai@loongson.cn>
In-Reply-To: <20251128094343.621879-1-chenhuacai@loongson.cn>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Tue, 2 Dec 2025 18:34:42 +0100
X-Gm-Features: AWmQ_bkULiasT2nd5uRjNuhm9bdkFlT0rSKN-y6aCluXuFX2bH2jC9z-APxyjjs
Message-ID: <CABgObfZoLisM_+8gkO3rh6aCKEXsOzDLowU-_HQZVDHNpeA00Q@mail.gmail.com>
Subject: Re: [GIT PULL] LoongArch KVM changes for v6.19
To: Huacai Chen <chenhuacai@loongson.cn>
Cc: Huacai Chen <chenhuacai@kernel.org>, Tianrui Zhao <zhaotianrui@loongson.cn>, 
	Bibo Mao <maobibo@loongson.cn>, kvm@vger.kernel.org, loongarch@lists.linux.dev, 
	linux-kernel@vger.kernel.org, Xuerui Wang <kernel@xen0n.name>, 
	Jiaxun Yang <jiaxun.yang@flygoat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 28, 2025 at 10:44=E2=80=AFAM Huacai Chen <chenhuacai@loongson.c=
n> wrote:
>
> The following changes since commit ac3fd01e4c1efce8f2c054cdeb2ddd2fc0fb15=
0d:
>
>   Linux 6.18-rc7 (2025-11-23 14:53:16 -0800)
>
> are available in the Git repository at:
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/chenhuacai/linux-loongson=
.git tags/loongarch-kvm-6.19
>
> for you to fetch changes up to 0f90fa6e2e9d98349492d9968c11ceaf2f958c98:
>
>   KVM: LoongArch: selftests: Add time counter test case (2025-11-28 14:49=
:48 +0800)

Pulled, thanks.

Paolo

> ----------------------------------------------------------------
> LoongArch KVM changes for v6.19
>
> 1. Get VM PMU capability from HW GCFG register.
> 2. Add AVEC basic support.
> 3. Use 64-bit register definition for EIOINTC.
> 4. Add KVM timer test cases for tools/selftests.
>
> ----------------------------------------------------------------
> Bibo Mao (8):
>       LoongArch: KVM: Get VM PMU capability from HW GCFG register
>       LoongArch: KVM: Use 64-bit register definition for EIOINTC
>       KVM: LoongArch: selftests: Add system registers save/restore on exc=
eption
>       KVM: LoongArch: selftests: Add basic interfaces
>       KVM: LoongArch: selftests: Add exception handler register interface
>       KVM: LoongArch: selftests: Add timer interrupt test case
>       KVM: LoongArch: selftests: Add SW emulated timer test case
>       KVM: LoongArch: selftests: Add time counter test case
>
> Song Gao (1):
>       LoongArch: KVM: Add AVEC basic support
>
>  arch/loongarch/include/asm/kvm_eiointc.h           |  55 +-----
>  arch/loongarch/include/asm/kvm_host.h              |   8 +
>  arch/loongarch/include/asm/kvm_vcpu.h              |   1 +
>  arch/loongarch/include/asm/loongarch.h             |   2 +
>  arch/loongarch/include/uapi/asm/kvm.h              |   1 +
>  arch/loongarch/kvm/intc/eiointc.c                  |  80 ++++-----
>  arch/loongarch/kvm/interrupt.c                     |  15 +-
>  arch/loongarch/kvm/vcpu.c                          |  19 +-
>  arch/loongarch/kvm/vm.c                            |  40 +++--
>  tools/testing/selftests/kvm/Makefile.kvm           |   1 +
>  .../selftests/kvm/include/loongarch/arch_timer.h   |  85 +++++++++
>  .../selftests/kvm/include/loongarch/processor.h    |  81 ++++++++-
>  .../selftests/kvm/lib/loongarch/exception.S        |   6 +
>  .../selftests/kvm/lib/loongarch/processor.c        |  47 ++++-
>  tools/testing/selftests/kvm/loongarch/arch_timer.c | 200 +++++++++++++++=
++++++
>  15 files changed, 534 insertions(+), 107 deletions(-)
>  create mode 100644 tools/testing/selftests/kvm/include/loongarch/arch_ti=
mer.h
>  create mode 100644 tools/testing/selftests/kvm/loongarch/arch_timer.c
>


