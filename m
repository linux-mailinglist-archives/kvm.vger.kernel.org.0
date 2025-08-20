Return-Path: <kvm+bounces-55126-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D107CB2DD48
	for <lists+kvm@lfdr.de>; Wed, 20 Aug 2025 15:05:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1391A5C0F15
	for <lists+kvm@lfdr.de>; Wed, 20 Aug 2025 13:02:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E0A361891A9;
	Wed, 20 Aug 2025 13:01:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="wW2AcJZy"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92F822475C7
	for <kvm@vger.kernel.org>; Wed, 20 Aug 2025 13:01:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755694905; cv=none; b=iKe9la1Cn0rI3qcOX+MHPAv3bURwW6eZgBe3pb36COuOyrAO/9TBlkuJF4Uh+7NYuj/1bMCvHzY04GLwDqUkSTfH1IQkL6yYDY4W/+XLqSX777n+TVfb+j8c9V8oTxb75zYWyoAAYafaI8pErvT/BjjjBHr9vC/4U97cDPBXNBM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755694905; c=relaxed/simple;
	bh=wKs6154q1CuWduyMYGk1ExrTS3G/asrXXyz4KcM+ZXE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=BzyOLh1vIoviQ6XNwbFMpsb/DXR2ntpM8Dc61mmW4eioG81w9OGYv5ufU7MH44xHbgH6t6rUcWGaTHgjKJZpmSalaYFwPOR35qZaA3SVW+quP7R4SS7+sk6R6MucEjAcrQdMGFCgtR+cC6MxHLs9mse5FSTfkMh6aZqU/q6AJzI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=wW2AcJZy; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-24458264c5aso70013155ad.3
        for <kvm@vger.kernel.org>; Wed, 20 Aug 2025 06:01:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755694903; x=1756299703; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=UaJOMLSIELpvDEO7epSv+22yc1sPRzaMaQRGyQr0AeE=;
        b=wW2AcJZywjYn2/D9QUY2C8b5aGe38lTRF6hP9WWTGXkXlqziPYscFqcpKoD8OzSRBo
         OspDyeFvbA5TUdQZ0Xfp9nZEf6v98cMcpF+YJx2MKpiaRxbJuVhcQBEN95Kns2QazEvZ
         u34YiLRCc2DBX3MBj1uLXIJi6k03QwvHtxm/wA2XjxesvI6Pjv2LqALJJa9L1Natwk5B
         AtOpkFcE/kWy61HMoBIP/ZvKle+g7Gd5ptKIEEvFSQk9mv0q/wNznmOV46kQqAVD7sP8
         XNpYWUk/45OO88glS/5Ky3iOyXcXw/wC4MOYo+nXZHzA7LVVHSC0HysjMylT4DKTCL2u
         c2+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755694903; x=1756299703;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=UaJOMLSIELpvDEO7epSv+22yc1sPRzaMaQRGyQr0AeE=;
        b=MEMcdpu3uI0i5NV5fwGuhVsJsBnjmdkWSaXSOeE2XXPOnqKEi/WgfIEDJofjBEPId6
         O+b7NMFgVy0ibfz3moAxo5ylGhSMMKlUSod0CXXA5NMr04XarCbSkA2KUy6k+0sJxw1E
         66KfBX0zVqvTSAv0I6xGr2hQVLU3A9s6rnnuIS9UHy1N+IoqqXSQsR8EWGaT/LKvSXNC
         hNk0ve6a+pVEGZA5xDfpfEcAMiSrB2mBr2KwrnsOlq8gZlwr+0666vtmXhOZSkIXBbwm
         Pw+zCYtmOOcTXFpOQrCc9SetK1ZbmDVXiVz3PllwOw2aY7H7onB700alF6zc282kBNbs
         yiNg==
X-Forwarded-Encrypted: i=1; AJvYcCXLk739uBwOnIt1tJI7MDfxbMzc7Vd/rt4koT/x0PDeZJSbsGJKkYgHATk69We4pniEDmM=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw8tTvI1Lj/cLRji4RphtMo7owm4ot1PSnHtO8ZAnpu7nJ+sQRH
	sad+xe9zd3pX+yWLBfHIGrARir4Rltob1vFuHX7X92NYXrvPQZcwzhCQcFjzuRNpa2gGSVTCckG
	Kv5CR3g==
