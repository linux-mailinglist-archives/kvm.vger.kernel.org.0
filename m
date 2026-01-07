Return-Path: <kvm+bounces-67236-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id A3813CFEC2F
	for <lists+kvm@lfdr.de>; Wed, 07 Jan 2026 17:02:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 145E130019E9
	for <lists+kvm@lfdr.de>; Wed,  7 Jan 2026 16:02:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E7C2C3876AE;
	Wed,  7 Jan 2026 15:55:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="S8kAnC8p"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E91E3A97F8
	for <kvm@vger.kernel.org>; Wed,  7 Jan 2026 15:54:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767801306; cv=none; b=dP8Cc24CFRRMOdzWoPMrNYJLzue14VccGDUihhGH+YL7h+a5mUqI351oVzcbOiue2zdF8wOJni/D/5eZ2LsXPpxb8+nUY+WUnKTiAeRLAR+zV+ns9R+8RHnJioA/HRwH9LV9G696wDF/wQRqzgDewJnv3fb5/XBg8FcouAX3+Mo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767801306; c=relaxed/simple;
	bh=yXyephpPsv2jEvNRfKQKQirxxpGxIV/ri/oUYID04Lo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=mcZ+7V00Av38nSpIeq+cuUvV/plTucal4/AOghrLN6h5e383PAT7xqccRV+YFsWQ8kx85QD7r5qxgpciATQc4u8mSMQGffkuZ2N8XgoQU7krvniCgblGPyG8+bU4XfzzwZS0YxE8O6YwhO+w98oY3R2Sc/TXavYwfU83cNGo0Ac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=S8kAnC8p; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-7b952a966d7so4541782b3a.3
        for <kvm@vger.kernel.org>; Wed, 07 Jan 2026 07:54:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767801295; x=1768406095; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=KGDxiUzmOiqUqvFGIUEpvgOPKZQcr6FM34ff6SZAbo8=;
        b=S8kAnC8ptdPgvVS0TAePJlKqiayWvABWD0EHRv4VpmejkVID7qdCBbjgaQ7OqJjk8x
         PN1lHi+XKn+UK18JbaWqpodcBxF39LbP++9qHXQD5EnTA4bM+CC0NNPiAS3Ed1nHFj9y
         euU1GiZlzc2O4w81+2v0B6Vfl56JwHMhrx6WeVVyQgD8irLYRWKKRNWLUeVNXZT+zVS0
         4VCYtxKP3otQKmOws+lMhB/Z9aiaBB2ye3GXl8AcLzAXSz0DqDVRpEj0eTJryPpeNq2K
         0wd5WmG/JAoV09mik412hikKlZ2Xsr+d2t7b/jBCNyWCYoRtwNtrA/v4CyWTocxQ/H8F
         peSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767801295; x=1768406095;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=KGDxiUzmOiqUqvFGIUEpvgOPKZQcr6FM34ff6SZAbo8=;
        b=ZtF52empqOx9/dFRxxU+QxjROl2DokbbBRUTDS2XIbim08PRNb3aNo4sCn0ZOWPITl
         bWNHgtwoAHbVMYWR7hiZngCuaA9aCOAocyNbUsrLMjv916HUsNmvLF4cBuR2M722KVVn
         zFEXLXFbMkg0AW7ZJKs6WiIH3HPBaTsJL6FGzjp7ciyeg0KBJj4t32I2lO58OHnleNFi
         WV+bsVROzmlph6ElI9zo+sDW0yZSbAVgaVL/OaSTtp8wv+zMj+jZQJGBiwoVyY9x+ZnP
         vjkpdcNegQa1IInKb3Ega9fJH+dxhQdBnogzLyEgUbJF90QRhtxaieDVV0pEr+gEHINe
         /FeQ==
X-Forwarded-Encrypted: i=1; AJvYcCXq+vTQF4n/ElWxckKSYHp8buLJ0K9zLRor7RdOC68jUT5sT2s3dey5IrptR/bbPu2fbUM=@vger.kernel.org
X-Gm-Message-State: AOJu0YzoRmkgLrSvYJKsG1E+A6nyAAAsg9yZyKVafnPe4SBysonJPd7P
	kYdnMqI30zzyNc8JTHTiuw2OcwRVDmMGqdpErwlTB9Px7Vof9sTVYqxaSOwM7q6KIbu2JAl5hn4
	JrtsRKg==
X-Google-Smtp-Source: AGHT+IHqGFGS6LAIDF1DwPZvkOWcGq1Um8q0uNPgRXMhHrxgju2ZXystVmcBRs3crGdS6VopTdlgO395eMw=
X-Received: from pfaf9.prod.google.com ([2002:a05:6a00:a119:b0:7dd:8bba:639d])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:4089:b0:7e8:43f5:bd28
 with SMTP id d2e1a72fcca58-81b7fdc968fmr3065457b3a.61.1767801295223; Wed, 07
 Jan 2026 07:54:55 -0800 (PST)
Date: Wed, 7 Jan 2026 07:54:53 -0800
In-Reply-To: <20260105074814.GA10215@k08j02272.eu95sqa>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231107202002.667900-1-aghulati@google.com> <CAJhGHyBtis3SkNZP8RSX5nKFcnQ4qvUrfTMD2RPc+w+Rzf30Zw@mail.gmail.com>
 <ZWYtDGH5p4RpGYBw@google.com> <20260105074814.GA10215@k08j02272.eu95sqa>
Message-ID: <aV6BzSbAjZJGJ-D5@google.com>
Subject: Re: [RFC PATCH 00/14] Support multiple KVM modules on the same host
From: Sean Christopherson <seanjc@google.com>
To: Hou Wenlong <houwenlong.hwl@antgroup.com>
Cc: Lai Jiangshan <jiangshanlai@gmail.com>, Anish Ghulati <aghulati@google.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, hpa@zytor.com, 
	Vitaly Kuznetsov <vkuznets@redhat.com>, peterz@infradead.org, paulmck@kernel.org, 
	Mark Rutland <mark.rutland@arm.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 05, 2026, Hou Wenlong wrote:
> Sorry for revisiting this topic after a long time. I haven't seen any
> new updates regarding this topic/series, and I didn=E2=80=99t find any re=
cent
> activity on the GitHub repository. Is the multi-KVM topic still being
> considered for upstreaming, or is there anything blocking this?

We have abandoned upstreaming multi-KVM.  The operational cost+complexity i=
s too
high relative to the benefits, especially when factoring in things like ASI=
 and
live patching, and the benefits are almost entirely obsoleted by kernel liv=
e update
support.

> As Lai pointed out, we also have a similar multi-KVM implementation in
> our internal environment, so we are quite interested in this topic.
> Recently, when we upgraded our kernel version, we found that maintaining
> multi-KVM has become a significant burden.

Yeah, I can imagine the pain all too well.  :-/

> We are willing to move forward with it if multi-KVM is still accepted for
> upstream. So I look forward to feedback from the maintainers.
>
> From what I've seen, the recent patch set that enables VMX/SVM during
> booting is a good starting point for multi-KVM as well.

I have mixed feelings on multi-KVM.  Without considering maintenance and su=
pport
costs, I still love the idea of reworking the kernel to support running mul=
tiple
hypervisors concurrently.  But as I explained in the first cover letter of =
that
series[0], there is a massive amount of complexity, both in initial develop=
ment
and ongoing maintenance, needed to provide such infrastructure:

 : I got quite far long on rebasing some internal patches we have to extrac=
t the
 : core virtualization bits out of KVM x86, but as I paged back in all of t=
he
 : things we had punted on (because they were waaay out of scope for our ne=
eds),
 : I realized more and more that providing truly generic virtualization
 : instrastructure is vastly different than providing infrastructure that c=
an be
 : shared by multiple instances of KVM (or things very similar to KVM)[1].
 :
 : So while I still don't want to blindly do VMXON, I also think that tryin=
g to
 : actually support another in-tree hypervisor, without an imminent user to=
 drive
 : the development, is a waste of resources, and would saddle KVM with a pi=
le of
 : pointless complexity.

For deployment to a relatively homogeneous fleet, many of the pain points c=
an be
avoided by either avoiding them entirely or making the settings "inflexible=
",
because there is effectively one use case and so such caveats are a non-iss=
ue.
But those types of simplifications don't work upstream, e.g. saying "eVMCS =
is
unsupported if multi-KVM is possible" instead of moving eVMCS enabling to a=
 base
module isn't acceptable.

So I guess my "official" stance is that I'm not opposed to upstreaming mult=
i-KVM
(or similar) functionality, but I'm not exactly in favor of it either.  And
practically speaking, because multi-KVM would be in constant conflict with =
so
much ongoing/new feature support (both in software and hardware), and is no=
t a
priority for anyone pursuing kernel live update, upstreaming would be likel=
y take
several years, without any guarantee of a successful landing.

[0] https://lore.kernel.org/all/20251010220403.987927-1-seanjc@google.com
[1] https://lore.kernel.org/all/aOl5EutrdL_OlVOO@google.com

