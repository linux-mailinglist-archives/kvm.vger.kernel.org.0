Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75EA654E091
	for <lists+kvm@lfdr.de>; Thu, 16 Jun 2022 14:10:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376811AbiFPMKS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Jun 2022 08:10:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376762AbiFPMKO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Jun 2022 08:10:14 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2E1452CCBA
        for <kvm@vger.kernel.org>; Thu, 16 Jun 2022 05:10:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1655381411;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=fnbFANRgoRclz/nSGpz08wiygYjL/K249VvGKPTLsfU=;
        b=VOSkStcVNOCYtYPBWbHbaSuQKti/vm5iHzQAVx03Id0bO0i6mLzGaB6BxAYCnSOGNdOUGT
        39WZ+TtYbcai5ZMlUSf9s41AgwjRdo3zIA++eiep2YalW7sV/dEOUwp4Nwjb9Aa5DUWG8h
        f4mA9EeiCjRbIQwlVj+1w/WFWWn5UPU=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-669-remI2F40P0uUbA-Nx7dZaw-1; Thu, 16 Jun 2022 08:10:10 -0400
X-MC-Unique: remI2F40P0uUbA-Nx7dZaw-1
Received: by mail-ed1-f72.google.com with SMTP id k21-20020aa7d2d5000000b0042dcac48313so1131021edr.8
        for <kvm@vger.kernel.org>; Thu, 16 Jun 2022 05:10:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=fnbFANRgoRclz/nSGpz08wiygYjL/K249VvGKPTLsfU=;
        b=ocKFrhiCVuhZLfSRDLSbBEpngZyfd/T72tDOMJOj5OlfSC677YJR2SCPGkypbfqY4z
         q/xYgIEmUXA0b5iwv1N7gGIyLhrU7dcZg2zvKegosvHMTDiMsDk+MYi1OY09lloYjIyN
         KU/Dpq2VMbxEg8kpw0a+ES369WF7Ds6N3IAAHw9csPCq3uk+HmH6jcRC/KHeOHvYNmOK
         K1lFqmMKf8s4wUPvn1452O1EcGyPOKyBeCPvxGCC4xZWgHXqCpCH5PzsfA9ogYYL2M7L
         UjNTlAZemXB7sI8nRoAfRIHm2I1morRQQhlSy9GuCWLfudnYyv638iImlI9cLyYf74Xx
         Ojig==
X-Gm-Message-State: AJIora/cfYuvD2inyfyQAZnvGGDY8Ja4znv1H8Qh500kwKpTnyNKxR7+
        fCQe4vRY7yPWgkta+BGl9Gt9VR/P9dvC5y2y9bfpcsL90olRBJpphoXwZXqUqqiXAWS0/5uTyA/
        fKkkRCcG9ur2v
X-Received: by 2002:a05:6402:ea7:b0:433:6141:840e with SMTP id h39-20020a0564020ea700b004336141840emr6109525eda.266.1655381409549;
        Thu, 16 Jun 2022 05:10:09 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1shrqTcIAQx5WuqolRTdcuV69UIK8NkIrhIplpkXUIdvASi2H8d4HpaeyriLBogszA7USoIuA==
X-Received: by 2002:a05:6402:ea7:b0:433:6141:840e with SMTP id h39-20020a0564020ea700b004336141840emr6109506eda.266.1655381409416;
        Thu, 16 Jun 2022 05:10:09 -0700 (PDT)
Received: from gator (cst2-173-67.cust.vodafone.cz. [31.30.173.67])
        by smtp.gmail.com with ESMTPSA id o17-20020aa7dd51000000b0042df0c7deccsm1628311edw.78.2022.06.16.05.10.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jun 2022 05:10:08 -0700 (PDT)
Date:   Thu, 16 Jun 2022 14:10:06 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Colton Lewis <coltonlewis@google.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        pbonzini@redhat.com, seanjc@google.com, vkuznets@redhat.com,
        thuth@redhat.com, maz@kernel.org
Subject: Re: [PATCH 2/4] KVM: selftests: Increase UCALL_MAX_ARGS to 7
Message-ID: <20220616121006.ch6x7du6ycevjo5m@gator>
References: <20220615193116.806312-1-coltonlewis@google.com>
 <20220615193116.806312-3-coltonlewis@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220615193116.806312-3-coltonlewis@google.com>
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jun 15, 2022 at 07:31:14PM +0000, Colton Lewis wrote:
> Increase UCALL_MAX_ARGS to 7 to allow GUEST_ASSERT_4 to pass 3 builtin
> ucall arguments specified in guest_assert_builtin_args plus 4
> user-specified arguments.
> 
> Signed-off-by: Colton Lewis <coltonlewis@google.com>
> ---
>  tools/testing/selftests/kvm/include/ucall_common.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tools/testing/selftests/kvm/include/ucall_common.h b/tools/testing/selftests/kvm/include/ucall_common.h
> index dbe872870b83..568c562f14cd 100644
> --- a/tools/testing/selftests/kvm/include/ucall_common.h
> +++ b/tools/testing/selftests/kvm/include/ucall_common.h
> @@ -16,7 +16,7 @@ enum {
>  	UCALL_UNHANDLED,
>  };
>  
> -#define UCALL_MAX_ARGS 6
> +#define UCALL_MAX_ARGS 7
>  
>  struct ucall {
>  	uint64_t cmd;
> -- 
> 2.36.1.476.g0c4daa206d-goog
>

We probably want to ensure all architectures are good with this. afaict,
riscv only expects 6 args and uses UCALL_MAX_ARGS to cap the ucall inputs,
for example.

Thanks,
drew

