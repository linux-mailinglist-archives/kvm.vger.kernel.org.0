Return-Path: <kvm+bounces-56187-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6BDAAB3AC5B
	for <lists+kvm@lfdr.de>; Thu, 28 Aug 2025 23:04:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 25C17171E2E
	for <lists+kvm@lfdr.de>; Thu, 28 Aug 2025 21:04:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2FC7E350856;
	Thu, 28 Aug 2025 21:00:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="fA/5k6G4"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71DE42C327D
	for <kvm@vger.kernel.org>; Thu, 28 Aug 2025 21:00:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756414823; cv=none; b=LwTt+SFOQmABMOrbilk76EUPTHPBDoEJz6s7yniF3lU65LwR9Da9MbG4fifhigeiBCIl4GCocxaSL79vYV3P+TxA9JcxXrPVkK5RbtCQHqGZQmtnbpGo0yWmIk3NF5XR6GtCwNli2YOW9zGJ7nGGznKHnnz8WNSzchav8HJKpjs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756414823; c=relaxed/simple;
	bh=+xEm1cx0Za+w4remSJITWJkTW+VbWCnkQCc2NlPwg8c=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=IpwmP8g35VaR+2dUPbRAlwBuOck0TFKGvimenHBT78hyPAx8gO1MRoq7hSzd3C4ca9tZLrCgHPvGlnTyUidwCMJ0yxnprz/ULRCjOY9x1oCVfYf4BZfiStRuOEBXBgTFrbAhwqJonFQ684uhqTPp30gSrgbs/ZYh8MHVzcnrlc8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=fA/5k6G4; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-3251961140bso1353199a91.2
        for <kvm@vger.kernel.org>; Thu, 28 Aug 2025 14:00:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1756414820; x=1757019620; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ywdWof/ViNLzNyQnGzMNgX5MxQlIKaomEnBSwE0zixA=;
        b=fA/5k6G48HqAd2zWvkU77wycKv6f/KkVzgr91XGtyHPSD6s71kuaQwVWAtgrb8BZud
         iT3HXRKZcgsQz67CWcQIcAWjWI9Arb82Hs7atv72shYw/gvBAcTMt3nj3fnQuZyRcI6e
         b1La49oeRxfngB/1Vf/dHwAkdJaAT0w6XsPT+tJiUm9PONu0mitI63/wvIoM6tNUX5jp
         K62MlM5i6O4iRBahKncUIpVGZsemqYSdkJPYrwPKZ8Hno/wwD4j5F7oSkzortKnsyzxr
         qrJrrytHubhC6OuFRCJy7b+0fuDC/DBsrzUVoAY/dlXd4i8KQSCdvEGiJfwE6bUywD0L
         KeHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756414820; x=1757019620;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=ywdWof/ViNLzNyQnGzMNgX5MxQlIKaomEnBSwE0zixA=;
        b=kkQuIyB7SzJtuADSUiGmhCdb3kQFcqmoE1SUxCBicuCavuJGLO5/bJnCPIRYE0HEfW
         D02UWiKd+pmo5gyCiq81yAwBwuWPPiVCw7in7zOO5HhHnIfcBjh3cVRJ95wYTf+bGR3S
         aOQg1jJYymbFdPtGVcPh7NE8PEkO6PDgZe1JibSkCcVLkONWO1imxfuOAW6tjQvbeyUh
         hNL66DDVeDXtSTKlTP6bSVggOESgfCAURX5sJC/C6mJc37sEW8xPfPluoj1jT0FmHlM6
         QS3dJ0QdF8CFed8fA5nmtyDO3jj+Kc2kf1MKzhJHRadWgNRGEjzdFkWINZ4I9X5jBLgk
         UwlQ==
X-Gm-Message-State: AOJu0YzsWa3uxdt1uKJsWNoX089WmBdm5z/bB+e1WybQzc+TF0xKhFYM
	0nj4a2Srj0I6BK0D797tmTXqUFuQqLvZn9VCPouNUakQlBRQmMSzEemQtP5VvgFTVQzDAG+/+zT
	z+446Xg==
X-Google-Smtp-Source: AGHT+IG+QyF/t7KC5aK5T2G3ygycA1ZpfEYMtGoJlRF0YIZ0ow0p0GS7c1QyR7lKrY/u0oeusLhkpekSx9c=
X-Received: from pjv12.prod.google.com ([2002:a17:90b:564c:b0:312:ea08:fa64])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:58cb:b0:321:6ac:532b
 with SMTP id 98e67ed59e1d1-32517b2cfb3mr32451938a91.35.1756414820632; Thu, 28
 Aug 2025 14:00:20 -0700 (PDT)
Date: Thu, 28 Aug 2025 14:00:18 -0700
In-Reply-To: <9e55a0e767317d20fc45575c4ed6dafa863e1ca0.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250827000522.4022426-1-seanjc@google.com> <20250827000522.4022426-7-seanjc@google.com>
 <11edfb8db22a48d2fe1c7a871f50fc07b77494d8.camel@intel.com>
 <aLCsM6DShlGDxPOd@google.com> <9e55a0e767317d20fc45575c4ed6dafa863e1ca0.camel@intel.com>
