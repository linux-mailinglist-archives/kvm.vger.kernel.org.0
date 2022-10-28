Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 33343611BCF
	for <lists+kvm@lfdr.de>; Fri, 28 Oct 2022 22:50:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229918AbiJ1UuH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Oct 2022 16:50:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230081AbiJ1Utt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Oct 2022 16:49:49 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 637601274B
        for <kvm@vger.kernel.org>; Fri, 28 Oct 2022 13:49:39 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id c15-20020a17090a1d0f00b0021365864446so5546586pjd.4
        for <kvm@vger.kernel.org>; Fri, 28 Oct 2022 13:49:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=4ahIxp5E6zgmY5llvMRcLGXl/NPQN8b67iS1NzJiQ4g=;
        b=f9JfHYFunGGiulwrSHLagew+z+UplWS/odc9Hujt4kCZOWAxhUklZLpw9EJO6e50Uy
         5TbVX4hJgrCTbiT3HXvTewliqxAoFgjygjXFLLhH+6u6EQicfJ3NqGLew7R/bVZXtF11
         f8yQbUFcQoxfiwu1ZuQ1JP0h80R0CCcB+JlNBon7ZSK5Y5SdefibrydKMzKa/3PQRNqx
         02jmCwf2iuqc0Tq/vzCcX/dunyW7ZyCJLhXsow0UDJb/u+x8f7G43acn31YiF/ACxbzq
         s4GiKXzj9dxxPj5c5W99b5hTZBV/NpV99fDzAgIlQp2uyWIvC6aQ6S9TMb5OPQRRmu56
         D0yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4ahIxp5E6zgmY5llvMRcLGXl/NPQN8b67iS1NzJiQ4g=;
        b=n3Xf61D93J+1ShgLhPb6/76AYil6LYr/ZSIj3ctmJfYVJ9EUQZyf4o5dE3wHsiXjmq
         GYVbxqZ+u8DtBUB/o/jMxZ9Z2Hh0gCY3f1FJCVwU1ZzLxzHhQLaQVSHq+c8DRMFrefxv
         YadAxbEPgfNY/3m/1iqrHNqe5hAen+zbIaOTUAY1L4fYLtnAKEyBLQTfuoGZ50fzeHWg
         D7hCEN7wbSHmNLOs8H/aBVccN2Hvn2wL1BykRNRmkRsGplC2rmyPjpi5ab+4rRVueRYf
         RdackGo7tuT8vh1hr2d4UOPDBVEDgnX+QnixpGbUFzKiyn1UwNzVPc1sftPjVxDZn+nY
         wdhg==
X-Gm-Message-State: ACrzQf1tzC+Sa61ywlAmpqtzfmj8rgBukjH6MSG4Li9Ug82ikRHQMhlG
        HWdjEoPWgHMyAHfXB5wVK7c6ew==
X-Google-Smtp-Source: AMsMyM6Glu6sSyICcJkyXbPyf8ild7ksFSp1x5PWMbVMG1TLY+XHCzKbNMggcgYyNa1VpboWEgsc0Q==
X-Received: by 2002:a17:903:26ce:b0:186:9029:fa22 with SMTP id jg14-20020a17090326ce00b001869029fa22mr858934plb.140.1666990178652;
        Fri, 28 Oct 2022 13:49:38 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id f4-20020a62db04000000b00560cdb3784bsm3240657pfg.60.2022.10.28.13.49.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Oct 2022 13:49:37 -0700 (PDT)
Date:   Fri, 28 Oct 2022 20:49:34 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Colton Lewis <coltonlewis@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, maz@kernel.org,
        dmatlack@google.com, oupton@google.com, ricarkol@google.com
Subject: Re: [PATCH v8 2/4] KVM: selftests: create -r argument to specify
 random seed
Message-ID: <Y1xAXtnQyTqbIMVE@google.com>
References: <20221027205631.340339-1-coltonlewis@google.com>
 <20221027205631.340339-3-coltonlewis@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20221027205631.340339-3-coltonlewis@google.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Oct 27, 2022, Colton Lewis wrote:
> diff --git a/tools/testing/selftests/kvm/lib/perf_test_util.c b/tools/testing/selftests/kvm/lib/perf_test_util.c
> index 9618b37c66f7..5f0eebb626b5 100644
> --- a/tools/testing/selftests/kvm/lib/perf_test_util.c
> +++ b/tools/testing/selftests/kvm/lib/perf_test_util.c
> @@ -49,6 +49,7 @@ void perf_test_guest_code(uint32_t vcpu_idx)
>  	uint64_t gva;
>  	uint64_t pages;
>  	int i;
> +	struct guest_random_state rand_state = new_guest_random_state(pta->random_seed + vcpu_idx);

This belong in the first patch that consumes rand_state, which I believe is patch 3.

lib/perf_test_util.c: In function ‘perf_test_guest_code’:
lib/perf_test_util.c:52:35: error: unused variable ‘rand_state’ [-Werror=unused-variable]
   52 |         struct guest_random_state rand_state = new_guest_random_state(pta->random_seed + vcpu_idx);
      |               
