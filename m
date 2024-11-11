Return-Path: <kvm+bounces-31504-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A11259C4325
	for <lists+kvm@lfdr.de>; Mon, 11 Nov 2024 18:04:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 654752825D5
	for <lists+kvm@lfdr.de>; Mon, 11 Nov 2024 17:04:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7EF401A4AB3;
	Mon, 11 Nov 2024 17:04:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="ktTUYju0"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FF032AF1C;
	Mon, 11 Nov 2024 17:03:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731344641; cv=none; b=E12EOHLc7c/HxMy2kbkAEpInvRC8w5tmv1L7spXYAgunqltPJ8+R977KY8Tev06umgm+IuDUqEJy8VZOqRH9wzbUpUBUBuPTSES4yotIkKcOEITNgXhMdRSu7HA/PYP3u40A+zuo/wZBuaDIc9agYqJsONMwm+kpwpcORAMUEVE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731344641; c=relaxed/simple;
	bh=b42IXBG2ZzuDtvKd6UwelPTGnlk2S+RVLNr2UIVmYdU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=upKe52vGTNRTnb3M2PqnYJQFoeLZacPum/wDBVkxAuERI2SmM/EjppEQrf3eo38lLmUF9nw4xsNm/1irtCEMw7Dr7MFKWnb+X1U8zANEJoQOMMMT0CRtPAysRtQeWHR4E63iAcmdIg++H1xlujkCrVpU6ySaxEqI2jDa+r0fWeM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=ktTUYju0; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id ADF6040E0208;
	Mon, 11 Nov 2024 17:03:55 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id JOYfo92pp0hu; Mon, 11 Nov 2024 17:03:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1731344628; bh=xLT93QlMRWqU3xrzbFjpjjh1ZpElVmgF8uk9lkKXUqs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ktTUYju0nUXlbfr4t3QdQAfcCr3lSnLVlc1xvEja1+ywGS/7epdyeoGRyZAe8MKZU
	 3f9CSavMSBvzUnpGv9eCkMxPuqHXJ3dbTfXGlrnlzgXejM+kgLp1F/XbOGTD82P8t2
	 nD17ZJbVsCKw+KJ3uQUiro3u+JvZKqSm1jbGnsTsaKT60oNJmPUgnEG60Km9QHHhp7
	 WbCO4u94+F2+WmtLYFLlRBCrXegywvGPdJVsogD9JX7/KYUg4Df5LeWV/k24qioHu3
	 ccSXEzbs2Pw01dEnRTJiFDDkTbsiV2unQIJhbjm/7V2ZUXFQXLOCj1hrPUJ1hqLY04
	 3Tftl8/gnzRsLuPzwKY2lkvhZbyd7EcUWhyyVrJbrmGD6Hhoo1Z8vxAQYbihZxmkXY
	 uuxI4rlzGCMaREP8u53iwofEqqh0Ys9uTP6FuwcEY4xTiIhotYr7AMvdo6OLDMbLtD
	 haG9PL/QwvHSkHm2Ktd/FsqiubCPahMMVh+R38bT7prN1PIKW24Ysarl6Z+xsb6s8f
	 bxPhasG2SDhgzYNE9soMOu/EE5t0SFo2eyBUc+WPGSEQDn+OH1UNQPk0DjRI4RqDRS
	 1CMV574EOZ9XHcdaY73Sokqt+STVXoDoAMkeWfspCM9tdyx45ekuZlvCvgzYa/vSBu
	 eZ0R9q4AZwjsOljpl2z58aHA=
Received: from zn.tnic (p200300ea973a31e1329c23fffea6a903.dip0.t-ipconnect.de [IPv6:2003:ea:973a:31e1:329c:23ff:fea6:a903])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 83BCA40E0169;
	Mon, 11 Nov 2024 17:03:37 +0000 (UTC)
Date: Mon, 11 Nov 2024 18:03:27 +0100
From: Borislav Petkov <bp@alien8.de>
To: "Nikunj A. Dadhania" <nikunj@amd.com>
Cc: linux-kernel@vger.kernel.org, thomas.lendacky@amd.com, x86@kernel.org,
	kvm@vger.kernel.org, mingo@redhat.com, tglx@linutronix.de,
	dave.hansen@linux.intel.com, pgonda@google.com, seanjc@google.com,
	pbonzini@redhat.com
Subject: Re: [PATCH v14 05/13] x86/sev: Prevent RDTSC/RDTSCP interception for
 Secure TSC enabled guests
Message-ID: <20241111170327.GCZzI43wnrZoMaGGMk@fat_crate.local>
References: <20241028053431.3439593-1-nikunj@amd.com>
 <20241028053431.3439593-6-nikunj@amd.com>
 <20241111155355.GDZzIok9eRWDPKnmS_@fat_crate.local>
 <638034b7-5c1e-d261-058a-79d795580410@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <638034b7-5c1e-d261-058a-79d795580410@amd.com>

On Mon, Nov 11, 2024 at 10:09:14PM +0530, Nikunj A. Dadhania wrote:
> Same message in commit and the code comment ?

Yes, the explanation in the commit message is more detailed than in the
comment below. And if you have to put it in a comment, then it is preferrable
the comment contains the more detailed variant because the comment is a lot
easier to find than some commit message in git history...

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

