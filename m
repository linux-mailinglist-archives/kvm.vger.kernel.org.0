Return-Path: <kvm+bounces-23665-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 442BE94C8DC
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2024 05:25:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EFB91282237
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2024 03:25:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 331FF182A0;
	Fri,  9 Aug 2024 03:25:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="fLVa0V46"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43324171AA
	for <kvm@vger.kernel.org>; Fri,  9 Aug 2024 03:25:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723173919; cv=none; b=apxfBmFrIUfStheop+RU95dbcUXscrbDj7dvpE4d6QxkveNpP8sKlbQiGt9scjwCRhJKs7ZjHalNbiKnQq6U5wBfqMaeQbOcle8E0wlAHjYOLAaD7IfhOSuY+Yov4T34eyUIezegM41obTCiFY88SLcBTXjJBx0a8RTy51ZRKvE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723173919; c=relaxed/simple;
	bh=Tw+oP3IUd1a2tjFWuBay+BRp/YDXjyJCFYsMxwsCFAA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hc1cKcBb8v0yGJ5B9N7o81RgwQDjrK5fCWp8w4Gs/yJtBtCF4D5JBJmwslZZLyqpeApAP/vi3/zUu7//U3hO9oldaqEDQ59PD2sfDS3/nveXSHN76c8J3hbLyzOD7w94EcE8fVx7ZBxcrzO2q2QnnmAormfW5nBrv4JxgJMsHVI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=fLVa0V46; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1723173918; x=1754709918;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Tw+oP3IUd1a2tjFWuBay+BRp/YDXjyJCFYsMxwsCFAA=;
  b=fLVa0V4698TvNJLjqmSFeSakdJBvNMCA6bMq7x+WlwNLzR9LHFY1CPMK
   FIltBEy3tmeR78dYIEHya4TDnUv/l+Fw1Ei3+SJ4RII6gbV6Vhjs9gsYd
   dNyqtCrO0FadzbiAG6NRKhEm2Jmjq14mreB/pxEpNWK0kITxAcZk1vrTv
   IHykCdRs7jLinfmN8E6ekLLd97RMzFDFCz+u5IJokpoEhCtKTfguqTLqN
   X63dzgeKkAbgH9kDTfHZoIoiZldk+OJNWQ+w0r9gN11XOuHsMe5jG8HQK
   GCDWVX8EdKThHsOVNNt+9ShmraKZj2pE7VZeTfz9LvqsrddW+gTJWtCzU
   Q==;
X-CSE-ConnectionGUID: XlKbsJVlRMybvcrwCtf0EQ==
X-CSE-MsgGUID: +4FrcpYIQNab2LV26Gs38g==
X-IronPort-AV: E=McAfee;i="6700,10204,11158"; a="31909005"
X-IronPort-AV: E=Sophos;i="6.09,275,1716274800"; 
   d="scan'208";a="31909005"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Aug 2024 20:25:17 -0700
X-CSE-ConnectionGUID: TUDafeUTQROSXWiRTIUWbg==
X-CSE-MsgGUID: Z1EXJPldT+Sok75tUmhTgw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,275,1716274800"; 
   d="scan'208";a="57306512"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.36])
  by orviesa010.jf.intel.com with ESMTP; 08 Aug 2024 20:25:15 -0700
Date: Fri, 9 Aug 2024 11:41:05 +0800
From: Zhao Liu <zhao1.liu@intel.com>
To: Ani Sinha <anisinha@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
	qemu-devel@nongnu.org
Subject: Re: [PATCH v2] kvm: refactor core virtual machine creation into its
 own function
Message-ID: <ZrWP0fWPNzeAvjja@intel.com>
References: <20240808113838.1697366-1-anisinha@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240808113838.1697366-1-anisinha@redhat.com>

Hi Ani,

On Thu, Aug 08, 2024 at 05:08:38PM +0530, Ani Sinha wrote:
> Date: Thu,  8 Aug 2024 17:08:38 +0530
> From: Ani Sinha <anisinha@redhat.com>
> Subject: [PATCH v2] kvm: refactor core virtual machine creation into its
>  own function
> X-Mailer: git-send-email 2.45.2
> 
> Refactoring the core logic around KVM_CREATE_VM into its own separate function
> so that it can be called from other functions in subsequent patches. There is
> no functional change in this patch.
> 
> CC: pbonzini@redhat.com
> CC: zhao1.liu@intel.com
> Signed-off-by: Ani Sinha <anisinha@redhat.com>
> ---
>  accel/kvm/kvm-all.c | 93 +++++++++++++++++++++++++++------------------
>  1 file changed, 56 insertions(+), 37 deletions(-)
> 
> changelog:
> v2: s/fprintf/warn_report as suggested by zhao

Thanks for your change!

> diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
> index 75d11a07b2..c2e177c39f 100644
> --- a/accel/kvm/kvm-all.c
> +++ b/accel/kvm/kvm-all.c
> @@ -2385,6 +2385,60 @@ uint32_t kvm_dirty_ring_size(void)
>      return kvm_state->kvm_dirty_ring_size;
>  }
>  
> +static int do_kvm_create_vm(MachineState *ms, int type)
> +{
> +    KVMState *s;
> +    int ret;
> +
> +    s = KVM_STATE(ms->accelerator);
> +
> +    do {
> +        ret = kvm_ioctl(s, KVM_CREATE_VM, type);
> +    } while (ret == -EINTR);
> +
> +    if (ret < 0) {
> +        warn_report("ioctl(KVM_CREATE_VM) failed: %d %s", -ret,
> +                    strerror(-ret));
> +
> +#ifdef TARGET_S390X
> +        if (ret == -EINVAL) {
> +            warn_report("Host kernel setup problem detected. Please verify:");
> +            warn_report("- for kernels supporting the switch_amode or"
> +                        " user_mode parameters, whether");
> +            warn_report("  user space is running in primary address space");
> +            warn_report("- for kernels supporting the vm.allocate_pgste "
> +                        "sysctl, whether it is enabled");
> +        }
> +#elif defined(TARGET_PPC)
> +        if (ret == -EINVAL) {
> +            warn_report("PPC KVM module is not loaded. Try modprobe kvm_%s.",
> +                        (type == 2) ? "pr" : "hv");
> +        }
> +#endif

I think error level message is more appropriate than warn because after
the print QEMU handles error and terminates the Guest startup.

What about the following change?

#ifdef TARGET_S390X
        if (ret == -EINVAL) {
            error_report("Host kernel setup problem detected");
            error_printf("Please verify:\n");
            error_printf("- for kernels supporting the switch_amode or"
                         " user_mode parameters, whether\n");
            error_printf("  user space is running in primary address space\n");
            error_printf("- for kernels supporting the vm.allocate_pgste "
                         "sysctl, whether it is enabled\n");
        }
#elif defined(TARGET_PPC)
        if (ret == -EINVAL) {
            error_report("PPC KVM module is not loaded");
            error_printf("Try modprobe kvm_%s.\n",
                         (type == 2) ? "pr" : "hv");
	}
#endif

The above uses error_report() to just print error reason/error code
since for error_report, "The resulting message should be a single
phrase, with no newline or trailing punctuation."

Other specific hints or information are printed by error_printf()
because style.rst suggests "Use error_printf() & friends to print
additional information."

Thanks,
Zhao

> +    }
> +
> +    return ret;
> +}
> +
> +static int find_kvm_machine_type(MachineState *ms)
> +{
> +    MachineClass *mc = MACHINE_GET_CLASS(ms);
> +    int type;
> +
> +    if (object_property_find(OBJECT(current_machine), "kvm-type")) {
> +        g_autofree char *kvm_type;
> +        kvm_type = object_property_get_str(OBJECT(current_machine),
> +                                           "kvm-type",
> +                                           &error_abort);
> +        type = mc->kvm_type(ms, kvm_type);
> +    } else if (mc->kvm_type) {
> +        type = mc->kvm_type(ms, NULL);
> +    } else {
> +        type = kvm_arch_get_default_type(ms);
> +    }
> +    return type;
> +}
> +
>  static int kvm_init(MachineState *ms)
>  {
>      MachineClass *mc = MACHINE_GET_CLASS(ms);
> @@ -2467,49 +2521,14 @@ static int kvm_init(MachineState *ms)
>      }
>      s->as = g_new0(struct KVMAs, s->nr_as);
>  
> -    if (object_property_find(OBJECT(current_machine), "kvm-type")) {
> -        g_autofree char *kvm_type = object_property_get_str(OBJECT(current_machine),
> -                                                            "kvm-type",
> -                                                            &error_abort);
> -        type = mc->kvm_type(ms, kvm_type);
> -    } else if (mc->kvm_type) {
> -        type = mc->kvm_type(ms, NULL);
> -    } else {
> -        type = kvm_arch_get_default_type(ms);
> -    }
> -
> +    type = find_kvm_machine_type(ms);
>      if (type < 0) {
>          ret = -EINVAL;
>          goto err;
>      }
>  
> -    do {
> -        ret = kvm_ioctl(s, KVM_CREATE_VM, type);
> -    } while (ret == -EINTR);
> -
> +    ret = do_kvm_create_vm(ms, type);
>      if (ret < 0) {
> -        fprintf(stderr, "ioctl(KVM_CREATE_VM) failed: %d %s\n", -ret,
> -                strerror(-ret));
> -
> -#ifdef TARGET_S390X
> -        if (ret == -EINVAL) {
> -            fprintf(stderr,
> -                    "Host kernel setup problem detected. Please verify:\n");
> -            fprintf(stderr, "- for kernels supporting the switch_amode or"
> -                    " user_mode parameters, whether\n");
> -            fprintf(stderr,
> -                    "  user space is running in primary address space\n");
> -            fprintf(stderr,
> -                    "- for kernels supporting the vm.allocate_pgste sysctl, "
> -                    "whether it is enabled\n");
> -        }
> -#elif defined(TARGET_PPC)
> -        if (ret == -EINVAL) {
> -            fprintf(stderr,
> -                    "PPC KVM module is not loaded. Try modprobe kvm_%s.\n",
> -                    (type == 2) ? "pr" : "hv");
> -        }
> -#endif
>          goto err;
>      }
>  
> -- 
> 2.45.2
> 

