Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9478757C1BD
	for <lists+kvm@lfdr.de>; Thu, 21 Jul 2022 02:51:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230014AbiGUAvj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Jul 2022 20:51:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229510AbiGUAvi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Jul 2022 20:51:38 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68A254BD25
        for <kvm@vger.kernel.org>; Wed, 20 Jul 2022 17:51:37 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id o5-20020a17090a3d4500b001ef76490983so27308pjf.2
        for <kvm@vger.kernel.org>; Wed, 20 Jul 2022 17:51:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=FfwW3SyUIE8ufwmauCmaTvP/1vZ1myX6djJgT87Pz2o=;
        b=q2qcmyUKJsPaH2wvPzQ/fimb9o4CHFBdfvcmL5kfM0CEEcipogcDFlARZyQPEM9sc1
         S3d8sV2cLSNXI2aXPONyziESQmppIDo6+ZVl7g3qe6k3VNnV6WKB//AuFoCswovdjIlR
         9Jz9wT5U086iuhO+RenB4Xe07ewjcpNLlEIDmZRbaOBjmbyqMrG8NeQU9S9w+t/1lqCc
         sKKgk99/duDaoJHNBsVqsDtSB6mBCBIuOY70NxILMLn6HLQ4pwoAoUlOTPnA/LgPjvyQ
         du52wFRmz4JejgxITQl3qp8eRsOQfySv03XT4pwn9GAeJgZ7PY82c9fVZJgB2psHN633
         qSOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=FfwW3SyUIE8ufwmauCmaTvP/1vZ1myX6djJgT87Pz2o=;
        b=mZCSF4D18JBnGBEdOGsMdzG4XZ9qTN4aXtBBCA7tYZl1hFpwnQXIVmVpizu9qCnBlr
         iSeZxKzbDCjVF8z6ztgz9cA1Zo7CNT6MxPxtiQ9x1uS1/QvYEJ8+X14Dv7LE06JgPEgT
         e1t2X+KspTEyPZigeVV0pqNug57EePDCUJEOEHzF2hYIulUuheYrIFgHgXCZ/K++9Gjh
         ypmFBhrOHO9CxpM9MsdWbB3qY+2M7zQnR/M9rw9AP1aki9LE5SgxFedtAbqrqxUC2ka8
         QqHWsRrcZDuzIh9JYn8WKVVBx73g4bWIixTVoCyTdnvz3qcVBgAGmmXmgguBNWah3gKx
         wrcg==
X-Gm-Message-State: AJIora9VUWTOBzc0qJTdnSDyXfrS720iQOMVFZC1aKsvVIRM9GzO0fJK
        FLjpr4yRGrIOvwyof3JitxRFXw==
X-Google-Smtp-Source: AGRyM1t7+rbX7J88JlrFrHbQ1VJx3OrZjxb+IcU1uOg6+LGM1lBzINlb2Cb61vUKevajOQKT7XqJ6Q==
X-Received: by 2002:a17:902:7106:b0:16c:6c95:6153 with SMTP id a6-20020a170902710600b0016c6c956153mr41012493pll.166.1658364696786;
        Wed, 20 Jul 2022 17:51:36 -0700 (PDT)
Received: from google.com (123.65.230.35.bc.googleusercontent.com. [35.230.65.123])
        by smtp.gmail.com with ESMTPSA id n7-20020a170903110700b0016bdeb58611sm178194plh.112.2022.07.20.17.51.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Jul 2022 17:51:36 -0700 (PDT)
Date:   Thu, 21 Jul 2022 00:51:32 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Like Xu <like.xu.linux@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Like Xu <likexu@tencent.com>
Subject: Re: [PATCH 4/7] KVM: x86/pmu: Not to generate PEBS records for
 emulated instructions
Message-ID: <YtijFDufUBR7buyv@google.com>
References: <20220713122507.29236-1-likexu@tencent.com>
 <20220713122507.29236-5-likexu@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220713122507.29236-5-likexu@tencent.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

"Don't" instead of "Not to".  Not is an adverb, not a verb itself.

On Wed, Jul 13, 2022, Like Xu wrote:
> From: Like Xu <likexu@tencent.com>
> 
> The KVM accumulate an enabeld counter for at least INSTRUCTIONS or

Probably just "KVM" instead of "the KVM"?

s/enabeld/enabled

> BRANCH_INSTRUCTION hw event from any KVM emulated instructions,
> generating emulated overflow interrupt on counter overflow, which
> in theory should also happen when the PEBS counter overflows but
> it currently lacks this part of the underlying support (e.g. through
> software injection of records in the irq context or a lazy approach).
> 
> In this case, KVM skips the injection of this BUFFER_OVF PMI (effectively
> dropping one PEBS record) and let the overflow counter move on. The loss
> of a single sample does not introduce a loss of accuracy, but is easily
> noticeable for certain specific instructions.
> 
> This issue is expected to be addressed along with the issue
> of PEBS cross-mapped counters with a slow-path proposal.
> 
> Fixes: 79f3e3b58386 ("KVM: x86/pmu: Reprogram PEBS event to emulate guest PEBS counter")
> Signed-off-by: Like Xu <likexu@tencent.com>
> ---
>  arch/x86/kvm/pmu.c | 11 ++++++++---
>  1 file changed, 8 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
> index 02f9e4f245bd..08ee0fed63d5 100644
> --- a/arch/x86/kvm/pmu.c
> +++ b/arch/x86/kvm/pmu.c
> @@ -106,9 +106,14 @@ static inline void __kvm_perf_overflow(struct kvm_pmc *pmc, bool in_pmi)
>  		return;
>  
>  	if (pmc->perf_event && pmc->perf_event->attr.precise_ip) {
> -		/* Indicate PEBS overflow PMI to guest. */
> -		skip_pmi = __test_and_set_bit(GLOBAL_STATUS_BUFFER_OVF_BIT,
> -					      (unsigned long *)&pmu->global_status);
> +		if (!in_pmi) {
> +			/* The emulated instructions does not generate PEBS records. */

This needs a better comment.  IIUC, it's not that they don't generate records,
it's that KVM is _choosing_ to not generate records to hack around a different
bug(s).  If that's true a TODO or FIXME would also be nice.

> +			skip_pmi = true;
> +		} else {
> +			/* Indicate PEBS overflow PMI to guest. */
> +			skip_pmi = __test_and_set_bit(GLOBAL_STATUS_BUFFER_OVF_BIT,
> +						      (unsigned long *)&pmu->global_status);
> +		}
>  	} else {
>  		__set_bit(pmc->idx, (unsigned long *)&pmu->global_status);
>  	}
> -- 
> 2.37.0
> 
