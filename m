Return-Path: <kvm+bounces-57544-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2755EB57807
	for <lists+kvm@lfdr.de>; Mon, 15 Sep 2025 13:26:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 7850D7AD0FC
	for <lists+kvm@lfdr.de>; Mon, 15 Sep 2025 11:24:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B9C462FE05F;
	Mon, 15 Sep 2025 11:26:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="h7V6iMvm"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A4801D54D8;
	Mon, 15 Sep 2025 11:26:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757935579; cv=none; b=uHyduihPEMS2sDjUx5HSAv/VksFqBpV+lZfTrmxoO9hpyyRQe8r48Z0f40IqjIiqqC3hYVCk/6GbFhdXpXN7oBA13Xjz+SymbWjzzYnGal+fppFTaBtDj2UjPRphTakTZxjpmCQNX7MLqlF3eqzz/V9vltqqC/O0GEfIIxMw8d4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757935579; c=relaxed/simple;
	bh=EyCbsyd109jlA6dWKPGR31a04u6NZDtlezBFxPWAehg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dxPTAYy1Z5aunDKYfI3AjZDAPWjnESFO85nS1phmWde+yMUnaidXFhgvfjmXwk6pyC/AUrqt5LPoAEOu+NiAfiBfwevd+NtPGhye7ayJCRdq20TLR1rFyCkKht7y2uJ+MFxSI/0yCKgaxOt7lAJCF1hGNJ/IkUsfRH4nVtMyvhY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=h7V6iMvm; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 7B29E40E019E;
	Mon, 15 Sep 2025 11:26:06 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id Q_gETiq9zByM; Mon, 15 Sep 2025 11:26:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1757935560; bh=og5A2WyNgFf7VMif0EZi46Of8DzCnjQ3vDeonAI/acM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=h7V6iMvmKJs5863dr5nkmFZiU3qP66keqlZx93dvM7YITmmnEqhBm2jC399/6c/X9
	 eY9gbp2YoNgadnZBfoFQRnkRzlgBnuOUnHMozopc4WqAyEnde3RgQSU2ZKcSxtYueK
	 mHx8p9+ZPwV8veJYk7A+Ck7xylMOptWVKSqdpjw+CpAxXm+Zs+I4P0DEsXZEWdyOvp
	 FfA4vvdC86enrUgOLIYL8T0pgOiW0/24oqTiK1bYXdnsXGFT4DfZTIeaBOiEXLSiqi
	 14CwdGeryMyaE5B0iUBHnuV2ThAOwslGsCZBipQvKxeOPCyjjuKV/KawE6Bd068WpV
	 V2Bmjdk1ffPhdrPbv5wfJF2mfNiyDze3a2ZZvsxj9b+ENTDuF0to2nIWwssoxxCB38
	 Hl3aF8O3sVyvsbRT0/tYpHLQbutKZZsgUt/Xc1Pq6Q2JwemjjmoLxp27NN+L00dRDk
	 Tb6vyvnJPk0Og9cRuZCUqT2miGRJnyCefzZ+Ha36VFdJTV+DON9EhwTszRBOWBYALn
	 gf4fZLpCRe+tzlMPeOR1JKGjJ49XwBOBF7SRmbBYa5220t3cwGd9t1ukJ1f8PX7Oyn
	 9J0iMhzitSbc984GGwPNmzIiYzgWY5gidjaCJ/+iE41ptd6pIkWIrQaJLl/GHFpO+9
	 Q0/zyASL+1qe81MtgrUGcbL8=
Received: from zn.tnic (p5de8ed27.dip0.t-ipconnect.de [93.232.237.39])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with UTF8SMTPSA id D3EBF40E01A3;
	Mon, 15 Sep 2025 11:25:17 +0000 (UTC)
Date: Mon, 15 Sep 2025 13:25:10 +0200
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
Subject: Re: [PATCH v18 00/33] x86,fs/resctrl: Support AMD Assignable
 Bandwidth Monitoring Counters (ABMC)
Message-ID: <20250915112510.GAaMf3lkd6Y1E_Oszg@fat_crate.local>
References: <cover.1757108044.git.babu.moger@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <cover.1757108044.git.babu.moger@amd.com>

On Fri, Sep 05, 2025 at 04:33:59PM -0500, Babu Moger wrote:
>  .../admin-guide/kernel-parameters.txt         |    2 +-
>  Documentation/filesystems/resctrl.rst         |  325 ++++++
>  MAINTAINERS                                   |    1 +
>  arch/x86/include/asm/cpufeatures.h            |    1 +
>  arch/x86/include/asm/msr-index.h              |    2 +
>  arch/x86/include/asm/resctrl.h                |   16 -
>  arch/x86/kernel/cpu/resctrl/core.c            |   81 +-
>  arch/x86/kernel/cpu/resctrl/internal.h        |   56 +-
>  arch/x86/kernel/cpu/resctrl/monitor.c         |  248 +++-
>  arch/x86/kernel/cpu/scattered.c               |    1 +
>  fs/resctrl/ctrlmondata.c                      |   26 +-
>  fs/resctrl/internal.h                         |   58 +-
>  fs/resctrl/monitor.c                          | 1008 ++++++++++++++++-
>  fs/resctrl/rdtgroup.c                         |  252 ++++-
>  include/linux/resctrl.h                       |  148 ++-
>  include/linux/resctrl_types.h                 |   18 +-
>  16 files changed, 2019 insertions(+), 224 deletions(-)

Ok, I've rebased and pushed out the pile into tip:x86/cache.

Please run it one more time to make sure all is good.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

