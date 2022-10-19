Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B5FC605365
	for <lists+kvm@lfdr.de>; Thu, 20 Oct 2022 00:50:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230032AbiJSWuC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Oct 2022 18:50:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229552AbiJSWuA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Oct 2022 18:50:00 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 360C7F01B3
        for <kvm@vger.kernel.org>; Wed, 19 Oct 2022 15:49:54 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id f23so18627805plr.6
        for <kvm@vger.kernel.org>; Wed, 19 Oct 2022 15:49:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=kWGT42KwMXWX98bFcRKI+EBCPeifJQr7+E9O+q7XiKs=;
        b=bxIgAOcl0HTRwTLa9nfyg4u3WCqDdMXrZXfM+Q+ccg9D3BRYCfake4k6Z3R7EcMBeG
         9lDsj6xCxBXD1/nyUQbeVcmzuAKRe492k6OMRnnrO8c88yYQl7tlIs8Qo2w4kSy3cV7h
         FHYMCMS/n2yjlBM7cMtOYd7kJ+FoSJ7IMmPRJv36zw4bmN/2KnbLThfmXUsgg/KF+Q4P
         QuY/zOT1k73QfadenpmX93oCSKU1/q8N3uJJB/6qZuduSSAoT0freezfpMcwTaSad8kt
         y5fx8bqh9N9jyvUtS+2DnnnVafunKhh+X/wU1kOjMy9p4TFcOYJok9Ts+f9zAcgAsp4L
         SzjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kWGT42KwMXWX98bFcRKI+EBCPeifJQr7+E9O+q7XiKs=;
        b=1zMWLJcDLP3bQVRCPVRPKOAyuXAFaYyhvGoOv81z6QBgpFIvTSleXetlBLwuMFM+Mw
         +OmEmJ8w6g1PNW/Bl1wLqywbU/RqDo7UNCWsYj8l5p41kCg+gxakGhY5bFJv3hQF0wHI
         THpT6HVyd9Pq8bEl2akaLZ5e7c22wxXuBsKkVPK3lxHqS8/4ezS0E0inHGiMJHPzYbAa
         nJjCESiUIU7nfgKW9iXqIipcHHrFGt7a7yHDeF35o7gq+Kz55eUC3n0bnzf9XWDQHCP8
         kitQBSNPxjQQIMEnNkum5LvWXmjstc397NgcdL3DCP3wJ2MhD3g5GUUZWbiEYvKAD6W0
         jX7A==
X-Gm-Message-State: ACrzQf09XKHN/fp+733amxv9c8nN1GsG78m5ZT+5kSxVVUud0PZ9t15+
        qTJjDlPVKb8oE/KY6N6v3Z9aCoustSmoWg==
X-Google-Smtp-Source: AMsMyM7NuSdJYZ1jEUkYq9bBX56Fhj4JcS2b8wusaZm+Keob4usMONm01sgk/eyfPmWNB5/MnBzMXg==
X-Received: by 2002:a17:902:f806:b0:184:4a8c:f91f with SMTP id ix6-20020a170902f80600b001844a8cf91fmr10836074plb.45.1666219793781;
        Wed, 19 Oct 2022 15:49:53 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id k6-20020a17090a4c8600b00211923b8edesm144605pjh.40.2022.10.19.15.49.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Oct 2022 15:49:53 -0700 (PDT)
Date:   Wed, 19 Oct 2022 22:49:49 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Jim Mattson <jmattson@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com
Subject: Re: [PATCH 3/6] KVM: x86: Mask off reserved bits in CPUID.80000008H
Message-ID: <Y1B/DW6anKV4oGG1@google.com>
References: <20220929225203.2234702-1-jmattson@google.com>
 <20220929225203.2234702-3-jmattson@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220929225203.2234702-3-jmattson@google.com>
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

On Thu, Sep 29, 2022, Jim Mattson wrote:
> KVM_GET_SUPPORTED_CPUID should only enumerate features that KVM
> actually supports. The following ranges of CPUID.80000008H are reserved
> and should be masked off:
>     EDX[31:18]
>     EDX[11:8]

Changelog says EDX, code and APM says ECX.

> Fixes: 24c82e576b78 ("KVM: Sanitize cpuid")
> Signed-off-by: Jim Mattson <jmattson@google.com>
> ---
>  arch/x86/kvm/cpuid.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index 90f9c295825d..15318f3f415e 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -1156,6 +1156,7 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
>  
>  		entry->eax = g_phys_as | (virt_as << 8);
>  		entry->edx = 0;
> +		entry->ecx &= ~(GENMASK(31, 18) | GENMASK(11, 8));

Would it makes sense to also zero out the PerfTscSize bits?  KVM doesn't emulate
MSR_F15H_PTSC.

Uber nit, ECX comes before EDX in both alphabetical and register index order :-D

>  		cpuid_entry_override(entry, CPUID_8000_0008_EBX);
>  		break;
>  	}
> -- 
> 2.38.0.rc1.362.ged0d419d3c-goog
> 
