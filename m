Return-Path: <kvm+bounces-25548-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A3889966699
	for <lists+kvm@lfdr.de>; Fri, 30 Aug 2024 18:13:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D28A9B24F05
	for <lists+kvm@lfdr.de>; Fri, 30 Aug 2024 16:13:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 93E451B1D7C;
	Fri, 30 Aug 2024 16:13:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="utARIRH2"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AF2C1B6552
	for <kvm@vger.kernel.org>; Fri, 30 Aug 2024 16:13:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725034387; cv=none; b=P/nhZjlM+myFh6nvD7Oslw4belDnts4cknPRSGesuWsjDZ3AU+vtJWL6u1vlX26QcZpGz0Yt1HrISZhLItMdEHwNoaNbGHAqc2f7mEkhkS9fQE/iNCDXaP4Bf+lV7LlX2/45iDuFYXRNvpSykwg7WoVfI3FZbckPNRnoUpTqRXk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725034387; c=relaxed/simple;
	bh=GBW0OUkfNOg6jUGnbPNWRKROaH/VSriIJgC2jITV0XA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=FdekwO2nMdOdIrR7rJg97IQLup3U+LkwbOASimMAS+dnLZikHTczJ7nuFASnV93KzYbOPMaXgbUifkc3LnwJ8Pk3PEwzARfC4SpX9L0cIlTfIcMvdlQUxFPNC4KFAFfvUzO5EpupSoqpTpoiaZO9TGj9jPxSrdnHWbSdzd1BCNY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=utARIRH2; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-6b71aa9349dso38274517b3.1
        for <kvm@vger.kernel.org>; Fri, 30 Aug 2024 09:13:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1725034385; x=1725639185; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=B8wKzeaoF86EzgRdZ5mXtZV5B8jehTSk9n/aFQzfv58=;
        b=utARIRH2MFeEQSa3VlPb4WL+3sTKRQZduClJcswl9FncywwMI1iGMmAw4WxSgTr/gf
         BWTP0lr6+hoLod9o0x0EdkL5Khba/h52MQZrssPhHldAK0mryLvcic/8m2ueU30IA4k3
         KcHjO+A4/S96Kfyfw4dFdjQi/7isOsFco/aont2o1eh25eRgF1sikhjjHf8SmAZqoz0i
         suL6G2dhdYTWwcpzxLTs9e/nxbQ08y8i4OVkvHtxHQjIJqJsxzoDzaPvUV9TfdvZSmN4
         o49M56NsDgWKlAbui5Aj1dRcPHZxw17zyzGm8rKYxMG4Xum1WCaN2GVZEw6wGvXbpF2B
         687g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725034385; x=1725639185;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=B8wKzeaoF86EzgRdZ5mXtZV5B8jehTSk9n/aFQzfv58=;
        b=tUEcfE2YrqmBuNIZ/ZNE9hrm6iliUowfF47eRIUMxdvQk77HhUZ92VdBJprYWo91iR
         r6gYRxTmTDpfCZHSMJHmgLhiUnQVzrJz+4q0vnTQs/jiGFLkLpLSYKy5ChTdI6AaZ4vP
         G+EdW0CkPcgx4mzfPun2cEe/ZCvdhBNUlWGgyCqOktj7bdKmaItROBLsjTb18xalXsWU
         +9Wb1wzD8WfTNWK6KePFvZ0mtCjb0ay5H2qPE4vVnnKhFvHqceGOtUe3HfGUxks3jcLJ
         Uu4DU/0LPsxa7bZ8X/uJMyiLufCHI0hnpTUQEF9jPrQJDpmPsQ/p6ODJN/FgpPRalqwG
         bnGA==
X-Forwarded-Encrypted: i=1; AJvYcCXEGPcpk0UNTaUkeSFVPIHWuDC7PYAUFsYLDrVCMcFNNLHNWzNC+M+lcszn5fbwQykGz/k=@vger.kernel.org
X-Gm-Message-State: AOJu0YwOJjRKJPgENgypALE81wkJGNgmR+bHj0yrYove4fPwqi567kW6
	KzVKzSS5NWjsZwfcJHOYWOmuhSSrqIKDUyWZVmRywzpQJpTRMsVqLarkmlWZhaWgqVQG0Nek5A/
	oOg==
X-Google-Smtp-Source: AGHT+IEMDNHweiA16k7gDHYb4p0wHpx39yD8IKXuwa99sr0oK8AtMZWM3VLmiFaMmPW/1iktaQ/NFFz+fLg=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:690c:5608:b0:6d4:d6de:3e35 with SMTP id
 00721157ae682-6d4d6de43aamr16677b3.8.1725034385169; Fri, 30 Aug 2024 09:13:05
 -0700 (PDT)
Date: Fri, 30 Aug 2024 09:13:03 -0700
In-Reply-To: <87plpqt6uh.fsf@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240309010929.1403984-1-seanjc@google.com> <20240309010929.1403984-6-seanjc@google.com>
 <877cbyuzdn.fsf@redhat.com> <vuwlkftomgsnzsywjyxw6rcnycg3bve3o53svvxg3vd6xpok7o@k4ktmx5tqtmz>
 <871q26unq8.fsf@redhat.com> <ZtHOr-kCqvCdUc_A@google.com> <87seumt89u.fsf@redhat.com>
 <87plpqt6uh.fsf@redhat.com>
