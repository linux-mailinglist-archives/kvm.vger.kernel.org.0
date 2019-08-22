Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 954EE992CA
	for <lists+kvm@lfdr.de>; Thu, 22 Aug 2019 14:03:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388192AbfHVMDC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Aug 2019 08:03:02 -0400
Received: from mx2.suse.de ([195.135.220.15]:56096 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726844AbfHVMDC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Aug 2019 08:03:02 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id AFC64AE89;
        Thu, 22 Aug 2019 12:02:59 +0000 (UTC)
Date:   Thu, 22 Aug 2019 14:02:54 +0200
From:   Borislav Petkov <bp@suse.de>
To:     "Singh, Brijesh" <brijesh.singh@amd.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Joerg Roedel <joro@8bytes.org>,
        "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 02/11] KVM: SVM: Add KVM_SEND_UPDATE_DATA command
Message-ID: <20190822120254.GC11845@zn.tnic>
References: <20190710201244.25195-1-brijesh.singh@amd.com>
 <20190710201244.25195-3-brijesh.singh@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190710201244.25195-3-brijesh.singh@amd.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jul 10, 2019 at 08:13:01PM +0000, Singh, Brijesh wrote:
> The command is used for encrypting the guest memory region using the encryption
> context created with KVM_SEV_SEND_START.
> 
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: "H. Peter Anvin" <hpa@zytor.com>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: "Radim Krčmář" <rkrcmar@redhat.com>
> Cc: Joerg Roedel <joro@8bytes.org>
> Cc: Borislav Petkov <bp@suse.de>
> Cc: Tom Lendacky <thomas.lendacky@amd.com>
> Cc: x86@kernel.org
> Cc: kvm@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
> ---
>  .../virtual/kvm/amd-memory-encryption.rst     |  24 ++++
>  arch/x86/kvm/svm.c                            | 120 +++++++++++++++++-
>  include/uapi/linux/kvm.h                      |   9 ++
>  3 files changed, 149 insertions(+), 4 deletions(-)
> 
> diff --git a/Documentation/virtual/kvm/amd-memory-encryption.rst b/Documentation/virtual/kvm/amd-memory-encryption.rst
> index 0e9e1e9f9687..060ac2316d69 100644
> --- a/Documentation/virtual/kvm/amd-memory-encryption.rst
> +++ b/Documentation/virtual/kvm/amd-memory-encryption.rst
> @@ -265,6 +265,30 @@ Returns: 0 on success, -negative on error
>                  __u32 session_len;
>          };
>  
> +11. KVM_SEV_SEND_UPDATE_DATA
> +----------------------------
> +
> +The KVM_SEV_SEND_UPDATE_DATA command can be used by the hypervisor to encrypt the
> +outgoing guest memory region with the encryption context creating using

s/creating/created/

