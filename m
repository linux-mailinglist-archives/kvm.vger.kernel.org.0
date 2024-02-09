Return-Path: <kvm+bounces-8492-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 63E4384FF64
	for <lists+kvm@lfdr.de>; Fri,  9 Feb 2024 23:04:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 147081F25F5D
	for <lists+kvm@lfdr.de>; Fri,  9 Feb 2024 22:04:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8B0B324B57;
	Fri,  9 Feb 2024 22:04:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="N4k9Lf6q"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4D2F18623
	for <kvm@vger.kernel.org>; Fri,  9 Feb 2024 22:04:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707516252; cv=none; b=nnpvo43/qAag/QQs1V4EsrFGuAEXRTmOZ1dzDmrFudgi+hE0x0TgkNqUxBF81DtWlDzzakqMZ8puTZCO0N0WaDs2uhWRvM3ddR30PQk8rsazQ01PJ9AWMw/LpZ7EHlqgJunpfqH7Q/cmTXLxYylZa5VqXOoGHpqqTMuWPS/tR+o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707516252; c=relaxed/simple;
	bh=/eKGCuNJ3FHEbyu+DPRPVualyEamXtqY05+7kv0j6v0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=VGn0rAEdqWHrK+vRoMEVtG0lg9PTNygWpI3HzHUjc4sO6NiCMEvI4gUF6bswlouYdSqA/PUpUQ9UYdgCZ/xP3bMv+4g4OZEXu9KUj5XxoV+nHMdJ5hWNqn/qKzRwtKoSmJmGJDlyPnZ0fyqfp5ktRIR63o/CSPgyKzyuamHUP7s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=N4k9Lf6q; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1707516248;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1PsQcBsRk1vKYhCjqjhZmQmcpr29M732Tn4RN7l3cCk=;
	b=N4k9Lf6qvzr2x5qqvdf8EZBey+X7g0o4/ky6BynvetJZH5yA6PyJwi3lFRSNJKI4MMdayf
	D9jWAJtX5xzXoI/cLQNUIJpXYDndNfIMV/QPpPyIxOpp5aYth77JlU7voSTh0ogVk16oAC
	GddRQTsGlqooI3RUHnyaypoOwjHoLL8=
