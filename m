Return-Path: <kvm+bounces-38375-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 82C6DA38780
	for <lists+kvm@lfdr.de>; Mon, 17 Feb 2025 16:27:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5778616E3F6
	for <lists+kvm@lfdr.de>; Mon, 17 Feb 2025 15:27:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 91D0E224AF2;
	Mon, 17 Feb 2025 15:27:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="aMccV998"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D32A1494DF;
	Mon, 17 Feb 2025 15:27:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739806025; cv=none; b=uHcM++PiOMh1w1iY0YikQqQ20o8x5d+Hr7jFlx+MHcEx9D04z0Ml+ae2skZ7ia5tXRxa7WeYwKIekV037vxfwfQxv9Co3Ozsz4WUddRhzD779yc5FFOi7McNTmWtteC4HzSSqVvoqDEb13BPMLIrBONXvhNFYBs+HVscwis6ZLo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739806025; c=relaxed/simple;
	bh=U1mjf0Tf6g1vVVmhRG2R4Tb3kAQNL/5crTroM67oZ+I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TUn8Fc85tFlrnWKJywFLFk3LfApigNO73t4gYNkV/eXDefS5tY2CQZOcrrJNDl9xZfgMANAoDfbhUDYwTEaeNXUJXUrhHT2ago6TiiVkFmd+lTWkJbhV3UkqUmxo1An4pwBLEpcAvggmK+2Igd6kx+tmSYSdp15ck8o/mO9Q3Hs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=aMccV998; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 5F26940E01A1;
	Mon, 17 Feb 2025 15:27:00 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id 2VhwGZUpXniU; Mon, 17 Feb 2025 15:26:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1739806014; bh=XG45Vhnc+dFMztxiq5T8wxFZgZlBWi+1l36DqM/+tMI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=aMccV998asM3I8wmciaAV/YAG3Ws2gaawvenMEl5XazrR+XUnjjJi2269++M8359o
	 OMbzxLba26U8QiSIe2oCkVu/kJo6yChyEydh/aix41lH1K8RhXDFl4LFi55Qoc0J6e
	 LVisFyCAKOJXEKg9ayH8wiuV1u1CGy+cd/KTjl9LozJQWkXOCPWRcgP38KlqiFQXe3
	 6pXtf403cN6WjF1QLP4iSj0aWd6zyTgpD557dPc06UKpLs+RDlVN7rQUnzwznMqmPA
	 1WmvrssqWp/axfkxy3CkS5PpQF7PEcAaQQsp2js44qv7+61WICb5DzAVaERgBSvzzE
	 WdGYO38oGHRxnNQp2FTKdLdS95o8G9X0XbI7Ab0+/X94E92T2ler6HZvC6flAzh8iq
	 U6fj22EtHJ9DC+aU+ZtpQIiSf8c8I8v3+sEDkwF+twXiYrUQLndLEixWCAl5/5TMPL
	 GiHYPLdjHgahqEeOBvFYDV0BJp/LoVQn2zMAasWr5qfgbUjBSI7fON42nKWOZs10GJ
	 RPWoKdu+ATpTQj2XNytwDqhNZvwAPKdpv+9doZfVyHKUWBmhDq8PdqyCBQk9wIOSEZ
	 hqWTrQ1wytSOsHHYH0YGjv2sM596NsE9PgwoZzMaqN/P+BsH79RspdR7Hn9oygJouv
	 3WP8g2rban6hTe2cyzT8+2Rk=
Received: from zn.tnic (pd95303ce.dip0.t-ipconnect.de [217.83.3.206])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 93A7E40E0176;
	Mon, 17 Feb 2025 15:26:43 +0000 (UTC)
Date: Mon, 17 Feb 2025 16:26:37 +0100
From: Borislav Petkov <bp@alien8.de>
To: Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: Patrick Bellasi <derkling@google.com>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Josh Poimboeuf <jpoimboe@redhat.com>,
	Pawan Gupta <pawan.kumar.gupta@linux.intel.com>, x86@kernel.org,
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
	Patrick Bellasi <derkling@matbug.net>,
	Brendan Jackman <jackmanb@google.com>
Subject: Re: Re: Re: Re: [PATCH] x86/bugs: KVM: Add support for SRSO_MSR_FIX
Message-ID: <20250217152637.GEZ7NVLR94K1fcZMJH@fat_crate.local>
References: <20250213142815.GBZ64Bf3zPIay9nGza@fat_crate.local>
 <20250213175057.3108031-1-derkling@google.com>
 <20250214201005.GBZ6-jHUff99tmkyBK@fat_crate.local>
 <Z6_mY3a_FH-Zw4MC@google.com>
 <20250215091527.GAZ7BbL2UfeJ0_52ib@fat_crate.local>
 <Z7LNjEqZELrPmRkV@Asmaa.>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Z7LNjEqZELrPmRkV@Asmaa.>

On Sun, Feb 16, 2025 at 09:47:56PM -0800, Yosry Ahmed wrote:
> Thanks for the context, didn't realize a manual backport was needed.

Feb 17 gregkh@linuxfoundation.org (:9.1K|) FAILED: patch "[PATCH] x86/cpu/kvm: SRSO: Fix possible missing IBPB on VM-Exit" failed to apply to 6.6-stable tree
Feb 17 gregkh@linuxfoundation.org (:9.1K|) FAILED: patch "[PATCH] x86/cpu/kvm: SRSO: Fix possible missing IBPB on VM-Exit" failed to apply to 6.1-stable tree
Feb 17 gregkh@linuxfoundation.org (:9.1K|) FAILED: patch "[PATCH] x86/cpu/kvm: SRSO: Fix possible missing IBPB on VM-Exit" failed to apply to 5.15-stable tree
Feb 17 gregkh@linuxfoundation.org (:9.2K|) FAILED: patch "[PATCH] x86/cpu/kvm: SRSO: Fix possible missing IBPB on VM-Exit" failed to apply to 5.10-stable tree
Feb 17 gregkh@linuxfoundation.org (:9.5K|) FAILED: patch "[PATCH] x86/cpu/kvm: SRSO: Fix possible missing IBPB on VM-Exit" failed to apply to 5.4-stable tree

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

