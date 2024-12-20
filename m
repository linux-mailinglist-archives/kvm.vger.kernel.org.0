Return-Path: <kvm+bounces-34224-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 3136A9F968F
	for <lists+kvm@lfdr.de>; Fri, 20 Dec 2024 17:28:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 539911896D07
	for <lists+kvm@lfdr.de>; Fri, 20 Dec 2024 16:26:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2253321C16B;
	Fri, 20 Dec 2024 16:25:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="mBuBXc5Z"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E73D321A435
	for <kvm@vger.kernel.org>; Fri, 20 Dec 2024 16:25:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734711914; cv=none; b=XWIKIb+UY9eegTK88z2xOYwH7nOkEbXcChGn+wQRMeot7tRKHmic9DmHwGamJJxPc0Cn8qh40mV7/zghyw4xDCCX9DckXI5ix9xAVQ3Nrpsm5mWis4fa71y7z129hwGY+6DhR/3C+URtpdDyzQWWhM5HsEbTQLeO8Hcfz6SnI58=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734711914; c=relaxed/simple;
	bh=iub0dcjRwS7n/viBTUfP3zzXsX0B5mXaAhBSy5ZWQto=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=NGLIfAwsUhHI1wZNl+TI8Pnrxgvh03d9plWPB3rsj4g0+7Ugr+VVH1QxIjl+gTFCSeAEaha8/JLwJPtoDFv1COiy9tdVbdfrU7GOgLbs9ge9DM6gwZWbSigHI1zSDtBErqxjk8ENEHAY3wSGjFiW0IsNqm/GzpFLdmAbf5hwovc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=mBuBXc5Z; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-72907f58023so2460455b3a.3
        for <kvm@vger.kernel.org>; Fri, 20 Dec 2024 08:25:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1734711912; x=1735316712; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=eLCijHqEgWqnuaOBsv7OhtW6DuFNGcPyjKp1uoSIRX0=;
        b=mBuBXc5ZVKN+UWAY3GMZAXCYjegAzoMmZBaxPdLtZqphst2RIL92jgmGaqQnkJ68Ye
         WVcOudT98iBhapKH6tFAvsIVXi/fRVu6n/0cNyWtlF537cWbjUMRWePfwlGcfTvCvxy9
         2/Y5PJXbomIHKKKNxq/5Q9A5kIsfuFEPLn0iLDMtwwcuIbSDE1GbZDCIeGl+ceGCcHhK
         d4bu2t2d+e1o09OP+jhmEAg88Ti6CKwIHjFFOjFQ0o/aKzlXdR732HB8zu96h1xnDGF4
         fcLYOfNfUrDlGp2Oj8O2Lpbun/E+W6e05pG11oAIa0ZyMlWGodu80mN18Ly1DvEFCjjS
         7zeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734711912; x=1735316712;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=eLCijHqEgWqnuaOBsv7OhtW6DuFNGcPyjKp1uoSIRX0=;
        b=rxSOPu7zRRnWvZgQoNdsbGI6iXnhrhsUaj7FA3XBTKDcufG2b9p2tuON8mrZYRX92W
         CtcgPj/5B4Yr0dnCWXO1qbmjBT6eBd7ZvEdG1joT7MuREUwWOoJ1zvr0/I+0b//oLIUj
         rJuo6RSa04g7vxs1KuJ5cEeSJzTxBIRhP9jc/lnUkgM7s9ZPJiQfkxgQvC/qokkRBT6D
         cKEngncj06dbj4hqjqIlxhV5994Fp8ktsogN43GICKjX1v30e9HZYcN30XwsZqjGZFJj
         iiNZ13CAC2YNl/uzJyi4gMOjP3qyA+5z4/ETqvdZ6On4hFHFrU6im4L2alXkfWbqQsIe
         O2pA==
X-Forwarded-Encrypted: i=1; AJvYcCWdWTdUDpHblQ5MYBq2bp5AHKv32rczNCRRuze6+66s6+jdXHWmsaoBcV8nIaYjqAqNNhM=@vger.kernel.org
X-Gm-Message-State: AOJu0YxwjcUmZzINwBVwX1ZaFPS25UzVJwX5mp97nKghWauKs+bXFF7T
	KXzHi8rIK86AlAAEjRrvTnF+LG+HQcE/IUkzr6MdkCLLVYy8ajBtj2vZfGHFvu8pHQivAPt1Up4
	veg==
