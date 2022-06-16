Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E0D554E103
	for <lists+kvm@lfdr.de>; Thu, 16 Jun 2022 14:46:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230386AbiFPMqR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Jun 2022 08:46:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230141AbiFPMqQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Jun 2022 08:46:16 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 30F0D2EA3A
        for <kvm@vger.kernel.org>; Thu, 16 Jun 2022 05:46:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1655383574;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=gLgx7hmsWQsQo30sh+kzZRE6xJ8y056KBCH3mRvUzv8=;
        b=EtQX6ObX9ufAqtmDpEd3Nf8rv1s6v5xiyjsq89lGUAzzg1TaQhUlYVobgiVA2blH7Kkbrm
        aabPxSY+ciQxv/ijsA1YH1YFEVmCMwnI2m3pzGzWFsOg0JVa6gCFFI5SzOuf8UMDPHQkS8
        sB3RtTyqbbBW19k+/mei59mo1ugNakw=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-78-PFXSAtKeNRyL9YyrAJzqcw-1; Thu, 16 Jun 2022 08:46:13 -0400
X-MC-Unique: PFXSAtKeNRyL9YyrAJzqcw-1
Received: by mail-ed1-f72.google.com with SMTP id x8-20020a056402414800b0042d8498f50aso1158774eda.23
        for <kvm@vger.kernel.org>; Thu, 16 Jun 2022 05:46:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=gLgx7hmsWQsQo30sh+kzZRE6xJ8y056KBCH3mRvUzv8=;
        b=Q/dU4REKfS38Q1F2LRQASY9cH0QlH0wD7Q0/YpNfTwJyQ0ZDLy1ssz5mxWr9PPf9Q2
         ovd2hfwd4Qknu2xXy2rScrcZ6Pxs4c+4/uPHK0bgLkjpZ9GP3iU+Db93/3eouUwn3Fti
         D6vgeF0p3iZ9HNlxp2PZi4uxVQCaIEQF3IvcatSCIbzc9E5oS+lSsbbixS8bMsaRKBUD
         Icmwj+/liZZOmJJGCN6OlGSjGg7csJYW4lV06QCheZ/Wik+Gw9++A/8aG8bvR/D7gsjK
         FEs8ZGSHJqSg/439evMUgnjsZMR2u/pNiiukn/l3XtU9cDe1AlWsksivQi0B2VNDXb6W
         4Sxg==
X-Gm-Message-State: AJIora+gqHKKk9fZkygLTSrdLVTni39diyauwOHCaEmCLxhxh+sZhMzK
        TRrS4jxN1pNNBnG7hwp3OMXWf8BEG3azbizM/ntgJuX9ONLYQGsDbfM+46OOGAtU0d4RIbeHoZj
        AjuSKZadoQ9Z4
X-Received: by 2002:a05:6402:3807:b0:435:20fb:318d with SMTP id es7-20020a056402380700b0043520fb318dmr6324736edb.272.1655383571817;
        Thu, 16 Jun 2022 05:46:11 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1v3lxgSx+whO8T5GvlDJx/RuoG4NSeOFL5I9qG6AmpHIWH5MdvIkc6+sxrw5L52/Yz1p/cM8A==
X-Received: by 2002:a05:6402:3807:b0:435:20fb:318d with SMTP id es7-20020a056402380700b0043520fb318dmr6324718edb.272.1655383571670;
        Thu, 16 Jun 2022 05:46:11 -0700 (PDT)
Received: from gator (cst2-173-67.cust.vodafone.cz. [31.30.173.67])
        by smtp.gmail.com with ESMTPSA id d13-20020a170906304d00b00704757b1debsm754009ejd.9.2022.06.16.05.46.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jun 2022 05:46:11 -0700 (PDT)
Date:   Thu, 16 Jun 2022 14:46:09 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Colton Lewis <coltonlewis@google.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        pbonzini@redhat.com, seanjc@google.com, vkuznets@redhat.com,
        thuth@redhat.com, maz@kernel.org
Subject: Re: [PATCH 3/4] KVM: selftests: Write REPORT_GUEST_ASSERT macros to
 pair with GUEST_ASSERT
