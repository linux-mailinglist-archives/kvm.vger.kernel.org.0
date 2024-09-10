Return-Path: <kvm+bounces-26182-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id B3B319726B6
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 03:46:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5E8721F242E6
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 01:46:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 582F013A418;
	Tue, 10 Sep 2024 01:46:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="N1b4DH76"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34A754D8B7
	for <kvm@vger.kernel.org>; Tue, 10 Sep 2024 01:46:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725932771; cv=none; b=DenJQwIkrqwUT6eJ+6vyyQ5XJcyI356wqx2ygCNcgfeMBl+EOCeLM0psFE3LOIXUQkcYdqF9LHRm1Sb+MYaMh35R0+Yx5ddoySq9MoxxmXkc8FCDUovAm3GlvPXYO+MTPZhFgBqw89ljLVslug5JcGEa9Y/8NHY1mNHU4aitjWE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725932771; c=relaxed/simple;
	bh=+qpnK1raOuYaMboHxtjYJpJSIG+2da+1uWMPuTSJl7E=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=GRdsl2W9FuGY2rqLx/1yim8Iyz3AQLfodWMZkmKfYblbEsWGbrVb15BSeA9qLjZCaTaL3TL9w4ofVuDLYstrWBPyFCe40OdCxw7zZHXGb9Hf4PGYanDF8XckHHPxT1JeFRV+GZtcet7oQs6i82dE/PYP1lKQdo5zxXjDSGjRUt0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=N1b4DH76; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2d89dacf002so6094643a91.3
        for <kvm@vger.kernel.org>; Mon, 09 Sep 2024 18:46:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1725932769; x=1726537569; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Yr9sxEZXrJXjhSaDYvUGo+oh8d4JFNbqBOnaKKPd+Ws=;
        b=N1b4DH76GG4mKoxbOmmyXuj3uLjOncnL6Hig1jeP30dg8HYSIOaqyEFG3BseY75mUk
         a28sVjgbeGKO757HhrkoPPogKyAGgLOneUvX9numnmyaLniOVgTOHFvc/xMlrpA6uUCG
         7Ranlp3A9zruQcxfIdw26cLLmiakrBJ6xGibg88LMKkHBIZuTZr3o9C1APhNUmAkIh49
         9T3wusxWMOeXEzyp8GWN8M/UB3aSNHaDVWDcDbufR7yPxlOtK2UN5PtZOgbsYR/iLgrr
         HHCicqzyJiJ0RGFcHISx2gFOPK8v6UgURm4Clnl2/XLNP8aASIopB5XjhZOCft09Eneg
         5CGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725932769; x=1726537569;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Yr9sxEZXrJXjhSaDYvUGo+oh8d4JFNbqBOnaKKPd+Ws=;
        b=GDqdft53ZYc+p5MyAPNIbJ4iV0gaNb8IDt6SSbaJMcfPgF1+CR0cuF6XYGYgnkbYqT
         Pb3dMQOqH6hGsruwkF4R4kfuRqCjOzWQYbwmOpBvQeeBhvNG2juuLN4XI/vY8BDwAckq
         WCmJvJ7fUZfH6faC9UdiLJgefromMV4iW9Rtz0Hi9bNB/HaiDZIWPF+fk9+rL2eEdily
         kMFehvooRamEotGI3UGkHZCLbFjDYuDqqhZh3/fvV8nH0hTIwjzFkDW4d4s9+SRLv3TC
         8fmuflFYCPt5kzlSguspAs3Fcu8knpKW3L+sxuFMhj7Kw3HA/iU4jA8l0zoy6WZqqdW0
         WtBw==
X-Forwarded-Encrypted: i=1; AJvYcCVApuv1hJ3j/4lGEk5CmN2BeuqRLlSGvOY5X5gjOj/RAmurS+MO/XNMLTXllt657drAF0k=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz2sVjCmRFa9N3gWhw71HfUyCsyfT8q0LLidVhWe1KwyXp4Xxs+
	xfmgIYWiExPraSSRJDqxRK0S753+2nxYH1jX3Nw1+jK2tVPNWqss5reghWgX9Hd2/5FhjFf+7pG
	sAg==
X-Google-Smtp-Source: AGHT+IFHED3XV0tIgtNybDwjKcpW59AuhS6hl2FC+pnGgwepVfaU/hpmfyvrW0Cu/KZvaijCIf6Wajq3JXk=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:b013:b0:2d8:9da6:cb50 with SMTP id
 98e67ed59e1d1-2dad5178e42mr120371a91.8.1725932769379; Mon, 09 Sep 2024
 18:46:09 -0700 (PDT)
