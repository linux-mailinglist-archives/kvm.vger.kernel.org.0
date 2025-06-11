Return-Path: <kvm+bounces-49090-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 1C25FAD5C14
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 18:26:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 592451893224
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 16:26:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 675EE1EE02F;
	Wed, 11 Jun 2025 16:26:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="zB5Vnq3T"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2461A1E8837
	for <kvm@vger.kernel.org>; Wed, 11 Jun 2025 16:26:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749659180; cv=none; b=GgimiOjSD+sAM1EEGFF5P5aIVQ59IvN+91+0l7i+fp/25JMvlBdmDr7FaQWVu07+A/XBcOnMarodDwtqGnejwRj6DIQJFUy/2zOY8RolbOZz35b7B/M2oKLrAL+Ej1DfFB49smXb2sbtqIdS1xLWc8uJ3WIuSX3gXpkW2M38Um0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749659180; c=relaxed/simple;
	bh=1ATIAtScEwv8MflLrosr1hnS8gOgGORCXCED04okpVY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=iDqYkXuMXr5xjqmB4QVkIAYy3vMt0PwslOJCoUwdkLm6G90wEhzw5PYcTi0FfZ84cHIUmn+SQh0XwQHz+ZZl0shbuCSZcntcUzCbKoWT8ryv9ankwItbdk78A1iAjzqWCMFFF8HRqUXgOv2GS4k+YQeYLMbhjsOqIlHnTtJjamU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=zB5Vnq3T; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-747adea6ddbso54867b3a.0
        for <kvm@vger.kernel.org>; Wed, 11 Jun 2025 09:26:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749659178; x=1750263978; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=aLjniqHBYepM/xcM6MPcnCZ4VmaaSdZz4NNkRlqyWXM=;
        b=zB5Vnq3TIKsJZ0PuVLbVWa5MedAsB+4N9x92NjZOY0/uryEY7UzqrAZB88N0S/Qs/V
         8RnOGdHPklKhcs3lTt0+Mb0HGD7sZF1HmywWarM0kfCjhsq98DsjEjYlTHVp2Ml/oWJe
         vlX+qI2Y94hoQg6H5To9Z6N/Imm9qflEV+d1UBkhVyhwUrtJK4iAy553+L0AknMP3ouI
         GdtfIIV1NWogQc+vvVV0dY0xxm/cYElEphua8tj6MdObVKykh2Du7a7HpiHbt9g9N4QT
         4urLhNkH8ichYlUXYVE7HyT9g46zZQwMv+awfAmR3nyoxYu5iypRLMArV/iKySiNjOZT
         uqtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749659178; x=1750263978;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=aLjniqHBYepM/xcM6MPcnCZ4VmaaSdZz4NNkRlqyWXM=;
        b=AtbYD5qLi70aOb4aosLY2tFagBjIf5yJbeie1Ive3sj6fHTI40h6j6QfhYiUIhyIcm
         oDDFpvVot8wLg4pFL/zhuQFHoIR2+YalM2Sbz3InDS/mIFGfSVPetMDiCSsPnVMUp4Pb
         Cb3TsWV9EGK7cBQ+sZ2MINsUcqLrSCDn5cFCrboAevBkr2CBEJTwQINp8xGYOexGlFeP
         WRjFA4qr/vCS3d6FxgmKwHHhx/QoBfKKNED6GuLyvgbvH2/zYUfXlfxwPfS2OsYz3L5r
         q81cNJLtSbj/KaxAthTkCGEdbMgLoHzX8DFvRNBayks69ojXMPz+wQavTV/d0itNFa0e
         t/1w==
