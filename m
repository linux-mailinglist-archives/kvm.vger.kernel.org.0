Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C505F5F5CAE
	for <lists+kvm@lfdr.de>; Thu,  6 Oct 2022 00:28:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229711AbiJEW2r (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Oct 2022 18:28:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229472AbiJEW2o (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Oct 2022 18:28:44 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 823AB80F6D
        for <kvm@vger.kernel.org>; Wed,  5 Oct 2022 15:28:43 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id d10so316173pfh.6
        for <kvm@vger.kernel.org>; Wed, 05 Oct 2022 15:28:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=M1fZLmNvpFm4BWyA7YZYu5iP/s7IAG0Jy5+Kxho31tc=;
        b=akPD5cQKk592DT+rvrBhNJzINb0Vvi26BzLdRa1N0H040CEQRm15Sw7+tKtl1mTEQa
         /eBCfL0zMdMy80XiaVxjJN+cDobg9VKbXgoi7AFAj70uP3rrX+SyTPmZeHg5WfTikh74
         wDwa0CnxVo9N1PFBEECtmPUYSxq7SzYR2a9lvCSrR3emyGJXlJligiPziTN237atr2fH
         arKhdWdX3pp/iY4j2p7JQ1p1YWvNIki6l+Y9uJ/XHWJPnrwdZbINpgYKNQzSSwkAKhPl
         Kmb1Nz6ye0j7JMeArhuqu5qcbz3sFhiqv9YymGACfoj55S1ijylANapPShMWVWjcoC4M
         CQMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=M1fZLmNvpFm4BWyA7YZYu5iP/s7IAG0Jy5+Kxho31tc=;
        b=qI8Y7gy6sjUA/DqlmoBD6SNmKBqk94apshRiNkyh2K0BzKXN8zP/v3BRvIa45SfZ4E
         ltcYTOOhG5ijR7YJjR4gXykdMt8YKknTvr/4pxbchKfDXvAQ4K+q7QksrGord2H0vFrq
         h78w8WYixAVmY/z5ziWDe77SrwRmTLosvuWGn+hsuPwP2aIzhD6lzJp7rUiOnnFBp61x
         er+n9akLfNhG6ZuAAHmE/8/67+/S0xexaI/D2196rPpqz78JRuqiLzmFEymsTT3/thWf
         E0IAYv6TClR9Gl74ftsypM+9CfE2HQLl+R4ilpf2hHjaUc0/6afK/ZNcJ7JmMbwek3Qj
         QZew==
X-Gm-Message-State: ACrzQf3V/A9rrESAmrGNxzZzVj0lyn5EhWqDMzmN1QqyPzS+dfSBlrsj
        +lR4kBJPDDozzgaKsyD214ybxg==
X-Google-Smtp-Source: AMsMyM6c50U0ptieO3gXt88IsntRxPBnqGgaC3KHTH+Lq2JXDISZIM7J0TDXKIHlWoT16/+7bxV+yQ==
X-Received: by 2002:a63:ff5c:0:b0:434:dc60:73d with SMTP id s28-20020a63ff5c000000b00434dc60073dmr1786645pgk.136.1665008922940;
        Wed, 05 Oct 2022 15:28:42 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id 67-20020a620646000000b005604c1a0fbcsm8088728pfg.74.2022.10.05.15.28.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Oct 2022 15:28:42 -0700 (PDT)
Date:   Wed, 5 Oct 2022 22:28:38 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Like Xu <like.xu.linux@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH v3 08/13] x86/pmu: Add PDCM check before
 accessing PERF_CAP register
Message-ID: <Yz4FFub+k79nyALC@google.com>
References: <20220819110939.78013-1-likexu@tencent.com>
 <20220819110939.78013-9-likexu@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220819110939.78013-9-likexu@tencent.com>
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

On Fri, Aug 19, 2022, Like Xu wrote:
> From: Like Xu <likexu@tencent.com>
> 
> On virtual platforms without PDCM support (e.g. AMD), #GP
> failure on MSR_IA32_PERF_CAPABILITIES is completely avoidable.
> 
> Signed-off-by: Like Xu <likexu@tencent.com>
> ---
>  x86/pmu.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/x86/pmu.c b/x86/pmu.c
> index 4eb92d8..25fafbe 100644
> --- a/x86/pmu.c
> +++ b/x86/pmu.c
> @@ -669,7 +669,8 @@ int main(int ac, char **av)
>  
>  	check_counters();
>  
> -	if (rdmsr(MSR_IA32_PERF_CAPABILITIES) & PMU_CAP_FW_WRITES) {
> +	if (this_cpu_has(X86_FEATURE_PDCM) &&
> +	    (rdmsr(MSR_IA32_PERF_CAPABILITIES) & PMU_CAP_FW_WRITES)) {


pmu_pebs.c ends up with similar code.  Maybe add a helper?

  static inline u64 this_cpu_perf_capabilities(void)
  {
	if (!this_cpu_has(X86_FEATURE_PDCM))
		return 0;

	rdmsr(MSR_IA32_PERF_CAPABILITIES);
  }

Or even better, if we end up with a lib/pmu and something like "struct pmu_caps",
the RDMSR can be done once in the library's init routine.
