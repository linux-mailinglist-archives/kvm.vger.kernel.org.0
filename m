Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 890394128BF
	for <lists+kvm@lfdr.de>; Tue, 21 Sep 2021 00:19:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237996AbhITWUg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Sep 2021 18:20:36 -0400
Received: from mga07.intel.com ([134.134.136.100]:1825 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233427AbhITWSg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Sep 2021 18:18:36 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10113"; a="286919666"
X-IronPort-AV: E=Sophos;i="5.85,309,1624345200"; 
   d="scan'208";a="286919666"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Sep 2021 15:17:07 -0700
X-IronPort-AV: E=Sophos;i="5.85,309,1624345200"; 
   d="scan'208";a="584834430"
Received: from cwoo-mobl1.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.254.34.163])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Sep 2021 15:17:04 -0700
Date:   Tue, 21 Sep 2021 10:17:02 +1200
From:   Kai Huang <kai.huang@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org,
        linux-sgx@vger.kernel.org, jarkko@kernel.org,
        dave.hansen@linux.intel.com, yang.zhong@intel.com
Subject: Re: [PATCH 2/2] x86: sgx_vepc: implement SGX_IOC_VEPC_REMOVE_ALL
 ioctl
Message-Id: <20210921101702.8672a0f1e356289e21864a76@intel.com>
In-Reply-To: <20210920125401.2389105-3-pbonzini@redhat.com>
References: <20210920125401.2389105-1-pbonzini@redhat.com>
        <20210920125401.2389105-3-pbonzini@redhat.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 20 Sep 2021 08:54:01 -0400 Paolo Bonzini wrote:
> For bare-metal SGX on real hardware, the hardware provides guarantees
> SGX state at reboot.  For instance, all pages start out uninitialized.
> The vepc driver provides a similar guarantee today for freshly-opened
> vepc instances, but guests such as Windows expect all pages to be in
> uninitialized state on startup, including after every guest reboot.
> 
> Some userspace implementations of virtual SGX would rather avoid having
> to close and reopen the /dev/sgx_vepc file descriptor and re-mmap the
> virtual EPC.  For example, they could be sandboxing themselves before the
> guest starts in order to mitigate exploits from untrusted guests,
> forbidding further calls to open().
> 
> Therefore, add a ioctl that does this with EREMOVE.  Userspace can
> invoke the ioctl to bring its vEPC pages back to uninitialized state.
> There is a possibility that some pages fail to be removed if they are
> SECS pages, so the ioctl returns the number of EREMOVE failures.  The
> correct usage is documented in sgx.rst.
> 
> Tested-by: Yang Zhong <yang.zhong@intel.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  Documentation/x86/sgx.rst       | 14 +++++++++++++
>  arch/x86/include/uapi/asm/sgx.h |  2 ++
>  arch/x86/kernel/cpu/sgx/virt.c  | 36 +++++++++++++++++++++++++++++++++
>  3 files changed, 52 insertions(+)
> 
> diff --git a/Documentation/x86/sgx.rst b/Documentation/x86/sgx.rst
> index dd0ac96ff9ef..b855db96c6c6 100644
> --- a/Documentation/x86/sgx.rst
> +++ b/Documentation/x86/sgx.rst
> @@ -250,3 +250,17 @@ user wants to deploy SGX applications both on the host and in guests
>  on the same machine, the user should reserve enough EPC (by taking out
>  total virtual EPC size of all SGX VMs from the physical EPC size) for
>  host SGX applications so they can run with acceptable performance.
> +
> +Some guests, such as Windows, require that all pages are uninitialized
> +at startup or after a guest reboot.  

I would say this is not requirement of some windows guests, but requirement of
correctly emulating architectural behaviour.  On bare-metal EPC is lost on
reboot, so on VM reboot, virtual EPC should be reset too, regardless what
guest VM is.  

