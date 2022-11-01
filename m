Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E5E9614EE0
	for <lists+kvm@lfdr.de>; Tue,  1 Nov 2022 17:11:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229763AbiKAQLj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Nov 2022 12:11:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229738AbiKAQLh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Nov 2022 12:11:37 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0A2D1C420
        for <kvm@vger.kernel.org>; Tue,  1 Nov 2022 09:11:36 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id b1-20020a17090a7ac100b00213fde52d49so3608254pjl.3
        for <kvm@vger.kernel.org>; Tue, 01 Nov 2022 09:11:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=3ITgL/aRZdkahYdq9DTxD5baxb+nL5G3z8cZ8xPGuJc=;
        b=CJ1VxDqaf9Mq8KLKTU/A+QxYzNu53X1nM+wAZlnLPjc1gho4lLM4XUpMehJM8DDm9F
         aW00iOdhxiGW/G28foJ25h0vdG7TBPH6KAdX8fdpsqb2bD3IgayOFRCs5ZIoelEcgT1C
         XvOrrWfcD82H3afoXY//lnlo9QBdlhdOsIfJNVCUewtcR9qTQw9axCGJvgBTelMZWcGW
         H8bfCyRh+7bFR9df4dkhsUrzEtJXR/ICnPgcycpyMfT46X2/4+X6m2oAtZshlYMJQani
         t4cfscIJ4KL6kstTrsWtdlqxy+UEhF5SgTLwrAYqjp8J3oVoyczJZ1Qded2Zmtv0b//0
         Fpbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3ITgL/aRZdkahYdq9DTxD5baxb+nL5G3z8cZ8xPGuJc=;
        b=rlFpD8pLxOFRZ99fx+JU+rEVkLUcwNAE4eAOgp5qpm66EG402/buHrBZ7SZU+qwSgW
         kJkJojWGwCl3JVOS0KPM6oSnOCvfZkKZP2tuiID3gPEA4/GBdXF14Cd1qS9qHPJjqWkg
         Dk7kKJ7nDzO2qHqV+RftBU2GCVwEiwnxyHU/n6UC33C5M8XY4CMAyTdSmxa8E2+VUBwd
         Y5ZiUENQVOtNe65aelPjNMZzewvOyvpEpKf+FmpAt3DqGV8mrIDopjeHAUQhmwVPCIsl
         xIsKsENLoeTOX9dLKFHXVSEY81v0UiIXd9XL0xZccQ4KIZ1lf9X799gyO0V+3LFriTe5
         D4zw==
X-Gm-Message-State: ACrzQf2Am3p7ouGpgf2fiU1e/m8Us6vY10TU0W+d4qg3Cod+xRxP20Ew
        J7OThyQk5nydPhmxp6mZbas8kQ==
X-Google-Smtp-Source: AMsMyM7B/QtilNm+zs8uSvatkt1ja+6hcaCbfnjwiz6Hx3546KbbHK5koU/ojF7ynJ84zmCv+/PO5A==
X-Received: by 2002:a17:90a:8a16:b0:213:bc0c:74cd with SMTP id w22-20020a17090a8a1600b00213bc0c74cdmr16564783pjn.28.1667319096284;
        Tue, 01 Nov 2022 09:11:36 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id x14-20020a62860e000000b0056c349f5c73sm6709027pfd.132.2022.11.01.09.11.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Nov 2022 09:11:35 -0700 (PDT)
Date:   Tue, 1 Nov 2022 16:11:32 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Siddharth Chandrasekaran <sidcha@amazon.de>,
        Yuan Yao <yuan.yao@linux.intel.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v13 45/48] KVM: selftests: Introduce rdmsr_from_l2() and
 use it for MSR-Bitmap tests
Message-ID: <Y2FFNO3Bu9Z3LtCW@google.com>
References: <20221101145426.251680-1-vkuznets@redhat.com>
 <20221101145426.251680-46-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221101145426.251680-46-vkuznets@redhat.com>
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

On Tue, Nov 01, 2022, Vitaly Kuznetsov wrote:
> Hyper-V MSR-Bitmap tests do RDMSR from L2 to exit to L1. While 'evmcs_test'
> correctly clobbers all GPRs (which are not preserved), 'hyperv_svm_test'
> does not. Introduce and use common rdmsr_from_l2() to avoid code
> duplication and remove hardcoding of MSRs.
> 
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> ---
>  .../selftests/kvm/include/x86_64/processor.h  |  9 +++++++
>  .../testing/selftests/kvm/x86_64/evmcs_test.c | 24 ++++---------------
>  .../selftests/kvm/x86_64/hyperv_svm_test.c    |  8 +++----
>  3 files changed, 17 insertions(+), 24 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/tools/testing/selftests/kvm/include/x86_64/processor.h
> index fbaf0b6cec4b..a14b7e4ea7c4 100644
> --- a/tools/testing/selftests/kvm/include/x86_64/processor.h
> +++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
> @@ -520,6 +520,15 @@ static inline void cpu_relax(void)
>  		"hlt\n"	\
>  		)
>  
> +/* Exit to L1 from L2 with RDMSR instruction */
> +static inline void rdmsr_from_l2(uint32_t msr)

I would prefer keeping this helper out of common x86-64 code, even if it means
duplicating code across multiple Hyper-V tests until the L1 VM-Enter/VM-Exit
sequences get cleaned up.  The name is misleading, e.g. it doesn't really read
the MSR since there are no outputs, and while we could obviously fix that with a
rename or a generic DO_VMEXIT_FROM_L2() macro, I would rather fix the underlying
problem of the world switches clobbering L2 state.  That way all the helpers that
exist for L1 can be used verbatim for L2 instead of needing dedicated helpers for
every instruction that is used to trigger a VM-Exit.
