Return-Path: <kvm+bounces-26159-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 11FB897247F
	for <lists+kvm@lfdr.de>; Mon,  9 Sep 2024 23:23:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C48D3283FC3
	for <lists+kvm@lfdr.de>; Mon,  9 Sep 2024 21:23:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 60CA618C903;
	Mon,  9 Sep 2024 21:23:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="msz9c1cY"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19A7E18C326
	for <kvm@vger.kernel.org>; Mon,  9 Sep 2024 21:23:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725917022; cv=none; b=H6A++LxeVkUDihi8c6j6ahZhANERo7xAkXxZFJAErvV0ZHWXpAee9Wq35H5GE4GHQ7O0uRCHGA9gTvRY+wRP403irdvj3PHZRe/WkuTFBhGmgMGT9ioBR0bpCOv2SXm1DMxQlZ03hVwhE9v6KQBNYfELKBjquOsM8TlkO+v7/xk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725917022; c=relaxed/simple;
	bh=mljDDF3bZrXe8OPt/F+z1+NnngcpYJfMTt53T5T2P7U=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=RqxLzjP3NoHdbqOLpbtEyrmB2sjsYvsgGNX3L0ik2RXInybm5cjXwEObenl7LEGPmHnLfMKgGLAm9TYrXUhZYnkUe9rz1pAbdt4AcS/T6rdO/Xkj0wDnNAHJCONwx5pamHIMoH6tvJuFTIHl/cdbtLABaYORPQL9NaTyUL5+dAo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=msz9c1cY; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-7177906db91so4950360b3a.3
        for <kvm@vger.kernel.org>; Mon, 09 Sep 2024 14:23:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1725917020; x=1726521820; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ttDDMvpCe1uTBRkxLuXdyj12J9DRQh699r4t2hOkTYk=;
        b=msz9c1cYQF50yNo/uOl1gmQvBn8EQZbis6+dwXsOZm2Wd2TKvuFvHMfoMDkkXQY94N
         Qz1KGND1xCEfJoOpLiCLJ1/Fb0m+nc2NNXajcKg/bP00D06l5rWoQmsxuQ+TnWgWru5J
         sD+8UfY1c5d9x/E3wVOcZgdKWbbXhlMPkHWhhJ9y8zfpEY8Aj9qy8HUjnM0TSS6UDbya
         pdG+4FGDXcgwmBrZRlBUMKRN13ef6Zpz5M37RcDBsDp+lZ2NsYQA3Gq8uXqS6WKY2P4n
         F0Zaa/L7Twzybms6Qr3t5uE6aZsWyfN14Hj/cxVsqSqQw4v61gsjbuIB42zM+MhT4l4a
         a+4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725917020; x=1726521820;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=ttDDMvpCe1uTBRkxLuXdyj12J9DRQh699r4t2hOkTYk=;
        b=OLGYyEnmzZOjQnRtAphOACIS2Yndv85PFxb4Wv/IDLBLbpsRyavhT7nvrbHz3IkYDW
         Vc3Ryo7sGvIl5rTEzasgRbuRa+SKASCKlJrT7NqIdr3PbAEcYb1Gc061TKxD7hAKcZla
         e296g4wY6ToSXYbGKgOcNS1iY4Srf0sd53fF8G0PEuzfup7IxVXpGBiAYYy9krGm8L2G
         fiIkGqS5AFzrzpbQku7GUwvtwpZQVslhcxgLXningPy4cIYOZNtNRbg4VUX6+hxCOLNr
         hv7bH+YctIxh4O6n/O2SAidOKjFb6F2Wy5z1oLZqU1R9B+1pWIhrveovCeh9pzV7mrHZ
         T7OQ==
X-Gm-Message-State: AOJu0Yz0iXBCKeyFVgc7ze/suwruuSIFQX0VI0+1ULRXhStwjb4Vwk+8
	FwTg7p+8fg20s7gt9ncLYTkoFxP+vIGfCksbrFiJ2niJSl5AE7aA8JsJAekiX0CRwt1LhC5Nw1c
	4SQ==
X-Google-Smtp-Source: AGHT+IGjpBqwvM+xi0r8Nfsq0VH6VwEMC2N4ITsAAsIiJuo8lZuSHZUZJ7AOGfGx3hT9xfzLjcKqTCVnJzQ=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:8997:b0:718:13bc:913c with SMTP id
 d2e1a72fcca58-718f2e451fbmr13588b3a.0.1725917020107; Mon, 09 Sep 2024
 14:23:40 -0700 (PDT)