X-Forwarded-Encrypted: i=1; AJvYcCWzPPu0eiafkxfKI60qvEgIcy9V358R2rG5G8QauuPQIVsLsC6/4nBA8zPyFAJ0L2Caxus=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxu/SE0sBPzxdtflnWfaidSzx9gVnj218F+9hkZwtqiPIyhiZVB
	n6ajFQlz2lCvzg0m/Ld9p4qiyLykmGLJIwA1y5C/22TJ1x9WmiWYN4WkzxpGDYndqPuJrjiKcJd
	kSHi4IA==
X-Google-Smtp-Source: AGHT+IEw5I/HfvQsgS82ZS/cuurbOuN425fhtHwxIgk3ZRi/K6leOQnkqnKRfQf0SFlrP0Qu9NQy4NaWX0c=
X-Received: from pfbjt31.prod.google.com ([2002:a05:6a00:91df:b0:746:247f:7384])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:c8a:b0:742:a23e:2a67
 with SMTP id d2e1a72fcca58-7486cde17b0mr4859975b3a.16.1749659178368; Wed, 11
 Jun 2025 09:26:18 -0700 (PDT)
Date: Wed, 11 Jun 2025 09:26:16 -0700
In-Reply-To: <effb33d4277c47ffcc6d69b71348e3b7ea8a2740.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250610021422.1214715-1-binbin.wu@linux.intel.com>
 <20250610021422.1214715-4-binbin.wu@linux.intel.com> <ff5fd57a-9522-448c-9ab6-e0006cb6b2ee@intel.com>
 <671f2439-1101-4729-b206-4f328dc2d319@linux.intel.com> <7f17ca58-5522-45de-9dae-6a11b1041317@intel.com>
 <aEmYqH_2MLSwloBX@google.com> <effb33d4277c47ffcc6d69b71348e3b7ea8a2740.camel@intel.com>
Message-ID: <aEmuKII8FGU4eQZz@google.com>
Subject: Re: [RFC PATCH 3/4] KVM: TDX: Exit to userspace for GetTdVmCallInfo
From: Sean Christopherson <seanjc@google.com>
To: Rick P Edgecombe <rick.p.edgecombe@intel.com>
Cc: Xiaoyao Li <xiaoyao.li@intel.com>, 
	"mikko.ylinen@linux.intel.com" <mikko.ylinen@linux.intel.com>, Kai Huang <kai.huang@intel.com>, 
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>, Jiewen Yao <jiewen.yao@intel.com>, 
	Reinette Chatre <reinette.chatre@intel.com>, Tony Lindgren <tony.lindgren@intel.com>, 
	Adrian Hunter <adrian.hunter@intel.com>, Yan Y Zhao <yan.y.zhao@intel.com>, 
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com" <pbonzini@redhat.com>, 
	Isaku Yamahata <isaku.yamahata@intel.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Kirill Shutemov <kirill.shutemov@intel.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 11, 2025, Rick P Edgecombe wrote:
> On Wed, 2025-06-11 at 07:54 -0700, Sean Christopherson wrote:
> > > Let's see what Paolo and Sean will say.
> >=20
> > Kicking this to userspace seems premature.=C2=A0 AIUI, no "optional" VM=
CALL
> > features
> > are defined at this time, i.e. there's nothing to enumerate.=C2=A0 And =
there's no
> > guarantee that there will ever be capabilties that require enumeration =
from=20
> > *userspace*.=C2=A0 E.g. if fancy feature XYZ requires enumeration, but =
that feature
> > requires explicit KVM support, then forcing userspace will be messy.
> >=20
> > So I don't see why KVM should anything other than return '0' to the gue=
st (or
> > whatever value says "there's nothing here").
>=20
> GetQuote is not part of the "Base" TDVMCALLs and so has a bit in
> GetTdVmCallInfo. We could move it to base?

Is GetQuote actually optional?  TDX without attestation seems rather pointl=
ess.

> Paolo seemed keen on GetTdVmCallInfo exiting to userspace, but this was b=
efore
> the spec overhaul.

If GetQuote is truly optional, then exiting to userspace makes sense.  But =
as
above, that seems odd to me.

