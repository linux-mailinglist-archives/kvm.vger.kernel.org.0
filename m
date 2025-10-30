Return-Path: <kvm+bounces-61491-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 6BFD5C2109F
	for <lists+kvm@lfdr.de>; Thu, 30 Oct 2025 16:51:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8407B1A264D9
	for <lists+kvm@lfdr.de>; Thu, 30 Oct 2025 15:47:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D5B48221F03;
	Thu, 30 Oct 2025 15:47:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="j0EPSJge"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82D9880604
	for <kvm@vger.kernel.org>; Thu, 30 Oct 2025 15:46:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761839220; cv=none; b=S2N/KU/W1Mwkr/GZ3wnt1qJGzPepvcxnGmsjN3Uv+MDcHqYGd3N53Jg06av29qYpnMoyNMhJE9/cvzw5G1SUYNnGcovJ/QtGhvhyDkoIVu8xYb5kM0LXpp3SqhLdBIh/Dq9BpRyptz9IsUK4JRqethpOwUU6nZFMlPDkZ72iU/s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761839220; c=relaxed/simple;
	bh=Eqo4DVoLwi8Ct/RRlM48iY64Hvj8SIZbn5etBQmpufw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=G9OCfLAJtayhfaf+VM4+MpczZNX0sWJ0arpL0GU7iU6UIvc88zNdNcrvupVdsytWVeJjIbZGOrCyFiIw9snqdT7iJ1h3re9KhnYMxRhh7dNXIsJsAKGs6il75TV2SlN4Gn5jJg9TdrI9kvYxktY8wE4985WPJP7BVxIFt7GPzaw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=j0EPSJge; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761839219; x=1793375219;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Eqo4DVoLwi8Ct/RRlM48iY64Hvj8SIZbn5etBQmpufw=;
  b=j0EPSJgeLtqrbkARwzhSoU/bz/F8bMgAnQgYXmwwQtsFux1BBMThw3ke
   AVIqZZyI2N357Qmi891cDJ5t17BltXlhBIgcrzI3W8wMIRf72Bq/N7GjW
   j42T/a+plgAigSD6TFUc5U1zrNZ9KpoYIw+VS5Jxo5pJhZ+Nj+Uxg6s/L
   R4NYd4VUl2/Hqk9dn85A9WdsQtmfAMczwxsIAiEnSq0E5j6H8rFxq0dJd
   2/bEZPYvuslj7FzkhngTUx7NPwcq86nc3yIX6NCDeF/56aQhyMdD7P+Yo
   P7oqiE7sGB6isP93ofRuTXLaCGc0hRIFE7TfXDSipUvDs60RlCj3S8UeV
   w==;
X-CSE-ConnectionGUID: ijxf802VSrWbpJvXfJfEcg==
X-CSE-MsgGUID: eutFhp3PTieyPtcysjjlbA==
X-IronPort-AV: E=McAfee;i="6800,10657,11598"; a="74278762"
X-IronPort-AV: E=Sophos;i="6.19,267,1754982000"; 
   d="scan'208";a="74278762"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Oct 2025 08:46:58 -0700
X-CSE-ConnectionGUID: FA4RR9eUQNuPiDBK/BMq/w==
X-CSE-MsgGUID: xB9czmitQRuLugEU7B6+XA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,267,1754982000"; 
   d="scan'208";a="186428469"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.39])
  by fmviesa009.fm.intel.com with ESMTP; 30 Oct 2025 08:46:54 -0700
Date: Fri, 31 Oct 2025 00:09:06 +0800
From: Zhao Liu <zhao1.liu@intel.com>
To: Chao Gao <chao.gao@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>, qemu-devel@nongnu.org,
	kvm@vger.kernel.org, John Allen <john.allen@amd.com>,
	Babu Moger <babu.moger@amd.com>,
	Mathias Krause <minipli@grsecurity.net>,
	Dapeng Mi <dapeng1.mi@intel.com>, Zide Chen <zide.chen@intel.com>,
	Chenyi Qiang <chenyi.qiang@intel.com>,
	Xiaoyao Li <xiaoyao.li@intel.com>,
	Farrah Chen <farrah.chen@intel.com>
Subject: Re: [PATCH v3 16/20] i386/cpu: Mark cet-u & cet-s xstates as
 migratable
Message-ID: <aQONorppI83cWYJK@intel.com>
References: <20251024065632.1448606-1-zhao1.liu@intel.com>
 <20251024065632.1448606-17-zhao1.liu@intel.com>
 <aQGvwMTWYPx5FNdQ@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aQGvwMTWYPx5FNdQ@intel.com>

On Wed, Oct 29, 2025 at 02:10:08PM +0800, Chao Gao wrote:
> Date: Wed, 29 Oct 2025 14:10:08 +0800
> From: Chao Gao <chao.gao@intel.com>
> Subject: Re: [PATCH v3 16/20] i386/cpu: Mark cet-u & cet-s xstates as
>  migratable
> 
> On Fri, Oct 24, 2025 at 02:56:28PM +0800, Zhao Liu wrote:
> >Cet-u and cet-s are supervisor xstates. Their states are saved/loaded by
> >saving/loading related CET MSRs. And there's a vmsd "vmstate_cet" to
> >migrate these MSRs.
> >
> >Thus, it's safe to mark them as migratable.
> >
> >Tested-by: Farrah Chen <farrah.chen@intel.com>
> >Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
> >---
> > target/i386/cpu.c | 3 ++-
> > 1 file changed, 2 insertions(+), 1 deletion(-)
> >
> >diff --git a/target/i386/cpu.c b/target/i386/cpu.c
> >index 0bb65e8c5321..c08066a338a3 100644
> >--- a/target/i386/cpu.c
> >+++ b/target/i386/cpu.c
> >@@ -1522,7 +1522,8 @@ FeatureWordInfo feature_word_info[FEATURE_WORDS] = {
> >         .migratable_flags = XSTATE_FP_MASK | XSTATE_SSE_MASK |
> >             XSTATE_YMM_MASK | XSTATE_BNDREGS_MASK | XSTATE_BNDCSR_MASK |
> >             XSTATE_OPMASK_MASK | XSTATE_ZMM_Hi256_MASK | XSTATE_Hi16_ZMM_MASK |
> >-            XSTATE_PKRU_MASK | XSTATE_ARCH_LBR_MASK | XSTATE_XTILE_CFG_MASK |
> >+            XSTATE_PKRU_MASK | XSTATE_CET_U_MASK | XSTATE_CET_S_MASK |
> >+            XSTATE_ARCH_LBR_MASK | XSTATE_XTILE_CFG_MASK |
> >             XSTATE_XTILE_DATA_MASK,
> 
> Supervisor states are enumerated via CPUID[EAX=0xd,ECX=1].ECX/EDX while user
> states are enumerated via CPUID[EAX=0xd,ECX=0].EAX/EDX. So, maybe we need to 
> two new feature words?

Yes, I added the mask into wrong place...

Regards,
Zhao


