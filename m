Return-Path: <kvm+bounces-61620-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 70EBFC22C4B
	for <lists+kvm@lfdr.de>; Fri, 31 Oct 2025 01:09:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2AED9420D57
	for <lists+kvm@lfdr.de>; Fri, 31 Oct 2025 00:09:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1590242AA3;
	Fri, 31 Oct 2025 00:09:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="klJP2Vhk"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9FA2134CF
	for <kvm@vger.kernel.org>; Fri, 31 Oct 2025 00:09:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761869384; cv=none; b=OM3k4bJKB+0oWqixEImQoP9cqKDKuN42gXxxt5j1CYE6qkrdqR/FEReV4KVWVPrEP073szmBYtkwvj9U7M1bOyXxMpHaH3uXObOrW0lNrxzC0dS9WM3XjMxy/XENz+0NXb7/WLLqAAwVxjQf+c6+YLhvqp02zL7t87VL5LIO3lA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761869384; c=relaxed/simple;
	bh=tOqji4svVFYnjsJuuwJe072kmFQ3eEB6odRukox2PW8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kmgRmjXtKfj4VL/4Ykkh0/xOsnl/t0bx5dj6oKPO+Tq6AXGuv5MvHgyQ4DNq8nyA+0hOLl5Pnj1QJ8TwIyHrR53j2+00IckD6/xcFWT8s6bDkolRieDGyOVFc04BHrhNBiLqHlsEUzamZGP+fqW6HG+4lwvQbYHQJERi9ES/bYM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=klJP2Vhk; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-295018cbc50so15711455ad.3
        for <kvm@vger.kernel.org>; Thu, 30 Oct 2025 17:09:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761869382; x=1762474182; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=tOqji4svVFYnjsJuuwJe072kmFQ3eEB6odRukox2PW8=;
        b=klJP2Vhkcdbr8tQPOQhgfvgEmrP7vsg+2k81HHP9P/tTtuBIPewkleOebXI+v2cxRI
         iB3nLjiW6+7ZVLdFK2W9yHGd7qeg1FAnAteUpBzo2/KoqUOWZfVKnIeJUuzSZJi0UoxV
         SjI2OjKVg/97+XoQTI8+0/mrKW1zsrZj1x6xkNtRKbgL7krn5Q55m1Yzcvz/VlhuDCuy
         oqPSVeoHZMmdAoDQOrctInu23kK8Yp5wyIZUPj5PgjBc3DQWG/wQu0tAvODnDP1lOx8r
         Li/9tj4L5oWoYA+AkUcLRJ0682zcpVrs0zah+Mh5p905Du5n1m3TGWMDW6chWKaopJc7
         to8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761869382; x=1762474182;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tOqji4svVFYnjsJuuwJe072kmFQ3eEB6odRukox2PW8=;
        b=k0TgjXgcdvaerXcm1guVjw8kss2VLp2TYUmjU24xQ9+7sd3jjNrrn4cg+F1Vwrn+XC
         KSFn12iKlGOU5TD5y9J/tn48flFL8sHDfq5HoqFi6ZLwybKUGBj7d2gHYY2w0uKP7amf
         Sg+o3nJ9n3+9ptdBxiumPhZEOYpcfXSnuoL+XFlBrkWdxaz831yXY8rUnpqJJ8Z3scV7
         Q4+0nQ6RBErY3P9/JPf5HoHvxkdCIv9WbH0IRS9ydyc/YZ2LtHpgxp3GpE10C7S7fHx2
         9vaWF51MSk5iTQvktNxmHNJ6ZiQDFl6GgAI/DFizNbYYfuMeqhbM78J/CenF9EY8NpMs
         v9UA==
X-Forwarded-Encrypted: i=1; AJvYcCWAVo+Q0kICCtUhmAPXIgYoiMA8H1DVRE0NJ4Qse+6cDWE5A9V1MtETNSp3mueD1lnaljY=@vger.kernel.org
X-Gm-Message-State: AOJu0YzAr1sVb2lbTiHoCqOShRuvxqutVirrJyByNtPyMPIT/ZbLmk/Q
	ezNHoeByr/9mKedFecYMNTiocqTxBOEY5iSDKJS5Ve7p2HBLrXqT4bxC
