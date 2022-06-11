Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 796535474E6
	for <lists+kvm@lfdr.de>; Sat, 11 Jun 2022 15:44:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233764AbiFKNoT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 11 Jun 2022 09:44:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233328AbiFKNoR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 11 Jun 2022 09:44:17 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0696513CC7
        for <kvm@vger.kernel.org>; Sat, 11 Jun 2022 06:44:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654955054;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=45HLPCXXqTkMdZ7LqQ9jrXy/Uzs9B569cMj5sdJqp1c=;
        b=hFpgLN2pP6y/y/w2lM/CZTtIQje2PPPX+wwYSItgLgLsiQpm8iUgsBOrE2mpgovVT787f7
        rt6XKfl7EEGJDcrDsjbh1hnyGuRnZcDPBpA8vodiZWkCKy9T4PbdjzMBviRQ4rvUv0Z35g
        QHJIh6YL8Vn2ZV20fK8hWeimZLv2MhQ=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-422-VoatBileMyOaX4L1wnbWew-1; Sat, 11 Jun 2022 09:44:10 -0400
X-MC-Unique: VoatBileMyOaX4L1wnbWew-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BDA31801E67;
        Sat, 11 Jun 2022 13:44:09 +0000 (UTC)
Received: from starship (unknown [10.40.194.180])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 64CDD1415102;
        Sat, 11 Jun 2022 13:44:07 +0000 (UTC)
Message-ID: <1d71f8acb62120aed87238051ef0f22b1ac58470.camel@redhat.com>
Subject: Re: [PATCH] KVM: SVM: Fix a misplaced paranthesis in APICV inhibit
 mask generation
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Sat, 11 Jun 2022 16:44:06 +0300
In-Reply-To: <20220610191813.371682-1-seanjc@google.com>
References: <20220610191813.371682-1-seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 2022-06-10 at 19:18 +0000, Sean Christopherson wrote:
> Relocate a ")" to its proper place at the end of a BIT usage, the intent
> is most definitely not to have a feedback loop of BITs in the mask.
> 
> arch/x86/kvm/svm/avic.c: In function ‘avic_check_apicv_inhibit_reasons’:
> include/vdso/bits.h:7:40: error: left shift count >= width of type [-Werror=shift-count-overflow]
>     7 | #define BIT(nr)                 (UL(1) << (nr))
>       |                                        ^~
> arch/x86/kvm/svm/avic.c:911:27: note: in expansion of macro ‘BIT’
>   911 |                           BIT(APICV_INHIBIT_REASON_SEV      |
>       |                           ^~~
> 
> Fixes: 3743c2f02517 ("KVM: x86: inhibit APICv/AVIC on changes to APIC ID or APIC base")
> Cc: Maxim Levitsky <mlevitsk@redhat.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/svm/avic.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
> index 5542d8959e11..d1bc5820ea46 100644
> --- a/arch/x86/kvm/svm/avic.c
> +++ b/arch/x86/kvm/svm/avic.c
> @@ -908,9 +908,9 @@ bool avic_check_apicv_inhibit_reasons(enum kvm_apicv_inhibit reason)
>  			  BIT(APICV_INHIBIT_REASON_PIT_REINJ) |
>  			  BIT(APICV_INHIBIT_REASON_X2APIC) |
>  			  BIT(APICV_INHIBIT_REASON_BLOCKIRQ) |
> -			  BIT(APICV_INHIBIT_REASON_SEV      |
> +			  BIT(APICV_INHIBIT_REASON_SEV)      |
>  			  BIT(APICV_INHIBIT_REASON_APIC_ID_MODIFIED) |
> -			  BIT(APICV_INHIBIT_REASON_APIC_BASE_MODIFIED));
> +			  BIT(APICV_INHIBIT_REASON_APIC_BASE_MODIFIED);
>  
>  	return supported & BIT(reason);
>  }
> 
> base-commit: b23f8810c46978bc05252db03055a61fcadc07d5

Sorry about it!

Best regards,
	Maxim Levitsky

