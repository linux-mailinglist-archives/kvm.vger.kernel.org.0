Return-Path: <kvm+bounces-8285-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A192584D582
	for <lists+kvm@lfdr.de>; Wed,  7 Feb 2024 23:11:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 548161F2B66E
	for <lists+kvm@lfdr.de>; Wed,  7 Feb 2024 22:11:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 768AB128360;
	Wed,  7 Feb 2024 21:41:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="RyNazpMF"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FC2780050
	for <kvm@vger.kernel.org>; Wed,  7 Feb 2024 21:41:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707342085; cv=none; b=hmxGnlgk6EJBf3qD+sNKWZgLZBDcgqW9MxTXbEzjQRVlYBaT+32jMX3XfujQHLgQzpYehne6qOP8XL6pVYNo5aaKlZGgB77UAatG0Y/BNlaUnbRVKjQPvizl5CXAubAqF0BWHUpDDsAKV8S82h3J7CZxMRgXJ/GpYnieeAAgqc8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707342085; c=relaxed/simple;
	bh=m0X4iYY47mytjams2aAWGUUTlmfK2BhzrJXilnIMHUc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=iDh8u39E8gOfhBANsAn4tkMHoC3JjseU8BCpI4Pr67SyFNndPNxlzo4ZxLpmkEwGjDJJCurp9l5f5OuzTKoThs8d01Q1W/mH63IuniOmrIYAb/KND2yh9eBvhTQZFq7psb3Zdp34WRP28pQiSPIg7TGueKoYOQUxSsM5UPRk/2g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=RyNazpMF; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-5c66a69ec8eso925252a12.3
        for <kvm@vger.kernel.org>; Wed, 07 Feb 2024 13:41:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1707342083; x=1707946883; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+uqJkD0pNiGFSzVNfxf/EpblheLHB1ALRvEiBOY/f2Q=;
        b=RyNazpMFM2hrquVMChv73zs5N93tR7ZR2V/ouqqeRl6KyrcIDVMOANs5KZnHVt46X/
         uKa2/pZvgGP+rT4cmzA8JDzBMSfp7QZQBm9sf3GthQaNWXeIcbRO7s0HCOlMqCONnq44
         OKpU+1fPhxSvZZKzDOcxaXSAQdgsk08YaPjmXxx9nePmT8IzZSkg+v7iVR2UcTjyEgoD
         HqnaAPkyTEIcCR6JJaCTvHIGnm+bN5Z8YyIbuQvlJJA5kTIlGMbDwkCukSxMCxoQAFLt
         tTdkN5X5MSBfmlN3VVVakLAv+AZthDT8QIVq1irzYxF4x/bYAgw/rnKA093FZb9AlJbz
         atQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707342083; x=1707946883;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=+uqJkD0pNiGFSzVNfxf/EpblheLHB1ALRvEiBOY/f2Q=;
        b=vsVThHvF0aAQIr5jT+A4Rb5dzbvsvpaYo+LDL7TZIt/sZJ8iyneYfSCY2rmgA+dJrc
         bR6tcAuP/IFirJ+fnX07SxHf/RotLDAX/wudmLgdkHSd8DhSOydI7QMrLTVstpiw3/O0
         MmNIy8yjtGH+M9bcjnBsGyn+CFQWiEc5G2ugWA43fLQ2Jl9UteDQFqHKVUB1isDYcTJm
         JrzE2WE+59Gyp/V/UXJIcZy59zwIxKmZLH3nmYnfE83PABdoC9tfW1mfqnJTBzssbQPB
         qqpHwJGW9s+L6vLLlIRn2iYLbEeE8CVOZuXeq7h/q/rR+T/k0h/6Tdei1wcQ+L3BvbF9
         Axvw==
X-Gm-Message-State: AOJu0Yzj6/JoYp+WUrUl7+FV6oSryzeUbprVUO9s/kuHzkFUgrCd4vrQ
	8wyLGOxL4cqqPafPiSMvMd5ymOmVIUDUHmk8wSGSOY/KpWWv+WHxd5J+kbj0z1bYbSynevoNVPo
	dbQ==
