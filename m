Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19EBA42D962
	for <lists+kvm@lfdr.de>; Thu, 14 Oct 2021 14:35:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231480AbhJNMh0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Oct 2021 08:37:26 -0400
Received: from mga04.intel.com ([192.55.52.120]:27952 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230126AbhJNMh0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Oct 2021 08:37:26 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10136"; a="226435933"
X-IronPort-AV: E=Sophos;i="5.85,372,1624345200"; 
   d="scan'208";a="226435933"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Oct 2021 05:35:21 -0700
X-IronPort-AV: E=Sophos;i="5.85,372,1624345200"; 
   d="scan'208";a="481245044"
Received: from yangzhon-virtual.bj.intel.com (HELO yangzhon-Virtual) ([10.238.144.101])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-SHA256; 14 Oct 2021 05:35:19 -0700
Date:   Thu, 14 Oct 2021 20:21:02 +0800
From:   Yang Zhong <yang.zhong@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        dave.hansen@linux.intel.com, seanjc@google.com, x86@kernel.org,
        yang.zhong@intel.com, jarkko@kernel.org
Subject: Re: [PATCH v2 0/2] x86: sgx_vepc: implement ioctl to EREMOVE all
 pages
Message-ID: <20211014122102.GA22574@yangzhon-Virtual>
References: <20211012105708.2070480-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211012105708.2070480-1-pbonzini@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Oct 12, 2021 at 06:57:06AM -0400, Paolo Bonzini wrote:
> Add to /dev/sgx_vepc a ioctl that brings vEPC pages back to uninitialized
> state with EREMOVE.  This is useful in order to match the expectations
> of guests after reboot, and to match the behavior of real hardware.
> 
> The ioctl is a cleaner alternative to closing and reopening the
> /dev/sgx_vepc device; reopening /dev/sgx_vepc could be problematic in
> case userspace has sandboxed itself since the time it first opened the
> device, and has thus lost permissions to do so.
> 
> If possible, I would like these patches to be included in 5.15 through
> either the x86 or the KVM tree.
> 
  
  Paolo, i did the below tests to verify those two patches on ICX server 
  (1). Windows2019 and Linux guest reboot 
  (2). One 10G vepc, and started 500 enclaves(each 2G) in guest, and then reset
       the guest with 'system_reset' command in monitor.
  (3). One 100K vepc, and start one 2M enclave in guest, then reset the guest
       with 'system_reset' command in the monitor.

   All those tests are successful, and the kernel changes work well. Thanks for
   the great support!

   Yang


> Thanks,
> 
> Paolo
> 
> Changes from RFC:
> - improved commit messages, added documentation
> - renamed ioctl from SGX_IOC_VEPC_REMOVE to SGX_IOC_VEPC_REMOVE_ALL
> 
> Change from v1:
> - fixed documentation and code to cover SGX_ENCLAVE_ACT errors
> - removed Tested-by since the code is quite different now
> 
> Paolo Bonzini (2):
>   x86: sgx_vepc: extract sgx_vepc_remove_page
>   x86: sgx_vepc: implement SGX_IOC_VEPC_REMOVE_ALL ioctl
> 
>  Documentation/x86/sgx.rst       | 26 +++++++++++++
>  arch/x86/include/asm/sgx.h      |  3 ++
>  arch/x86/include/uapi/asm/sgx.h |  2 +
>  arch/x86/kernel/cpu/sgx/virt.c  | 69 ++++++++++++++++++++++++++++++---
>  4 files changed, 95 insertions(+), 5 deletions(-)
> 
> -- 
> 2.27.0