Date: Mon, 9 Sep 2024 14:23:38 -0700
In-Reply-To: <Zt9kmVe1nkjVjoEg@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240904030751.117579-1-rick.p.edgecombe@intel.com>
 <20240904030751.117579-10-rick.p.edgecombe@intel.com> <6449047b-2783-46e1-b2a9-2043d192824c@redhat.com>
 <b012360b4d14c0389bcb77fc8e9e5d739c6cc93d.camel@intel.com> <Zt9kmVe1nkjVjoEg@google.com>
Message-ID: <Zt9nWjPXBC8r0Xw-@google.com>
Subject: Re: [PATCH 09/21] KVM: TDX: Retry seamcall when TDX_OPERAND_BUSY with
 operand SEPT
From: Sean Christopherson <seanjc@google.com>
To: Rick P Edgecombe <rick.p.edgecombe@intel.com>
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com" <pbonzini@redhat.com>, 
	Yan Y Zhao <yan.y.zhao@intel.com>, Yuan Yao <yuan.yao@intel.com>, 
	"nik.borisov@suse.com" <nik.borisov@suse.com>, "dmatlack@google.com" <dmatlack@google.com>, 
	Kai Huang <kai.huang@intel.com>, "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 09, 2024, Sean Christopherson wrote:
> On Mon, Sep 09, 2024, Rick P Edgecombe wrote:
> > On Mon, 2024-09-09 at 17:25 +0200, Paolo Bonzini wrote:
> > > On 9/4/24 05:07, Rick Edgecombe wrote:
> > > > +static inline u64 tdx_seamcall_sept(u64 op, struct tdx_module_args=
 *in)
> > > > +{
> > > > +#define SEAMCALL_RETRY_MAX=C2=A0=C2=A0=C2=A0=C2=A0 16
> > >=20
> > > How is the 16 determined?=C2=A0 Also, is the lock per-VM or global?
> >=20
> > The lock being considered here is per-TD, but TDX_OPERAND_BUSY in gener=
al can be
> > for other locks. I'm not sure where the 16 came from, maybe Yuan or Isa=
ku can
> > share the history. In any case, there seems to be some problems with th=
is patch
> > or justification.
> >=20
> > Regarding the zero-step mitigation, the TDX Module has a mitigation for=
 an
> > attack where a malicious VMM causes repeated private EPT violations for=
 the same
> > GPA. When this happens TDH.VP.ENTER will fail to enter the guest. Regar=
dless of
> > zero-step detection, these SEPT related SEAMCALLs will exit with the ch=
ecked
> > error code if they contend the mentioned lock. If there was some other =
(non-
> > zero-step related) contention for this lock and KVM tries to re-enter t=
he TD too
> > many times without resolving an EPT violation, it might inadvertently t=
rigger
> > the zero-step mitigation.=C2=A0I *think* this patch is trying to say no=
t to worry
> > about this case, and do a simple retry loop instead to handle the conte=
ntion.
> >=20
> > But why 16 retries would be sufficient, I can't find a reason for. Gett=
ing this
> > required retry logic right is important because some failures
> > (TDH.MEM.RANGE.BLOCK) can lead to KVM_BUG_ON()s.
>=20
> I (somewhat indirectly) raised this as an issue in v11, and at a (very qu=
ick)
> glance, nothing has changed to alleviate my concerns.

Gah, went out of my way to find the thread and then forgot to post the link=
:

https://lore.kernel.org/all/Y8m34OEVBfL7Q4Ns@google.com

> In general, I am _very_ opposed to blindly retrying an SEPT SEAMCALL, eve=
r.  For
> its operations, I'm pretty sure the only sane approach is for KVM to ensu=
re there
> will be no contention.  And if the TDX module's single-step protection sp=
uriously
> kicks in, KVM exits to userspace.  If the TDX module can't/doesn't/won't =
communicate
> that it's mitigating single-step, e.g. so that KVM can forward the inform=
ation
> to userspace, then that's a TDX module problem to solve.
>=20
> > Per the docs, in general the VMM is supposed to retry SEAMCALLs that re=
turn
> > TDX_OPERAND_BUSY.
>=20
> IMO, that's terrible advice.  SGX has similar behavior, where the xucode =
"module"
> signals #GP if there's a conflict.  #GP is obviously far, far worse as it=
 lacks
> the precision that would help software understand exactly what went wrong=
, but I
> think one of the better decisions we made with the SGX driver was to have=
 a
> "zero tolerance" policy where the driver would _never_ retry due to a pot=
ential
> resource conflict, i.e. that any conflict in the module would be treated =
as a
> kernel bug.
>=20
> > I think we need to revisit the general question of which
> > SEAMCALLs we should be retrying and how many times/how long. The other
> > consideration is that KVM already has per-VM locking, that would preven=
t
> > contention for some of the locks. So depending on internal details KVM =
may not
> > need to do any retries in some cases.
>=20
> Yes, and if KVM can't avoid conflict/retry, then before we go any further=
, I want
> to know exactly why that is the case.