X-Google-Smtp-Source: AGHT+IFpdEi45Rjll8ycI0QJQfD6b8UOFdWhoFwT1NQma5Og9bbNF3xTCRlDkTCknSmCb3ZTBclclI1LzO4=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a02:8c8:b0:5dc:1c7d:2c75 with SMTP id
 ch8-20020a056a0208c800b005dc1c7d2c75mr11022pgb.1.1707342083319; Wed, 07 Feb
 2024 13:41:23 -0800 (PST)
Date: Wed, 7 Feb 2024 13:41:21 -0800
In-Reply-To: <CAF7b7mqOCP2NiMsvzfpYaEaKWm4AzrRAHSGgQT9BWhRD1mcBcg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231109210325.3806151-1-amoorthy@google.com> <20231109210325.3806151-9-amoorthy@google.com>
 <CAF7b7mqDN97OM7kgS--KsDygokUHd=wiZjYPVz3yk7UB0jF_6w@mail.gmail.com>
 <ZcOkRoQn7Q-GcQ_s@google.com> <ZcOysZC2TI7hZBPA@linux.dev> <CAF7b7mqOCP2NiMsvzfpYaEaKWm4AzrRAHSGgQT9BWhRD1mcBcg@mail.gmail.com>
Message-ID: <ZcP5ASva7h1gWhx7@google.com>
Subject: Re: [PATCH v6 08/14] KVM: arm64: Enable KVM_CAP_MEMORY_FAULT_INFO
From: Sean Christopherson <seanjc@google.com>
To: Anish Moorthy <amoorthy@google.com>
Cc: Oliver Upton <oliver.upton@linux.dev>, kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	pbonzini@redhat.com, maz@kernel.org, robert.hoo.linux@gmail.com, 
	jthoughton@google.com, dmatlack@google.com, axelrasmussen@google.com, 
	peterx@redhat.com, nadav.amit@gmail.com, isaku.yamahata@gmail.com, 
	kconsul@linux.vnet.ibm.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Feb 07, 2024, Anish Moorthy wrote:
> On Wed, Feb 7, 2024 at 8:41=E2=80=AFAM Oliver Upton <oliver.upton@linux.d=
ev> wrote:
> >
> > On Wed, Feb 07, 2024 at 07:39:50AM -0800, Sean Christopherson wrote:
> >
> > Having said that...
> >
> > > be part of this patch.  Because otherwise, advertising KVM_CAP_MEMORY=
_FAULT_INFO
> > > is a lie.  Userspace can't catch KVM in the lie, but that doesn't mak=
e it right.
> > >
> > > That should in turn make it easier to write a useful changelog.
> >
> > The feedback still stands. The capability needs to be squashed into the
> > patch that actually introduces the functionality.
> >
> > --
> > Thanks,
> > Oliver
>=20
> Hold on, I think there may be confusion here.
> KVM_CAP_MEMORY_FAULT_INFO is the mechanism for reporting annotated
> EFAULTs. These are generic in that other things (such as the guest
> memfd stuff) may also report information to userspace using annotated
> EFAULTs.
>=20
> KVM_CAP_EXIT_ON_MISSING is the thing that says "do an annotated EFAULT
> when a stage-2 violation would require faulting in host mapping" On
> both x86 and arm64, the relevant functionality is added and the cap is
> advertised in a single patch.
>=20
> I think it makes sense to enable/advertise the two caps separately (as
> I've done here). The former, after all, just says that userspace "may
> get annotated EFAULTs for whatever reason" (as opposed to the latter
> cap, which says that userspace *will* get annotated EFAULTs when the
> stage-2 handler is failed). So even if arm64 userspaces never get
> annotated EFAULTs as of this patch, I don't think we're "lying" to
> them.

Neither Oliver nor I are advocating you smush the two together.  We're sayi=
ng
the code that actually fills memory_fault should be either (a) a separate p=
atch
(x86) or (b) in the patch that advertises KVM_CAP_MEMORY_FAULT_INFO (arm).

I *highly* doubt it will matter in practice, but if there was a problem wit=
h
filling memory_fault, it would be nice to isolate that to a standalone patc=
h,
and not the EXIT_ON_MISSING_CHANGE.

