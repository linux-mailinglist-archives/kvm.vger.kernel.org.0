Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F4EC4EEEAC
	for <lists+kvm@lfdr.de>; Fri,  1 Apr 2022 15:59:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346607AbiDAOA6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Apr 2022 10:00:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229719AbiDAOA4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Apr 2022 10:00:56 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99E0D4C412
        for <kvm@vger.kernel.org>; Fri,  1 Apr 2022 06:59:06 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id jx9so2477679pjb.5
        for <kvm@vger.kernel.org>; Fri, 01 Apr 2022 06:59:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=vINCBhX/7V/5MbVjKTcLLNhSCyxfRcucmANL3gsUx+c=;
        b=kgoUwoh6UHXaBaA6YYZCcgdkNvoc15wi7vSzTTqulnHcMOVeuIFhIf/jCWzNDWRIDW
         Zp8miYwkjL24BUhdbwxFu7MbiqL2t+lq0iMHCS+J06BNN/nlWQ+NXba27kWz6+vpPKKN
         +xKDC/38TJb7+1r3HiXiuOrQMqlW/bzUF+RpJQpkCXVmnE+AkgCMZJNzF2dIENsVp1qt
         51KuvPeZfuGH1CnRfNWH6blMVnA83mgMKm2BA5mvt5kr1nanrlxRCB81uvyHEl+JeFc2
         LxqmtrNrjqTFqn4keU661u8EK0qc3N0JtZBYSCgczj9IBc2xDprdLRw30raFx21gvKI9
         TtEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=vINCBhX/7V/5MbVjKTcLLNhSCyxfRcucmANL3gsUx+c=;
        b=KWQMa76J6YQ/H4AgXg+4Zdua2gU40yOTcS5vwZmeFAiuJ2PZOHK9oESA7MGdPU5R7B
         C4kvkddcW7Qcjg7qnhy849fXbVuWB6iQNrBxkXw6If6uLTjZdMdTcrXmGeRONkRv2mbA
         nPVVhGG91GEA7L8vhMr70h2x4IQY4rc55ZuP1US0WN6H5Jvucio60qwyhP+iNOBz1J0P
         WEGruK2m7fttNSIxVxiOzwD+ijIaqHD1WlumIUp9R+uEpTU9HCYcRSWxw7ccS9D4lHd0
         mkWkcSFo4zXLRlE3C8cbxbFPYJID53gXjtDWDC3u/+9XzlmUuegZdsl7UxXuDEVNyUdA
         3IOw==
X-Gm-Message-State: AOAM5308gay1hOO/00G+3/SA5R6CWtOTkUZTNpNgpNND/n++AY+L98rD
        sjXy8feX9HFCANw6iAPbevhsbg==
X-Google-Smtp-Source: ABdhPJzLqHePrkY/XZw4LtIr0qcnGq2xNXtmMhGv2XKvY6gEsdiOQBz+EHAXrwVP8F0HA3xy02hygg==
X-Received: by 2002:a17:90b:4c08:b0:1c7:61ce:b707 with SMTP id na8-20020a17090b4c0800b001c761ceb707mr12061015pjb.16.1648821545937;
        Fri, 01 Apr 2022 06:59:05 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id s3-20020a056a00194300b004f6664d26eesm3308345pfk.88.2022.04.01.06.59.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Apr 2022 06:59:05 -0700 (PDT)
Date:   Fri, 1 Apr 2022 13:59:01 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     cgel.zte@gmail.com
Cc:     pbonzini@redhat.com, vkuznets@redhat.com, wanpengli@tencent.com,
        jmattson@google.com, joro@8bytes.org, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, hpa@zytor.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Lv Ruyi <lv.ruyi@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
Subject: Re: [PATCH] KVM: x86/mmu: remove unnecessary flush_workqueue()
Message-ID: <YkcFJZW0r+OQmQwz@google.com>
References: <20220401083530.2407703-1-lv.ruyi@zte.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220401083530.2407703-1-lv.ruyi@zte.com.cn>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Apr 01, 2022, cgel.zte@gmail.com wrote:
> From: Lv Ruyi <lv.ruyi@zte.com.cn>
> 
> All work currently pending will be done first by calling destroy_workqueue,
> so there is unnecessary to flush it explicitly.
> 
> Reported-by: Zeal Robot <zealci@zte.com.cn>

Good bot :-)

> Signed-off-by: Lv Ruyi <lv.ruyi@zte.com.cn>
> ---
>  arch/x86/kvm/mmu/tdp_mmu.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index a2f9a34a0168..b822677ee3da 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -51,7 +51,6 @@ void kvm_mmu_uninit_tdp_mmu(struct kvm *kvm)
>  	if (!kvm->arch.tdp_mmu_enabled)
>  		return;
>  
> -	flush_workqueue(kvm->arch.tdp_mmu_zap_wq);

Might be worth adding a comment calling out that this drains the queue.  Either way,

Reviewed-by: Sean Christopherson <seanjc@google.com>
