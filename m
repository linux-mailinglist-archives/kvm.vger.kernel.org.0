Return-Path: <kvm+bounces-17021-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0832A8C0036
	for <lists+kvm@lfdr.de>; Wed,  8 May 2024 16:38:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B73CF288903
	for <lists+kvm@lfdr.de>; Wed,  8 May 2024 14:38:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 86D74126F05;
	Wed,  8 May 2024 14:38:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="uPtt3h1P"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 672F685280
	for <kvm@vger.kernel.org>; Wed,  8 May 2024 14:38:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715179095; cv=none; b=O6NR10f5rkX+OZt7JJJJPLDDyStOyfndakYGL2qgry64ZLRU/BxLKCq0RgRqZI5Hf1g2tGfDq2BNM6DjKWlK/jWhwJ1cWhbnfJw7Y4GWjG/IuqjvCLhWr1JojAERQCm+jgbGhzTGhCwpFR1nOa3PKvZRZkRrnVn8gJbPQSn9bSo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715179095; c=relaxed/simple;
	bh=aFboWOrm7H2FhmOYJG+9bfDnrcpnZ8PDxm7a8GEEJ4g=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=kbPhN2p2RDFU2Vk7IxgDz6D6oD2bhbY2WacF2Tkb+bUJzSc1unh6Tm+5IVCFEO6TpRDo0QzG/n489S7FnwBzek44RkAEFyjryectwlp1hyIqzvRVCYuZ7DF/uxyK+pYnFNnxDnDsDHQTus6KG8BdMcHuXEKM574A8+9ScOmDJ2k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=uPtt3h1P; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-6f4574f6bffso3229096b3a.1
        for <kvm@vger.kernel.org>; Wed, 08 May 2024 07:38:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1715179094; x=1715783894; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5RcWN2WrSwXdTO88vEMTaGe9Rxg692ER5j0jmQd42is=;
        b=uPtt3h1PkOXIdJcvlsb/xZ1fOtiQrUwJ0XHavUZuG4P0COu80adKXoIuF5A4NZdETE
         qJBtAZ1A9iwWBXKRwBo8//GWhu08ddvLcB2Z1MDDdVRdmfFD/AzGmjJl1M5XCya9RI8m
         pwIAfQLmE3vFVgGTJsdQmMowIMt0dgULbJixJn4hAQt3dnQHoFpqQ04pcxrh3z/N16ga
         9qPyCc6+KnlhrGgAMu2fY+JwoBLOPq/a05Ft77aJgavaA6ecZACQQ76DV/lGGZ906dkp
         bnoH1Vwsrh099J84CJvvsldAM75/N7RLnluJ58QoJYi4l3b7rB0O8eHzr/1SHgle9s0i
         5O9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715179094; x=1715783894;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=5RcWN2WrSwXdTO88vEMTaGe9Rxg692ER5j0jmQd42is=;
        b=EbFC7aj7FlJPxCDCH+TBontMzI3JYnqO6Vo4VzAMSj6SW60ESJTLTk1oy/wlcTS4XE
         uQyuVGEnq888di+MHOB2ywMPkpafYVpaBndPvdvQ979GetUzwWqd4NxoNoXfiCQsj5Tr
         bitmiplleTUzUBCYUzWR+R/JUKg20XeH3VrI3qQIuIVfnpPmrH9vAQCOaTaG2roQQjbq
         yXY985FkMY4Klj+gwLgWNi0VRITsNs2RcacLi6xKkpUEx0Ur2uMmozZntW2k5LhAsReT
         e8MF66+dEzGB284dZRtDAsXwU96sOrjgi/rfesRTMCWDJOY9SzBKFfl9CPCuYXyT+HUn
         Hu3Q==
X-Gm-Message-State: AOJu0Yx/SKdL6lMePDZTLgCRvX1eexGZ5uM+N7JK3C354gW1dGlezCBq
	yNrWHI50o7YQx6GlPj9J89TddQlO/VEB8xZh+1kli/RxTQNdJyjzN0/nRewxg5zc2NrQ+rcQAmH
	ulQ==
X-Google-Smtp-Source: AGHT+IFb9xiTfYWH9jIPK1qzK+/iXw5uiqVvO4vj4lyx5XChVOy/r2TZEomHsvP4cE1UI2BIBiEewlzEsxU=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:1414:b0:6ea:ad01:358f with SMTP id
 d2e1a72fcca58-6f49c30dd08mr57761b3a.6.1715179093524; Wed, 08 May 2024
 07:38:13 -0700 (PDT)
Date: Wed, 8 May 2024 07:38:11 -0700
In-Reply-To: <2c8cf51456efab39beb8b4af75fc0331d7902542.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240404121327.3107131-1-pbonzini@redhat.com> <20240404121327.3107131-8-pbonzini@redhat.com>
 <43d1ade0461868016165e964e2bc97f280aee9d4.camel@intel.com>
 <ZhSYEVCHqSOpVKMh@google.com> <b4892d4cb7fea466fd82bcaf72ad3b29d28ce778.camel@intel.com>
 <ZjrFblWaPNwXe0my@google.com> <2c8cf51456efab39beb8b4af75fc0331d7902542.camel@intel.com>
Message-ID: <ZjuOUzhVIgkAQXmf@google.com>
Subject: Re: [PATCH v5 07/17] KVM: x86: add fields to struct kvm_arch for CoCo features
From: Sean Christopherson <seanjc@google.com>
To: Rick P Edgecombe <rick.p.edgecombe@intel.com>
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com" <pbonzini@redhat.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Yan Y Zhao <yan.y.zhao@intel.com>, 
	"michael.roth@amd.com" <michael.roth@amd.com>, Isaku Yamahata <isaku.yamahata@intel.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Wed, May 08, 2024, Rick P Edgecombe wrote:
> On Tue, 2024-05-07 at 17:21 -0700, Sean Christopherson wrote:
> > > Can you elaborate on the reason for a per-memslot flag? We are discus=
sing
> > > this
> > > design point internally, and also the intersection with the previous
> > > attempts to
> > > do something similar with a per-vm flag[0].
> > >=20
> > > I'm wondering if the intention is to try to make a memslot flag, so i=
t can
> > > be
> > > expanded for the normal VM usage.
> >=20
> > Sure, I'll go with that answer.=C2=A0 Like I said, off-the-cuff.
> >=20
> > There's no concrete motiviation, it's more that _if_ we're going to exp=
ose
> > a knob to userspace, then I'd prefer to make it as precise as possible =
to
> > minimize the changes of KVM ending up back in ABI hell again.
> >=20
> > > Because the discussion on the original attempts, it seems safer to ke=
ep this
> > > behavior more limited (TDX only) for now.=C2=A0 And for TDX's usage a=
 struct kvm
> > > bool fits best because all memslots need to be set to zap_leafs_only =
=3D true,
> > > anyway.
> >=20
> > No they don't.=C2=A0 They might be set that way in practice for QEMU, b=
ut it's
> > not strictly required.=C2=A0 E.g. nothing would prevent a VMM from expo=
sing a
> > shared- only memslot to a guest.=C2=A0 The memslots that burned KVM the=
 first
> > time around were related to VFIO devices, and I wouldn't put it past
> > someone to be crazy enough
> > to expose an passhtrough an untrusted device to a TDX guest.
>=20
> Ok, thanks for clarification. So it's more of a strategic thing to move m=
ore
> zapping logic into userspace so the logic can change without introducing =
kernel
> regressions.

You're _really_ reading too much into my suggestion.  As above, my suggesti=
on
was very spur of the momemnt.  I haven't put much thought into the tradeoff=
s and
side effects.

