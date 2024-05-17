Return-Path: <kvm+bounces-17607-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8C4E28C880E
	for <lists+kvm@lfdr.de>; Fri, 17 May 2024 16:27:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9A1761C20B41
	for <lists+kvm@lfdr.de>; Fri, 17 May 2024 14:27:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5091F5FB87;
	Fri, 17 May 2024 14:26:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="q1pMpO4D"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C6065B696
	for <kvm@vger.kernel.org>; Fri, 17 May 2024 14:26:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715956014; cv=none; b=Yksskw6EwGfv1U1eoBvXp+CZr0aDN/t7u31eviCMGDSvENbtHZZG/Q3nQokLHyRAnfiHsEiNDAbIeB5lQpC3jLqbvDsae6eMn3xKjDfvB6qsZqlkf+W1OQnyezNbf35THpt7/HcF4Or1RKbJKKGxqjSPOTtcWkIMWSO2HZvX1h0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715956014; c=relaxed/simple;
	bh=Dl1P6YnQp8wm8iRfIfHtmRjWQ9ByiknL44FRIVpTL+4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=VuXq9TAWQgGcq7X3uPLfTEUcf3RoOfvxOlxqQl2oDbA1B8HciTGjgV7rNuKsPPYmYxDVU0L6XHhWPVCBKrKDpgM7K0eF06mU6CQycc5qn1AV+7+l0+WsezGthFMNd4SP2uVfBRvsoAtVoQ55I+gAtZfv/DORPoutLozVH2dQo5Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=q1pMpO4D; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-61d21cf3d3bso160616037b3.3
        for <kvm@vger.kernel.org>; Fri, 17 May 2024 07:26:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1715956012; x=1716560812; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jT4nqw0S4zpXFTc9WY81aiwMnvRN0tQtnQdC3noi5G0=;
        b=q1pMpO4DlHuDnjTQ+ojw3lK68JPCjnycduBv49WwYC76d/I/fZ0QozrVrqxacusE3O
         4zRsCc8d881N3EYp9kCvE5xARPXesFxPEV5aKTlcHfw3y85dsD0zpQhhgWdQLKFZqglX
         UvUTIyjsEpYF84gcFEDOHV6s98qadrfMJlm4uCF4Lz2HiO9tgb2rhnTTNrIWyX6cRdc0
         M+vAQEWFH3tixVh/o+8zDlAsLStIEE0+sZDNGjL1GAVvEsuFG865tenPFy8c4ahMTzuX
         SBa0azYwo9Xljj10TS08KHTEUDl++0vedR1yx3u6VjAt1gvHnMjK7/MC71llrvDokJQO
         3pAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715956012; x=1716560812;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=jT4nqw0S4zpXFTc9WY81aiwMnvRN0tQtnQdC3noi5G0=;
        b=S+ywj5CnyE2yHxID9mPk4CGv5y6D1E2IdldmrJG2gglAVsCdCITfWc150C+RQN8F5u
         ZMWsh8HLGDCzookPhzDb9KVTsYfmIzdIWLqrSltGO+fXEcbm0qDHKUxrK1xkNU5h1QbV
         vuv3/WCklcifmOXTsv74NCZaMmLY17srAzWuiab0KqvA+8YZHRyiKllnZ3BJxlB71S+f
         pfZhOyN4E1wZzuAyNbAkav9DysI6My+pxRQpY3OsQEJbRrhND344FOuQ7a2D6hlASI5f
         lzJ9IpjJJzZx12803RFoK7w56ivViJW0ralQBog7YHU4m02IAqaKI6K8sU+h4qGJTckR
         ZsiA==
X-Forwarded-Encrypted: i=1; AJvYcCX8b+cTx3PA5zMmrylzZWPEyofRhp7m9+Nu+kJBgvMVaWeqOrEe6gQmOoW4alVOLk66/mnqURRe7Wa2UFjIBFjIIsY9
X-Gm-Message-State: AOJu0YwUybPDbbu/5+ywIWh0557bIK6eYBJJlz9G1+AYJn/sB5+ClkRc
	hVjCBjgo6GHXsWWMxPeo7A3t3FbMOggBZR2KwJZjZzIkhX+bJ8QW7+/Whf7z6m/uvaEUOLmV9lg
	OTQ==
X-Google-Smtp-Source: AGHT+IEguYb768Ll9OxJG+xCvTeZMRyELAi07YJ2srYLgxpNkOH97TLsQqMexK5jbFU7Ajlqzvrc5B0cD3A=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:690c:3804:b0:61b:1d66:61c4 with SMTP id
 00721157ae682-622b016d66cmr44336497b3.10.1715956012119; Fri, 17 May 2024
 07:26:52 -0700 (PDT)
Date: Fri, 17 May 2024 14:26:50 +0000
In-Reply-To: <87r0e0ke8w.ffs@tglx>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240219074733.122080-1-weijiang.yang@intel.com>
 <20240219074733.122080-25-weijiang.yang@intel.com> <ZjLNEPwXwPFJ5HJ3@google.com>
 <39b95ac6-f163-4461-93f3-eaa653ab1355@intel.com> <ZkYauRJBhaw9P1A_@google.com>
 <87r0e0ke8w.ffs@tglx>
Message-ID: <ZkdpKiSyOwB3NwRD@google.com>
Subject: Re: [PATCH v10 24/27] KVM: x86: Enable CET virtualization for VMX and
 advertise to userspace
From: Sean Christopherson <seanjc@google.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Weijiang Yang <weijiang.yang@intel.com>, rick.p.edgecombe@intel.com, 
	pbonzini@redhat.com, dave.hansen@intel.com, x86@kernel.org, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, peterz@infradead.org, 
	chao.gao@intel.com, mlevitsk@redhat.com, john.allen@amd.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Fri, May 17, 2024, Thomas Gleixner wrote:
> On Thu, May 16 2024 at 07:39, Sean Christopherson wrote:
> > On Thu, May 16, 2024, Weijiang Yang wrote:
> >> We synced the issue internally, and got conclusion that KVM should hon=
or host
> >> IBT config.  In this case IBT bit in boot_cpu_data should be honored.=
=C2=A0 With
> >> this policy, it can avoid CPUID confusion to guest side due to host ib=
t=3Doff
> >> config.
> >
> > What was the reasoning?  CPUID confusion is a weak justification, e.g. =
it's not
> > like the guest has visibility into the host kernel, and raw CPUID will =
still show
> > IBT support in the host.
> >
> > On the other hand, I can definitely see folks wanting to expose IBT to =
guests
> > when running non-complaint host kernels, especially when live migration=
 is in
> > play, i.e. when hiding IBT from the guest will actively cause problems.
>=20
> I have to disagree here violently.
>=20
> If the exposure of a CPUID bit to a guest requires host side support,
> e.g. in xstate handling, then exposing it to a guest is simply not
> possible.

Ya, I don't disagree, I just didn't realize that CET_USER would be cleared =
in the
supported xfeatures mask.

