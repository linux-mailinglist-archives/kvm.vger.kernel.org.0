Return-Path: <kvm+bounces-53143-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id AF07EB0DFDE
	for <lists+kvm@lfdr.de>; Tue, 22 Jul 2025 17:04:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D97191C23AA1
	for <lists+kvm@lfdr.de>; Tue, 22 Jul 2025 14:58:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6BF422ECD08;
	Tue, 22 Jul 2025 14:57:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="UkQPPri7"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A73162E1724;
	Tue, 22 Jul 2025 14:57:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753196244; cv=none; b=AeD1UZkCsURQRF9k9kUCrLKFgP8H4QsYkOVmwtU2+mCmRzqc7n7FYcxiAkd6L/sWYvitDx1KHjELoPXMyVYGr5elzH58LyKKWUSTwsV7b0f6VfGW26Umjx7rBCDKfRg51spxZiO6BO2a73onJfdF9/y7DgBjl06RCnZhqT8UfzQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753196244; c=relaxed/simple;
	bh=3xnLaWnOmOkuJ0977o3SrFUG6qb/RVNQZ8CVCCYJzww=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FQEtcVjlZzPv54EPi7YhczYVZij4ncz18O0SMGVdEG7GW7QzrFALBd6GLHWTGuappbKkq7MDl77J8u/dosQVJhCDdeRxP5ygdTHdjgNHEuWqokZF5+svEBHiJ5Hbx7nL68LBsqAWnV2YNqbtfctncbjwXUT0XRDCX6xpemMXMfk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=UkQPPri7; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 6AA9D40E026C;
	Tue, 22 Jul 2025 14:57:19 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id 1y_-TjzpZqNK; Tue, 22 Jul 2025 14:57:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1753196236; bh=CV12ZyPTxqPmlSN7j772KXpPQFGLihlZuz2lc7oVyx4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=UkQPPri7/pKRTQnzkIWK5s0tfRVwYGY7qg8j8odxh9zx2KVuGkK024yEVjJElO7aq
	 bwK98klfCEphi4/LXhmAxJ7E8JMpl6AwZR3NNwGE0qYBCnAs27XhnN6fF6a818y11E
	 8DYTip6Dm62MkTF8FFKxtnDjPwZzNNiB6gD5yD5CTAXok1xEJ21RXRhHvAJBJhv8ps
	 Qapkq66PqUbRyXG7/fTFE4dCLEke+4mjMNi++OlS6hKParGax79OKIaUuCCPdU/pHt
	 7ZpVY/iqEA5nlGhmYboOGrBbBM8LzeGm0atnLGIR0yCSIAYRotHnNH4tSRzpFZRE4H
	 X82QqiI3jNwjLckbnNnBYVerRXpebpHEm4iItVgHmO5jkIepjnkFh5Xnn2d1H3ZYeG
	 cJn8bqjnIga98fENoyKJG+izJxx7Xn8NKjqt0P8E8vAv4BKzdhD95zDcwx0sVg4hYo
	 p8a6qPzNnO7pmuyq5eAaW5PLxH2XU7vM7mEHk5g4FmafjOV9Mx0mXhQSADIC8cj56V
	 Dl17qhTNidU/w9Z2cRrr4KAetogvP8VX46MIUs9TuCSA3/fsYv+tmVIb8dgxV51L8l
	 Cn+YB4pKapuEnNuH9BatPUho0cfLi4cmzeQvlrc4f0tnpxaiNQZ8PaFMD5dea4Gznt
	 T0deDF0MZ/QMfc1sfFvblgH8=
Received: from rn.tnic (unknown [78.130.214.207])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with UTF8SMTPSA id A10CC40E0265;
	Tue, 22 Jul 2025 14:56:53 +0000 (UTC)
Date: Tue, 22 Jul 2025 16:58:54 +0200
From: Borislav Petkov <bp@alien8.de>
To: "Huang, Kai" <kai.huang@intel.com>
Cc: "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>,
	"tglx@linutronix.de" <tglx@linutronix.de>,
	"peterz@infradead.org" <peterz@infradead.org>,
	"Hansen, Dave" <dave.hansen@intel.com>,
	"mingo@redhat.com" <mingo@redhat.com>,
	"hpa@zytor.com" <hpa@zytor.com>, "Gao, Chao" <chao.gao@intel.com>,
	"Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
	"seanjc@google.com" <seanjc@google.com>,
	"x86@kernel.org" <x86@kernel.org>,
	"kas@kernel.org" <kas@kernel.org>,
	"sagis@google.com" <sagis@google.com>,
	"Chatre, Reinette" <reinette.chatre@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"Williams, Dan J" <dan.j.williams@intel.com>,
	"nik.borisov@suse.com" <nik.borisov@suse.com>,
	"ashish.kalra@amd.com" <ashish.kalra@amd.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>,
	"dwmw@amazon.co.uk" <dwmw@amazon.co.uk>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"Yamahata, Isaku" <isaku.yamahata@intel.com>
Subject: Re: [PATCH v4 1/7] x86/kexec: Consolidate relocate_kernel() function
 parameters
Message-ID: <20250722145854.GAaH-nLpCa12zaiOPa@renoirsky.local>
References: <cover.1752730040.git.kai.huang@intel.com>
 <c7356a40384a70b853b6913921f88e69e0337dd8.1752730040.git.kai.huang@intel.com>
 <5dc4745c-4608-a070-d8a8-6afb6f9b14a9@amd.com>
 <45ecb02603958fa6b741a87bc415ec2639604faa.camel@intel.com>
 <7eb254a7-473a-94c6-8dd5-24377ed67a34@amd.com>
 <1d2956ba8c7f0198ed76e09e2f1540d53c96815b.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1d2956ba8c7f0198ed76e09e2f1540d53c96815b.camel@intel.com>

On Mon, Jul 21, 2025 at 09:36:48PM +0000, Huang, Kai wrote:
> Np and thanks! I'll address your other comments but I'll see whether Boris
> has any other comments first.

Nah, he hasn't. This looks exactly like what I had in mind so thanks for
doing it.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

