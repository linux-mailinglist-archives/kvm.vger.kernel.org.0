Return-Path: <kvm+bounces-70708-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id KCpaF3rZimnrOAAAu9opvQ
	(envelope-from <kvm+bounces-70708-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 08:08:42 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id E6A94117AC3
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 08:08:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id F24903037D55
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 07:07:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CF52B32F742;
	Tue, 10 Feb 2026 07:07:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="PRFYLgts"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B01EE32E757
	for <kvm@vger.kernel.org>; Tue, 10 Feb 2026 07:07:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770707274; cv=none; b=JOVaJ7pX5PVDADewW+rp1QwXvJ2nSar2gG5fQjIZZ+KgKC/EKGPKq8zU8iBKrwH8skDaB5dUCW0d6itu2iXAwlr8h6/30i95kxPCzk6kpj8zINaGfUL8yFxt0YtqGyfdH+wT5KzJl+BVfIHpp2dMxsjsqirtjRqfzhesMRvQQdY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770707274; c=relaxed/simple;
	bh=VCHm+1U7yx0luMTFJ4dTIegtYJP0FVqEZIZriluU/LE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=iHGS5X8cjpU4DSd9Emzj0S9B1Xud/Z+pliBW5kNJ/7WAEe81FgIhVgr9DU6BZKLEHHxTv0bBqTDzy6fbtqY1KDuJwpc2zOHhRnAKQKb1vXFZQVfiVejMO4nX7JVZrTqPL09hvgn4ZphnVPzrsbBeEFTJQ49TZX8YE0A1O7xx1yM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=PRFYLgts; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1770707273; x=1802243273;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=VCHm+1U7yx0luMTFJ4dTIegtYJP0FVqEZIZriluU/LE=;
  b=PRFYLgts62FYj9erbYwhozs1pjfGFBbgZeQYFqB1IVIbwnIOSNwzR1r2
   nyHfUlmf+B1q/Y6nOm28jqA9K07WynZC8DiVaEnV1yuOB3oFH8La7u93E
   BAkVP8sKtUzXFW88s582XRDRGPVGWWyqPrBVa1Nz1uNK2tqchts6yckqn
   +fMxOuU7L2Fv/TYxGyaVQdZmJM8NnOa06hcXk4uV2tTgCvPEmYEURuuuk
   4J0MyxHCSa3CJUb6izTbKh/sVjhjRrOdKRAoBYv8utVh9VzQmV36Oo22z
   YOUYbSZ72bg4eCTLFXA8QMMmWqfE5Ds6g0DbQoIM9Q+8Y1uuQZLUlapHO
   w==;
X-CSE-ConnectionGUID: eo1VlGxzSMm0d3g6Ib+mzg==
X-CSE-MsgGUID: x8yQUrB4Q42vyDFCnYWB6w==
X-IronPort-AV: E=McAfee;i="6800,10657,11696"; a="71039005"
X-IronPort-AV: E=Sophos;i="6.21,283,1763452800"; 
   d="scan'208";a="71039005"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Feb 2026 23:07:52 -0800
X-CSE-ConnectionGUID: GRhIKsADTVSQ1t+LQYmsqA==
X-CSE-MsgGUID: 9spyRXT5SyWOs1i1oC+1Uw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,283,1763452800"; 
   d="scan'208";a="211038275"
Received: from qianm-mobl2.ccr.corp.intel.com (HELO [10.238.1.184]) ([10.238.1.184])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Feb 2026 23:07:49 -0800
Message-ID: <aebb7e2a-9690-45d2-8410-3d27bb3fa715@linux.intel.com>
Date: Tue, 10 Feb 2026 15:07:47 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V2 08/11] target/i386: Clean up LBR format handling
To: Zide Chen <zide.chen@intel.com>, qemu-devel@nongnu.org,
 kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
 Zhao Liu <zhao1.liu@intel.com>, Peter Xu <peterx@redhat.com>,
 Fabiano Rosas <farosas@suse.de>
Cc: Xiaoyao Li <xiaoyao.li@intel.com>, Dongli Zhang <dongli.zhang@oracle.com>
References: <20260128231003.268981-1-zide.chen@intel.com>
 <20260128231003.268981-9-zide.chen@intel.com>
