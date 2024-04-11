Return-Path: <kvm+bounces-14355-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1CD7A8A21A0
	for <lists+kvm@lfdr.de>; Fri, 12 Apr 2024 00:11:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 8CD31B22219
	for <lists+kvm@lfdr.de>; Thu, 11 Apr 2024 22:11:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F06F43E462;
	Thu, 11 Apr 2024 22:11:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="zTH9Nrym"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBDE13D3A4
	for <kvm@vger.kernel.org>; Thu, 11 Apr 2024 22:11:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712873473; cv=none; b=MrVcK0Bo1+5mB2bRCGwPU5i7GX17uCDfv1YICobuovtzjmRguZ6DNOg+Z3MHqWaypmGKpr3A81CDIx20SokruJATwIrw/cnjr+BIQucYxEKQRYfMoS1OcZ/ZjKJeqM0HQt1hh5kORTe5sCjlOXPb9yGZANNviXiPeHnyIdDDpPc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712873473; c=relaxed/simple;
	bh=XzMv/PsKvb64ygIMkbPO9rdOLtTv9xpugwFBdSTwbRU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=YTq90f02FoQldJpStNW3jKBSQRXVQZItQy0DcDx6O3DOJI/froHWn7+PWc1IgdP42JQrcY6gfrqnBjT3WkqmqfkaZ93fJFiAtJwoZb8+tx/dlOGlJ8IZfYy6wVcKT4yI6KxIEJBdRRdJoLHVaAQ1LXwgpGXoXE9OprWtVH+HEsM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=zTH9Nrym; arc=none smtp.client-ip=209.85.208.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-56fe56d4d9cso2157a12.1
        for <kvm@vger.kernel.org>; Thu, 11 Apr 2024 15:11:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1712873470; x=1713478270; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BbaG91lWLov53dvFGF0ekNiCf4p8bhwzy5hlY8LQwTU=;
        b=zTH9Nrymlnp0x75L1y54QtQhaY8uLPHwiYaAaX4wn7F85Idzirb/LqiSkULv2rJHvZ
         7ZO07+YY5FJ3Ol3gl5xDktV794NOvjaLEi3SNoShhS+X4iyh/qeU+G6PUkGxDfBMiY5r
         eePaw1rcDv/GCQp+o3VtXBBU1pj+xdFF7Dm14ZPU2gGchij801bR7ke0sXP71BcXwCE3
         kHTTKfsAeMYrvke55s7cBwwRXC/qeI/YrZ9PHsOjCTzwGngpWI2xIeZaTkdOk3pJLfmI
         80UztkQ7MKz30AmAKJqXdicB2e3lMRAQoRvY10+UBG47yP0Tir7YQVZ7mw51cTciMMKb
         T0ZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712873470; x=1713478270;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BbaG91lWLov53dvFGF0ekNiCf4p8bhwzy5hlY8LQwTU=;
        b=q9/u+uXkwKRuGQpF+C6wWcAoiLkfvxmtDWA6fIApbMrn+F6Gp0jMZfZRhJbumqC240
         UDtYKJvPNBKX5cSqyQBnzm7qw1sks34x9FpFqlzDhdmA+byN3cFkp0vK6xmVINgZAvsS
         Yx4W7B9kPIgN8rG3dtTUu5AJZTIfwZ/WIlNsaYR0ByoEDl2A4RutzWlL7F2iWdd59rRQ
         zg08UtaF6q9Wt6foYNXuafd9hJzjIGTjA/+TPnt171HFWoTmumkl4g5yUpQVn/0CtMML
         IinHgxeRdJ1tm+QGQQEA2iIAFgHmYzXNvb+oKYKX7NBQ2p/ZWU5zV/6uNClopyMrc/7t
         dJIw==
