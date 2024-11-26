Return-Path: <kvm+bounces-32529-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id D06D29D9A77
	for <lists+kvm@lfdr.de>; Tue, 26 Nov 2024 16:34:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 1160EB251F7
	for <lists+kvm@lfdr.de>; Tue, 26 Nov 2024 15:33:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EEAE31D63F0;
	Tue, 26 Nov 2024 15:33:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="APZ7VXqW"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5EBF1D5CFE;
	Tue, 26 Nov 2024 15:33:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732635212; cv=none; b=C5gqQ49cKplZYNfbUPGpObi4xhQtsePXsQaiX4i02u0vMKr6zloohjV9lLBBBGTa4YOj66bwtSEQ4VvIqtiohglbVpNHxRDy+47Y5Zc34yF1oUgmZi+c/stAaO/iHkjIl1MW46vh2rBHpxFcl2Af4CffRJrp2YY3SW2p7RZPsY8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732635212; c=relaxed/simple;
	bh=nxnmAuLKYJi66hhvY7QwT5Vtfn9Ggz8D0cIPiCp3yaY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=owoJdRf3h/3OhXVj9Eh134v5pVd5wDdbnkpncBILKIP6HIE1lJP6Uw+wG9M8nBtPDgQ1rJFjXGQh2Zxep0SDFdtYFB7/1mopvWzT8aPTox63aHiwbk7d/kQceQ3TGJn8wFZiAALF0LopltkNJocMdU3Ue57SYIedphVKOQiE0r8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=APZ7VXqW; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id D23A740E015E;
	Tue, 26 Nov 2024 15:33:25 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id akIB6_p_7tDu; Tue, 26 Nov 2024 15:33:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1732635201; bh=aCkBNu0K3VWgvGWy++Ru7d+M1x9LxDkBkYyYabjnHqA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=APZ7VXqWTEQfaJ4srzKukUYpg/PpLA3Mx2gvKz90SS7DENOeMHQU3TojGdNK3AMk1
	 ieqDcNRgfGAHyTtj9BKMSF4C3UtglkEBpRR8sgbPMjLiMIt9PDfq1ku/duw7fliME7
	 DYBSvmeu4hCA/UJr+RGpmfYzn9EPSHDZlU8TS0pNcPUJcPKglR1KYdafmkza+ieEPX
	 iIe4b3yrc/0kUV8R6N5LHZsw7g7V8kdN9tiKeO/lgicKLQK3f3a6IaU3PhsP4vCCjZ
	 gegQO56qbYZPxO7myIJhWnMS1D6Hnpx2A5wlr+l4kNwPlKqyHIKS8iwszsWvs3ClRl
	 UaCZ8dosBpNXUi+f5fccE9IX6JvgQF6lAsWr3nWZSb7r6PbGT5B4yY3cAuzVSAD2Wx
	 Pl/Ai2IcNIs3qaCdv6KwZXO0rNBkZfTsrpr4b3Dv3fPX8O1sF050gn5D1b23U4kXkF
	 SzenE/L5dCIzo9cpY7O9brjg3R4Rj5veSikYtKpeUAIilg9i7xI4DEMNxstIHjuYne
	 S+Eq8In4pN+f8AK4yjGkVpeI4Xy/k/9p1lXiLEQIoznSItEsWsJNJwZwG/nX75qej/
	 8+MgQ+i+uXjrwtbkp54NK4pSqKWnIs/fofQZiZOUVIsyTu/rD8+GTWSWio5aMbn4jb
	 yjKm434OPEUeJtIGqe8VZf2w=
Received: from zn.tnic (pd9530b86.dip0.t-ipconnect.de [217.83.11.134])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 160D440E0163;
	Tue, 26 Nov 2024 15:33:06 +0000 (UTC)
Date: Tue, 26 Nov 2024 16:32:59 +0100
From: Borislav Petkov <bp@alien8.de>
To: "Xin Li (Intel)" <xin@zytor.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org, seanjc@google.com, pbonzini@redhat.com,
	corbet@lwn.net, tglx@linutronix.de, mingo@redhat.com,
	dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
	luto@kernel.org, peterz@infradead.org, andrew.cooper3@citrix.com
Subject: Re: [PATCH v3 05/27] KVM: VMX: Disable FRED if FRED consistency
 checks fail
Message-ID: <20241126153259.GAZ0XqK92lqgV7a475@fat_crate.local>
References: <20241001050110.3643764-1-xin@zytor.com>
 <20241001050110.3643764-6-xin@zytor.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20241001050110.3643764-6-xin@zytor.com>

On Mon, Sep 30, 2024 at 10:00:48PM -0700, Xin Li (Intel) wrote:
> +static inline bool cpu_has_vmx_fred(void)
> +{
> +	/* No need to check FRED VM exit controls. */
> +	return boot_cpu_has(X86_FEATURE_FRED) &&

For your whole patchset:

s/boot_cpu_has/cpu_feature_enabled/g

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

