Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08A7451308C
	for <lists+kvm@lfdr.de>; Thu, 28 Apr 2022 12:01:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230414AbiD1KEY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Apr 2022 06:04:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232186AbiD1KDp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Apr 2022 06:03:45 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 62063B6D35
        for <kvm@vger.kernel.org>; Thu, 28 Apr 2022 02:49:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1651139392;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=J/tFn7zfKbOP49Zn7udrRkKElxW0ATnp0QB1hw1Lcmc=;
        b=VvWF1yOGWicgj8qrNdk9aQ7Z+5GaWxnaQPZUYS5YtDqfvKoKD2gxCuRLN3/0X5qvUGgMm0
        OKI8cBJk+3iONvRCSte5cz3gTLdiGOgQkXwdlNZBooYPExpDecEqbut9ASxTkisFAzl6KR
        fj+rVXvTL+XrmCb+M9i/WagHx9HPmaM=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-470-tk-d7XwQNoyX_swQ9pv9Aw-1; Thu, 28 Apr 2022 05:49:47 -0400
X-MC-Unique: tk-d7XwQNoyX_swQ9pv9Aw-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 670BA3C0E188;
        Thu, 28 Apr 2022 09:49:47 +0000 (UTC)
Received: from starship (unknown [10.40.192.41])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 67BFA567628;
        Thu, 28 Apr 2022 09:49:45 +0000 (UTC)
Message-ID: <79a0c1205b646ead0b2128147cb7df4198646b99.camel@redhat.com>
Subject: Re: [PATCH v2 08/11] KVM: x86: Print error code in exception
 injection tracepoint iff valid
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Maciej S . Szmigiero" <maciej.szmigiero@oracle.com>
Date:   Thu, 28 Apr 2022 12:49:44 +0300
In-Reply-To: <20220423021411.784383-9-seanjc@google.com>
References: <20220423021411.784383-1-seanjc@google.com>
         <20220423021411.784383-9-seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, 2022-04-23 at 02:14 +0000, Sean Christopherson wrote:
> Print the error code in the exception injection tracepoint if and only if
> the exception has an error code.  Define the entire error code sequence
> as a set of formatted strings, print empty strings if there's no error
> code, and abuse __print_symbolic() by passing it an empty array to coerce
> it into printing the error code as a hex string.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/trace.h | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/kvm/trace.h b/arch/x86/kvm/trace.h
> index d07428e660e3..385436d12024 100644
> --- a/arch/x86/kvm/trace.h
> +++ b/arch/x86/kvm/trace.h
> @@ -376,10 +376,11 @@ TRACE_EVENT(kvm_inj_exception,
>  		__entry->reinjected	= reinjected;
>  	),
>  
> -	TP_printk("%s (0x%x)%s",
> +	TP_printk("%s%s%s%s%s",
>  		  __print_symbolic(__entry->exception, kvm_trace_sym_exc),
> -		  /* FIXME: don't print error_code if not present */
> -		  __entry->has_error ? __entry->error_code : 0,
> +		  !__entry->has_error ? "" : " (",
> +		  !__entry->has_error ? "" : __print_symbolic(__entry->error_code, { }),
> +		  !__entry->has_error ? "" : ")",
>  		  __entry->reinjected ? " [reinjected]" : "")
>  );
>  



Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Good idea to do it in few more places, I'll keep that in mind.

Best regards,
	Maxim Levitsky

