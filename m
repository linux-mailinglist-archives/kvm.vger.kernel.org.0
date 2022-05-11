Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9ACBA5231AA
	for <lists+kvm@lfdr.de>; Wed, 11 May 2022 13:31:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229620AbiEKLar (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 May 2022 07:30:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238935AbiEKLal (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 May 2022 07:30:41 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B84152415E7
        for <kvm@vger.kernel.org>; Wed, 11 May 2022 04:30:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652268630;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wohS2fd8iJK+nOu4KauEQg//cRaTs75yj08GCIBle5g=;
        b=AJxXfDCgaNzYsH4bF7s9T+X7TPWz/wZ+ERMab7POHimDXheMBC10rLE8MDOf0JORcpLzdk
        Zr629T+1YO8AXZnDGONQfcDkFTYRNrjqQQVYhTEZxdn6JLx/Js5DRm4XCJ3esiAFzNOPh8
        BTlP/UMy+MpFklvO058smzbZACkX3XE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-642-25UsvugIN9usLHru1ARIcQ-1; Wed, 11 May 2022 07:30:27 -0400
X-MC-Unique: 25UsvugIN9usLHru1ARIcQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 23770801210;
        Wed, 11 May 2022 11:30:27 +0000 (UTC)
Received: from starship (unknown [10.40.192.26])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 72C8214693A5;
        Wed, 11 May 2022 11:30:24 +0000 (UTC)
Message-ID: <a060d2f84fb207af7d96cb955dd676c1d87f6adb.camel@redhat.com>
Subject: Re: [PATCH v3 18/34] x86/hyperv: Fix 'struct hv_enlightened_vmcs'
 definition
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Siddharth Chandrasekaran <sidcha@amazon.de>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Wed, 11 May 2022 14:30:23 +0300
In-Reply-To: <20220414132013.1588929-19-vkuznets@redhat.com>
References: <20220414132013.1588929-1-vkuznets@redhat.com>
         <20220414132013.1588929-19-vkuznets@redhat.com>
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
> Section 1.9 of TLFS v6.0b says:
> 
> "All structures are padded in such a way that fields are aligned
> naturally (that is, an 8-byte field is aligned to an offset of 8 bytes
> and so on)".
> 
> 'struct enlightened_vmcs' has a glitch:
> 
> ...
>         struct {
>                 u32                nested_flush_hypercall:1; /*   836: 0  4 */
>                 u32                msr_bitmap:1;         /*   836: 1  4 */
>                 u32                reserved:30;          /*   836: 2  4 */
>         } hv_enlightenments_control;                     /*   836     4 */
>         u32                        hv_vp_id;             /*   840     4 */
>         u64                        hv_vm_id;             /*   844     8 */
>         u64                        partition_assist_page; /*   852     8 */
> ...
> 
> And the observed values in 'partition_assist_page' make no sense at
> all. Fix the layout by padding the structure properly.
> 
> Fixes: 68d1eb72ee99 ("x86/hyper-v: define struct hv_enlightened_vmcs and clean field bits")
> Reviewed-by: Michael Kelley <mikelley@microsoft.com>
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> ---
>  arch/x86/include/asm/hyperv-tlfs.h | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/include/asm/hyperv-tlfs.h b/arch/x86/include/asm/hyperv-tlfs.h
> index 5225a85c08c3..e7ddae8e02c6 100644
> --- a/arch/x86/include/asm/hyperv-tlfs.h
> +++ b/arch/x86/include/asm/hyperv-tlfs.h
> @@ -548,7 +548,7 @@ struct hv_enlightened_vmcs {
>  	u64 guest_rip;
>  
>  	u32 hv_clean_fields;
> -	u32 hv_padding_32;
> +	u32 padding32_1;
>  	u32 hv_synthetic_controls;
>  	struct {
>  		u32 nested_flush_hypercall:1;
> @@ -556,7 +556,7 @@ struct hv_enlightened_vmcs {
>  		u32 reserved:30;
>  	}  __packed hv_enlightenments_control;
>  	u32 hv_vp_id;
> -
> +	u32 padding32_2;
>  	u64 hv_vm_id;
>  	u64 partition_assist_page;
>  	u64 padding64_4[4];


Makes sense.

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky

