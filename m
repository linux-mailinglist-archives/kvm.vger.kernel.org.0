Return-Path: <kvm+bounces-25688-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CBCAE968C53
	for <lists+kvm@lfdr.de>; Mon,  2 Sep 2024 18:43:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 07BEF1C2099B
	for <lists+kvm@lfdr.de>; Mon,  2 Sep 2024 16:43:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9FF5C1A3036;
	Mon,  2 Sep 2024 16:43:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="Q0lfsSdO"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2EFD38DC0
	for <kvm@vger.kernel.org>; Mon,  2 Sep 2024 16:43:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725295393; cv=none; b=ZFyw4d4xCrq7DVlYw6XxWMMAKMWWm0c8I/Odv1Bt7FIYz0p8TG3QPCNp7ABgGW1hB7jfoU+Yayg689R4FMhgh22NCSDfysqkvXJVxR97p+S5cCGS3Gy/KwgGC6cJ0YV8u0K4lQWuibTXvs+RPgvLSQq44O4hc4OH6eFurG5KErI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725295393; c=relaxed/simple;
	bh=PoF0OhXKY5OcwmNuM3GcCzLlQlVK9juL0vDhehT/O8o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HptRrYwFqhA6nZftVLvBS52692nSymoe5jg86qgKl6Iktx/U9fqjjh1FqTiVA1Ow1S702I5++HVz4RWxK39Be271c3nIuvA1qz1DYcchsDtsGOtewNuu2Y+joMDbpW70bmjUfCObVZOEHID7K92Kc+orh5lRhIeppsgvyBdQLpw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=Q0lfsSdO; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 95FED40E0191;
	Mon,  2 Sep 2024 16:43:08 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id ckKYtZ9P00XF; Mon,  2 Sep 2024 16:43:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1725295384; bh=cWpd/W7jP0bfUkNNR90JgbXqJ3F5sjGSlF/w3xJCA6A=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Q0lfsSdO0csEsw0UQx/ldFv+peIdrERgAc/rexBb+vRhj4hsT2cKsxJpz+Z+ubvcL
	 y8BDHW5rHoXh6P4O5Qs8wlvbfgr/mm7pnI4KqyWShhZ51Hz+k20bq8wBGYRLrNdSil
	 4eA1kPV8EpW+kXefxDAr7/7cVP7QrlQOKbPM9KsCiL86PYjYLln7CW2TKDPNm7RcNZ
	 m9ICdb9taIXfm8S6OgySPLYTatodpiReeBInrzfoBebLbXK8IV44S5AHepwZ1LGfz9
	 q1JRYyjH9b+lehc63/jXZ5bdeXmeCQvznGmfK5h886qrEo0wmWSXoMo3jVuU+SxVLj
	 CXnZbrQsdl5Pbp02j43vcvGkJ995RvbD6btibPJdpcM24Q1w5uIPagvSqy0AEwij4c
	 edaBDxWBmalUrf6uezFfuGo8uzRcMEvicWF6gTaskZ8v1EhpJRRoljVaeMJS9XXCKN
	 Y34sE4Xiia6kedfyYCu0GXiGln2mqNiSqvoJpQWkxZDtli/Tnh01vL4+YRxgDDzM5J
	 zoLbg/cJyX4TCn4/kasYBmONxTj26P8KOaumGhBOFURWgqJ4At5fA4N8ybclC+hDFx
	 CS2MiOLzvMnDzRk0ivueIXbrgYjGxNB1JdUI7zoao2b0pZWzFVzjC7lELoj6JfFKPH
	 pOoIxmJGIOdbcEOU7IO+0fiw=
Received: from zn.tnic (p5de8e8eb.dip0.t-ipconnect.de [93.232.232.235])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 4854340E0081;
	Mon,  2 Sep 2024 16:42:57 +0000 (UTC)
Date: Mon, 2 Sep 2024 18:42:51 +0200
From: Borislav Petkov <bp@alien8.de>
To: "Nikunj A. Dadhania" <nikunj@amd.com>
Cc: seanjc@google.com, pbonzini@redhat.com, kvm@vger.kernel.org,
	thomas.lendacky@amd.com, santosh.shukla@amd.com, ketanch@iitk.ac.in
Subject: Re: [RFC PATCH 1/5] x86/cpufeatures: Add SNP Secure TSC
Message-ID: <20240902164251.GBZtXrC79ZX13-eGqx@fat_crate.local>
References: <20240829053748.8283-1-nikunj@amd.com>
 <20240829053748.8283-2-nikunj@amd.com>
 <20240829132201.GBZtB1-ZHQ8wW9-5fi@fat_crate.local>
 <1bea8191-b0f2-9b22-7e7b-a24d640e47a2@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1bea8191-b0f2-9b22-7e7b-a24d640e47a2@amd.com>

On Mon, Sep 02, 2024 at 09:46:57AM +0530, Nikunj A. Dadhania wrote:
> Ok, do we need to add an entry to tools/arch/x86/kcpuid/cpuid.csv ?

Already there:

# Leaf 8000001FH
# AMD encrypted memory capabilities enumeration (SME/SEV)

0x8000001f,         0,  eax,       0,    sme                    , Secure Memory Encryption supported
0x8000001f,         0,  eax,       1,    sev                    , Secure Encrypted Virtualization supported
0x8000001f,         0,  eax,       2,    vm_page_flush          , VM Page Flush MSR (0xc001011e) available
0x8000001f,         0,  eax,       3,    sev_es                 , SEV Encrypted State supported
0x8000001f,         0,  eax,       4,    sev_nested_paging      , SEV secure nested paging supported
0x8000001f,         0,  eax,       5,    vm_permission_levels   , VMPL supported
0x8000001f,         0,  eax,       6,    rpmquery               , RPMQUERY instruction supported
0x8000001f,         0,  eax,       7,    vmpl_sss               , VMPL supervisor shadwo stack supported
0x8000001f,         0,  eax,       8,    secure_tsc             , Secure TSC supported
^^^^

but in general if it is not there, most definitely.

This list should contain *all* CPUID definitions.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

