Return-Path: <kvm+bounces-24081-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D9A9695116A
	for <lists+kvm@lfdr.de>; Wed, 14 Aug 2024 03:10:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 5A1BAB21CC2
	for <lists+kvm@lfdr.de>; Wed, 14 Aug 2024 01:10:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 424EABE47;
	Wed, 14 Aug 2024 01:10:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="wU47e2IE"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F72123AB
	for <kvm@vger.kernel.org>; Wed, 14 Aug 2024 01:10:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723597841; cv=none; b=K7YZyxbwit6hrwcG84XFapitimWrz718AdJKBETpztG74b20xdClTJdIMs5tGRLDHBFlQ8q2eIYDSKwOPKKqymdmcJmr1eY3bVfdps4YtVzBaZMPOnuAikoUuZGXlfE3lFwEKJ01HjgSQ0ZTB6IVM8LghN6Fo9T4t3npNjzgvdo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723597841; c=relaxed/simple;
	bh=05ctJLqFzmWTtIoxhUdWL+c73B7LApIAABBMmSXwBlk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=HK03asCX///j8tfd3xN0zoDIfN9KkqnZvQ4XdrKGIP9IGtZ75xcEfVNTTcUWPn0tbqdTuaq180UMQdV4KunjVlAhPoig6LGIpMIot26ibWEqk0GJjEpzocCjtICAt1hdw9YUC+pbPy9deOQBQVfsIjZ+5A87FnPnyAJMrJEjIf8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=wU47e2IE; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-664bc570740so7220527b3.0
        for <kvm@vger.kernel.org>; Tue, 13 Aug 2024 18:10:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1723597839; x=1724202639; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9hOtc8fNAlhLYuIuFFZ4t4foLKOgj+DhOBObaSJm5DQ=;
        b=wU47e2IEgSs9O7ZpUFJ2UGpUMwwfdEH5zUR1tbIaDnaqAIVuBnyRxP4Csc7U9pPP/S
         H5cs3xcS6HmVnTK+0VQbmARPnUYEsGB0IjpFUG5kgiS5lhzyXlPsfdT+ftylHJ8SRErS
         L/plZFr1/J0GbthbJic1I9+VVakpVmyYVg0jwbOKiv7z4z03a5VF1C7fi2Nq/z/wUSTo
         /9etyJOh40BEoPY1PVcKiVjWZSAxZkdiHlz1LHsmh3fQoz6jVlK4iMWCo9B2pMqrEdFp
         j2jwL5dA5ug8GNTtHkggl8ykcBN5RrRyhsxgj39ocs4ZL/nFeGKACW+27gOrz/Ca5pnb
         i6IQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723597839; x=1724202639;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=9hOtc8fNAlhLYuIuFFZ4t4foLKOgj+DhOBObaSJm5DQ=;
        b=mbV7uInfrwYVhTCJOx7VEqhTV+umEAbUZWtTlBMPr5WP+CYNYOpKL8d97BZJoSMdYj
         lljW0b2J9huRR+N0qPT7nUvEBvJjBZHyipH7a05x0ni3ycqhfbqy5LVKu4YC/sG2Btdk
         KFEaOBiEPly34mZ+4v0S7VvAlRpLtuAEcx+F8L+2JTtFQupKxe+xMw27WFBrlAMF6Tg1
         /iwzXeNwah/OjKkWja6WpHPmZI3AalOgy3zs68kavJMlmL17IyncfkInkvhQQnWPjn5G
         c50qPyigdAF0vl4qg2xH7Q/dpd/aN/49uvk20LkD0S12R8E2iebd9IhddjmJeymu2CAA
         F1iQ==
X-Forwarded-Encrypted: i=1; AJvYcCUXcbONzyoqOoDXV6Q7Y52329xny7f23yiU7qkSHkJql3F5irNR7VTHXslaDNVNUTjfh2Le7NmjOdxPSKxilEEpRCyT
X-Gm-Message-State: AOJu0Yy02lc621wPfQIkgEgO+aYRuGk2NgA0MpIB6kId76U7RnQwy18V
	L1oF5lGrEEg5CFiuqN3tNVBvNTrn3a5FvdwoEFP5g5ota3dGC0EjxKZ1ADmzE7Ls2cVGzdPAIsQ
	qnw==
X-Google-Smtp-Source: AGHT+IG/2rDr9URUPDl9FM8oMDrvH3jCXr+cSppLGOe0KQE9X5dKiZqG3sFVtvXlrLbhADZaZ6WgRYBXjd8=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a0d:d147:0:b0:651:2eea:4dfe with SMTP id
 00721157ae682-6a9df63c480mr655687b3.0.1723597839045; Tue, 13 Aug 2024
 18:10:39 -0700 (PDT)
Date: Tue, 13 Aug 2024 18:10:37 -0700
In-Reply-To: <a24f20625203465b54f20d1fc1456a779eee06a1.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240812224820.34826-1-rick.p.edgecombe@intel.com>
 <20240812224820.34826-26-rick.p.edgecombe@intel.com> <ZrtEvEh4UJ6ZbPq5@chao-email>
 <a24f20625203465b54f20d1fc1456a779eee06a1.camel@intel.com>
Message-ID: <ZrwEDTrA2SjWJlen@google.com>
Subject: Re: [PATCH 25/25] KVM: x86: Add CPUID bits missing from KVM_GET_SUPPORTED_CPUID
From: Sean Christopherson <seanjc@google.com>
To: Rick P Edgecombe <rick.p.edgecombe@intel.com>
Cc: Chao Gao <chao.gao@intel.com>, Kai Huang <kai.huang@intel.com>, 
	Xiaoyao Li <xiaoyao.li@intel.com>, 
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"tony.lindgren@linux.intel.com" <tony.lindgren@linux.intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"pbonzini@redhat.com" <pbonzini@redhat.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 13, 2024, Rick P Edgecombe wrote:
> On Tue, 2024-08-13 at 19:34 +0800, Chao Gao wrote:
> > Mandating that all fixed-1 bits be supported by KVM would be a burden f=
or both
> > KVM and the TDX module: the TDX module couldn't add any fixed-1 bits un=
til KVM
> > supports them, and=C2=A0
>=20
> > KVM shouldn't drop any feature that was ever a fixed-1 bit
> > in any TDX module.
>=20
> Honest question...can/does this happen for normal VMs? KVM dropping suppo=
rt for
> features?

Almost never.  KVM still supports Intel CPUs without virtual NMI support, w=
hich
IIRC was something like one SKU of Yonah that was 32-bit only.  Keeping bac=
kwards
compability is annoying from time to time, but it's generally not that much=
 of a
maintenance burden.  The only CPUs I really wish had never existed are thos=
e that
have EPT without A/D bits.  Other than that, maintaining support for old CP=
Us
doesn't hinder us too much.

> I think I recall even MPX getting limped along for backward compatibility=
 reasons.

Yep, KVM still supports virtualizing MPX.