Content-Language: en-US
From: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
In-Reply-To: <20260128231003.268981-9-zide.chen@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	FORGED_SENDER_MAILLIST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,intel.com:email,intel.com:dkim];
	TO_DN_SOME(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROM(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[dapeng1.mi@linux.intel.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[9];
	PRECEDENCE_BULK(0.00)[];
	TAGGED_FROM(0.00)[bounces-70708-lists,kvm=lfdr.de];
	RCVD_COUNT_FIVE(0.00)[5];
	RCVD_TLS_LAST(0.00)[];
	DKIM_TRACE(0.00)[intel.com:+]
X-Rspamd-Queue-Id: E6A94117AC3
X-Rspamd-Action: no action


On 1/29/2026 7:09 AM, Zide Chen wrote:
> Since the lbr-fmt property is masked with PERF_CAP_LBR_FMT in
> DEFINE_PROP_UINT64_CHECKMASK(), there is no need to explicitly validate
> user-requested lbr-fmt values.
>
> The PMU feature is only supported when running under KVM, so initialize
> cpu->lbr_fmt in kvm_cpu_instance_init().  Use -1 as the default lbr-fmt,
> rather than initializing it with ~PERF_CAP_LBR_FMT, which is misleading
> as it suggests a semantic relationship that does not exist.
>
> Rename requested_lbr_fmt to a more generic guest_fmt.  When lbr-fmt is
> not specified and cpu->migratable is false, the guest lbr_fmt value is
> not user-requested.
>
> Signed-off-by: Zide Chen <zide.chen@intel.com>
> ---
> V2:
> - New patch.
>
>  target/i386/cpu.c         | 18 ++++++------------
>  target/i386/kvm/kvm-cpu.c |  2 ++
>  2 files changed, 8 insertions(+), 12 deletions(-)
>
> diff --git a/target/i386/cpu.c b/target/i386/cpu.c
> index f2c83b4f259c..09180c718d58 100644
> --- a/target/i386/cpu.c
> +++ b/target/i386/cpu.c
> @@ -9788,7 +9788,7 @@ static void x86_cpu_realizefn(DeviceState *dev, Error **errp)
>      X86CPUClass *xcc = X86_CPU_GET_CLASS(dev);
>      CPUX86State *env = &cpu->env;
>      Error *local_err = NULL;
> -    unsigned requested_lbr_fmt;
> +    unsigned guest_fmt;
>  
>      if (!kvm_enabled())
>          cpu->enable_pmu = false;
> @@ -9828,11 +9828,7 @@ static void x86_cpu_realizefn(DeviceState *dev, Error **errp)
>       * Override env->features[FEAT_PERF_CAPABILITIES].LBR_FMT
>       * with user-provided setting.
>       */
> -    if (cpu->lbr_fmt != ~PERF_CAP_LBR_FMT) {
> -        if ((cpu->lbr_fmt & PERF_CAP_LBR_FMT) != cpu->lbr_fmt) {
> -            error_setg(errp, "invalid lbr-fmt");
> -            return;
> -        }
> +    if (cpu->lbr_fmt != -1) {
>          env->features[FEAT_PERF_CAPABILITIES] &= ~PERF_CAP_LBR_FMT;
>          env->features[FEAT_PERF_CAPABILITIES] |= cpu->lbr_fmt;
>      }
> @@ -9841,9 +9837,8 @@ static void x86_cpu_realizefn(DeviceState *dev, Error **errp)
>       * vPMU LBR is supported when 1) KVM is enabled 2) Option pmu=on and
>       * 3)vPMU LBR format matches that of host setting.
>       */
> -    requested_lbr_fmt =
> -        env->features[FEAT_PERF_CAPABILITIES] & PERF_CAP_LBR_FMT;
> -    if (requested_lbr_fmt && kvm_enabled()) {
> +    guest_fmt = env->features[FEAT_PERF_CAPABILITIES] & PERF_CAP_LBR_FMT;
> +    if (guest_fmt) {
>          uint64_t host_perf_cap =
>              x86_cpu_get_supported_feature_word(NULL, FEAT_PERF_CAPABILITIES);
>          unsigned host_lbr_fmt = host_perf_cap & PERF_CAP_LBR_FMT;
> @@ -9852,10 +9847,10 @@ static void x86_cpu_realizefn(DeviceState *dev, Error **errp)
>              error_setg(errp, "vPMU: LBR is unsupported without pmu=on");
>              return;
>          }
> -        if (requested_lbr_fmt != host_lbr_fmt) {
> +        if (guest_fmt != host_lbr_fmt) {
>              error_setg(errp, "vPMU: the lbr-fmt value (0x%x) does not match "
>                          "the host value (0x%x).",
> -                        requested_lbr_fmt, host_lbr_fmt);
> +                        guest_fmt, host_lbr_fmt);
>              return;
>          }
>      }
> @@ -10279,7 +10274,6 @@ static void x86_cpu_initfn(Object *obj)
>      object_property_add_alias(obj, "sse4_2", obj, "sse4.2");
>  
>      object_property_add_alias(obj, "hv-apicv", obj, "hv-avic");
> -    cpu->lbr_fmt = ~PERF_CAP_LBR_FMT;
>      object_property_add_alias(obj, "lbr_fmt", obj, "lbr-fmt");
>  
>      if (xcc->model) {
> diff --git a/target/i386/kvm/kvm-cpu.c b/target/i386/kvm/kvm-cpu.c
> index 33a8c26bc27c..b4500ab69f82 100644
> --- a/target/i386/kvm/kvm-cpu.c
> +++ b/target/i386/kvm/kvm-cpu.c
> @@ -231,6 +231,8 @@ static void kvm_cpu_instance_init(CPUState *cs)
>          kvm_cpu_max_instance_init(cpu);
>      }
>  
> +    cpu->lbr_fmt = -1;
> +
>      kvm_cpu_xsave_init();
>  }
>  

Reviewed-by: Dapeng Mi <dapeng1.mi@linux.intel.com>



