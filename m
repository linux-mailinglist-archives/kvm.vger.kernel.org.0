Return-Path: <kvm+bounces-59199-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id AF547BAE25A
	for <lists+kvm@lfdr.de>; Tue, 30 Sep 2025 19:17:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3A5DB194254F
	for <lists+kvm@lfdr.de>; Tue, 30 Sep 2025 17:17:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8DB1830C34D;
	Tue, 30 Sep 2025 17:17:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="e6DgW7MV"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BF2A8287E
	for <kvm@vger.kernel.org>; Tue, 30 Sep 2025 17:17:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759252639; cv=none; b=IPgFp1FQonkDeBSQbZf94zYWEt3BmUpzafqMfJ6PU/+3EK1dYAtP5VrgEAwIeo/Pk44QmvAbEDTmNsO9HqaTyV6/Ku1L+WAiqdj+iqPSj3/JHb3M+Ctktw/7DN9HQs+/0e+k2ZJff9L1ba75NooaK+waBhaJUDH6TBFkGtSieuI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759252639; c=relaxed/simple;
	bh=2TA85JhG88MKTbU/gfG3nGwNs6z1JUIysIQJJDXAdOY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Qhfdn2hSt/y0Xh1OQ3RW/ltEMek2THi+LImwxnHwwZDS48lFGak1O+vyENJkoVqeBnya18BAammO+7/Hi0CslVfugpa6rSX6sGTdhZBkjaZn9wsJhGmymOL8TtxPjS5JjkVtC4XEbg1xE6P4ShA0gNDy4L2iEMerN1Zk/abgX88=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=e6DgW7MV; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1759252636;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2C3tUWszDTmoiAk0dwZyFPIXw5qdDN0uqN1IQdkVOiw=;
	b=e6DgW7MV7jJBPj2LHIW3Qp25J0+QwAsy4nUMv4CyVXZ4HY989omhkl/cR12unA7TfnaQYB
	RNFaUpQ59inGi+4trQW7Yf9+cM8tJRezqIhXgYeghDav6bTJUX7jeuROSaPbEjjNWABr8R
	9PsOvry+JnCwh/7VEfXt3HrQ2mQq1m8=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-306-dY9yWDIlPLu7gcxRqsVaaQ-1; Tue, 30 Sep 2025 13:17:14 -0400
X-MC-Unique: dY9yWDIlPLu7gcxRqsVaaQ-1
X-Mimecast-MFC-AGG-ID: dY9yWDIlPLu7gcxRqsVaaQ_1759252633
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-3ee1317b132so4662263f8f.0
        for <kvm@vger.kernel.org>; Tue, 30 Sep 2025 10:17:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759252632; x=1759857432;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2C3tUWszDTmoiAk0dwZyFPIXw5qdDN0uqN1IQdkVOiw=;
        b=aniFfdxrF/+GJGvQLtsKMXEiIy7ynJA+GelJ1DZ+W0lnii9+XQkPdRw2CflFgO8nm1
         cO2gzQBT+nn+wO0C/Z0OMEMbhyap5/KWnjJOs2BgDGT21uH6pQa7neAltyjGobEhh56n
         r8xboTmBfWuVb28ycPtbQfblU3Mt4AHA+oPse/3U99+45GFGf6n/x5FhIFx3GbJdhqXA
         mcuC8qHLsJuyq0Kp0QA2K0iLY/07eVCtdLitQCcflSAJH4EO8Wze8uEREtHDt4gZlMEs
         36nCAiApq/W+h/h6wZuFv5NogJJ4rGzgnSjS10YVQ1sBe1BFvUKL6ThV1RbnKjfx0fXT
         PLAQ==
X-Forwarded-Encrypted: i=1; AJvYcCViviGwDQNq6H9jkSZuE+C9ZvEDbfhYCeSnNyE/z2dvvIXNUvAEz7qN6rnWFQ2mGU2pgQc=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxy0Vb+IcdFTCg4JNGamlPz9oMSYRCOn+Ca63iAqmal0nhg3lj1
	zZpKWbK/EssvdJNjHHXBz7FddTGX2NStgg5a78blORSj7P4/xvSmRshBSU9NxqNpfkrNUwlHFVa
	EMq0IFSfvBgPa01DWH8AFP+MGLpXFtcAybW3KzkvilgiH1VrDbufmO/WzjIw2sJVDwmIn9ttAEm
	m2nNCV4rGRSbjt3nRG64yNNSbRio4oJXH/PTuq
X-Gm-Gg: ASbGncs+z1bTdlcmHmu2fWN/ZOHUMCBVn/9X+mjqcoJUVLY3Sv2i1nqlb8WvVUuz1yG
	lxuDoclF0Ylbb+7AGEPJlTumj4vnZTcsnNa3X+oexNnfcV3YK3kRVu7dEPrRXJuAuBuEJcj8qt3
	AlPdn4VtlASejb4mE1pR1WuWM3SeTinp0dbh5t8Tn7vL5N1CQd6yeBV/BQfKoNFeEoaPwOWgEZ1
	qAsv2TyBHp35b2qcApLUD16ia3IEdAj
