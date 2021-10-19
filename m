Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B72A343338D
	for <lists+kvm@lfdr.de>; Tue, 19 Oct 2021 12:32:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235243AbhJSKeT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Oct 2021 06:34:19 -0400
Received: from mga04.intel.com ([192.55.52.120]:50296 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230123AbhJSKeT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Oct 2021 06:34:19 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10141"; a="227245162"
X-IronPort-AV: E=Sophos;i="5.85,384,1624345200"; 
   d="scan'208";a="227245162"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Oct 2021 03:32:06 -0700
X-IronPort-AV: E=Sophos;i="5.85,384,1624345200"; 
   d="scan'208";a="494037103"
Received: from yangzhon-virtual.bj.intel.com (HELO yangzhon-Virtual) ([10.238.144.101])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-SHA256; 19 Oct 2021 03:32:04 -0700
Date:   Tue, 19 Oct 2021 18:17:44 +0800
From:   Yang Zhong <yang.zhong@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        dave.hansen@linux.intel.com, seanjc@google.com, x86@kernel.org,
        yang.zhong@intel.com, jarkko@kernel.org, bp@suse.de
Subject: Re: [PATCH v3 0/2] x86: sgx_vepc: implement ioctl to EREMOVE all
 pages
Message-ID: <20211019101744.GA30037@yangzhon-Virtual>
References: <20211016071434.167591-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20211016071434.167591-1-pbonzini@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Oct 16, 2021 at 03:14:32AM -0400, Paolo Bonzini wrote:
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

  Paolo, i verified this version with Qemu reset patch, and passed all
  test.
  (1). sgx windows guest reset test.
  (2). single vepc or multiple vepc reset with 100 enlclaves are running
       in the guest.

  Thanks，

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
