Return-Path: <kvm+bounces-57329-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 5BD86B536FA
	for <lists+kvm@lfdr.de>; Thu, 11 Sep 2025 17:10:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 630F31C22B37
	for <lists+kvm@lfdr.de>; Thu, 11 Sep 2025 15:10:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6613B34AB0E;
	Thu, 11 Sep 2025 15:09:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="bMW4JEDS"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E73CF345752;
	Thu, 11 Sep 2025 15:09:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757603390; cv=none; b=o5NLkNbANMrW5/fUb7WImcZEDAWExyoBCXQ6w1H/6uV7bn+omgp2ZgJhXJ7OohakMKlhH+O1huXroHJcwurm9twE6UPyXb6ET/Q6U2MQV5m8GD2Z3vyS0vXleE9Hlsl6o+XNuvyUqptlDfv7NDSbbBJeB7oWju9IdkwLpCVmgAo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757603390; c=relaxed/simple;
	bh=95uhAxbfkKFyOFgW3RXGiSoEN3G9GsJCAWc40eu/89A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YMQP7+2wcGa7iMaBCOzEiQz8FOK+KXJkZLYD7vyY8MBO6QuzALdNPwZNXNs1kuRMRyWVV7yxLG6FqOHu+6v7uAWHLmATZdHuBGX+MEWnD519M7sYvNtiKTL3K078QnSQgyWxGYcrO1N7RXNANgC4YpknKPQUoMFmPISqz+7Ft98=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=bMW4JEDS; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id BE94040E01A5;
	Thu, 11 Sep 2025 15:09:44 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id PtK42-h5vEMM; Thu, 11 Sep 2025 15:09:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1757603380; bh=dq+R5oWq9WF149Sw6eDWmEVjGVrgX+aszHp1gMyx7F4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=bMW4JEDSWHlnSuYPRRPaQ9rkXEJ0WZVzfqZvnNd4UAT0ziFWkRMHajNwqt2mRHCpi
	 cGKX6q5574msDfnCgMmsU0ah6J/gPo23fc+IDmQVvPZh9m0JTLA1IG7wekOAYAq8Eu
	 VqnvVkopu5oCNUrNrqtOIDYhmtTqQ85xrPs6a+3JyQ9aOep9+0hxUppb+Blnb3/C/0
	 D/D4WJ70DaoL1hT7FrD32JS0mdQ28C/vpwWHnmc7yTMXnr8q3TNtKeV1QFd92fxhPu
	 EHjOp2amle4NmfpPGQV542l4Y6vilmbYnpnDbsXc0t15cmy95Sq5XrYcry3P7r+igq
	 bWytuVII/HfC4hvjHnFduQ7ALo4ECXzAPJFqHybg62P/tMZHwaitQdRs6Kq7B7uP9P
	 lxnwi21qtVJh/75m62+gKAGPA73KpNkSQ4eDaE+pd9lDaWD1PMXUNNic4NVG9bhxzd
	 InRkPWW+1lP2w+ojAazmayIaU71ItKM3QZTQ+0P9wkeWzhJpD9jl1CJK19wOWvOcAd
	 Yzl7OmA8X2I2YrdXlsbInC3FixJHxz4/TepEcWjwVIgkxP+Xam4JV5NqhRJBvCncw9
	 eYPwZRaJfiTV+7hFIHLdbf1Fk5Y23TRYVULf3eBWvAwtZw7jC0E3eUbqcCR+9mSodN
	 Fv6yRg2W2fIBqUw1woAAGv/Q=
Received: from zn.tnic (p5de8ed27.dip0.t-ipconnect.de [93.232.237.39])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with UTF8SMTPSA id 531A740E01BB;
	Thu, 11 Sep 2025 15:08:58 +0000 (UTC)
Date: Thu, 11 Sep 2025 17:08:50 +0200
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
Subject: Re: [PATCH v18 26/33] fs/resctrl: Introduce mbm_assign_on_mkdir to
 enable assignments on mkdir
Message-ID: <20250911150850.GAaMLmAoi5fTIznQzY@fat_crate.local>
References: <cover.1757108044.git.babu.moger@amd.com>
 <3b73498a18ddd94b0c6ab5568a23ec42b62af52a.1757108044.git.babu.moger@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <3b73498a18ddd94b0c6ab5568a23ec42b62af52a.1757108044.git.babu.moger@amd.com>

On Fri, Sep 05, 2025 at 04:34:25PM -0500, Babu Moger wrote:
> The "mbm_event" counter assignment mode allows users to assign a hardware
> counter to an RMID, event pair and monitor the bandwidth as long as it is
> assigned.
> 
> Introduce a user-configurable option that determines if a counter will
> automatically be assigned to an RMID, event pair when its associated
> monitor group is created via mkdir. Accessible when "mbm_event" counter
> assignment mode is enabled.

This is just a note for the future - you don't have to go change things now:
reading those commit messages back-to-back, there's a lot of boilerplate code
which repeats with each commit message and there's a lot of text talking what
the patch does.

Please tone this down in the future - it is really annoying and doesn't bring
a whole lot by repeating things or explaining the obvious. Just concentrate on
explaining why the patch exists and mention any non-obvious things.

Everything else people can find by searching the net.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

