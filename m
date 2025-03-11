Return-Path: <kvm+bounces-40766-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id BCFF2A5C068
	for <lists+kvm@lfdr.de>; Tue, 11 Mar 2025 13:15:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2B4D9189CC07
	for <lists+kvm@lfdr.de>; Tue, 11 Mar 2025 12:12:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2A3D925F7AF;
	Tue, 11 Mar 2025 12:04:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="ANso++PT"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6816025F792;
	Tue, 11 Mar 2025 12:04:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741694648; cv=none; b=WjFgo8Yovf75/G49YCDHpado3Jqcg3PXTbiwkLNgk96MXnVlA/W93cKB/Ti+68G6yiw7PSTK9hxnV4PJtLQbLB1s6yEcu2XWTguhu8+LEpUkJBUArSkPc8pv1Qj6Y/Xwq0UlTqKLtjSHwgNmai9Fzq4L5kj11Dwjt76LNmaNjPA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741694648; c=relaxed/simple;
	bh=xOEREiN2uQjKIn9J+2s38uHFDGAokPVsN8kB9KMEmtE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=V6RzYMMLU1oKyVlgcUFV+c+J6YL+K6rFehkva31/6wbHoxOdzqOJ/4+Gtxnq0vR+1H29mf+zlh9IDEEnZIH/yu8zBe781Ut1Ay+7RVPKZgrHMS3TBQR52ijCInaNlVF8R1mOsPbIjwGpsZhyefeKiROmrjEnTgfruBpRY2HxcRE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=ANso++PT; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 6818840E01A5;
	Tue, 11 Mar 2025 12:04:03 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id 7ftBxgbX5-Fr; Tue, 11 Mar 2025 12:03:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1741694639; bh=CO+LDNh8IlZoGZzHBH1aBZkh7iJLXMM3yHqf4JXWOlI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ANso++PTHNhvd5YCgSkM2TF6+6p1IdTTAAcjLu27nUYiPnfwFkzTVe/+dKx2bxdjs
	 vhC/f3OmEGB/fMW3YyunVZnL9jwBneGhjW3U1gDGsPeYQqtlob1vvk8HhkUm4lZshb
	 6qEBOQ2wihnpCls2nZqgsjhPoCLSxgEzCVKVgMQ8/O3bYqKrt47+mSkNPl2GGY6cGG
	 vNu8fBSw6QeaAqoLR5af2RM02DYtp/mHrZngT0jCogMvYxVToUkOxg0U7MnrGvrJLM
	 PNoeAk6WfgSRA1FaiQRLXQuhq+0lDrOTi2XYjsWcQlENsrGWTmai9ZY5d2w6xtFDRi
	 JmZhQt5Nx7aFGxYo7iBxQ7Or9q5AlPYokLtGx8ohojR3eOCUnms5cSDNrW8E4ZYa76
	 s6QuiwHoTfovd8W378wktVBdHyZtwRDGTElOk1NIjVyk0mlXQ2TJTmg3IgyPBNu8Ax
	 gGiL+Q+N283lw4QAO7Xzd5HKwcKSpssagft2rYkhdBi0cewWUK+hlQCiVfhd7jBLMB
	 8xLJpCYz696V2+ZyhDaqjA5a54qaVa6c/BX7C04/Zx/EHtUq4IcMDDyvk03mjDv5dN
	 hdMP6BETr0FRLHJE6c2q+zPooM0PM842aAYsHNDpSShHTchR+t3jZWJgZf34/00Tbs
	 MvnttPVpr2HZU4coilPLexL0=
Received: from zn.tnic (pd95303ce.dip0.t-ipconnect.de [217.83.3.206])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id C588740E015D;
	Tue, 11 Mar 2025 12:03:46 +0000 (UTC)
Date: Tue, 11 Mar 2025 13:03:40 +0100
From: Borislav Petkov <bp@alien8.de>
To: Patrick Bellasi <derkling@google.com>,
	Brendan Jackman <jackmanb@google.com>
Cc: Sean Christopherson <seanjc@google.com>,
	Yosry Ahmed <yosry.ahmed@linux.dev>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Josh Poimboeuf <jpoimboe@redhat.com>,
	Pawan Gupta <pawan.kumar.gupta@linux.intel.com>, x86@kernel.org,
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
	Patrick Bellasi <derkling@matbug.net>,
	David Kaplan <David.Kaplan@amd.com>
Subject: Re: [PATCH final?] x86/bugs: KVM: Add support for SRSO_MSR_FIX
Message-ID: <20250311120340.GFZ9AmnAcZg-4pXOBv@fat_crate.local>
References: <20250303150557.171528-1-derkling@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250303150557.171528-1-derkling@google.com>

On Mon, Mar 03, 2025 at 03:05:56PM +0000, Patrick Bellasi wrote:
> That's why we are also going to detect this cases and set
> SRSO_MITIGATION_BP_SPEC_REDUCE_NA, so that we get a:
> 
>   "Vulnerable: Reduced Speculation, not available"
> 
> from vulnerabilities/spec_rstack_overflow, which should be the only place users
> look for to assess the effective mitigation posture, ins't it?

If they even look. The strategy so far has been that the kernel should simply
DTRT (it being the default) if the user doesn't know anything about
mitigations etc.

So I have another idea: how about we upstream enough ASI bits - i.e., the
function which checks whether ASI is enabled - and use that in the mitigation
selection?

IOW:
	case SRSO_CMD_BP_SPEC_REDUCE:
		if ((boot_cpu_has(X86_FEATURE_SRSO_BP_SPEC_REDUCE)) {
			select it
		} else {
			if (ASI enabled)
				do not fall back to IBPB;
			else
				fallback to IBPB;
		}

"ASI enabled" will return false upstream - at least initially only, until ASI
is out-of-tree - and then it'll fall back.

On your kernels, it'll return true and there it won't fall back.

We just need to sync with Brendan what "ASI enabled" would be and then it
should work and your backports would be easy in that respect.

Until ASI is not upstream, that is.

Hmmmm?

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

