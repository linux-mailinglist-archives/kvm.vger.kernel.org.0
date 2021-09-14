Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8A6940AC0F
	for <lists+kvm@lfdr.de>; Tue, 14 Sep 2021 12:55:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231879AbhINK4c (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Sep 2021 06:56:32 -0400
Received: from mga05.intel.com ([192.55.52.43]:54916 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230153AbhINK4a (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Sep 2021 06:56:30 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10106"; a="307508763"
X-IronPort-AV: E=Sophos;i="5.85,292,1624345200"; 
   d="scan'208";a="307508763"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2021 03:55:13 -0700
X-IronPort-AV: E=Sophos;i="5.85,292,1624345200"; 
   d="scan'208";a="451982794"
Received: from krentach-mobl1.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.251.142.231])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2021 03:55:10 -0700
Date:   Tue, 14 Sep 2021 22:55:08 +1200
From:   Kai Huang <kai.huang@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org,
        linux-sgx@vger.kernel.org, jarkko@kernel.org,
        dave.hansen@linux.intel.com, yang.zhong@intel.com
Subject: Re: [PATCH 2/2] x86: sgx_vepc: implement SGX_IOC_VEPC_REMOVE ioctl
Message-Id: <20210914225508.032db86d89e6d207789ec1ea@intel.com>
In-Reply-To: <20210913131153.1202354-3-pbonzini@redhat.com>
References: <20210913131153.1202354-1-pbonzini@redhat.com>
        <20210913131153.1202354-3-pbonzini@redhat.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 13 Sep 2021 09:11:53 -0400 Paolo Bonzini wrote:
> Windows expects all pages to be in uninitialized state on startup.
> Add a ioctl that does this with EREMOVE, so that userspace can bring
> the pages back to this state also when resetting the VM.
> Pure userspace implementations, such as closing and reopening the device,
> are racy.
> 
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  arch/x86/include/uapi/asm/sgx.h |  2 ++
>  arch/x86/kernel/cpu/sgx/virt.c  | 36 +++++++++++++++++++++++++++++++++
>  2 files changed, 38 insertions(+)
> 
> diff --git a/arch/x86/include/uapi/asm/sgx.h b/arch/x86/include/uapi/asm/sgx.h
> index 9690d6899ad9..f79d84ce8033 100644
> --- a/arch/x86/include/uapi/asm/sgx.h
> +++ b/arch/x86/include/uapi/asm/sgx.h
> @@ -27,6 +27,8 @@ enum sgx_page_flags {
>  	_IOW(SGX_MAGIC, 0x02, struct sgx_enclave_init)
>  #define SGX_IOC_ENCLAVE_PROVISION \
>  	_IOW(SGX_MAGIC, 0x03, struct sgx_enclave_provision)
> +#define SGX_IOC_VEPC_REMOVE \
> +	_IO(SGX_MAGIC, 0x04)

Perhaps SGX_IOC_VEPC_RESET is better than REMOVE, since this ioctl doesn't
actually remove any EPC page from virtual EPC device, but just reset to a clean
slate (by using EREMOVE).
