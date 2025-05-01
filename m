Return-Path: <kvm+bounces-45068-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3DD27AA5C0C
	for <lists+kvm@lfdr.de>; Thu,  1 May 2025 10:20:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8B33E3B8EFE
	for <lists+kvm@lfdr.de>; Thu,  1 May 2025 08:19:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E93E221146A;
	Thu,  1 May 2025 08:19:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="VHGSKB2u"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 673991E8855;
	Thu,  1 May 2025 08:19:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746087588; cv=none; b=WXTtOKjfmK9SVhnRZaoL8Ek0hVBemcE9opAK4DV0tGCj3oq0jlaVd8W9d5wh7i47fHazYYxxmtf4bGbcxnZrWfizHNkomP2Su4c2xLHPsdKKDsU7lOrADshWim07uDzcyYNR1/xAiFHTTs25V7y+pDfVML6x1ByyqpQspL8AqQg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746087588; c=relaxed/simple;
	bh=z201K7ut7H2joVvShGidrYo64tbBBJEvnIlX8ihy38U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=f2SN1+q9LyzVzDB8V/1WQ8IIh4E/FWnrnAIVIhnfI9tWc4SYMjn4fuxG0KnBRtSvXqqwOrktOgtznSBj4QO01Vb9HmTVK2ezSWbJMMs8AKnjFXyHATzHZDlkvcE/obF9IWpKMs/k5R6tZ/Gvjsk1C6vrYGrZWITKEsIa52Y7ymI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=VHGSKB2u; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id A53D340E0238;
	Thu,  1 May 2025 08:19:42 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id VufDa6gF_ClS; Thu,  1 May 2025 08:19:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1746087578; bh=KSdtnJ2K6SKvY5JM8I86ZBE4uu5b2/R/NMYpHDkO/b4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=VHGSKB2uPHuim0838tafAvFBiatBzEIO0febpFQCut2FPI31JKOny5MGuzKTg4Qci
	 /w1PRN/uY8rGRw6yagX0iozYTMrGWr7sIh6URpmyJA+noDrpJEMGvX9AW0lJhmLjL8
	 eH0IqFwplTTLAy2JOnMGNXMsU4bAZRtF1bWg4Jb75KTYm1VgpUZY0/PUkEJvppK1KV
	 HhYw6PZK91IFhnMJccmCY4RBohzaJg3OLkJw22VQkCFBwWmObCxjEyvIBTg5+6Q1e0
	 uf6LZ2bDXynNzlWmlH87jO8+0DcIu/3TRn7D0xCoRQoB2frfC/HDDHA4d89x94RoNj
	 PXYy2gnv8okdpSCh9lfCIYwQ7nPv6sh1TzSLBeBqACt2xgCBCy28J8LVA7F8Qw/l/R
	 dnhD6GzY41TACKFrASmSZLTKZhzfXuKX7AUXeHuQL/DL5vX8ooF/N87q7Xv7gNAq9o
	 5e1M6QnCg2u5/Zl1RZ2EaUA92WVn2E6uBouYeflzaYfkE2BZmnyfPKwdaiJU0ZSeUC
	 nbWuDH1bEuC4LPXKeiTZlRGPDFyppqOMa5ms37ZwYZ3hFmiUDU3OJoF9NxQF53BMGh
	 4lhdeQHhqP1zLc9do9zz40mPVdeZxbxT6aLBCYgSlIeC2TkTek81SE/LwYn9B5P+Zx
	 6e23GqelAJ79fRu2qJxlVYPU=
Received: from zn.tnic (p579690ee.dip0.t-ipconnect.de [87.150.144.238])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id A217B40E01CF;
	Thu,  1 May 2025 08:19:25 +0000 (UTC)
Date: Thu, 1 May 2025 10:19:18 +0200
From: Borislav Petkov <bp@alien8.de>
To: Sean Christopherson <seanjc@google.com>
Cc: Yosry Ahmed <yosry.ahmed@linux.dev>,
	Patrick Bellasi <derkling@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Josh Poimboeuf <jpoimboe@redhat.com>,
	Pawan Gupta <pawan.kumar.gupta@linux.intel.com>, x86@kernel.org,
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
	Patrick Bellasi <derkling@matbug.net>,
	Brendan Jackman <jackmanb@google.com>,
	David Kaplan <David.Kaplan@amd.com>,
	Michael Larabel <Michael@michaellarabel.com>
Subject: Re: x86/bugs: KVM: Add support for SRSO_MSR_FIX, back for moar
Message-ID: <20250501081918.GAaBMuhq6Qaa0C_xk_@fat_crate.local>
References: <20250214201005.GBZ6-jHUff99tmkyBK@fat_crate.local>
 <20250215125307.GBZ7COM-AkyaF8bNiC@fat_crate.local>
 <Z7LQX3j5Gfi8aps8@Asmaa.>
 <20250217160728.GFZ7NewJHpMaWdiX2M@fat_crate.local>
 <Z7OUZhyPHNtZvwGJ@Asmaa.>
 <20250217202048.GIZ7OaIOWLH9Y05U-D@fat_crate.local>
 <f16941c6a33969a373a0a92733631dc578585c93@linux.dev>
 <20250218111306.GFZ7RrQh3RD4JKj1lu@fat_crate.local>
 <20250429132546.GAaBDTWqOsWX8alox2@fat_crate.local>
 <aBKzPyqNTwogNLln@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <aBKzPyqNTwogNLln@google.com>

On Wed, Apr 30, 2025 at 04:33:19PM -0700, Sean Christopherson wrote:
> Eww.  That's quite painful, and completely disallowing enable_virt_on_load is
> undesirable, e.g. for use cases where the host is (almost) exclusively running
> VMs.

I wanted to stay generic... :-)

> Best idea I have is to throw in the towel on getting fancy, and just maintain a
> dedicated count in SVM.
> 
> Alternatively, we could plumb an arch hook into kvm_create_vm() and kvm_destroy_vm()
> that's called when KVM adds/deletes a VM from vm_list, and key off vm_list being
> empty.  But that adds a lot of boilerplate just to avoid a mutex+count.

FWIW, that was Tom's idea.

> +static void svm_srso_add_remove_vm(int count)
> +{
> +	bool set;
> +
> +	if (!cpu_feature_enabled(X86_FEATURE_SRSO_BP_SPEC_REDUCE))
> +		return;
> +
> +	guard(mutex)(&srso_lock);
> +
> +	set = !srso_nr_vms;
> +	srso_nr_vms += count;
> +
> +	WARN_ON_ONCE(srso_nr_vms < 0);
> +	if (!set && srso_nr_vms)
> +		return;

So instead of doing this "by-foot", I would've used any of those
atomic_inc_return() and atomic_dec_and_test() and act upon the value when it
becomes 0 or !0 instead of passing 1 and -1. Because the count is kinda
implicit...

But yeah, not a biggie - that solves the issue too.

Thanks!

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

