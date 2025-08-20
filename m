Return-Path: <kvm+bounces-55111-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3BECDB2D84F
	for <lists+kvm@lfdr.de>; Wed, 20 Aug 2025 11:34:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2868EA01509
	for <lists+kvm@lfdr.de>; Wed, 20 Aug 2025 09:30:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B96D62DEA98;
	Wed, 20 Aug 2025 09:28:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="ihye02n6"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 964B92DCF79;
	Wed, 20 Aug 2025 09:28:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755682122; cv=none; b=MExPsDzERV5J1DQgrZtszQ0Km7OqWVfy7vQcxuT/DBux72CtgwaNNncMxcmXWzIzeA9bG5MJ75k0NJSC3RaungFfJqiDeeiJx46RNcdRwQ9fbX94hp+/f/NWSZ2d/h6XFIhujdIDyTPv22UaSkR1XN4seQmPwSlVUFataUndwsM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755682122; c=relaxed/simple;
	bh=pfipzuvQo/2bKVONaEJPkjEnyGWR0uVaiGeC6t9iyMg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=s/wW3DblZU6QDRKUbdMGyRlkU79NtBIgB2v2sLnH4TeRQwqLLdYHivAx82UEI43aknrzbC8Y67Ucviq+T8wKMDrP3vxoYCXDM9ZA1dXq4pzMO3aJctGgcL69DG3ZIRR1Gyx3nU363/69VejFO/SNzfbBCF8xWhS5jlNlnhjsjqY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=ihye02n6; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 7DB9C40E027E;
	Wed, 20 Aug 2025 09:28:33 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id sP4gNivZuxzy; Wed, 20 Aug 2025 09:28:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1755682109; bh=FMaoZYwb77gndXfYTCfwk5Udd9os45OGRqChyHPkrQI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ihye02n63PRXyClBqdSKfZqVXJpP6AJP79N/etUM9s0yi6Zn/Bka/XxQYtr+hHGjB
	 0qaCWCXJhjIpY4STVCCU28/BaxI8XfcMKEF7XeJCc1rvtPncXbCmk2oDWzmxaMbdxZ
	 CR5KarjNK6ZT3Voo7JOGJEcAWs4UxdGvfqFr8lnEpMy55i0wQoQ5g6or/eW1fd5j8s
	 i405kk/9lPdjJJCuqzWn/FHGULoBM2eus2dW8AUK6nWiPNPcmImcFqddDyNDKitced
	 psLW0K2o24F6WS3JpNFB+RHPVhvbwxIpsWeVak/SrfYuhM5bZMgmEJTwDx5Pld6j15
	 fY2sb9UHMYNQEY03mXWDhmhs7gKeWFH0geWRwJZPLLNvRHWgu2NRHsLXdG6lDxSiOF
	 DBjloLwNPIs5qU6g7/+eUgsgD5gLoxgctZ2hUaX30Xfmq6sNIhQgQt8lZ4i3bnpz93
	 r6GKDrO6zQgl8lK/HDH4UlnM5XW8opbxHf1dGBAGHMOxrF6u5DFfw2Q1yTIk/hhu5c
	 WW91IEXcd0m9fs2ak7hTjaoAunwOtHTx33QzRoJ1r1xEdEVHw8RRczGQbcT7pYwO7D
	 pAR+i/xmtM6dxeEop5PimH7VCn68FSpHAPkhEygeyRdVtj4HDPTV55joWM/oN7sm0x
	 WnIdff8dNlybJQzSXastXvqc=
Received: from zn.tnic (pd953092e.dip0.t-ipconnect.de [217.83.9.46])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 0ABF240E0217;
	Wed, 20 Aug 2025 09:28:09 +0000 (UTC)
Date: Wed, 20 Aug 2025 11:28:03 +0200
From: Borislav Petkov <bp@alien8.de>
To: K Prateek Nayak <kprateek.nayak@amd.com>
Cc: Naveen N Rao <naveen@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>, x86@kernel.org,
	Sairaj Kodilkar <sarunkod@amd.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	"Xin Li (Intel)" <xin@zytor.com>,
	Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
	Mario Limonciello <mario.limonciello@amd.com>,
	"Gautham R. Shenoy" <gautham.shenoy@amd.com>,
	Babu Moger <babu.moger@amd.com>,
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Subject: Re: [PATCH v3 0/4] x86/cpu/topology: Work around the nuances of
 virtualization on AMD/Hygon
Message-ID: <20250820092803.GCaKWVI0fkM3aaqmn4@fat_crate.local>
References: <20250818060435.2452-1-kprateek.nayak@amd.com>
 <20250819113447.GJaKRhVx6lBPUc6NMz@fat_crate.local>
 <mcclyouhgeqzkhljovu7euzvowyqrtf5q4madh3f32yeb7ubnk@xdtbsvi2m7en>
 <20250820085935.GBaKWOd5Wk3plH0h1l@fat_crate.local>
 <97aace4c-921f-4037-b8f2-c4112b4a26a9@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <97aace4c-921f-4037-b8f2-c4112b4a26a9@amd.com>

On Wed, Aug 20, 2025 at 02:42:26PM +0530, K Prateek Nayak wrote:
>       tscan->c->topo.initial_apicid = leaf.ext_apic_id; /*** Overwritten here ***/

Looks like it shouldn't unconditionally overwrite it but I'll let tglx comment
here.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