X-Google-Smtp-Source: AGHT+IHoBHUmeDEVN53khNakWATzKl/ZCvRIPz/sAopfe6VES86j2gkyd/p6MCVXr+0GpIvjuBy9uC4tBLU=
X-Received: from pgtq13.prod.google.com ([2002:a65:684d:0:b0:802:81:dd47])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:6da4:b0:1e1:e2d9:7f0a
 with SMTP id adf61e73a8af0-1e5e0802525mr6970765637.34.1734711912161; Fri, 20
 Dec 2024 08:25:12 -0800 (PST)
Date: Fri, 20 Dec 2024 08:25:10 -0800
In-Reply-To: <Z2UvlXeG6Iqd9eFQ@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <cover.1734392473.git.ashish.kalra@amd.com> <CAAH4kHa2msL_gvk12h_qv9h2M43hVKQQaaYeEXV14=R3VtqsPg@mail.gmail.com>
 <cc27bfe2-de7c-4038-86e3-58da65f84e50@amd.com> <Z2HvJESqpc7Gd-dG@google.com>
 <57d43fae-ab5e-4686-9fed-82cd3c0e0a3c@amd.com> <Z2MeN9z69ul3oGiN@google.com>
 <3ef3f54c-c55f-482d-9c1f-0d40508e2002@amd.com> <d0ba5153-3d52-4481-82af-d5c7ee18725f@amd.com>
 <Z2UvlXeG6Iqd9eFQ@redhat.com>
Message-ID: <Z2WaZvUPYNcP14Yp@google.com>
Subject: Re: [PATCH v2 0/9] Move initializing SEV/SNP functionality to KVM
From: Sean Christopherson <seanjc@google.com>
To: "Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?=" <berrange@redhat.com>
Cc: Ashish Kalra <ashish.kalra@amd.com>, Dionna Amalie Glaze <dionnaglaze@google.com>, pbonzini@redhat.com, 
	tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, 
	dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com, 
	thomas.lendacky@amd.com, john.allen@amd.com, herbert@gondor.apana.org.au, 
	davem@davemloft.net, michael.roth@amd.com, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org, 
	linux-coco@lists.linux.dev
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Dec 20, 2024, Daniel P. Berrang=C3=A9 wrote:
> On Thu, Dec 19, 2024 at 04:04:45PM -0600, Kalra, Ashish wrote:
> > On 12/18/2024 7:11 PM, Kalra, Ashish wrote:
> > > But, i believe there is another alternative approach :=20
> > >=20
> > > - PSP driver can call SEV Shutdown right before calling DLFW_EX and t=
hen do
> > > a SEV INIT after successful DLFW_EX, in other words, we wrap DLFW_EX =
with=20
> > > SEV_SHUTDOWN prior to it and SEV INIT post it. This approach will als=
o allow
> > > us to do both SNP and SEV INIT at KVM module load time, there is no n=
eed to
> > > do SEV INIT lazily or on demand before SEV/SEV-ES VM launch.
> > >=20
> > > This approach should work without any changes in qemu and also allow=
=20
> > > SEV firmware hotloading without having any concerns about SEV INIT st=
ate.
> > >=20
> >=20
> > And to add here that SEV Shutdown will succeed with active SEV and SNP =
guests.=20
> >=20
> > SEV Shutdown (internally) marks all SEV asids as invalid and decommissi=
on all
> > SEV guests and does not affect SNP guests.=20
> >=20
> > So any active SEV guests will be implicitly shutdown and SNP guests wil=
l not be=20
> > affected after SEV Shutdown right before doing SEV firmware hotloading =
and
> > calling DLFW_EX command.=20
> >=20
> > It should be fine to expect that there are no active SEV guests or any =
active
> > SEV guests will be shutdown as part of SEV firmware hotloading while ke=
eping=20
> > SNP guests running.
>=20
> That's a pretty subtle distinction that I don't think host admins will
> be likely to either learn about or remember. IMHO if there are active
> SEV guests, the kernel should refuse the run the operation, rather
> than kill running guests. The host admin must decide whether it is
> appropriate to shutdown the guests in order to be able to run the
> upgrade.

+1 to this and what Dionna said.  Aside from being a horrible experience fo=
r
userspace, trying to forcefully stop actions from within the kernel gets ug=
ly.

