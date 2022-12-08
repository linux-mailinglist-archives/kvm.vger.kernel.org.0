Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2EB7A64785E
	for <lists+kvm@lfdr.de>; Thu,  8 Dec 2022 22:58:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229911AbiLHV6C (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Dec 2022 16:58:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230060AbiLHV5o (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Dec 2022 16:57:44 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC6716B98E
        for <kvm@vger.kernel.org>; Thu,  8 Dec 2022 13:56:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670536608;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FliWeXV018ru6ANKqxRF6RtAWv58W7FzLHcXM4gsCwg=;
        b=PVM0ihwo0v5HFw2jqyIXhAqyyaf1MoxJrmFU565eHPR6Svoz+Pywgx7Xran1eTaMNc13hQ
        QdC/xgI3ddr8P1Ek1hUvNwPs4hR7gEnNJYlMkuhRvw2BKhS/p7yeSczQQMmLdpmCezZ1rs
        afB7jt1RvMvWvNnXndleJXbtX34jlrk=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-494-mknDyv2_PHaXXflb6fuTUg-1; Thu, 08 Dec 2022 16:56:45 -0500
X-MC-Unique: mknDyv2_PHaXXflb6fuTUg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 96E4E101A52A;
        Thu,  8 Dec 2022 21:56:44 +0000 (UTC)
Received: from starship (unknown [10.35.206.46])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2E2762166B26;
        Thu,  8 Dec 2022 21:56:43 +0000 (UTC)
Message-ID: <121a948a7089c7b30226efd6d13871432eec43de.camel@redhat.com>
Subject: Re: [PATCH v4 15/32] Revert "KVM: SVM: Use target APIC ID to
 complete x2AVIC IRQs when possible"
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Li RongQing <lirongqing@baidu.com>
Date:   Thu, 08 Dec 2022 23:56:42 +0200
In-Reply-To: <20221001005915.2041642-16-seanjc@google.com>
References: <20221001005915.2041642-1-seanjc@google.com>
         <20221001005915.2041642-16-seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, 2022-10-01 at 00:58 +0000, Sean Christopherson wrote:
> Due to a likely mismerge of patches, KVM ended up with a superfluous
> commit to "enable" AVIC's fast path for x2AVIC mode.  Even worse, the
> superfluous commit has several bugs and creates a nasty local shadow
> variable.
> 
> Rather than fix the bugs piece-by-piece[*] to achieve the same end
> result, revert the patch wholesale.
> 
> Opportunistically add a comment documenting the x2AVIC dependencies.
> 
> This reverts commit 8c9e639da435874fb845c4d296ce55664071ea7a.
> 
> [*] https://lore.kernel.org/all/YxEP7ZBRIuFWhnYJ@google.com
> 
> Fixes: 8c9e639da435 ("KVM: SVM: Use target APIC ID to complete x2AVIC IRQs when possible")
> Suggested-by: Maxim Levitsky <mlevitsk@redhat.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/svm/avic.c | 29 +++++++++++------------------
>  1 file changed, 11 insertions(+), 18 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
> index e35e9363e7ff..605c36569ddf 100644
> --- a/arch/x86/kvm/svm/avic.c
> +++ b/arch/x86/kvm/svm/avic.c
> @@ -378,7 +378,17 @@ static int avic_kick_target_vcpus_fast(struct kvm *kvm, struct kvm_lapic *source
>  
>  		logid_index = cluster + __ffs(bitmap);
>  
> -		if (!apic_x2apic_mode(source)) {
> +		if (apic_x2apic_mode(source)) {
> +			/*
> +			 * For x2APIC, the logical APIC ID is a read-only value
> +			 * that is derived from the x2APIC ID, thus the x2APIC
> +			 * ID can be found by reversing the calculation (done
> +			 * above).  Note, bits 31:20 of the x2APIC ID are not
> +			 * propagated to the logical ID, but KVM limits the
> +			 * x2APIC ID limited to KVM_MAX_VCPU_IDS.
> +			 */
> +			l1_physical_id = logid_index;
> +		} else {
>  			u32 *avic_logical_id_table =
>  				page_address(kvm_svm->avic_logical_id_table_page);
>  
> @@ -393,23 +403,6 @@ static int avic_kick_target_vcpus_fast(struct kvm *kvm, struct kvm_lapic *source
>  
>  			l1_physical_id = logid_entry &
>  					 AVIC_LOGICAL_ID_ENTRY_GUEST_PHYSICAL_ID_MASK;
> -		} else {
> -			/*
> -			 * For x2APIC logical mode, cannot leverage the index.
> -			 * Instead, calculate physical ID from logical ID in ICRH.
> -			 */
> -			int cluster = (icrh & 0xffff0000) >> 16;
> -			int apic = ffs(icrh & 0xffff) - 1;
> -
> -			/*
> -			 * If the x2APIC logical ID sub-field (i.e. icrh[15:0])
> -			 * contains anything but a single bit, we cannot use the
> -			 * fast path, because it is limited to a single vCPU.
> -			 */
> -			if (apic < 0 || icrh != (1 << apic))
> -				return -EINVAL;
> -
> -			l1_physical_id = (cluster << 4) + apic;
>  		}
>  	}
>  


Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky

