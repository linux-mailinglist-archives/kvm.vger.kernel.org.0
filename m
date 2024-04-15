Return-Path: <kvm+bounces-14703-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5F8FF8A5DF4
	for <lists+kvm@lfdr.de>; Tue, 16 Apr 2024 00:59:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 90ADC1C20C43
	for <lists+kvm@lfdr.de>; Mon, 15 Apr 2024 22:59:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C35AC15885D;
	Mon, 15 Apr 2024 22:59:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="IaFvlV/Z"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4ABA15885C
	for <kvm@vger.kernel.org>; Mon, 15 Apr 2024 22:59:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713221955; cv=none; b=TDvCM+0YM9174+1OaolAIuJdIEAbN5hCsMLgWN1CoLqkBwLqOEQhziIbIplc2QZLNNb9ZSwy99L3l3uKp1BSNos2WT7xxg8r8fC7oMrISjeyLodDHkF0Nbvawaj/KB9Jp08LzpipzvypB2iGbimINpTJGG0b5az9YS2pue9gFDo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713221955; c=relaxed/simple;
	bh=DdFbcDWupdbZq3MIrDoyTUGR/ypiyEhsqthCvxrfA/w=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=AEBUEshSitbVJdV1pHUgNu1dZMm7zsiOc/EzlTYExfdkxzLmggcjQOt14ORoj16aXpCbdVh0dHOGBYH3rU2DeIo3ZZp09YaW3wTJG2FEeE5zSgIJ2cPRh9hfZFKPht6jamruH3EYaHazetcCLiIAevVbiMzTw96xEab04bV1QQU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=IaFvlV/Z; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-5cf555b2a53so2688498a12.1
        for <kvm@vger.kernel.org>; Mon, 15 Apr 2024 15:59:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1713221953; x=1713826753; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Y+6RmiqHl0vlEhWm7Grv4WhfQxc8gtLrnCV+6pwVYvc=;
        b=IaFvlV/ZSQ+ANIBVsbZ6FhZc7skfu4a5M8B6h4IAb4H994t043HqVfiwpRvOXy8Icb
         3XSjs2skgiC3g7n6pVjflrMfwhrFonw7DrZ0jfMj4oEZBkcxrL4Uo8F7a/aP8FnxXS2M
         cvtRhRgJrUY5BcGM4G9P6nUVEK7709eskQRjB0UBatGgu3PCdKWJq/ZU/sB7yYVI7nIa
         a4ckUYDdw4EzwV5J4+OV4FXMtVpEOY4uIYd8hacYeggEFQF1j2WNfRqJCt2sNxlDMoBO
         10EXk2D1fu9qErUT+e/YfGTlJZUYE7oIsjWi99axwiFvt3534/J7jQ+uik++01f+mk00
         hAMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713221953; x=1713826753;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Y+6RmiqHl0vlEhWm7Grv4WhfQxc8gtLrnCV+6pwVYvc=;
        b=wKmCoBkQ+hjvDv87d/8s4lQae2NisUMa76y9rMX3bgK2BGVTiRdVYwIQBppdaSFHab
         YHkqNxT6TDSSRE4A1W5FQakw9Pz46Kd9D38/mHhmzilCWoHZF3voxbtzK2f6TfrMSLBh
         2cXUjkbMVGD8uZrj4Dscn9arVxUnBXhc7EPjzf8fxpQhqhXtjD53H3x/Kr1Ive5ry+Pg
         P/BMf+3D1//7VhAZHvGCBKC87o9/LldbPPaq0Db5bi/eg6CkDofkgL0mDsdwozC8IZJq
         PuHpfJoNBtQhUYWnNcT1aVxVYoO69bGVRDuJU8PPeARm+dE0OkmdCwUaNjXaO3VwWFzh
         3Lug==
