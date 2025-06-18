Return-Path: <kvm+bounces-49790-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 833B8ADE1B2
	for <lists+kvm@lfdr.de>; Wed, 18 Jun 2025 05:35:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 32EC617AE50
	for <lists+kvm@lfdr.de>; Wed, 18 Jun 2025 03:35:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0CEE21DC9A3;
	Wed, 18 Jun 2025 03:35:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="uY/d77SC"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 643BD28E7;
	Wed, 18 Jun 2025 03:34:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750217700; cv=none; b=Uwq5aIcAbfT3+5qixBfGiRYmFPk5mztaz2qVKmSGELuFiJ/ADHTVI09KfjSL9PXecEwqqQxfTkCLnsRAy3PygZPhHeNfTIGCmC3ee6fwjv1h+UQt7r0TRUmqDwfSWiTBkWoinKpTUfoLh3BcIAmlefC422HaKmsNGRTcdY72p14=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750217700; c=relaxed/simple;
	bh=QADJZu+wYVE4rOxfgnFlkA3juPVE4g6tlhVku56dgKk=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:Message-ID:
	 MIME-Version:Content-Type; b=XdCpPNosT1XPPAMIATSwiLMuKDAZCCh7VDWMeWkD2buVqeMRE05tTEbjSY2M5Iwt2qA8NFrONLuze7gW2ZuuoVKFWyzZdpDrrl9N89mx4fy5L1+7z+qggZwu8gajBDn3DVg0EODyfwyWTxQld9w89wX8Yll0A3UA2YvKdR2jAGw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=uY/d77SC; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from [127.0.0.1] (c-76-133-66-138.hsd1.ca.comcast.net [76.133.66.138])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 55I3YHB31384936
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NO);
	Tue, 17 Jun 2025 20:34:18 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 55I3YHB31384936
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025052101; t=1750217659;
	bh=QADJZu+wYVE4rOxfgnFlkA3juPVE4g6tlhVku56dgKk=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:From;
	b=uY/d77SCwbZHK5KwLWXdhqYYiM2E1LbziCx7+ZC+2oeozKBooOT2Bwad0UW2OlQjL
	 6hX/j76nPeFUmSIqoUn0X7jGT3nH8w08FllI/eaz+yFivY6B6cLHG+I50Z0BSEYFKR
	 X3kCVt/3e9rBZ6Mhs+cYSXWn2ErlFMyGU7EmijgUas1N+RGmKzuuGEmVQXuBUrbkdg
	 W9cQvybFTRe/EfymO8M21dnCYM1ZubRsrLC1ERd3V/MbOpAK8mNYj4JtuYMGgjmHqX
	 KIdYeyPNLpt2143beD+dlIKquzLI4rsWDZiQ1s+fGmCvye7rfRiYFWQ8yrbeM8rJlH
	 PzImWPxTxog0Q==
Date: Tue, 17 Jun 2025 20:34:17 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
To: Xin Li <xin@zytor.com>, Sean Christopherson <seanjc@google.com>
CC: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, pbonzini@redhat.com, peterz@infradead.org,
        sohil.mehta@intel.com, brgerst@gmail.com, tony.luck@intel.com,
        fenghuay@nvidia.com
Subject: =?US-ASCII?Q?Re=3A_=5BPATCH_v2_2/2=5D_x86/traps=3A_Initialize_D?=
 =?US-ASCII?Q?R7_by_writing_its_architectural_reset_value?=
User-Agent: K-9 Mail for Android
In-Reply-To: <1b8095a8-1e65-4508-b874-fa2fce1b00ee@zytor.com>
References: <20250617073234.1020644-1-xin@zytor.com> <20250617073234.1020644-3-xin@zytor.com> <aFFvECpO3lBCjo1l@google.com> <9720c605-c542-4969-b7f0-b4477bc2ab1e@zytor.com> <1b8095a8-1e65-4508-b874-fa2fce1b00ee@zytor.com>
Message-ID: <3305378C-7D27-4A89-9DF8-B7F1A1582613@zytor.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable

On June 17, 2025 5:15:18 PM PDT, Xin Li <xin@zytor=2Ecom> wrote:
>On 6/17/2025 4:08 PM, Xin Li wrote:
>>=20
>> I hope the bit will be kept reserved to 1 *forever*, because inverted
>> polarity seems causing confusing and complicated code only=2E
>
>BTW, FRED flipped BLD and RTM polarities in its event data:
>
>The event data is not exactly the same as that which will be in DR6
>following delivery of the #DB=2E The polarity of bit 11 (BLD) and bit 16
>(RTM) is inverted in DR6=2E
>
>
>I=2Ee=2E, BLD and RTM are active high in FRED event data=2E

Yes, we designed it so FRED (and VTx) are always active high