Because this state can be reached
> +only through the privileged ``ENCLS[EREMOVE]`` instruction, ``/dev/sgx_vepc``
> +provides the ``SGX_IOC_VEPC_REMOVE_ALL`` ioctl to execute the instruction on
> +all pages in the virtual EPC.
> +
> +The ioctl will often not able to remove SECS pages, in case their child
> +pages have not gone through ``EREMOVE`` yet; therefore, the ioctl returns the
> +number of pages that failed to be removed.  ``SGX_IOC_VEPC_REMOVE_ALL`` should
> +first be invoked on all the ``/dev/sgx_vepc`` file descriptors mapped
> +into the guest; a second call to the ioctl will be able to remove all
> +leftover pages and will return 0.  Any other return value on the second call
> +would be a symptom of a bug in either Linux or the userspace client.

Maybe also worth to mention userspace should guarantee there's no vcpu running
inside guest enclave when resetting guest's virtual EPC.

> diff --git a/arch/x86/include/uapi/asm/sgx.h b/arch/x86/include/uapi/asm/sgx.h
> index 9690d6899ad9..f79d84ce8033 100644
> --- a/arch/x86/include/uapi/asm/sgx.h
> +++ b/arch/x86/include/uapi/asm/sgx.h
> @@ -27,6 +27,8 @@ enum sgx_page_flags {
>  	_IOW(SGX_MAGIC, 0x02, struct sgx_enclave_init)
>  #define SGX_IOC_ENCLAVE_PROVISION \
>  	_IOW(SGX_MAGIC, 0x03, struct sgx_enclave_provision)
> +#define SGX_IOC_VEPC_REMOVE_ALL \
> +	_IO(SGX_MAGIC, 0x04)
>  
>  /**
>   * struct sgx_enclave_create - parameter structure for the
> diff --git a/arch/x86/kernel/cpu/sgx/virt.c b/arch/x86/kernel/cpu/sgx/virt.c
> index 59b9c13121cd..81dc186fda2e 100644
> --- a/arch/x86/kernel/cpu/sgx/virt.c
> +++ b/arch/x86/kernel/cpu/sgx/virt.c
> @@ -154,6 +154,24 @@ static int sgx_vepc_free_page(struct sgx_epc_page *epc_page)
>  	return 0;
>  }
>  
> +static long sgx_vepc_remove_all(struct sgx_vepc *vepc)
> +{
> +	struct sgx_epc_page *entry;
> +	unsigned long index;
> +	long failures = 0;
> +
> +	xa_for_each(&vepc->page_array, index, entry)
> +		if (sgx_vepc_remove_page(entry))
> +			failures++;

I think need to hold vepc->lock?

> +
> +	/*
> +	 * Return the number of pages that failed to be removed, so
> +	 * userspace knows that there are still SECS pages lying
> +	 * around.
> +	 */
> +	return failures;
> +}
> +
>  static int sgx_vepc_release(struct inode *inode, struct file *file)
>  {
>  	struct sgx_vepc *vepc = file->private_data;
> @@ -239,9 +257,27 @@ static int sgx_vepc_open(struct inode *inode, struct file *file)
>  	return 0;
>  }
>  
> +static long sgx_vepc_ioctl(struct file *file,
> +			   unsigned int cmd, unsigned long arg)
> +{
> +	struct sgx_vepc *vepc = file->private_data;
> +
> +	switch (cmd) {
> +	case SGX_IOC_VEPC_REMOVE_ALL:
> +		if (arg)
> +			return -EINVAL;
> +		return sgx_vepc_remove_all(vepc);
> +
> +	default:
> +		return -ENOTTY;
> +	}
> +}
> +
>  static const struct file_operations sgx_vepc_fops = {
>  	.owner		= THIS_MODULE,
>  	.open		= sgx_vepc_open,
> +	.unlocked_ioctl	= sgx_vepc_ioctl,
> +	.compat_ioctl	= sgx_vepc_ioctl,
>  	.release	= sgx_vepc_release,
>  	.mmap		= sgx_vepc_mmap,
>  };
> -- 
> 2.27.0
> 
