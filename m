Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7490523166
	for <lists+kvm@lfdr.de>; Wed, 11 May 2022 13:23:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237652AbiEKLXd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 May 2022 07:23:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237166AbiEKLXa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 May 2022 07:23:30 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id DF65822EA69
        for <kvm@vger.kernel.org>; Wed, 11 May 2022 04:23:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652268208;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zt0OS1hGFRD4C8YQzVy36UKvcvKZE0+pTjEjsVa3aIA=;
        b=E91M0lIessdMoa4DRl1YQi0swo7Dx3UNdHAHaqCIP7oC+jBke0xlfqP4rkrrNB6EzII8RZ
        BLrtHu8xZCwaNpqFUZiJfhyK7aen8XCiNJTlzeDCidMGzoJEplzdLHGqwvJe8/212qf2GX
        bVQbd9fen6G63P8yTKULsBiPfDDqK0Y=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-499-aBRYLjheOGOwuBZJVWavkA-1; Wed, 11 May 2022 07:23:22 -0400
X-MC-Unique: aBRYLjheOGOwuBZJVWavkA-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6246D80B920;
        Wed, 11 May 2022 11:23:22 +0000 (UTC)
Received: from starship (unknown [10.40.192.26])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1F6C2438BDB;
        Wed, 11 May 2022 11:23:19 +0000 (UTC)
Message-ID: <bfeb4a317e08831e03707fad96ceb65dad286163.camel@redhat.com>
Subject: Re: [PATCH v3 05/34] KVM: x86: hyper-v: Expose support for extended
 gva ranges for flush hypercalls
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Siddharth Chandrasekaran <sidcha@amazon.de>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Wed, 11 May 2022 14:23:18 +0300
In-Reply-To: <20220414132013.1588929-6-vkuznets@redhat.com>
References: <20220414132013.1588929-1-vkuznets@redhat.com>
         <20220414132013.1588929-6-vkuznets@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
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
> Extended GVA ranges support bit seems to indicate whether lower 12
> bits of GVA can be used to specify up to 4095 additional consequent
> GVAs to flush. This is somewhat described in TLFS.
> 
> Previously, KVM was handling HVCALL_FLUSH_VIRTUAL_ADDRESS_LIST{,EX}
> requests by flushing the whole VPID so technically, extended GVA
> ranges were already supported. As such requests are handled more
> gently now, advertizing support for extended ranges starts making
> sense to reduce the size of TLB flush requests.
> 
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> ---
>  arch/x86/include/asm/hyperv-tlfs.h | 2 ++
>  arch/x86/kvm/hyperv.c              | 1 +
>  2 files changed, 3 insertions(+)
> 
> diff --git a/arch/x86/include/asm/hyperv-tlfs.h b/arch/x86/include/asm/hyperv-tlfs.h
> index 0a9407dc0859..5225a85c08c3 100644
> --- a/arch/x86/include/asm/hyperv-tlfs.h
> +++ b/arch/x86/include/asm/hyperv-tlfs.h
> @@ -61,6 +61,8 @@
>  #define HV_FEATURE_GUEST_CRASH_MSR_AVAILABLE		BIT(10)
>  /* Support for debug MSRs available */
>  #define HV_FEATURE_DEBUG_MSRS_AVAILABLE			BIT(11)
> +/* Support for extended gva ranges for flush hypercalls available */
> +#define HV_FEATURE_EXT_GVA_RANGES_FLUSH			BIT(14)
>  /*
>   * Support for returning hypercall output block via XMM
>   * registers is available
> diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
> index 759e1a16e5c3..1a6f9628cee9 100644
> --- a/arch/x86/kvm/hyperv.c
> +++ b/arch/x86/kvm/hyperv.c
> @@ -2702,6 +2702,7 @@ int kvm_get_hv_cpuid(struct kvm_vcpu *vcpu, struct kvm_cpuid2 *cpuid,
>  			ent->ebx |= HV_DEBUGGING;
>  			ent->edx |= HV_X64_GUEST_DEBUGGING_AVAILABLE;
>  			ent->edx |= HV_FEATURE_DEBUG_MSRS_AVAILABLE;
> +			ent->edx |= HV_FEATURE_EXT_GVA_RANGES_FLUSH;
>  
>  			/*
>  			 * Direct Synthetic timers only make sense with in-kernel


I do think that we need to ask Microsoft to document this,
since from the spec (v6.0b) the only mention of this is 

"Bit 14: ExtendedGvaRangesForFlushVirtualAddressListAvailable"


Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky

