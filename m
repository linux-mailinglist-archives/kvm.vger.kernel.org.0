Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9CD785A7B3D
	for <lists+kvm@lfdr.de>; Wed, 31 Aug 2022 12:20:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230241AbiHaKUC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 Aug 2022 06:20:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230142AbiHaKT7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 Aug 2022 06:19:59 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0B4E14D29
        for <kvm@vger.kernel.org>; Wed, 31 Aug 2022 03:19:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1661941197;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7BAfut2fqnOI2gHOJTwiv+Oolt0KrYkM0Hx7Bxxkc38=;
        b=WX8LHXzeyyEMXZRoQvyfqwpzWDYhU8hMVlOLb8OkQ6qEj/06NSFBdid8PVVSuBSzu4xI6B
        tTgWuInQcoXNvfk+CbAEZHrToMVX0FcmK0ZRIGhUzsx0qFnAoPpi5znfat6589NbBvlotE
        OOF2DNRSx0pAeHtE5eCJR/hbhYTgr4M=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-648-lLZg_qBLOEyqVqzixgEHFg-1; Wed, 31 Aug 2022 06:19:53 -0400
X-MC-Unique: lLZg_qBLOEyqVqzixgEHFg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8F3723C00086;
        Wed, 31 Aug 2022 10:19:53 +0000 (UTC)
Received: from starship (unknown [10.40.194.96])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EFA721410F3C;
        Wed, 31 Aug 2022 10:19:51 +0000 (UTC)
Message-ID: <7281e42323b53a016cf8545b7a4547d70d87efce.camel@redhat.com>
Subject: Re: [PATCH 08/19] KVM: SVM: Remove redundant cluster calculation
 that also creates a shadow
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Li RongQing <lirongqing@baidu.com>
Date:   Wed, 31 Aug 2022 13:19:50 +0300
In-Reply-To: <20220831003506.4117148-9-seanjc@google.com>
References: <20220831003506.4117148-1-seanjc@google.com>
         <20220831003506.4117148-9-seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 2022-08-31 at 00:34 +0000, Sean Christopherson wrote:
> Drop the redundant "cluster" calculation and its horrific shadowing in
> the x2avic logical mode path.  The "cluster" that is declared at an outer
> scope is derived using the exact same calculation and has performed the
> left-shift.

Actually I think we should just revert the commit 
'KVM: SVM: Use target APIC ID to complete x2AVIC IRQs when possible'


I know that the patch that intially introduced the the avic_kick_target_vcpus_fast had
x2apic/x2avic code, and then it was split to avoid adding x2avic code before it was merged,
resulting in this patch to add the x2apic specific code.

But when I fixed most issues of avic_kick_target_vcpus_fast in my 
'KVM: x86: SVM: fix avic_kick_target_vcpus_fast', I added back x2apic code because
it was just natural to do since I had to calculate cluster/bitmap masks anyway.

I expected this patch to be dropped because of this but I guess it was not noticed,
or patches were merged in the wrong order.

This is the reason of shadowing, duplicate calculations/etc.

Patch 9 and 7 of your series can be dropped as well then.

Best regards,
	Maxim Levitsky


> 
> No functional change intended.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/svm/avic.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
> index 14f567550a1e..8c9cad96008e 100644
> --- a/arch/x86/kvm/svm/avic.c
> +++ b/arch/x86/kvm/svm/avic.c
> @@ -410,10 +410,9 @@ static int avic_kick_target_vcpus_fast(struct kvm *kvm, struct kvm_lapic *source
>  			 * For x2APIC logical mode, cannot leverage the index.
>  			 * Instead, calculate physical ID from logical ID in ICRH.
>  			 */
> -			int cluster = (icrh & 0xffff0000) >> 16;
>  			int apic = ffs(bitmap) - 1;
>  
> -			l1_physical_id = (cluster << 4) + apic;
> +			l1_physical_id = cluster + apic;
>  		}
>  	}
>  


