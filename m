Return-Path: <kvm+bounces-55107-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 756ABB2D76E
	for <lists+kvm@lfdr.de>; Wed, 20 Aug 2025 11:03:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 674F43AAD85
	for <lists+kvm@lfdr.de>; Wed, 20 Aug 2025 09:00:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8C6112DAFB7;
	Wed, 20 Aug 2025 09:00:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="G7IsIJv7"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED68D25F998;
	Wed, 20 Aug 2025 09:00:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755680409; cv=none; b=seMd+I9kDCyXhSmpHg+U7CzREF7KW9qgblWzUfI1AbeMctfH3qfrMfWHSxo+QsGrFLoGBlMzaVWydAJlIMbd4iVGQuR65waQPCvrcpyFyROmPq0dJGv3xC3agonqeXX9Xq48Eh2h1utYJFTLYxz9KbEYoAfb2WtYY0uGZB6aLoE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755680409; c=relaxed/simple;
	bh=txs/vM6W8Yv/7EZjG/Md1COukCyt+gv82O8XJ50xA90=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jwr6xd+/1Y6KE8DntwDDBCeEDoSauSn9m0E1qqzOeFGPApzH4XJbkG+ODakAdYdR0x1yZFg9yfYh3tnx+4wrGFU9Up1eoD5fhGb+GoOdXMSke50tISAkqLow5uWpfM37M6notNUlswsQPQGeSaR0ut+UsmOaClc0RQGBpNmJKGQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=G7IsIJv7; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 4D80240E027E;
	Wed, 20 Aug 2025 09:00:03 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id 3IOq7lNCDxO3; Wed, 20 Aug 2025 09:00:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1755680399; bh=beySYSjjYv/3HXXkq0/rNq324ZfG9YsZxFSqt79VFc8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=G7IsIJv7HnX79b+e7Aw9+b5OBqD0o5IwHBtS1HSpOYaDVE0aMMilWv9FCQWdvwdyj
	 7dF1juRVqxwd/HTD1ar5ANctaUc8CPwfONMs7R24YcMC8aOl1fPMR8yn5Lm0kaQApI
	 QsK5iC3E/YtCm61EtNNFJplRYVWhBqmjLVYI3y2IwXyRqlUy91rhMufU0pxkVJ3AkU
	 0sHIxl6HcT6IErBT2GfC8ruALpqxFNkP96ZIYNBNVVG+g/3aaonX5vjCTlMmvU432l
	 xaUdqeO3JXTWcOibyhPxpmHk4KY8X2VtQVLfQ/r/OHcToprspYU+ya82OrymJo4nGr
	 lGGHqT2+Dqx3dSzsKgka2kjftCGserjXFqY4NeCC6v6x7/NY6O8bkZtRxdFjw8PAtf
	 8lcCRC25NM7vGhDjif8GOmal5hqIiSJcIlKZXwq37PTYwD3rhJlZ2biEMcHnWptWfd
	 R5qln9p7YVr/Nfw3V36jogBQu4qo/vllkcjum+H2m+x8JOSwal2ApdRUT7yr7LwrM5
	 WQkGCkVZYsm1nL9DiqB1zgGBmDeZQDLaJuEM++LT/3JFRAwbb+GLRo8iRpsm4GY94G
	 NMsZpNXpFxXcl7nwTnlAKzuiPO5POQ+gKYOmF9g10Pr4xFn7BFqUBHLPqtrvOrGjQ7
	 4jZKD5ZDlkO358JoPbKhGVTM=
Received: from zn.tnic (pd953092e.dip0.t-ipconnect.de [217.83.9.46])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 8729240E0232;
	Wed, 20 Aug 2025 08:59:40 +0000 (UTC)
Date: Wed, 20 Aug 2025 10:59:35 +0200
From: Borislav Petkov <bp@alien8.de>
To: Naveen N Rao <naveen@kernel.org>
Cc: K Prateek Nayak <kprateek.nayak@amd.com>,
	Thomas Gleixner <tglx@linutronix.de>,
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
Message-ID: <20250820085935.GBaKWOd5Wk3plH0h1l@fat_crate.local>
References: <20250818060435.2452-1-kprateek.nayak@amd.com>
 <20250819113447.GJaKRhVx6lBPUc6NMz@fat_crate.local>
 <mcclyouhgeqzkhljovu7euzvowyqrtf5q4madh3f32yeb7ubnk@xdtbsvi2m7en>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <mcclyouhgeqzkhljovu7euzvowyqrtf5q4madh3f32yeb7ubnk@xdtbsvi2m7en>

On Wed, Aug 20, 2025 at 01:41:28PM +0530, Naveen N Rao wrote:
> That suggests use of leaf 0xb for the initial x2APIC ID especially 
> during early init.  I'm not sure why leaf 0x8000001e was preferred over 
> leaf 0xb in commit c749ce393b8f ("x86/cpu: Use common topology code for 
> AMD") though.

Well, I see parse_topology_amd() calling cpu_parse_topology_ext() if you have
TOPOEXT - which all AMD hw does - which then does cpu_parse_topology_ext() and
that one tries 0x80000026 and then falls back to 0xb and *only* *then* to
0x8000001e.

So, it looks like it DTRT to me...

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

