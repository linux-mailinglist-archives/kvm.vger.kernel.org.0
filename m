Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2AE42B02F4
	for <lists+kvm@lfdr.de>; Thu, 12 Nov 2020 11:41:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727913AbgKLKlp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Nov 2020 05:41:45 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:54247 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727819AbgKLKlp (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 12 Nov 2020 05:41:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605177703;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=vKVFV4JnJGFcIAEtfnBGX30mXa0QZSGIDA3Q1iebpuY=;
        b=bbbLtVk+cm0UoluockYPyXOEzzVX6eCuv9U63f3oVylpOenqQdA+BTLMZFHeFCSe/92+GH
        TwPcOd2tsv7sHknL94Xnr72W/pVxjVyfy1abT332tKCQazcPRPBQKSNkSuQ2aDM6lOZpfs
        h3yzuu1vlevvd3ezMtDLByrBehPQI5s=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-291-RGEacXpmO0GZOsE-f1HnJA-1; Thu, 12 Nov 2020 05:41:41 -0500
X-MC-Unique: RGEacXpmO0GZOsE-f1HnJA-1
Received: by mail-wm1-f72.google.com with SMTP id o19so1992494wme.2
        for <kvm@vger.kernel.org>; Thu, 12 Nov 2020 02:41:41 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=vKVFV4JnJGFcIAEtfnBGX30mXa0QZSGIDA3Q1iebpuY=;
        b=rIVH/bYTFVBsuNl3rWHNx4bvKc6q7DMxWM1mGsXdkutT1KoYJrhxYYm5WHRCoprkhQ
         xsTwP1xV6pU7o+gnbwgukxxBeGkVkLabhx7AeCk6XtixzKjSfc7uIKStqZC/aIgsoYNr
         3+62UNMqCORx1Qyopf8kL2J5fexRGPfnUtkmuzlbKpVky+C4ypR3tyUuZswQiDWOpp1B
         qshCYAiXuECmsnE1mhzW2CZOPVjvStSPIqWoycoC39KVPkKRlhDsEEAZlvJbpvAtQ0q3
         PD3KRd2GGZhQBue9ECf/24jikTDF6SWZpr/nBYGFdUr6D4rokh7Qx635ofKL1DU/xmmS
         SmHg==
X-Gm-Message-State: AOAM533BzscDLbqAEJ0FZR6mOdjfXFGodtkw4cTk8Kj04emIvFE01vox
        mAH7kemPEjSJ0VjuxgStmkD/vkN9zOI2jPvIF5APWhL4tcyf6JvnIoKoYhKLHwYZ9G6AsAgiEkR
        iLxgVmKvJKmXv
X-Received: by 2002:a1c:dd41:: with SMTP id u62mr8664712wmg.78.1605177700594;
        Thu, 12 Nov 2020 02:41:40 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzZP6QFIrs8ryaUIUML/lihjMm6eZxcOzZSaftRTQDT0u1LUG9lhTJwYPHvNS1dEuPxfqybog==
X-Received: by 2002:a1c:dd41:: with SMTP id u62mr8664702wmg.78.1605177700427;
        Thu, 12 Nov 2020 02:41:40 -0800 (PST)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id s9sm7105814wrf.90.2020.11.12.02.41.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Nov 2020 02:41:39 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 04/11] KVM: VMX: Fold Hyper-V EPTP checking into it's
 only caller
In-Reply-To: <20201027212346.23409-5-sean.j.christopherson@intel.com>
References: <20201027212346.23409-1-sean.j.christopherson@intel.com>
 <20201027212346.23409-5-sean.j.christopherson@intel.com>
Date:   Thu, 12 Nov 2020 11:41:38 +0100
Message-ID: <87blg2zwkd.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <sean.j.christopherson@intel.com> writes:

> Fold check_ept_pointer_match() into hv_remote_flush_tlb_with_range() in
> preparation for combining the kvm_for_each_vcpu loops of the ==CHECK and
> !=MATCH statements.
>
> No functional change intended.
>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>  arch/x86/kvm/vmx/vmx.c | 44 +++++++++++++++++++-----------------------
>  1 file changed, 20 insertions(+), 24 deletions(-)
>
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index a6442a861ffc..f5e9e2f61e10 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -472,28 +472,6 @@ static const u32 vmx_uret_msrs_list[] = {
>  static bool __read_mostly enlightened_vmcs = true;
>  module_param(enlightened_vmcs, bool, 0444);
>  
> -/* check_ept_pointer() should be under protection of ept_pointer_lock. */
> -static void check_ept_pointer_match(struct kvm *kvm)
> -{
> -	struct kvm_vcpu *vcpu;
> -	u64 tmp_eptp = INVALID_PAGE;
> -	int i;
> -
> -	kvm_for_each_vcpu(i, vcpu, kvm) {
> -		if (!VALID_PAGE(tmp_eptp)) {
> -			tmp_eptp = to_vmx(vcpu)->ept_pointer;
> -		} else if (tmp_eptp != to_vmx(vcpu)->ept_pointer) {
> -			to_kvm_vmx(kvm)->hv_tlb_eptp = INVALID_PAGE;
> -			to_kvm_vmx(kvm)->ept_pointers_match
> -				= EPT_POINTERS_MISMATCH;
> -			return;
> -		}
> -	}
> -
> -	to_kvm_vmx(kvm)->hv_tlb_eptp = tmp_eptp;
> -	to_kvm_vmx(kvm)->ept_pointers_match = EPT_POINTERS_MATCH;
> -}
> -
>  static int kvm_fill_hv_flush_list_func(struct hv_guest_mapping_flush_list *flush,
>  		void *data)
>  {
> @@ -523,11 +501,29 @@ static int hv_remote_flush_tlb_with_range(struct kvm *kvm,
>  	struct kvm_vmx *kvm_vmx = to_kvm_vmx(kvm);
>  	struct kvm_vcpu *vcpu;
>  	int ret = 0, i;
> +	u64 tmp_eptp;
>  
>  	spin_lock(&kvm_vmx->ept_pointer_lock);
>  
> -	if (kvm_vmx->ept_pointers_match == EPT_POINTERS_CHECK)
> -		check_ept_pointer_match(kvm);
> +	if (kvm_vmx->ept_pointers_match == EPT_POINTERS_CHECK) {
> +		kvm_vmx->ept_pointers_match = EPT_POINTERS_MATCH;
> +		kvm_vmx->hv_tlb_eptp = INVALID_PAGE;
> +
> +		kvm_for_each_vcpu(i, vcpu, kvm) {
> +			tmp_eptp = to_vmx(vcpu)->ept_pointer;
> +			if (!VALID_PAGE(tmp_eptp))
> +				continue;
> +
> +			if (!VALID_PAGE(kvm_vmx->hv_tlb_eptp)) {
> +				kvm_vmx->hv_tlb_eptp = tmp_eptp;
> +			} else if (kvm_vmx->hv_tlb_eptp != tmp_eptp) {
> +				kvm_vmx->hv_tlb_eptp = INVALID_PAGE;
> +				kvm_vmx->ept_pointers_match
> +					= EPT_POINTERS_MISMATCH;
> +				break;
> +			}
> +		}
> +	}
>  
>  	if (kvm_vmx->ept_pointers_match != EPT_POINTERS_MATCH) {
>  		kvm_for_each_vcpu(i, vcpu, kvm) {

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

-- 
Vitaly

