Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C30D62E22C
	for <lists+kvm@lfdr.de>; Thu, 17 Nov 2022 17:43:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235038AbiKQQnF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Nov 2022 11:43:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231377AbiKQQnC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Nov 2022 11:43:02 -0500
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A34B12BDE
        for <kvm@vger.kernel.org>; Thu, 17 Nov 2022 08:43:01 -0800 (PST)
Received: by mail-pj1-x1031.google.com with SMTP id v3-20020a17090ac90300b00218441ac0f6so6305593pjt.0
        for <kvm@vger.kernel.org>; Thu, 17 Nov 2022 08:43:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=q+1xJSL3VM8iSFTsp03QupIowEq4+8/ya2A9qqSsvoI=;
        b=RQyoXwTi902pRB4zDgavW/fhzJf70JgPPHS5RHfnZffDn3tZsxaP9tb3KxFiW2hC1D
         TSiIYihwc16AKuWEr8Yo8b3BpXg4Zefk0kebJgvzLtHfyp4UJKVQFEhy+5qJZo1omqNO
         S6wcDbNeeZkFHQZaXONwy89UqGHKV+vvfqrwiDex7x/saTBaGRfc5MWnrwL3vXhJPMvC
         lGk6BXVG96Z1LAowso8GNgUcsddSAS1SyLUsN2SJTe4kpgaayGgKMGeSPqht1Mgh/DpT
         OGYb5Cw7PmFK2S7+Fmz1c8Lxf1uCmBR/8l1Aiym65U9dOKf03+QEkWVFcD9XG5GvMnGK
         SWmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=q+1xJSL3VM8iSFTsp03QupIowEq4+8/ya2A9qqSsvoI=;
        b=JQJj8Yoo0JPQ5+diiVesaYsV39saNL4IB+v6zRfNFTBt7vnJtV2/mK9TGnNAYRcmu3
         9RZLcnCVQRkDyEoJycpnBglHTSquSY8puoD9VwztCgyRvMr5trd8btD9cl7pIsW0eAUE
         40I7Xo5lDQ9ubulraoBpilI9WHDsfOYskWRqkGOw0k4QiOCS+M7TWLUX/0kuXAjR4WJI
         5YbEHQALkNo7ScHvQkrPhFlxRg3zH5/Q1fx8ILtZ0HmAOKMGR0z2LqUQ6cpXiPKKgCHk
         uH6jGz8IORjBBp4KUra3yk96GuULSzfdiht4uarZpzry5A0hZnKGlFrhimtK+q6HiD6d
         bizg==
X-Gm-Message-State: ANoB5plBxpPmezwj9F3pGKceqfRZ37W+TXSLvNcXhaYOb00eN0e4YCN1
        k0caKnreZxU65l5zfXlqfxChCQ==
X-Google-Smtp-Source: AA0mqf4t3hfAZ/TWSOP6Gbe5YhlkNCqNAX1pjA/9HjdBlrbr7wiIDRtgkwwefkdOaviZiP+5DvH/hQ==
X-Received: by 2002:a17:902:8ecb:b0:186:fe2d:f3cb with SMTP id x11-20020a1709028ecb00b00186fe2df3cbmr3401553plo.132.1668703381052;
        Thu, 17 Nov 2022 08:43:01 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id y65-20020a626444000000b0056ee0d0985asm1372731pfb.82.2022.11.17.08.43.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Nov 2022 08:43:00 -0800 (PST)
Date:   Thu, 17 Nov 2022 16:42:57 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Borislav Petkov <bp@alien8.de>
Cc:     Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sandipan Das <sandipan.das@amd.com>,
        Daniel Sneddon <daniel.sneddon@linux.intel.com>,
        Jing Liu <jing2.liu@intel.com>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Wyes Karny <wyes.karny@amd.com>,
        Babu Moger <babu.moger@amd.com>,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Jim Mattson <jmattson@google.com>, x86@kernel.org,
        Santosh Shukla <santosh.shukla@amd.com>
Subject: Re: [PATCH 06/13] KVM: SVM: Add VNMI bit definition
Message-ID: <Y3Zkkc1edwYtpk+N@google.com>
References: <20221117143242.102721-1-mlevitsk@redhat.com>
 <20221117143242.102721-7-mlevitsk@redhat.com>
 <Y3ZHKVq8enyxJmVu@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y3ZHKVq8enyxJmVu@zn.tnic>
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

On Thu, Nov 17, 2022, Borislav Petkov wrote:
> On Thu, Nov 17, 2022 at 04:32:35PM +0200, Maxim Levitsky wrote:
> > @@ -5029,6 +5031,10 @@ static __init int svm_hardware_setup(void)
> >  		svm_x86_ops.vcpu_get_apicv_inhibit_reasons = NULL;
> >  	}
> >  
> > +	vnmi = vnmi && boot_cpu_has(X86_FEATURE_AMD_VNMI);
> 
> s/boot_cpu_has/cpu_feature_enabled/

Why?  This is rarely run code, won't cpu_feature_enabled() unnecessarily require
patching?

And while we're on the topic... https://lore.kernel.org/all/Y22IzA9DN%2FxYWgWN@google.com
