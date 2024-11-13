Return-Path: <kvm+bounces-31809-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 13BAA9C7D9D
	for <lists+kvm@lfdr.de>; Wed, 13 Nov 2024 22:25:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C00531F23CBA
	for <lists+kvm@lfdr.de>; Wed, 13 Nov 2024 21:24:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E0B582076A6;
	Wed, 13 Nov 2024 21:24:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fz0HMG18"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A70D18A6CC;
	Wed, 13 Nov 2024 21:24:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731533083; cv=none; b=eJpQaa5ziDDbh4qsKnHR35VY4KIp1atLHwMCRG//7Ea2clRQRNKtIbM2P07AWrwH8VpEj/aFlYd9jJx/vFUTl1e+AuPpTSrBq0rD4vBVL2uN1k2Zr6hq7PyPSfj5P09SKGKBL2cXB2MXRv74eFlCaFDw0luVMXrkVhByWOyL+mo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731533083; c=relaxed/simple;
	bh=tYbuumMPpC5E94ORRBawZfuPHo78kFraY5LrRZTAzrI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RB0aeT6RsVvjCrlf78FbBXH8I6jjVbt6mctrmpuI0/mv6tmzxrQcGBkKm1mYX7fDUzTJGeKwkeRDmdLfb+sMjTbVpT5vu9jOigllCWUId5SkoAFr7/HL6AFiOg3TmR5XA2bQrhs/24bmouwPShTTz/QkduYbzEtJMoJVpLNAF8E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fz0HMG18; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4793C4CEC3;
	Wed, 13 Nov 2024 21:24:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1731533082;
	bh=tYbuumMPpC5E94ORRBawZfuPHo78kFraY5LrRZTAzrI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=fz0HMG18RMmNeEHcS4It+z/LOqDoo1Xz47kmsa0vEdr1Nme6rDniW+5GccFooezmu
	 24/y7t7d8Ty0oCGhB3kROleSLXjDjtqmvKySYO/msXxr3yap8FryzhSStgD4ydyVHg
	 CbW2fzu0ITSjDdPFeCWSqcwbfp1jpx53MpfyvLUAYiGseUuu2mi7uueHGRdlgLV+O3
	 cBsBPIJCp7vnNVJqrA5GEGRCce0fneNm9z/8K9++6UHDYWn3L73QC0zKieJMvpEjaH
	 7L0taa6qcKgB/OhNXWXlMmkGqim3W2DylaoppQcXfUeyP0iWdm+l2ycNZFMpfwGiIh
	 G2uCWANVc1YHA==
Date: Wed, 13 Nov 2024 13:24:40 -0800
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: Borislav Petkov <bp@alien8.de>
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
Message-ID: <20241113212440.slbdllbdvbnk37hu@jpoimboe>
References: <20241111163913.36139-1-amit@kernel.org>
 <20241111163913.36139-2-amit@kernel.org>
 <20241111193304.fjysuttl6lypb6ng@jpoimboe>
 <564a19e6-963d-4cd5-9144-2323bdb4f4e8@citrix.com>
 <20241112014644.3p2a6te3sbh5x55c@jpoimboe>
 <20241112115811.GAZzNC08WU5h8bLFcf@fat_crate.local>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20241112115811.GAZzNC08WU5h8bLFcf@fat_crate.local>

On Tue, Nov 12, 2024 at 12:58:11PM +0100, Borislav Petkov wrote:
> On Mon, Nov 11, 2024 at 05:46:44PM -0800, Josh Poimboeuf wrote:
> > Subject: [PATCH] x86/bugs: Update insanely long comment about RSB attacks
> 
> Why don't you stick this insanely long comment in
> Documentation/admin-guide/hw-vuln/ while at it?
> 
> Its place is hardly in the code. You can point to it from the code tho...

There are a lot of subtle details to this $#!tstorm, and IMO we probably
wouldn't be having these discussions in the first place if the comment
lived in the docs, as most people seem to ignore them...

-- 
Josh

