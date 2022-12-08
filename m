Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E844264787B
	for <lists+kvm@lfdr.de>; Thu,  8 Dec 2022 23:03:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230119AbiLHWDO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Dec 2022 17:03:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230134AbiLHWCu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Dec 2022 17:02:50 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D351AA0FB5
        for <kvm@vger.kernel.org>; Thu,  8 Dec 2022 14:00:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670536840;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FYrDLJGucSIpdbIsOIn8UE6xyaF/+dOPy8B3O9dEgSQ=;
        b=LRpn3mul2RrtqYhFuaj/jY9tY0Qq2v/1T7/rdSXt1XMEG+dtmPzqXOPdlA8EKR1ZM0qZVL
        wFpAeir91CH8fom7ZlgzOp9LJdAIE6/U3mlk5ml9nDE2P6b5oqpKThSuWpYXiu2hovPXEH
        6jDypusBDuQbZYiPSfSY7QsoYaoW4Sg=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-16-BbYH1xuZPpenyluuYR9TYw-1; Thu, 08 Dec 2022 17:00:36 -0500
X-MC-Unique: BbYH1xuZPpenyluuYR9TYw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 875141C087A9;
        Thu,  8 Dec 2022 22:00:35 +0000 (UTC)
Received: from starship (unknown [10.35.206.46])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 24BAB2024CC0;
        Thu,  8 Dec 2022 22:00:33 +0000 (UTC)
Message-ID: <f1f1a33134c739f09f5820b5a4973535f121c0da.camel@redhat.com>
Subject: Re: [PATCH v4 28/32] KVM: SVM: Require logical ID to be power-of-2
 for AVIC entry
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Li RongQing <lirongqing@baidu.com>
Date:   Fri, 09 Dec 2022 00:00:33 +0200
In-Reply-To: <20221001005915.2041642-29-seanjc@google.com>
References: <20221001005915.2041642-1-seanjc@google.com>
         <20221001005915.2041642-29-seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, 2022-10-01 at 00:59 +0000, Sean Christopherson wrote:
> Do not modify AVIC's logical ID table if the logical ID portion of the
> LDR is not a power-of-2, i.e. if the LDR has multiple bits set.  Taking
> only the first bit means that KVM will fail to match MDAs that intersect
> with "higher" bits in the "ID"
> 
> The "ID" acts as a bitmap, but is referred to as an ID because theres an
> implicit, unenforced "requirement" that software only set one bit.  This
> edge case is arguably out-of-spec behavior, but KVM cleanly handles it
> in all other cases, e.g. the optimized logical map (and AVIC!) is also
> disabled in this scenario.
> 
> Refactor the code to consolidate the checks, and so that the code looks
> more like avic_kick_target_vcpus_fast().
> 
> Fixes: 18f40c53e10f ("svm: Add VMEXIT handlers for AVIC")
> Cc: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
> Cc: Maxim Levitsky <mlevitsk@redhat.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/svm/avic.c | 30 +++++++++++++++---------------
>  1 file changed, 15 insertions(+), 15 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
> index 4b6fc9d64f4d..a9e4e09f83fc 100644
> --- a/arch/x86/kvm/svm/avic.c
> +++ b/arch/x86/kvm/svm/avic.c
> @@ -513,26 +513,26 @@ unsigned long avic_vcpu_get_apicv_inhibit_reasons(struct kvm_vcpu *vcpu)
>  static u32 *avic_get_logical_id_entry(struct kvm_vcpu *vcpu, u32 ldr, bool flat)
>  {
>  	struct kvm_svm *kvm_svm = to_kvm_svm(vcpu->kvm);
> -	int index;
>  	u32 *logical_apic_id_table;
> -	int dlid = GET_APIC_LOGICAL_ID(ldr);
> +	u32 cluster, index;
>  
> -	if (!dlid)
> -		return NULL;
> +	ldr = GET_APIC_LOGICAL_ID(ldr);
>  
> -	if (flat) { /* flat */
> -		index = ffs(dlid) - 1;
> -		if (index > 7)
> +	if (flat) {
> +		cluster = 0;
> +	} else {
> +		cluster = (ldr >> 4) << 2;
> +		if (cluster >= 0xf)
>  			return NULL;
> -	} else { /* cluster */
> -		int cluster = (dlid & 0xf0) >> 4;
> -		int apic = ffs(dlid & 0x0f) - 1;
> -
> -		if ((apic < 0) || (apic > 7) ||
> -		    (cluster >= 0xf))
> -			return NULL;
> -		index = (cluster << 2) + apic;
> +		ldr &= 0xf;
>  	}
> +	if (!ldr || !is_power_of_2(ldr))
> +		return NULL;
> +
> +	index = __ffs(ldr);
> +	if (WARN_ON_ONCE(index > 7))
> +		return NULL;
> +	index += (cluster << 2);
>  
>  	logical_apic_id_table = (u32 *) page_address(kvm_svm->avic_logical_id_table_page);
>  


Looks good.

For future refactoring, I also suggest to rename this function to 'avic_get_logical_id_table_entry'
to stress the fact that it gets a pointer to the AVIC's data structure.

Same for 'avic_get_physical_id_entry'

And also while at it : the 'svm->avic_physical_id_cache', is a very misleading name,

It should be svm->avic_physical_id_table_entry_ptr with a comment explaining that
is is the pointer to physid table entry.


Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>



Best regards,
	Maxim Levitsky

