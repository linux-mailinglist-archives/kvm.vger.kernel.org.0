Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1FE0523174
	for <lists+kvm@lfdr.de>; Wed, 11 May 2022 13:25:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241567AbiEKLZU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 May 2022 07:25:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240213AbiEKLYx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 May 2022 07:24:53 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B5E67233A60
        for <kvm@vger.kernel.org>; Wed, 11 May 2022 04:24:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652268255;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qyVh4yYbgKLJScnCPfU+OUbwX6+f1OtvAPiKUvEbSzQ=;
        b=RJIL5/MEb9nFjan2jcriVBTwTgHdFx8VpATstBABc1GSzgNw6Vf4/6+QMGlcSYp8SHi96e
        rOe60fw9jS1NfQUklwyZDzICFl/VqVz4hQer2GPYcnmXAOjCOJ8lqfrqvprO84mEXR5aiJ
        hTAUY0/RTH3/5TMRf/mqdjZmVheLa2c=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-461-j_qvobNEPxyE-MEDq4p5Ww-1; Wed, 11 May 2022 07:24:09 -0400
X-MC-Unique: j_qvobNEPxyE-MEDq4p5Ww-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4A6F32949BD7;
        Wed, 11 May 2022 11:24:09 +0000 (UTC)
Received: from starship (unknown [10.40.192.26])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0947A14A5069;
        Wed, 11 May 2022 11:24:06 +0000 (UTC)
Message-ID: <01b9b22398d791126c41e517816b1cd513af7326.camel@redhat.com>
Subject: Re: [PATCH v3 08/34] KVM: x86: hyper-v: Use
 HV_MAX_SPARSE_VCPU_BANKS/HV_VCPUS_PER_SPARSE_BANK instead of raw '64'
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Siddharth Chandrasekaran <sidcha@amazon.de>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Wed, 11 May 2022 14:24:06 +0300
In-Reply-To: <20220414132013.1588929-9-vkuznets@redhat.com>
References: <20220414132013.1588929-1-vkuznets@redhat.com>
         <20220414132013.1588929-9-vkuznets@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2022-04-14 at 15:19 +0200, Vitaly Kuznetsov wrote:
> It may not be clear from where the '64' limit for the maximum sparse
> bank number comes from, use HV_MAX_SPARSE_VCPU_BANKS define instead.
> Use HV_VCPUS_PER_SPARSE_BANK in KVM_HV_MAX_SPARSE_VCPU_SET_BITS's
> definition. Opportunistically adjust the comment around BUILD_BUG_ON().
> 
> No functional change.
> 
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> ---
>  arch/x86/kvm/hyperv.c | 13 ++++++-------
>  1 file changed, 6 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
> index fc4bb0ead9fa..3cf68645a2e6 100644
> --- a/arch/x86/kvm/hyperv.c
> +++ b/arch/x86/kvm/hyperv.c
> @@ -43,7 +43,7 @@
>  /* "Hv#1" signature */
>  #define HYPERV_CPUID_SIGNATURE_EAX 0x31237648
>  
> -#define KVM_HV_MAX_SPARSE_VCPU_SET_BITS DIV_ROUND_UP(KVM_MAX_VCPUS, 64)
> +#define KVM_HV_MAX_SPARSE_VCPU_SET_BITS DIV_ROUND_UP(KVM_MAX_VCPUS, HV_VCPUS_PER_SPARSE_BANK)
>  
>  static void stimer_mark_pending(struct kvm_vcpu_hv_stimer *stimer,
>  				bool vcpu_kick);
> @@ -1798,7 +1798,7 @@ static u64 kvm_get_sparse_vp_set(struct kvm *kvm, struct kvm_hv_hcall *hc,
>  				 u64 *sparse_banks, int consumed_xmm_halves,
>  				 gpa_t offset)
>  {
> -	if (hc->var_cnt > 64)
> +	if (hc->var_cnt > HV_MAX_SPARSE_VCPU_BANKS)
>  		return -EINVAL;
>  
>  	/* Cap var_cnt to ignore banks that cannot contain a legal VP index. */
> @@ -1969,12 +1969,11 @@ static u64 kvm_hv_flush_tlb(struct kvm_vcpu *vcpu, struct kvm_hv_hcall *hc)
>  	gpa_t data_offset;
>  
>  	/*
> -	 * The Hyper-V TLFS doesn't allow more than 64 sparse banks, e.g. the
> -	 * valid mask is a u64.  Fail the build if KVM's max allowed number of
> -	 * vCPUs (>4096) would exceed this limit, KVM will additional changes
> -	 * for Hyper-V support to avoid setting the guest up to fail.
> +	 * The Hyper-V TLFS doesn't allow more than HV_MAX_SPARSE_VCPU_BANKS
> +	 * sparse banks. Fail the build if KVM's max allowed number of
> +	 * vCPUs (>4096) exceeds this limit.
>  	 */
> -	BUILD_BUG_ON(KVM_HV_MAX_SPARSE_VCPU_SET_BITS > 64);
> +	BUILD_BUG_ON(KVM_HV_MAX_SPARSE_VCPU_SET_BITS > HV_MAX_SPARSE_VCPU_BANKS);
>  
>  	if (!hc->fast && is_guest_mode(vcpu)) {
>  		hc->ingpa = translate_nested_gpa(vcpu, hc->ingpa, 0, NULL);

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky

