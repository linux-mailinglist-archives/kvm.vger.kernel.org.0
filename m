Return-Path: <kvm+bounces-13925-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 765D289CE82
	for <lists+kvm@lfdr.de>; Tue,  9 Apr 2024 00:36:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1287E1F234DC
	for <lists+kvm@lfdr.de>; Mon,  8 Apr 2024 22:36:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C817C4CE09;
	Mon,  8 Apr 2024 22:36:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="duLf6SKb"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 917DB171B0
	for <kvm@vger.kernel.org>; Mon,  8 Apr 2024 22:36:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712615775; cv=none; b=Phs2P1g3XngvvBxURKI+RJeE/SbeSNhJhrX41A3EygYOtOyVA+sdHgNRj2EJ+pz50GGPKo9TyhFF8uYyogyTWTOiUelU9DgAl62NHD0HgXbYK2X2pZMcx7fEmJhv+O7K5rjRqR8K259v8urZ4+U65YeiWeBCxTC0JP4aNXlEZnQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712615775; c=relaxed/simple;
	bh=wd9auWj6neAH4mwPBANg9G0rtjJL6aqclc7lajDKiYg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=hma8U7ZKjL8EW85naVTW3zsSiHR8tMk1Q9Ihndpysa0ffTZuTnFLfV06//6h4rrrL2conQtN74/Q9uTHr8y0MkhqJz8l9N6LF2tSqMnohxlGtKLaQ5Hyiyw4k6yieWpPX4mXcJNbqrZ09Af742EJuAX1A4ZeZ5rkOJe+tWGv8Mc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=duLf6SKb; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2a4a1065dc4so2590484a91.3
        for <kvm@vger.kernel.org>; Mon, 08 Apr 2024 15:36:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1712615773; x=1713220573; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=H3IyoUWCaMuOsrSmdtiAaHOAeX0T2/iesX+PuEFhG/o=;
        b=duLf6SKbk9ruf+aEZLiUtDpW0RGBgbPH30ZOBaR1wAaybjARXGQUQ994/OaZmZlOid
         A18DKxs3nd0A340wmKgBZtU91VKnlhAw6uVCEhX1Iiu5EU0Nki9wRrrackSe5N50PZXq
         C7t6A8xTtYI2WeJB1AgNG09I5lHnzle3OfURmBgupr2/J9/W6tePa0lyMdePy1a5gdWZ
         L+Dm9Ky8eH7M39zwMiSmCiB2dnepn7Az6sqQ5wHDaSJcm5lW9nndKlUmWlRcRsrLNgri
         EYMqD9BzrRyOC00KTabTi3ZmbQCuu9Vk4R++CnXpHRB7ijewPsQs7BJNBiaswKhD8OKN
         GN0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712615773; x=1713220573;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=H3IyoUWCaMuOsrSmdtiAaHOAeX0T2/iesX+PuEFhG/o=;
        b=R4af9y7TKb/4A2uAJq5l5lFfJAv6gf4v/xFWX5WeKpv5ZTpYvImKGkd7ntJk7YZfCm
         MrB1+DLMmV4OuykPhFz7THFadsv4f5sDfgKR1OobGd+3lDUf7WZWuIxFX/DGtDvyE4lt
         swoMBqFggk8wW/Kt/QGapfan7Ei84+KpaXqgXnHtvfumzFdkhWw/pvwj0p4qAZqmCh46
         zaMfPXX6MgG/gNwQSGRFsD7GTRSG/3ctUzc6MiCprxg4F7sPSkyXTZizVbEbJ4FoiZul
         G9oqkra7YtNUFA4WDfG7kGVEUh+cEGJtHNtcwCLjLVV/AM+iiHjnfK1HBrpGxqqWrh4k
         qpSQ==
X-Forwarded-Encrypted: i=1; AJvYcCUO8DuZKNzl/BrsWX3b1NQIaP9fOekGME2kAFwurLm4ostqJiXws9mtVNgafCBzl0DmzK5VTTmukCXgPOVuTNyonEcC
X-Gm-Message-State: AOJu0Yw15UjZJt3SGfH5q+wJB1lCe23+kYNxkhK8EQApJI+8RvIC8hhz
	tX3TCkdZa0evqakxZZL/BZBk6EYfCsnYXtQu+AzxoWcY8e4COmQTp0CAZysZY3hndhWR3U2/2ks
	vvA==
X-Google-Smtp-Source: AGHT+IGA02QPgUvTHLSjG35tJY/y8cz2zBR88FLhWwtJO2ItlMMNLpk97KO76IwFPepitjBhAf8k/cmoAGo=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:ea01:b0:1e2:b75e:37b5 with SMTP id
 s1-20020a170902ea0100b001e2b75e37b5mr352811plg.2.1712615772902; Mon, 08 Apr
 2024 15:36:12 -0700 (PDT)
Date: Mon, 8 Apr 2024 15:36:11 -0700
In-Reply-To: <5faaeaa7bc66dbc4ea86a64ef8e8f9b22fd22ef4.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240405165844.1018872-1-seanjc@google.com> <73b40363-1063-4cb3-b744-9c90bae900b5@intel.com>
 <ZhQZYzkDPMxXe2RN@google.com> <a17c6f2a3b3fc6953eb64a0c181b947e28bb1de9.camel@intel.com>
 <ZhQ8UCf40UeGyfE_@google.com> <5faaeaa7bc66dbc4ea86a64ef8e8f9b22fd22ef4.camel@intel.com>
Message-ID: <ZhRxWxRLbnrqwQYw@google.com>
Subject: Re: [ANNOUNCE] PUCK Notes - 2024.04.03 - TDX Upstreaming Strategy
From: Sean Christopherson <seanjc@google.com>
To: Rick P Edgecombe <rick.p.edgecombe@intel.com>
Cc: "davidskidmore@google.com" <davidskidmore@google.com>, Xiaoyao Li <xiaoyao.li@intel.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"srutherford@google.com" <srutherford@google.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"pankaj.gupta@amd.com" <pankaj.gupta@amd.com>, Isaku Yamahata <isaku.yamahata@intel.com>, 
	Wei W Wang <wei.w.wang@intel.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Apr 08, 2024, Rick P Edgecombe wrote:
> On Mon, 2024-04-08 at 18:51 +0000, Sean Christopherson wrote:
> > > I'm not following the code examples involving struct kvm_vcpu. Since =
TDX
> > > configures these at a VM level, there isn't a vcpu.
> >=20
> > Ah, I take it GPAW is a VM-scope knob?
>=20
> Yea.
>=20
> > I forget where we ended up with the ordering of TDX commands vs. creati=
ng
> > vCPUs.=C2=A0 Does KVM allow creating vCPU structures in advance of the =
TDX INIT
> > call?=C2=A0 If so, the least awful solution might be to use vCPU0's CPU=
ID.
>=20
> Currently the values for the directly settable CPUID leafs come via a TDX
> specific init VM userspace API.

Is guest.MAXPHYADDR one of those?  If so, use that.

> So should we look at making the TDX side follow a
> KVM_GET_SUPPORTED_CPUID/KVM_SET_CPUID pattern for feature enablement? Or =
am I
> misreading general guidance out of this specific suggestion around GPAW?=
=20

No?  Where I was going with that, is _if_ vCPUs can be created (in KVM) bef=
ore
the GPAW is set (in the TDX module), then using vCPU0's guest.MAXPHYADDR to
compute the desired GPAW may be the least awful solution, all things consid=
ered.

