Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A9A84AF676
	for <lists+kvm@lfdr.de>; Wed,  9 Feb 2022 17:23:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236740AbiBIQWu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Feb 2022 11:22:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233355AbiBIQWt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Feb 2022 11:22:49 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 351BBC061355
        for <kvm@vger.kernel.org>; Wed,  9 Feb 2022 08:22:52 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id om7so2559086pjb.5
        for <kvm@vger.kernel.org>; Wed, 09 Feb 2022 08:22:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Vm6ihdLtxN/Yq6rrgriB6HNCQ5Tc28Tp9D4Us+d0Q3A=;
        b=b2psXUn/n2KAEtRMVJOg/NtPxnUzCuNQ3Qn4ZoNS4jxwOfkbnRkPA2fYQCRMXZIeNI
         t7kewhZ+EZQAUdw78ofcLPFdaZODoW9mx5I5RdMlOwvwmGdcb2QsKIUr+ncReiZ5GgDu
         ZB2CPk6JQx73YWjWAG00ZIEbKWp5QT0OYJQh7fvwlpwO0U6H3bhXVS+Oh/kSkW9yzhk7
         IDMeUC5QUQIYZvgSlyOcUV2GSyI2voR2vhgDDwzzZSTASrmEAD+Ol/+CITnmSN2c0F7n
         1yj39YJWm31gCg4Xyz33ybm3YH5gc/4/PK20DoL8RJuEwMwTZgk3fO/2aV3ot0v0LbXU
         JnGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Vm6ihdLtxN/Yq6rrgriB6HNCQ5Tc28Tp9D4Us+d0Q3A=;
        b=1rtYCh6Lkhz+vnPKW47W37s5xf7dsRY5pMWCbPlYHC6xn3BJx9PDOCNMpWL8jly7qf
         XPbMh3vAaGNooF62YnThiURIgd5VMWVFvzz+jnOgfgsEhXfoZg1+C+gr0/oI4ROVLIaV
         xPchQXYSJmnswlJM6KlZ86nfohZSlKSyaS7ICV4BRl2le+4+9NR85xhoty09oEOgyO5P
         ZNlyiWcGFe91MErVEtcL6levM+gr0n6iNAf3heU+NeTopmE6ULGCY/0SXJaDPoQxHKh+
         WoW4TyUdUg8nsA6uopxZNWqm129pitFado03a1aE1GbDOepAPwTAVDqz7nTwPI9bImlr
         1IAA==
X-Gm-Message-State: AOAM533kTKIS7YYkn2+GVwE6yEAzyfWsS/aJHkcfrOig9aD9DGv2P0dO
        kVqx19TnFbjqA2sOi+XXjMvJgw==
X-Google-Smtp-Source: ABdhPJxOBgPpyiVAIWoMeO0tnGVIVP4NnIgcMzIf2DOa4eeV4VfwhS3nIcoewPtD6GG+yivcAQP6JA==
X-Received: by 2002:a17:90a:8b06:: with SMTP id y6mr3430580pjn.214.1644423771458;
        Wed, 09 Feb 2022 08:22:51 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id f8sm20757624pfe.204.2022.02.09.08.22.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Feb 2022 08:22:50 -0800 (PST)
Date:   Wed, 9 Feb 2022 16:22:47 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     Maxim Levitsky <mlevitsk@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: warning in kvm_hv_invalidate_tsc_page due to writes to guest
 memory from VM ioctl context
Message-ID: <YgPqV8EZFnENj41D@google.com>
References: <190b5932de7c61905d11c92780095a2caaefec1c.camel@redhat.com>
 <87ee4d9yp3.fsf@redhat.com>
 <060ce89597cfbc85ecd300bdd5c40bb571a16993.camel@redhat.com>
 <87bkzh9wkd.fsf@redhat.com>
 <YgKjDm5OdSOKIdAo@google.com>
 <87wni48b11.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87wni48b11.fsf@redhat.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Feb 09, 2022, Vitaly Kuznetsov wrote:
> Sean Christopherson <seanjc@google.com> writes:
> 
> > On Tue, Feb 08, 2022, Vitaly Kuznetsov wrote:
> >> Maxim Levitsky <mlevitsk@redhat.com> writes:
> >> > and hv-avic only mentions AutoEOI feature.
> >> 
> >> True, this is hidden in "The enlightenment allows to use Hyper-V SynIC
> >> with hardware APICv/AVIC enabled". Any suggestions on how to improve
> >> this are more than welcome!.
> >
> > Specifically for the WARN, does this approach makes sense?
> >
> > https://lore.kernel.org/all/YcTpJ369cRBN4W93@google.com
> 
> (Sorry for missing this dicsussion back in December)
> 
> It probably does but the patch just introduces
> HV_TSC_PAGE_UPDATE_REQUIRED flag and drops kvm_write_guest() completely,
> the flag is never reset and nothing ever gets written to guest's
> memory. I suppose you've forgotten to commit a hunk :-)

I don't think so, the idea is that kvm_hv_setup_tsc_page() handles the write.

> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index c194a8cbd25f..c1adc9efea28 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -2848,7 +2848,7 @@ static void kvm_end_pvclock_update(struct kvm *kvm)
>
>  static void kvm_update_masterclock(struct kvm *kvm)
>  {
> -	kvm_hv_invalidate_tsc_page(kvm);
> +	kvm_hv_request_tsc_page_update(kvm);
>  	kvm_start_pvclock_update(kvm);
>  	pvclock_update_vm_gtod_copy(kvm);
>  	kvm_end_pvclock_update(kvm);
> @@ -3060,8 +3060,7 @@ static int kvm_guest_time_update(struct kvm_vcpu *v)
>  				       offsetof(struct compat_vcpu_info, time));
>  	if (vcpu->xen.vcpu_time_info_set)
>  		kvm_setup_pvclock_page(v, &vcpu->xen.vcpu_time_info_cache, 0);
> -	if (!v->vcpu_idx)
> -		kvm_hv_setup_tsc_page(v->kvm, &vcpu->hv_clock);
> +	kvm_hv_setup_tsc_page(v->kvm, &vcpu->hv_clock);

This change sends all vCPUs through the helper, not just vCPU 0.  Then the common
helper checks HV_TSC_PAGE_UPDATE_REQUIRED under lock.

	if (!(hv->hv_tsc_page_status & HV_TSC_PAGE_UPDATE_REQUIRED))
		goto out_unlock;


	--- error checking ---

	/* Write the struct entirely before the non-zero sequence.  */
	smp_wmb();

	hv->tsc_ref.tsc_sequence = tsc_seq;
	if (kvm_write_guest(kvm, gfn_to_gpa(gfn),
			    &hv->tsc_ref, sizeof(hv->tsc_ref.tsc_sequence)))
		goto out_err;

	hv->hv_tsc_page_status = HV_TSC_PAGE_SET;
	goto out_unlock;

out_err:
	hv->hv_tsc_page_status = HV_TSC_PAGE_BROKEN;
out_unlock:
	mutex_unlock(&hv->hv_lock);


If there are no errors, the kvm_write_guest() goes through and the status is
"reset".  If there are errors, the status is set to BROKEN.

Should I send an RFC to facilitate discussion?
