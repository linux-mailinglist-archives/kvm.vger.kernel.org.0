Return-Path: <kvm+bounces-8585-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D00CF85279C
	for <lists+kvm@lfdr.de>; Tue, 13 Feb 2024 03:58:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 939D628618F
	for <lists+kvm@lfdr.de>; Tue, 13 Feb 2024 02:58:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EDAB0A93C;
	Tue, 13 Feb 2024 02:57:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="EmtYwMSo"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C89BE8F4D
	for <kvm@vger.kernel.org>; Tue, 13 Feb 2024 02:57:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707793073; cv=none; b=I7kZnVouovzlIWfuZ1ezTBWHDvCuvh7BCWvKQZkRRoNZCE38U0YvwQku2rYUdfpRqvfXBYGuKuz/Sxh/T82upfqxeXtoet6seic3EX/HFEaLT0vRwv1h+u/sHOv5EU80WCDqoz1D+4n7Fr6lGXzNWwnOvF2O9oBirSemJWfy6qQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707793073; c=relaxed/simple;
	bh=gKJFfu63jwMr2L/Cxwzv3BXvXjhYSn8OnEebVEApyZw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=fqjVpus+YlKjHq0FX95ppWTZNprAkE/HRbWIkFH2fCHDpeZf2iy+fwpxTR/z+2NoCchlIsjAa275BDXPmEVB7rtrcl7b9TTr9KpR7kj9SNB4t4V18oKne/lzPQC0EugG7mdCPv+yW3BGygP9X8WfDsqUO2TPd6A72Z/qe8cQhcQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=EmtYwMSo; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-296fa0144b5so1946719a91.1
        for <kvm@vger.kernel.org>; Mon, 12 Feb 2024 18:57:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1707793071; x=1708397871; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8VHA+kbZQmNH0KfmyjD++Vx8goDUnnVPYFFFCFvDlx0=;
        b=EmtYwMSo48x7+THuTePd9B5/UR0VH/0UMYMc0kAnVXWkgwt+zO7jFHUMO/Etn+gxRA
         LigI8U6qSoOVydhdrMgfq1C5t7IWUqZfHEzbKcUkjlFgsPF4DNIQr2Bo6oCtqV6MPBMu
         FdfBnZWG5y8CImgy6dukTUJSrK0lHPt8uOUiaIRD/Z886FvVc/DFQqtJc8fSczR6aOgJ
         vdWrYxDnWFxo46S2c5P2aAANUvUbv2Yf5QC0DcLO8wDMil64Ycc3Nw9PSZrnZzsDoOy1
         7tUZg5WqS9eHoGzcjT2LsPoqCXS/iy6uF5AFO9ZWcyofSzZ0aINuUhKZDdYUYdBOV5RH
         37yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707793071; x=1708397871;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=8VHA+kbZQmNH0KfmyjD++Vx8goDUnnVPYFFFCFvDlx0=;
        b=fMKSD0VP01laZx7QdrDq0qljfrhdON6ho10/bxVkl9+dkIdGWLcACpNCQ3J6BPFQSG
         GraAQqxUSW/BNFslQRH2jdiG30hW6gf0MQ3nS1cQhKzi+1AnPtaoReMoIjjaBjhDhYj9
         ryYEq43jvjZEmRaY95nGDLEdk9Px6F0rxX3zFP8WUPxv+AyyAO38J+1jdF714O4krEzy
         M42fXmLdUdDotHM1nsRAdh/a+KSo4Hg06eZtZF1OFhsSMskzqg+k2Dj+p3t+ja0maPsI
         Ge9XV4ME8LJfs2s4gS3G8n2cxY72HcxLJiHV0XK3lV0txGPQ0Ynp29XXpYEk9wNxWIrI
         P79A==
X-Gm-Message-State: AOJu0YxvzaQNssTkslAeuer9jCuZkV8jmdMjY78Q/Vb1RgzkOy8lIjLL
	pbNeHypsOymIWDpMFhZnyPY5RZ+eOvbazW+sZY7cmSTBeYv7MYgg5mAu7xkOmjryo1+48bf5Z/9
	TQQ==
X-Google-Smtp-Source: AGHT+IFLrQSyWAo34mcTmEij2pzvFCTRIp5Lmw1QGmSvrKDx9ju4v7ZA3sh0svx4UcZhzStGpLmD0gR3W2Y=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90b:35c3:b0:296:d696:a5ac with SMTP id
 nb3-20020a17090b35c300b00296d696a5acmr56630pjb.5.1707793071021; Mon, 12 Feb
 2024 18:57:51 -0800 (PST)
Date: Mon, 12 Feb 2024 18:57:49 -0800
In-Reply-To: <CABgObfaEz8zmdqy4QatCKKqjugMxW+AsnLDAg6PN+BX1QyV01A@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <cover.1705965634.git.isaku.yamahata@intel.com>
 <591420ca62f0a9ac2478c2715181201c23f8acf0.1705965635.git.isaku.yamahata@intel.com>
 <CABgObfaEz8zmdqy4QatCKKqjugMxW+AsnLDAg6PN+BX1QyV01A@mail.gmail.com>
Message-ID: <Zcrarct88veirZx7@google.com>
Subject: Re: [PATCH v18 032/121] KVM: x86/mmu: introduce config for PRIVATE
 KVM MMU
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: isaku.yamahata@intel.com, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com, erdemaktas@google.com, 
	Sagi Shahar <sagis@google.com>, Kai Huang <kai.huang@intel.com>, chen.bo@intel.com, 
	hang.yuan@intel.com, tina.zhang@intel.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Feb 12, 2024, Paolo Bonzini wrote:
> On Tue, Jan 23, 2024 at 12:55=E2=80=AFAM <isaku.yamahata@intel.com> wrote=
:
> >
> > From: Isaku Yamahata <isaku.yamahata@intel.com>
> >
> > To keep the case of non TDX intact, introduce a new config option for
> > private KVM MMU support.  At the moment, this is synonym for
> > CONFIG_INTEL_TDX_HOST && CONFIG_KVM_INTEL.  The config makes it clear
> > that the config is only for x86 KVM MMU.
>=20
> Better, just put this as:
>=20
> config KVM_MMU_PRIVATE
>     bool
>=20
> but also add a reverse dependency to KVM_INTEL:
>=20
> config KVM_INTEL
>      tristate "KVM for Intel (and compatible) processors support"
>      depends on KVM && IA32_FEAT_CTL
>      select KVM_MMU_PRIVATE if INTEL_TDX_HOST
>      ...
>=20
> This matches the usage of kvm-intel-$(INTEL_TDX_HOST) in the Makefile.

But why even bother with a Kconfig in the first place?  Saving the is_priva=
te
bit in the role adds no value whatsoever.  In fact, it's probably a big net
negative because it necessitates this ugly code:

	if (private)
		kvm_mmu_page_role_set_private(&role);

which really should just be

	role.private =3D private;

Ditto for kvm_mmu_page.private_spt.

The only thing that even so much as approaches being a hot path is
kvm_gfn_shared_mask(), and if that needs to be optimized, then we'd probabl=
y be
better off with a static_key, a la kvm_has_noapic_vcpu (though I'm *extreme=
ly*
skeptical that that adds any measurable benefit).

