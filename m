Return-Path: <kvm+bounces-56190-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5F11EB3ACC8
	for <lists+kvm@lfdr.de>; Thu, 28 Aug 2025 23:35:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0A5E5583A7F
	for <lists+kvm@lfdr.de>; Thu, 28 Aug 2025 21:35:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 754082C0F60;
	Thu, 28 Aug 2025 21:34:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="XvPyhaow"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 474F0265CAD
	for <kvm@vger.kernel.org>; Thu, 28 Aug 2025 21:34:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756416896; cv=none; b=pQa2US9S5OgRmt0qircwbDTVCKGOWmP/zaIHBfo00EovKIWtAqSnUGlstPD80eDT1ePQTS0tK+3sEZgjJJ5tHVKgcI2fnMMzWlJycvacpy+BCeV+N2Ez0NcVbjhLmKO3hJZ85BAxOeOOSRkOVU9wQa85Y0+cGPgICFc1hkHmVPE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756416896; c=relaxed/simple;
	bh=OFGxQkja66u6g4m+YfBQP4bX3XbJCT3HITESY14dQ1M=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=qVSjaZj0d84QpoP6cQpfykwUcO9gAPhRr++5g2/4GkThei3a9JKGwIhxJAbqZtVrNBmIXTit/adoj3Tw5N+dBxB7Si1DB5uyfNhZi+4U1yB4hEil2tXQkCG6Vy0i4g/a490pmYUUjDL0xX40gZ9al4qLNPe5yXwTTbe43MBOSu0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=XvPyhaow; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-b4c54676185so1154208a12.3
        for <kvm@vger.kernel.org>; Thu, 28 Aug 2025 14:34:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1756416895; x=1757021695; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=P9gMVp6DPCDPNoXotxC8KMTvooZSthv5NZJDNr83Yc0=;
        b=XvPyhaowVwlz7MkNQdXje+MVLV/C+WJjAkZnzn8bEgj6j+tQlaWhLadyFd9s+sqLax
         EWQFIO2rFVqBi33ekBrOXqswYXzHmu/Fsy3xvHzNvY5pUbQaMBRANZLC+pHJSTFObkfG
         RDcbnB7gTKlKcGSq/qD1FN6JCnYfAkbQg+q0iXlYanaEiOIKJvjZ940UrUs+tJXvsX8w
         Zd1JteVHriAwVlPbtnPNXUu0+m73ch530SWi1xfcttd/aqmtJ2/6Ts9WwYSv10XQtPUW
         7o6AhiwS99pyGzrItSrmxuRCPyMpIwmGLKHNNadMGlP+C2EMmXGUqYiS+mydCvVaGDWQ
         b33w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756416895; x=1757021695;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=P9gMVp6DPCDPNoXotxC8KMTvooZSthv5NZJDNr83Yc0=;
        b=Fd310K5zSnLNux9mJmbMHIMvLVrWqzx1dwHnop7WAhwjSe/q/8C9gv/SqEV4fa3kfM
         4M9fLCi3ajuOVn1HqvfAFGfcnqDFZT4qSWhO5IzAy7fnJdWXLsM+c1tsrdeRgv+LCg6W
         wQXIVNUdsn+MCW51ovnSZAI/sTS4VzqPDL4DHLjU9wr3Pn9LFfAC6PxVKvHYZG4rpgeV
         aEUY8m7VUAMvJCkVH6Bwu2tpcFNbVWau1SfDHxjZTBc40eP8dFVTECoOWQX/SIaAQynl
         4YTmcT/5cpQE4cahd5gDTkPbDwdy47RBDFkohdyOWUW/eBtSNWw59IOZMbM/A2rq0Imy
         vKeg==
X-Gm-Message-State: AOJu0YzIELGZydBtQ0qBXkpTogLjNsgrBOzWci1ms5L6ziFaUkofPNbW
	YRs0U28UcehRiLCScNSqDYa3SPtNQ8uzvHUk7pl1DcWxqGCcqPbsvp9hPcbc5TpYjpAHDLacXu/
	zulHKWg==
X-Google-Smtp-Source: AGHT+IGi/GigvS1zrkttB799Bmjqo/nzAhrvA2gbkeJEt4vN4uB4gSmQQSwgtkWPD3wNpyUjBFNAB0mCIJQ=
X-Received: from pgbs63.prod.google.com ([2002:a63:5e42:0:b0:b4c:33f8:8904])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:3c8f:b0:243:78a:82bd
 with SMTP id adf61e73a8af0-24340da245fmr37806679637.55.1756416894639; Thu, 28
 Aug 2025 14:34:54 -0700 (PDT)
Date: Thu, 28 Aug 2025 14:34:53 -0700
In-Reply-To: <48743e1790220072c72d45af8d3582cdd25f4083.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250827000522.4022426-1-seanjc@google.com> <20250827000522.4022426-7-seanjc@google.com>
 <11edfb8db22a48d2fe1c7a871f50fc07b77494d8.camel@intel.com>
 <aLCsM6DShlGDxPOd@google.com> <9e55a0e767317d20fc45575c4ed6dafa863e1ca0.camel@intel.com>
 <aLDDYo-b5ES-KBWW@google.com> <48743e1790220072c72d45af8d3582cdd25f4083.camel@intel.com>
Message-ID: <aLDLfQc21DXnLwuR@google.com>
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
> On Thu, 2025-08-28 at 14:00 -0700, Sean Christopherson wrote:
> > But that's not actually what the code does.=C2=A0 The lockdep assert wo=
n't trip because
> > KVM never removes S-EPT entries under read-lock:
>=20
> Right
>=20
> >=20
> > 		if (is_mirror_sp(sp)) {
> > 			KVM_BUG_ON(shared, kvm);
> > 			remove_external_spte(kvm, gfn, old_spte, level);
> > 		}
> >=20
> > Not because KVM actually guarantees -EBUSY is avoided.=C2=A0 So the cur=
rent code is
> > flawed, it just doesn't cause problems.
>=20
> Flawed, as in the lockdep should assert regardless of EBUSY?

Yep, exactly.

> Seems good to me.
> Probably if we wanted to try to call tdx_sept_remove_private_spte() under=
 read
> lock with special plans to avoid EBUSY we should think twice anyway.

Heh, add a few zeros to "twice" :-D

