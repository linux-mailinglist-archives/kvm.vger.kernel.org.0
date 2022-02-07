Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01B664AC82D
	for <lists+kvm@lfdr.de>; Mon,  7 Feb 2022 19:03:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242367AbiBGSDd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Feb 2022 13:03:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238963AbiBGR4m (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Feb 2022 12:56:42 -0500
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92123C0401DA
        for <kvm@vger.kernel.org>; Mon,  7 Feb 2022 09:56:42 -0800 (PST)
Received: by mail-pf1-x433.google.com with SMTP id g8so4425009pfq.9
        for <kvm@vger.kernel.org>; Mon, 07 Feb 2022 09:56:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ETIFP07SP/TaaaC7o85g2t9HzBYeDg4pndm8e/jG5Lo=;
        b=J6KNvjnq6cF3QqdIwkXT1M8ORFE/6WpxZMR4p7GrgA3uRjJmxjGoiRIilv8usw+tfL
         Idr8aJ6MfwrAo9sQfHCLeBjfJZxyUJsj0USeAqtsJW23T97qdBpNqVufVSqxk4iiKa/l
         R3yTuUKXrwc0rGxdNvlkawPS1XsekdKNnWzdhlXI5/u8hg2ZgOFRRu44/x8X12Ys87FL
         yoJueBvGKpKADn5dVu99CeOql3E3d+Mok7IM6zryf3HxTcxVuPO3HI2WMBknlSVc19cy
         a4U700wg4oW3p87RVx56DYzqxhrCIb7Kbh8iiVhXmR9ABeYWFBJ/B262OGAAm7PCccfF
         caUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ETIFP07SP/TaaaC7o85g2t9HzBYeDg4pndm8e/jG5Lo=;
        b=mxTbi7as+j30SjxC/k6YwsVyMuL/DRA8vXbY6zoW/DlcV7zlPYL8QNbPsCvbU4WCda
         HYCGQ8mq2yONg+VMXaZ50QeuyE+rkcklolYzBN5cW0zcgd89QSJKhyOI3s/nX3cObGRa
         qqYDVbQzW5gqd4lhFeTzfQX3QNtEdkKMsGXjHCSNOgL1Z/04efPvfQdFolxVvRcLzcPU
         cYd3facCfoO/qWGOtkWcWmKxeG1R2XixsRz4OCuWrjoL6H1C7+p6nsdePioLPaiA+ghJ
         efMUf3tG0K8LArymqFJmFPa3fa97WaTCTReIXnO/EMB3+ptRHBe9pWi1jEYTJ5LqVrhQ
         gIFQ==
X-Gm-Message-State: AOAM530GIMJAwikU/Uw+CwNJuPJVER89rrZr05lJGm4DbtZGq09ug4xc
        nt1abMIuKZPBKq72QU2IAnIiTg==
X-Google-Smtp-Source: ABdhPJw9zTj9wjitrb8gyyv5HkXnddCKMH3UK+X2OD+zcTDWnh5bLZ6rJTnIEpRpHMzh+aM85Q0Baw==
X-Received: by 2002:a05:6a00:14c9:: with SMTP id w9mr509546pfu.69.1644256601964;
        Mon, 07 Feb 2022 09:56:41 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id d15sm12378076pfu.127.2022.02.07.09.56.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Feb 2022 09:56:41 -0800 (PST)
Date:   Mon, 7 Feb 2022 17:56:38 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Oliver Upton <oupton@google.com>
Cc:     kernel test robot <lkp@intel.com>, kvm@vger.kernel.org,
        kbuild-all@lists.01.org, Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: Re: [PATCH v2 3/7] KVM: nVMX: Roll all entry/exit ctl updates into a
 single helper
Message-ID: <YgFdVivGFRjXVOfo@google.com>
References: <20220204204705.3538240-4-oupton@google.com>
 <202202051529.y26BVBiF-lkp@intel.com>
 <CAOQ_QsgWzfe-2-d709NFycJ_CpeBGR3Up4f9ORFseUCWMB=_UQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ_QsgWzfe-2-d709NFycJ_CpeBGR3Up4f9ORFseUCWMB=_UQ@mail.gmail.com>
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

On Sat, Feb 05, 2022, Oliver Upton wrote:
> On Fri, Feb 4, 2022 at 11:44 PM kernel test robot <lkp@intel.com> wrote:
> > >> ERROR: modpost: "kvm_pmu_is_valid_msr" [arch/x86/kvm/kvm-intel.ko] undefined!
> 
> Argh... Local tooling defaults to building KVM nonmodular so I missed this.
> 
> Squashing the following in fixes the issue.
> 
> --
> diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
> index f614f95acc6b..18430547357d 100644
> --- a/arch/x86/kvm/pmu.c
> +++ b/arch/x86/kvm/pmu.c
> @@ -396,6 +396,7 @@ bool kvm_pmu_is_valid_msr(struct kvm_vcpu *vcpu, u32 msr)
>         return kvm_x86_ops.pmu_ops->msr_idx_to_pmc(vcpu, msr) ||
>                 kvm_x86_ops.pmu_ops->is_valid_msr(vcpu, msr);
>  }
> +EXPORT_SYMBOL_GPL(kvm_pmu_is_valid_msr);

I'd much prefer to avoid this mess entirely.

[*] https://lore.kernel.org/all/20220128005208.4008533-9-seanjc@google.com
