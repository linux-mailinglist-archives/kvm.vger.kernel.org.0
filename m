Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B833647861
	for <lists+kvm@lfdr.de>; Thu,  8 Dec 2022 22:58:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230022AbiLHV62 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Dec 2022 16:58:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229966AbiLHV6E (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Dec 2022 16:58:04 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 682C36B99D
        for <kvm@vger.kernel.org>; Thu,  8 Dec 2022 13:57:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670536621;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=du3U8StQ3hHU3YVISF9mkSgajM1WK/Fz9Qy+lPFZL84=;
        b=BS2EcF42HPnVixcsMf7lCFk04Nx0ZohHmPpIgKxHuEMOiOJjV+WNcEj1GAHVhJrltdSQ5u
        DbVAiNhVo35AP5xkA443q4vn0jUk9WI4oYHogjybpbEnOVlzGK3WxZwKvGJixWXUXzYg5J
        cyOOw4uoBtxQsF/D+sniEgk9N1+sipI=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-137-e1hxfrBGOKWSnK_32fbb_A-1; Thu, 08 Dec 2022 16:56:56 -0500
X-MC-Unique: e1hxfrBGOKWSnK_32fbb_A-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CB01438041C4;
        Thu,  8 Dec 2022 21:56:53 +0000 (UTC)
Received: from starship (unknown [10.35.206.46])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6860D17582;
        Thu,  8 Dec 2022 21:56:52 +0000 (UTC)
Message-ID: <e3e9da038f9ea83b1dc81e2532a737e98b2f2195.camel@redhat.com>
Subject: Re: [PATCH v4 18/32] KVM: x86: Explicitly skip optimized logical
 map setup if vCPU's LDR==0
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Li RongQing <lirongqing@baidu.com>
Date:   Thu, 08 Dec 2022 23:56:51 +0200
In-Reply-To: <20221001005915.2041642-19-seanjc@google.com>
References: <20221001005915.2041642-1-seanjc@google.com>
         <20221001005915.2041642-19-seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
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
> Explicitly skip the optimized map setup if the vCPU's LDR is '0', i.e. if
> the vCPU will never respond to logical mode interrupts.  KVM already
> skips setup in this case, but relies on kvm_apic_map_get_logical_dest()
> to generate mask==0.  KVM still needs the mask=0 check as a non-zero LDR
> can yield mask==0 depending on the mode, but explicitly handling the LDR
> will make it simpler to clean up the logical mode tracking in the future.
> 
> No functional change intended.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/lapic.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> index 42b61469674d..cef8b202490b 100644
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -286,10 +286,12 @@ void kvm_recalculate_apic_map(struct kvm *kvm)
>  			continue;
>  
>  		ldr = kvm_lapic_get_reg(apic, APIC_LDR);
> +		if (!ldr)
> +			continue;
>  
>  		if (apic_x2apic_mode(apic)) {
>  			new->mode |= KVM_APIC_MODE_X2APIC;
> -		} else if (ldr) {
> +		} else {
>  			ldr = GET_APIC_LOGICAL_ID(ldr);
>  			if (kvm_lapic_get_reg(apic, APIC_DFR) == APIC_DFR_FLAT)
>  				new->mode |= KVM_APIC_MODE_XAPIC_FLAT;

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky

