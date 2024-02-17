Return-Path: <kvm+bounces-8978-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 02E4C859325
	for <lists+kvm@lfdr.de>; Sat, 17 Feb 2024 23:28:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D21C71C20F47
	for <lists+kvm@lfdr.de>; Sat, 17 Feb 2024 22:28:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4A5B180045;
	Sat, 17 Feb 2024 22:25:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="eqUYcdTC";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="zzKGGxxK"
X-Original-To: kvm@vger.kernel.org
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 334177CF0D;
	Sat, 17 Feb 2024 22:25:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708208714; cv=none; b=aSAE6gVKLGgNWpDdZjPhLv8QyZzgEJXECwSZcqV1FxJ1r/ffxwWuTVGa9pTJnTt2VZYFVFAQDtaBA1Id6QEQrtoxEcok8lv+IYfYaYJ4JzduDWRGVBx5xbiRuLab/2NmjA01ToHvbwo5BsSIy60iBX/VUfLOVLMDBML/DjfNJm4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708208714; c=relaxed/simple;
	bh=mPrz0sxbq360lVAhO6Nco2fa8QwM8JkWcxuMbCde+bg=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=oWFtlw69wsfZx9Gz/G58EQgXPxA486OSZkpw+nDo5shT3b46PNIiqNImpd9yGLxRtjOIF8cqALXVg3ndXJYVMu5g9NeRSzZWJfvf/A2HgqRezLLqr8K2CAa8vEHHR+NLTwDgNkAFUuV0cOxPCYOBkEK+T9s7c5Ckyx4cC0zKfNo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=eqUYcdTC; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=zzKGGxxK; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
From: Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1708208704;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NXB8872lLT9TPOhV6sEx8QOr0X4RsbukNkY28IHdLYQ=;
	b=eqUYcdTC78WFXZI5cTrXIWaJex17r2CcaPrhdl0oyi9GGjKVGhRLSslopwUnLAOby5HIEf
	Putaj8cYhEyQSk8jSfrupz3ikHmTFIDA5w0jCkm2J+L6yDZzmXz/OZ0+1sbwfheGwO378X
	ghjIxkG3nSlfh9gnamXjuKqEp3xu13s6/Yvbos8jBHug26bLh3hK2ZXlz+VtBsEmr+4z+Y
	F2QwVWek+mbkf5zuErATFIJsqMF+vYZiglLKPSZf1+49ux9xAYfNbiCQCAtlMibU8ODrNs
	/BBwQC7jESHzF0ddAdRq7U/W06HoENMRK94W0Stb9NXyBjyaAyfVOCndpmigjg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1708208704;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NXB8872lLT9TPOhV6sEx8QOr0X4RsbukNkY28IHdLYQ=;
	b=zzKGGxxKDcUvYNGqk7GLoBnt0kis0k5MUSB3xs08t6gQJOk3fhdlxu885oP4sWxXesKoXu
	PHs51IIOT9HsnRBQ==
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Xin Li <xin@zytor.com>, Sean Christopherson <seanjc@google.com>, Max
 Kellermann <max.kellermann@ionos.com>, hpa@zytor.com, x86@kernel.org,
 linux-kernel@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>,
 kvm@vger.kernel.org
Subject: Re: [PATCH] arch/x86/entry_fred: don't set up KVM IRQs if KVM is
 disabled
In-Reply-To: <CABgObfY1GPbOhpvnds7tOD5xLOPO6SAmJULDWpT_Z2OGGR80aw@mail.gmail.com>
References: <20240215133631.136538-1-max.kellermann@ionos.com>
 <Zc5sMmT20kQmjYiq@google.com>
 <a61b113c-613c-41df-80a5-b061889edfdf@zytor.com>
 <5a332064-0a26-4bb9-8a3e-c99604d2d919@redhat.com> <87ttm8axrq.ffs@tglx>
 <CABgObfY1GPbOhpvnds7tOD5xLOPO6SAmJULDWpT_Z2OGGR80aw@mail.gmail.com>
Date: Sat, 17 Feb 2024 23:25:03 +0100
Message-ID: <87cysubuf4.ffs@tglx>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Sat, Feb 17 2024 at 10:52, Paolo Bonzini wrote:
> On Fri, Feb 16, 2024 at 10:45=E2=80=AFPM Thomas Gleixner <tglx@linutronix=
.de> wrote:
>> #ifdeffing out the vector numbers is silly to begin with because these
>> vector numbers stay assigned to KVM whether KVM is enabled or not.
>
> No problem---it seems that I misunderstood or read too much into the
> usage of CONFIG_HAVE_KVM up to 6.8, so I'm happy to follow whatever
> FRED support did for thermal vector and the like, and remove the
> #ifdef for the vector numbers.

Thank you! Appreciated!

      tglx

