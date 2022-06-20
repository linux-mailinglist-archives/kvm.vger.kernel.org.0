Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D65E1551E71
	for <lists+kvm@lfdr.de>; Mon, 20 Jun 2022 16:27:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347222AbiFTOBT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Jun 2022 10:01:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241256AbiFTNzw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Jun 2022 09:55:52 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id EE92034BA4
        for <kvm@vger.kernel.org>; Mon, 20 Jun 2022 06:21:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1655731273;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=CUQCJRI06y3J+/812aZ86ATOZgRVRfW4HLzZbrLgbQ8=;
        b=BJLEiMdr8ieGfNZdG198rYGdz/mP9uWWZHmeN5MjzMPlws033FCxVDCBljzpo5FE5JM89q
        EO/QSz4LOh3rE8pH5E2of3awPhD+zZ/0ArfdrGqW6QXxeMu10rR1kjJjYQD/aIbdUQ1GzS
        C0klYD7S70K0bMwRovo+j5azZpq1wc8=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-163-P2Rlog1NM-egGnTysfwhlQ-1; Mon, 20 Jun 2022 09:21:10 -0400
X-MC-Unique: P2Rlog1NM-egGnTysfwhlQ-1
Received: by mail-wr1-f71.google.com with SMTP id i16-20020adfa510000000b0021b8e9f7666so855234wrb.19
        for <kvm@vger.kernel.org>; Mon, 20 Jun 2022 06:21:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=CUQCJRI06y3J+/812aZ86ATOZgRVRfW4HLzZbrLgbQ8=;
        b=5z7PtpIjkrVPagGiSDsqA6mmr15N7D9rU8RwHnaHXkJXjHsxSHwwfYqnSK4PibMMUS
         GsT1KXal8OrFVYoocb7GmDJn+Aoqcgslw3MpA0etk6ndZn4INWQIDcf0q2LONZ5pda1l
         DjUxzLTnAvpGKBcKDOLnRky0MeAGqgyJYtSZc4M+/7LrRlBaHiKmFM25TWE+w9it6ojS
         sqBun3pPGr4fft0PcpqBL6A7VNSXttJUYSuJTtvuf7YyZrPHO9WeO1oh4rvCQdMoaA9h
         MT2qzcWep/AZ8YVRNgS9Syt5hCg3nRugNpx2gfPYgClWUIrreBU+UmUwwDNuqijJi/uX
         oRYQ==
X-Gm-Message-State: AJIora8BK4BOEXumCUo9ZquRHwy7mA8ULb9bbIpVRnIIavdYgWg9UoAI
        f6dpvYR4uT44xKlnTtHx/5ryLKpYrpLgjZR9YaocEHWTumseFB+f/tj7/CnAix2oaGrgTUUmMvc
        gUqjpl1eTvzC/
X-Received: by 2002:a05:600c:4f4e:b0:39c:1bbb:734f with SMTP id m14-20020a05600c4f4e00b0039c1bbb734fmr24392318wmq.116.1655731269042;
        Mon, 20 Jun 2022 06:21:09 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1tUV9rvX4nJ/95jAvg8un3XPRTCFNataKSiPHHwW6CNr66NL+ZHJp2SoaoRMQsUv9XfU1sg3w==
X-Received: by 2002:a05:600c:4f4e:b0:39c:1bbb:734f with SMTP id m14-20020a05600c4f4e00b0039c1bbb734fmr24392306wmq.116.1655731268871;
        Mon, 20 Jun 2022 06:21:08 -0700 (PDT)
Received: from gator (cst2-173-67.cust.vodafone.cz. [31.30.173.67])
        by smtp.gmail.com with ESMTPSA id c5-20020a5d63c5000000b0020c5253d8c2sm12654052wrw.14.2022.06.20.06.21.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jun 2022 06:21:08 -0700 (PDT)
Date:   Mon, 20 Jun 2022 15:21:06 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Colton Lewis <coltonlewis@google.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        pbonzini@redhat.com, seanjc@google.com, vkuznets@redhat.com,
        thuth@redhat.com, maz@kernel.org
Subject: Re: [PATCH 2/4] KVM: selftests: Increase UCALL_MAX_ARGS to 7
Message-ID: <20220620132106.5vknwvcs3ja224tw@gator>
References: <20220615193116.806312-1-coltonlewis@google.com>
 <20220615193116.806312-3-coltonlewis@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220615193116.806312-3-coltonlewis@google.com>
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
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

Reviewed-by: Andrew Jones <drjones@redhat.com>