Received: from mail-oi1-f198.google.com (mail-oi1-f198.google.com
 [209.85.167.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-519-TjtckmTmPw2r0KAltZNuUA-1; Fri, 09 Feb 2024 17:04:07 -0500
X-MC-Unique: TjtckmTmPw2r0KAltZNuUA-1
Received: by mail-oi1-f198.google.com with SMTP id 5614622812f47-3bfc8b1853cso1609143b6e.3
        for <kvm@vger.kernel.org>; Fri, 09 Feb 2024 14:04:07 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707516246; x=1708121046;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1PsQcBsRk1vKYhCjqjhZmQmcpr29M732Tn4RN7l3cCk=;
        b=D/OB+jG7GwOrVTswmIb9ObaktiQFdWVHg4KgEFIot8WJgPsekEX8un5KM2AX9vvYBl
         nykLjEd263PeB+W6hAzD47bnYsg6J/xCPJwtdWKArYMxkWpUdSadtNDkFRakjNyOPs/Z
         PpZbaRU4BRFZYf/P7M+/oF+HQZT38y5YpBgJuUeOGYQ0lzIKqPVJzXIzCNPRpReV2oIU
         8nlSrEOuu2s+baizl/URlIvpTAN9o66KYLSAgF3DaKaKUgSrvhKdqhjCniugIzDbq8dI
         PV+Ci4WdNcQoYymSmvmIPO+P6s4d3JXwlYca1fFUoOJ4R7OHTJ5LhIzvJktaxlbSjGRj
         LVuw==
X-Gm-Message-State: AOJu0YylOXt9QvX5VbLdl0tzA83C0+3uRyedPdhQ1GCukHxcGPAak1Ac
	GsFURimn0B/U0BC0O+8H9cbaYojW1hO3GgkI6WtIU0YC1aoLkXPRJVy5aiWio5RMVLBdGnwUkq8
	v+VPeZxuCg+BqyBesDSPhKv3RdczXR/Nyev61S/0CONm1CSsXq1mmvhF4wKuaFNf+TN6tqfOU65
	bdDkROftOJqxuTU07Ed6KehUTp
X-Received: by 2002:a05:6808:120b:b0:3bf:dc8c:7a10 with SMTP id a11-20020a056808120b00b003bfdc8c7a10mr380363oil.45.1707516246430;
        Fri, 09 Feb 2024 14:04:06 -0800 (PST)
X-Google-Smtp-Source: AGHT+IESd3wyQYbLXEJgWAjhRINhimI++QSrzJ/Q1rWiu7+oeZZ7mrDpl2fSjeBnrRsri1YJlp6CLkBROWJZ9MNGWd0=
X-Received: by 2002:a05:6808:120b:b0:3bf:dc8c:7a10 with SMTP id
 a11-20020a056808120b00b003bfdc8c7a10mr380339oil.45.1707516246138; Fri, 09 Feb
 2024 14:04:06 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240123001555.4168188-1-michal.wilczynski@intel.com>
 <20240125005710.GA8443@yjiang5-mobl.amr.corp.intel.com> <CABgObfYaUHXyRmsmg8UjRomnpQ0Jnaog9-L2gMjsjkqChjDYUQ@mail.gmail.com>
 <42d31df4-2dbf-44db-a511-a2d65324fded@intel.com> <CABgObfYa5eKj_8qyRfimqG7DXpbxe-eSM6pCwR6Hq97eZEtX6A@mail.gmail.com>
 <ZcY_GbqcFXH2pR5E@google.com>
In-Reply-To: <ZcY_GbqcFXH2pR5E@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Fri, 9 Feb 2024 23:03:53 +0100
Message-ID: <CABgObfYQQZooYrsUnc8SSUbpiYQyZKGzDN2JutB-a5mJWWcr7w@mail.gmail.com>
Subject: Re: [PATCH v2] KVM: x86: nSVM/nVMX: Fix handling triple fault on RSM instruction
To: Sean Christopherson <seanjc@google.com>
Cc: Michal Wilczynski <michal.wilczynski@intel.com>, 
	Yunhong Jiang <yunhong.jiang@linux.intel.com>, mlevitsk@redhat.com, tglx@linutronix.de, 
	mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org, 
	hpa@zytor.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	dedekind1@gmail.com, yuan.yao@intel.com, Zheyu Ma <zheyuma97@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Feb 9, 2024 at 4:05=E2=80=AFPM Sean Christopherson <seanjc@google.c=
om> wrote:
> > If they are needed, it's fine. In my opinion a new callback is easier
> > to handle and understand than new state.
>
> Yeah, we ripped out post_leave_smm() because its sole usage at the time w=
as buggy,
> and having a callback without a purpose would just be dead code.

[...]

>  : But due to nested_run_pending being (unnecessarily) buried in vendor s=
tructs, it
>  : might actually be easier to do a cleaner fix.  E.g. add yet another fl=
ag to track
>  : that a hardware VM-Enter needs to be completed in order to complete in=
struction
>  : emulation.
>
> I didn't mean add a flag to the emulator to muck with nested_run_pending,=
 I meant
> add a flag to kvm_vcpu_arch to be a superset of nested_run_pending.  E.g.=
 as a
> first step, something like the below.  And then as follow up, see if it's=
 doable
> to propagate nested_run_pending =3D> insn_emulation_needs_vmenter so that=
 the
> nested_run_pending checks in {svm,vmx}_{interrupt,nmi,smi}_allowed() can =
be
> dropped.

That seems a lot more complicated... What do you think of the patches
I posted (the one that works and the wish-it-could-be-like-that one
that folds triple faults into check_nested_events).

Paolo


