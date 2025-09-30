Return-Path: <kvm+bounces-59205-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 44459BAE327
	for <lists+kvm@lfdr.de>; Tue, 30 Sep 2025 19:33:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F3BB232235D
	for <lists+kvm@lfdr.de>; Tue, 30 Sep 2025 17:33:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 63FF126A1AB;
	Tue, 30 Sep 2025 17:33:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dFiyTxjo"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 153181E0DFE
	for <kvm@vger.kernel.org>; Tue, 30 Sep 2025 17:33:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759253620; cv=none; b=iM0rMBXGCnj7SIkyOvgqE0sT7ntbOhoCM80C4JOyLo32jtUmnEdbYKTrLkgHjDm+JLCDaRzZPXmoqAH0c11gXErkfQ3lS/uyUfBefXnOd291RVR3DrLCan7vdkbCNvCxjO1qouHETI0XM7hfkV6VmA8PUpbgEsAFmO8YeEtttpU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759253620; c=relaxed/simple;
	bh=/uzHTZRlmfTXfkbDbdCgwivf0VeFrYx3UT6Fycy7EKg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=eFQw03p/5SYOHoBI2iLH5DYwlTsskwY1qABu92njsGoHo4ClKiDo699+dXRUqPgnh9zEMOC0iRqnEzt/fpkVj1M74iDE7sEhZ21hf1JhgmfgwZ3uTDtmfm2S+2NcBpWSY29iaUspixR1YrLPuy1gErbcxAsqqvU5f6sgreQFN/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=dFiyTxjo; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1759253618;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=DVdC9fzy8g2U07P39DvGMyerTR2hUiEGZN4FGElHXu8=;
	b=dFiyTxjoqWwObaRezi4Fbsc9Fv+wP37RR0ufgLqpJtc1c/WqhKbf53cplHAzS32jd1eX+9
	JZNEEK5XOsXemNAWU+oYx4mAIHBFTVpEyRr8e8Ja858pecQW5/aJJ4JeOswm41zpN0UBmf
	uhxSu+3vm3QZQB9r3SRKwn3XldeyrYo=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-547-b7HOV6XkOEqw7lbtznAs7A-1; Tue, 30 Sep 2025 13:33:36 -0400
X-MC-Unique: b7HOV6XkOEqw7lbtznAs7A-1
X-Mimecast-MFC-AGG-ID: b7HOV6XkOEqw7lbtznAs7A_1759253615
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-3ecdf7b5c46so3636964f8f.2
        for <kvm@vger.kernel.org>; Tue, 30 Sep 2025 10:33:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759253615; x=1759858415;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DVdC9fzy8g2U07P39DvGMyerTR2hUiEGZN4FGElHXu8=;
        b=PchAmDhON/NySx50pkqzv+uzSK/N3wIQr4T5KvMXMH0Wx4+eerxRic0V8XlAGkLMMz
         vrs7vXtdw6NoT/9NIFvjQjjwlU7wElxxWvda25Y+swf6Wwm7zh76WQ0zmFaWaSJS5wqY
         kpWYS9z8qQLK93exXRD5rhSZdabRkNlNSiobzu7cuaT+B0AtSxouO5s5nrlXoZOqXtDD
         +fytiTXdCJhKRfEzaW5ur6NG1YnGD1BzkkElaDbzxdb2C6qyKw3YXfSY4Kny3dndvV4I
         +fVplBdAQZJz47vwcfhjJjXhyjzUEyGzsJ6b4OVG/xznPHQNoDAIIzk9f0DFoP6IFBMy
         uP6g==
X-Gm-Message-State: AOJu0Yxoh1CZwFJFOiFuVscFK8p0Kj13QM9Qyj8FAs6Ld+0sIDiNYkAQ
	DmreLhcu56wwavLpQa8MRbkP1LV0oYduKR8yH2iAzf6ewkuAapPysxNeZJJpvYmE/YKpaUICulG
	fyCfclWoC2hP8fbAsGlNaxrcV05eLMhKXTHdRTF3MNHeqtDkst3Jr6YAE0n+zBvP10Zn2IUtdqj
	Irs91/eO1vD4/SREBLbPOgMh92QN9V
