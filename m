Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D18704371F7
	for <lists+kvm@lfdr.de>; Fri, 22 Oct 2021 08:39:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232130AbhJVGmL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Oct 2021 02:42:11 -0400
Received: from mga12.intel.com ([192.55.52.136]:13560 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231894AbhJVGmK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Oct 2021 02:42:10 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10144"; a="209341395"
X-IronPort-AV: E=Sophos;i="5.87,171,1631602800"; 
   d="scan'208";a="209341395"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Oct 2021 23:39:53 -0700
X-IronPort-AV: E=Sophos;i="5.87,171,1631602800"; 
   d="scan'208";a="495540650"
Received: from yangzhon-virtual.bj.intel.com (HELO yangzhon-Virtual) ([10.238.144.101])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-SHA256; 21 Oct 2021 23:39:51 -0700
Date:   Fri, 22 Oct 2021 14:25:29 +0800
From:   Yang Zhong <yang.zhong@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org, bp@suse.de,
        seanjc@google.com, dave.hansen@linux.intel.com, jarkko@kernel.org,
        yang.zhong@intel.com, x86@kernel.org
Subject: Re: [PATCH v4 0/2] x86: sgx_vepc: implement ioctl to EREMOVE all
 pages
Message-ID: <20211022062529.GA5469@yangzhon-Virtual>
References: <20211021201155.1523989-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211021201155.1523989-1-pbonzini@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Oct 21, 2021 at 04:11:53PM -0400, Paolo Bonzini wrote:
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

  Paolo, i verified this version with latest SGX NUMA patches plus Qemu
  reset patch, and below all tests are passed.
  1). Windows2019 guest reboot.
  2). Single vepc and multiple vepcs to guest, and run 500 enclaves in the
      guest. reboot the guest.

  This kernel patchset can remove all pages including child and SECS pages
  with one round or two rounds removals from Qemu side.

  The Qemu NUMA v2 will be sent out today, and which will include this reset
  patch. Welcome to use this v2 to verify this reset or NUMA cases, thanks!

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
> Changes from v2:
> - return EBUSY also if EREMOVE causes a general protection fault
> 
> Changes from v3:
> - keep the warning if EREMOVE causes a #PF (or any other fault
>   than a general protection fault)
> 
> Paolo Bonzini (2):
>   x86: sgx_vepc: extract sgx_vepc_remove_page
>   x86: sgx_vepc: implement SGX_IOC_VEPC_REMOVE_ALL ioctl
> 
>  Documentation/x86/sgx.rst       | 35 +++++++++++++++++++++
>  arch/x86/include/uapi/asm/sgx.h |  2 ++
>  arch/x86/kernel/cpu/sgx/virt.c  | 63 ++++++++++++++++++++++++++++++---
>  3 files changed, 95 insertions(+), 5 deletions(-)
> 
> -- 
> 2.27.0
