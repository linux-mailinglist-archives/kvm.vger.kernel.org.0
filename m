Return-Path: <kvm+bounces-25241-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 14D349624CD
	for <lists+kvm@lfdr.de>; Wed, 28 Aug 2024 12:24:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A7F701F25585
	for <lists+kvm@lfdr.de>; Wed, 28 Aug 2024 10:24:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9A74ADDDC;
	Wed, 28 Aug 2024 10:23:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="ByTxmvBW"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D6E016630F;
	Wed, 28 Aug 2024 10:23:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724840630; cv=none; b=qDV8if1tTSfspYivUJ5VmOLVIsA97YxBxCS53mOtAYZiqmF4gYVaYxTOf7IY7RXsfYk3PqD1jMnyUGlrAdOJLLbOgPkU70Kd1qY0oEb/5gE+A+tzrB1TtLEzHLWY8DR+v7sEHiXIzdc49TQT677EXDQDbhphlfa5IDKhGri+aqI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724840630; c=relaxed/simple;
	bh=WkeWkMHT8wJffburwSLbbQl3fGKE0R0M5twr/hXzINw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=G6wYmXJ9p/Pq5qqfkhKIemqOSBJYTcYMR0/OUZp/DDH9ww4mWXXPgs6vG0Ep49R0S1pnMJve0qo20jmCD/b9ZMzL9KPA+qD4vk+JB970IiIOFslyNKsrOI96djxc/FM0vSyeeNsMhBuYA55UEG7W7VSPQYRdUNu8JFJOwC8sxqw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=ByTxmvBW; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 073F240E025E;
	Wed, 28 Aug 2024 10:23:46 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id QOgJoKfMJfor; Wed, 28 Aug 2024 10:23:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1724840621; bh=ddCbswtjTTHgDRFIT8XIkmnHRxR08h6tTIECtSm3fKw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ByTxmvBWJnONmGpOAoF2R0u4iMB1sYKum675i9AQIA9+bPv5zeaw1jtFjSHVAa3Um
	 uED/jGJx+9BfCIvlSbmP5DGPfmnWJSxkvASJfgrMd7KkUGTL++siweoEcMe3aX0AFo
	 E16XB3fjXRfjzLOX7c2QPHcVNy04K8Szs3bOsPlPKFdR7M0uI3ZtpZstwIv4d3P3CH
	 yjIg1FpigC8i38XyvesjdOEN9zDspmgfXdzW3y32g/Lof8Z8svneKaBER2qkPZKh66
	 GCgIq2THCfAb/1KkDVAgJlCMo/n3hz7Jpko35/l0qaiDizx4kiJPNOdEEGk63vz0kp
	 86TaiSc3XhXTBqx4VZrRpT9+4JvaKzdYMlZd8Gxo1aHa60rioDr2OYIhewuF5R5Kzm
	 CRXq5e38et/yIZyDd63sNDZ3MLOo3DtJtYmD1GiCkHWgIQ9zKBucLU8nyPCMDkAu3Z
	 oEeaG0dHbQYNJR4PDjryh+4Qy7j8v9U5bPSDQuSv9Hlm32k2qUZX5rGletywyguOYn
	 j/ndFBvvt9ikLbkw8mzxauWH8DDraJDQ7LXtlhpqieU9A3rIqDuyd4VC7gYpYKlA8w
	 Ep7NcnS1NX2HWtSwqF+QjDdZrn9pHl+unNpvgE4bIJLdjVMPq0fahqRcARgSXGNqNm
	 uJk2cjR8pq6rfYSS7RnW1R6U=
Received: from zn.tnic (p5de8ee85.dip0.t-ipconnect.de [93.232.238.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id B27C240E0169;
	Wed, 28 Aug 2024 10:23:30 +0000 (UTC)
Date: Wed, 28 Aug 2024 12:23:25 +0200
From: Borislav Petkov <bp@alien8.de>
To: "Nikunj A. Dadhania" <nikunj@amd.com>
Cc: linux-kernel@vger.kernel.org, thomas.lendacky@amd.com, x86@kernel.org,
	kvm@vger.kernel.org, mingo@redhat.com, tglx@linutronix.de,
	dave.hansen@linux.intel.com, pgonda@google.com, seanjc@google.com,
	pbonzini@redhat.com
Subject: Re: [PATCH v11 06/20] x86/sev: Handle failures from snp_init()
Message-ID: <20240828102325.GBZs76nXJVyj-pILca@fat_crate.local>
References: <20240731150811.156771-1-nikunj@amd.com>
 <20240731150811.156771-7-nikunj@amd.com>
 <20240827113227.GAZs25S8Ubep1CDYr8@fat_crate.local>
 <5b62f751-668f-714e-24a2-6bbc188c3ce8@amd.com>
 <20240828094933.GAZs7yrbCHDJUeUWys@fat_crate.local>
 <94899c78-97e3-230a-a7eb-d4d448d9fa75@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <94899c78-97e3-230a-a7eb-d4d448d9fa75@amd.com>

On Wed, Aug 28, 2024 at 03:46:23PM +0530, Nikunj A. Dadhania wrote:
> Do you want me to send the patch again with above change?

After I've gone through the whole set, sure.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

