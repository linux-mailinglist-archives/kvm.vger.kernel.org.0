Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F0DB4C2F32
	for <lists+kvm@lfdr.de>; Thu, 24 Feb 2022 16:16:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235876AbiBXPPe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Feb 2022 10:15:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234165AbiBXPPd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Feb 2022 10:15:33 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6665B19F44F
        for <kvm@vger.kernel.org>; Thu, 24 Feb 2022 07:15:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645715701;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Cy7lPs8Raa8m7UjZ2Ss4NoHQLXafIaQ5zMCDtis8zls=;
        b=GqH5QYU0rF+4e0JfUlx+1y+xyXDY3whrYFq2XpebAbblhAE5JiAkZhv8dJbgzSWrNxaVPl
        VqRteNHdjM5eNgPpQ+/hhG/CbRlUO/fXwebdRSrpP3Upie3/DGK0MHdcRj5IDhS4JV637X
        bpI99OD0mpSCXlb7TB4rNa70/Df2j90=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-130-p1WSv2OiM1mYVvpecrHF2Q-1; Thu, 24 Feb 2022 10:15:00 -0500
X-MC-Unique: p1WSv2OiM1mYVvpecrHF2Q-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 22D8CFC80;
        Thu, 24 Feb 2022 15:14:59 +0000 (UTC)
Received: from starship (unknown [10.40.195.190])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DAB9A7FFF2;
        Thu, 24 Feb 2022 15:14:54 +0000 (UTC)
Message-ID: <cbc04a96e59c86a1ad77dcbdc10fabfb45066c89.camel@redhat.com>
Subject: Re: [PATCH v2 14/18] KVM: x86/mmu: avoid indirect call for get_cr3
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Date:   Thu, 24 Feb 2022 17:14:53 +0200
In-Reply-To: <YhegVBUzv+qnKATS@google.com>
References: <20220217210340.312449-1-pbonzini@redhat.com>
         <20220217210340.312449-15-pbonzini@redhat.com>
         <207674f05d63a8b1a0edd1a35f6453aa8532200e.camel@redhat.com>
         <YhegVBUzv+qnKATS@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2022-02-24 at 15:12 +0000, Sean Christopherson wrote:
> On Thu, Feb 24, 2022, Maxim Levitsky wrote:
> > Not sure though if that is worth it though. IMHO it would be better to
> > convert mmu callbacks (and nested ops callbacks, etc) to static calls.
> 
> nested_ops can utilize static_call(), mmu hooks cannot.  static_call() patches
> the code, which means there cannot be multiple targets at any given time.  The
> "static" part refers to the target not changing, generally for the lifetime of
> the kernel/module in question.  Even with TDP that doesn't hold true due to
> nested virtualization.

Ah, right, I forgot that static_call patches the call sites.

Best regards,
	Maxim Levitsky

> 
> We could selectively use INDIRECT_CALL_*() for some of the MMU calls, but given
> how few cases and targets we really care about, I prefer our homebrewed manual
> checks as theres less macro maze to navigate.
> 
> E.g. to convert the TDP fault case
> 
> diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
> index 1d0c1904d69a..940ec6a9d284 100644
> --- a/arch/x86/kvm/mmu.h
> +++ b/arch/x86/kvm/mmu.h
> @@ -3,6 +3,8 @@
>  #define __KVM_X86_MMU_H
> 
>  #include <linux/kvm_host.h>
> +#include <linux/indirect_call_wrapper.h>
> +
>  #include "kvm_cache_regs.h"
>  #include "cpuid.h"
> 
> @@ -169,7 +171,8 @@ struct kvm_page_fault {
>         bool map_writable;
>  };
> 
> -int kvm_tdp_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault);
> +INDIRECT_CALLABLE_DECLARE(int kvm_tdp_page_fault(struct kvm_vcpu *vcpu,
> +                                                struct kvm_page_fault *fault));
> 
>  extern int nx_huge_pages;
>  static inline bool is_nx_huge_page_enabled(void)
> @@ -196,11 +199,9 @@ static inline int kvm_mmu_do_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
>                 .req_level = PG_LEVEL_4K,
>                 .goal_level = PG_LEVEL_4K,
>         };
> -#ifdef CONFIG_RETPOLINE
> -       if (fault.is_tdp)
> -               return kvm_tdp_page_fault(vcpu, &fault);
> -#endif
> -       return vcpu->arch.mmu->page_fault(vcpu, &fault);
> +       struct kvm_mmu *mmu = vcpu->arch.mmu;
> +
> +       return INDIRECT_CALL_1(mmu->page_fault, kvm_tdp_page_fault, vcpu, &fault);
>  }
> 
>  /*
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index c1deaec795c2..a3ad1bc58859 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -4055,7 +4055,8 @@ int kvm_handle_page_fault(struct kvm_vcpu *vcpu, u64 error_code,
>  }
>  EXPORT_SYMBOL_GPL(kvm_handle_page_fault);
> 
> -int kvm_tdp_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
> +INDIRECT_CALLABLE_SCOPE int kvm_tdp_page_fault(struct kvm_vcpu *vcpu,
> +                                              struct kvm_page_fault *fault)
>  {
>         while (fault->max_level > PG_LEVEL_4K) {
>                 int page_num = KVM_PAGES_PER_HPAGE(fault->max_level);
> 


