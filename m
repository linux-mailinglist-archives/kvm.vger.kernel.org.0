Return-Path: <kvm+bounces-10020-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C0A7F868812
	for <lists+kvm@lfdr.de>; Tue, 27 Feb 2024 04:51:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 37C121F22D2C
	for <lists+kvm@lfdr.de>; Tue, 27 Feb 2024 03:51:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ABC8F4CE17;
	Tue, 27 Feb 2024 03:50:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="grPLvk1S"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88937EAD7;
	Tue, 27 Feb 2024 03:50:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709005847; cv=none; b=UxLWfpafL8pY9X/bxsMfaDVaW49ZQpqH/db4XMMi/krcPxacxMdotLfXwKaSqG89jBK/OzffzH2Ib0UrXb9/ut2Jbt4NnGMDTsNNlbKEWbSxqpQ7EYM9RTJxKR/dRn8hsMQCcVDMV6Xq+rziWBhjtPLS45tWNt+B74qqPvcLW9o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709005847; c=relaxed/simple;
	bh=B1wd95IBC5zhPLBZb/ki8h4b3Rr2IW00CltWVoKgFVw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SUAR/faxzFVn1It8y+eEqIoIwNk8SwnGZi8F57Ye4BOxOgbKfndwUGCK/itrTFaSNbVmbIJAtYAotSpcLGj3rqtMRn8vQzfM/mx1mqB+Q7/E4IV27XeNeUvdv4jOscFovNZEc0Hl4dgm31Cl+mei9x8/58UDhTAFbFnX/MrkNY0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=grPLvk1S; arc=none smtp.client-ip=209.85.216.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f41.google.com with SMTP id 98e67ed59e1d1-29a858a0981so2423218a91.0;
        Mon, 26 Feb 2024 19:50:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1709005846; x=1709610646; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=8QbTKblq93ws5YpIS+NgNaE7jgggDQuS7cD18xjQxgc=;
        b=grPLvk1SkKH9UiXxTYCaFJZnYv6X6KTcJOyZXtz8FYWVExK9Pq1Y8e8HrPz+PLcBt/
         5QVz063YQx6PcFVLJSMGa7MUpDtzMwneWMlPYOJit98g6H5BT7xus2zCw4sj9gcnjD+h
         3L2ek/C53ywZblsaPlsFBJV/Msa43GcRfSJkq7UV0vkA+tegypRuRZPGA0pfapvak9Ch
         whz9DXG2dXalSmCAULGTb4+7ePUkAPIYfzNM5ZNKWjJS/ub+DBZOnsKg1bHom6yxFP0W
         b8Ntv1vKJpnpxzRV86CxmvvUOE+yBXn6zrX4yFx3FHd0RZEoZKDOYus7zCS7Ha3T4Sal
         UVMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709005846; x=1709610646;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8QbTKblq93ws5YpIS+NgNaE7jgggDQuS7cD18xjQxgc=;
        b=SCsO3oJLC1ZHK0CttZMJtHT/KHmEAFArZP1GPT+dv7VXfWfumRutXVNQXoU1HlS9r8
         ArCXnYa/rVYwhb+wvkxAkfL0mVc3SSFHrxFwheMJY3jnlR88gLt1FdpjIFvfgZlt5tSY
         jGS728/PjfG0to/nx0H+koEFSQXayiTS3Uu8JXUMRGD4GJTHYkCUde9irTh8kuIPYUFL
         ltgOEm3y5eDhMx9UatowZ364DMMO0I0PJj54brA1hNKgibd8XZBfTUeBSNCK/ydUhi6k
         cpaDM4jpJr5rIVwMsLt7nfMzCKSOwn5vrzChP3pa5fiwGncm1wFyoJ/YuTK0XkJSPNkI
         lwRQ==
X-Forwarded-Encrypted: i=1; AJvYcCVHhVhI9e+Dx9DjmCmyxFY6eSIOfICmuG5MU+SzjaYX6iqhbcaieRy2hk778gVaPNxwse+5AH15aEEKipyml5sv9qSsKoc40D/bReM0m8c79xyqrl6ZWkH1Hu4R6tnToZzN
X-Gm-Message-State: AOJu0YxN/e4VblwrNz4lM/4e2H5oAElrK6KueSIqKUngs0LwWSq9jtH+
	ItZfQXXLraLGtgsdC5cJk6iSEjc+85bhZM+JY7AIqmaKzLHcPNS9