X-Forwarded-Encrypted: i=1; AJvYcCVkXnRKZQ//ZMjucoY77CCHVVQgM1MG9aUXQmm6n8MWxbhwo6q8nhXGNsZR5t1ay3MWEl7Wfcc/LjfbC293zws1ypsV
X-Gm-Message-State: AOJu0Yzm0a/8BCYW3wMuyIBlmXXZxvv2QyFMQuDYU6WvU0qee5caNjnq
	+BhZQrdXUwczIUgU/p/YuJ7ZOVQs/KSojDLgwo2yiyiix6sB8gPro5g5VEC1P7FK3H2TVxGWLdF
	1GLQIBsNdPGJkIumPsaT1buonsCY3vqd5iDVL
X-Google-Smtp-Source: AGHT+IEdRz51c5N65alHGuS4aE+ios2xQWgcBA80yiRi8Tlzhh3yjCC+mkcAB9Nof7IUIQRUh/3WK8WOSXd71rI+7WI=
X-Received: by 2002:aa7:c554:0:b0:56e:2b00:fcc7 with SMTP id
 s20-20020aa7c554000000b0056e2b00fcc7mr61633edr.0.1712873469805; Thu, 11 Apr
 2024 15:11:09 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240126085444.324918-1-xiong.y.zhang@linux.intel.com>
 <20240126085444.324918-29-xiong.y.zhang@linux.intel.com> <ZhhcAT7XiLHK3ZNQ@google.com>
In-Reply-To: <ZhhcAT7XiLHK3ZNQ@google.com>
From: Jim Mattson <jmattson@google.com>
Date: Thu, 11 Apr 2024 15:10:54 -0700
Message-ID: <CALMp9eTQr8ndf48uHHDem2ZkycdhAuVqz18+V1reEEfv0sx8qg@mail.gmail.com>
Subject: Re: [RFC PATCH 28/41] KVM: x86/pmu: Switch IA32_PERF_GLOBAL_CTRL at
 VM boundary
To: Sean Christopherson <seanjc@google.com>
Cc: Xiong Zhang <xiong.y.zhang@linux.intel.com>, pbonzini@redhat.com, 
	peterz@infradead.org, mizhang@google.com, kan.liang@intel.com, 
	zhenyuw@linux.intel.com, dapeng1.mi@linux.intel.com, kvm@vger.kernel.org, 
	linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org, 
	zhiyuan.lv@intel.com, eranian@google.com, irogers@google.com, 
	samantha.alt@intel.com, like.xu.linux@gmail.com, chao.gao@intel.com, 
	Xiong Zhang <xiong.y.zhang@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Apr 11, 2024 at 2:54=E2=80=AFPM Sean Christopherson <seanjc@google.=
com> wrote:
>
> On Fri, Jan 26, 2024, Xiong Zhang wrote:
> > +static void save_perf_global_ctrl_in_passthrough_pmu(struct vcpu_vmx *=
vmx)
> > +{
> > +     struct kvm_pmu *pmu =3D vcpu_to_pmu(&vmx->vcpu);
> > +     int i;
> > +
> > +     if (vm_exit_controls_get(vmx) & VM_EXIT_SAVE_IA32_PERF_GLOBAL_CTR=
L) {
> > +             pmu->global_ctrl =3D vmcs_read64(GUEST_IA32_PERF_GLOBAL_C=
TRL);
> > +     } else {
> > +             i =3D vmx_find_loadstore_msr_slot(&vmx->msr_autostore.gue=
st,
> > +                                             MSR_CORE_PERF_GLOBAL_CTRL=
);
> > +             if (i < 0)
> > +                     return;
> > +             pmu->global_ctrl =3D vmx->msr_autostore.guest.val[i].valu=
e;
>
> As before, NAK to using the MSR load/store lists unless there's a *really=
* good
> reason I'm missing.

The VM-exit control, "save IA32_PERF_GLOBAL_CTL," first appears in
Sapphire Rapids. I think that's a compelling reason.

> And we should consider adding VCPU_EXREG_GLOBAL_CTRL so that we can defer=
 the
> VMREAD until KVM actually tries to access the guest value.

