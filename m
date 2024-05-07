Return-Path: <kvm+bounces-16896-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E3C5A8BEA21
	for <lists+kvm@lfdr.de>; Tue,  7 May 2024 19:12:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 494391F23D7C
	for <lists+kvm@lfdr.de>; Tue,  7 May 2024 17:12:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 28D81157A41;
	Tue,  7 May 2024 17:12:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="O8T3i7rc"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 263083F9E8
	for <kvm@vger.kernel.org>; Tue,  7 May 2024 17:11:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715101921; cv=none; b=ujjV2j0he7NfxnZgorv3TgSumsVBhPMhyiBGfbMLiSVcJXh9GrsLu1PTPN/kGIjx4yB8xWV8/79LG9UPS4nN8cQgFmLNSzGfla3LFLhhPt8z5jZIqx+UUVjiZw5q1ThynN9QALPGOJKxzjmpoOLZJZnzwCkHqE3ql6I8xoXK8uw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715101921; c=relaxed/simple;
	bh=7OSkgP5+kPRPnXz92hms6Q0kbyy8WDX+cILm9CSvN1M=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=GzJ26BAmQl+nE+97fX8XeenZFEYiz44CnOJAPCEjJ1e5o26uD2SZinOGoSpYjk2EhdP0pd1kpGckx3jGbndKyUdTYvc8R2TT3r6yynD5BNxSjJN1Aj8rKsugexXRnb91lx5gvZtjDIskW7RagONeKg40O6qG6DaUfdkUs77evy8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=O8T3i7rc; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-6292562bac4so2428186a12.1
        for <kvm@vger.kernel.org>; Tue, 07 May 2024 10:11:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1715101919; x=1715706719; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jNWTjRHNzguG/ECX3sxXEdtUovfHpdLwJgS1SRLByzU=;
        b=O8T3i7rc+RkWnSrCk9mcubuP5KVcymafCfpjL9wB9fVo2xZUtppD1OoH4gLp0OhTWR
         F6920V715+PLHJRNsnFP/QtSEwlP+q4UGoUHnKSwLWdQcSZDFZHNVOaPc2wk4AbPHsIe
         1NnLCMZ8PDrKClv7fYa85u2d66KbnMmpN++J9V1A/G+gBeWWQENaiJxWj+xqUvN+rCdC
         0DZImk2eBk65/vwqdYl4Yvp3BOvPy3rY7owIRle3YUpr67eEeZA73brIFfcMw1YJQw00
         zEMrgYIIQk5syCcCr0XDmeHUvqDIuZeI7UK8nzbtQHKVu4C6aIDlJw3cnZZfD5KXV/Lh
         vXSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715101919; x=1715706719;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=jNWTjRHNzguG/ECX3sxXEdtUovfHpdLwJgS1SRLByzU=;
        b=fW8rW9UZMauXsqvak7fseCp10Z3y5XDbArYmebfHJcOxr24nCYPV8J7E/3H5ZNaYcZ
         c7I0x/uzvVGojRiC1IHhBt3S+UPPPlEJveg4Wy49a81ABr25vKGyvcR9gU1s2l2Ozihf
         CA0hOd0udtTgv2HISYlklv/DCmhgYfpx3pYEc4hNKVnEi3j3OAGaIA2MwGS26I9I7Mio
         S15O3dd+XT614GBMQ8BocQ9s35lKCkKX4zsyZ1j4CVVSq0/uJ/kkoYk902olee51oayt
         /TBT6834q8wjhvhRv4xmRbFWvNL20BNKvyRgSr1y2End0H2xx2DGh9r5MXkFpjh0k5p9
         2lkA==
X-Forwarded-Encrypted: i=1; AJvYcCUPPpraKYPLaf2y/WmIuY/XbiTLDpzekCU6f4XYbF5oxuadysZKdnHUjEpiw8oumFHtBXF9U2pesx57/vveVDIw/Eqw
X-Gm-Message-State: AOJu0YyOYPf6IngVFUw6G91ZioZFN65Du2BhWfMV72n65vsgLlV5lJmc
	QcbEVGqMaC8L1TOHI1pyzZh56NHqMPGdNrnFK+5kWQomycwALv38W/IT74SIsoPkzlHtQmkwzhD
	nkw==
X-Google-Smtp-Source: AGHT+IGXYTNhE4o6Jz4a9tofzokKuMCJots4ro+a/npTiGMlkU1K2gSt900bsifAeL/u4yulw2hSE1dwe40=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a65:6d0c:0:b0:5f7:651b:fed8 with SMTP id
 41be03b00d2f7-62f295deabemr1389a12.12.1715101919434; Tue, 07 May 2024
 10:11:59 -0700 (PDT)
Date: Tue, 7 May 2024 10:11:57 -0700
In-Reply-To: <6e0dc5f2-169e-4277-b7fe-e69234ccc1fd@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <f9f1da5dc94ad6b776490008dceee5963b451cda.camel@intel.com> <6e0dc5f2-169e-4277-b7fe-e69234ccc1fd@intel.com>
Message-ID: <Zjpg3dhf0mWetkSE@google.com>
Subject: Re: [RFC] TDX module configurability of 0x80000008
From: Sean Christopherson <seanjc@google.com>
To: Xiaoyao Li <xiaoyao.li@intel.com>
Cc: Rick P Edgecombe <rick.p.edgecombe@intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"pbonzini@redhat.com" <pbonzini@redhat.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Wed, May 08, 2024, Xiaoyao Li wrote:
> On 4/25/2024 12:55 AM, Edgecombe, Rick P wrote:
> > One of the TDX module features is called MAXPA_VIRT. In short, it is si=
milar to
> > KVM=E2=80=99s allow_smaller_maxphyaddr. It requires an explicit opt-in =
by the VMM, and
> > allows a TD=E2=80=99s 0x80000008.EAX[7:0] to be configured by the VMM. =
Accesses to
> > physical addresses above the specified value by the TD will cause the T=
DX module
> > to inject a mostly correct #PF with the RSVD error code set. It has to =
deal with
> > the same problems as allow_smaller_maxphyaddr for correctly setting the=
 RSVD
> > bit. I wasn=E2=80=99t thinking to push this feature for KVM due the mov=
ement away from
> > allow_smaller_maxphyaddr and towards 0x80000008.EAX[23:16].
> >=20
>=20
> I would like to get your opinion of the MAXPA_VIRT feature of TDX. What i=
s
> likely the KVM's decision on it? Won't support it due to it has the same
> limitation of allow_smaller_maxphyaddr?

Not supporting MAXPA_VIRT has my vote.  I'm of the opinion that allow_small=
er_maxphyaddr
should die a horrible, fiery death :-)

