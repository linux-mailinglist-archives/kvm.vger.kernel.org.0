Return-Path: <kvm+bounces-33543-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4CFFC9EDDF9
	for <lists+kvm@lfdr.de>; Thu, 12 Dec 2024 04:41:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CA226164B69
	for <lists+kvm@lfdr.de>; Thu, 12 Dec 2024 03:41:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DB10E14D719;
	Thu, 12 Dec 2024 03:41:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="tS93Gam/"
X-Original-To: kvm@vger.kernel.org
Received: from out30-112.freemail.mail.aliyun.com (out30-112.freemail.mail.aliyun.com [115.124.30.112])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4F1413D8A0
	for <kvm@vger.kernel.org>; Thu, 12 Dec 2024 03:41:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.112
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733974903; cv=none; b=RVYq4pxixnJdfVkNZmrEZxUuIxEAsATQwsdDrborTDXTiMz182BVckOGYbG3jQlZHGqeTiPRByPlJJRXcVjDTpvLz/8gUnrY4Dk0dZaUM82/UacMIi7Ygouq9HTlihPr4JQPl4U673MI7y4pMn5zU+XKfZvGXXjngobI0KBFo2s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733974903; c=relaxed/simple;
	bh=epNBq3Q6Iflk8sdwpV5uDV3RHb3v9QUwGr/PQt399TA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eLHCyH1XC6g13krEPhBVFkVYNNrNTmoTcdZXtbDk6myl2Ae3BfvpVZ9D84ym3/q/l68sHsJfxjrSUxi1vjnfmcmVnHvhXLrL043ie8zf7paimQ2o0C6pcMz6IVYREkqJgw8kUpxijvXnXF2fm5fGZNBPK+PxeRvJxmhRAngWYZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=tS93Gam/; arc=none smtp.client-ip=115.124.30.112
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1733974897; h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type;
	bh=9EcLnTR7QbNumNY8YIr1TZfrhT/nECOq4b1pLbyi7qY=;
	b=tS93Gam/2cjWwqs7htOxmygW5bVibuXxH66a19CU2siJRSmiuZXrsQPloNEdqsZMZP0UpZuVDtkUyW6YZxR4Chbaz4UO5rjQCwDlibFsd9wyx6d5GwBF/FcTYYIThW87sGsFeWdT/VLOsvrt5HpftKAjFVK6HYGIC5RrOe1wnVU=
Received: from localhost(mailfrom:yaoyuan@linux.alibaba.com fp:SMTPD_---0WLKA3v0_1733974896 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 12 Dec 2024 11:41:36 +0800
Date: Thu, 12 Dec 2024 11:41:34 +0800
From: Yao Yuan <yaoyuan@linux.alibaba.com>
To: Binbin Wu <binbin.wu@linux.intel.com>
Cc: pbonzini@redhat.com, xiaoyao.li@intel.com, qemu-devel@nongnu.org, 
	seanjc@google.com, michael.roth@amd.com, rick.p.edgecombe@intel.com, 
	isaku.yamahata@intel.com, farrah.chen@intel.com, kvm@vger.kernel.org
Subject: Re: [PATCH] i386/kvm: Set return value after handling
 KVM_EXIT_HYPERCALL
Message-ID: <ivj52agcnualj7avwe4mbv65q6hd3fyzjihnm4sejieiewv2ae@s5d55tdzgnfq>
References: <20241212032628.475976-1-binbin.wu@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241212032628.475976-1-binbin.wu@linux.intel.com>

On Thu, Dec 12, 2024 at 11:26:28AM +0800, Binbin Wu wrote:
> Userspace should set the ret field of hypercall after handling
> KVM_EXIT_HYPERCALL.  Otherwise, a stale value could be returned to KVM.
>
> Fixes: 47e76d03b15 ("i386/kvm: Add KVM_EXIT_HYPERCALL handling for KVM_HC_MAP_GPA_RANGE")
> Reported-by: Farrah Chen <farrah.chen@intel.com>
> Signed-off-by: Binbin Wu <binbin.wu@linux.intel.com>
> Tested-by: Farrah Chen <farrah.chen@intel.com>
> ---
> To test the TDX code in kvm-coco-queue, please apply the patch to the QEMU,
> otherwise, TDX guest boot could fail.
> A matching QEMU tree including this patch is here:
> https://github.com/intel-staging/qemu-tdx/releases/tag/tdx-qemu-upstream-v6.1-fix_kvm_hypercall_return_value
>
> Previously, the issue was not triggered because no one would modify the ret
> value. But with the refactor patch for __kvm_emulate_hypercall() in KVM,
> https://lore.kernel.org/kvm/20241128004344.4072099-7-seanjc@google.com/, the
> value could be modified.
> ---
>  target/i386/kvm/kvm.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
>
> diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
> index 8e17942c3b..4bcccb48d1 100644
> --- a/target/i386/kvm/kvm.c
> +++ b/target/i386/kvm/kvm.c
> @@ -6005,10 +6005,14 @@ static int kvm_handle_hc_map_gpa_range(struct kvm_run *run)
>
>  static int kvm_handle_hypercall(struct kvm_run *run)
>  {
> +    int ret = -EINVAL;
> +
>      if (run->hypercall.nr == KVM_HC_MAP_GPA_RANGE)
> -        return kvm_handle_hc_map_gpa_range(run);
> +        ret = kvm_handle_hc_map_gpa_range(run);

LGTM to the issue it tries to fix :-)

> +
> +    run->hypercall.ret = ret;
>
> -    return -EINVAL;
> +    return ret;
>  }
>
>  #define VMX_INVALID_GUEST_STATE 0x80000021
>
> base-commit: ae35f033b874c627d81d51070187fbf55f0bf1a7
> --
> 2.46.0
>

