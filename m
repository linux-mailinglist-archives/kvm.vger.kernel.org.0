Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 115435A7B47
	for <lists+kvm@lfdr.de>; Wed, 31 Aug 2022 12:22:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229589AbiHaKW4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 Aug 2022 06:22:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbiHaKWz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 Aug 2022 06:22:55 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 660321CFE5
        for <kvm@vger.kernel.org>; Wed, 31 Aug 2022 03:22:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1661941373;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LzIvd2n53+U6UvrcPz90+OBrywtHLH6pX3t23J4LFE8=;
        b=TEBMQlvvdN85TmdKf1Xc2RX4ptR/Sa9yPO/ucYnUJ+vAtC3fEQmVBF/43LLoftN4hX8UWz
        ohgT8H/8cb9towgVwYi/yfdzzSjWvfK3d/V2ofMYYrj62veT8/eAEysfAoI/F3DweJZlmj
        Ig7hHJsIf94u62fXC/7FJ0uWQIZEAfk=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-332-bG5GNCaiMi2mCocYHzbtwA-1; Wed, 31 Aug 2022 06:22:50 -0400
X-MC-Unique: bG5GNCaiMi2mCocYHzbtwA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EA2B91C08961;
        Wed, 31 Aug 2022 10:22:49 +0000 (UTC)
Received: from starship (unknown [10.40.194.96])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 531712166B2A;
        Wed, 31 Aug 2022 10:22:48 +0000 (UTC)
Message-ID: <29542724f23fd15745bd137b99153bf8629907f0.camel@redhat.com>
Subject: Re: [PATCH 10/19] KVM: SVM: Document that vCPU ID == APIC ID in
 AVIC kick fastpatch
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Li RongQing <lirongqing@baidu.com>
Date:   Wed, 31 Aug 2022 13:22:47 +0300
In-Reply-To: <20220831003506.4117148-11-seanjc@google.com>
References: <20220831003506.4117148-1-seanjc@google.com>
         <20220831003506.4117148-11-seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 2022-08-31 at 00:34 +0000, Sean Christopherson wrote:
> Document that AVIC is inhibited if any vCPU's APIC ID diverges from its
> vCPU ID, i.e. that there's no need to check for a destination match in
> the AVIC kick fast path.
> 
> Opportunistically tweak comments to remove "guest bug", as that suggests
> KVM is punting on error handling, which is not the case.  Targeting a
> non-existent vCPU or no vCPUs _may_ be a guest software bug, but whether
> or not it's a guest bug is irrelevant.  Such behavior is architecturally
> legal and thus needs to faithfully emulated by KVM (and it is).

I don't want to pick a fight, but personally these things *are* guest bugs / improper usage of APIC,
and I don't think it is wrong to document them as such.

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>


> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/svm/avic.c | 10 +++++++---
>  1 file changed, 7 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
> index 05a1cde8175c..3959d4766911 100644
> --- a/arch/x86/kvm/svm/avic.c
> +++ b/arch/x86/kvm/svm/avic.c
> @@ -380,8 +380,8 @@ static int avic_kick_target_vcpus_fast(struct kvm *kvm, struct kvm_lapic *source
>  			cluster = (dest >> 4) << 2;
>  		}
>  
> +		/* Nothing to do if there are no destinations in the cluster. */
>  		if (unlikely(!bitmap))
> -			/* guest bug: nobody to send the logical interrupt to */
>  			return 0;
>  
>  		if (!is_power_of_2(bitmap))
> @@ -399,7 +399,7 @@ static int avic_kick_target_vcpus_fast(struct kvm *kvm, struct kvm_lapic *source
>  			if (WARN_ON_ONCE(index != logid_index))
>  				return -EINVAL;
>  
> -			/* guest bug: non existing/reserved logical destination */
> +			/* Nothing to do if the logical destination is invalid. */
>  			if (unlikely(!(logid_entry & AVIC_LOGICAL_ID_ENTRY_VALID_MASK)))
>  				return 0;
>  
> @@ -418,9 +418,13 @@ static int avic_kick_target_vcpus_fast(struct kvm *kvm, struct kvm_lapic *source
>  		}
>  	}
>  
> +	/*
> +	 * KVM inhibits AVIC if any vCPU ID diverges from the vCPUs APIC ID,
> +	 * i.e. APIC ID == vCPU ID.  Once again, nothing to do if the target
> +	 * vCPU doesn't exist.
> +	 */
>  	target_vcpu = kvm_get_vcpu_by_id(kvm, l1_physical_id);
>  	if (unlikely(!target_vcpu))
> -		/* guest bug: non existing vCPU is a target of this IPI*/
>  		return 0;
>  
>  	target_vcpu->arch.apic->irr_pending = true;


