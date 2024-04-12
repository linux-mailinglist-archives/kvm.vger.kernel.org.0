Return-Path: <kvm+bounces-14582-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id DE11A8A38A2
	for <lists+kvm@lfdr.de>; Sat, 13 Apr 2024 00:46:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5628D1F225BE
	for <lists+kvm@lfdr.de>; Fri, 12 Apr 2024 22:46:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 207C21514CB;
	Fri, 12 Apr 2024 22:46:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="gfb0AnLA"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1572E225D7
	for <kvm@vger.kernel.org>; Fri, 12 Apr 2024 22:46:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712961970; cv=none; b=KFvMAlwwJjKyG6U32ZX+mPBkaYLmIQdNDPkdo+RtNYPDWnjYw025ZvpmvvW58RMFXW4nvjA8Pgs2/AWY0xn05ToKb56TNTXwju9L8RMPpW5iwJdv4F4SlgmsylTfUmS93OyATA/nC09B8E959SIpTmyrGIumgRwLHqrcpPMahU8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712961970; c=relaxed/simple;
	bh=CVh3GoQ0Uj5EBqBGfQw29CTm8/4AiBhdQKue4WhQnYU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=uA+yer486yedxFmA98ewFOvr57uMH0IAOYK81/yD4hVF5wS7KrMyY/BNBXCjd1hhjE5QSSGo8ijwRdhfV8a9U3LjyDSp32//Bi05IEclXj9pe/G59ld7hraVvlN3Xab2il+dXT1BIzvlrCp4wAG+SpCY1GJySmj15hCOFrJUQcU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=gfb0AnLA; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2a4f128896aso1863217a91.1
        for <kvm@vger.kernel.org>; Fri, 12 Apr 2024 15:46:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1712961968; x=1713566768; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=azAaAXQ+5slCG5tLzAxZ1/q0F1Xu5c3tqFk5gSJfnGk=;
        b=gfb0AnLAz5bQDguarqegI62fEl7QhQxdhTLJvbWhhi7FN6MfeZSqs05/8EcIQmHUf1
         /IfV749FMMl8LiA0JGJM2km8cTl/NCuIyy/dw2EHsXT0oVWlPEbB8zUPBDn6H2DTxUOY
         xCCjJaGyUELxscJ5eLaXyTaB+7rQjCiRaQ+OzeAmbqOE6hQhGOF0IipR9hLB2vizyDU4
         ZKr5uVuOxcQR/3/yONHemnM40qwh2C0tmmvQ5xgwb/Pti89TXhZtZk4z/t0KqI8Y7+wh
         82ExeSqQO1G6VO2HVdENfgcNeXIMSGvKdI6qAez06CeiPj9MmnUOUEHQZKRH2H8L8aUC
         O37g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712961968; x=1713566768;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=azAaAXQ+5slCG5tLzAxZ1/q0F1Xu5c3tqFk5gSJfnGk=;
        b=mp2006SH9iOB3ktr+SFocXdiawmy0An67GCEosEGO3BLK8jBET9GkN4jf08ubRVcl9
         ILWUjVnCOBPX9ybpA09lMIkZv479+8DrBngpM9afqvXT5dh04nMZ3CU0GPmepcrVKxrR
         OYH48BBsgfaK5D8DWmSvxMkxjLR/2uW1FWdcBNAYUifNY1R9UYR7cd6U+e+unNLN6RI1
         e7XlKT4P37TFUd+MYezABRhRLEb5pWd8Syvg/Y4EySGwbTkbegt+oSYkGRXW0yrZZmOD
         ncB6nADwdSk0dtdxoChIz6ICtekaqxWLd/CjkDlDlP+GeqAbgo98KRsU/07NGfb7RKpq
         mWww==
X-Forwarded-Encrypted: i=1; AJvYcCXg0xr3jYPR4t8mMnlKqu4o0QdgxykRF1QEaqK8s67OpCHcRQT4+mowJlmbXnWSSgCpHpZzzd4yZsVOaJXcK7LFEZjk
X-Gm-Message-State: AOJu0YwKxSvDskLB6nDkuPNcAr/9hBcjrtS/mt4j7VrJNiL80IANSh99
	JnBuc51DqjAp074ISTQjLcqPcTSVM3b7gqvsOd2+tPs7yydImFUM/3l6a5AhLzBoUwWdKCmzgbJ
	BTg==
