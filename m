Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 913624DDFF8
	for <lists+kvm@lfdr.de>; Fri, 18 Mar 2022 18:31:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239507AbiCRRcp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Mar 2022 13:32:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233290AbiCRRcm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Mar 2022 13:32:42 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9130180047
        for <kvm@vger.kernel.org>; Fri, 18 Mar 2022 10:31:22 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id d19so10023814pfv.7
        for <kvm@vger.kernel.org>; Fri, 18 Mar 2022 10:31:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=2MkPp5rz5yZTi1j0z10QZloHTdL88Uou16AjDa3o5sY=;
        b=SDQEBNki5gKAYc9bZ170XzbgZxvrP3s/hPC6jgXzN+LL3CWOhXRJQlo8PLKbrcXXTC
         EvbihEAiNZRsj9rerE4kUD7dDyvwepEMudAaCakGnF6PB44UcalJ61c9NCxk1pdspwwN
         kgtrDPIu98m8SnYdNgjshWljc5qdWkrkS6O093/NxOWw4SSoYXxiEtiZGAg7psb6u+3b
         VhvQtWPVKgshdDWBBgY/4c43pLNvHumXf5mWzwhwUiBYuhzQm/BQPa3rrRF9VASJQfwX
         0RHIMe8hiaPNPcoOIgMKD2l1Gz1xnwJgdzxbiVjp+QBU5/E8piKn8VzdlPFAG1frWPrB
         qV9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=2MkPp5rz5yZTi1j0z10QZloHTdL88Uou16AjDa3o5sY=;
        b=i7kWLKYJNJGhF7m+nMtWsfX/wrRHI5pakKXIRApy2m2rxiTXanViJo7qBFRjKfwpSP
         Kk8x+WF9VHf4LfitGxMCfYDGp1iKfRcijeTlkj6DUQCKqWG+Kr2TYjVZS+CXFJgypUZ7
         2NHc1keh2tdnVLdDWZeXyU+o2Myusl1LDCkxFGeyveE8LRH9u74TAdR9QHWf409LFdD9
         3315MwJAUilF3w3pzzKufcRUiUk1CE/HXdC1ISk5xGP1UEuzpRCb7LZ4VDncJ4oe02Gr
         21hLcvbcPSUa1mtBuojczQGbuhMokHiokLbKXurrln9fGQyAHaLlYytnEik87OcHcWKU
         8jEg==
X-Gm-Message-State: AOAM533aIOEXB+TjaIhgYBS9b7AK3t1iYnPKMG2poeeyKSFzoyIHPIj4
        Ot98K+emqE1eLa5tdZK5xLc=
X-Google-Smtp-Source: ABdhPJz7Liou2+xomDe/pZPrfIFcOCXmxO8o0BS6BktnOwY8LmTCcN9/V2UBfZPHusPo7Fn3nyk/YQ==
X-Received: by 2002:a05:6a00:2816:b0:4fa:6ca4:1e70 with SMTP id bl22-20020a056a00281600b004fa6ca41e70mr5175192pfb.85.1647624682417;
        Fri, 18 Mar 2022 10:31:22 -0700 (PDT)
Received: from localhost ([192.55.54.52])
        by smtp.gmail.com with ESMTPSA id hk1-20020a17090b224100b001b8cff17f89sm8796649pjb.12.2022.03.18.10.31.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Mar 2022 10:31:22 -0700 (PDT)
Date:   Fri, 18 Mar 2022 10:31:20 -0700
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Philippe Mathieu-Daud??? <f4bug@amsat.org>,
        Richard Henderson <richard.henderson@linaro.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Cornelia Huck <cohuck@redhat.com>,
        "Daniel P. Berrang???" <berrange@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Laszlo Ersek <lersek@redhat.com>,
        Gerd Hoffmann <kraxel@redhat.com>,
        Eric Blake <eblake@redhat.com>, isaku.yamahata@intel.com,
        kvm@vger.kernel.org, Connor Kuehl <ckuehl@redhat.com>,
        seanjc@google.com, qemu-devel@nongnu.org, erdemaktas@google.com,
        isaku.yamahata@gmail.com
Subject: Re: [RFC PATCH v3 33/36] i386/tdx: Only configure MSR_IA32_UCODE_REV
 in kvm_init_msrs() for TDs
Message-ID: <20220318173120.GB4050087@ls.amr.corp.intel.com>
References: <20220317135913.2166202-1-xiaoyao.li@intel.com>
 <20220317135913.2166202-34-xiaoyao.li@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220317135913.2166202-34-xiaoyao.li@intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Mar 17, 2022 at 09:59:10PM +0800,
Xiaoyao Li <xiaoyao.li@intel.com> wrote:

> For TDs, only MSR_IA32_UCODE_REV in kvm_init_msrs() can be configured
> by VMM, while the features enumerated/controlled by other MSRs except
> MSR_IA32_UCODE_REV in kvm_init_msrs() are not under control of VMM.
> 
> Only configure MSR_IA32_UCODE_REV for TDs.

non-TDs?
-- 
Isaku Yamahata <isaku.yamahata@gmail.com>
