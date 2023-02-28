Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A7226A5FB8
	for <lists+kvm@lfdr.de>; Tue, 28 Feb 2023 20:35:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229735AbjB1TfA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Feb 2023 14:35:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229524AbjB1Te6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Feb 2023 14:34:58 -0500
Received: from mail-lj1-x22d.google.com (mail-lj1-x22d.google.com [IPv6:2a00:1450:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AE2732E73;
        Tue, 28 Feb 2023 11:34:53 -0800 (PST)
Received: by mail-lj1-x22d.google.com with SMTP id t14so11478224ljd.5;
        Tue, 28 Feb 2023 11:34:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1677612891;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:date:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9aXeLx0CrpBVP498ASsEhPYoa+pG7fk4Kq2etwACLwc=;
        b=gWc+UrExeUqz3VHtXt9HMIwGCK60nfcrWCTBO142P/WvlIWoXDgvDbVfburJGj2Kjn
         vItyPDB+85VtMfkbUt4PhuOhe/4rOk28IBRDy4CFdUKowFNzfbWWmJ7SnvgwMWIT/P7q
         uzrcuR/U4guqMfpIWUPYppT+r4YFo8iL3c0KihrD0I+wJuoDXIzJkqHOPOTucBaDmIhq
         5eXP+akV7DHPuCOfkBZFEgj33IG3BXcbHezOpBklOaroCnrlLBSJZrAUcsvBdWz3qrbm
         lXwLOKBvutWFmdbF1Hn4bSEV4nJ8gB7h59nsZDKLfgV8lhDZ9aU9duMCdNwiLdB457UL
         cDYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677612891;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9aXeLx0CrpBVP498ASsEhPYoa+pG7fk4Kq2etwACLwc=;
        b=QwoP8bUo6YDGC4NaGaHD9vXJOZZyHJp1lYuWaHCekRe+ErYy9lseCFi2Dvo0xsG/s2
         fy1Q1ptRHXYz3HXJTJ6Lv+qvstVtJO/PKMMETnMI9tyhJmqw7KH3d1vURYmpN1r75rvW
         MzuBMUnDZrFRh0j1EodMGMbTOYrn4yFccQl1WyWG4jQHNnXq/MA2BU2RUZc7MmDk6Y88
         JuUpokb08OUCZHcr2JvZfI2Ic5g/SxzHi6B0BXDa0W/4lEEr0eoTgoRCnMWUz51xOO+4
         LnoyV2Rxbd0whDW+3N/xkCSvKXTp4wB9qnA+9n1/eZatG2ndxLQsTnkSuWxgMtZTP/Lr
         C0fg==
X-Gm-Message-State: AO0yUKXinpukYOWKevIsJwp+CiwqRnMM8tYW1cHCxRb18vdg3NrT0y+P
        YlhS1Bv6Xf1Y2Bp45M/pz80=
X-Google-Smtp-Source: AK7set8Vbp7f4cOrnA0l7TQOYiydqyLYA54hGfaQCN1A8mtnuV2tm8vva+VbuLjOOGgQ+YLHXabR0A==
X-Received: by 2002:a2e:960d:0:b0:295:9d09:680d with SMTP id v13-20020a2e960d000000b002959d09680dmr1028924ljh.0.1677612891231;
        Tue, 28 Feb 2023 11:34:51 -0800 (PST)
Received: from localhost (88-115-161-74.elisa-laajakaista.fi. [88.115.161.74])
        by smtp.gmail.com with ESMTPSA id y16-20020a2e7d10000000b00295c45d5a67sm560624ljc.23.2023.02.28.11.34.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Feb 2023 11:34:50 -0800 (PST)
From:   Zhi Wang <zhi.wang.linux@gmail.com>
X-Google-Original-From: Zhi Wang <zhi.wang.linux@intel.com>
Date:   Tue, 28 Feb 2023 21:34:47 +0200
To:     Michael Roth <michael.roth@amd.com>
Cc:     <kvm@vger.kernel.org>, <linux-coco@lists.linux.dev>,
        <linux-mm@kvack.org>, <linux-crypto@vger.kernel.org>,
        <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
        <tglx@linutronix.de>, <mingo@redhat.com>, <jroedel@suse.de>,
        <thomas.lendacky@amd.com>, <hpa@zytor.com>, <ardb@kernel.org>,
        <pbonzini@redhat.com>, <seanjc@google.com>, <vkuznets@redhat.com>,
        <jmattson@google.com>, <luto@kernel.org>,
        <dave.hansen@linux.intel.com>, <slp@redhat.com>,
        <pgonda@google.com>, <peterz@infradead.org>,
        <srinivas.pandruvada@linux.intel.com>, <rientjes@google.com>,
        <dovmurik@linux.ibm.com>, <tobin@ibm.com>, <bp@alien8.de>,
        <vbabka@suse.cz>, <kirill@shutemov.name>, <ak@linux.intel.com>,
        <tony.luck@intel.com>, <marcorr@google.com>,
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        <alpergun@google.com>, <dgilbert@redhat.com>, <jarkko@kernel.org>,
        <ashish.kalra@amd.com>, <nikunj.dadhania@amd.com>,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: Re: [PATCH RFC v8 45/56] KVM: SVM: Provide support for
 SNP_GUEST_REQUEST NAE event
Message-ID: <20230228213447.00006279@intel.com>
In-Reply-To: <20230220183847.59159-46-michael.roth@amd.com>
References: <20230220183847.59159-1-michael.roth@amd.com>
        <20230220183847.59159-46-michael.roth@amd.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 20 Feb 2023 12:38:36 -0600
Michael Roth <michael.roth@amd.com> wrote:

> From: Brijesh Singh <brijesh.singh@amd.com>
> 
> Version 2 of GHCB specification added the support for two SNP Guest
> Request Message NAE events. The events allows for an SEV-SNP guest to
> make request to the SEV-SNP firmware through hypervisor using the
> SNP_GUEST_REQUEST API define in the SEV-SNP firmware specification.
> 
> The SNP_EXT_GUEST_REQUEST is similar to SNP_GUEST_REQUEST with the
> difference of an additional certificate blob that can be passed through
> the SNP_SET_CONFIG ioctl defined in the CCP driver. The CCP driver
> provides snp_guest_ext_guest_request() that is used by the KVM to get
> both the report and certificate data at once.
> 
> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
> Signed-off-by: Michael Roth <michael.roth@amd.com>
> ---
>  arch/x86/kvm/svm/sev.c | 185 +++++++++++++++++++++++++++++++++++++++--
>  arch/x86/kvm/svm/svm.h |   2 +
>  2 files changed, 181 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 197b1f904567..92179614102e 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -327,6 +327,7 @@ static int sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp)
>  		if (ret)
>  			goto e_free;
>  
> +		mutex_init(&sev->guest_req_lock);
>  		ret = sev_snp_init(&argp->error, false);
>  	} else {
>  		ret = sev_platform_init(&argp->error);
> @@ -2059,23 +2060,34 @@ int sev_vm_move_enc_context_from(struct kvm *kvm, unsigned int source_fd)
>   */
>  static void *snp_context_create(struct kvm *kvm, struct kvm_sev_cmd *argp)
>  {
> +	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
>  	struct sev_data_snp_addr data = {};
> -	void *context;
> +	void *context, *certs_data;
>  	int rc;
>  
> +	/* Allocate memory used for the certs data in SNP guest request */
> +	certs_data = kzalloc(SEV_FW_BLOB_MAX_SIZE, GFP_KERNEL_ACCOUNT);
> +	if (!certs_data)
> +		return NULL;
> +
>  	/* Allocate memory for context page */
>  	context = snp_alloc_firmware_page(GFP_KERNEL_ACCOUNT);
>  	if (!context)
> -		return NULL;
> +		goto e_free;
>  
>  	data.gctx_paddr = __psp_pa(context);
>  	rc = __sev_issue_cmd(argp->sev_fd, SEV_CMD_SNP_GCTX_CREATE, &data, &argp->error);
> -	if (rc) {
> -		snp_free_firmware_page(context);
> -		return NULL;
> -	}
> +	if (rc)
> +		goto e_free;
> +
> +	sev->snp_certs_data = certs_data;
>  
>  	return context;
> +
> +e_free:
> +	snp_free_firmware_page(context);
> +	kfree(certs_data);
> +	return NULL;
>  }
>  
>  static int snp_bind_asid(struct kvm *kvm, int *error)
> @@ -2693,6 +2705,8 @@ static int snp_decommission_context(struct kvm *kvm)
>  	snp_free_firmware_page(sev->snp_context);
>  	sev->snp_context = NULL;
>  
> +	kfree(sev->snp_certs_data);
> +
>  	return 0;
>  }
>  
> @@ -3153,6 +3167,8 @@ static int sev_es_validate_vmgexit(struct vcpu_svm *svm)
>  	case SVM_VMGEXIT_UNSUPPORTED_EVENT:
>  	case SVM_VMGEXIT_HV_FEATURES:
>  	case SVM_VMGEXIT_PSC:
> +	case SVM_VMGEXIT_GUEST_REQUEST:
> +	case SVM_VMGEXIT_EXT_GUEST_REQUEST:
>  		break;
>  	default:
>  		reason = GHCB_ERR_INVALID_EVENT;
> @@ -3384,6 +3400,149 @@ static int snp_complete_psc(struct kvm_vcpu *vcpu)
>  	return 1;
>  }
>  
> +static unsigned long snp_setup_guest_buf(struct vcpu_svm *svm,
> +					 struct sev_data_snp_guest_request *data,
> +					 gpa_t req_gpa, gpa_t resp_gpa)
> +{
> +	struct kvm_vcpu *vcpu = &svm->vcpu;
> +	struct kvm *kvm = vcpu->kvm;
> +	kvm_pfn_t req_pfn, resp_pfn;
> +	struct kvm_sev_info *sev;
> +
> +	sev = &to_kvm_svm(kvm)->sev_info;
> +
> +	if (!IS_ALIGNED(req_gpa, PAGE_SIZE) || !IS_ALIGNED(resp_gpa, PAGE_SIZE))
> +		return SEV_RET_INVALID_PARAM;
> +
> +	req_pfn = gfn_to_pfn(kvm, gpa_to_gfn(req_gpa));
> +	if (is_error_noslot_pfn(req_pfn))
> +		return SEV_RET_INVALID_ADDRESS;
> +
> +	resp_pfn = gfn_to_pfn(kvm, gpa_to_gfn(resp_gpa));
> +	if (is_error_noslot_pfn(resp_pfn))
> +		return SEV_RET_INVALID_ADDRESS;
> +
> +	if (rmp_make_private(resp_pfn, 0, PG_LEVEL_4K, 0, true))
> +		return SEV_RET_INVALID_ADDRESS;
> +
> +	data->gctx_paddr = __psp_pa(sev->snp_context);
> +	data->req_paddr = __sme_set(req_pfn << PAGE_SHIFT);
> +	data->res_paddr = __sme_set(resp_pfn << PAGE_SHIFT);
> +
> +	return 0;
> +}
> +
> +static void snp_cleanup_guest_buf(struct sev_data_snp_guest_request *data, unsigned long *rc)
> +{
> +	u64 pfn = __sme_clr(data->res_paddr) >> PAGE_SHIFT;
> +	int ret;
> +
> +	ret = snp_page_reclaim(pfn);
> +	if (ret)
> +		*rc = SEV_RET_INVALID_ADDRESS;
> +
> +	ret = rmp_make_shared(pfn, PG_LEVEL_4K);
> +	if (ret)
> +		*rc = SEV_RET_INVALID_ADDRESS;
> +}
> +
> +static void snp_handle_guest_request(struct vcpu_svm *svm, gpa_t req_gpa, gpa_t resp_gpa)
> +{
> +	struct sev_data_snp_guest_request data = {0};
> +	struct kvm_vcpu *vcpu = &svm->vcpu;
> +	struct kvm *kvm = vcpu->kvm;
> +	struct kvm_sev_info *sev;
> +	unsigned long rc;
> +	int err;
> +
> +	if (!sev_snp_guest(vcpu->kvm)) {
> +		rc = SEV_RET_INVALID_GUEST;
> +		goto e_fail;
> +	}
> +
> +	sev = &to_kvm_svm(kvm)->sev_info;
> +
> +	mutex_lock(&sev->guest_req_lock);
> +
> +	rc = snp_setup_guest_buf(svm, &data, req_gpa, resp_gpa);
> +	if (rc)
> +		goto unlock;
> +
> +	rc = sev_issue_cmd(kvm, SEV_CMD_SNP_GUEST_REQUEST, &data, &err);
> +	if (rc)
> +		/* use the firmware error code */
> +		rc = err;
> +
> +	snp_cleanup_guest_buf(&data, &rc);
> +

I am curious about the reason of having a shared-private and private-shared
conversion before and after issuing the command to firmware.

Is it because the firmware requires the resp page has to be a private page?
while the req page is not. (I understand that the req/resp page should be
shared before returnning to guest due to GHCB spec)

> +unlock:
> +	mutex_unlock(&sev->guest_req_lock);
> +
> +e_fail:
> +	ghcb_set_sw_exit_info_2(svm->sev_es.ghcb, rc);
> +}
> +
> +static void snp_handle_ext_guest_request(struct vcpu_svm *svm, gpa_t req_gpa, gpa_t resp_gpa)
> +{
> +	struct sev_data_snp_guest_request req = {0};
> +	struct kvm_vcpu *vcpu = &svm->vcpu;
> +	struct kvm *kvm = vcpu->kvm;
> +	unsigned long data_npages;
> +	struct kvm_sev_info *sev;
> +	unsigned long rc, err;
> +	u64 data_gpa;
> +
> +	if (!sev_snp_guest(vcpu->kvm)) {
> +		rc = SEV_RET_INVALID_GUEST;
> +		goto e_fail;
> +	}
> +
> +	sev = &to_kvm_svm(kvm)->sev_info;
> +
> +	data_gpa = vcpu->arch.regs[VCPU_REGS_RAX];
> +	data_npages = vcpu->arch.regs[VCPU_REGS_RBX];
> +
> +	if (!IS_ALIGNED(data_gpa, PAGE_SIZE)) {
> +		rc = SEV_RET_INVALID_ADDRESS;
> +		goto e_fail;
> +	}
> +
> +	mutex_lock(&sev->guest_req_lock);
> +
> +	rc = snp_setup_guest_buf(svm, &req, req_gpa, resp_gpa);
> +	if (rc)
> +		goto unlock;
> +
> +	rc = snp_guest_ext_guest_request(&req, (unsigned long)sev->snp_certs_data,
> +					 &data_npages, &err);
> +	if (rc) {
> +		/*
> +		 * If buffer length is small then return the expected
> +		 * length in rbx.
> +		 */
> +		if (err == SNP_GUEST_REQ_INVALID_LEN)
> +			vcpu->arch.regs[VCPU_REGS_RBX] = data_npages;
> +
> +		/* pass the firmware error code */
> +		rc = err;
> +		goto cleanup;
> +	}
> +
> +	/* Copy the certificate blob in the guest memory */
> +	if (data_npages &&
> +	    kvm_write_guest(kvm, data_gpa, sev->snp_certs_data, data_npages << PAGE_SHIFT))
> +		rc = SEV_RET_INVALID_ADDRESS;
> +
> +cleanup:
> +	snp_cleanup_guest_buf(&req, &rc);
> +
> +unlock:
> +	mutex_unlock(&sev->guest_req_lock);
> +
> +e_fail:
> +	ghcb_set_sw_exit_info_2(svm->sev_es.ghcb, rc);
> +}
> +
>  static int sev_handle_vmgexit_msr_protocol(struct vcpu_svm *svm)
>  {
>  	struct vmcb_control_area *control = &svm->vmcb->control;
> @@ -3633,6 +3792,20 @@ int sev_handle_vmgexit(struct kvm_vcpu *vcpu)
>  		vcpu->run->vmgexit.ghcb_msr = ghcb_gpa;
>  		vcpu->arch.complete_userspace_io = snp_complete_psc;
>  		break;
> +	case SVM_VMGEXIT_GUEST_REQUEST: {
> +		snp_handle_guest_request(svm, control->exit_info_1, control->exit_info_2);
> +
> +		ret = 1;
> +		break;
> +	}
> +	case SVM_VMGEXIT_EXT_GUEST_REQUEST: {
> +		snp_handle_ext_guest_request(svm,
> +					     control->exit_info_1,
> +					     control->exit_info_2);
> +
> +		ret = 1;
> +		break;
> +	}
>  	case SVM_VMGEXIT_UNSUPPORTED_EVENT:
>  		vcpu_unimpl(vcpu,
>  			    "vmgexit: unsupported event - exit_info_1=%#llx, exit_info_2=%#llx\n",
> diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> index 13b00233b315..4a9ffb7e5139 100644
> --- a/arch/x86/kvm/svm/svm.h
> +++ b/arch/x86/kvm/svm/svm.h
> @@ -93,6 +93,8 @@ struct kvm_sev_info {
>  	atomic_t migration_in_progress;
>  	u64 snp_init_flags;
>  	void *snp_context;      /* SNP guest context page */
> +	void *snp_certs_data;
> +	struct mutex guest_req_lock; /* Lock for guest request handling */
>  };
>  
>  struct kvm_svm {

