Return-Path: <kvm+bounces-32918-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C51419E1AC4
	for <lists+kvm@lfdr.de>; Tue,  3 Dec 2024 12:21:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 759A916710F
	for <lists+kvm@lfdr.de>; Tue,  3 Dec 2024 11:21:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BE0C11E3786;
	Tue,  3 Dec 2024 11:21:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="DUyN4d9x"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6342F1E379C;
	Tue,  3 Dec 2024 11:20:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733224863; cv=none; b=pH0D6vDV344LZTCoQq4AO6smspvT313MxKCpR2KnmYCBH/fdXGdluAKvmCVShG3XLUPTAgC78IxWJP0iTlBH9dLqjN8BxMMngeMhd8nc4SHa30p0wlMiaJmJk2tdbWMuIsriIitB1QMtzezdQEdW0cRBSATRDz2M6Vz8vN1wkwI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733224863; c=relaxed/simple;
	bh=dPN0mOwb0Y/fLKb/1YRJK0Ydqw49XUMXrfGIrQO+Few=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UuxX63TQ6aVvl6yAcw5r56Mxom/21CHfk4Kd5NZlCdSpetOQ7jcyBEXoiuv01MXBIDmTUfQm4XWaL3+gpPxjN02beZYMzMBJcci8nlxnkj8ozktwYc9wd/DM3OPJ5eHbQzzE3nLBD09uuGr5YpyBCQ41OaWVsl53b5Yg4kM5+nY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=DUyN4d9x; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id C3EFA40E0163;
	Tue,  3 Dec 2024 11:20:50 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id uMG_m2PsBUlh; Tue,  3 Dec 2024 11:20:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1733224846; bh=Akon8FqpbaMPcNlbRM6MS0M3aNDuYE2kNIRRuTA0OXc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=DUyN4d9x5YaGBirWqfwjWdw30hAamdERt5ajKdoJqgUa93dFIsiBdhOBcjfJGELUh
	 uJL1qDFGgQ7QrF6v9kokfA4/+bM9Jo02D45XB/7ts7/GsoIliiSdoBvsZetodwrHMZ
	 ITTdx6RZe83449DC6Qk4/zGcTCJmzsJcQJxEkLPuN0/O+O609Kf7xD28Vfl+GYggU3
	 pScNT+JfjHNYMINMJL3A5eVaBhSmX2UuCjuwfMYrawYQBzsKP4n7vPM3BvC8lSg/+s
	 dFnxjxoWmCkYIClGLnb82G+ebiSWa3u6AyCIp40lEupykzOHo2O3CVKlWW+iMHncf+
	 TqO/UX8gH2gLCvOkSHmTMmcfqcPXpAEV0eCAijE5OPTL0taaaps2aMaLmLmJbrUFbL
	 JSe6MG1faTht374SQ8veYE49Z7T7ocDUDCde0r2dwh/P8CPcZm2nrHmV5d4V4UdmsG
	 aH3phwPpfFgXuZ4R4IhhcXekJy0MGWKzJtqxJGBdf75R1qP1Ys7EnW2LH1077mTlkB
	 /Jmdc62/FEseo3XzsoowWFshlMnTIHerxniTigsZDDHMkSXGXx1KNpjiH4ZQm1a3Jj
	 6cNQWtRD7pkG/bpe1aR+uAmh6QSub2QGkpRg2+1vbFIVBwg+WNf2y99UQHNVDIGA9Z
	 pJnamu/GJb6jnw1HFeM9CYec=
Received: from zn.tnic (pd9530b86.dip0.t-ipconnect.de [217.83.11.134])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 67D3640E0269;
	Tue,  3 Dec 2024 11:20:22 +0000 (UTC)
Date: Tue, 3 Dec 2024 12:20:15 +0100
From: Borislav Petkov <bp@alien8.de>
To: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Cc: Josh Poimboeuf <jpoimboe@kernel.org>, x86@kernel.org,
	linux-kernel@vger.kernel.org, amit@kernel.org, kvm@vger.kernel.org,
	amit.shah@amd.com, thomas.lendacky@amd.com, tglx@linutronix.de,
	peterz@infradead.org, corbet@lwn.net, mingo@redhat.com,
	dave.hansen@linux.intel.com, hpa@zytor.com, seanjc@google.com,
	pbonzini@redhat.com, daniel.sneddon@linux.intel.com,
	kai.huang@intel.com, sandipan.das@amd.com,
	boris.ostrovsky@oracle.com, Babu.Moger@amd.com,
	david.kaplan@amd.com, dwmw@amazon.co.uk, andrew.cooper3@citrix.com
Subject: Re: [PATCH v2 1/2] x86/bugs: Don't fill RSB on VMEXIT with
 eIBRS+retpoline
Message-ID: <20241203112015.GBZ07pb74AGR-TDWt7@fat_crate.local>
References: <cover.1732219175.git.jpoimboe@kernel.org>
 <9bd7809697fc6e53c7c52c6c324697b99a894013.1732219175.git.jpoimboe@kernel.org>
 <20241130153125.GBZ0svzaVIMOHBOBS2@fat_crate.local>
 <20241202233521.u2bygrjg5toyziba@desk>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20241202233521.u2bygrjg5toyziba@desk>

On Mon, Dec 02, 2024 at 03:35:21PM -0800, Pawan Gupta wrote:
> It is in this doc:
> 
>   https://www.intel.com/content/www/us/en/developer/articles/technical/software-security-guidance/technical-documentation/indirect-branch-restricted-speculation.html
> 

I hope those URLs remain more stable than past experience shows.

>   "Processors with enhanced IBRS still support the usage model where IBRS is
>   set only in the OS/VMM for OSes that enable SMEP. To do this, such
>   processors will ensure that guest behavior cannot control the RSB after a
>   VM exit once IBRS is set, even if IBRS was not set at the time of the VM
>   exit."

ACK, thanks.

Now, can we pls add those excerpts to Documentation/ and point to them from
the code so that it is crystal clear why it is ok?

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

