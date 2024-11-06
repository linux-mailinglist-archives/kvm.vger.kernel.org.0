Return-Path: <kvm+bounces-30949-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 274DC9BE8CC
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 13:27:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D25351F216AF
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 12:27:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8EF341DFD84;
	Wed,  6 Nov 2024 12:27:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="WtUY2h+3"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1366D1DFD8D
	for <kvm@vger.kernel.org>; Wed,  6 Nov 2024 12:27:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730896055; cv=none; b=sYI0OmdZJCgDM+KTxG8aoZJKqTHg1eI40Rl1YcAILf20+RysAbs83XLV041KjVmXIrn/KSn2nGfyIMb63l7Gx3QU3n9ZDJ39e9Rv+OG6umCUMus6xMAmF00P7xq0+NgMaCYRItCigAffjXDkMUhdhZn9zFHiAIdu+En/toOLDug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730896055; c=relaxed/simple;
	bh=Q5mAGqr6fBZa46ptlj0c2tOjO/AVkSYXS7mLE8kdevc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MmjpZhhM0fVIWVJuiDgDZFZDJW+o1YC7IL3HRmUhwDWT1uokAdZAUtX+D3vKpcTnx09qI67o3J3ufipsYttogiqL7W7c1R/3zBF0hA1bc499bOQ9PjAipBHA/w+AgmQMTvAGFQGJTRqc9WcMrINmX8Y7gXs6zvz//RAJ8nxLmNg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=WtUY2h+3; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730896054; x=1762432054;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Q5mAGqr6fBZa46ptlj0c2tOjO/AVkSYXS7mLE8kdevc=;
  b=WtUY2h+3+gAHaOLB7duHXd4ma4kzEpSoN5Rj/38g5JLiSk2G3MCA+Til
   /V1JZvTRZfCi2VoFfU+D0iZSMGY79QWOPwo6rsnaJubvmH95B5t/XuNI+
   jyKUn0CEKveJvjB9XkbuHqf9UUEfmjNBUeOaGlYeZJWe8RrZLNwp8VFtB
   WWOJLZ5ZjJeY+AqlgYWLYO01sEfdEvkFSjRFzeahWvg0We5biCdi6e2CG
   b44uL7HwPV6Rxy2a0fPV+67T7egKujPqLmmz/IzIPT0UzJKWqIog2S0Up
   S+N5xi0dWcBbobpkap6gYja3O9AeWVo3im5GuySLH1wLWHJiOihwNlFGe
   A==;
X-CSE-ConnectionGUID: hS/12FBkRjCE8jxMCisv7g==
X-CSE-MsgGUID: GYUsU9JUSfyL9hQtsqNNpg==
X-IronPort-AV: E=McAfee;i="6700,10204,11248"; a="30117918"
X-IronPort-AV: E=Sophos;i="6.11,262,1725346800"; 
   d="scan'208";a="30117918"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Nov 2024 04:27:34 -0800
X-CSE-ConnectionGUID: pcgVXOXpTwKtm7Qqb+LBAw==
X-CSE-MsgGUID: oEPzkh84Qme5i7cGVAyMIg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,262,1725346800"; 
   d="scan'208";a="89635785"
Received: from linux.bj.intel.com ([10.238.157.71])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Nov 2024 04:27:30 -0800
Date: Wed, 6 Nov 2024 20:22:23 +0800
From: Tao Su <tao1.su@linux.intel.com>
To: Zhao Liu <zhao1.liu@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Eduardo Habkost <eduardo@habkost.net>,
	"Michael S . Tsirkin" <mst@redhat.com>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Xiaoyao Li <xiaoyao.li@intel.com>,
	Pankaj Gupta <pankaj.gupta@amd.com>,
	Zide Chen <zide.chen@intel.com>, qemu-devel@nongnu.org,
	kvm@vger.kernel.org, qemu-stable@nongnu.org
Subject: Re: [PATCH v5 01/11 for v9.2?] i386/cpu: Mark avx10_version filtered
 when prefix is NULL
Message-ID: <Zytffxz6DMfQSv0G@linux.bj.intel.com>
References: <20241106030728.553238-1-zhao1.liu@intel.com>
 <20241106030728.553238-2-zhao1.liu@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241106030728.553238-2-zhao1.liu@intel.com>

On Wed, Nov 06, 2024 at 11:07:18AM +0800, Zhao Liu wrote:
> In x86_cpu_filter_features(), if host doesn't support AVX10, the
> configured avx10_version should be marked as filtered regardless of
> whether prefix is NULL or not.
> 
> Check prefix before warn_report() instead of checking for
> have_filtered_features.
> 
> Cc: qemu-stable@nongnu.org
> Fixes: commit bccfb846fd52 ("target/i386: add AVX10 feature and AVX10 version property")
> Signed-off-by: Zhao Liu <zhao1.liu@intel.com>

Reviewed-by: Tao Su <tao1.su@linux.intel.com>

> ---
> v5: new commit.
> ---
>  target/i386/cpu.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/target/i386/cpu.c b/target/i386/cpu.c
> index 3baa95481fbc..77c1233daa13 100644
> --- a/target/i386/cpu.c
> +++ b/target/i386/cpu.c
> @@ -7711,8 +7711,10 @@ static bool x86_cpu_filter_features(X86CPU *cpu, bool verbose)
>              env->avx10_version = version;
>              have_filtered_features = true;
>          }
> -    } else if (env->avx10_version && prefix) {
> -        warn_report("%s: avx10.%d.", prefix, env->avx10_version);
> +    } else if (env->avx10_version) {
> +        if (prefix) {
> +            warn_report("%s: avx10.%d.", prefix, env->avx10_version);
> +        }
>          have_filtered_features = true;
>      }
>  
> -- 
> 2.34.1
> 

