Return-Path: <kvm+bounces-15546-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 6D8E08AD37D
	for <lists+kvm@lfdr.de>; Mon, 22 Apr 2024 19:50:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0D8B51F21B21
	for <lists+kvm@lfdr.de>; Mon, 22 Apr 2024 17:50:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 54023154422;
	Mon, 22 Apr 2024 17:50:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ZipYcwWS"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E221152197;
	Mon, 22 Apr 2024 17:50:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713808238; cv=none; b=R+Zn/kE4wVMONVMk5jkB/+NkZUXWVSubYxiOXXBvf6iTwxTm+LBc2cYiywDt1YcryeP0mxuw/CD0ElkpuD/+AACQ8PWwGMi9IVfD0lIMQ/fPkkXuXURJtymcFaIy5OZWS/O26J7LPDQpZXRwxhxYw2MSjG2A7SQ9JvDbOpl7ibs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713808238; c=relaxed/simple;
	bh=Qw/XTx7VLmthJ54XYfaELgIcf7RnZMS2pyeRWr1PD90=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RaWslKgrLngLFKEg6bXXtGjQodBUCoxVR1LZyBbIYu6riQWMxhrOvGGKOrmsSfhlJj5n7pz6n/FBUy3ipBK78C38GzcrgNksdL4nCOSGwDFNKQ++1UWcfgHT0prbS/xCfwkmmdLckCfpYQodPopWDtUPf0WZoYWcsHmz0rqWzOk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ZipYcwWS; arc=none smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713808235; x=1745344235;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Qw/XTx7VLmthJ54XYfaELgIcf7RnZMS2pyeRWr1PD90=;
  b=ZipYcwWSDnUvQ+p3thVKxnR0KgjG7Pn9TfPbbjD2m3bVSRrxfNKaupgG
   nHfmPl3pEf0dqBGtLYgfMhGP8doEpwGr5Acah+5cJZeRAMT8j8B7mgC6p
   eXgp5ubuwgDUBLH97he+pcY2zYlKzkdXZMLcBpvR/ymMJKEO/+PMm441B
   JPgvslgfZJ/86IXhkhjkg9AAm1PPPEP3Nkd1UBSNLooENgd5jyw7NFw/x
   4JNbpt41/cEAXLmNsL67hVXm1kHYglRn55SDqVl+/sVd4OwXjugtk5Z4N
   ynb+T8wJxC1ozsS6pVTiPs+tCXGdH8ydXiq92JJUPbx/dAohBn2uJpu7A
   Q==;
X-CSE-ConnectionGUID: XL1wmoxjRmyAW3OEyojiJg==
X-CSE-MsgGUID: RCTNhaV7QOGEeklY9JGJVw==
X-IronPort-AV: E=McAfee;i="6600,9927,11052"; a="9191158"
X-IronPort-AV: E=Sophos;i="6.07,221,1708416000"; 
   d="scan'208";a="9191158"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Apr 2024 10:50:35 -0700
X-CSE-ConnectionGUID: IeyaIZ5ORR+2ySyY7QiO9g==
X-CSE-MsgGUID: zwNY0vCbQoS3GTyZeOJhfA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,221,1708416000"; 
   d="scan'208";a="24142083"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Apr 2024 10:50:34 -0700
Date: Mon, 22 Apr 2024 10:50:33 -0700
From: Isaku Yamahata <isaku.yamahata@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
	isaku.yamahata@intel.com, xiaoyao.li@intel.com,
	binbin.wu@linux.intel.com, seanjc@google.com,
	rick.p.edgecombe@intel.com, isaku.yamahata@linux.intel.com
Subject: Re: [PATCH 6/6] KVM: selftests: x86: Add test for
 KVM_PRE_FAULT_MEMORY
Message-ID: <20240422175033.GL3596705@ls.amr.corp.intel.com>
References: <20240419085927.3648704-1-pbonzini@redhat.com>
 <20240419085927.3648704-7-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240419085927.3648704-7-pbonzini@redhat.com>

On Fri, Apr 19, 2024 at 04:59:27AM -0400,
Paolo Bonzini <pbonzini@redhat.com> wrote:

> From: Isaku Yamahata <isaku.yamahata@intel.com>
> 
> Add a test case to exercise KVM_PRE_FAULT_MEMORY and run the guest to access the
> pre-populated area.  It tests KVM_PRE_FAULT_MEMORY ioctl for KVM_X86_DEFAULT_VM
> and KVM_X86_SW_PROTECTED_VM.
> 
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> Message-ID: <32427791ef42e5efaafb05d2ac37fa4372715f47.1712785629.git.isaku.yamahata@intel.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  tools/include/uapi/linux/kvm.h                |   8 +
>  tools/testing/selftests/kvm/Makefile          |   1 +
>  .../selftests/kvm/pre_fault_memory_test.c     | 146 ++++++++++++++++++
>  3 files changed, 155 insertions(+)
>  create mode 100644 tools/testing/selftests/kvm/pre_fault_memory_test.c
> 
> diff --git a/tools/include/uapi/linux/kvm.h b/tools/include/uapi/linux/kvm.h
> index c3308536482b..4d66d8afdcd1 100644
> --- a/tools/include/uapi/linux/kvm.h
> +++ b/tools/include/uapi/linux/kvm.h
> @@ -2227,4 +2227,12 @@ struct kvm_create_guest_memfd {
>  	__u64 reserved[6];
>  };
>  
> +#define KVM_PRE_FAULT_MEMORY	_IOWR(KVMIO, 0xd5, struct kvm_pre_fault_memory)
> +
> +struct kvm_pre_fault_memory {
> +	__u64 gpa;
> +	__u64 size;
> +	__u64 flags;

nitpick: catch up for struct update.
+       __u64 padding[5];

> +};
> +
>  #endif /* __LINUX_KVM_H */
-- 
Isaku Yamahata <isaku.yamahata@intel.com>