> +KVM_SEV_SEND_START.
> +
> +Parameters (in): struct kvm_sev_send_update_data
> +
> +Returns: 0 on success, -negative on error
> +
> +::
> +
> +        struct kvm_sev_launch_send_update_data {
> +                __u64 hdr_uaddr;        /* userspace address containing the packet header */
> +                __u32 hdr_len;
> +
> +                __u64 guest_uaddr;      /* the source memory region to be encrypted */
> +                __u32 guest_len;
> +
> +                __u64 trans_uaddr;      /* the destition memory region  */

s/destition/destination/

> +                __u32 trans_len;

Those addresses are all system physical addresses, according to the doc.
Why do you call them "uaddr"?

> +        };
> +
>  References
>  ==========
>  
> diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
> index 0b0937f53520..8e815a53c420 100644
> --- a/arch/x86/kvm/svm.c
> +++ b/arch/x86/kvm/svm.c
> @@ -418,6 +418,7 @@ enum {
>  
>  static unsigned int max_sev_asid;
>  static unsigned int min_sev_asid;
> +static unsigned long sev_me_mask;
>  static unsigned long *sev_asid_bitmap;
>  #define __sme_page_pa(x) __sme_set(page_to_pfn(x) << PAGE_SHIFT)
>  
> @@ -1216,16 +1217,21 @@ static int avic_ga_log_notifier(u32 ga_tag)
>  static __init int sev_hardware_setup(void)
>  {
>  	struct sev_user_data_status *status;
> +	int eax, ebx;
>  	int rc;
>  
> -	/* Maximum number of encrypted guests supported simultaneously */
> -	max_sev_asid = cpuid_ecx(0x8000001F);
> +	/*
> +	 * Query the memory encryption information.
> +	 *  EBX:  Bit 0:5 Pagetable bit position used to indicate encryption (aka Cbit).
> +	 *  ECX:  Maximum number of encrypted guests supported simultaneously.
> +	 *  EDX:  Minimum ASID value that should be used for SEV guest.
> +	 */
> +	cpuid(0x8000001f, &eax, &ebx, &max_sev_asid, &min_sev_asid);
>  
>  	if (!max_sev_asid)
>  		return 1;
>  
> -	/* Minimum ASID value that should be used for SEV guest */
> -	min_sev_asid = cpuid_edx(0x8000001F);
> +	sev_me_mask = 1UL << (ebx & 0x3f);
>  
>  	/* Initialize SEV ASID bitmap */
>  	sev_asid_bitmap = bitmap_zalloc(max_sev_asid, GFP_KERNEL);
> @@ -7059,6 +7065,109 @@ static int sev_send_start(struct kvm *kvm, struct kvm_sev_cmd *argp)
>  	return ret;
>  }
>  
> +static int sev_send_update_data(struct kvm *kvm, struct kvm_sev_cmd *argp)
> +{
> +	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
> +	struct sev_data_send_update_data *data;
> +	struct kvm_sev_send_update_data params;
> +	void *hdr = NULL, *trans_data = NULL;
> +	struct page **guest_page = NULL;

Ah, I see why you do init them to NULL - -Wmaybe-uninitialized. See below.

> +	unsigned long n;
> +	int ret, offset;
> +
> +	if (!sev_guest(kvm))
> +		return -ENOTTY;
> +
> +	if (copy_from_user(&params, (void __user *)(uintptr_t)argp->data,
> +			sizeof(struct kvm_sev_send_update_data)))
> +		return -EFAULT;
> +
> +	data = kzalloc(sizeof(*data), GFP_KERNEL);
> +	if (!data)
> +		return -ENOMEM;
> +
> +	/* userspace wants to query either header or trans length */
> +	if (!params.trans_len || !params.hdr_len)
> +		goto cmd;
> +
> +	ret = -EINVAL;
> +	if (!params.trans_uaddr || !params.guest_uaddr ||
> +	    !params.guest_len || !params.hdr_uaddr)
> +		goto e_free;
> +
> +	/* Check if we are crossing the page boundry */

WARNING: 'boundry' may be misspelled - perhaps 'boundary'?

So the fact that you have to init local variables to NULL means that gcc
doesn't see the that kfree() can take a NULL.

But also, you can restructure your labels in a way so that gcc sees them
properly and doesn't issue the warning even without having to init those
local variables.

And also, you can cleanup that function and split out the header and
trans length query functionality into a separate helper and this way
make it a lot more readable. I gave it a try here and it looks more
readable to me but this could be just me.

I could've missed some case too... pasting the whole thing for easier
review than as a diff:


---
/* Userspace wants to query either header or trans length. */
static int
__sev_send_update_data_query_lengths(struct kvm *kvm, struct kvm_sev_cmd *argp,
				     struct kvm_sev_send_update_data *params)
{
	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
	struct sev_data_send_update_data data;

	memset(&data, 0, sizeof(data));

	data.handle = sev->handle;
	sev_issue_cmd(kvm, SEV_CMD_SEND_UPDATE_DATA, &data, &argp->error);

	params->hdr_len   = data.hdr_len;
	params->trans_len = data.trans_len;

	if (copy_to_user((void __user *)(uintptr_t)argp->data, params,
			 sizeof(struct kvm_sev_send_update_data)))
		return -EFAULT;

	return 0;
}

static int sev_send_update_data(struct kvm *kvm, struct kvm_sev_cmd *argp)
{
	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
	struct sev_data_send_update_data *data;
	struct kvm_sev_send_update_data params;
	struct page **guest_page;
	void *hdr, *trans_data;
	unsigned long n;
	int ret, offset;

	if (!sev_guest(kvm))
		return -ENOTTY;

	if (copy_from_user(&params,
			   (void __user *)(uintptr_t)argp->data,
			   sizeof(struct kvm_sev_send_update_data)))
		return -EFAULT;

	/* Userspace wants to query either header or trans length */
	if (!params.trans_len || !params.hdr_len)
		return __sev_send_update_data_query_lengths(kvm, argp, &params);

	if (!params.trans_uaddr || !params.guest_uaddr ||
	    !params.guest_len || !params.hdr_uaddr)
		return -EINVAL;

	/* Check if we are crossing the page boundary: */
	offset = params.guest_uaddr & (PAGE_SIZE - 1);
	if ((params.guest_len + offset > PAGE_SIZE))
		return -EINVAL;

	hdr = kmalloc(params.hdr_len, GFP_KERNEL);
	if (!hdr)
		return -ENOMEM;

	ret = -ENOMEM;
	trans_data = kmalloc(params.trans_len, GFP_KERNEL);
	if (!trans_data)
		goto free_hdr;

	data = kzalloc(sizeof(*data), GFP_KERNEL);
        if (!data)
                goto free_trans;

	/* Pin guest memory */
	ret = -EFAULT;
	guest_page = sev_pin_memory(kvm, params.guest_uaddr & PAGE_MASK, PAGE_SIZE, &n, 0);
	if (!guest_page)
		goto free_data;

	/* The SEND_UPDATE_DATA command requires C-bit to be always set. */
	data->guest_address	= (page_to_pfn(guest_page[0]) << PAGE_SHIFT) + offset;
	data->guest_address     |= sev_me_mask;
	data->guest_len		= params.guest_len;
	data->hdr_address	= __psp_pa(hdr);
	data->hdr_len		= params.hdr_len;
	data->trans_address	= __psp_pa(trans_data);
	data->trans_len		= params.trans_len;
	data->handle		= sev->handle;

	ret = sev_issue_cmd(kvm, SEV_CMD_SEND_UPDATE_DATA, data, &argp->error);
	if (ret)
		goto unpin_memory;

	/* Copy transport buffer to user space. */
	ret = copy_to_user((void __user *)(uintptr_t)params.trans_uaddr, trans_data, params.trans_len);
	if (ret)
		goto unpin_memory;

	/* Copy packet header to userspace. */
	ret = copy_to_user((void __user *)(uintptr_t)params.hdr_uaddr, hdr, params.hdr_len);

unpin_memory:
	sev_unpin_memory(kvm, guest_page, n);

free_data:
	kfree(data);

free_trans:
	kfree(trans_data);

free_hdr:
	kfree(hdr);

	return ret;
}

-- 
Regards/Gruss,
    Boris.

SUSE Linux GmbH, GF: Felix Imendörffer, Mary Higgins, Sri Rasiah, HRB 21284 (AG Nürnberg)