X-Google-Smtp-Source: AGHT+IHpmM0T1qbcrujtM60wcQMYBwJrHAIovMMIp4f0tGcuRKNNDFBQnem5hXEUif8f9CwoJLI6ow==
X-Received: by 2002:a17:90a:17ca:b0:29a:6695:7c74 with SMTP id q68-20020a17090a17ca00b0029a66957c74mr6736229pja.45.1709005845609;
        Mon, 26 Feb 2024 19:50:45 -0800 (PST)
Received: from archie.me ([103.124.138.155])
        by smtp.gmail.com with ESMTPSA id sm12-20020a17090b2e4c00b002996778d8e7sm7421049pjb.26.2024.02.26.19.50.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Feb 2024 19:50:44 -0800 (PST)
Received: by archie.me (Postfix, from userid 1000)
	id 79D81184799CC; Tue, 27 Feb 2024 10:50:40 +0700 (WIB)
Date: Tue, 27 Feb 2024 10:50:39 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: seanjc@google.com, michael.roth@amd.com, aik@amd.com
Subject: Re: [PATCH v3 00/15] KVM: SEV: allow customizing VMSA features
Message-ID: <Zd1cDyyx65J1IVK1@archie.me>
References: <20240226190344.787149-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="ctgGmvIrBhMujgO2"
Content-Disposition: inline
In-Reply-To: <20240226190344.787149-1-pbonzini@redhat.com>


--ctgGmvIrBhMujgO2
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Feb 26, 2024 at 02:03:29PM -0500, Paolo Bonzini wrote:
> The idea that no parameter would ever be necessary when enabling SEV or
> SEV-ES for a VM was decidedly optimistic.  The first source of variability
> that was encountered is the desired set of VMSA features, as that affects
> the measurement of the VM's initial state and cannot be changed
> arbitrarily by the hypervisor.
>=20
> This series adds all the APIs that are needed to customize the features,
> with room for future enhancements:
>=20
> - a new /dev/kvm device attribute to retrieve the set of supported
>   features (right now, only debug swap)
>=20
> - a new sub-operation for KVM_MEM_ENCRYPT_OP that can take a struct,
>   replacing the existing KVM_SEV_INIT and KVM_SEV_ES_INIT
>=20
> It then puts the new op to work by including the VMSA features as a field
> of the The existing KVM_SEV_INIT and KVM_SEV_ES_INIT use the full set of
> supported VMSA features for backwards compatibility; but I am considering
> also making them use zero as the feature mask, and will gladly adjust the
> patches if so requested.
>=20
> In order to avoid creating *two* new KVM_MEM_ENCRYPT_OPs, I decided that
> I could as well make SEV and SEV-ES use VM types.  And then, why not make
> a SEV-ES VM, when created with the new VM type instead of KVM_SEV_ES_INIT,
> reject KVM_GET_REGS/KVM_SET_REGS and friends on the vCPU file descriptor
> once the VMSA has been encrypted...  Which is how the API should have
> always behaved.
>=20
> The series is structured as follows:
>=20
> - patches 1 to 5 are unrelated fixes and improvements for the SEV code
>   and documentation.  In particular they change sev.c so that it is
>   compiled only if SEV is enabled in kconfig
>=20
> - patches 6 to 8 introduce the new device attribute to retrieve supported
>   VMSA features
>=20
> - patch 9 disables DEBUG_SWAP by default
>=20
> - patches 10 and 11 introduce new infrastructure for VM types, replacing
>   the similar code in the TDX patches
>=20
> - patches 12 to 14 introduce the new VM types for SEV and
>   SEV-ES, and KVM_SEV_INIT2 as a new sub-operation for KVM_MEM_ENCRYPT_OP.
>=20
> - patch 15 tests the new ioctl.
>=20
> The idea is that SEV SNP will only ever support KVM_SEV_INIT2.  I have
> patches in progress for QEMU to support this new API.
>=20
> Thanks,
>=20
> Paolo
>=20
>=20
> v2->v3:
> - use u64_to_user_addr()
> - Compile sev.c if and only if CONFIG_KVM_AMD_SEV=3Dy
> - remove double signoffs
> - rebase on top of kvm-x86/next

I can't apply this series on top of current kvm-x86/next. On what exact
commit the series is based on?

Confused...

--=20
An old man doll... just what I always wanted! - Clara

--ctgGmvIrBhMujgO2
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZd1cCgAKCRD2uYlJVVFO
o8QBAQCptoaVJ0SmzzkqHRaW356Dx1h9Iza0opgqKEbujzlO4QD8Dld0M8ntPrRN
x75LqpsznWKX3Atx8foF3HNqwE9vgwQ=
=Xixn
-----END PGP SIGNATURE-----

--ctgGmvIrBhMujgO2--

