Return-Path: <kvm+bounces-19424-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 9EE4B904F16
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2024 11:22:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 38600B23AC2
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2024 09:22:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 340C716D9DD;
	Wed, 12 Jun 2024 09:22:03 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A857916B72E;
	Wed, 12 Jun 2024 09:22:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718184122; cv=none; b=qrWmyJN6hs1uW1HntxwGAvjhC5apIutuVAMX/PzqWiK/rChR5bqGbMFIS8NTGPzMJftC+eE9cEgzz1XJTpVXLa7roocIPkDBTkrhYDhxkPZzr3k+PXVIJy3vt/+wxSkit2UuQjusIs68QsFBGp5WUyYqefpSBE1pFy8azjlojTY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718184122; c=relaxed/simple;
	bh=ta48ixBdpMRrTsIAyE+J7/VDBnWPsC4PwbGNgrcyFlc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hEroQeRNe0P4O6x6tNPRcxv/dfHx7gYxvWKE8jLrLLnakbvJ6Ts7wGHMFSewUXZ3tT2YepIrtxun4FUYQLTf++5P1TY8rPyr6gaZa6Yk97hihNYKdbNOhLiLeuaqzmTx/aVcl/Ql9mUbzo6AaRtEX3H7VCDk/QlxGsOKhqmga4U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC7BCC3277B;
	Wed, 12 Jun 2024 09:21:56 +0000 (UTC)
Date: Wed, 12 Jun 2024 10:21:54 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Fred Griffoul <fgriffo@amazon.co.uk>
Cc: griffoul@gmail.com, kernel test robot <lkp@intel.com>,
	Will Deacon <will@kernel.org>,
	Alex Williamson <alex.williamson@redhat.com>,
	Waiman Long <longman@redhat.com>,
	Zefan Li <lizefan.x@bytedance.com>, Tejun Heo <tj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Mark Rutland <mark.rutland@arm.com>, Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Mark Brown <broonie@kernel.org>, Ard Biesheuvel <ardb@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Jeremy Linton <jeremy.linton@arm.com>,
	Jason Gunthorpe <jgg@ziepe.ca>, Yi Liu <yi.l.liu@intel.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Eric Auger <eric.auger@redhat.com>,
	Stefan Hajnoczi <stefanha@redhat.com>,
	Christian Brauner <brauner@kernel.org>,
	Ankit Agrawal <ankita@nvidia.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Ye Bin <yebin10@huawei.com>, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
	cgroups@vger.kernel.org
Subject: Re: [PATCH v6 1/2] cgroup/cpuset: export cpuset_cpus_allowed()
Message-ID: <Zmlosj-Fmsoq1AiU@arm.com>
References: <20240611174430.90787-1-fgriffo@amazon.co.uk>
 <20240611174430.90787-2-fgriffo@amazon.co.uk>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240611174430.90787-2-fgriffo@amazon.co.uk>

On Tue, Jun 11, 2024 at 05:44:24PM +0000, Fred Griffoul wrote:
> diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
> index 56583677c1f2..2f1de6343bee 100644
> --- a/arch/arm64/kernel/cpufeature.c
> +++ b/arch/arm64/kernel/cpufeature.c
> @@ -127,6 +127,7 @@ static bool __read_mostly allow_mismatched_32bit_el0;
>   * seen at least one CPU capable of 32-bit EL0.
>   */
>  DEFINE_STATIC_KEY_FALSE(arm64_mismatched_32bit_el0);
> +EXPORT_SYMBOL_GPL(arm64_mismatched_32bit_el0);
>  
>  /*
>   * Mask of CPUs supporting 32-bit EL0.
> @@ -1614,6 +1615,7 @@ const struct cpumask *system_32bit_el0_cpumask(void)
>  
>  	return cpu_possible_mask;
>  }
> +EXPORT_SYMBOL_GPL(system_32bit_el0_cpumask);

For the arm64 bits:

Acked-by: Catalin Marinas <catalin.marinas@arm.com>

