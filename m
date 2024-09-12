Return-Path: <kvm+bounces-26722-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4053D976B9C
	for <lists+kvm@lfdr.de>; Thu, 12 Sep 2024 16:09:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 029282862E0
	for <lists+kvm@lfdr.de>; Thu, 12 Sep 2024 14:09:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C146D1B12EF;
	Thu, 12 Sep 2024 14:09:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="B7m+Aq+V"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EB0519F43E
	for <kvm@vger.kernel.org>; Thu, 12 Sep 2024 14:09:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726150179; cv=none; b=QRPr/I3aE2gu2ImF5PPKp+YG0cGI/adOdcqRpPXmdliTzkmcy+Hm9EwCHwewe/j/n0gi8ivEL+lOLwFZksD6Zr6SVGAhbwgkXo2Z0KOYBKdnuNIQDpk3INiG6qNyDbsNu6i0EkN8O8Uq/uieWYZ7Reln7bMHTuioYmGbEACLca0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726150179; c=relaxed/simple;
	bh=LBWsfuA61ZgLh8l5H+nPmaCDGDpV3miRWF5Qsk8z0WM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ABNWPkFlHyMsfEaWN6BL5E0zFKk1PqQgXlcEcu5+yzb9DjVXY13iRJR2o9MIdCcmMLH4nVY7djnI8W4pO9Zs3cq7l5+q8dy9JB9lFXftXk0YRUEMI6ymtXrgKUgXosFplui71AQYZWMOrkBh1XVz3d7HFGGx4lheDD1HHpDE3jM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=B7m+Aq+V; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1726150176;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=B/noI6L46LpMySUAEmkZWrNHzOowp74DcO8neknTAA4=;
	b=B7m+Aq+V5fcb4v3o2mScCGQ/4rtE8y51M9IIT0JDTIPpcXps+iGBP1Txg4dZbJebKzGKHO
	UIihwHC4zGPw+1KVkqCSnULVfLO23H+JGlZ3ab/wygy4xsyxkQuQF/f+XRNI4vEhEmdMJw
	J5WCMlF6Qc0Ir4VrLUrCUcq+v/JYZcw=
