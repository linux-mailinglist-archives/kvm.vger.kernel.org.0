Return-Path: <kvm+bounces-55625-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B02DBB3453E
	for <lists+kvm@lfdr.de>; Mon, 25 Aug 2025 17:10:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C470348192C
	for <lists+kvm@lfdr.de>; Mon, 25 Aug 2025 15:07:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 441A02FC011;
	Mon, 25 Aug 2025 15:07:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="Yh7YATvS"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAEC7611E;
	Mon, 25 Aug 2025 15:07:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756134452; cv=none; b=p8xg0cci7eXOu6VnqnrR9Jfc4Mv5XTaiSK5v2Ujac//QmPT/+rZuP/+foxtic64lQL2GghIszE/zBHro9t0iE+FFULpw2DBiWDZ2KoZAZQUB1+7vmJ5KJsWwh0EV4RKAZWjAlzD7dJ/0N7vPHZJhuGZtsx6zGyRoHm/nRVkLu/E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756134452; c=relaxed/simple;
	bh=vs614cjVbkXrHqmrqUy5gJOdGaDMPLKQD2BjzEuQqPY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rle1/muDncBrsVsbmaFdFg3dPlNwxj4kJXMJu/+d0Y0Xpq3l+aCNxiaFY/Pnx0I3GuGVPP6ljkCU/YuTy8JJMIaF8kYlqC6Wu2Bz0coaum5ClnKvPf5wL1ctmxbC13C5SO/8xAIfg+TLHY3poP5s4xWcObExKU3frwxaF/gbnhw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=Yh7YATvS; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 2F8D240E01A1;
	Mon, 25 Aug 2025 15:07:28 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id BIYyjupB5BrM; Mon, 25 Aug 2025 15:07:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1756134444; bh=eDbhlwZJw6ENl+QzRxKbsR7aRJTF/4MFwWPYuUGpZCs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Yh7YATvSeG3B+h+I8JASERwcDhhHmx1RHLI2M5DqhR/0zzUtHRAV3h1A+IttnqLUD
	 hxTg4dRIppiwdE71ZA1z4WoAPovQCyKH2E1jyWo3WbJKw7XSWt7oX//Ogv0Ea+7NNS
	 XMFVyym/wPq1/4A2UIymVAY6c8SaGOGdluvOOTX/O+zsb76Ugx6zchGZMVx4mEOn3x
	 Kr2soTcw8S095Uta+WCG8pXM+LPclPa7zkrvgKrHauB9u7n1B8vL+NWWh/r63dIxx4
	 7yY6mvPMkeRp2IRbnoaczHHXx6ir2boR9xB8fxh60Xr/82TyFdUTXvZl+h8qvsz/K6
	 MwP9GhNBymaVi3eoBr4dM7F28KFCJyapNHaZ+BQeh5oxguepXMD9o4foYYAATnBRcz
	 ASdAFKB1q70NujnW5jbr1rKeMJlwY9RptjyrddUCkNcFWtJ6T+sTwT6mRyxNDi99ia
	 2k6JumsglJvsdG3kel+Ob4hp/HnIWEU3tq81fu0pLOtlcXnWpDOrHhn0wNLwcdvRM6
	 0v3z5wYJHyYXpTbbc6FVNXXxfyt0dSooJXUSsbJl/DytVsXUplXxBfbgcTjmGb/E4n
	 v7Lxe0K6dm10LBPuaX45fQv/4cUY966hzvlcHPWvu3MTAmKjcn+9G6pApYJCy5TFgC
	 xt+FgjbGTaWHFvZl1gpqWGM4=
Received: from zn.tnic (pd953092e.dip0.t-ipconnect.de [217.83.9.46])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 78A2740E0202;
	Mon, 25 Aug 2025 15:07:02 +0000 (UTC)
Date: Mon, 25 Aug 2025 17:06:56 +0200
From: Borislav Petkov <bp@alien8.de>
To: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
	dave.hansen@linux.intel.com, Thomas.Lendacky@amd.com,
	nikunj@amd.com, Santosh.Shukla@amd.com, Vasant.Hegde@amd.com,
	Suravee.Suthikulpanit@amd.com, David.Kaplan@amd.com, x86@kernel.org,
	hpa@zytor.com, peterz@infradead.org, seanjc@google.com,
	pbonzini@redhat.com, kvm@vger.kernel.org,
	kirill.shutemov@linux.intel.com, huibo.wang@amd.com,
	naveen.rao@amd.com, francescolavra.fl@gmail.com,
	tiala@microsoft.com
Subject: Re: [PATCH v9 10/18] x86/apic: Add support to send NMI IPI for
 Secure AVIC
Message-ID: <20250825150656.GXaKx8ENWi4X5RN2RA@fat_crate.local>
References: <20250811094444.203161-1-Neeraj.Upadhyay@amd.com>
 <20250811094444.203161-11-Neeraj.Upadhyay@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250811094444.203161-11-Neeraj.Upadhyay@amd.com>

On Mon, Aug 11, 2025 at 03:14:36PM +0530, Neeraj Upadhyay wrote:
> Secure AVIC has introduced a new field in the APIC backing page
> "NmiReq" that has to be set by the guest to request a NMI IPI
> through APIC_ICR write.
> 
> Add support to set NmiReq appropriately to send NMI IPI.
> 
> Sending NMI IPI also requires Virtual NMI feature to be enabled
> in VINTRL_CTRL field in the VMSA. However, this would be added by
> a later commit after adding support for injecting NMI from the
> hypervisor.

So drop this whole paragraph. No need to mention that here.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

