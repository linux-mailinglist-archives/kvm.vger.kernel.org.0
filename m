Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1AE0437A2F
	for <lists+kvm@lfdr.de>; Fri, 22 Oct 2021 17:39:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233206AbhJVPlz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Oct 2021 11:41:55 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:43956 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232339AbhJVPly (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 22 Oct 2021 11:41:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634917176;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SKwUK85QUS5UvGDvhSdm0UayuQZWDZ03hElSfZLYkFI=;
        b=EqVuw+6L8B7qbuXr7Imhc1mHzPagQXMt+PPGo0bdgVBPnkAfLex2E4OLhb8jmt62CWLm0k
        KdL8axtaajzvIHa2BhpD77wBj0LiCifPZkPqzA5dX4U3odUTY5dhPxxGvKoRzGb2cb0oXD
        yuNLvyStMD+K/ng0GuteCEO2KEVVHUY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-459-Ueq-nJDMO02g3l7HjQastQ-1; Fri, 22 Oct 2021 11:39:35 -0400
X-MC-Unique: Ueq-nJDMO02g3l7HjQastQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DAB81806688;
        Fri, 22 Oct 2021 15:39:33 +0000 (UTC)
Received: from starship (unknown [10.40.192.246])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DF7AA10016F2;
        Fri, 22 Oct 2021 15:39:30 +0000 (UTC)
Message-ID: <b17bbdd2872513ba98daac63b5bf3c578bde6a61.camel@redhat.com>
Subject: Re: [PATCH 1/3] KVM: x86/mmu: Drop a redundant, broken remote TLB
 flush
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Maciej S . Szmigiero" <maciej.szmigiero@oracle.com>,
        Ben Gardon <bgardon@google.com>
Date:   Fri, 22 Oct 2021 18:39:29 +0300
In-Reply-To: <20211022010005.1454978-2-seanjc@google.com>
References: <20211022010005.1454978-1-seanjc@google.com>
         <20211022010005.1454978-2-seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2021-10-21 at 18:00 -0700, Sean Christopherson wrote:
> A recent commit to fix the calls to kvm_flush_remote_tlbs_with_address()
> in kvm_zap_gfn_range() inadvertantly added yet another flush instead of
> fixing the existing flush.  Drop the redundant flush, and fix the params
> for the existing flush.
> 
> Fixes: 2822da446640 ("KVM: x86/mmu: fix parameters to kvm_flush_remote_tlbs_with_address")
> Cc: Maxim Levitsky <mlevitsk@redhat.com>
> Cc: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/mmu/mmu.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index c6ddb042b281..f82b192bba0b 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -5709,13 +5709,11 @@ void kvm_zap_gfn_range(struct kvm *kvm, gfn_t gfn_start, gfn_t gfn_end)
>  		for (i = 0; i < KVM_ADDRESS_SPACE_NUM; i++)
>  			flush = kvm_tdp_mmu_zap_gfn_range(kvm, i, gfn_start,
>  							  gfn_end, flush);
> -		if (flush)
> -			kvm_flush_remote_tlbs_with_address(kvm, gfn_start,
> -							   gfn_end - gfn_start);
>  	}
>  
>  	if (flush)
> -		kvm_flush_remote_tlbs_with_address(kvm, gfn_start, gfn_end);
> +		kvm_flush_remote_tlbs_with_address(kvm, gfn_start,
> +						   gfn_end - gfn_start);
>  
>  	kvm_dec_notifier_count(kvm, gfn_start, gfn_end);
>  
Opps, I didn't notice that the revert added back another flush. I probablyhaven't had
the revert in place when I wrote the patch that fixed parameters to 
kvm_flush_remote_tlbs_with_address.

Best regards,
	Maxim Levitsky