Date: Mon, 9 Sep 2024 18:46:07 -0700
In-Reply-To: <639496dd9507b09e83d728de0ee9eccccf951da4.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240904030751.117579-1-rick.p.edgecombe@intel.com>
 <20240904030751.117579-10-rick.p.edgecombe@intel.com> <6449047b-2783-46e1-b2a9-2043d192824c@redhat.com>
 <b012360b4d14c0389bcb77fc8e9e5d739c6cc93d.camel@intel.com>
 <Zt9kmVe1nkjVjoEg@google.com> <Zt9nWjPXBC8r0Xw-@google.com>
 <72ef77d580d2f16f0b04cbb03235109f5bde48dd.camel@intel.com>
 <Zt-LmzUSyljHGcMO@google.com> <639496dd9507b09e83d728de0ee9eccccf951da4.camel@intel.com>
Message-ID: <Zt-k30MHhMTxpFKQ@google.com>
Subject: Re: [PATCH 09/21] KVM: TDX: Retry seamcall when TDX_OPERAND_BUSY with
 operand SEPT
From: Sean Christopherson <seanjc@google.com>
To: Rick P Edgecombe <rick.p.edgecombe@intel.com>
Cc: "pbonzini@redhat.com" <pbonzini@redhat.com>, Yuan Yao <yuan.yao@intel.com>, 
	Kai Huang <kai.huang@intel.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Yan Y Zhao <yan.y.zhao@intel.com>, 
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "dmatlack@google.com" <dmatlack@google.com>, 
	"nik.borisov@suse.com" <nik.borisov@suse.com>, 
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 10, 2024, Rick P Edgecombe wrote:
> On Mon, 2024-09-09 at 16:58 -0700, Sean Christopherson wrote:
> > On Mon, Sep 09, 2024, Rick P Edgecombe wrote:
> > > On Mon, 2024-09-09 at 14:23 -0700, Sean Christopherson wrote:
> > > > > In general, I am _very_ opposed to blindly retrying an SEPT SEAMC=
ALL,
> > > > > ever.=C2=A0 For its operations, I'm pretty sure the only sane app=
roach is for
> > > > > KVM to ensure there will be no contention.=C2=A0 And if the TDX m=
odule's
> > > > > single-step protection spuriously kicks in, KVM exits to userspac=
e.=C2=A0 If
> > > > > the TDX module can't/doesn't/won't communicate that it's mitigati=
ng
> > > > > single-step, e.g. so that KVM can forward the information to user=
space,
> > > > > then that's a TDX module problem to solve.
> > > > >=20
> > > > > > Per the docs, in general the VMM is supposed to retry SEAMCALLs=
 that
> > > > > > return TDX_OPERAND_BUSY.
> > > > >=20
> > > > > IMO, that's terrible advice.=C2=A0 SGX has similar behavior, wher=
e the xucode
> > > > > "module" signals #GP if there's a conflict.=C2=A0 #GP is obviousl=
y far, far
> > > > > worse as it lacks the precision that would help software understa=
nd
> > > > > exactly what went wrong, but I think one of the better decisions =
we made
> > > > > with the SGX driver was to have a "zero tolerance" policy where t=
he
> > > > > driver would _never_ retry due to a potential resource conflict, =
i.e.
> > > > > that any conflict in the module would be treated as a kernel bug.
> > >=20
> > > Thanks for the analysis. The direction seems reasonable to me for thi=
s lock
> > > in
> > > particular. We need to do some analysis on how much the existing mmu_=
lock
> > > can
> > > protects us.=20
> >=20
> > I would operate under the assumption that it provides SEPT no meaningfu=
l
> > protection.
> > I think I would even go so far as to say that it is a _requirement_ tha=
t
> > mmu_lock
> > does NOT provide the ordering required by SEPT, because I do not want t=
o take
> > on
> > any risk (due to SEPT constraints) that would limit KVM's ability to do=
 things
> > while holding mmu_lock for read.
>=20
> Ok. Not sure, but I think you are saying not to add any extra acquisition=
s of
> mmu_lock.

No new write_lock.  If read_lock is truly needed, no worries.  But SEPT nee=
ding
a write_lock is likely a hard "no", as the TDP MMU's locking model depends
heavily on vCPUs being readers.  E.g. the TDP MMU has _much_ coarser granul=
arity
than core MM, but it works because almost everything is done while holding
mmu_lock for read.

> Until we answer some of the questions (i.e. HOST_PRIORITY exposure), it's=
 hard
> to say. We need to check some stuff on our end.

Ya, agreed.

