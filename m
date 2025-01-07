Return-Path: <kvm+bounces-34710-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id ACC90A04A91
	for <lists+kvm@lfdr.de>; Tue,  7 Jan 2025 20:54:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A41183A68E5
	for <lists+kvm@lfdr.de>; Tue,  7 Jan 2025 19:54:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 136BE1F63FC;
	Tue,  7 Jan 2025 19:54:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="h0ashn9O"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CB261F5415;
	Tue,  7 Jan 2025 19:54:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736279658; cv=none; b=mFkjA7gmg86zl6DquR8gsv7jTtpWGeJCaNmhTGeq5fuMLtBAgVwjm2+BxoxXCQyNd+/a9XfB4Wh0x9iBX840UAsFc21n6zPROjB1lRgr0dyFMq/n1lVbdMwG5yphQlbp8C+CWw1Lj1NkFdd3zCh1Us9nKiZngIjFlx2DKquSHZk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736279658; c=relaxed/simple;
	bh=sOSrCKKxKb0Yh5caaBT4WHrgq9fiuoBVi4wD9ky0SWk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=U/O0Me2sERYrfLNh/EjLVnSzoM7t95lmgQH76Ark6aVxYasrRPm8wGPG1T19xiFcBu+PxJ3s3bD9oD1jEnkzh1eagl64EkJuaQg6ij4JBRnDfUzx3y6PMU13Gj+EUEs9btNz1L4dMjtedHWfcMYehIPnVLTK0jfPztB+0syc+jI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=h0ashn9O; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 46B7B40E0266;
	Tue,  7 Jan 2025 19:54:14 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id cHZLT2vmVHHl; Tue,  7 Jan 2025 19:54:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1736279643; bh=HJRwILgjLkoFVqNaNiMmIf7Xz052GkM4o5KUP2MlI4c=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=h0ashn9OnAAtRUKIHoWYPVGcAfON1R87XyGDrl9V9oItt0TF7p9wiy3hMTDwNjvk1
	 Mh3Ittwu+1AMlcpXCfDaGVTiUf2l67AfyirPg+vUu8LqgEGYggzwo3iMbu2cVvzbrX
	 2OoCUexrLgUowK57KsZomN2F9NRF3KUba/oR4Rsq8/mDfeZSDpsdLd69ZihLyoj/Cm
	 ezRmDP7eiJ5FESxbKrphUXRba9jJzYQ8ht4u27t2OjLoG30JU4CL8H5mLTb/gCEgB6
	 TH1hq/3ZmM/L0pkRoF6cQszXoC+XFRGQklbY9cfoWza5lwdUnAfbXRjk8gmdrWy5AX
	 XubWNPLnBkNQBTxjnVj13wYX7pLmeCwiwlc5rvXyIJ9ALTnhZkaY3wdRYQ62TVtUDp
	 Oc7raJXCyvHM70CYXMrWRtpPmv2GdTXaR80SMlFRJlqpq6n9/JgG+NGLmj7ANO0tTt
	 zX9g4FPTTJZEnxlUER2C68h5AOfDDJ03TrDuNy1V9P6kCBnwvZOL2DLJcPDMY4IdwJ
	 hetWuwbo44LJj3+MPkP5T4to+ScRo+MvEWSOKFEmqU24y2wTfMX5f5YaYFzb7cbqWK
	 q+qVfBmhMQYQvb6Xk1g3OzWA8Dl4sicL3hdvNsvUPgdDjQZ0nimoSJ6lXGNEnzuBlf
	 mac/u0Ha5NukDc/5bTqZjuUY=
Received: from zn.tnic (p200300ea971F9314329C23fffeA6a903.dip0.t-ipconnect.de [IPv6:2003:ea:971f:9314:329c:23ff:fea6:a903])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id ADE0A40E021E;
	Tue,  7 Jan 2025 19:53:51 +0000 (UTC)
Date: Tue, 7 Jan 2025 20:53:46 +0100
From: Borislav Petkov <bp@alien8.de>
To: Tom Lendacky <thomas.lendacky@amd.com>
Cc: Nikunj A Dadhania <nikunj@amd.com>, linux-kernel@vger.kernel.org,
	x86@kernel.org, kvm@vger.kernel.org, mingo@redhat.com,
	tglx@linutronix.de, dave.hansen@linux.intel.com, pgonda@google.com,
	seanjc@google.com, pbonzini@redhat.com, francescolavra.fl@gmail.com
Subject: Re: [PATCH v16 05/13] x86/sev: Add Secure TSC support for SNP guests
Message-ID: <20250107195346.GIZ32GSnLaIzboUmj_@fat_crate.local>
References: <20250106124633.1418972-1-nikunj@amd.com>
 <20250106124633.1418972-6-nikunj@amd.com>
 <de503473-e0a8-bf65-39d2-2b6bd9fa638c@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <de503473-e0a8-bf65-39d2-2b6bd9fa638c@amd.com>

On Tue, Jan 07, 2025 at 01:46:49PM -0600, Tom Lendacky wrote:
> Although if you have to re-spin, it might make sense to use the __free()
> support to reduce the number of gotos and labels in snp_get_tsc_info().
> You could also use kfree_sensitive() to automatically do the
> memzero_explicit(), too.

Let's keep that for future cleanups, pls, when there's time.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