X-Forwarded-Encrypted: i=1; AJvYcCWSQuMsr/j6tFmUTQLLN9Vt5nN52U8NFswcq90TAVHDV3Yn+8ykt0rhRjOEDxb8l4PmoCij4dJyWjrCnZ3D3/Wr8u2e
X-Gm-Message-State: AOJu0YxUCmjmd3HvWmhgO43KjM1dNN8TvDoP81NL8iVj1XKzf2krDz/C
	7FsGLyp36vzFj6cCg46eprfIKmTwLWECZAcLCOtGmdeUee96jVhlFDu8UNUWrqFdI+BsdiAzbPr
	sDw==
X-Google-Smtp-Source: AGHT+IHIN3c3KafZKwbjYEO7XDxNUeKMgXMoQNPwQ3zXEtyUK633NACFAHkTnhqp9fuH4PP86bf5/43ShhI=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:e618:b0:2a1:f7af:887c with SMTP id
 j24-20020a17090ae61800b002a1f7af887cmr3469pjy.4.1713221952870; Mon, 15 Apr
 2024 15:59:12 -0700 (PDT)
Date: Mon, 15 Apr 2024 15:59:11 -0700
In-Reply-To: <8959c330e47aa78b97bdca6e8beae11697c15908.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <cover.1712785629.git.isaku.yamahata@intel.com>
 <2f1de1b7b6512280fae4ac05e77ced80a585971b.1712785629.git.isaku.yamahata@intel.com>
 <116179545fafbf39ed01e1f0f5ac76e0467fc09a.camel@intel.com>
 <Zh2ZTt4tXXg0f0d9@google.com> <8959c330e47aa78b97bdca6e8beae11697c15908.camel@intel.com>
Message-ID: <Zh2xPwGAMMgqKeYV@google.com>
Subject: Re: [PATCH v2 07/10] KVM: x86: Always populate L1 GPA for KVM_MAP_MEMORY
From: Sean Christopherson <seanjc@google.com>
To: Rick P Edgecombe <rick.p.edgecombe@intel.com>
Cc: Kai Huang <kai.huang@intel.com>, 
	"federico.parola@polito.it" <federico.parola@polito.it>, 
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "dmatlack@google.com" <dmatlack@google.com>, 
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, Isaku Yamahata <isaku.yamahata@intel.com>, 
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "michael.roth@amd.com" <michael.roth@amd.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Apr 15, 2024, Rick P Edgecombe wrote:
> On Mon, 2024-04-15 at 14:17 -0700, Sean Christopherson wrote:
> > > But doesn't the fault handler need the vCPU state?
> >=20
> > Ignoring guest MTRRs, which will hopefully soon be a non-issue, no.=C2=
=A0 There are
> > only six possible roots if TDP is enabled:
> >=20
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 1. 4-level !SMM !guest_mode
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 2. 4-level=C2=A0 SMM !guest_mode
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 3. 5-level !SMM !guest_mode
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 4. 5-level=C2=A0 SMM !guest_mode
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 5. 4-level !SMM guest_mode
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 6. 5-level !SMM guest_mode
> >=20
> > 4-level vs. 5-level is a guest MAXPHYADDR thing, and swapping the MMU
> > eliminates the SMM and guest_mode issues.=C2=A0 If there is per-vCPU st=
ate that
> > makes its way into the TDP page tables, then we have problems, because =
it
> > means that there is per-vCPU state in per-VM structures that isn't
> > accounted for.
> >=20
> > There are a few edge cases where KVM treads carefully, e.g. if the faul=
t is
> > to the vCPU's APIC-access page, but KVM manually handles those to avoid
> > consuming per-vCPU state.
> >=20
> > That said, I think this option is effectively 1b, because dropping the =
SMM
> > vs.  guest_mode state has the same uAPI problems as forcibly swapping t=
he
> > MMU, it's just a different way of doing so.
> >=20
> > The first question to answer is, do we want to return an error or
> > "silently" install mappings for !SMM, !guest_mode.=C2=A0 And so this op=
tion
> > becomes relevant only _if_ we want to unconditionally install mappings =
for
> > the 'base" mode.
>=20
> Ah, I thought there was some logic around CR0.CD.

There is, but it's hopefully going the way of the dodo, along with full MTR=
R
virtualization:

https://lore.kernel.org/all/20240309010929.1403984-1-seanjc@google.com