X-Google-Smtp-Source: AGHT+IEa78IMUBOreaXnhO8WKAdssc3iFz0oqiOvqMH5Yz6szB/OqGs806267bfnDoRjxI6Hb7/ZXyDX410=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:a392:b0:2a6:f288:53da with SMTP id
 x18-20020a17090aa39200b002a6f28853damr12661pjp.3.1712961967328; Fri, 12 Apr
 2024 15:46:07 -0700 (PDT)
Date: Fri, 12 Apr 2024 15:46:05 -0700
In-Reply-To: <20240412214201.GO3039520@ls.amr.corp.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <b9fe57ceeaabe650f0aecb21db56ef2b1456dcfe.1708933498.git.isaku.yamahata@intel.com>
 <0c3efffa-8dd5-4231-8e90-e0241f058a20@intel.com> <20240412214201.GO3039520@ls.amr.corp.intel.com>
Message-ID: <Zhm5rYA8eSWIUi36@google.com>
Subject: Re: [PATCH v19 087/130] KVM: TDX: handle vcpu migration over logical processor
From: Sean Christopherson <seanjc@google.com>
To: Isaku Yamahata <isaku.yamahata@intel.com>
Cc: Reinette Chatre <reinette.chatre@intel.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com, 
	Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com, Sagi Shahar <sagis@google.com>, 
	Kai Huang <kai.huang@intel.com>, chen.bo@intel.com, hang.yuan@intel.com, 
	tina.zhang@intel.com, isaku.yamahata@linux.intel.com
Content-Type: text/plain; charset="us-ascii"

On Fri, Apr 12, 2024, Isaku Yamahata wrote:
> On Fri, Apr 12, 2024 at 09:15:29AM -0700, Reinette Chatre <reinette.chatre@intel.com> wrote:
> > > +void tdx_mmu_release_hkid(struct kvm *kvm)
> > > +{
> > > +	while (__tdx_mmu_release_hkid(kvm) == -EBUSY)
> > > +		;
> > >  }
> > 
> > As I understand, __tdx_mmu_release_hkid() returns -EBUSY
> > after TDH.VP.FLUSH has been sent for every vCPU followed by
> > TDH.MNG.VPFLUSHDONE, which returns TDX_FLUSHVP_NOT_DONE.
> > 
> > Considering earlier comment that a retry of TDH.VP.FLUSH is not
> > needed, why is this while() loop here that sends the
> > TDH.VP.FLUSH again to all vCPUs instead of just a loop within
> > __tdx_mmu_release_hkid() to _just_ resend TDH.MNG.VPFLUSHDONE?
> > 
> > Could it be possible for a vCPU to appear during this time, thus
> > be missed in one TDH.VP.FLUSH cycle, to require a new cycle of
> > TDH.VP.FLUSH?
> 
> Yes. There is a race between closing KVM vCPU fd and MMU notifier release hook.
> When KVM vCPU fd is closed, vCPU context can be loaded again.

But why is _loading_ a vCPU context problematic?  If I'm reading the TDX module
code correctly, TDX_FLUSHVP_NOT_DONE is returned when a vCPU is "associated" with
a pCPU, and association only happens during TDH.VP_ENTER, TDH.MNG.RD, and TDH.MNG.WR,
none of which I see in tdx_vcpu_load().

Assuming there is something problematic lurking under vcpu_load(), I would love,
love, LOVE an excuse to not do vcpu_{load,put}() in kvm_unload_vcpu_mmu(), i.e.
get rid of that thing entirely.

I have definitely looked into kvm_unload_vcpu_mmu() on more than one occassion,
but I can't remember off the top of my head why I have never yanked out the
vcpu_{load,put}().  Maybe I was just scared of breaking something and didn't have
a good reason to risk breakage?

> The MMU notifier release hook eventually calls tdx_mmu_release_hkid().  Other
> kernel thread (concretely, vhost krenel thread) can get reference count to
> mmu and put it by timer, the MMU notifier release hook can be triggered
> during closing vCPU fd.
> 
> The possible alternative is to make the vCPU closing path complicated not to
> load vCPU context instead f sending IPI on every retry.

