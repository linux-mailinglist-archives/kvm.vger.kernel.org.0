Return-Path: <kvm+bounces-59202-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 4E16ABAE2EF
	for <lists+kvm@lfdr.de>; Tue, 30 Sep 2025 19:30:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CA3831927EA7
	for <lists+kvm@lfdr.de>; Tue, 30 Sep 2025 17:30:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 231CD30F7ED;
	Tue, 30 Sep 2025 17:28:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Sywz6PYJ"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9D7530CD88
	for <kvm@vger.kernel.org>; Tue, 30 Sep 2025 17:28:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759253333; cv=none; b=rbgSu/eZDwt4fYRz15eceTSxjYi+4efIxhlkOb3sOdwcBzeJh84RMO7Ym+Vjs3yEApam5PD0IUW+IWJggg6A8RAxw8oEA/BuW6epSmifkbOH9oyOmIUu6rUXDqRA4X/XQzbS0aFp4f38XJVlgrKWdlODEzjiCJ/sFoIvyBaUndk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759253333; c=relaxed/simple;
	bh=w+3JqlmYLBBaTPiRVhxtcMb1NY5LUZdawsa8jq03Mjo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=eUEKsm0jfsE/qa3j2Zeu2HEAKDSHVsxKkPKanVskuy3GY1JPpKqS3xzqI9mDshHM0x55ugyrujab2ausbiGphc+yBwR9BN+DKS/ASxDB7DKzoLuGqIIizXv72GPSRaLTMX5q5TMdlL7ssmuTS0KJF/7dCBIQoqL47lCWZOAhjto=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Sywz6PYJ; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1759253330;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Smit4RXry3tFgHAJJpMhFeA2qbWR/NaaUjNlw4h6iKw=;
	b=Sywz6PYJZFBq2qIl5SN7gYqNXh34fc2m1eEbKx3GAzN98lSrVZH8jkWurIsn9nbImwZyjd
	9tRXdfhcNNvGh3El7kfFXvbzrgy5GqqYTIgxiw3nvi5/EoW+mM9ilFwuwrua4EQUQB5IWG
	2fJbLhQ933y83qZQrjiHRbgtDvmn6Jo=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-369-x56KWhFANY2RvYh6QBlB0A-1; Tue, 30 Sep 2025 13:28:47 -0400
X-MC-Unique: x56KWhFANY2RvYh6QBlB0A-1
X-Mimecast-MFC-AGG-ID: x56KWhFANY2RvYh6QBlB0A_1759253325
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-3f384f10762so3944203f8f.3
        for <kvm@vger.kernel.org>; Tue, 30 Sep 2025 10:28:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759253325; x=1759858125;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Smit4RXry3tFgHAJJpMhFeA2qbWR/NaaUjNlw4h6iKw=;
        b=Rd/MxD9mOVxwIJgD10WTSqUiTFJl91MiamY5o7hZl8Rj7cO+XBORoL2ZxEkH9t2dWn
         LG/pA4JPFJNKgJcFjxi4pWq+ru7oGWNv8d5dED6GugwyY6LCe76q9yMOJCKVvXtbKt8w
         6GUpwProZkxmaIUWQ/XyLeRcWtAhNDEy1O6FOZsbBcf0d0aUUekDzEei3AqKmUEMcFN5
         lBpMwWc/vl2AM8wfPGrlE54ZlS6QOuJWLR+jCcnZf934nV056E07PHp/HhZXHWpXRrFH
         pASFTzkqQcTe3pqanEbs12pEtitIAy5Np09aiHHBPdDqK+dB8KBM1vTdR0K3XAuySEzJ
         ZfuQ==
X-Gm-Message-State: AOJu0YwHm1Pffm11VMFjX0ITws5Jw9OG5Yj7giM2ooPazkR2Fk7TQ8Ap
	fC9hKVw7QD6XzNsRg5e2mvX5rM2LVa2cXe5t3M4JWxs/JMzvY4EpIdHhToi9M1mdznaYGNDJ9BC
	Q4Pt326Sb6KUq9AWIiqpD62t2at/ru0d3uVF5ENJyU3orNvCANN0gzOGkfAECT6goJIK2LewM6k
	2LNWOj5SlsHetQpWTgAP1htMbT4Kml
