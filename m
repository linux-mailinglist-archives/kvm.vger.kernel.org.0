Return-Path: <kvm+bounces-30381-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 5FE479B998F
	for <lists+kvm@lfdr.de>; Fri,  1 Nov 2024 21:38:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0A0DD1F21EFB
	for <lists+kvm@lfdr.de>; Fri,  1 Nov 2024 20:38:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F158C1DDC10;
	Fri,  1 Nov 2024 20:38:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="m05eWXsw"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lf1-f48.google.com (mail-lf1-f48.google.com [209.85.167.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77000155330
	for <kvm@vger.kernel.org>; Fri,  1 Nov 2024 20:38:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730493517; cv=none; b=kNBl7+E3j22O8+zyFd5ByoWDn8Kr7YAKpk5gKgJnBK0/FY4AhW0NRYrb0D48Th5uDr0ZfQpYxg5T7SPvYpkW3GV1AVGFov4M9F1zuD3fRZwB5pRLrxInFG7f7mR73MmEFEZOYn9AhtsCSRy+w8+Wr5WNJm7MOQAI7uVUloSiItc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730493517; c=relaxed/simple;
	bh=2E0ss6fxrkLx7gCToCGGo1UWCNZ7U9hTeqIbgKHaGWo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=cCJjXkRMaKF6TT7E58viCM2SXcFv1is6v6Yzv9/oEuhTOQIXfSDCMSIqaBuXEC3Ht2IUJAJGlnpqGoWVe23f9zqFPg1Y2CoAR7iqx6pfwcuM2QkB+/yndPIhzqBslzWsL4fDgJs0Eq0vSkf95ERegriDPz0373NXjmGflj/0YK0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=m05eWXsw; arc=none smtp.client-ip=209.85.167.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-lf1-f48.google.com with SMTP id 2adb3069b0e04-539e617ef81so1341e87.1
        for <kvm@vger.kernel.org>; Fri, 01 Nov 2024 13:38:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1730493513; x=1731098313; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0S8SZ/gu2eXiOekIU0bSJdruZsNOZ1MYmQCtb/cNQgw=;
        b=m05eWXswXD+LYARFAPOJ82/RcP39gHFWb8oGjI6rMmK49h8sHgYeU2B9UCkATunN8r
         lhfKv0ZduPvBUxR3S4Vyp1CdoMv04uVH7qEjK1em4DXQS7kvkYZwqpmAV3YSWNVycNFr
         PLiMD7DfhSXbqT74J7VdlFXu3KypuJrAvLmNYw17Lb7+qp2/dKc9XxPhIm81zgRZwGL/
         2hoUhU2FOR/DKDbH5ko8gxCM0Qr7iZOTYGl4lRLNUXGV7pM8TzhyPao6Fjg2DOCdLfm9
         oIsuGanKFgOjb3RjLAa6WtbOPBkrYe+hi0sWfgQhGnL17xsfiGOuVFowaNGEhvzYEy65
         OjQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730493513; x=1731098313;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0S8SZ/gu2eXiOekIU0bSJdruZsNOZ1MYmQCtb/cNQgw=;
        b=cHodNSwf3DxPNNlywuAsSE9/1bar+kj7PhHISuGEBDMyY2oZpDvCdAOuCH4bsfHhTh
         HoWF+382PAUpmYtRS27hWV/3azMI1gMgmbzGnziamOEEySrs2SLUjUuxoNG6oL7/7rYl
         J5jN+NrqNP2GZEADm2ydIY0a3Vq+QHPKKDU7Y3PVnLoOQIMQnFMSivay/HM1CjdWVR5q
         AwzrDjZhPG0DGvgoApVUZ/Vdcn55WReNgTRD6QmKV5YhP7K3cqkL1u0YBUeqGS8T9kmS
         6wE2VEkWJ07IcliO1VlzgHHGoN43BZ0pu90j1OhClX2nf0JIm2ul0+oU+mUrmFezI0sh
         R6ZA==
X-Forwarded-Encrypted: i=1; AJvYcCX+gZeBXUa+fjWkVDZQnE0DYC+0FcCF/HfOQLAF8wkdHFUGuHoqhsp8rLfWBas6KFNYHvU=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxon/HQHf2ha5p7wwwid5OtTDi58LYe0fRlfHWrE+5kbQt81ydY
	ZnPUK6ezmXZVX04J3gV5HvJOtAYTqNS6UwG9wNr9YxmXH/B3n5K2KVqKlNXhEb/zfWOAJNhC9/+
	pRUM64+aHD1PtHJJs2UAtDtZdAt07APy1Spvs
X-Gm-Gg: ASbGncumeQQBXKVNrYXyfbs8QFFrpXl7Yc2vdNaA9p0HLN/9QXLe9pD8Z4GNNZVpuvt
	plfUAwcGLEN0EGu0UfqEsT+b3a9Dn7KtSqXw7Fe28k+qWSPgTWnCKEVsPETby
X-Google-Smtp-Source: AGHT+IEQsTagRZjln5L5dgZDdUvGYh0A09kXflpjFuGnCCnyRuBSdgyZUma8MPjFfahqpeFF8bROqWSlwcWOc4c4Edg=
X-Received: by 2002:a05:6512:2019:b0:536:88d0:420d with SMTP id
 2adb3069b0e04-53d6acfb187mr120615e87.6.1730493513257; Fri, 01 Nov 2024
 13:38:33 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240823235648.3236880-1-dmatlack@google.com> <20240823235648.3236880-5-dmatlack@google.com>
 <CAHVum0ffQFnu2-uGYCsxQJt4HxmC+dTKP=StzRJgHxajJ7tYoA@mail.gmail.com>
 <Zwa-9mItmmiKeVsd@google.com> <CAHVum0di0z1G7qDfexErzi_f99_T_fTPbZM0s2=TYFCQ8K5pBg@mail.gmail.com>
 <ZyLES2Ai4CC4W-0s@google.com>
In-Reply-To: <ZyLES2Ai4CC4W-0s@google.com>
From: Vipin Sharma <vipinsh@google.com>
Date: Fri, 1 Nov 2024 13:37:56 -0700
Message-ID: <CAHVum0fYkpU-UAyuqrRx+VGi2BFVSupwMhKQ+Q0hY9+15GSTCg@mail.gmail.com>
Subject: Re: [PATCH v2 4/6] KVM: x86/mmu: Recover TDP MMU huge page mappings
 in-place instead of zapping
To: Sean Christopherson <seanjc@google.com>
Cc: David Matlack <dmatlack@google.com>, Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 30, 2024 at 4:42=E2=80=AFPM Sean Christopherson <seanjc@google.=
com> wrote:
>
> On Wed, Oct 09, 2024, Vipin Sharma wrote:
>
> Coming back to this, I opted to match the behavior of make_small_spte() a=
nd do:
>
>         KVM_BUG_ON(!is_shadow_present_pte(small_spte) || level =3D=3D PG_=
LEVEL_4K, kvm);
>

Should these be two separate KVM_BUG_ON(), to aid in debugging?

> As explained in commit 3d4415ed75a57, the scenario is meant to be impossi=
ble.
> If the check fails in production, odds are good there's SPTE memory corru=
ption
> and we _want_ to kill the VM.
>
>     KVM: x86/mmu: Bug the VM if KVM tries to split a !hugepage SPTE
>
>     Bug the VM instead of simply warning if KVM tries to split a SPTE tha=
t is
>     non-present or not-huge.  KVM is guaranteed to end up in a broken sta=
te as
>     the callers fully expect a valid SPTE, e.g. the shadow MMU will add a=
n
>     rmap entry, and all MMUs will account the expected small page.  Retur=
ning
>     '0' is also technically wrong now that SHADOW_NONPRESENT_VALUE exists=
,
>     i.e. would cause KVM to create a potential #VE SPTE.
>
>     While it would be possible to have the callers gracefully handle fail=
ure,
>     doing so would provide no practical value as the scenario really shou=
ld be
>     impossible, while the error handling would add a non-trivial amount o=
f
>     noise.
>
> There's also no need to return SHADOW_NONPRESENT_VALUE.  KVM_BUG_ON() ens=
ures
> all vCPUs are kicked out of the guest, so while the return SPTE may be a =
bit
> nonsensical, it will never be consumed by hardware.  Theoretically, KVM c=
ould
> wander down a weird path in the future, but again, the most likely scenar=
io is
> that there was host memory corruption, so potential weird paths are the l=
east of
> KVM's worries at that point.
>
> More importantly, in the _current_ code, returning SHADOW_NONPRESENT_VALU=
E happens
> to be benign, but that's 100% due to make_huge_spte() only being used by =
the TDP
> MMU.  If the shaduw MMU ever started using make_huge_spte(), returning a =
!present
> SPTE would be all but guaranteed to cause fatal problems.

I think the caller should be given the opportunity to handle a
failure. In the current code, TDP is able to handle the error
condition, so penalizing a VM seems wrong. We have gone from a state
of reduced performance to either very good performance or VM being
killed.

If shadow MMU starts using make_huge_spte() and doesn't add logic to
handle this scenario (killing vm or something else) then that is a
coding bug of that feature which should be fixed.

