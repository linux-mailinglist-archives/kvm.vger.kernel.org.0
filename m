Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7CF6A568787
	for <lists+kvm@lfdr.de>; Wed,  6 Jul 2022 13:59:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233425AbiGFL6g (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Jul 2022 07:58:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233442AbiGFL63 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Jul 2022 07:58:29 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3B43A1EC56
        for <kvm@vger.kernel.org>; Wed,  6 Jul 2022 04:58:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657108706;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1QhWLKEpshviPNDTG+rlONXrogGmGRJzt+OodfxRCiM=;
        b=DmvmLY9lvmRPiWeTX0WgqMtfGmnvVd6ZAuZaFYSkXF/Q8oI4/3RBjq6X8HKOFHh/EcH1tS
        y1y0uCWd2lzT1Fh72mQb/zLS4dLCZEC6Zz8IgyW0l1gyEBUp5eO12GhXefLPIqBXq4Jwrd
        30+UQs9tisuGdjmJfKJX532DqRJVx48=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-563-wjfukSXlN-yeSNYX2DHFhA-1; Wed, 06 Jul 2022 07:58:22 -0400
X-MC-Unique: wjfukSXlN-yeSNYX2DHFhA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8F8ED3C0D85D;
        Wed,  6 Jul 2022 11:58:21 +0000 (UTC)
Received: from starship (unknown [10.40.194.38])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3AA451121315;
        Wed,  6 Jul 2022 11:58:19 +0000 (UTC)
Message-ID: <253c4296bc328346bcd0571c1ef0f9f85bbc12f4.camel@redhat.com>
Subject: Re: [PATCH v2 07/21] KVM: x86: Use DR7_GD macro instead of open
 coding check in emulator
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Oliver Upton <oupton@google.com>,
        Peter Shier <pshier@google.com>
Date:   Wed, 06 Jul 2022 14:58:18 +0300
In-Reply-To: <20220614204730.3359543-8-seanjc@google.com>
References: <20220614204730.3359543-1-seanjc@google.com>
         <20220614204730.3359543-8-seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2022-06-14 at 20:47 +0000, Sean Christopherson wrote:
> Use DR7_GD in the emulator instead of open coding the check, and drop a
> comically wrong comment.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/emulate.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
> index 39ea9138224c..bf499716d9d3 100644
> --- a/arch/x86/kvm/emulate.c
> +++ b/arch/x86/kvm/emulate.c
> @@ -4182,8 +4182,7 @@ static int check_dr7_gd(struct x86_emulate_ctxt *ctxt)
>  
>  	ctxt->ops->get_dr(ctxt, 7, &dr7);
>  
> -	/* Check if DR7.Global_Enable is set */
> -	return dr7 & (1 << 13);
> +	return dr7 & DR7_GD;
>  }
>  
>  static int check_dr_read(struct x86_emulate_ctxt *ctxt)


Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky

