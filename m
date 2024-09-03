Return-Path: <kvm+bounces-25710-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id EA9ED969506
	for <lists+kvm@lfdr.de>; Tue,  3 Sep 2024 09:17:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A19791F2661A
	for <lists+kvm@lfdr.de>; Tue,  3 Sep 2024 07:17:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9682F1DAC6B;
	Tue,  3 Sep 2024 07:16:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="T38ABwOp"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C7CE1D678C
	for <kvm@vger.kernel.org>; Tue,  3 Sep 2024 07:16:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725347797; cv=none; b=kSQXPtLqIfGaiFInppFn22NMxvFJgtLJ3VT4oHLdgZXbbbfpfbjFCxxVcfyby1DCJzAsHUDMCufjSd0vlApZgnhmZ2e55HTBLsMhVi3nqN0Cw1ZhKFA69JvHWmvDxug812VduEYuwfY70ET5WTma92zK9QU3AtBAvzMkNyOltlE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725347797; c=relaxed/simple;
	bh=ijR5+lWplUlUteqROhswPoMMYQTBwXTytdQTjz0XShU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KulP/qcXWYn1YnNi1GrdzeinGpUKAeMvqkEYcpA96vTPnnxr8EFbPDdDuCb+NC4TQwJXNLnFFDfic6sk0u9NcbQT4T6D0JvJyoSkVrwlHl6oJLjMflgQlBfAESnVqBC8JYEmEXSNWSsClPZ99yvtH7o9/jGDYamF0IE80yrsz4I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=T38ABwOp; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 0454E40E0285;
	Tue,  3 Sep 2024 07:16:30 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id RWJzP4XrWi-b; Tue,  3 Sep 2024 07:16:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1725347785; bh=k8tI9GnMrvYUuEW0wAp1ZdXOXM6cOhEUswy+rgLcwHM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=T38ABwOpwXmpGIfEdRMZP1MopDR6bXuV9+d3X/AXTVlSBxnR/yXiBwUiYW+JoNhC2
	 SuH1ki2sZpbFevt2kvXvg7PLe31ZLEoj9M16wvNzlVDVi0bUXPPEnAMTGt9loQaJ3C
	 /Q6+Xre9Q8jstuEMWoeCFRs89yUPOJvn9PRCeq6nOJFqzvgywh4tuPktHht7Hx20Qr
	 xgIz5MwLWbi1SJK4mJ3C7z8YJjQweLKRKWRD5vOfCtleKIHgjK2xwRs9zOm+S8d9D/
	 8fbU0BT0nu+IAlnWFXcLJ+kjZNxRih/FFLL6uZ64RMO49e0LrbDVCJ1SNcmmNHujQn
	 OcFkHBrKd3QXosjv4ikw9KWegyFi/HC0OvZqq/GFEZqBuCt4AysoiNslSQ7Tfantcy
	 CylqeZL+dEXPpgYPtQeqwtt+aTclZQUNJKjbmMPbG2sBJgmulWtqLNlTowBGybPsxO
	 Yx8q+o/3jeaDBALG3mM600O0TLcrS2ogEqb2J16Puo5rW6C1cMbgITi5pvQUkdEBd8
	 kX/uvHno8dsOCc/ns9RFC6KrX+Z9JgyiAEZqYIlcGLgi4vFTLXR5oNVFfzerAo1npp
	 Ta3JG2ipcRdsJ22hObyKOFcTvgk99CIG9yAYwxoPmn4Rt+a5kyjFFbPX17ybJWV1rD
	 D5W7nfcZLQYcotGqmqXjU89Q=
Received: from zn.tnic (p5de8e8eb.dip0.t-ipconnect.de [93.232.232.235])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 9B87940E0198;
	Tue,  3 Sep 2024 07:16:19 +0000 (UTC)
Date: Tue, 3 Sep 2024 09:16:13 +0200
From: Borislav Petkov <bp@alien8.de>
To: "Nikunj A. Dadhania" <nikunj@amd.com>
Cc: seanjc@google.com, pbonzini@redhat.com, kvm@vger.kernel.org,
	thomas.lendacky@amd.com, santosh.shukla@amd.com
Subject: Re: [RFC PATCH 1/5] x86/cpufeatures: Add SNP Secure TSC
Message-ID: <20240903071613.GAZta3vWChVfE-S13E@fat_crate.local>
References: <20240829053748.8283-1-nikunj@amd.com>
 <20240829053748.8283-2-nikunj@amd.com>
 <20240829132201.GBZtB1-ZHQ8wW9-5fi@fat_crate.local>
 <1bea8191-b0f2-9b22-7e7b-a24d640e47a2@amd.com>
 <20240902164251.GBZtXrC79ZX13-eGqx@fat_crate.local>
 <5239c9b8-a116-1f57-fd8f-8a50d0c2ba89@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <5239c9b8-a116-1f57-fd8f-8a50d0c2ba89@amd.com>

On Tue, Sep 03, 2024 at 11:13:45AM +0530, Nikunj A. Dadhania wrote:
> Ah ok, in tip/master

What else?

See, we document these things not to waste space on people's hdds:

Documentation/process/maintainer-tip.rst

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

