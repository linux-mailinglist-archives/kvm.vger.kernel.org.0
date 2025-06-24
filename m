Return-Path: <kvm+bounces-50526-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id E6F8CAE6DD5
	for <lists+kvm@lfdr.de>; Tue, 24 Jun 2025 19:48:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id BAE187A8A95
	for <lists+kvm@lfdr.de>; Tue, 24 Jun 2025 17:46:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E59602E6112;
	Tue, 24 Jun 2025 17:47:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="icUlbw2z"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54CC9126C05;
	Tue, 24 Jun 2025 17:47:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750787269; cv=none; b=XwNdxZ0VTInrCC2DxGsoTUrqhwgorZzgm4TYd0iVTxTyh2rP0Ut0TrIAGOrgUPxawpsuXLS/+xRKkFxllYHUrv/b+C1QYa/zjNwL2RacDFNsQc2HsVBDEoD54Jjik/vhX5BKlyp6p0aIdDF5q8eF80ckRTUXGft6pDxJ2wlhVnE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750787269; c=relaxed/simple;
	bh=5nm1A4MVgvcQpOP/0PwY5Is2uix0KrV9HNqYCDKZMfA=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:Message-ID:
	 MIME-Version:Content-Type; b=Et9IJKhWTfldukPfmj7R0D4OnmcqoNcC+tYLqpS88dAzUDgYjxKHYf2ghIQhiHexSjr6+5SeRpTwt3RiGgHygnow7J/gYBUr/bchliS8XzwIqAmWNToUCM4tu8fzTZhK/7lcIO8F/JSGJU+GVM+almnThMnoILprJwRJ5U1ivNc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=icUlbw2z; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from [127.0.0.1] (c-76-133-66-138.hsd1.ca.comcast.net [76.133.66.138])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 55OHlIDC1447537
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NO);
	Tue, 24 Jun 2025 10:47:19 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 55OHlIDC1447537
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025062101; t=1750787240;
	bh=Xtzy7Z0TVEfcGM1KP1rtxvZJCcru8z+E9SrW3T2nLYQ=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:From;
	b=icUlbw2zSZHKK0m+/vm/Ajftypsfq4s8aYU5l54HmfQ5kWwKmneT4XFxsn0bzf/OB
	 MS6hcBzXmk7LSIGmvAnZ6G1chbLmGb0s9MxjFgHIKj5jycrng3Uz4GrpsQMy+Ona93
	 ZfksS8e9a1ioJ0NgWNfSSJxGsW/a01hgJzWjCsgYydN2gh18zHwW+/QgGcAPADoi66
	 yMXCfdg9utLzyupU12RHJT+75cLYkDWGF4/8JZmgnu/m7/EV7wbH3yYxjq4BQ0M2wz
	 w0t04TIGAj1M3cWn7pHmGaWtMV96n9MMwW5uv0MSoZ5DKK1Gxc/Y7uc6WKrmcwjhKL
	 tfMCzHDQm+yiA==
Date: Tue, 24 Jun 2025 10:47:17 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
To: Xin Li <xin@zytor.com>, Sean Christopherson <seanjc@google.com>
CC: pbonzini@redhat.com, kvm@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, corbet@lwn.net, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, andrew.cooper3@citrix.com, luto@kernel.org,
        peterz@infradead.org, chao.gao@intel.com, xin3.li@intel.com
Subject: Re: [PATCH v4 00/19] Enable FRED with KVM VMX
User-Agent: K-9 Mail for Android
In-Reply-To: <80ba45cf-2679-471b-ae3d-986697089b75@zytor.com>
References: <20250328171205.2029296-1-xin@zytor.com> <d243d203-7514-4541-9ea2-1200f7116cc1@zytor.com> <aFrbIgouGiZWf51O@google.com> <80ba45cf-2679-471b-ae3d-986697089b75@zytor.com>
Message-ID: <D379AE34-58DE-4082-B0DF-1D1AE463D19A@zytor.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable

On June 24, 2025 10:43:26 AM PDT, Xin Li <xin@zytor=2Ecom> wrote:
>On 6/24/2025 10:06 AM, Sean Christopherson wrote:
>> On Fri, Mar 28, 2025, Xin Li wrote:
>>> Any chance we could merge FRED ahead of CET?
>>=20
>> Probably not?  CET exists is publicly available CPUs=2E  AFAIK, FRED do=
es not=2E
>
>Better not, as you said it creates extra effort because FRED does lean a
>bit on CET=2E
>
>I was a bit worried that CET would take longer time than expected=2E=2E=
=2E
>
>> And CET is (/knock wood) hopefully pretty much ready?  FWIW, I'd really=
 like to
>
>That is also my reading on CET=2E
>
>> get both CET and FRED virtualization landed by 6=2E18, i=2Ee=2E in time=
 for the next
>> LTS=2E
>
>I love the plan!
>
>FRED is my top priority=2E  I=E2=80=99ll address all your comments, rebas=
e onto
>kvm-x86/next (you have not updated yet :) ), and send out v5 at an
>appropriate time=2E
>
>Thanks!
>     Xin
>

FRED doesn't lean on CET=2E=2E=2E one could argue it leans on LASS, at lea=
st to a small extent, though=2E

