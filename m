Return-Path: <kvm+bounces-31839-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id BCDD89C8441
	for <lists+kvm@lfdr.de>; Thu, 14 Nov 2024 08:50:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 801AC282AC7
	for <lists+kvm@lfdr.de>; Thu, 14 Nov 2024 07:50:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 555461F8194;
	Thu, 14 Nov 2024 07:48:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="OZvxdGjc"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BDCA1F756D;
	Thu, 14 Nov 2024 07:48:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731570503; cv=none; b=mV4APyPPXtxjUzePlmB7MXRwIkUQo1jyVeq7Lz3DpiMU0BCL4URjHUDhPhymrcn8S9TDKBSUDmie9Y+uZmbRO1DR1AU7uhqcY6hZ68MCfWSY5fketx50gPhqp7n/aVR+ovVsrWM18JJ/hKF6uYo+DlPcY0MAetnVgHXLhX8iED8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731570503; c=relaxed/simple;
	bh=VhIVxSf64TL+RKk03i17FNYbWe9fqXELqvWOEg63o4I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RLN2+nX71VGee1loRhDfKuXqXsu2Tl9M3Ec7i0xwZGfKUOE+Mwn1wPyLD+vxunyDtRtLpS1V5l1RwgMxgl/X95lUXgVqZG/PJQd52LfdLKulhrDBNd4bTWmxqIVDALz/4e92Vup370uNKFO+tyOc+OPoj6pYoSudqoi8+Yud6dA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=OZvxdGjc; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id B31E840E015E;
	Thu, 14 Nov 2024 07:48:13 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id KcqmbqV9IE8D; Thu, 14 Nov 2024 07:48:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1731570488; bh=SAvtplwexqx24144/4H/qXv46ZRBhLOF+FmBUrb1yYc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=OZvxdGjcJGbVQeLaHVR9CVmEPCqvoLs39vQ1JIxoTK4EVhJk0+TK4jnwZesyxPydF
	 MrfuhNrV/JBzbUF/hvY+Zf3UGcCQF7DDHhdsv71702MaRcS7x65mU5GsOOuQOrw3tO
	 kmmpIMGCQInT9lu6eODYYSffaAejrgeEFzn+JawhNFRlmv0HgaY4w+vNIIDbtEQ/t4
	 fWYroy+L93Nuv7tENcWAlJMnlTyWVbbE0P0FndwLb+0lUexoGZEGa1CaWFzjCoU6Qd
	 hkO/hBdbPATsUtG167X3vQoqMpaQJSGsFZ7cHuZX9ddD48Q+dW+dGbt73DcL7GcNUR
	 cczu/hus1uaR8rtxL84Vs6br9LmoKetx3GyjaG44Y2SvyvqRHgGcBW8Tqe+tleU4Zr
	 jE9rQBszTdlOIUToEWpuxxyWqvLABqiMINBBiZlk6y3MNyYIUM6iiowG0odPNKWrHR
	 TeS8lDRXn6f43gCAPonHzL1biCgSXwRIs8YtNHnCJ325TyxQcxZTAXLZwtG3QtTxdi
	 Bmwb3OHIpQfFo520NFER2Xmjs9GHH56+SCgouTrMP/h5u0XhlbmNYISqif9oDYiZ5L
	 chQxY5x7hd/hFKS26a7hzdc7Gs6Pn//ApTPpbFXd+AX+Mi95CDHJhw6avQCrDCIkJJ
	 A/JfkNZINXnSWjOsEItxfTIA=
Received: from zn.tnic (p200300ea973a31a9329c23fffea6a903.dip0.t-ipconnect.de [IPv6:2003:ea:973a:31a9:329c:23ff:fea6:a903])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id DDAF940E0163;
	Thu, 14 Nov 2024 07:47:42 +0000 (UTC)
Date: Thu, 14 Nov 2024 08:47:33 +0100
From: Borislav Petkov <bp@alien8.de>
To: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: Andrew Cooper <andrew.cooper3@citrix.com>, Amit Shah <amit@kernel.org>,
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org,
	linux-doc@vger.kernel.org, amit.shah@amd.com,
	thomas.lendacky@amd.com, tglx@linutronix.de, peterz@infradead.org,
	pawan.kumar.gupta@linux.intel.com, corbet@lwn.net, mingo@redhat.com,
	dave.hansen@linux.intel.com, hpa@zytor.com, seanjc@google.com,
	pbonzini@redhat.com, daniel.sneddon@linux.intel.com,
	kai.huang@intel.com, sandipan.das@amd.com,
	boris.ostrovsky@oracle.com, Babu.Moger@amd.com,
	david.kaplan@amd.com, dwmw@amazon.co.uk
Subject: Re: [RFC PATCH v2 1/3] x86: cpu/bugs: update SpectreRSB comments for
 AMD
Message-ID: <20241114074733.GAZzWrFTZM7HZxMXP5@fat_crate.local>
References: <20241111163913.36139-1-amit@kernel.org>
 <20241111163913.36139-2-amit@kernel.org>
 <20241111193304.fjysuttl6lypb6ng@jpoimboe>
 <564a19e6-963d-4cd5-9144-2323bdb4f4e8@citrix.com>
 <20241112014644.3p2a6te3sbh5x55c@jpoimboe>
 <20241112115811.GAZzNC08WU5h8bLFcf@fat_crate.local>
 <20241113212440.slbdllbdvbnk37hu@jpoimboe>
 <20241113213724.GJZzUcFKUHCiqGLRqp@fat_crate.local>
 <20241114004358.3l7jxymrtykuryyd@jpoimboe>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20241114004358.3l7jxymrtykuryyd@jpoimboe>

On Wed, Nov 13, 2024 at 04:43:58PM -0800, Josh Poimboeuf wrote:
> This comment relates to the "why" for the code itself (and its poor
> confused developers), taking all the RSB-related vulnerabilities into
> account.

So use Documentation/arch/x86/.

This is exactly the reason why we need more "why" documentation - because
everytime we have to swap the whole bugs.c horror back in, we're poor confused
developers. And we have the "why" spread out across commit messages and other
folklore which means everytime we have to change stuff, the git archeology
starts. :-\ "err, do you remember why we're doing this?!" And so on
converstaions on IRC.

So having an implementation document explaining clearly why we did things is
long overdue.

But it's fine - I can move it later when the dust settles here.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

