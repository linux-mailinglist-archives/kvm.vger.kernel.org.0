Return-Path: <kvm+bounces-55185-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1B583B2E11B
	for <lists+kvm@lfdr.de>; Wed, 20 Aug 2025 17:31:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 228DEA23A40
	for <lists+kvm@lfdr.de>; Wed, 20 Aug 2025 15:18:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EA5973277BA;
	Wed, 20 Aug 2025 15:10:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="MQET5TqX"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89A1D322DCA
	for <kvm@vger.kernel.org>; Wed, 20 Aug 2025 15:10:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755702651; cv=none; b=HKaNEnghayLaSUG3rV95rsgqEs4NqIfVDKjiGuNoJk+ZrstZp2ShoNzptDLBrEtEJVu4JvmAy0fEl0M4y8+hnlu1EWziv/+GNBukyPTWVUxT91bTp/r84mBV8m7PlkvNO5g8x53Gno49ZSLEZ4VtFxMsHK+YnfmrM2YWV6O79cA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755702651; c=relaxed/simple;
	bh=1fxfY5dVvQZNFSj6lzgF6BNISnMdwPKlIZQ0ehBDwGI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=UMF3A/HAQIOIQvNqhQCFl6c2N9U/HdpZ8oauaJREPNxOh14WZOnVjT/Ut/BoBm19PNLLb+4VzRZLGlKdi0avmSLrjHeIablt+frogh8xREWFOqFTCfVWCp7fuOhm0OkLsJqN408GBi2E8SAAYRDs0nj1JolRI6n197rUFlQZ7Rk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=MQET5TqX; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2445803f0cfso70095795ad.1
        for <kvm@vger.kernel.org>; Wed, 20 Aug 2025 08:10:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755702649; x=1756307449; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1fxfY5dVvQZNFSj6lzgF6BNISnMdwPKlIZQ0ehBDwGI=;
        b=MQET5TqX+3kfl3qeoRIjIIJMGaJaSlmrHIXeWDVJ2sbzONHNu9Ue35cvc7O75kRmOP
         e6u9ytoQzW9P1kxMn7ej1x1DyG4fkUPPwzdNPHiVcQD9Rn8edI7Fz+q1Q1QBurSCDBmc
         560dvmgR8k7ilUxiJE7C+EfZy+Wr325M9cyw9PtourBX6XTjNVas+NEtfzzqfW1Xfs8c
         H3vaWBD/u/vCkhJGeUYGgntdb9F0VthTjlF3em0bsBJcAVTdsa5Yvgyr4Ww7BAIKNy72
         e6sWz8BoKaZuR88OtzQR4vrjOE8juCebvXfwDKDy/hsrh5Y6QWnZ35G820COKyeYIsBc
         EKhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755702649; x=1756307449;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=1fxfY5dVvQZNFSj6lzgF6BNISnMdwPKlIZQ0ehBDwGI=;
        b=oActx6c0X4J6b0NUwq/pZVPuFpdoG0Y1zjjnqjOaaU9IOyW3pFyRChZEikUUaO75E1
         SV37nIFRZi92RGeXVnVRKJSAFzs391NqSGxcCUewBEjfGMA4rvjf+7nWsjxt7CkGZ9Q4
         EuBgFvlsL+JWphmtubSVU2Y3bdmq8zFQ/zjavmVrF+1LubL1kgAH9uyaPG+hmipQP5U5
         VaDsWErQ7nO5vdBECPncFowVPCnjJ+teSXM0q6Mf1UyyrVsJvRslmB4RcgVhLe9DWSaw
         z3GgclN/fUd09ws7A/Qiyq9D0MPfbj8bwqQCvle0YL2w9FyTEZf/oRtlCZLCMZIk0BuQ
         QoCQ==
X-Forwarded-Encrypted: i=1; AJvYcCVjoY98ERB1sO91ZMOSwL3gXmMEKbIPPBlwzUxLhermy1JIgNHbn+sLqCT2rhqLTKfh0BA=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz1M6NVuQ6lNkupSH2MVJf4MkYMlMaBUG9aRLPSIwZjvpcshG2Q
	ox+7BW4JFkc3gy0sxW2sQbdVLPKfLFGefRDBOhjPPTZUVd5oOQ+Hgt0rnz2oQfHEfM9o2dnbIPU
	RzaGtMA==
X-Google-Smtp-Source: AGHT+IFKIChJVfhivrtL6SAQS2f+B7ilBclOWVAZJETl/5OR41KJtkCw9r7nWSgB064593+bk5z1H7JvJgY=
X-Received: from pjtd9.prod.google.com ([2002:a17:90b:49:b0:31f:6ddd:ef5])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:ce0b:b0:234:914b:3841
 with SMTP id d9443c01a7336-245ef256a40mr45940385ad.39.1755702648695; Wed, 20
 Aug 2025 08:10:48 -0700 (PDT)
Date: Wed, 20 Aug 2025 08:10:47 -0700
In-Reply-To: <0a2e3ae2-6459-46eb-a9a3-2cab284a49f7@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250819234833.3080255-1-seanjc@google.com> <afcf9a0b-7450-4df7-a21b-80b56264fc15@amd.com>
 <755ca898eab309445e461ee9f542ba7a4057d36c.camel@intel.com> <0a2e3ae2-6459-46eb-a9a3-2cab284a49f7@amd.com>
Message-ID: <aKXld8Lecq7tjYZS@google.com>
Subject: Re: [PATCH v11 0/8] KVM: SVM: Enable Secure TSC for SEV-SNP
From: Sean Christopherson <seanjc@google.com>
To: "Nikunj A. Dadhania" <nikunj@amd.com>
Cc: Kai Huang <kai.huang@intel.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>, 
	"thomas.lendacky@amd.com" <thomas.lendacky@amd.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"vaishali.thakkar@suse.com" <vaishali.thakkar@suse.com>, 
	"Ketan.Chaturvedi@amd.com" <Ketan.Chaturvedi@amd.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"michael.roth@amd.com" <michael.roth@amd.com>, "bp@alien8.de" <bp@alien8.de>, david.kaplan@amd.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 20, 2025, Nikunj A. Dadhania wrote:
> On 8/20/2025 4:55 PM, Huang, Kai wrote:
> > On Wed, 2025-08-20 at 14:18 +0530, Nikunj A. Dadhania wrote:
> >>> =C2=A0 - Continue on with snp_launch_start() if default_tsc_khz is '0=
'.=C2=A0 AFAICT,
> >>> =C2=A0=C2=A0=C2=A0 continuing on doesn't put the host at (any moer) r=
isk. [Kai]
> >>
> >> If I hack default_tsc_khz=C2=A0 as '0', SNP guest kernel with SecureTS=
C spits out
> >> couple of warnings and finally panics:
> >> =C2=A0
> >=20
> > It's a surprise that the SEV_CMD_SNP_LAUNCH_START didn't fail in such
> > configuration. :-)
>=20
> As mentioned here[1], this is an unsupported configuration as per the SNP
> Firmware ABI.

Yeah, but outside of AMD hardware/firmware, the usual response to an unsupp=
orted
configuration is to return an error :-D

Anyways, I'll fixup to the -EINVAL version from v10 when applying.

