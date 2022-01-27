Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7BEE49DA5A
	for <lists+kvm@lfdr.de>; Thu, 27 Jan 2022 06:54:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236338AbiA0Fyz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Jan 2022 00:54:55 -0500
Received: from mga04.intel.com ([192.55.52.120]:10536 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229551AbiA0Fyz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Jan 2022 00:54:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643262895; x=1674798895;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=wZNiQ5pkRxeJ8Ao6cIn34CxSJY+ary9AZNzrIwzYuZw=;
  b=DAm4AWoVR//pENCcSmxfnRtRFFYka0wru3n9iha4lTHYWBMNStNAIpYy
   jvwARkDpvcYeWPFrSDv3/jOvdSVlUE7RlhLENZ/XSVferQ6/PmlTSsufx
   xDE7yi6WnR5/P/E1qZwGGuzfOA9tCnT6vPtp2bOx0wuu+q+VmnIlYCdQx
   tRJlPILjHFC6MlmYMaBpDUxy6IIG89TVfqlIRpRF8DOTvRjlWzZL1Tisi
   XcPCz0srr91B/8XiiXjEPTV7rSIlIiHgHb/tBJUEkQySHxqJx34ljwAA5
   D81D53nZP1I7SS1QF6a8gr7LSMkm6NNlBQOyyJPtQbCUkJtSJdfEHFFdp
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10239"; a="245596571"
X-IronPort-AV: E=Sophos;i="5.88,320,1635231600"; 
   d="scan'208";a="245596571"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2022 21:54:54 -0800
X-IronPort-AV: E=Sophos;i="5.88,320,1635231600"; 
   d="scan'208";a="628566642"
Received: from yangzhon-virtual.bj.intel.com (HELO yangzhon-Virtual) ([10.238.145.56])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-SHA256; 26 Jan 2022 21:54:52 -0800
Date:   Thu, 27 Jan 2022 13:39:29 +0800
From:   Yang Zhong <yang.zhong@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        seanjc@google.com, yang.zhong@intel.com
Subject: Re: [PATCH 0/3] KVM: x86: export supported_xcr0 via UAPI
Message-ID: <20220127053929.GA8503@yangzhon-Virtual>
References: <20220126152210.3044876-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220126152210.3044876-1-pbonzini@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jan 26, 2022 at 10:22:07AM -0500, Paolo Bonzini wrote:
> While working on the QEMU support for AMX, I noticed that there is no
> equivalent of ARCH_GET_XCOMP_SUPP in the KVM API.  This is important
> because KVM_GET_SUPPORTED_CPUID is meant to be passed (by simple-minded
> VMMs) to KVM_SET_CPUID2, and therefore it cannot include any dynamic
> xsave states that have not been enabled.  Probing the availability of
> dynamic xsave states therefore, requires a new ioctl or arch_prctl.
> 
> In order to avoid moving supported_xcr0 to the kernel from the KVM
> module just for this use, and to ensure that the value can only be
> probed if/after the KVM module has been loaded, this series goes
> for the former option.
> 
> KVM_CHECK_EXTENSION cannot be used because it only has 32 bits of
> output; in order to limit the growth of capabilities and ioctls, the
> series adds a /dev/kvm variant of KVM_{GET,HAS}_DEVICE_ATTR that
> can be used in the future and by other architectures.  It then
> implements it in x86 with just one group (0) and attribute
> (KVM_X86_XCOMP_GUEST_SUPP).
> 
> The corresponding changes to the tests, in patches 1 and 3, are
> designed so that the code will be covered (to the possible extent)
> even when running the tests on systems that do not support AMX.
> However, the patches have not been tested with AMX.
>

  Paolo, thanks for this patchset. I applied this patchset into latest
  Linux release, and verified it from kvm selftest tool and Qemu side
  (In order to verify this easily, I reused the older request permission
   function like kvm selftest did), all work well. thanks!

  Yang
 
> Thanks,
> 
> Paolo
> 
> 
> Paolo Bonzini (3):
>   selftests: kvm: move vm_xsave_req_perm call to amx_test
>   KVM: x86: add system attribute to retrieve full set of supported xsave
>     states
>   selftests: kvm: check dynamic bits against KVM_X86_XCOMP_GUEST_SUPP
> 
>  Documentation/virt/kvm/api.rst                |  4 +-
>  arch/x86/include/uapi/asm/kvm.h               |  3 ++
>  arch/x86/kvm/x86.c                            | 45 +++++++++++++++++++
>  include/uapi/linux/kvm.h                      |  1 +
>  tools/arch/x86/include/uapi/asm/kvm.h         |  3 ++
>  tools/include/uapi/linux/kvm.h                |  1 +
>  .../selftests/kvm/include/kvm_util_base.h     |  1 -
>  .../selftests/kvm/include/x86_64/processor.h  |  1 +
>  tools/testing/selftests/kvm/lib/kvm_util.c    |  7 ---
>  .../selftests/kvm/lib/x86_64/processor.c      | 27 ++++++++---
>  tools/testing/selftests/kvm/x86_64/amx_test.c |  2 +
>  11 files changed, 80 insertions(+), 15 deletions(-)
> 
> -- 
> 2.31.1
