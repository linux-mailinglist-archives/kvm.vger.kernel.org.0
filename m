Return-Path: <kvm+bounces-55042-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id BA5B5B2CE93
	for <lists+kvm@lfdr.de>; Tue, 19 Aug 2025 23:33:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4E5F91BA7CC9
	for <lists+kvm@lfdr.de>; Tue, 19 Aug 2025 21:33:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B408B343D97;
	Tue, 19 Aug 2025 21:33:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="Bpa6EGt8"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33F40284896;
	Tue, 19 Aug 2025 21:33:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755639202; cv=none; b=BkI6oIevk7Y/ROEijp46HVPQGp5EJgudO0R94Klt9/VIQdgrZlaR6tE73hn79nRr3ZeBwyiKYMRNXCVPBA/75QT98pgfB5ePzwaQOyJZUnAPgN0XpsKFCWcgDNHAsyZkBUXwSOEMJW7KjrwOIvWLCz72Yh0Jx34EqKs6n1zmudY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755639202; c=relaxed/simple;
	bh=5GKkr71Vqh1UydfQJdAoG61RmWXd5ZaX8ORcmo57KgU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Gph9AL1dlgXSI/DJypn/AayMkfExfuYxfDVT7O3KfA906Rfz/JOs8jweAdQV4bpWcN19MD8Q6VogRGhlfrhKpOj2jzZtf3hwfv6CNukK+q+wwfNn9xA7QlubHzM4G4gWTezdZ4dhMi1P5JiQenuH8EKbPyR7fWpfC7lQVCZ1bVs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=Bpa6EGt8; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id D710440E0286;
	Tue, 19 Aug 2025 21:33:18 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id Dn354hQKDEPk; Tue, 19 Aug 2025 21:33:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1755639193; bh=nAbSgNtJTr5mL95vcDKXETLp7bDfTbShwe9wYBDiXM8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Bpa6EGt8Dok47Rvv/1Xfd+kfcvv92lcJUrYu6nHS1Uwf72u6ewozutEtaf/axqjFK
	 EKZygJ/vVrc8JcFWBiFJeF9np7oo2lGvuv8m8SIR+9ssFZncu4iJ4/PqLqq7hZEjFB
	 UaOSPu5evIpO2hfZH0pWgo2EWkH0PJNrkJ6upFwyA+qag4sint05grYbdfFy4v5Ycr
	 BCFhh9JMdaEyA0fu6aQyc6SZ/ksTzhLpxB6YWZihahjbrBb3Lunpm6rcjLM/IklKFK
	 xuLHCtPb1rj+HKSKMmeJ+HNiVgG++DFYsV4S4IOgmhIiqpZd/g+VMDj3d1kaLQLWUP
	 DzOFxCh0sxMXDgtzBXaLOmxxt1EzSdSDxriE5wmgaic4TXIRy6etT1dpK8WfCi/lip
	 BQQLaFN2FxmV7tmlpehffFJ5jY9eFeLVJagd5q1crD+/wJg+xCPbCICcUWl0iyDjJC
	 UyV31WmY5smUHbKiO6jyfGdXiJ0PMPz9RMTIhETv8UNQv+1/BHfLearhZmSVBhovLu
	 r81HUIYroyYX7/ckAVFkhdfRrjmIOJqsfZxJ/EryU2se4uQgLQ/+D6xlH+sNVYrHsb
	 YCv+fT6L87XJiRx/30PbmZ80T6lZP94Pp7WdUXvEVL8PBLFokYD/cHQ88cxznZBQWX
	 Prxgk3zaim22t6freZJ8jsgA=
Received: from zn.tnic (pd953092e.dip0.t-ipconnect.de [217.83.9.46])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 6AAFD40E023B;
	Tue, 19 Aug 2025 21:32:48 +0000 (UTC)
Date: Tue, 19 Aug 2025 23:32:47 +0200
From: Borislav Petkov <bp@alien8.de>
To: Adrian Hunter <adrian.hunter@intel.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>,
	Tony Luck <tony.luck@intel.com>, pbonzini@redhat.com,
	seanjc@google.com, vannapurve@google.com,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
	H Peter Anvin <hpa@zytor.com>, linux-edac@vger.kernel.org,
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
	rick.p.edgecombe@intel.com, kai.huang@intel.com,
	reinette.chatre@intel.com, xiaoyao.li@intel.com,
	tony.lindgren@linux.intel.com, binbin.wu@linux.intel.com,
	ira.weiny@intel.com, isaku.yamahata@intel.com,
	Fan Du <fan.du@intel.com>, Yazen Ghannam <yazen.ghannam@amd.com>,
	yan.y.zhao@intel.com, chao.gao@intel.com
Subject: Re: [PATCH RESEND V2 1/2] x86/mce: Fix missing address mask in
 recovery for errors in TDX/SEAM non-root mode
Message-ID: <20250819213247.GJaKTtf1er-Ced_mzP@fat_crate.local>
References: <20250819162436.137625-1-adrian.hunter@intel.com>
 <20250819162436.137625-2-adrian.hunter@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250819162436.137625-2-adrian.hunter@intel.com>

On Tue, Aug 19, 2025 at 07:24:34PM +0300, Adrian Hunter wrote:
> Commit 8a01ec97dc066 ("x86/mce: Mask out non-address bits from machine
> check bank") introduced a new #define MCI_ADDR_PHYSADDR for the mask of
> valid physical address bits within the machine check bank address register.
> 
> This is particularly needed in the case of errors in TDX/SEAM non-root mode
> because the reported address contains the TDX KeyID.  Refer to TDX and
> TME-MK documentation for more information about KeyIDs.
> 
> Commit 7911f145de5fe ("x86/mce: Implement recovery for errors in TDX/SEAM
> non-root mode") uses the address to mark the affected page as poisoned, but
> omits to use the aforementioned mask.
> 
> Investigation of user space expectations has concluded it would be more
> correct for the address to contain only address bits in the first place.
> Refer https://lore.kernel.org/r/807ff02d-7af0-419d-8d14-a4d6c5d5420d@intel.com
> 
> Mask the address when it is read from the machine check bank address
> register.  Do not use MCI_ADDR_PHYSADDR because that will be removed in a
> later patch.

Why is this patch talking about TDX-something but doing "global" changes to
mce.addr?

Why don't you simply do a TDX-specific masking out when you're running on
in TDX env and leave the rest as is?

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

