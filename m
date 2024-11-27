Return-Path: <kvm+bounces-32558-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 524149DA2D9
	for <lists+kvm@lfdr.de>; Wed, 27 Nov 2024 08:10:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E6349B24C1E
	for <lists+kvm@lfdr.de>; Wed, 27 Nov 2024 07:10:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A810E14A604;
	Wed, 27 Nov 2024 07:10:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="QHHLPtce"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D013781AD7;
	Wed, 27 Nov 2024 07:10:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732691437; cv=none; b=IRZVHaleMKDeL3NgOzym9asVTmap8f119POK26lYHdLtmZAHldHzJiN/1UUG2JTINSirDiL57bsghNs55Asr73Rlxl74riDgTtnYFuoESJCY+2p6TTJDjMj0EF8fOceODpASiHWEV/GJ9W9MU1fGx/1Lvu5N2fti+Ge46ire1lk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732691437; c=relaxed/simple;
	bh=h/6PXM5+oeSmRI+UjWHclb5ds1HiT/ArENythA3YGvQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IKsPsH/0xPOJlxAE0blXMYKAsajFmmk3jE8WEy5EdhmlCQOrRGc3NleTRY8nKtDc+QHWX90T6tV94q1cnVJeO7CtNIYouc2aVXVEQGY8PTdN98T++NPjSLEdz9in5qdxZmp0wuC4YrT1z4VoLa19wU1QNiQSRZ/ckHAR2e7ngKE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=QHHLPtce; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id DBC9940E015E;
	Wed, 27 Nov 2024 07:10:32 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id dqphlJko5SAh; Wed, 27 Nov 2024 07:10:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1732691429; bh=UdEI40W3d2pLt5TzoYH/Wxqr7ZNKm7eelk0wt7IqSl8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=QHHLPtceeHxY1YT4Y1oyon0HpG/ePAIwZtJnko/9trT0m4s08+TgNEaDWy7lZnOoj
	 2dySuc+pg+qpo5Y1Tf9653kinTMqItPEQsBem/1uY/+9ONSbJBZNR26KVY6aolC2h6
	 RvMIVM8Ryy8Y+nopxcdTXmSkOmOA5m9jE+/U6oujJ0WHp4d2TXU3Qygl8L1Rngktsr
	 L040jV29rOSh9q9Gwrex+M1U2J3HaVP9L90EeXIJa09i+AP8127Y0Ja+KDar2o5B2G
	 QONMy+QdrbFVemerDfKPVo/jU02lYtis+JMZb0SMpSNeBN86qAxii8bjj0ibS2MC1z
	 qeGE511fWgtmKisNCjOXZ32i51lFLP7ZF1eTeDa9d1fwy0tf9Xcu9fSK/VmPO+l1tf
	 cHbI0nbU2AxD5etVOTg+1LxD8YfLIdLzZ/RgcAnqtjOPji2zEDzbazrQ/AXoTxaOng
	 EWLUEtfytzqIeS+JYwORhlb4/ArhAZ1FNMVWkfa7x4uSrru2nuGOqQ3Gn2CfYnUiVF
	 orbDq/64jLxKs5sVcfPfNWD7ZK3wJHUMWxALqm2+kj0qsRGE/2k9ZGxK811Nm5VK56
	 7Zk5hiGcFmt6LfNrXtd5/C5ORtu/uQfrPK2Pwaou8YSYsS/qpueUXzd/ubRRmK1cd2
	 rVwRlQus/OGwl/sGDfTvx4XQ=
Received: from zn.tnic (pd9530b86.dip0.t-ipconnect.de [217.83.11.134])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 73D2840E0163;
	Wed, 27 Nov 2024 07:10:14 +0000 (UTC)
Date: Wed, 27 Nov 2024 08:10:08 +0100
From: Borislav Petkov <bp@alien8.de>
To: Xin Li <xin@zytor.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org, seanjc@google.com, pbonzini@redhat.com,
	corbet@lwn.net, tglx@linutronix.de, mingo@redhat.com,
	dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
	luto@kernel.org, peterz@infradead.org, andrew.cooper3@citrix.com
Subject: Re: [PATCH v3 09/27] KVM: VMX: Do not use
 MAX_POSSIBLE_PASSTHROUGH_MSRS in array definition
Message-ID: <20241127071008.GCZ0bF0EGespFhxwlP@fat_crate.local>
References: <20241001050110.3643764-1-xin@zytor.com>
 <20241001050110.3643764-10-xin@zytor.com>
 <20241126180253.GAZ0YNTdXH1UGeqsu6@fat_crate.local>
 <e7f6e7c2-272a-4527-ba50-08167564e787@zytor.com>
 <20241126200624.GDZ0YqQF96hKZ99x_b@fat_crate.local>
 <f2fa87d7-ade8-42e2-8b2b-dba6f050d8c2@zytor.com>
 <20241127065510.GBZ0bCTl8hptbdph2p@fat_crate.local>
 <a76d9b6c-5578-4384-970d-2642bff3a268@zytor.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <a76d9b6c-5578-4384-970d-2642bff3a268@zytor.com>

On Tue, Nov 26, 2024 at 11:02:31PM -0800, Xin Li wrote:
> This is a patch that cleanup the existing code for better accommodate
> new VMX pass-through MSRs.  And it can be a standalone one.

Well, your very *next* patch is adding more MSRs to that array. So it needs to
be part of this series.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

