Return-Path: <kvm+bounces-13988-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id CA24489DB8A
	for <lists+kvm@lfdr.de>; Tue,  9 Apr 2024 16:01:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 80E2B286ECF
	for <lists+kvm@lfdr.de>; Tue,  9 Apr 2024 14:01:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 49AC4130A4D;
	Tue,  9 Apr 2024 14:01:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="cqQDQulE"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BC0F12FB36
	for <kvm@vger.kernel.org>; Tue,  9 Apr 2024 14:01:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712671270; cv=none; b=pI8xtxDNe399qO5nZoJ5JQZkQtD3L2Lf+Cx7YHHyyfqw+4aNQ07knM2Bj5F32wxasgNDTZgDrvqc6jlFzg2a3XFNapPtWdW41vHm7AcHbuNlz84Uf6XZQ0U/EhGpMkebxKOYKMvnCvQOXbWUHDnR7kZ1ITIb33CsTkzmGKqO3uk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712671270; c=relaxed/simple;
	bh=ptYqy6ge+/stdH+ojKozuXTLP0awUt/mbKjAM+pruyg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=HlxdQI1SIS+BpJrOpi3sjsC3u6LseSX2VU52W43zMOhAf/rPOD5a3t/MKFoCynceUFGAF9ggRDPG7aIv5lbPOrcuLyqLg5ZWX+p3FERySxeuBr9JSvxcLk+Vrks+PVCiyD27wLZUV0NrzfinHNrRD4Si9gyyxytbJIqJIXTTOgE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=cqQDQulE; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-5d1bffa322eso6165330a12.1
        for <kvm@vger.kernel.org>; Tue, 09 Apr 2024 07:01:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1712671268; x=1713276068; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=fjIwXx6BxT3u9BQ69lRo33fRcwSok3HZV2l6W5q+KRE=;
        b=cqQDQulESfh12nH0zXM2SUgSk+2WtwNnBibcYW4z/gMzW7yOzYvNO4XaSfgTexOiVW
         oMwlmlR5/m8fDQ3hFRY5JPaTyxWQak4UypVMhpx8167mJ91CsOADWq4Qn08B0BJCDG4G
         4CuB7W/kTW88AgU7L22wkZT+Q7zkwxOv5q3ASVectAg5ched+u3cDcswce3qOLBr6cYs
         crLJ+RLzAzYs1A8kw89PHMxQuylGSdzNzhxeqOaH95t5fDyTmgb8vyNSDo6hkyiYlH8a
         r845IUNAEqtNpfQAIncOGoJprEUtvv++ING/wIWKNOr3ZQdf2NQyinEzUfiOafoq6DAZ
         +jCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712671268; x=1713276068;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fjIwXx6BxT3u9BQ69lRo33fRcwSok3HZV2l6W5q+KRE=;
        b=fgH1Mzg3oelFZ5HnADJ1WDRqrWcLt+ypZUywkdoVFEDAh2Mdn0dWPBXsD7G9eR0j/t
         F4LPqGnttZ+A+ydv/Ek5JPgy5I254BQoeEeRbJ/27Pp44wlQnqq3Qhtw1/oY5xTLs3pM
         LYVIUEbv3pr4gCkiidIDX8U5m1CaEwY+PDmyy6eqzIODHEwC6p4NWhaVAIrdJvZHJOvT
         3oQ6jX34Sux+PR6Jxfs+vHeJyAvwMAQwzTTUANO71RRg9GbBElhcwHr9KbQTJj48xmvC
         kPPPa8DFjjBWh9lkAiTdF6lM9k1BrNzkvXi3jt/WEzcJrj8JraPyiJFY9U51tlA2Eqg6
         TfkA==
X-Gm-Message-State: AOJu0YyXItTCuJ6RbiXE/GIIiSpvJ1bkDk17bMGkpbK4+fQujBviVsF0
	POFTkK7Z5LKN4NQ0VFb+fEne66Q4pXBarNekyEmFQO3QLCIpS/d7jeZi4bP47WaJurxNl64xixL
	5pA==
X-Google-Smtp-Source: AGHT+IHnZyEFuCVHumA09SlUKxgklv8AUAjZZEHTWZ53Zi6fs44ZQpmlJTOw3ou2IUeggTXHF8hlwKdOvfA=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:f404:0:b0:5dc:6130:a914 with SMTP id
 g4-20020a63f404000000b005dc6130a914mr37729pgi.7.1712671266680; Tue, 09 Apr
 2024 07:01:06 -0700 (PDT)
Date: Tue, 9 Apr 2024 07:01:05 -0700
In-Reply-To: <24c80d16-733b-4036-8057-075a0dab3b4d@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240405165844.1018872-1-seanjc@google.com> <73b40363-1063-4cb3-b744-9c90bae900b5@intel.com>
 <ZhQZYzkDPMxXe2RN@google.com> <24c80d16-733b-4036-8057-075a0dab3b4d@intel.com>
Message-ID: <ZhVKIfydhfac9SE4@google.com>
Subject: Re: [ANNOUNCE] PUCK Notes - 2024.04.03 - TDX Upstreaming Strategy
From: Sean Christopherson <seanjc@google.com>
To: Xiaoyao Li <xiaoyao.li@intel.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Rick P Edgecombe <rick.p.edgecombe@intel.com>, Isaku Yamahata <isaku.yamahata@intel.com>, 
	Wei W Wang <wei.w.wang@intel.com>, David Skidmore <davidskidmore@google.com>, 
	Steve Rutherford <srutherford@google.com>, Pankaj Gupta <pankaj.gupta@amd.com>
