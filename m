Return-Path: <kvm+bounces-57213-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 78354B51EE2
	for <lists+kvm@lfdr.de>; Wed, 10 Sep 2025 19:27:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A1DE11B27479
	for <lists+kvm@lfdr.de>; Wed, 10 Sep 2025 17:28:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B0775321448;
	Wed, 10 Sep 2025 17:27:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="YoIYZjZz"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FC2C255F5E;
	Wed, 10 Sep 2025 17:27:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757525255; cv=none; b=BAL+/AQHReKph6AMKfOqocxxeJWfN1MZTs201B+MMI0dMCjt8ciZrqKE3Dy9+bauRFQW4Y800eOt0GWvZxW6hrdWI/qapbor1jmUNTub5wxnMUEpC0qR1RLrRHsUjcmHq+shV1Oa9Sn+gEgs/5u6RCCTszpkioCB+5cAb95VyBk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757525255; c=relaxed/simple;
	bh=IbDI6NByxIuvJpDQV0z450B/UbqXV9f1soeWIoUs718=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KmJy1ixWWLsrmpcsdiXPwUiX80Zgbtpf8qdq7jp7gWaqMzSRVznRCUXntYqk2z9HIZuIoF6Iw3BLAIn5tt0gx3WkS+vGDrWbfKwcs+VrIIai2RyMu+hIMcOjutGAQphvSLb8mD4qJTlfxi6ikeenwRAf3+ZFqrd5+f/xSXyqFpU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=YoIYZjZz; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 698A140E01D2;
	Wed, 10 Sep 2025 17:27:23 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id ejTizIk3HIBh; Wed, 10 Sep 2025 17:27:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1757525238; bh=AaHxBJ1T5/lzqwfAIWFqoerftxnxSVKw4mzH9fNFLvQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=YoIYZjZz7DB/GNwEwUULywd3ovui4UA0jSTMFhu59QEAtf45IB08kRZFA+JHt4Z8e
	 h8wTl7aBch86V1TbFJ6csu0YyK3MZMArHg5LKD3xKxWn7HnnTcdGejMlWP/nRuTKcH
	 asNn23Ya35Z39N9uCWjB3qBnJFGET9cAeveBzp0xyvIGQRTWL9tiCkk2cRF0bD8Mfg
	 Rc2fhhMbUc+6zj+UIge9ORMbI3zOdrvIuxJ54Kd2i54Kr27OJZJZGTAxsz5JkNXk3e
	 kGbs1v8GKaF4jF8ODc564UfR7oqMwjUZSOvMSHqYnRAHQLn6Ji2sMcKT82KMK6PV/K
	 hrW670pt2m2Ru7I+NkmUKr+oTbIr1M2u2nW1rDhG0lMpwaJ5aHl/dfe5ItJoprAGb+
	 kSOpAH6Yw1GnSNPy/e7CfcpK8pBBfkjzcMsXgyP7jMH2HdlXnmAfRoGckzw4Q6hPQM
	 ifjkfVFsDyUOj7U4UWcCXWJs1bls+JKyvFoKRkp+BdqEwSZsGc2VJCWCAe7nWgC7Mx
	 OB6qBF7WLbuv8K+jHMa63UsRB2yX5v4rMttSTxkXM6d8nZv+QXBi/GTPMQW6NK/dpd
	 Ap5kFEG/3LfRka8OpNjLATnxhZz7IXPDLPZjT4NnXXxyXjm8PxXa0PvHOBgEzBCqP0
	 GIqu/SuwgH7nbr3m+nmFGv/g=
Received: from zn.tnic (p5de8ed27.dip0.t-ipconnect.de [93.232.237.39])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with UTF8SMTPSA id 37CA240E00DD;
	Wed, 10 Sep 2025 17:26:36 +0000 (UTC)
Date: Wed, 10 Sep 2025 19:26:27 +0200
From: Borislav Petkov <bp@alien8.de>
To: Babu Moger <babu.moger@amd.com>
Cc: corbet@lwn.net, tony.luck@intel.com, reinette.chatre@intel.com,
	Dave.Martin@arm.com, james.morse@arm.com, tglx@linutronix.de,
	mingo@redhat.com, dave.hansen@linux.intel.com, x86@kernel.org,
	hpa@zytor.com, kas@kernel.org, rick.p.edgecombe@intel.com,
	akpm@linux-foundation.org, paulmck@kernel.org, frederic@kernel.org,
	pmladek@suse.com, rostedt@goodmis.org, kees@kernel.org,
	arnd@arndb.de, fvdl@google.com, seanjc@google.com,
	thomas.lendacky@amd.com, pawan.kumar.gupta@linux.intel.com,
	perry.yuan@amd.com, manali.shukla@amd.com, sohil.mehta@intel.com,
	xin@zytor.com, Neeraj.Upadhyay@amd.com, peterz@infradead.org,
	tiala@microsoft.com, mario.limonciello@amd.com,
	dapeng1.mi@linux.intel.com, michael.roth@amd.com,
	chang.seok.bae@intel.com, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-coco@lists.linux.dev,
	kvm@vger.kernel.org, peternewman@google.com, eranian@google.com,
	gautham.shenoy@amd.com
Subject: Re: [PATCH v18 14/33] x86/resctrl: Add data structures and
 definitions for ABMC assignment
Message-ID: <20250910172627.GCaMG0w6UP4ksqZZ50@fat_crate.local>
References: <cover.1757108044.git.babu.moger@amd.com>
 <1eb6f7ba74f37757ebf3a45cfe84081b8e6cd89a.1757108044.git.babu.moger@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1eb6f7ba74f37757ebf3a45cfe84081b8e6cd89a.1757108044.git.babu.moger@amd.com>

On Fri, Sep 05, 2025 at 04:34:13PM -0500, Babu Moger wrote:
> diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
> index 18222527b0ee..48230814098d 100644
> --- a/arch/x86/include/asm/msr-index.h
> +++ b/arch/x86/include/asm/msr-index.h
> @@ -1232,6 +1232,7 @@
>  /* - AMD: */
>  #define MSR_IA32_MBA_BW_BASE		0xc0000200
>  #define MSR_IA32_SMBA_BW_BASE		0xc0000280
> +#define MSR_IA32_L3_QOS_ABMC_CFG	0xc00003fd
>  #define MSR_IA32_L3_QOS_EXT_CFG		0xc00003ff
>  #define MSR_IA32_EVT_CFG_BASE		0xc0000400

Some of those MSRs are AMD-specific: why do they have "IA32" in the name and
not "AMD64"?

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

