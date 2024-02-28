Return-Path: <kvm+bounces-10214-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 62D2286AB66
	for <lists+kvm@lfdr.de>; Wed, 28 Feb 2024 10:35:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B83501F27774
	for <lists+kvm@lfdr.de>; Wed, 28 Feb 2024 09:35:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 78FCD364BF;
	Wed, 28 Feb 2024 09:34:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hrGJahEJ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f169.google.com (mail-pg1-f169.google.com [209.85.215.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A5B736133;
	Wed, 28 Feb 2024 09:34:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709112880; cv=none; b=ovzRqh7SuH2rPisC8kjXe2pyXmMFXPSiEEBilau9A/C040ANdyO/8H2TbriN2c0J2NtFL6Ho+vru42Pf2hp0bCV93pfHyfOGhQeFq7uJNjDs8yUSe1e5tvu9mQLUTfRF57i8g3yInT7mLU1BZ4tQ+wZHLXtdrj8f0/CKDZ2gUaQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709112880; c=relaxed/simple;
	bh=Cf7Ab1S5Azi7ftJlAgSjDp6AD00chiKeVOaFhJkgUqo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fIsqipA/KKwzQMx9SPmmmZ4p5HFR5/o3fvajeqD4fDFh8yX6udCt/SncWHsxAUOO7dMULSBPaKzeI3aRWhrouq5j1wdvGtMWm7WrWq4W3arOfQaCfGXjs3Dq/JX5btc95Q45UXRJN/RCXhFyvz8T7+IM3HqIjEjeOm2QXz+Nisc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hrGJahEJ; arc=none smtp.client-ip=209.85.215.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pg1-f169.google.com with SMTP id 41be03b00d2f7-5cddc5455aeso4905606a12.1;
        Wed, 28 Feb 2024 01:34:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1709112878; x=1709717678; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=BnTxzgDB4D6z5X/XWZgAEvdqEsYIyodUJ23UluDAgo8=;
        b=hrGJahEJja+59nTNLV8vTZpK5nHU2IWAh/hfK58Fwewtfy0la4gn6b5vC43Df9ybx9
         oTa/ea6wsUI7shS0sUl/F2TQYAIlYdUHqMmqwaaQUPDmL0z5eBuSNDkGkNtrdmFapUEv
         iaRGYDc8zlmkztVHWuAOLJQEPAR4+FlVALMMKjrslPaREuScwnS1WtD6+FLQQV4lB0l+
         u3CU1HpUlu1WqfBgu/GinA90JyTbs8oX5vzjPJBvSm1ereLbyvfjORLumwyIdez4G8U2
         ynTJEk6JJ6SxAYdX5TVe35DgWQ/V+vMxtWYUiKFd91tKjp+6ysIJNinwU2mN0f5x9o4y
         cdew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709112878; x=1709717678;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BnTxzgDB4D6z5X/XWZgAEvdqEsYIyodUJ23UluDAgo8=;
        b=YRG8rpYwLpVB3pwSRXANdox2pfISfFBfY5R+rHnWG1BRPdTvHQA4Swc/AftlebsSPX
         9/z2hgprGPF4mY7miXjCv4YAuS6jyHix6kK8AobYEtUi7ISO9eElHJnJdWE0OyElBP0Y
         c1x/U81rieL5zItFagqI0ZFvXukXroqkx/WxwsX+wj+DNhBbrsSBucCKrpUp+cqYDPk1
         SgzfNrZN3RnRPA67JhbpPDP84YVcKWe3T0VcObY/WhxtnXopWa4AEURkkkbiP49x94+Q
         75rjJBbP5k85k8swhgtk9hz5ES82UUDMAd6MGxeGId2OjZXElWFEuaIKXP+2/1k1aF1i
         8d0g==
X-Forwarded-Encrypted: i=1; AJvYcCXSVrcGem6ulktbKxBBvXrqTHuAQtwqdS7CROayk01qI5dFuuXM6bZzbocI0s9aFYsHfcvcQyHri2Azn1uwkaWwC6toQsWEnvG5JxspdnviZAR3Tn7nvokIW6GYFHPX5APb
X-Gm-Message-State: AOJu0Yx23xKd6rt74p+AIzztaDqtwS6EPToUPREP707lPPbQAV+NJQip
	qs66AbvZ4RE/Gz7QNHp/EsAQxqCEFWbtDoCh6tJ1wWfGShzz91M1
X-Google-Smtp-Source: AGHT+IGuQ8W5px8wKjurGo44FSp62ASDSBPR2Tehpe/JisAe2FtfFe9UEtCIaamJIUbV1mDvADh8YA==
X-Received: by 2002:a05:6a20:c116:b0:1a0:fc33:17b8 with SMTP id bh22-20020a056a20c11600b001a0fc3317b8mr3634526pzb.24.1709112878380;
        Wed, 28 Feb 2024 01:34:38 -0800 (PST)
Received: from archie.me ([103.124.138.155])
        by smtp.gmail.com with ESMTPSA id f19-20020a17090aa79300b0029ab73a80a2sm1104370pjq.22.2024.02.28.01.34.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Feb 2024 01:34:37 -0800 (PST)
Received: by archie.me (Postfix, from userid 1000)
	id 6442518515716; Wed, 28 Feb 2024 16:34:34 +0700 (WIB)
Date: Wed, 28 Feb 2024 16:34:33 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: seanjc@google.com, michael.roth@amd.com, aik@amd.com
Subject: Re: [PATCH v3 05/15] Documentation: kvm/sev: separate description of
 firmware
Message-ID: <Zd7-KWFGOXGs_iOu@archie.me>
References: <20240226190344.787149-1-pbonzini@redhat.com>
 <20240226190344.787149-6-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="eUPRBjCtZiK17fws"
Content-Disposition: inline
In-Reply-To: <20240226190344.787149-6-pbonzini@redhat.com>


--eUPRBjCtZiK17fws
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Feb 26, 2024 at 02:03:34PM -0500, Paolo Bonzini wrote:
> +``KVM_MEMORY_ENCRYPT_OP`` API
> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D

Nit: I think to be consistent, with command names in section headings below,
the API name heading above should not be inlined.

> =20
>  The main ioctl to access SEV is KVM_MEMORY_ENCRYPT_OP.  If the argument
>  to KVM_MEMORY_ENCRYPT_OP is NULL, the ioctl returns 0 if SEV is enabled
> @@ -87,10 +81,6 @@ guests, such as launching, running, snapshotting, migr=
ating and decommissioning.
>  The KVM_SEV_INIT command is used by the hypervisor to initialize the SEV=
 platform
>  context. In a typical workflow, this command should be the first command=
 issued.
> =20
> -The firmware can be initialized either by using its own non-volatile sto=
rage or
> -the OS can manage the NV storage for the firmware using the module param=
eter
> -``init_ex_path``. If the file specified by ``init_ex_path`` does not exi=
st or
> -is invalid, the OS will create or override the file with output from PSP.
> =20
>  Returns: 0 on success, -negative on error
> =20
> @@ -434,6 +424,21 @@ issued by the hypervisor to make the guest ready for=
 execution.
> =20
>  Returns: 0 on success, -negative on error
> =20
> +Firmware Management
> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +
> +The SEV guest key management is handled by a separate processor called t=
he AMD
> +Secure Processor (AMD-SP). Firmware running inside the AMD-SP provides a=
 secure
> +key management interface to perform common hypervisor activities such as
> +encrypting bootstrap code, snapshot, migrating and debugging the guest. =
For more
> +information, see the SEV Key Management spec [api-spec]_
> +
> +The AMD-SP firmware can be initialized either by using its own non-volat=
ile
> +storage or the OS can manage the NV storage for the firmware using
> +parameter ``init_ex_path`` of the ``ccp`` module. If the file specified
> +by ``init_ex_path`` does not exist or is invalid, the OS will create or
> +override the file with PSP non-volatile storage.
> +

This one LGTM.

Other than the nit,

Reviewed-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--eUPRBjCtZiK17fws
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZd7+IAAKCRD2uYlJVVFO
o162AQCcn8Ku0qmJzR0aVZhAlymyxJjRteYpeKWfN7U4NfghawEAkNBc12XmmmJP
8LB8u3zNlnOBbkVipGKxB+YnRI5WQQ8=
=Hybi
-----END PGP SIGNATURE-----

--eUPRBjCtZiK17fws--

