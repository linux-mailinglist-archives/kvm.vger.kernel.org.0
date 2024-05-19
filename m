Return-Path: <kvm+bounces-17738-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id ECFD78C9378
	for <lists+kvm@lfdr.de>; Sun, 19 May 2024 07:18:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DD29B1C2094E
	for <lists+kvm@lfdr.de>; Sun, 19 May 2024 05:18:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 14732DF49;
	Sun, 19 May 2024 05:18:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LR2+RVEi"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9F7133D5
	for <kvm@vger.kernel.org>; Sun, 19 May 2024 05:18:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716095886; cv=none; b=atwxbghP9VFTYyJMFmrnj7yHE2bDvyVAnF8+oiZ12AdmEdi8t1HxvqXGuDQE8Wiyzv5iA38oPXzaT+XhQxMa7Yq4+PNwJQNJHCCGdL2f1F26fogph90V8uod1k0rSnI6OjVWq2c+et3VHa74dZAYbWxY1DDHAjur+bNQ4pqHDHs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716095886; c=relaxed/simple;
	bh=VLBAgYvNs58uk0c+nMzWu7qkgoLamMOfEMxv1hOARwE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=VUQEOXYoTE6NVScu3/gpHGZaInwgpXi2CvrtfLSQUL0J9MmAy0wz4UnAYdGHyxijlbBegVdZDPvGhnsdLAWC6F0ocnZcvN0r3wAIi+FwRwpq8XS+BWd2Drk6uHATp0dtavNQA+kILNymlJEIUv9bKBtZZOPKE+EPdyQxiifrpl8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LR2+RVEi; arc=none smtp.client-ip=209.85.208.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-5751237a79bso3315419a12.2
        for <kvm@vger.kernel.org>; Sat, 18 May 2024 22:18:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1716095883; x=1716700683; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gKVSyAXhnUuNs1u2dFlyKe7k81jXi9Bidkc1Kxc4ySU=;
        b=LR2+RVEiwFZJENWsk+BjjOxmo6moyZWipNGPCMPiDuWxKaoQOUQxVgwRLqV3p1OPTx
         voku5pqyujSGgZic6TuEVXGEKyo7rcjhXQQJCMINzQyMnyA9BvX1Q3MGepeX+zE3PEmJ
         HwDYc6k7L6jBGbjAz5+hnVPxYyjJ4yn6/09Rpq0CpJ6Vh8DgQkuAUoKrc+8fyxFha2nv
         fHRxp7Jwc3ShOtd3VuOcCpfOHzFpdtucjnJN8cCLUhfEp7EqSh1Mt94sCoNlIg1ygVid
         sRrUWGIJYRs0UlqJiG3Ggq1ZHXGPKBPjDVxqDaU8hrXMy0R/nC0mGuI2QOIbOPqKDOKU
         wRVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716095883; x=1716700683;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gKVSyAXhnUuNs1u2dFlyKe7k81jXi9Bidkc1Kxc4ySU=;
        b=GGxPhNymm8XkA/8Lch2pEQWKSizBv5bTII+e/P7wp1qCiByrcKefwRPclNlQ/esXjD
         3GiDzifK6FRutEi8nsFdqDb3yPUkwrcg+6OeJPL2Y1koANAvIfzoi2RvU8EycH5J/UHD
         p27iAVIjjpl4rk+EvnwoxZzA+s8xLap3MpFt87qTSikV16hiFrs2fx1FRwgAXRNqVg+H
         DrM1ByTjpz2ioIWh8InVkqv3ITooEfyZRSJEz5XFXuuu4ta131SLcXktzVlDSDA0nE/6
         2ZmuobRBLqvZ0c6JpVfP8xmc8TeMuGTf+I5ChUYdkJ5PhaW8xtOqEDcVLLsEdv4u8Y3x
         oYVw==