Message-ID: <20220616124609.fforgaccsp3rwbxi@gator>
References: <20220615193116.806312-1-coltonlewis@google.com>
 <20220615193116.806312-4-coltonlewis@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220615193116.806312-4-coltonlewis@google.com>
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jun 15, 2022 at 07:31:15PM +0000, Colton Lewis wrote:
> Write REPORT_GUEST_ASSERT macros to pair with GUEST_ASSERT to abstract
> and make consistent all guest assertion reporting. Every report
> includes an explanatory string, a filename, and a line number.
> 
> Signed-off-by: Colton Lewis <coltonlewis@google.com>
> ---
>  .../selftests/kvm/include/ucall_common.h      | 42 +++++++++++++++++++
>  1 file changed, 42 insertions(+)
> 
> diff --git a/tools/testing/selftests/kvm/include/ucall_common.h b/tools/testing/selftests/kvm/include/ucall_common.h
> index 568c562f14cd..e8af3b4fef6d 100644
> --- a/tools/testing/selftests/kvm/include/ucall_common.h
> +++ b/tools/testing/selftests/kvm/include/ucall_common.h
> @@ -6,6 +6,7 @@
>   */
>  #ifndef SELFTEST_KVM_UCALL_COMMON_H
>  #define SELFTEST_KVM_UCALL_COMMON_H
> +#include "test_util.h"
>  
>  /* Common ucalls */
>  enum {
> @@ -64,4 +65,45 @@ enum guest_assert_builtin_args {
>  
>  #define GUEST_ASSERT_EQ(a, b) __GUEST_ASSERT((a) == (b), #a " == " #b, 2, a, b)
>  
> +#define __REPORT_GUEST_ASSERT(_ucall, fmt, _args...)			\
> +	TEST_FAIL("%s at %s:%ld\n" fmt,					\
> +		  (const char *)(_ucall).args[GUEST_ERROR_STRING],	\
> +		  (const char *)(_ucall).args[GUEST_FILE],		\
> +		  (_ucall).args[GUEST_LINE],				\
> +		  ##_args)
> +
> +#define GUEST_ASSERT_ARG(ucall, i) ((ucall).args[GUEST_ASSERT_BUILTIN_NARGS + i])
> +
> +#define REPORT_GUEST_ASSERT(ucall)		\
> +	__REPORT_GUEST_ASSERT((ucall), "")
> +
> +#define REPORT_GUEST_ASSERT_1(ucall, fmt)			\
> +	__REPORT_GUEST_ASSERT((ucall),				\
> +			      fmt,				\
> +			      GUEST_ASSERT_ARG((ucall), 0))
> +
> +#define REPORT_GUEST_ASSERT_2(ucall, fmt)			\
> +	__REPORT_GUEST_ASSERT((ucall),				\
> +			      fmt,				\
> +			      GUEST_ASSERT_ARG((ucall), 0),	\
> +			      GUEST_ASSERT_ARG((ucall), 1))
> +
> +#define REPORT_GUEST_ASSERT_3(ucall, fmt)			\
> +	__REPORT_GUEST_ASSERT((ucall),				\
> +			      fmt,				\
> +			      GUEST_ASSERT_ARG((ucall), 0),	\
> +			      GUEST_ASSERT_ARG((ucall), 1),	\
> +			      GUEST_ASSERT_ARG((ucall), 2))
> +
> +#define REPORT_GUEST_ASSERT_4(ucall, fmt)			\
> +	__REPORT_GUEST_ASSERT((ucall),				\
> +			      fmt,				\
> +			      GUEST_ASSERT_ARG((ucall), 0),	\
> +			      GUEST_ASSERT_ARG((ucall), 1),	\
> +			      GUEST_ASSERT_ARG((ucall), 2),	\
> +			      GUEST_ASSERT_ARG((ucall), 3))
> +
> +#define REPORT_GUEST_ASSERT_N(ucall, fmt, args...)	\
> +	__REPORT_GUEST_ASSERT((ucall), fmt, ##args)
> +
>  #endif /* SELFTEST_KVM_UCALL_COMMON_H */
> -- 
> 2.36.1.476.g0c4daa206d-goog
>

nit: All the ()'s around ucall when it's between ( and , are unnecessary.

Otherwise,

Reviewed-by: Andrew Jones <drjones@redhat.com>

Thanks,
drew

