Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 200C43562F3
	for <lists+kvm@lfdr.de>; Wed,  7 Apr 2021 07:18:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348622AbhDGFSa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Apr 2021 01:18:30 -0400
Received: from pegase1.c-s.fr ([93.17.236.30]:56697 "EHLO pegase1.c-s.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229603AbhDGFS3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Apr 2021 01:18:29 -0400
Received: from localhost (mailhub1-int [192.168.12.234])
        by localhost (Postfix) with ESMTP id 4FFXjP3J3lz9txtp;
        Wed,  7 Apr 2021 07:18:17 +0200 (CEST)
X-Virus-Scanned: Debian amavisd-new at c-s.fr
Received: from pegase1.c-s.fr ([192.168.12.234])
        by localhost (pegase1.c-s.fr [192.168.12.234]) (amavisd-new, port 10024)
        with ESMTP id 6vzWpDzipn1p; Wed,  7 Apr 2021 07:18:17 +0200 (CEST)
Received: from messagerie.si.c-s.fr (messagerie.si.c-s.fr [192.168.25.192])
        by pegase1.c-s.fr (Postfix) with ESMTP id 4FFXjP1Vm5z9txtn;
        Wed,  7 Apr 2021 07:18:17 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id BA7748B781;
        Wed,  7 Apr 2021 07:18:17 +0200 (CEST)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from messagerie.si.c-s.fr ([127.0.0.1])
        by localhost (messagerie.si.c-s.fr [127.0.0.1]) (amavisd-new, port 10023)
        with ESMTP id 65bLtPcC481K; Wed,  7 Apr 2021 07:18:17 +0200 (CEST)
Received: from [192.168.4.90] (unknown [192.168.4.90])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id 6557F8B75F;
        Wed,  7 Apr 2021 07:18:16 +0200 (CEST)
Subject: Re: [PATCH v2 5/8] crypto: ccp: Use the stack for small SEV command
 buffers
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        John Allen <john.allen@amd.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Borislav Petkov <bp@suse.de>
References: <20210406224952.4177376-1-seanjc@google.com>
 <20210406224952.4177376-6-seanjc@google.com>
From:   Christophe Leroy <christophe.leroy@csgroup.eu>
Message-ID: <354d67c0-addc-011a-5203-93a2071bb780@csgroup.eu>
Date:   Wed, 7 Apr 2021 07:18:13 +0200
User-Agent: Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.0
MIME-Version: 1.0
In-Reply-To: <20210406224952.4177376-6-seanjc@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: fr
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



Le 07/04/2021 à 00:49, Sean Christopherson a écrit :
> For commands with small input/output buffers, use the local stack to
> "allocate" the structures used to communicate with the PSP.   Now that
> __sev_do_cmd_locked() gracefully handles vmalloc'd buffers, there's no
> reason to avoid using the stack, e.g. CONFIG_VMAP_STACK=y will just work.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   drivers/crypto/ccp/sev-dev.c | 122 ++++++++++++++---------------------
>   1 file changed, 47 insertions(+), 75 deletions(-)
> 
> diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
> index 4aedbdaffe90..bb0d6de071e6 100644
> --- a/drivers/crypto/ccp/sev-dev.c
> +++ b/drivers/crypto/ccp/sev-dev.c
> @@ -396,7 +396,7 @@ static int sev_ioctl_do_pek_csr(struct sev_issue_cmd *argp, bool writable)
>   {
>   	struct sev_device *sev = psp_master->sev_data;
>   	struct sev_user_data_pek_csr input;
> -	struct sev_data_pek_csr *data;
> +	struct sev_data_pek_csr data;

struct sev_data_pek_csr data = {0, 0};

>   	void __user *input_address;
>   	void *blob = NULL;
>   	int ret;
> @@ -407,29 +407,24 @@ static int sev_ioctl_do_pek_csr(struct sev_issue_cmd *argp, bool writable)
>   	if (copy_from_user(&input, (void __user *)argp->data, sizeof(input)))
>   		return -EFAULT;
>   
> -	data = kzalloc(sizeof(*data), GFP_KERNEL);
> -	if (!data)
> -		return -ENOMEM;
> -
>   	/* userspace wants to query CSR length */
> -	if (!input.address || !input.length)
> +	if (!input.address || !input.length) {
> +		data.address = 0;
> +		data.len = 0;

With the change proposed above, those two new lines are unneeded.

>   		goto cmd;
> +	}
>   
>   	/* allocate a physically contiguous buffer to store the CSR blob */
>   	input_address = (void __user *)input.address;
> -	if (input.length > SEV_FW_BLOB_MAX_SIZE) {
> -		ret = -EFAULT;
> -		goto e_free;
> -	}
> +	if (input.length > SEV_FW_BLOB_MAX_SIZE)
> +		return -EFAULT;
>   
>   	blob = kmalloc(input.length, GFP_KERNEL);
> -	if (!blob) {
> -		ret = -ENOMEM;
> -		goto e_free;
> -	}
> +	if (!blob)
> +		return -ENOMEM;
>   
> -	data->address = __psp_pa(blob);
> -	data->len = input.length;
> +	data.address = __psp_pa(blob);
> +	data.len = input.length;
>   
>   cmd:
>   	if (sev->state == SEV_STATE_UNINIT) {
> @@ -438,10 +433,10 @@ static int sev_ioctl_do_pek_csr(struct sev_issue_cmd *argp, bool writable)
>   			goto e_free_blob;
>   	}
>   
> -	ret = __sev_do_cmd_locked(SEV_CMD_PEK_CSR, data, &argp->error);
> +	ret = __sev_do_cmd_locked(SEV_CMD_PEK_CSR, &data, &argp->error);
>   
>   	 /* If we query the CSR length, FW responded with expected data. */
> -	input.length = data->len;
> +	input.length = data.len;
>   
>   	if (copy_to_user((void __user *)argp->data, &input, sizeof(input))) {
>   		ret = -EFAULT;
> @@ -455,8 +450,6 @@ static int sev_ioctl_do_pek_csr(struct sev_issue_cmd *argp, bool writable)
>   
>   e_free_blob:
>   	kfree(blob);
> -e_free:
> -	kfree(data);
>   	return ret;
>   }
>   
> @@ -588,7 +581,7 @@ static int sev_ioctl_do_pek_import(struct sev_issue_cmd *argp, bool writable)
>   {
>   	struct sev_device *sev = psp_master->sev_data;
>   	struct sev_user_data_pek_cert_import input;
> -	struct sev_data_pek_cert_import *data;
> +	struct sev_data_pek_cert_import data;
>   	void *pek_blob, *oca_blob;
>   	int ret;
>   
> @@ -598,19 +591,14 @@ static int sev_ioctl_do_pek_import(struct sev_issue_cmd *argp, bool writable)
>   	if (copy_from_user(&input, (void __user *)argp->data, sizeof(input)))
>   		return -EFAULT;
>   
> -	data = kzalloc(sizeof(*data), GFP_KERNEL);
> -	if (!data)
> -		return -ENOMEM;
> -
>   	/* copy PEK certificate blobs from userspace */
>   	pek_blob = psp_copy_user_blob(input.pek_cert_address, input.pek_cert_len);
> -	if (IS_ERR(pek_blob)) {
> -		ret = PTR_ERR(pek_blob);
> -		goto e_free;
> -	}
> +	if (IS_ERR(pek_blob))
> +		return PTR_ERR(pek_blob);
>   
> -	data->pek_cert_address = __psp_pa(pek_blob);
> -	data->pek_cert_len = input.pek_cert_len;
> +	data.reserved = 0;
> +	data.pek_cert_address = __psp_pa(pek_blob);
> +	data.pek_cert_len = input.pek_cert_len;
>   
>   	/* copy PEK certificate blobs from userspace */
>   	oca_blob = psp_copy_user_blob(input.oca_cert_address, input.oca_cert_len);
> @@ -619,8 +607,8 @@ static int sev_ioctl_do_pek_import(struct sev_issue_cmd *argp, bool writable)
>   		goto e_free_pek;
>   	}
>   
> -	data->oca_cert_address = __psp_pa(oca_blob);
> -	data->oca_cert_len = input.oca_cert_len;
> +	data.oca_cert_address = __psp_pa(oca_blob);
> +	data.oca_cert_len = input.oca_cert_len;
>   
>   	/* If platform is not in INIT state then transition it to INIT */
>   	if (sev->state != SEV_STATE_INIT) {
> @@ -629,21 +617,19 @@ static int sev_ioctl_do_pek_import(struct sev_issue_cmd *argp, bool writable)
>   			goto e_free_oca;
>   	}
>   
> -	ret = __sev_do_cmd_locked(SEV_CMD_PEK_CERT_IMPORT, data, &argp->error);
> +	ret = __sev_do_cmd_locked(SEV_CMD_PEK_CERT_IMPORT, &data, &argp->error);
>   
>   e_free_oca:
>   	kfree(oca_blob);
>   e_free_pek:
>   	kfree(pek_blob);
> -e_free:
> -	kfree(data);
>   	return ret;
>   }
>   
>   static int sev_ioctl_do_get_id2(struct sev_issue_cmd *argp)
>   {
>   	struct sev_user_data_get_id2 input;
> -	struct sev_data_get_id *data;
> +	struct sev_data_get_id data;
>   	void __user *input_address;
>   	void *id_blob = NULL;
>   	int ret;
> @@ -657,28 +643,25 @@ static int sev_ioctl_do_get_id2(struct sev_issue_cmd *argp)
>   
>   	input_address = (void __user *)input.address;
>   
> -	data = kzalloc(sizeof(*data), GFP_KERNEL);
> -	if (!data)
> -		return -ENOMEM;
> -
>   	if (input.address && input.length) {
>   		id_blob = kmalloc(input.length, GFP_KERNEL);
> -		if (!id_blob) {
> -			kfree(data);
> +		if (!id_blob)
>   			return -ENOMEM;
> -		}
>   
> -		data->address = __psp_pa(id_blob);
> -		data->len = input.length;
> +		data.address = __psp_pa(id_blob);
> +		data.len = input.length;
> +	} else {
> +		data.address = 0;
> +		data.len = 0;
>   	}
>   
> -	ret = __sev_do_cmd_locked(SEV_CMD_GET_ID, data, &argp->error);
> +	ret = __sev_do_cmd_locked(SEV_CMD_GET_ID, &data, &argp->error);
>   
>   	/*
>   	 * Firmware will return the length of the ID value (either the minimum
>   	 * required length or the actual length written), return it to the user.
>   	 */
> -	input.length = data->len;
> +	input.length = data.len;
>   
>   	if (copy_to_user((void __user *)argp->data, &input, sizeof(input))) {
>   		ret = -EFAULT;
> @@ -686,7 +669,7 @@ static int sev_ioctl_do_get_id2(struct sev_issue_cmd *argp)
>   	}
>   
>   	if (id_blob) {
> -		if (copy_to_user(input_address, id_blob, data->len)) {
> +		if (copy_to_user(input_address, id_blob, data.len)) {
>   			ret = -EFAULT;
>   			goto e_free;
>   		}
> @@ -694,7 +677,6 @@ static int sev_ioctl_do_get_id2(struct sev_issue_cmd *argp)
>   
>   e_free:
>   	kfree(id_blob);
> -	kfree(data);
>   
>   	return ret;
>   }
> @@ -744,7 +726,7 @@ static int sev_ioctl_do_pdh_export(struct sev_issue_cmd *argp, bool writable)
>   	struct sev_device *sev = psp_master->sev_data;
>   	struct sev_user_data_pdh_cert_export input;
>   	void *pdh_blob = NULL, *cert_blob = NULL;
> -	struct sev_data_pdh_cert_export *data;
> +	struct sev_data_pdh_cert_export data;

struct sev_data_pdh_cert_export data = {0, 0, 0, 0, 0};

>   	void __user *input_cert_chain_address;
>   	void __user *input_pdh_cert_address;
>   	int ret;
> @@ -762,9 +744,7 @@ static int sev_ioctl_do_pdh_export(struct sev_issue_cmd *argp, bool writable)
>   	if (copy_from_user(&input, (void __user *)argp->data, sizeof(input)))
>   		return -EFAULT;
>   
> -	data = kzalloc(sizeof(*data), GFP_KERNEL);
> -	if (!data)
> -		return -ENOMEM;
> +	memset(&data, 0, sizeof(data));

You can avoid that memset by initing at declaration, see above.

>   
>   	/* Userspace wants to query the certificate length. */
>   	if (!input.pdh_cert_address ||
> @@ -776,25 +756,19 @@ static int sev_ioctl_do_pdh_export(struct sev_issue_cmd *argp, bool writable)
>   	input_cert_chain_address = (void __user *)input.cert_chain_address;
>   
>   	/* Allocate a physically contiguous buffer to store the PDH blob. */
> -	if (input.pdh_cert_len > SEV_FW_BLOB_MAX_SIZE) {
> -		ret = -EFAULT;
> -		goto e_free;
> -	}
> +	if (input.pdh_cert_len > SEV_FW_BLOB_MAX_SIZE)
> +		return -EFAULT;
>   
>   	/* Allocate a physically contiguous buffer to store the cert chain blob. */
> -	if (input.cert_chain_len > SEV_FW_BLOB_MAX_SIZE) {
> -		ret = -EFAULT;
> -		goto e_free;
> -	}
> +	if (input.cert_chain_len > SEV_FW_BLOB_MAX_SIZE)
> +		return -EFAULT;
>   
>   	pdh_blob = kmalloc(input.pdh_cert_len, GFP_KERNEL);
> -	if (!pdh_blob) {
> -		ret = -ENOMEM;
> -		goto e_free;
> -	}
> +	if (!pdh_blob)
> +		return -ENOMEM;
>   
> -	data->pdh_cert_address = __psp_pa(pdh_blob);
> -	data->pdh_cert_len = input.pdh_cert_len;
> +	data.pdh_cert_address = __psp_pa(pdh_blob);
> +	data.pdh_cert_len = input.pdh_cert_len;
>   
>   	cert_blob = kmalloc(input.cert_chain_len, GFP_KERNEL);
>   	if (!cert_blob) {
> @@ -802,15 +776,15 @@ static int sev_ioctl_do_pdh_export(struct sev_issue_cmd *argp, bool writable)
>   		goto e_free_pdh;
>   	}
>   
> -	data->cert_chain_address = __psp_pa(cert_blob);
> -	data->cert_chain_len = input.cert_chain_len;
> +	data.cert_chain_address = __psp_pa(cert_blob);
> +	data.cert_chain_len = input.cert_chain_len;
>   
>   cmd:
> -	ret = __sev_do_cmd_locked(SEV_CMD_PDH_CERT_EXPORT, data, &argp->error);
> +	ret = __sev_do_cmd_locked(SEV_CMD_PDH_CERT_EXPORT, &data, &argp->error);
>   
>   	/* If we query the length, FW responded with expected data. */
> -	input.cert_chain_len = data->cert_chain_len;
> -	input.pdh_cert_len = data->pdh_cert_len;
> +	input.cert_chain_len = data.cert_chain_len;
> +	input.pdh_cert_len = data.pdh_cert_len;
>   
>   	if (copy_to_user((void __user *)argp->data, &input, sizeof(input))) {
>   		ret = -EFAULT;
> @@ -835,8 +809,6 @@ static int sev_ioctl_do_pdh_export(struct sev_issue_cmd *argp, bool writable)
>   	kfree(cert_blob);
>   e_free_pdh:
>   	kfree(pdh_blob);
> -e_free:
> -	kfree(data);
>   	return ret;
>   }
>   
> 