Message-ID: <ZtHvjzBFUbG3fcMc@google.com>
Subject: Re: [PATCH 5/5] KVM: VMX: Always honor guest PAT on CPUs that support self-snoop
From: Sean Christopherson <seanjc@google.com>
To: Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: Gerd Hoffmann <kraxel@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, 
	rcu@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Kevin Tian <kevin.tian@intel.com>, Yan Zhao <yan.y.zhao@intel.com>, 
	Yiwei Zhang <zzyiwei@google.com>, Lai Jiangshan <jiangshanlai@gmail.com>, 
	"Paul E. McKenney" <paulmck@kernel.org>, Josh Triplett <josh@joshtriplett.org>
Content-Type: text/plain; charset="us-ascii"

On Fri, Aug 30, 2024, Vitaly Kuznetsov wrote:
> Vitaly Kuznetsov <vkuznets@redhat.com> writes:
> 
> > Sean Christopherson <seanjc@google.com> writes:
> >
> >> On Fri, Aug 30, 2024, Vitaly Kuznetsov wrote:
> >>> Gerd Hoffmann <kraxel@redhat.com> writes:
> >>> 
> >>> >> Necroposting!
> >>> >> 
> >>> >> Turns out that this change broke "bochs-display" driver in QEMU even
> >>> >> when the guest is modern (don't ask me 'who the hell uses bochs for
> >>> >> modern guests', it was basically a configuration error :-). E.g:
> >>> >
> >>> > qemu stdvga (the default display device) is affected too.
> >>> >
> >>> 
> >>> So far, I was only able to verify that the issue has nothing to do with
> >>> OVMF and multi-vcpu, it reproduces very well with
> >>> 
> >>> $ qemu-kvm -machine q35,accel=kvm,kernel-irqchip=split -name guest=c10s
> >>> -cpu host -smp 1 -m 16384 -drive file=/var/lib/libvirt/images/c10s-bios.qcow2,if=none,id=drive-ide0-0-0
> >>> -device ide-hd,bus=ide.0,unit=0,drive=drive-ide0-0-0,id=ide0-0-0,bootindex=1
> >>> -vnc :0 -device VGA -monitor stdio --no-reboot
> >>> 
> >>> Comparing traces of working and broken cases, I couldn't find anything
> >>> suspicious but I may had missed something of course. For now, it seems
> >>> like a userspace misbehavior resulting in a segfault.
> >>
> >> Guest userspace?
> >>
> >
> > Yes? :-) As Gerd described, video memory is "mapped into userspace so
> > the wayland / X11 display server can software-render into the buffer"
> > and it seems that wayland gets something unexpected in this memory and
> > crashes. 
> 
> Also, I don't know if it helps or not, but out of two hunks in
> 377b2f359d1f, it is the vmx_get_mt_mask() one which brings the
> issue. I.e. the following is enough to fix things:
> 
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index f18c2d8c7476..733a0c45d1a6 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -7659,13 +7659,11 @@ u8 vmx_get_mt_mask(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio)
>  
>         /*
>          * Force WB and ignore guest PAT if the VM does NOT have a non-coherent
> -        * device attached and the CPU doesn't support self-snoop.  Letting the
> -        * guest control memory types on Intel CPUs without self-snoop may
> -        * result in unexpected behavior, and so KVM's (historical) ABI is to
> -        * trust the guest to behave only as a last resort.
> +        * device attached.  Letting the guest control memory types on Intel
> +        * CPUs may result in unexpected behavior, and so KVM's ABI is to trust
> +        * the guest to behave only as a last resort.
>          */
> -       if (!static_cpu_has(X86_FEATURE_SELFSNOOP) &&
> -           !kvm_arch_has_noncoherent_dma(vcpu->kvm))
> +       if (!kvm_arch_has_noncoherent_dma(vcpu->kvm))
>                 return (MTRR_TYPE_WRBACK << VMX_EPT_MT_EPTE_SHIFT) | VMX_EPT_IPAT_BIT;
>  
>         return (MTRR_TYPE_WRBACK << VMX_EPT_MT_EPTE_SHIFT);

Hmm, that suggests the guest kernel maps the buffer as WC.  And looking at the
bochs driver, IIUC, the kernel mappings via ioremap() are UC-, not WC.  So it
could be that userspace doesn't play nice with WC, but could it also be that the
QEMU backend doesn't play nice with WC (on Intel)?

Given that this is a purely synthetic device, is there any reason to use UC or WC?
I.e. can the bochs driver configure its VRAM buffers to be WB?  It doesn't look
super easy (the DRM/TTM code has so. many. layers), but it appears doable.  Since
the device only exists in VMs, it's possible the bochs driver has never run on
Intel CPUs with WC memtype.

The one thing that confuses and concerns me is that this broke in the first place.
KVM has honored guest PAT on SVM since forever, which is why I/we had decent
confidence KVM could honor guest PAT on VMX without breaking anything.  SVM (NPT)
has an explicitlyed document special "WC+" memtype, where guest=WC && host=WB == WC+,
and WC+ accesses snoop caches on all CPUs.

But per Intel engineers, Intel CPUs with self-snoop are supposed to snoop caches
on all processors too.

I assume this same setup works fine on AMD/SVM?  If so, we probably need to do
more digging before fudging around this in the guest.