X-Google-Smtp-Source: AGHT+IEwOh08V7OwFaToRvymHqAkp1iuuPWnLNS6JSQCMW6zILVjkhJt5JbRAqseXO9ZLDriDY4AFd/fiY8=
X-Received: from pjbok13.prod.google.com ([2002:a17:90b:1d4d:b0:321:c2a7:cbce])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:ef01:b0:243:3b1:47cb
 with SMTP id d9443c01a7336-245ef1045a8mr33382985ad.6.1755694902882; Wed, 20
 Aug 2025 06:01:42 -0700 (PDT)
Date: Wed, 20 Aug 2025 06:01:40 -0700
In-Reply-To: <c3e638e9-631f-47af-b0d2-06cea949ec1e@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250819234833.3080255-1-seanjc@google.com> <20250819234833.3080255-9-seanjc@google.com>
 <c3e638e9-631f-47af-b0d2-06cea949ec1e@amd.com>
Message-ID: <aKXHNDiKys9y8Xdw@google.com>
Subject: Re: [PATCH v11 8/8] KVM: SVM: Enable Secure TSC for SNP guests
From: Sean Christopherson <seanjc@google.com>
To: "Nikunj A. Dadhania" <nikunj@amd.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Thomas Lendacky <thomas.lendacky@amd.com>, Michael Roth <michael.roth@amd.com>, 
	Borislav Petkov <bp@alien8.de>, Vaishali Thakkar <vaishali.thakkar@suse.com>, 
	Kai Huang <kai.huang@intel.com>, David.Kaplan@amd.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 20, 2025, Nikunj A. Dadhania wrote:
>=20
>=20
> On 8/20/2025 5:18 AM, Sean Christopherson wrote:
> > From: Nikunj A Dadhania <nikunj@amd.com>
> >=20
> > @@ -2195,6 +2206,12 @@ static int snp_launch_start(struct kvm *kvm, str=
uct kvm_sev_cmd *argp)
> > =20
> >  	start.gctx_paddr =3D __psp_pa(sev->snp_context);
> >  	start.policy =3D params.policy;
> > +
> > +	if (snp_is_secure_tsc_enabled(kvm)) {
> > +		WARN_ON_ONCE(!kvm->arch.default_tsc_khz);
>=20
> Any particular reason to drop the the following change:=20
>=20
> +		if (WARN_ON(!kvm->arch.default_tsc_khz)) {
> +			rc =3D -EINVAL;
> +			goto e_free_context;
> +		}

Based on this conversation[*], both Kai and I expected KVM to let firmware =
deal
with the should-be-impossible situation.

  On Tue, Jul 8, 2025 at 9:15=E2=80=AFPM Nikunj A. Dadhania <nikunj@amd.com=
> wrote:
  > On 7/8/2025 8:04 PM, Sean Christopherson wrote:
  > > On Tue, Jul 08, 2025, Kai Huang wrote:
  > >>>> Even some bug results in the default_tsc_khz being 0, will the
  > >>>> SNP_LAUNCH_START command catch this and return error?
  > >>>
  > >>> No, that is an invalid configuration, desired_tsc_khz is set to 0 w=
hen
  > >>> SecureTSC is disabled. If SecureTSC is enabled, desired_tsc_khz sho=
uld
  > >>> have correct value.
  > >>
  > >> So it's an invalid configuration that when Secure TSC is enabled and
  > >> desired_tsc_khz is 0.  Assuming the SNP_LAUNCH_START will return an =
error
  > >> if such configuration is used, wouldn't it be simpler if you remove =
the
  > >> above check and depend on the SNP_LAUNCH_START command to catch the
  > >> invalid configuration?
  > >
  > > Support for secure TSC should depend on tsc_khz being non-zero.  That=
 way it'll
  > > be impossible for arch.default_tsc_khz to be zero at runtime.  Then K=
VM can WARN
  > > on arch.default_tsc_khz being zero during SNP_LAUNCH_START.
  >
  > Sure.

https://lore.kernel.org/all/c327df02-c2eb-41e7-9402-5a16aa211265@amd.com

>=20
> As this is an unsupported configuration as per the SEV SNP Firmware ABI S=
pecification:=20

Right, but what happens if KVM manages to pass in '0' for the frequency?  D=
oes
SNP_LAUNCH_START fail?  If so, bailing from KVM doesn't seem to add any val=
ue.

>=20
> 8.16 SNP_LAUNCH_START
>=20
> DESIRED_TSC_FREQ
> Hypervisor-desired mean TSC frequency in KHz of the guest. This field has=
 no
> effect if guests do not enable Secure TSC in the VMSA. The hypervisor sho=
uld
> set this field to 0h if it *does not support Secure TSC* for this guest.
>=20
> > +		start.desired_tsc_khz =3D kvm->arch.default_tsc_khz;
> > +	}
> > +
> Regards,Nikunj