Content-Type: text/plain; charset="us-ascii"

On Tue, Apr 09, 2024, Xiaoyao Li wrote:
> On 4/9/2024 12:20 AM, Sean Christopherson wrote:
> > On Sun, Apr 07, 2024, Xiaoyao Li wrote:
> > > On 4/6/2024 12:58 AM, Sean Christopherson wrote:
> > > >    - For guest MAXPHYADDR vs. GPAW, rely on KVM_GET_SUPPORTED_CPUID to enumerate
> > > >      the usable MAXPHYADDR[2], and simply refuse to enable TDX if the TDX Module
> > > >      isn't compatible.  Specifically, if MAXPHYADDR=52, 5-level paging is enabled,
> > > >      but the TDX-Module only allows GPAW=0, i.e. only supports 4-level paging.
> > > 
> > > So userspace can get supported GPAW from usable MAXPHYADDR, i.e.,
> > > CPUID(0X8000_0008).eaxx[23:16] of KVM_GET_SUPPORTED_CPUID:
> > >   - if usable MAXPHYADDR == 52, supported GPAW is 0 and 1.
> > >   - if usable MAXPHYADDR <= 48, supported GPAW is only 0.
> > > 
> > > There is another thing needs to be discussed. How does userspace configure
> > > GPAW for TD guest?
> > > 
> > > Currently, KVM uses CPUID(0x8000_0008).EAX[7:0] in struct
> > > kvm_tdx_init_vm::cpuid.entries[] of IOCTL(KVM_TDX_INIT_VM) to deduce the
> > > GPAW:
> > > 
> > > 	int maxpa = 36;
> > > 	entry = kvm_find_cpuid_entry2(cpuid->entries, cpuid->nent, 0x80000008, 0);
> > > 	if (entry)
> > > 		max_pa = entry->eax & 0xff;
> > > 
> > > 	...
> > > 	if (!cpu_has_vmx_ept_5levels() && max_pa > 48)
> > > 		return -EINVAL;
> > > 	if (cpu_has_vmx_ept_5levels() && max_pa > 48) {
> > > 		td_params->eptp_controls |= VMX_EPTP_PWL_5;
> > > 		td_params->exec_controls |= TDX_EXEC_CONTROL_MAX_GPAW;
> > > 	} else {
> > > 		td_params->eptp_controls |= VMX_EPTP_PWL_4;
> > > 	}
> > > 
> > > The code implies that KVM allows the provided CPUID(0x8000_0008).EAX[7:0] to
> > > be any value (when 5level ept is supported). when it > 48, configure GPAW of
> > > TD to 1, otherwise to 0.
> > > 
> > > However, the virtual value of CPUID(0x8000_0008).EAX[7:0] inside TD is
> > > always the native value of hardware (for current TDX).
> > > 
> > > So if we want to keep this behavior, we need to document it somewhere that
> > > CPUID(0x8000_0008).EAX[7:0] in struct kvm_tdx_init_vm::cpuid.entries[] of
> > > IOCTL(KVM_TDX_INIT_VM) is only for configuring GPAW, not for userspace to
> > > configure virtual CPUID value for TD VMs.
> > > 
> > > Another option is that, KVM doesn't allow userspace to configure
> > > CPUID(0x8000_0008).EAX[7:0]. Instead, it provides a gpaw field in struct
> > > kvm_tdx_init_vm for userspace to configure directly.
> > > 
> > > What do you prefer?
> > 
> > Hmm, neither.  I think the best approach is to build on Gerd's series to have KVM
> > select 4-level vs. 5-level based on the enumerated guest.MAXPHYADDR, not on
> > host.MAXPHYADDR.
> 
> I see no difference between using guest.MAXPHYADDR (EAX[23:16]) and using
> host.MAXPHYADDR (EAX[7:0]) to determine the GPAW (and EPT level) for TD
> guest. The case for TDX diverges from what for non TDX VMs. The value of
> them passed from userspace can only be used to configure GPAW and EPT level
> for TD, but won't be reflected in CPUID inside TD.

But the TDX module will emulate EAX[7:0] to match hardware, no?  Whenever possible,
the CPUID entries passed to KVM should match the CPUID values that are observed
by the guest.  E.g. if host.MAXPHYADDR=52, but the CPU only supports 4-level
paging, then KVM should get host.MAXPHYADDR=52, guest.MAXPHYADDR=48.

As I said in my response to Rick:

 : > An alternative would be to have the KVM API peak at the value, and then
 : > discard it (not pass the leaf value to the TDX module). Not ideal.
 : 
 : Heh, I typed up this idea before reading ahead.  This has my vote.  Unless I'm
 : misreading where things are headed, using guest.MAXPHYADDR to communicate what
 : is essentially GPAW to the guest is about to become the de facto standard.
 : 
 : At that point, KVM can basically treat the current TDX module behavior as an
 : erratum, i.e. discarding guest.MAXPHYADDR becomes a workaround for a "CPU" bug,
 : not some goofy KVM quirk.

