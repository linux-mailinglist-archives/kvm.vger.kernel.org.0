Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F37EF5754E2
	for <lists+kvm@lfdr.de>; Thu, 14 Jul 2022 20:24:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240611AbiGNSYE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Jul 2022 14:24:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240438AbiGNSYD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Jul 2022 14:24:03 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45443E1A
        for <kvm@vger.kernel.org>; Thu, 14 Jul 2022 11:24:01 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id bh13so2318853pgb.4
        for <kvm@vger.kernel.org>; Thu, 14 Jul 2022 11:24:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=tiWgUvy6b45CWDd/HT0PEWri5Zoyvp2wLT2egCbCO20=;
        b=dIgBlRTqASHmCeIp8hmpFhrD3seWd7DxAiOdzSeHp+7sX7MDEiFRNz8a8T3N+vmkot
         sIdhzb4rEGsicPy4lOlEMfn2SYjmuwI1PXT4tvYyXt5HNdKvYs0OZejBtdXC3RLyXM9D
         Z2+QYX5QY/xUCjm4iPLDr7a06j0UoiTX4x51UH6u0eeVIHOBQMq1nnqUHycEOM3aHNTW
         WJVCgX4nNtiS9Z8bWZwpQp4UiMwz7Dk3Vddq7vkfYZUQtN2TaiOCin+zMtujmGxGqXth
         TBAUphWaCI98VSautIghtaipwWw7VPJs6T+UKNotPA09/FdTUazxT16+J025lTS03R9U
         7oaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=tiWgUvy6b45CWDd/HT0PEWri5Zoyvp2wLT2egCbCO20=;
        b=hHFnzuX3n0F06gzevcPrEsG1CoBYP138pae6gqnkNUoA9l8eHnk/pbqqMY7RuYYh9s
         FUI6k+GbiVLnUjBoJ2fubyMIn4wXVrxN55uxTDI//3uloBBISvf0NBMFX7bY9BZNciiI
         zm9IZtTSWBtGopOALlqZYPxjvhHPwKwwQYS/l8n9jiYZVx0IB5HN+xeBKKj0WUpJ5FzR
         t/Q5fphx+hq470MVfpiDIdwFutKM1lcnFbwrjci59vzkbkx4gTIXsI6GnU9405y6ykw+
         N5xnptMMY1Up52xhuoUhPNDBtqBQTQh6fopm2gvMO9ZpbIGSHGCkAVza6aC6kMD9ccp6
         T8sA==
X-Gm-Message-State: AJIora/Xrlc9RICrtrcX2m+Cp9U6U5h+4qmR/Yn1eS9vCANeacR+QLsl
        8yY+EoR5HMBKQjUeTsGJE9pFBg==
X-Google-Smtp-Source: AGRyM1uKKKEi+IB/5nUXTWYTX6nYjrjrDJBfbWsUyGJS+AJ5g/0MPb81ZtQTUmLBgQSZY+WbkrwC2g==
X-Received: by 2002:a63:d1e:0:b0:40d:379e:bff8 with SMTP id c30-20020a630d1e000000b0040d379ebff8mr8987266pgl.215.1657823040721;
        Thu, 14 Jul 2022 11:24:00 -0700 (PDT)
Received: from google.com (123.65.230.35.bc.googleusercontent.com. [35.230.65.123])
        by smtp.gmail.com with ESMTPSA id md11-20020a17090b23cb00b001f10b31e7a7sm156628pjb.32.2022.07.14.11.24.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Jul 2022 11:24:00 -0700 (PDT)
Date:   Thu, 14 Jul 2022 18:23:57 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Peter Xu <peterx@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] KVM: x86/mmu: Defer "full" MMU setup until after
 vendor hardware_setup()
Message-ID: <YtBfPU4lhPbuDJ3y@google.com>
References: <20220624232735.3090056-1-seanjc@google.com>
 <20220624232735.3090056-3-seanjc@google.com>
 <Ys3uDJ90dBeFFbka@xz-m1.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Ys3uDJ90dBeFFbka@xz-m1.local>
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

On Tue, Jul 12, 2022, Peter Xu wrote:
> On Fri, Jun 24, 2022 at 11:27:33PM +0000, Sean Christopherson wrote:
> > @@ -11937,6 +11932,10 @@ int kvm_arch_hardware_setup(void *opaque)
> >  
> >  	kvm_ops_update(ops);
> >  
> > +	r = kvm_mmu_hardware_setup();
> > +	if (r)
> > +		goto out_unsetup;
> > +
> >  	kvm_register_perf_callbacks(ops->handle_intel_pt_intr);
> >  
> >  	if (!kvm_cpu_cap_has(X86_FEATURE_XSAVES))
> > @@ -11960,12 +11959,18 @@ int kvm_arch_hardware_setup(void *opaque)
> >  	kvm_caps.default_tsc_scaling_ratio = 1ULL << kvm_caps.tsc_scaling_ratio_frac_bits;
> >  	kvm_init_msr_list();
> >  	return 0;
> > +
> > +out_unsetup:
> > +	static_call(kvm_x86_hardware_unsetup)();
> 
> Should this be kvm_mmu_hardware_unsetup()?  Or did I miss something?..

There is no kvm_mmu_hardware_unsetup().  This path is called if kvm_mmu_hardware_setup()
fails, i.e. the common code doesn't need to unwind anything.

The vendor call is not shown in the patch diff, but it's before this as:

	r = ops->hardware_setup();
	if (r != 0)
		return r

there's no existing error paths after that runs, which is why the vendor unsetup
call is new.