X-Gm-Gg: ASbGncvbkrDPeeNd2G2Ij7y9eAX+Nxlc93JKxDVAUZFo2lxlBkc6qKRyOAMZBWbao/P
	RLkiZ5zh3WbX3/rQh0I/IbS1fq9OimmJyYiy5mICq8wU7CrIRH4h00gZOoKMz4bxgqikQsmXFCa
	xw1P29TVnkjtZkMX+gpTuEDXZiliDXH1Hr+hoaDjPJe6pI4yiepsOZxxoHsi2xQGuCnNAMqPDf6
	eR8vlg/2Yn0GPts2X6sYqaUtLQPV0u+
X-Received: by 2002:a05:6000:1ace:b0:411:f07a:67fb with SMTP id ffacd0b85a97d-4255781e1a0mr454524f8f.55.1759253325052;
        Tue, 30 Sep 2025 10:28:45 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGmJ227aXi221B0wP/BG4vCRwommHhr+79J7w8MzBC7UzOaOiz5JLAhCW5UrWSIpkXDSn6jxqy4zs5ZgKeHLRo=
X-Received: by 2002:a05:6000:1ace:b0:411:f07a:67fb with SMTP id
 ffacd0b85a97d-4255781e1a0mr454509f8f.55.1759253324648; Tue, 30 Sep 2025
 10:28:44 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250927060910.2933942-1-seanjc@google.com> <20250927060910.2933942-2-seanjc@google.com>
In-Reply-To: <20250927060910.2933942-2-seanjc@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Tue, 30 Sep 2025 19:28:31 +0200
X-Gm-Features: AS18NWBWhwEGLYreLcKc4mzuFPFEtfbSQww3AWhTkQ-epQgX-DO_hoIEQ2oh5nA
Message-ID: <CABgObfb_vRm+WgR_i_BNrhfs_nt46W=ZvFgjuwnn4P5fYfeQXg@mail.gmail.com>
Subject: Re: [GIT PULL] x86/kvm: Guest side changes for 6.18
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Sep 27, 2025 at 8:09=E2=80=AFAM Sean Christopherson <seanjc@google.=
com> wrote:
>
> A few smallish guest-side changes.
>
> The following changes since commit a6ad54137af92535cfe32e19e5f3bc1bb7dbd3=
83:
>
>   Merge branch 'guest-memfd-mmap' into HEAD (2025-08-27 04:41:35 -0400)
>
> are available in the Git repository at:
>
>   https://github.com/kvm-x86/linux.git tags/kvm-x86-guest-6.18
>
> for you to fetch changes up to 960550503965094b0babd7e8c83ec66c8a763b0b:
>
>   x86/kvm: Prefer native qspinlock for dedicated vCPUs irrespective of PV=
_UNHALT (2025-09-11 08:58:37 -0700)

Pulled, thanks.

Paolo

> ----------------------------------------------------------------
> x86/kvm guest side changes for 6.18
>
>  - For the legacy PCI hole (memory between TOLUD and 4GiB) to UC when
>    overriding guest MTRR for TDX/SNP to fix an issue where ACPI auto-mapp=
ing
>    could map devices as WB and prevent the device drivers from mapping th=
eir
>    devices with UC/UC-.
>
>  - Make kvm_async_pf_task_wake() a local static helper and remove its
>    export.
>
>  - Use native qspinlocks when running in a VM with dedicated vCPU=3D>pCPU
>    bindings even when PV_UNHALT is unsupported.
>
> ----------------------------------------------------------------
> Li RongQing (1):
>       x86/kvm: Prefer native qspinlock for dedicated vCPUs irrespective o=
f PV_UNHALT
>
> Sean Christopherson (2):
>       x86/kvm: Force legacy PCI hole to UC when overriding MTRRs for TDX/=
SNP
>       x86/kvm: Make kvm_async_pf_task_wake() a local static helper
>
>  arch/x86/include/asm/kvm_para.h |  2 --
>  arch/x86/kernel/kvm.c           | 44 ++++++++++++++++++++++++++++-------=
------
>  2 files changed, 30 insertions(+), 16 deletions(-)
>


