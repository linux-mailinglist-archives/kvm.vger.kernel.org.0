Return-Path: <kvm+bounces-26875-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2EA26978B50
	for <lists+kvm@lfdr.de>; Sat, 14 Sep 2024 00:19:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BA54E282C87
	for <lists+kvm@lfdr.de>; Fri, 13 Sep 2024 22:19:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2222C1714C1;
	Fri, 13 Sep 2024 22:18:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="1ZgurxCk"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E83EC1494CE
	for <kvm@vger.kernel.org>; Fri, 13 Sep 2024 22:18:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726265931; cv=none; b=Q8/XUhQDjuAoctXwhih7FrIW3+PJtAzGp0uYm47zDUOQBpCmjhC5ZfEIbciOHUd4fFijdeJigmCVNX3ca5UDDVqSDRstut/ppN1r99zhGtlAQGuYqNabtjfbwavJQc6EDjobhh0Jk3OFRQkxvBVlDl63ARGWj83Z+c7+VArWttE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726265931; c=relaxed/simple;
	bh=LmaUTuFuTcc7yU1/rC/EbHxZ+OomwmkfIy/uLqa79o4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=O5pdYS86h8vCZrnMqxg51aSH7LLehJ/MA+bSoInozPmA/M1JwvSl3Ew+7jvFMfF7jhEm/vFRG1KZjyjRCZStLkfDxTcP+PJbXqDcR6aHO0PmZhOEetH50vwLZEeRWr7ZA7XPaTvkw+g25OY7vvaJ8K4YtleqPtXhHK01GqfvZDY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=1ZgurxCk; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-206e07915c2so12780735ad.3
        for <kvm@vger.kernel.org>; Fri, 13 Sep 2024 15:18:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1726265929; x=1726870729; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+lg7W1reJVaCd4w6Hfmv7NNUvMMjgh2a3fstO+opB70=;
        b=1ZgurxCkeoPpHBGL8+xiUO5YvtMgFqVmhM5rn+BqIk7BI15EDVWuW+kR6bPdm2GhLH
         fMCxi+I655025wJPcv/3E/oTKJFi56B4WFA08R6UBNlEnS/FVrcAEMUjnm8gmTb5X3xC
         8psaYX2W6s3l0a5ct9o/s6/C2ZwrCV3xAjW3y4V0TsS0te6o8kINLhfxZe6pVLYnggrs
         YJY0wfpeGT0bJbwhiIRJdme0bPSgfihylJHyAoBsXVq3Nrw0MV865mg6SpzFCfGStXfL
         mQpnGT1p2xhzpfWpITOfn0N0YbzZgGFLqM1L7Atq6bvPPxE9NqW/xl5Fw79DzB45Bu89
         DRAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726265929; x=1726870729;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=+lg7W1reJVaCd4w6Hfmv7NNUvMMjgh2a3fstO+opB70=;
        b=XaIuFejL8syoaK3yAlWK+Tb87lt+9vnvqwOJVjoS4tS8hnfGX4RVg8knXYumrTtKvj
         yi6mfyNnrOHGXYx/KaRjVNsuNXYyRIV/GFFQf6VxFe6CqlzY7qWBvqY85y2m2/KAb7OX
         hyaaFe/Z/aLd2oaYLd/sf5D4Q7Dwytv2YHZvswGGHFrgmELHaEaWyPr9+Pos5sV+gthr
         OTlwVPNcjm0Z/C8WqKXpvPtLQ072q7t1p6TgCypHq7QFYkc/dFFLLZPNjBu4G7wx9wVd
         oGIgcn6UFryQds2aqZfybzUAxu1Cxu04HXlwmQxQh7iJPPLCxKXnJqrd7HpZ+6agVwHI
         QoGg==
X-Forwarded-Encrypted: i=1; AJvYcCW4+q8ZS2d0eTDNo95NLimo93ab8tUc/5HWKAKqTwBaCQzyIZ5tXvMYDC0KNzjcpiqyVso=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw4enQ9I2I2bH0JIuvB0pwj9w5TGh59gb4r7cRsZhDMnkLnxabo
	BOGNBFs/MANDturbjvC+aXCnn2PfyevEFUfQLn5fMUDK/JgGoXIRMLqniCo6V3i+B0ONuGDZmzZ
	CfA==
