Return-Path: <kvm+bounces-10719-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 33FE686EFBB
	for <lists+kvm@lfdr.de>; Sat,  2 Mar 2024 10:10:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DE6C11F22788
	for <lists+kvm@lfdr.de>; Sat,  2 Mar 2024 09:10:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1830F1428E;
	Sat,  2 Mar 2024 09:10:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=xry111.site header.i=@xry111.site header.b="hwZ2PLQa"
X-Original-To: kvm@vger.kernel.org
Received: from xry111.site (xry111.site [89.208.246.23])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B488412B83;
	Sat,  2 Mar 2024 09:10:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.208.246.23
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709370620; cv=none; b=aiDtCTBtyx9AXpBbUsLT1QXWsLLd4aEHHmguxRAqUflBKiopmqIiLvQMJmN/mRJrwhyBM1loaI/PXq3qWBzdcPFcibsN/AxEihT8GLU4STAJTNA6dsbaodPG3vtCcbzE/CRIGe7i37TG58id2ny0Wp0MRrXW6aAkCS3ypPTW72w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709370620; c=relaxed/simple;
	bh=VxCbvdeZMA93Dn8YyrqwTRm4PO3ov9xeDB4UC1XDyxc=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=fh2k/t+gCwj8YAwEhTc/Rb4q6uzjO4jUhuiIyAxjTSfBIPxsBKvmKHCWKC7yrOtiuGgaa9j/Aa1DTAQD1wIoqXMsqw8uvrepZvna0JxTIyFc+1WWp+nYEFwSI+1eeWDDletA/D3c4zTkTvJZ23aiZWJxNOUlL+kVwH9bhYL6odI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=xry111.site; spf=pass smtp.mailfrom=xry111.site; dkim=pass (1024-bit key) header.d=xry111.site header.i=@xry111.site header.b=hwZ2PLQa; arc=none smtp.client-ip=89.208.246.23
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=xry111.site
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=xry111.site
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=xry111.site;
	s=default; t=1709370609;
	bh=VxCbvdeZMA93Dn8YyrqwTRm4PO3ov9xeDB4UC1XDyxc=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
	b=hwZ2PLQa19LvHPWCzcgLifd48d56tjRsI4qPabm/MlWVrr7IySRXXjWNs5rHp+p6g
	 AUkE3/17pNsXOspSkDVM6Q4wfpvx577cuxC7+ngJGqzqyFHpACI2K6Sspn5+EhqOyg
	 IWi/VUVFQXBZZGCsQ2eCpOdNPS44qVVffBqefdIU=
Received: from [127.0.0.1] (unknown [IPv6:2001:470:683e::1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-384) server-digest SHA384)
	(Client did not present a certificate)
	(Authenticated sender: xry111@xry111.site)
	by xry111.site (Postfix) with ESMTPSA id 69DFC66633;
	Sat,  2 Mar 2024 04:10:07 -0500 (EST)
Message-ID: <562473e1080ce8a4d283cc8fb330073115b21019.camel@xry111.site>
Subject: Re: [PATCH v6 0/7] LoongArch: Add pv ipi support on LoongArch VM
From: Xi Ruoyao <xry111@xry111.site>
To: maobibo <maobibo@loongson.cn>, Huacai Chen <chenhuacai@kernel.org>, 
 Tianrui Zhao <zhaotianrui@loongson.cn>, Juergen Gross <jgross@suse.com>,
 Paolo Bonzini <pbonzini@redhat.com>,  Jonathan Corbet <corbet@lwn.net>
Cc: loongarch@lists.linux.dev, linux-kernel@vger.kernel.org, 
 virtualization@lists.linux.dev, kvm@vger.kernel.org,
 linux-doc@vger.kernel.org
Date: Sat, 02 Mar 2024 17:10:04 +0800
In-Reply-To: <b2084dbd-3ea6-736a-293e-2309e828a960@loongson.cn>
References: <20240302075120.1414999-1-maobibo@loongson.cn>
	 <b2084dbd-3ea6-736a-293e-2309e828a960@loongson.cn>
Autocrypt: addr=xry111@xry111.site; prefer-encrypt=mutual;
 keydata=mDMEYnkdPhYJKwYBBAHaRw8BAQdAsY+HvJs3EVKpwIu2gN89cQT/pnrbQtlvd6Yfq7egugi0HlhpIFJ1b3lhbyA8eHJ5MTExQHhyeTExMS5zaXRlPoiTBBMWCgA7FiEEkdD1djAfkk197dzorKrSDhnnEOMFAmJ5HT4CGwMFCwkIBwICIgIGFQoJCAsCBBYCAwECHgcCF4AACgkQrKrSDhnnEOPHFgD8D9vUToTd1MF5bng9uPJq5y3DfpcxDp+LD3joA3U2TmwA/jZtN9xLH7CGDHeClKZK/ZYELotWfJsqRcthOIGjsdAPuDgEYnkdPhIKKwYBBAGXVQEFAQEHQG+HnNiPZseiBkzYBHwq/nN638o0NPwgYwH70wlKMZhRAwEIB4h4BBgWCgAgFiEEkdD1djAfkk197dzorKrSDhnnEOMFAmJ5HT4CGwwACgkQrKrSDhnnEOPjXgD/euD64cxwqDIqckUaisT3VCst11RcnO5iRHm6meNIwj0BALLmWplyi7beKrOlqKfuZtCLbiAPywGfCNg8LOTt4iMD
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.50.4 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Sat, 2024-03-02 at 16:52 +0800, maobibo wrote:
> Sorry for the noise. It seems that there is some problem with my mail
> client when batch method.
>=20
> Please ignore this series, will send one by one manually.

Maybe you can try git send-email.


--=20
Xi Ruoyao <xry111@xry111.site>
School of Aerospace Science and Technology, Xidian University