X-Gm-Gg: ASbGncuu77x0TBK1ro5EymHcPTkJ3yp1Ahc+Dpy37mqVie1ozoJF1VCNilc1YRmp4C7
	NPthkXFjZRfSxoIEqkm9aQOny13fbHHvkMD5KlcaEY9SuezCcpwM50+ZCri0j54jfb35oXK/iiZ
	dfue/dp16h+tDAc7xo+ENaVflFpARwiC4yEQeFf5rmlu4bcP98n3n6G0ex2DpduAnHEz2iOGOhK
	zyyOicGiywUnYchH2x+dVQ0ldjQ4isrpaSWOJvKxHpO1drpnllmYFzObfxqO4lYQpvbNy31J5Vd
	CSJGS9UOyBIWB5lHWVwcpb+KjoCAj3pThSzml1LPpmymxVuuEszmxDQFwNNpoGE7aeWvtT/yF10
	6kpksUwudcv/3kFnDCXleeOsyYnGzqHeyiAHpGDmXIdfKDcTiiOPf9HZwWT6CNKG7rFRUKXOohQ
	Co
X-Google-Smtp-Source: AGHT+IEXVNb2H7WFZFLBuvMGoO23i051th+3XKdx2cHyPS895ioXoRXcS0lzDT9ZxeAWygJirg3ebw==
X-Received: by 2002:a17:902:e78d:b0:24b:24dc:91a7 with SMTP id d9443c01a7336-2951a52a946mr19593005ad.45.1761869381941;
        Thu, 30 Oct 2025 17:09:41 -0700 (PDT)
Received: from archie.me ([210.87.74.117])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2952696f6d6sm1785865ad.68.2025.10.30.17.09.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Oct 2025 17:09:40 -0700 (PDT)
Received: by archie.me (Postfix, from userid 1000)
	id D67E64209E4A; Fri, 31 Oct 2025 07:09:38 +0700 (WIB)
Date: Fri, 31 Oct 2025 07:09:38 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Yosry Ahmed <yosry.ahmed@linux.dev>,
	Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Jim Mattson <jmattson@google.com>,
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: x86: Document a virtualization gap for GIF on AMD
 CPUs
Message-ID: <aQP-Qv1SOi0cy-nO@archie.me>
References: <20251030223757.2950309-1-yosry.ahmed@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="esF5ABbH8ZFy2Hrc"
Content-Disposition: inline
In-Reply-To: <20251030223757.2950309-1-yosry.ahmed@linux.dev>


--esF5ABbH8ZFy2Hrc
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 30, 2025 at 10:37:57PM +0000, Yosry Ahmed wrote:
> -TBD
> +On AMD CPUs, when GIF is cleared, #DB exceptions or traps due to a break=
point
> +register match are ignored and discarded by the CPU. The CPU relies on t=
he VMM
> +to fully virtualize this behavior, even when vGIF is enabled for the gue=
st
> +(i.e. vGIF=3D0 does not cause the CPU to drop #DBs when the guest is run=
ning).
> +KVM does not virtualize this behavior as the complexity is unjustified g=
iven
> +the rarity of the use case. One way to handle this would be for KVM to
> +intercept the #DB, temporarily disable the breakpoint, single-step over =
the
> +instruction, then re-enable the breakpoint.

The wording LGTM, thanks!

Reviewed-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--esF5ABbH8ZFy2Hrc
Content-Type: application/pgp-signature; name=signature.asc

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCaQP+OgAKCRD2uYlJVVFO
o1/xAQDRkpadriLgvvT/+503xXuvsaiKT53xVLXmZHvTe/ghwwEAvNOeC1nXPtHQ
lC6ze9NwfECTfuCk+ZlAYKbSvm0Svgo=
=2fXT
-----END PGP SIGNATURE-----

--esF5ABbH8ZFy2Hrc--