X-Received: by 2002:a05:6000:3103:b0:3ec:7583:3b76 with SMTP id ffacd0b85a97d-425577f3212mr441485f8f.22.1759252632222;
        Tue, 30 Sep 2025 10:17:12 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGlWCVGpeAZLUKs0K+oxbN18oiVm08xlLaObPt5b2kGu4QXgX8tqNJMKW9uG4wk/tLSn8ve7rDKzfDZGh7oUUo=
X-Received: by 2002:a05:6000:3103:b0:3ec:7583:3b76 with SMTP id
 ffacd0b85a97d-425577f3212mr441456f8f.22.1759252631740; Tue, 30 Sep 2025
 10:17:11 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250924081305.3068787-1-chenhuacai@loongson.cn>
In-Reply-To: <20250924081305.3068787-1-chenhuacai@loongson.cn>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Tue, 30 Sep 2025 19:16:59 +0200
X-Gm-Features: AS18NWCIAUHM6q-f3EVvW3Rf6Uwq0MmF38t06GUExmaXllterNGLylxJXrEqQ8Y
Message-ID: <CABgObfZvdkAR6YGx7HKT+aVaE06w=FG7Jus=3B6nxadDiv5c_Q@mail.gmail.com>
Subject: Re: [GIT PULL] LoongArch KVM changes for v6.18
To: Huacai Chen <chenhuacai@loongson.cn>
Cc: Huacai Chen <chenhuacai@kernel.org>, Tianrui Zhao <zhaotianrui@loongson.cn>, 
	Bibo Mao <maobibo@loongson.cn>, kvm@vger.kernel.org, loongarch@lists.linux.dev, 
	linux-kernel@vger.kernel.org, Xuerui Wang <kernel@xen0n.name>, 
	Jiaxun Yang <jiaxun.yang@flygoat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 24, 2025 at 10:15=E2=80=AFAM Huacai Chen <chenhuacai@loongson.c=
n> wrote:
>
> The following changes since commit 07e27ad16399afcd693be20211b0dfae63e061=
5f:
>
>   Linux 6.17-rc7 (2025-09-21 15:08:52 -0700)
>
> are available in the Git repository at:
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/chenhuacai/linux-loongson=
.git tags/loongarch-kvm-6.18
>
> for you to fetch changes up to 66e2d96b1c5875122bfb94239989d832ccf51477:
>
>   LoongArch: KVM: Move kvm_iocsr tracepoint out of generic code (2025-09-=
23 23:37:26 +0800)

Pulled, thanks.

Paolo

> ----------------------------------------------------------------
> LoongArch KVM changes for v6.18
>
> 1. Add PTW feature detection on new hardware.
> 2. Add sign extension with kernel MMIO/IOCSR emulation.
> 3. Improve in-kernel IPI emulation.
> 4. Improve in-kernel PCH-PIC emulation.
> 5. Move kvm_iocsr tracepoint out of generic code.
>
> ----------------------------------------------------------------
> Bibo Mao (9):
>       LoongArch: KVM: Add PTW feature detection on new hardware
>       LoongArch: KVM: Add sign extension with kernel MMIO read emulation
>       LoongArch: KVM: Add sign extension with kernel IOCSR read emulation
>       LoongArch: KVM: Add implementation with IOCSR_IPI_SET
>       LoongArch: KVM: Access mailbox directly in mail_send()
>       LoongArch: KVM: Set version information at initial stage
>       LoongArch: KVM: Add IRR and ISR register read emulation
>       LoongArch: KVM: Add different length support in loongarch_pch_pic_r=
ead()
>       LoongArch: KVM: Add different length support in loongarch_pch_pic_w=
rite()
>
> Steven Rostedt (1):
>       LoongArch: KVM: Move kvm_iocsr tracepoint out of generic code
>
> Yury Norov (NVIDIA) (1):
>       LoongArch: KVM: Rework pch_pic_update_batch_irqs()
>
>  arch/loongarch/include/asm/kvm_pch_pic.h |  15 +-
>  arch/loongarch/include/uapi/asm/kvm.h    |   1 +
>  arch/loongarch/kvm/exit.c                |  19 +--
>  arch/loongarch/kvm/intc/ipi.c            |  80 ++++++-----
>  arch/loongarch/kvm/intc/pch_pic.c        | 239 +++++++++++++------------=
------
>  arch/loongarch/kvm/trace.h               |  35 +++++
>  arch/loongarch/kvm/vcpu.c                |   2 +
>  arch/loongarch/kvm/vm.c                  |   4 +
>  include/trace/events/kvm.h               |  35 -----
>  9 files changed, 211 insertions(+), 219 deletions(-)
>