Message-ID: <aLDDYo-b5ES-KBWW@google.com>
Subject: Re: [RFC PATCH 06/12] KVM: TDX: Return -EIO, not -EINVAL, on a
 KVM_BUG_ON() condition
From: Sean Christopherson <seanjc@google.com>
To: Rick P Edgecombe <rick.p.edgecombe@intel.com>
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com" <pbonzini@redhat.com>, 
	Vishal Annapurve <vannapurve@google.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Yan Y Zhao <yan.y.zhao@intel.com>, 
	"michael.roth@amd.com" <michael.roth@amd.com>, Ira Weiny <ira.weiny@intel.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 28, 2025, Rick P Edgecombe wrote:
> On Thu, 2025-08-28 at 12:21 -0700, Sean Christopherson wrote:
> > Generally speaking, the number of KVM_BUG_ON()s is fine.=C2=A0 What we =
can do though
> > is reduce the amount of boilerplate and the number of paths the propaga=
te a SEAMCALL
> > err through multiple layers, e.g. by eliminating single-use helpers (wh=
ich is made
> > easier by reducing boilerplate and thus lines of code).
> >=20
> > Concretely, if we combine the KVM_BUG_ON() usage with pr_tdx_error():
> >=20
> > #define __TDX_BUG_ON(__err, __fn_str, __kvm, __fmt, __args...)			\
> > ({										\
> > 	struct kvm *_kvm =3D (__kvm);						\
> > 	bool __ret =3D !!(__err);							\
> > 										\
> > 	if (WARN_ON_ONCE(__ret && (!_kvm || !_kvm->vm_bugged))) {		\
> > 		if (_kvm)							\
> > 			kvm_vm_bugged(_kvm);					\
> > 		pr_err_ratelimited("SEAMCALL " __fn_str " failed: 0x%llx"	\
> > 				=C2=A0=C2=A0 __fmt "\n",=C2=A0 __err,=C2=A0 __args);=C2=A0		\
> > 	}									\
> > 	unlikely(__ret);							\
> > })
> >=20
> > #define TDX_BUG_ON(__err, __fn, __kvm)				\
> > 	__TDX_BUG_ON(__err, #__fn, __kvm, "%s", "")
> >=20
> > #define TDX_BUG_ON_1(__err, __fn, __rcx, __kvm)			\
> > 	__TDX_BUG_ON(__err, #__fn, __kvm, ", rcx 0x%llx", __rcx)
> >=20
> > #define TDX_BUG_ON_2(__err, __fn, __rcx, __rdx, __kvm)		\
> > 	__TDX_BUG_ON(__err, #__fn, __kvm, ", rcx 0x%llx, rdx 0x%llx", __rcx, _=
_rdx)
> >=20
> > #define TDX_BUG_ON_3(__err, __fn, __rcx, __rdx, __r8, __kvm)	\
> > 	__TDX_BUG_ON(__err, #__fn, __kvm, ", rcx 0x%llx, rdx 0x%llx, r8 0x%llx=
", __rcx, __rdx, __r8)
>=20
> In general sounds good. But there it's a bit strange to specify them rcx,=
 rdx,
> etc in a general helper. This is fallout from the existing chain of stran=
ge
> naming:
>=20
> For example tdh_mem_range_block() plucks them from those registers and ca=
lls
> them ext_err1 due to their conditional meaning. Then KVM gives them some =
more
> meaning with 'entry' and 'level_state". Then prints them out as original
> register names. How about keeping the KVM names, like:
>=20
> #define TDX_BUG_ON_2(__err, __fn, arg1, arg2, __kvm)		\
> 	__TDX_BUG_ON(__err, #__fn, __kvm, ", " #arg1 " 0x%llx, " #arg2 "
> 0x%llx", arg1, arg2)
>=20
> so you get: entry: 0x00 level:0xF00

Ooh, nice, I'll tack on a patch.

> I *think* there is a way to make this work like var args and have a singl=
e
> function, but it becomes impossible for people to read.

Heh, and would probably take two months to decipher the compiler errors in =
order
to get it working :-)

> > And a macro to handle retry when kicking vCPUs out of the guest:
> >=20
> > #define tdh_do_no_vcpus(tdh_func, kvm, args...)					\
> > ({										\
> > 	struct kvm_tdx *__kvm_tdx =3D to_kvm_tdx(kvm);				\
> > 	u64 __err;								\
> > 										\
> > 	lockdep_assert_held_write(&kvm->mmu_lock);				\
>=20
> There is a functional change=20

Ugh, I missed that.  I'll do a prep change to make that explicit.

> in that the lock assert is not required if BUSY
> avoidance can be guaranteed to not happen. I don't think it should be nee=
ded
> today. I guess it's probably better to not rely on hitting rare races to =
catch
> an issue like that.

But that's not actually what the code does.  The lockdep assert won't trip =
because
KVM never removes S-EPT entries under read-lock:

		if (is_mirror_sp(sp)) {
			KVM_BUG_ON(shared, kvm);
			remove_external_spte(kvm, gfn, old_spte, level);
		}

Not because KVM actually guarantees -EBUSY is avoided.  So the current code=
 is
flawed, it just doesn't cause problems.