X-Gm-Gg: ASbGncv4iNJHukK0ku9DUemK+D7Q/3ACuLdHdx2XNWUOaD0+ENbdDSubjSEa+oCsDvl
	LE1dvDArV3HV8vx5/ZdMcfkflig/tD6v0HtUixAUsT2vw4YEXlsMDrWGcTc5Wo42GbN0XJTdkPV
	WMJug6VXHmbqQa3PMc913cM6c4mqkRrAs+yiCtRC4fiS6tECycCwf6Di+hN4cMUJjwLp4NpGfRi
	pBWDmIamcvOyFJEzzbS+1uM7MzJxe8v
X-Received: by 2002:a05:6000:420a:b0:3ee:15d5:614f with SMTP id ffacd0b85a97d-4255781b050mr453893f8f.46.1759253615171;
        Tue, 30 Sep 2025 10:33:35 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGPEGl7i1wI3zGz8Gl0JlNQlV381u6TWCOx0x5yH96A4cHnQkC4YdjEEJwapOyYbkd/ZvX3EIxM60w4sr5oFVo=
X-Received: by 2002:a05:6000:420a:b0:3ee:15d5:614f with SMTP id
 ffacd0b85a97d-4255781b050mr453874f8f.46.1759253614771; Tue, 30 Sep 2025
 10:33:34 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250927060910.2933942-1-seanjc@google.com> <20250927060910.2933942-6-seanjc@google.com>
In-Reply-To: <20250927060910.2933942-6-seanjc@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Tue, 30 Sep 2025 19:33:22 +0200
X-Gm-Features: AS18NWBYZvWeclECRyRctpt0s36DZsWKpQ0aMUf6N3yHtD8DPtsunh5xRdz3dz4
Message-ID: <CABgObfbOSffjFPgpOe1TQ8XJNYD907Ufa-YQN7C--9dREkFw2w@mail.gmail.com>
Subject: Re: [GIT PULL] KVM: x86: VMX changes for 6.18
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Sep 27, 2025 at 8:09=E2=80=AFAM Sean Christopherson <seanjc@google.=
com> wrote:
>
> Fix a TDX bug detected by Smatch where KVM would return '0' on failure, d=
o a
> bit of early prep for FRED virtualization, and tidy up.
>
> The following changes since commit c17b750b3ad9f45f2b6f7e6f7f4679844244f0=
b9:
>
>   Linux 6.17-rc2 (2025-08-17 15:22:10 -0700)
>
> are available in the Git repository at:
>
>   https://github.com/kvm-x86/linux.git tags/kvm-x86-vmx-6.18
>
> for you to fetch changes up to 510c47f165f0c1f0b57329a30a9a797795519831:
>
>   KVM: TDX: Fix uninitialized error code for __tdx_bringup() (2025-09-19 =
15:25:34 -0700)

Pulled, thanks.

Paolo

> ----------------------------------------------------------------
> KVM VMX changes for 6.18
>
>  - Add read/write helpers for MSRs that need to be accessed with preempti=
on
>    disable to prepare for virtualizing FRED RSP0.
>
>  - Fix a bug where KVM would return 0/success from __tdx_bringup() on err=
or,
>    i.e. where KVM would load with enable_tdx=3Dtrue despite TDX not being=
 usable.
>
>  - Minor cleanups.
>
> ----------------------------------------------------------------
> Qianfeng Rong (1):
>       KVM: TDX: Remove redundant __GFP_ZERO
>
> Sean Christopherson (1):
>       KVM: VMX: Add host MSR read/write helpers to consolidate preemption=
 handling
>
> Tony Lindgren (1):
>       KVM: TDX: Fix uninitialized error code for __tdx_bringup()
>
> Xin Li (1):
>       KVM: VMX: Fix an indentation
>
>  arch/x86/kvm/vmx/tdx.c | 12 ++++--------
>  arch/x86/kvm/vmx/vmx.c | 37 ++++++++++++++++++++++++++-----------
>  2 files changed, 30 insertions(+), 19 deletions(-)
>


