Return-Path: <kvm+bounces-42446-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B952EA7871C
	for <lists+kvm@lfdr.de>; Wed,  2 Apr 2025 06:10:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 325E116DCEB
	for <lists+kvm@lfdr.de>; Wed,  2 Apr 2025 04:10:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 76C3D230D1E;
	Wed,  2 Apr 2025 04:10:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TnGYyG5P"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75C0820AF87;
	Wed,  2 Apr 2025 04:10:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743567024; cv=none; b=mPGvbG1lylVBiZrfFVVNRhvvxXvy4KiBr3xmtvCBXzxy8QFPkfe6b1MWOMcYE4GEYWYt2OSpm1ezyA1Fr0jEzyUUSxUWXWRceRBTtzKlg75ajJHGitQ7MRJij+5AA6urMUll6gIZfgN7vrP4+Vu0q/6mDuBU4O78y56yBOnB4yU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743567024; c=relaxed/simple;
	bh=I0s5Gv1mQHqnKIzWxsoxCEERoVHvYzeckwE8nOas3VU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jIAkqr2yjXXvz9b41k+FqQcRpJTSK1Hk68oNqIbZ4USFppSpp8alP5JmcVFq8WuRGUlF6a1K+zqZyjTjw73/vgmWISi4ripyT+6ylz13JpCWo4ess2kWdzbQvYZGsAIYDMFHLmVKVmKRPYczTc0cW9Kas8ysHIR4KefXc4G6DPI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TnGYyG5P; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BD29C4CEE9;
	Wed,  2 Apr 2025 04:10:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1743567024;
	bh=I0s5Gv1mQHqnKIzWxsoxCEERoVHvYzeckwE8nOas3VU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=TnGYyG5PegnZexH78EkVEZhjl67pWL7sXIuankw0lLUoS6l525yDJb1k2Y991Swzi
	 Y/BQdn5EKeOPY4iCMiCsl/wcs58dUo6w4xmkNpQPl13ChnxQG34bUHyTmZ9oI5i9zj
	 GXNesFcifbImdVA7Krak7NrblCx3xnxnf0NZrjadpmZUOlSF3sDsu4Wqsh/OKamc5N
	 +/zpZVi9YHfAGYahd4Ce8z4sLXldFsNZWZ5Nqw2T1fjxJ8DAvB6m9Rtz/uEQMlDmh/
	 IRy6AIGMdjxGih5ykPwxvU4bKYE7f4SM5B+pULQxCAmH41LRub4Yb6OVvdI2LbooM3
	 g8DLjexGSgPew==
Date: Wed, 2 Apr 2025 06:10:12 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Xin Li <xin@zytor.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
	linux-perf-users@vger.kernel.org, linux-hyperv@vger.kernel.org,
	virtualization@lists.linux.dev, linux-edac@vger.kernel.org,
	kvm@vger.kernel.org, xen-devel@lists.xenproject.org,
	linux-ide@vger.kernel.org, linux-pm@vger.kernel.org,
	bpf@vger.kernel.org, llvm@lists.linux.dev, tglx@linutronix.de,
	mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
	x86@kernel.org, jgross@suse.com, andrew.cooper3@citrix.com,
	peterz@infradead.org, acme@kernel.org, namhyung@kernel.org,
	mark.rutland@arm.com, alexander.shishkin@linux.intel.com,
	jolsa@kernel.org, irogers@google.com, adrian.hunter@intel.com,
	kan.liang@linux.intel.com, wei.liu@kernel.org,
	ajay.kaher@broadcom.com, alexey.amakhalov@broadcom.com,
	bcm-kernel-feedback-list@broadcom.com, tony.luck@intel.com,
	pbonzini@redhat.com, vkuznets@redhat.com, seanjc@google.com,
	luto@kernel.org, boris.ostrovsky@oracle.com, kys@microsoft.com,
	haiyangz@microsoft.com, decui@microsoft.com,
	Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [RFC PATCH v1 01/15] x86/msr: Replace __wrmsr() with
 native_wrmsrl()
Message-ID: <Z-y4pGxgiP55lpOj@gmail.com>
References: <20250331082251.3171276-1-xin@zytor.com>
 <20250331082251.3171276-2-xin@zytor.com>
 <Z-pruogreCuU66wm@gmail.com>
 <9D15DE81-2E68-4FCD-A133-4963602E18C9@zytor.com>
 <Z-ubVFyoOzwKhI53@gmail.com>
 <7a503d55-db41-42da-8133-4a3dbbd36c7e@zytor.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7a503d55-db41-42da-8133-4a3dbbd36c7e@zytor.com>


* Xin Li <xin@zytor.com> wrote:

> Hi Ingo,
> 
> Is this branch public?
> 
> I wanted to rebase on it and then incooperate your review comments, but
> couldn't find the branch.

Yeah, I moved it over to:

  git://git.kernel.org/pub/scm/linux/kernel/git/mingo/tip.git WIP.x86/msr

Thanks,

	Ingo

