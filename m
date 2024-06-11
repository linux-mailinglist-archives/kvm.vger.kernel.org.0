Return-Path: <kvm+bounces-19292-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 54EC9902F31
	for <lists+kvm@lfdr.de>; Tue, 11 Jun 2024 05:47:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D37011F22E31
	for <lists+kvm@lfdr.de>; Tue, 11 Jun 2024 03:47:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 58BF016F915;
	Tue, 11 Jun 2024 03:47:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="PnVtCIp4"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1285264B
	for <kvm@vger.kernel.org>; Tue, 11 Jun 2024 03:47:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718077660; cv=none; b=irXFJ2R/PGc7fRHvsXKKIosApWG/3GrwxBAFR4CRGxN6tJKEwgRu7bVJ29zaVH7vmrDYutE4FvTDH/HtTXP8QE5j3V4A4CkE3Qqoy6BEge1/aIoW0cpnzCu/+HSyX54BcEz9Q0izcaLwYn3CxmUJzIbNdJ/RUTbznv+WSlQbjk0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718077660; c=relaxed/simple;
	bh=ImC9OdLsLq5zNZ6vdjGWmQM6DDhoKVkf/yl46Ae7Og8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=TdgS0WnJ+bfhGioqXSa2SYp1PPdr36E1dCiII5nurjpNkwIWH9Jf0lVogzN/xrX+/VIej7uBRMdJqdN5iu/WH5OjdvMoWn5zU1QKRpaoUP/P6bH06X/x5YfWEMW3D2+sOMtnBxupioDUzo78hmac7LfIzqIZSfPDucX8Ud3QjUk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=PnVtCIp4; arc=none smtp.client-ip=209.85.208.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-57c8bd6b655so10642a12.0
        for <kvm@vger.kernel.org>; Mon, 10 Jun 2024 20:47:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1718077657; x=1718682457; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Gl/RVYtUWAmdJmYhx3bWwluPkKF6eTc3z6iPlXxf8LE=;
        b=PnVtCIp4on/k1VCDLATSzAf8Pi1yHfxD3sgK9nJ9Ttt9I+hGWN0u+OR5GhpcngKuBM
         mbVjoo182IPxj3/AFLt/C44x5XKeC+IjZlJQYfameC9AsKT2codr2GAfEgjfpCqPUgXp
         a1KnuUPXypcs8eVV9gQhEI/IRZjI2TAPMDlFs/lFFcBi1rgDdhUBmHPDMieV/S+z/oun
         G8gwUFvGK1F44WnplhT2I4yZ9O9/gb9oE4epK9amAW/KPCeo1H9m+DREZqxFBCWuFHIi
         lUQbMmnyLlJ8pZqOl95jKomVshiTRFbHzdDtdxoxkRH00CSlhhtHEL0Tpni1S/XWEcWq
         gAww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718077657; x=1718682457;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Gl/RVYtUWAmdJmYhx3bWwluPkKF6eTc3z6iPlXxf8LE=;
        b=PJJlTMRVRf+KHW3dzi2bU7dYxJz86YDKpUkSFClO8vNPCmoKzwle9phL7duzh5JR6B
         +j9l3AlQyARoOCwTPMXfDtzOOflTsNqL1LeWuuB3PuqA698jSuH4kY5yCiJIl319pTuK
         yUt4XnuzXUggLbMpvc0BTbLGLgO/eesKFCGTL0U9oQECn2BlsgWvVorFNAHPhbBR3CGA
         IvArIi6Qw0enj+u0kq0HWzwPxDslA7S+eHRAsRqKBO3w+r88iy0NnOCCLBkeTHtP8DjS
         8LTFYCpCBnxZmBtkOaslUM6r42tPcl0A8XCqiRgIQRihrKK8zZFddGkJhnbOAHidJyyf
         HuZQ==
X-Forwarded-Encrypted: i=1; AJvYcCUFkAsIDGtDSHdPNMiOvp4MLtcR1wdIBUDzTDLMrkXoZi2GvU1ASv2cwi177KCablkuIAKOrJ0epIeBbJPMyU3VI8Wr
X-Gm-Message-State: AOJu0YyOtqYnv0I7nzuWHRS63P+QYbFxXTIAKPoL4AkHUBalJDTUVNBB
	l4Pza4S7uQBV/g1FtPB7rLlL88QZtZ2B7QRRCzvKcbw38SCfRRasFZybhclGiJK8qT70BNW/wOl
	WZ3ram+HS2HEIM7ZXaMw576ZX31FOWq8+xP1h
X-Google-Smtp-Source: AGHT+IHrnelPx4R7r3XsfzngPJ9pvyQM/0CUQ9e4Z0bbrPV0pjxrPvjnITInnIVugp2O/RUIuuEIazoy4vH18TduMQY=
X-Received: by 2002:a05:6402:b74:b0:572:988f:2f38 with SMTP id
 4fb4d7f45d1cf-57c92510457mr152515a12.6.1718077657109; Mon, 10 Jun 2024
 20:47:37 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240611014845.82795-1-seanjc@google.com>
In-Reply-To: <20240611014845.82795-1-seanjc@google.com>
From: Jim Mattson <jmattson@google.com>
Date: Mon, 10 Jun 2024 20:47:21 -0700
Message-ID: <CALMp9eQBd1yFA+w8X4EK1M+Dmh_MaEG=7POd-pexgA-wHWJBSQ@mail.gmail.com>
Subject: Re: [PATCH] KVM: x86: Always sync PIR to IRR prior to scanning I/O
 APIC routes
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Adamos Ttofari <attofari@amazon.de>, Raghavendra Rao Ananta <rananta@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 10, 2024 at 6:48=E2=80=AFPM Sean Christopherson <seanjc@google.=
com> wrote:
>
> Sync pending posted interrupts to the IRR prior to re-scanning I/O APIC
> routes, irrespective of whether the I/O APIC is emulated by userspace or
> by KVM.  If a level-triggered interrupt routed through the I/O APIC is
> pending or in-service for a vCPU, KVM needs to intercept EOIs on said
> vCPU even if the vCPU isn't the destination for the new routing, e.g. if
> servicing an interrupt using the old routing races with I/O APIC
> reconfiguration.
>
> Commit fceb3a36c29a ("KVM: x86: ioapic: Fix level-triggered EOI and
> userspace I/OAPIC reconfigure race") fixed the common cases, but
> kvm_apic_pending_eoi() only checks if an interrupt is in the local
> APIC's IRR or ISR, i.e. misses the uncommon case where an interrupt is
> pending in the PIR.
>
> Failure to intercept EOI can manifest as guest hangs with Windows 11 if
> the guest uses the RTC as its timekeeping source, e.g. if the VMM doesn't
> expose a more modern form of time to the guest.
>
> Cc: stable@vger.kernel.org
> Cc: Adamos Ttofari <attofari@amazon.de>
> Cc: Raghavendra Rao Ananta <rananta@google.com>
> Cc: Jim Mattson <jmattson@google.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Jim Mattson <jmattson@google.com>