X-Forwarded-Encrypted: i=1; AJvYcCVgngTANBlAnH17OLfEZw5jYSBLHPB4n5gOrEguQ90nb54Nk0vAOVgi5f7SumuljZwQ8jov7gt56LUFFr9dht+6xhHR
X-Gm-Message-State: AOJu0YxwkI+rmEMmqFHI/6D8a+ueY89f1ZkZw0O3O9RFkGPSLVKWs21H
	FPM3KCpAZhsI32U+AlpGKKIAU2W4J99nko1ZcKpycMc/7iiTnuX1+aETsUPfzmoSKOZnDUXmQOD
	97Umnx14fHTbPjuCkpsKTx8pPEJk=
X-Google-Smtp-Source: AGHT+IFNkNjYc5lqAsW+vwBzc4d40VsyRBRnr4DCpUgOOs+/SNnn3tAWrLBTLU9Xg/bdK0XxfXoaw2TbElXDR0P+yvY=
X-Received: by 2002:a50:d654:0:b0:572:6cd5:f8d with SMTP id
 4fb4d7f45d1cf-5734d5ce1b1mr18298488a12.22.1716095882732; Sat, 18 May 2024
 22:18:02 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240515080607.919497-1-liangchen.linux@gmail.com>
 <82c8c53b-56e8-45af-902a-a6b908e5a8b3@redhat.com> <CAKhg4t+=vMTaAfbetNZXfgUBiVZYo-tJK-BPX7RbL5kYJrFt=A@mail.gmail.com>
 <83c1b5c9-fcf3-41ba-94e8-f536ebb9581e@redhat.com>
In-Reply-To: <83c1b5c9-fcf3-41ba-94e8-f536ebb9581e@redhat.com>
From: Liang Chen <liangchen.linux@gmail.com>
Date: Sun, 19 May 2024 13:17:50 +0800
Message-ID: <CAKhg4tJmTmTJtNZQdp8H8DVBGozYgyQwDj-_y=NN2MX5kAFbiQ@mail.gmail.com>
Subject: Re: [PATCH] KVM: x86: Prevent L0 VMM from modifying L2 VM registers
 via ioctl
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: seanjc@google.com, kvm@vger.kernel.org, 
	syzbot+988d9efcdf137bc05f66@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, May 18, 2024 at 12:51=E2=80=AFAM Paolo Bonzini <pbonzini@redhat.com=
> wrote:
>
> On 5/17/24 13:37, Liang Chen wrote:
> >>
> >> The attached cleaned up reproducer shows that the problem is simply th=
at
> >> EFLAGS.VM is set in 64-bit mode.  To fix it, it should be enough to do
> >> a nested_vmx_vmexit(vcpu, EXIT_REASON_TRIPLE_FAULT, 0, 0); just like
> >> a few lines below.
> >>
> > Yes, that was the situation we were trying to deal with. However, I am
> > not quite sure if I fully understand the suggestion, "To fix it, it
> > should be enough to do a nested_vmx_vmexit(vcpu,
> > EXIT_REASON_TRIPLE_FAULT, 0, 0); just like a few lines below.". From
> > what I see, "(vmx->nested.nested_run_pending, vcpu->kvm) =3D=3D true" i=
n
> > __vmx_handle_exit can be a result of an invalid VMCS12 from L1 that
> > somehow escaped checking when trapped into L0 in nested_vmx_run. It is
> > not convenient to tell whether it was a result of userspace
> > register_set ops, as we are discussing, or an invalid VMCS12 supplied
> > by L1.
>
> Right, KVM assumes that it can delegate the "Checks on Guest Segment
> Registers" to the processor if a field is copied straight from VMCS12 to
> VMCS02.  In this case the segments are not set up for virtual-8086 mode;
> interestingly the manual seems to say that EFLAGS.VM wins over "IA-32e
> mode guest" is 1 for the purpose of checking guest state.  AMD's manual
> says that EFLAGS.VM is completely ignored in 64-bit mode instead.
>
> I need to look more at the sequence of VMLAUNCH/RESUME, KVM_SET_MSR and
> the failed vmentry to understand exactly what the right fix is.

Yep. Thanks a lot!

Thanks,
Liang
>
> Paolo
>
> > Additionally, nested_vmx_vmexit warns when
> > 'vmx->nested.nested_run_pending is true,' saying that "trying to
> > cancel vmlaunch/vmresume is a bug".
>

