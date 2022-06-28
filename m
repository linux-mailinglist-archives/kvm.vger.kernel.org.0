Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B11655E489
	for <lists+kvm@lfdr.de>; Tue, 28 Jun 2022 15:39:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346439AbiF1NaJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Jun 2022 09:30:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346479AbiF1N3P (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Jun 2022 09:29:15 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C2AFD2182E
        for <kvm@vger.kernel.org>; Tue, 28 Jun 2022 06:28:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1656422898;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=PH7wMQRYi1ZWFVxyL/3d+sZ7rcf181kH7ObPj88vxe0=;
        b=TCjYsq9XEdoy0jbmQXqcg2qcWB13azoELplc8JkC1XvnSHTnfhJRBpfavpM1tYh48xmR/Q
        CIPK/tgpSd3BU0vCJ+UOHUfGOdyMLYlLNBsDcIHCpqHxYpThXR4LxX+m4dw+ozZW0gtP0j
        WK4lYd4EgaQLkEg3Le00JgezpVx8Goc=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-304-EcWJGqfhMOyzA9mDqlu7zQ-1; Tue, 28 Jun 2022 09:28:17 -0400
X-MC-Unique: EcWJGqfhMOyzA9mDqlu7zQ-1
Received: by mail-wm1-f72.google.com with SMTP id p6-20020a05600c358600b003a0483b3c2eso3741727wmq.3
        for <kvm@vger.kernel.org>; Tue, 28 Jun 2022 06:28:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=PH7wMQRYi1ZWFVxyL/3d+sZ7rcf181kH7ObPj88vxe0=;
        b=GwcLI2NnpTWpyZtRfnHy4v2cPVHQMIGnR8dtgv2aGD8KHxCdAi5/y+83aKnxUiVQdc
         SunUWHp6tca47jMyJrxffNQQQPIEfINp/n9GQ+IUlaqOIDjEw5R4ok/aBXghdKYy/X1x
         AZxge/Hzlvv7hbS9Jw8ISjHpgohsmtuEi1rPjlJVc9lpBJVhBaDH/Ttov2wq9wjJlYM+
         cS7lpSEY7WdjkNo3D9NzV9J6CJ9oRmJdnro7I4BYL53CST13apvHh+nbMPlBnzo1Jtwv
         Jwip/rkIq6eIqVtX6SWuflXtL3Ah7k9zi9wk8G+xQFMkZysfo788X4R/3UTyB4GDqSzk
         WXLQ==
X-Gm-Message-State: AJIora+Gt2DOgFO1aQTv4SDm8YpkrizhkEAxT/DdiBDo//nlosP8LwOb
        I7NTu+3e9Et56ncvcVxGZPD61OxGs8Fod79ezdHM6JyduKqCzGJKDnrsa7eEHJupnmdPurcnK7C
        wTbOuyupcyxyV
X-Received: by 2002:a5d:5047:0:b0:21b:92b2:f34f with SMTP id h7-20020a5d5047000000b0021b92b2f34fmr17127821wrt.677.1656422896238;
        Tue, 28 Jun 2022 06:28:16 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1tqVf5A7KSxbTw31AFhCSUb6QIduyx0h8n4yb62+NQ1QBxlS5VZpJjh7TfSMSbhzJ+0xSz+Vw==
X-Received: by 2002:a5d:5047:0:b0:21b:92b2:f34f with SMTP id h7-20020a5d5047000000b0021b92b2f34fmr17127781wrt.677.1656422895955;
        Tue, 28 Jun 2022 06:28:15 -0700 (PDT)
Received: from work-vm (cpc109025-salf6-2-0-cust480.10-2.cable.virginm.net. [82.30.61.225])
        by smtp.gmail.com with ESMTPSA id w9-20020a5d6089000000b0020e5b4ebaecsm13771290wrt.4.2022.06.28.06.28.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jun 2022 06:28:15 -0700 (PDT)
Date:   Tue, 28 Jun 2022 14:28:12 +0100
From:   "Dr. David Alan Gilbert" <dgilbert@redhat.com>
To:     Ashish Kalra <Ashish.Kalra@amd.com>
Cc:     x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-coco@lists.linux.dev, linux-mm@kvack.org,
        linux-crypto@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        jroedel@suse.de, thomas.lendacky@amd.com, hpa@zytor.com,
        ardb@kernel.org, pbonzini@redhat.com, seanjc@google.com,
        vkuznets@redhat.com, jmattson@google.com, luto@kernel.org,
        dave.hansen@linux.intel.com, slp@redhat.com, pgonda@google.com,
        peterz@infradead.org, srinivas.pandruvada@linux.intel.com,
        rientjes@google.com, dovmurik@linux.ibm.com, tobin@ibm.com,
        bp@alien8.de, michael.roth@amd.com, vbabka@suse.cz,
        kirill@shutemov.name, ak@linux.intel.com, tony.luck@intel.com,
        marcorr@google.com, sathyanarayanan.kuppuswamy@linux.intel.com,
        alpergun@google.com, jarkko@kernel.org
Subject: Re: [PATCH Part2 v6 36/49] KVM: SVM: Add support to handle GHCB GPA
 register VMGEXIT
Message-ID: <YrsB7G4NSgJ+vKVw@work-vm>
References: <cover.1655761627.git.ashish.kalra@amd.com>
 <c2c4d365b4616c83ab2fb91b7c89d13535de8c0a.1655761627.git.ashish.kalra@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c2c4d365b4616c83ab2fb91b7c89d13535de8c0a.1655761627.git.ashish.kalra@amd.com>
User-Agent: Mutt/2.2.6 (2022-06-05)
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

* Ashish Kalra (Ashish.Kalra@amd.com) wrote:
> From: Brijesh Singh <brijesh.singh@amd.com>
> 
> SEV-SNP guests are required to perform a GHCB GPA registration. Before
> using a GHCB GPA for a vCPU the first time, a guest must register the
> vCPU GHCB GPA. If hypervisor can work with the guest requested GPA then
> it must respond back with the same GPA otherwise return -1.
> 
> On VMEXIT, Verify that GHCB GPA matches with the registered value. If a
> mismatch is detected then abort the guest.
> 
> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
> ---
>  arch/x86/include/asm/sev-common.h |  8 ++++++++
>  arch/x86/kvm/svm/sev.c            | 27 +++++++++++++++++++++++++++
>  arch/x86/kvm/svm/svm.h            |  7 +++++++
>  3 files changed, 42 insertions(+)
> 
> diff --git a/arch/x86/include/asm/sev-common.h b/arch/x86/include/asm/sev-common.h
> index 539de6b93420..0a9055cdfae2 100644
> --- a/arch/x86/include/asm/sev-common.h
> +++ b/arch/x86/include/asm/sev-common.h
> @@ -59,6 +59,14 @@
>  #define GHCB_MSR_AP_RESET_HOLD_RESULT_POS	12
>  #define GHCB_MSR_AP_RESET_HOLD_RESULT_MASK	GENMASK_ULL(51, 0)
>  
> +/* Preferred GHCB GPA Request */
> +#define GHCB_MSR_PREF_GPA_REQ		0x010
> +#define GHCB_MSR_GPA_VALUE_POS		12
> +#define GHCB_MSR_GPA_VALUE_MASK		GENMASK_ULL(51, 0)

Are the magic 51's in here fixed ?

Dave

> +#define GHCB_MSR_PREF_GPA_RESP		0x011
> +#define GHCB_MSR_PREF_GPA_NONE		0xfffffffffffff
> +
>  /* GHCB GPA Register */
>  #define GHCB_MSR_REG_GPA_REQ		0x012
>  #define GHCB_MSR_REG_GPA_REQ_VAL(v)			\
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index c70f3f7e06a8..6de48130e414 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -3331,6 +3331,27 @@ static int sev_handle_vmgexit_msr_protocol(struct vcpu_svm *svm)
>  				  GHCB_MSR_INFO_MASK, GHCB_MSR_INFO_POS);
>  		break;
>  	}
> +	case GHCB_MSR_PREF_GPA_REQ: {
> +		set_ghcb_msr_bits(svm, GHCB_MSR_PREF_GPA_NONE, GHCB_MSR_GPA_VALUE_MASK,
> +				  GHCB_MSR_GPA_VALUE_POS);
> +		set_ghcb_msr_bits(svm, GHCB_MSR_PREF_GPA_RESP, GHCB_MSR_INFO_MASK,
> +				  GHCB_MSR_INFO_POS);
> +		break;
> +	}
> +	case GHCB_MSR_REG_GPA_REQ: {
> +		u64 gfn;
> +
> +		gfn = get_ghcb_msr_bits(svm, GHCB_MSR_GPA_VALUE_MASK,
> +					GHCB_MSR_GPA_VALUE_POS);
> +
> +		svm->sev_es.ghcb_registered_gpa = gfn_to_gpa(gfn);
> +
> +		set_ghcb_msr_bits(svm, gfn, GHCB_MSR_GPA_VALUE_MASK,
> +				  GHCB_MSR_GPA_VALUE_POS);
> +		set_ghcb_msr_bits(svm, GHCB_MSR_REG_GPA_RESP, GHCB_MSR_INFO_MASK,
> +				  GHCB_MSR_INFO_POS);
> +		break;
> +	}
>  	case GHCB_MSR_TERM_REQ: {
>  		u64 reason_set, reason_code;
>  
> @@ -3381,6 +3402,12 @@ int sev_handle_vmgexit(struct kvm_vcpu *vcpu)
>  		return 1;
>  	}
>  
> +	/* SEV-SNP guest requires that the GHCB GPA must be registered */
> +	if (sev_snp_guest(svm->vcpu.kvm) && !ghcb_gpa_is_registered(svm, ghcb_gpa)) {
> +		vcpu_unimpl(&svm->vcpu, "vmgexit: GHCB GPA [%#llx] is not registered.\n", ghcb_gpa);
> +		return -EINVAL;
> +	}
> +
>  	ret = sev_es_validate_vmgexit(svm, &exit_code);
>  	if (ret)
>  		return ret;
> diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> index c80352c9c0d6..54ff56cb6125 100644
> --- a/arch/x86/kvm/svm/svm.h
> +++ b/arch/x86/kvm/svm/svm.h
> @@ -206,6 +206,8 @@ struct vcpu_sev_es_state {
>  	 */
>  	u64 ghcb_sw_exit_info_1;
>  	u64 ghcb_sw_exit_info_2;
> +
> +	u64 ghcb_registered_gpa;
>  };
>  
>  struct vcpu_svm {
> @@ -334,6 +336,11 @@ static inline bool sev_snp_guest(struct kvm *kvm)
>  	return sev_es_guest(kvm) && sev->snp_active;
>  }
>  
> +static inline bool ghcb_gpa_is_registered(struct vcpu_svm *svm, u64 val)
> +{
> +	return svm->sev_es.ghcb_registered_gpa == val;
> +}
> +
>  static inline void vmcb_mark_all_dirty(struct vmcb *vmcb)
>  {
>  	vmcb->control.clean = 0;
> -- 
> 2.25.1
> 
-- 
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

