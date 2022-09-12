Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D8E95B5BBF
	for <lists+kvm@lfdr.de>; Mon, 12 Sep 2022 16:00:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229498AbiILOAA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Sep 2022 10:00:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229821AbiILN76 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Sep 2022 09:59:58 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87CE2A1B4
        for <kvm@vger.kernel.org>; Mon, 12 Sep 2022 06:59:57 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id x1so8690529plv.5
        for <kvm@vger.kernel.org>; Mon, 12 Sep 2022 06:59:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=CBw2jRLKePbG0d1bevJk7MojLNgMrFNThWg3tV1196s=;
        b=ONa5FFh+7XdNOXJqog7pCFfGV1y84lnz1Bkx6emd+txO8rpTILAI28016lHiyvT1ZZ
         aZYXR7bV3a36XUkNV3C5SRic1rjL2m0pTdKZsutxFKpkBy2baFOqCSevxpsKiUezETXb
         ODtXSzSOWNLi7Yp7hhqVV0Hm+r4rKY0U0ISj5TkQu9h3GENiQ4D+fNWKChD+t440KFij
         ZvRHreX4JM89Yqt9MTMDR3y9df00KCTY7leDKkmoaVfFcnx3DzLlRNTDVLOJd1ub0Dnb
         zXm0goI9PrWGlLPx+OeLhC3ARgsYafctfiV8/qSzMzTKyLxzqSecULcpnEHxxwUg82Sf
         wqWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=CBw2jRLKePbG0d1bevJk7MojLNgMrFNThWg3tV1196s=;
        b=SUh6j5R78a0fwcrE4HWD1A3zmYzpyg1UuzrfAASYVX76lRrvd1hcsv/m5x6aAVTf5H
         Q2NnDtAStu4gWsKQdyPOmtKlJP04/uMWlwJjHAlyfW+f7XCTtwS7dVGb7IpnmmV8lyi9
         RqXVDxG8NFMKCC8W+bKB5hSbhanrmvjjRJb2AWM44Xz8EYhkAfFRWSdkKvAfIj9veqyQ
         p4haZQYNRYLnnuDdjJOQdO73/+pV9wGGGg9BeefEVeCcT+8iRMyQ2hWXZVV/ErEyIUDL
         eFLHkKIHDHj8K05RycYHoT3T6rG9XIYdDHCGel7E1J64D8OnWDK1oIo7M86ymBpyLEav
         iycw==
X-Gm-Message-State: ACgBeo3oHzKuTJ1ArZ5gIbDqKnq+dOgDErWZAqaHHs/oXSxlpTc7ZC4j
        0SBUPTdq/dfyjMS/QjCiDHCWAA==
X-Google-Smtp-Source: AA6agR445HG3r3qBDDzaVsSrHcRQkMnu4zhhjpAsfoxku52mXAIvKOxgtmC0dcX8Fqi2BnRGVrb9Cg==
X-Received: by 2002:a17:902:b20a:b0:172:7385:ea63 with SMTP id t10-20020a170902b20a00b001727385ea63mr27092536plr.54.1662991196920;
        Mon, 12 Sep 2022 06:59:56 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id 72-20020a62174b000000b0053eec4bb1b1sm5513780pfx.64.2022.09.12.06.59.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Sep 2022 06:59:56 -0700 (PDT)
Date:   Mon, 12 Sep 2022 13:59:53 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/3] KVM: selftests: Rename 'msr->availble' to
 'msr->should_not_gp' in hyperv_features test
Message-ID: <Yx87WXMXGzLxrT0f@google.com>
References: <20220831085009.1627523-1-vkuznets@redhat.com>
 <20220831085009.1627523-3-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220831085009.1627523-3-vkuznets@redhat.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 31, 2022, Vitaly Kuznetsov wrote:
> It may not be clear what 'msr->availble' means. The test actually
> checks that accessing the particular MSR doesn't cause #GP, rename
> the varialble accordingly.
> 
> Suggested-by: Maxim Levitsky <mlevitsk@redhat.com>
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> ---
>  .../selftests/kvm/x86_64/hyperv_features.c    | 92 +++++++++----------
>  1 file changed, 46 insertions(+), 46 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/x86_64/hyperv_features.c b/tools/testing/selftests/kvm/x86_64/hyperv_features.c
> index 79ab0152d281..4ec4776662a4 100644
> --- a/tools/testing/selftests/kvm/x86_64/hyperv_features.c
> +++ b/tools/testing/selftests/kvm/x86_64/hyperv_features.c
> @@ -33,7 +33,7 @@ static inline uint8_t hypercall(u64 control, vm_vaddr_t input_address,
>  
>  struct msr_data {
>  	uint32_t idx;
> -	bool available;
> +	bool should_not_gp;

I agree that "available" is a bit inscrutable, but "should_not_gp" is also odd.

What about inverting it to?

	bool gp_expected;

or maybe even just

	bool fault_expected;

and letting the assert define which vector is expected.
