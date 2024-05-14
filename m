Return-Path: <kvm+bounces-17392-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 796A98C5D64
	for <lists+kvm@lfdr.de>; Wed, 15 May 2024 00:01:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 32A572828FF
	for <lists+kvm@lfdr.de>; Tue, 14 May 2024 22:00:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 27A22181D1A;
	Tue, 14 May 2024 22:00:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="fCSceKzd"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6577181BBF
	for <kvm@vger.kernel.org>; Tue, 14 May 2024 22:00:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715724043; cv=none; b=bwstkh5tKgfcdT3UyHIsQ1F/oUCCloOShv7un+JKJKQbEbxPOpYmZzq5QezIhSxwciTsAgWk0nd7nT1ODaCjpRTavsQE+r6MfZ9IjJlvZRz9tseCIwHarDiH/GEAEJvTqcE08U2M/ORvCaKKNgdA7rL4lPP4pA9f1FaxV0k2Ydw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715724043; c=relaxed/simple;
	bh=ZesKsYDyRLqGOwxtVdB1+K8Zx7Lg3+8aB8pP+CHz0Dg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=kNVGIC0QAb27NEGRXV8RosmT4Lvv4Tj4XeqGXiB/gKsQMevJvif6VdJAu7NorjI8dB0qKSOs7STBzTyJLvlAiP7Jqa83wXFh5T9QAU6oD/ACvobq963umS7m/lXsWRiggO0qAUWYVuZXT2EhB4GODsowu3rT/l3C0FxlAGHKjiQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=fCSceKzd; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-dbf216080f5so10532549276.1
        for <kvm@vger.kernel.org>; Tue, 14 May 2024 15:00:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1715724041; x=1716328841; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=f5EfcMEAUsY+SnBp06Z60R+yACvmNOdhzYQEu5su4rs=;
        b=fCSceKzdUJgUhkpUWttA2hYbpOAbWGMG3SvjwyjwceF3uL0JisQM25zYW4r9ZvmVJk
         OTYV6JdZo0lgvc4TP0QksNuKtKSt51oca0doTGW6Ry8bH8nJNbef9l3G4/aHymVpr+Cv
         Wuh5lw9VxWNjjcD+AezreK+nUpeFPXxYS/v8hUPAgXFMZ45v5umIY7UbFVSXJsNS4kOI
         UjuPtCGT58BG4it42XQniwFV6klMCs7mOsVZGH0ZxIhdPPXlNhckaOvMCXcNJL7gNXOy
         NZ64Er6zY2vct2QgcSgmfHAI3BlAS2vdmLjl86GZCdaDTvyXFSALQp8Us4GJEvas7CwS
         Js1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715724041; x=1716328841;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=f5EfcMEAUsY+SnBp06Z60R+yACvmNOdhzYQEu5su4rs=;
        b=HMLJeB6nvhU2VpnmKu6okV55G3ByYCu1gLcKcrwxqk7+Dabzs7hCLX3VNfxwmDfJBH
         YBwYFOoqGVsPU8azwnnm3vVal9iWmvWWjM/3pkU8QN39M+EqOkT9nnJXtS9diuy5mUxp
         Ol72/oPbsN+jbm2+BHfLfk/+93T50Cm0ieZe27QQAh7uFjp8FOynh1NVAsWxu2lGMXje
         1g1Vgf6oUYlY80e6W8LacdQ/NsdYsmklMVM5imUO98XoqxHepbOu/kGVcPKGWRWZEYZ/
         PL9JGNZD4Jf/pILsgmbiCwmWIj5jL2s4En5l4v48LcEp+KDYQX3eL33ho+0RuKcG/Aai
         WFJg==
X-Forwarded-Encrypted: i=1; AJvYcCXYeYKYIeKZCeY3d0hb9iYqG8ozYcMq0UQgt0Zmmz+3sHf6tFbzzsjSElUgZ6zYatHbJEYc7iqs2rKaefK2cHveonlg
X-Gm-Message-State: AOJu0Yz/NwftAmFEhrmrLgTGwVzwmK0dfJjQvL9SECl/6UFOamFFQWMv
	6485m+RR0BQj8jpMD/T+xH3du+/mLnFfOd1C8FK+6A3AgO06uRex19a35bQgKT0LPuenJO3IRl9
	u1A==
X-Google-Smtp-Source: AGHT+IEHn/IozBdXsx0bX0Dkzx1Eykeu5z0TT4Gh/z+2WrwAmnf+V/tSLSSBrYXzdJT2aMvByp0UpHOfWHw=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:2b87:b0:de4:7bae:3333 with SMTP id
 3f1490d57ef6-dee4f340733mr3995440276.3.1715724040895; Tue, 14 May 2024
 15:00:40 -0700 (PDT)
Date: Tue, 14 May 2024 15:00:39 -0700
In-Reply-To: <202405111034432081zGPU1OUESImLVeboZ0zQ@zte.com.cn>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <Zj4qEG5QfbX4mo48@google.com> <202405111034432081zGPU1OUESImLVeboZ0zQ@zte.com.cn>
Message-ID: <ZkPfB2VpGkRmMLsi@google.com>
Subject: Re: [PATCH] KVM: introduce vm's max_halt_poll_ns to debugfs
From: Sean Christopherson <seanjc@google.com>
To: cheng.lin130@zte.com.cn
Cc: pbonzini@redhat.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	jiang.yong5@zte.com.cn, wang.liang82@zte.com.cn, jiang.xuexin@zte.com.cn
Content-Type: text/plain; charset="us-ascii"

On Sat, May 11, 2024, cheng.lin130@zte.com.cn wrote:
> > > > > > From: seanjc <seanjc@google.com>
> > > > > > > From: Cheng Lin <cheng.lin130@zte.com.cn>
> > > > > > >
> > > > > > > Introduce vm's max_halt_poll_ns and override_halt_poll_ns to
> > > > > > > debugfs. Provide a way to check and modify them.
> > > > > > Why?
> > > > > If a vm's max_halt_poll_ns has been set using KVM_CAP_HALT_POLL,
> > > > > the module parameter kvm.halt_poll.ns will no longer indicate the maximum
> > > > > halt pooling interval for that vm. After introducing these two attributes into
> > > > > debugfs, it can be used to check whether the individual configuration of the
> > > > > vm is enabled and the working value.
> > > > But why is max_halt_poll_ns special enough to warrant debugfs entries?  There is
> > > > a _lot_ of state in KVM that is configurable per-VM, it simply isn't feasible to
> > > > dump everything into debugfs.
> > > If we want to provide a directly modification interface under /sys for per-vm
> > > max_halt_poll_ns, like module parameter /sys/module/kvm/parameters/halt_poll_ns,
> > > using debugfs may be worth.
> > Yes, but _why_?  I know _what_ a debugs knob allows, but you have yet to explain
> > why this
> I think that if such an interface is provided, it can be used to check the source of
> vm's max_halt_poll_ns, general module parameter or per-vm configuration.
> When configured through per-vm, such an interface can be used to monitor this
> configuration. If there is an error in the setting through KVMCAP_HALL_POLL, such
> an interface can be used to fix or reset it dynamicly.

But again, that argument can be made for myriad settings in KVM.  And unlike many
settings, a "bad" max_halt_poll_ns can be fixed simply by redoing KVM_CAP_HALL_POLL.

It's not KVM's responsibility to police userspace for bugs/errors, and IMO a
backdoor into max_halt_poll_ns isn't justified.

