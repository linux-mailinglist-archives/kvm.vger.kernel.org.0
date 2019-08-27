Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E9AB99E760
	for <lists+kvm@lfdr.de>; Tue, 27 Aug 2019 14:10:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729166AbfH0MJh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Aug 2019 08:09:37 -0400
Received: from mx2.suse.de ([195.135.220.15]:47888 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725850AbfH0MJf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Aug 2019 08:09:35 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 9E816AF19;
        Tue, 27 Aug 2019 12:09:34 +0000 (UTC)
Date:   Tue, 27 Aug 2019 14:09:28 +0200
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
Subject: Re: [PATCH v3 05/11] KVM: SVM: Add KVM_SEV_RECEIVE_UPDATE_DATA
 command
Message-ID: <20190827120928.GC27871@zn.tnic>
References: <20190710201244.25195-1-brijesh.singh@amd.com>
 <20190710201244.25195-6-brijesh.singh@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190710201244.25195-6-brijesh.singh@amd.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jul 10, 2019 at 08:13:06PM +0000, Singh, Brijesh wrote:
> The command is used for copying the incoming buffer into the
> SEV guest memory space.

...

> +static int sev_receive_update_data(struct kvm *kvm, struct kvm_sev_cmd *argp)
> +{
> +	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
> +	struct kvm_sev_receive_update_data params;
> +	struct sev_data_receive_update_data *data;
> +	void *hdr = NULL, *trans = NULL;
> +	struct page **guest_page;
> +	unsigned long n;
> +	int ret, offset;
> +
> +	if (!sev_guest(kvm))
> +		return -EINVAL;
> +
> +	if (copy_from_user(&params, (void __user *)(uintptr_t)argp->data,
> +			sizeof(struct kvm_sev_receive_update_data)))
> +		return -EFAULT;
> +
> +	if (!params.hdr_uaddr || !params.hdr_len ||
> +	    !params.guest_uaddr || !params.guest_len ||
> +	    !params.trans_uaddr || !params.trans_len)
> +		return -EINVAL;
> +
> +	/* Check if we are crossing the page boundry */

WARNING: 'boundry' may be misspelled - perhaps 'boundary'?

> +	offset = params.guest_uaddr & (PAGE_SIZE - 1);
> +	if ((params.guest_len + offset > PAGE_SIZE))
> +		return -EINVAL;
> +
> +	data = kzalloc(sizeof(*data), GFP_KERNEL);
> +	if (!data)
> +		return -ENOMEM;
> +
> +	hdr = psp_copy_user_blob(params.hdr_uaddr, params.hdr_len);
> +	if (IS_ERR(hdr)) {
> +		ret = PTR_ERR(hdr);
> +		goto e_free;
> +	}
> +
> +	data->hdr_address = __psp_pa(hdr);
> +	data->hdr_len = params.hdr_len;
> +
> +	trans = psp_copy_user_blob(params.trans_uaddr, params.trans_len);
> +	if (IS_ERR(trans)) {
> +		ret = PTR_ERR(trans);
> +		goto e_free;
> +	}
> +
> +	data->trans_address = __psp_pa(trans);
> +	data->trans_len = params.trans_len;
> +
> +	/* Pin guest memory */
> +	ret = -EFAULT;
> +	guest_page = sev_pin_memory(kvm, params.guest_uaddr & PAGE_MASK,
> +				    PAGE_SIZE, &n, 0);
> +	if (!guest_page)
> +		goto e_free;
> +
> +	/* The RECEIVE_UPDATE_DATA command requires C-bit to be always set. */
> +	data->guest_address = (page_to_pfn(guest_page[0]) << PAGE_SHIFT) + offset;
> +	data->guest_address |= sev_me_mask;
> +	data->guest_len = params.guest_len;
> +
> +	data->handle = sev->handle;
> +	ret = sev_issue_cmd(kvm, SEV_CMD_RECEIVE_UPDATE_DATA, data, &argp->error);
> +
> +	sev_unpin_memory(kvm, guest_page, n);
> +e_free:
> +	kfree(data);
> +	kfree(hdr);
> +	kfree(trans);

Pls add separate labels so that you don't have to init function-local
vars above to NULL.

-- 
Regards/Gruss,
    Boris.

SUSE Software Solutions Germany GmbH, GF: Felix Imendörffer, HRB 247165, AG München