Received: from mail-lf1-f70.google.com (mail-lf1-f70.google.com
 [209.85.167.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-458-m9ObX_jyP163LxKLEce0Fw-1; Thu, 12 Sep 2024 10:09:35 -0400
X-MC-Unique: m9ObX_jyP163LxKLEce0Fw-1
Received: by mail-lf1-f70.google.com with SMTP id 2adb3069b0e04-5365c0e2eafso842285e87.3
        for <kvm@vger.kernel.org>; Thu, 12 Sep 2024 07:09:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726150173; x=1726754973;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=B/noI6L46LpMySUAEmkZWrNHzOowp74DcO8neknTAA4=;
        b=EeEl8w6s9Wurmwg+swTO7QkQ/FoctaIVVWs40mfLn+FPu/K6Y1lQg1inhe5iWYVIDg
         4+lzgVmBt6Ls/+Pg/vPL7soD8FXnylLhqSSc8LJOthqEvucGfk+pb294+SkCITdZcPHY
         IyFTAWGy9gtcqV0OpGcKzE+92O8XO9A7rrXhFSrJqaNpZWi7igGYhhouHEgDL6N7y5cc
         /bmLc2fpMGJ98U04GAqSHkubhw82k8c5REmjMGFRkdUwleqR/O/RR8NEHNt30EoV1yYd
         hB4efW+Ew89DgmsInEdKPCUtmcWkZ0RTVRrZeDVjHZTXRqwCtgQrER5S+3MTBxkpwqro
         pn/w==
X-Forwarded-Encrypted: i=1; AJvYcCUcYq7W0w6lGx4ZmMlnwZaDRZVl3in0GP77CX6ItFJSf7LfteJL7QQ3Z1MHq56Iu20URuw=@vger.kernel.org
X-Gm-Message-State: AOJu0Yykcw6Jsq/2TTLCg3FvBvdyomKKaSZ7slIuv6Abjk/HQBgbYEab
	SHTEnqlsQDGDao5r6ujq8TY7l4QhOE+94IYmy2c9sEt4UyuNzGcsnTgkDhI8TkHoy818t1Lp6EK
	2yWGVRa2fIMdmqtZcvj2rTLh6GYjJjRv6O5Yy1oZsTLRwFiEiXXkvIROOiqetNW+c34LAba2gJJ
	bDsjUfM8EhPXRXR+edrUtp6yIg
X-Received: by 2002:a05:6512:398c:b0:535:63a9:9d8c with SMTP id 2adb3069b0e04-53678fba292mr1725783e87.17.1726150173370;
        Thu, 12 Sep 2024 07:09:33 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEvoyuxSck7Et6Xyrx9KV/p41KKDpZ4FwZ6ViBs3qjK4/W94E9cZZm7edQZrVbkHf45A1ngSmJQ5PU6Hx52O4Y=
X-Received: by 2002:a05:6512:398c:b0:535:63a9:9d8c with SMTP id
 2adb3069b0e04-53678fba292mr1725750e87.17.1726150172863; Thu, 12 Sep 2024
 07:09:32 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240812224820.34826-1-rick.p.edgecombe@intel.com>
 <20240812224820.34826-26-rick.p.edgecombe@intel.com> <05cf3e20-6508-48c3-9e4c-9f2a2a719012@redhat.com>
 <cd236026-0bc9-424c-8d49-6bdc9daf5743@intel.com>
In-Reply-To: <cd236026-0bc9-424c-8d49-6bdc9daf5743@intel.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Thu, 12 Sep 2024 16:09:21 +0200
Message-ID: <CABgObfbyd-a_bD-3fKmF3jVgrTiCDa3SHmrmugRji8BB-vs5GA@mail.gmail.com>
Subject: Re: [PATCH 25/25] KVM: x86: Add CPUID bits missing from KVM_GET_SUPPORTED_CPUID
To: Xiaoyao Li <xiaoyao.li@intel.com>
Cc: Rick Edgecombe <rick.p.edgecombe@intel.com>, seanjc@google.com, kvm@vger.kernel.org, 
	kai.huang@intel.com, isaku.yamahata@gmail.com, tony.lindgren@linux.intel.com, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 12, 2024 at 9:48=E2=80=AFAM Xiaoyao Li <xiaoyao.li@intel.com> w=
rote:
> On 9/11/2024 1:52 AM, Paolo Bonzini wrote:
> > On 8/13/24 00:48, Rick Edgecombe wrote:
> >> For KVM_TDX_CAPABILITIES, there was also the problem of bits that are
> >> actually supported by KVM, but missing from get_supported_cpuid() for =
one
> >> reason or another. These include X86_FEATURE_MWAIT, X86_FEATURE_HT and
> >> X86_FEATURE_TSC_DEADLINE_TIMER. This is currently worked around in
> >> QEMU by
> >> adjusting which features are expected.
>
> I'm not sure what issue/problem can be worked around in QEMU.
> QEMU doesn't expect these bit are reported by KVM as supported for TDX.
> QEMU just accepts the result reported by KVM.

QEMU already adds some extra bits, for example:

        ret |=3D CPUID_EXT_HYPERVISOR;
        if (kvm_irqchip_in_kernel() &&
                kvm_check_extension(s, KVM_CAP_TSC_DEADLINE_TIMER)) {
            ret |=3D CPUID_EXT_TSC_DEADLINE_TIMER;
        }

> The problem is, TDX module and the hardware allow these bits be
> configured for TD guest, but KVM doesn't allow. It leads to users cannot
> create a TD with these bits on.

KVM is not going to have any checks, it's only going to pass the
CPUID to the TDX module and return an error if the check fails
in the TDX module.

KVM can have a TDX-specific version of KVM_GET_SUPPORTED_CPUID, so
that we can keep a variant of the "get supported bits and pass them
to KVM_SET_CPUID2" logic, but that's it.

> > This is the kind of API that we need to present for TDX, even if the
> > details on how to get the supported CPUID are different.  Not because
> > it's a great API, but rather because it's a known API.
>
> However there are differences for TDX. For legacy VMs, the result of
> KVM_GET_SUPPORTED_CPUID isn't used to filter the input of KVM_SET_CPUID2.
> But for TDX, it needs to filter the input of KVM_TDX_VM_INIT.CPUID[]
> because TDX module only allows the bits that are reported as
> configurable to be set to 1.

Yes, that's userspace's responsibility.

> With current designed API, QEMU can only know which bits are
> configurable before KVM_TDX_VM_INIT, i.e., which bits can be set to 1 or
> 0 freely.

The API needs userspace to have full knowledge of the
requirements of the TDX module, if it wants to change the
defaults provided by KVM.

This is the same as for non-TDX VMs (including SNP).  The only
difference is that TDX and SNP fails, while non-confidential VMs
get slightly garbage CPUID.

> For other bits not reported as configurable, QEMU can know the exact
> value of them via KVM_TDX_GET_CPUID, after KVM_TDX_VM_INIT and before
> TD's running. With it, QEMU can validate the return value is matched
> with what QEMU wants to set that determined by users input. If not
> matched, QEMU can provide some warnings like what for legacy VMs:
>
>    - TDX doesn't support requested feature: CPUID.01H.ECX.tsc-deadline
> [bit 24]
>    - TDX forcibly sets features: CPUID.01H:ECX.hypervisor [bit 31]
>
> If there are ioctls to report the fixed0 bits and fixed1 bits for TDX,
> QEMU can validate the user's configuration earlier.

Yes, that's fine.

Paolo