X-Google-Smtp-Source: AGHT+IH9nbs5qdnvPw/8oHJxe8p1ZkwaRp91F5WWmtNygJRvhBnyirrYyU1Y03XGMM+hBPA5K0pbtdebSjk=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:ecd0:b0:206:b8b7:859 with SMTP id
 d9443c01a7336-2078296043amr1970935ad.7.1726265929074; Fri, 13 Sep 2024
 15:18:49 -0700 (PDT)
Date: Fri, 13 Sep 2024 15:18:47 -0700
In-Reply-To: <4bed8c0579298fbb0767c04b75cc9c3be0e925ad.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <Zt9kmVe1nkjVjoEg@google.com> <1bbe3a78-8746-4db9-a96c-9dc5f1190f16@redhat.com>
 <ZuBQYvY6Ib4ZYBgx@google.com> <CABgObfayLGyWKERXkU+0gjeUg=Sp3r7GEQU=+13sUMpo36weWg@mail.gmail.com>
 <ZuBsTlbrlD6NHyv1@google.com> <655170f6a09ad892200cd033efe5498a26504fec.camel@intel.com>
 <ZuCE_KtmXNi0qePb@google.com> <ZuP5eNXFCljzRgWo@yzhao56-desk.sh.intel.com>
 <ZuR09EqzU1WbQYGd@google.com> <4bed8c0579298fbb0767c04b75cc9c3be0e925ad.camel@intel.com>
Message-ID: <ZuS6R2kuGHQQqkEw@google.com>
Subject: Re: [PATCH 09/21] KVM: TDX: Retry seamcall when TDX_OPERAND_BUSY with
 operand SEPT
From: Sean Christopherson <seanjc@google.com>
To: Rick P Edgecombe <rick.p.edgecombe@intel.com>
Cc: Yan Y Zhao <yan.y.zhao@intel.com>, Yuan Yao <yuan.yao@intel.com>, 
	Kai Huang <kai.huang@intel.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>, 
	"dmatlack@google.com" <dmatlack@google.com>, "nik.borisov@suse.com" <nik.borisov@suse.com>, 
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Sep 13, 2024, Rick P Edgecombe wrote:
> On Fri, 2024-09-13 at 10:23 -0700, Sean Christopherson wrote:
> > > TL;DR:
> > > - tdh_mem_track() can contend with tdh_vp_enter().
> > > - tdh_vp_enter() contends with tdh_mem*() when 0-stepping is suspecte=
d.
> >=20
> > The zero-step logic seems to be the most problematic.=C2=A0 E.g. if KVM=
 is trying
> > to

I am getting a feeling of deja vu.  Please fix your mail client to not gene=
rate
newlines in the middle of quoted text.

> > install a page on behalf of two vCPUs, and KVM resumes the guest if it
> > encounters a FROZEN_SPTE when building the non-leaf SPTEs, then one of =
the
> > vCPUs could trigger the zero-step mitigation if the vCPU that "wins" an=
d
> > gets delayed for whatever reason.
>=20
> Can you explain more about what the concern is here? That the zero-step
> mitigation activation will be a drag on the TD because of extra contentio=
n with
> the TDH.MEM calls?
>=20
> >=20
> > Since FROZEN_SPTE is essentially bit-spinlock with a reaaaaaly slow
> > slow-path, what if instead of resuming the guest if a page fault hits
> > FROZEN_SPTE, KVM retries the fault "locally", i.e. _without_ redoing
> > tdh_vp_enter() to see if the vCPU still hits the fault?
>=20
> It seems like an optimization. To me, I would normally want to know how m=
uch it
> helped before adding it. But if you think it's an obvious win I'll defer.

I'm not worried about any performance hit with zero-step, I'm worried about=
 KVM
not being able to differentiate between a KVM bug and guest interference.  =
The
goal with a local retry is to make it so that KVM _never_ triggers zero-ste=
p,
unless there is a bug somewhere.  At that point, if zero-step fires, KVM ca=
n
report the error to userspace instead of trying to suppress guest activity,=
 and
potentially from other KVM tasks too.

It might even be simpler overall too.  E.g. report status up the call chain=
 and
let the top-level TDX S-EPT handler to do its thing, versus adding various =
flags
and control knobs to ensure a vCPU can make forward progress.

