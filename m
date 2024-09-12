Return-Path: <kvm+bounces-26751-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C790D976EEC
	for <lists+kvm@lfdr.de>; Thu, 12 Sep 2024 18:42:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0556B1C239AD
	for <lists+kvm@lfdr.de>; Thu, 12 Sep 2024 16:42:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B2E351B654F;
	Thu, 12 Sep 2024 16:42:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="puq01Qub"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EC9213D531
	for <kvm@vger.kernel.org>; Thu, 12 Sep 2024 16:42:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726159325; cv=none; b=kvvPtNGfiRGFwOZhklUOIRAxL7j+Jn3Zwsx8w2BpQKXh8Lwa1PKIejMOtFU6D8beH2Lz5+M5FbiyQI8UEO252WWSgJ8w3NfkvH9y/u+heeZkKhJ7vzX6H9fV2Pj8jkB3+RLuRG/yJ5JW8REp8Ifzr2klJ9f9AxE9utLrqUj3CCM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726159325; c=relaxed/simple;
	bh=M8+PBkR1oiKaZ9r0U3hmulmioggnq2eSV2q1S5zMC+0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=PBhSBeDKbaLXg2XaIZlzgnrDnKvHUemPJW+EqDL+TMrbiYe2T5UxoxvhJFG6Rwa3SuBMWmjJAGhWQ0UnpN83dIYmll6W8cmjAjmSL614sXWXXYWkJNVGpo9d1+NX3GD/ardO4F0RaaN1/1AaCiSVztTcqx7/qwlBoG3m3od3j9M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=puq01Qub; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-718db8e61bfso1972120b3a.0
        for <kvm@vger.kernel.org>; Thu, 12 Sep 2024 09:42:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1726159324; x=1726764124; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=rSoCh08e7KyIe42FqcDSlKyKAmA7DtL1wDAOqCxQHdc=;
        b=puq01QuboNfVOMxf7e40McHTV1agOhvOPvYu4amy84DKXsolLOj0kiGsw92X48S+At
         1dKE/gfouabJlqwYyK57WLzEYFBvxNikSRGIylKyftfIlt6qUJ4mdG2bCVQTbgOLjOx3
         SPrNUvkWUDosFjJjqOiJ6TrlG85rGl2vsfnZYYsLrBlfxLGmjwoW1cs/JKhAzeav70CO
         ngoTt7zPuA5KdDDJJangv9hdmKO6D6OB3+eqQCpFM3TR/MEJgsBss/DvM8N+F9LtYGnn
         J/EqYpgJvqEWob6Rog5cwaOEqXJN2f5jJZrQJqjnD8KUxrz9KtGEgfn3PaKE/TMKkAvp
         pjXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726159324; x=1726764124;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=rSoCh08e7KyIe42FqcDSlKyKAmA7DtL1wDAOqCxQHdc=;
        b=lwqvRH/d4I26rq3dNFpb3W0QbLxgY3zgSXojzWd5ZaAk+/KlpXXrzfi54w4BHZNZSd
         v7a9TAXOOgfPH7OwxzznFOt8Q1ka3izE6vtEEcSeRaYaHPVyo5kCIPha6l6c84fp6vnB
         SFh1ePUYDlplGhvlgFviQo04cALS4nXybWZ8VVY4oIn1hCjvtwbBR/buefH8vBDkN89i
         C3aIdm49Dwd12MqLq5hM279WhNSfLAf2ycL5JIEaVX2ZVFPQPnV6VPvrKo2M7YW1t5dL
         gFKbiCpMziSWC6AzEJFjI/x2FPNENMTwD38jaHcnLkDOBpmgZ++YvL9MLigpsdlum6QP
         4jXA==
