Return-Path: <kvm+bounces-23673-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id F070794C9F4
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2024 07:57:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 29F851C21D79
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2024 05:57:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9A53916C86E;
	Fri,  9 Aug 2024 05:57:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="eQ9+lRuw"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 246AB12E7E
	for <kvm@vger.kernel.org>; Fri,  9 Aug 2024 05:57:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723183063; cv=none; b=SKglk+k3y1VOP1Kj41KRzOIu4NFOGab6l+lOwzfrI/jqxnEHwd+yVupHfTv6NpEbJoPx/yhC97IcA6ZwKCyu3mZDw9Bfu4RrpTYHTmYPX0zxyWR26JOXcLRM08brHelsoAfue1pr72gJhqYnvGQjHaP0iurqL9/wCuTfnl18MYw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723183063; c=relaxed/simple;
	bh=xnP+MSR/wvIrA5raQK0NBZEHIJRmZdfsczn+tYlznUM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NjZzkwdkPeh6uPcKXt5zvf6OlwQePi4c5NlHyIsovvcgTNCd4YEyOi1L9K+2CBLwsZcmXOAwLlsP9cz63bsPqWoMl65TAX6dexCIci33X734NMyvxcBgrtnlX63Jti57+HcY5LfDICBsyFzBghGavhPjfGBtTJAGKDGoSEosMHU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=eQ9+lRuw; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1723183062; x=1754719062;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=xnP+MSR/wvIrA5raQK0NBZEHIJRmZdfsczn+tYlznUM=;
  b=eQ9+lRuwKIqduOjaIDrWNgg002rxT0lIiDWc1bDCYkP+bFfeyp5pPSDD
   nQPMKJbLPt/SiXtZ4qXvQWkvpLm2gEYRfETGv2KhoHK0d5MvYg6dGeRQd
   vnuGhNZwG3TFmxYtQNDVO6VZ8Z1aMd2Sv97jvPgKJBWcFg/U5dNQ162+f
   AW4j51bVMqdBncdySut7djpWJNQWE9idRpnDxm41Zn6huBEgV50b8VMFL
   mW/6DQAI5Rsc5VzHWlSGZrWeghAHImgmzhfbG5ZupoFXXjfX7YzClnGiZ
   Q1I+/7KPMV4meNxdbSVlU5cQT1LIdSv1IPhEQbenX8XrzjW0qjNr1amLf
   w==;
X-CSE-ConnectionGUID: WNQX9/WyQS27GqG7E687Lg==
X-CSE-MsgGUID: Je4mcl47SA2P0/hIzaRfUw==
X-IronPort-AV: E=McAfee;i="6700,10204,11158"; a="20905619"
X-IronPort-AV: E=Sophos;i="6.09,275,1716274800"; 
   d="scan'208";a="20905619"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Aug 2024 22:57:39 -0700
X-CSE-ConnectionGUID: WDs2KvbSQLWNIMcbVD4wjQ==
X-CSE-MsgGUID: tkfS8gnOSyeGcFimJ4QBTQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,275,1716274800"; 
   d="scan'208";a="80702279"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.36])
  by fmviesa002.fm.intel.com with ESMTP; 08 Aug 2024 22:57:37 -0700
Date: Fri, 9 Aug 2024 14:13:28 +0800
From: Zhao Liu <zhao1.liu@intel.com>
To: Ani Sinha <anisinha@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, qemu-trivial@nongnu.org,
	kvm@vger.kernel.org, qemu-devel@nongnu.org
Subject: Re: [PATCH v2 1/2] kvm: replace fprintf with error_report() in
 kvm_init() for error conditions
Message-ID: <ZrWziCQWgLogq+lV@intel.com>
References: <20240809051054.1745641-1-anisinha@redhat.com>
 <20240809051054.1745641-2-anisinha@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240809051054.1745641-2-anisinha@redhat.com>

On Fri, Aug 09, 2024 at 10:40:53AM +0530, Ani Sinha wrote:
> Date: Fri,  9 Aug 2024 10:40:53 +0530
> From: Ani Sinha <anisinha@redhat.com>
> Subject: [PATCH v2 1/2] kvm: replace fprintf with error_report() in
>  kvm_init() for error conditions
> X-Mailer: git-send-email 2.45.2
> 
> error_report() is more appropriate for error situations. Replace fprintf with
> error_report. Cosmetic. No functional change.
> 
> CC: qemu-trivial@nongnu.org
> CC: zhao1.liu@intel.com
> Signed-off-by: Ani Sinha <anisinha@redhat.com>
> ---
>  accel/kvm/kvm-all.c | 40 ++++++++++++++++++----------------------
>  1 file changed, 18 insertions(+), 22 deletions(-)
> 
> changelog:
> v2: fix a bug.

Generally good to me. Only some nits below, otherwise,

Reviewed-by: Zhao Liu <zhao1.liu@intel.com>

>  #ifdef TARGET_S390X
>          if (ret == -EINVAL) {
> -            fprintf(stderr,
> -                    "Host kernel setup problem detected. Please verify:\n");
> -            fprintf(stderr, "- for kernels supporting the switch_amode or"
> -                    " user_mode parameters, whether\n");
> -            fprintf(stderr,
> -                    "  user space is running in primary address space\n");
> -            fprintf(stderr,
> -                    "- for kernels supporting the vm.allocate_pgste sysctl, "
> -                    "whether it is enabled\n");
> +            error_report("Host kernel setup problem detected. Please verify:");

The doc of error_report() said it doesn't want multiple sentences or trailing
punctuation:

"The resulting message should be a single phrase, with no newline or trailing
punctuation."

So I think these extra messages (with complex formatting & content) are
better printed with error_printf() as I suggested in [1].

[1]: https://lore.kernel.org/qemu-devel/ZrWP0fWPNzeAvjja@intel.com/T/#m953afd879eb6279fcdf03cda594c43f1829bdffe

> +            error_report("- for kernels supporting the switch_amode or"
> +                        " user_mode parameters, whether");
> +            error_report("  user space is running in primary address space");
> +            error_report("- for kernels supporting the vm.allocate_pgste "
> +                        "sysctl, whether it is enabled");
>          }
>  #elif defined(TARGET_PPC)
>          if (ret == -EINVAL) {
> -            fprintf(stderr,
> -                    "PPC KVM module is not loaded. Try modprobe kvm_%s.\n",
> -                    (type == 2) ? "pr" : "hv");
> +            error_report("PPC KVM module is not loaded. Try modprobe kvm_%s.",
> +                        (type == 2) ? "pr" : "hv");

Same here. A trailing punctuation. If possible, feel free to refer to
the comment in [1].

>          }
>  #endif

[snip]

> @@ -2542,8 +2538,8 @@ static int kvm_init(MachineState *ms)
>      }
>      if (missing_cap) {
>          ret = -EINVAL;
> -        fprintf(stderr, "kvm does not support %s\n%s",
> -                missing_cap->name, upgrade_note);
> +        error_report("kvm does not support %s", missing_cap->name);
> +        error_report("%s", upgrade_note);

"upgrade_note" string also has the trailing punctuation, and it's
also better to use error_printf() to replace the 2nd error_report().

For this patch, error_report() is already a big step forward, so I think
these few nits doesn't block this patch.

Thank you for your patience.
Zhao