X-Forwarded-Encrypted: i=1; AJvYcCVjyxYithlvP6GbZXCCaxK9MvKWCiOXBXhNFSslY5p05kJ/rJ4RzEMFKgHQ1zVspzU0pdY=@vger.kernel.org
X-Gm-Message-State: AOJu0YwvKhYYUAxQS7ii9A80A0qyDerTV0l6hP4UXUI8vR34aWwS28ub
	iXSHOHdZiQAjirsLKdm6E+FT7ZnbYij3WpB1ea+ZwwoRhkhLuQ2metlEXp4BAUKrSjfNv6EqjMV
	jLg==
X-Google-Smtp-Source: AGHT+IHkyO/EL/QePhqc2gP93gRsoRCw7q0rkAv7kqtImZ/C3jpRgKOYW4ykEt82kgck1ZXLgTMrSjCLuEQ=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:81c2:b0:714:24bf:eaee with SMTP id
 d2e1a72fcca58-7192606cea9mr9155b3a.2.1726159323719; Thu, 12 Sep 2024 09:42:03
 -0700 (PDT)
Date: Thu, 12 Sep 2024 09:42:02 -0700
In-Reply-To: <CABgObfZ5ssWK=Beu7t+7RqyZGMiY2zbmAKPy_Sk0URDZ9zbhJA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240812224820.34826-1-rick.p.edgecombe@intel.com>
 <20240812224820.34826-26-rick.p.edgecombe@intel.com> <05cf3e20-6508-48c3-9e4c-9f2a2a719012@redhat.com>
 <cd236026-0bc9-424c-8d49-6bdc9daf5743@intel.com> <CABgObfbyd-a_bD-3fKmF3jVgrTiCDa3SHmrmugRji8BB-vs5GA@mail.gmail.com>
 <df05e4fe-a50b-49a8-9ea0-2077cb061c44@intel.com> <CABgObfZ5ssWK=Beu7t+7RqyZGMiY2zbmAKPy_Sk0URDZ9zbhJA@mail.gmail.com>
Message-ID: <ZuMZ2u937xQzeA-v@google.com>
Subject: Re: [PATCH 25/25] KVM: x86: Add CPUID bits missing from KVM_GET_SUPPORTED_CPUID
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Xiaoyao Li <xiaoyao.li@intel.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>, 
	kvm@vger.kernel.org, kai.huang@intel.com, isaku.yamahata@gmail.com, 
	tony.lindgren@linux.intel.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 12, 2024, Paolo Bonzini wrote:
> On Thu, Sep 12, 2024 at 4:45=E2=80=AFPM Xiaoyao Li <xiaoyao.li@intel.com>=
 wrote:
> > > KVM is not going to have any checks, it's only going to pass the
> > > CPUID to the TDX module and return an error if the check fails
> > > in the TDX module.
> >
> > If so, new feature can be enabled for TDs out of KVM's control.
> >
> > Is it acceptable?
>=20
> It's the same as for non-TDX VMs, I think it's acceptable.

No?  IIUC, it's not the same.

E.g. KVM doesn't yet support CET, and while userspace can enumerate CET sup=
port
to VMs all it wants, guests will never be able to set CR4.CET and thus can'=
t
actually enable CET.

IIUC, the proposal here is to allow userspace to configure the features tha=
t are
exposed _and enabled_ for a TDX VM without any enforcement from KVM.

CET might be a bad example because it looks like it's controlled by TDCS.XF=
AM, but
presumably there are other CPUID-based features that would actively enable =
some
feature for a TDX VM.

For HYPERVISOR and TSC_DEADLINE_TIMER, I would much prefer to fix those KVM=
 warts,
and have already posted patches[1][2] to do exactly that.

With those out of the way, are there any other CPUID-based features that KV=
M
supports, but doesn't advertise?  Ignore MWAIT, it's a special case and isn=
't
allowed in TDX VMs anyways.

[1] https://lore.kernel.org/all/20240517173926.965351-34-seanjc@google.com
[2] https://lore.kernel.org/all/20240517173926.965351-35-seanjc@google.com

