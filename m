Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B452611CB4
	for <lists+kvm@lfdr.de>; Fri, 28 Oct 2022 23:51:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230104AbiJ1VvE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Oct 2022 17:51:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230118AbiJ1Vu7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Oct 2022 17:50:59 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E32E4224AA8
        for <kvm@vger.kernel.org>; Fri, 28 Oct 2022 14:50:57 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id q1-20020a17090a750100b002139ec1e999so1287212pjk.1
        for <kvm@vger.kernel.org>; Fri, 28 Oct 2022 14:50:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=pG/BrenBw6hgCxl5VhkXR4NOktBVnqSpzLQKA/jc4WY=;
        b=qVqGZ7aaO2HKyF1pQGZKNYs2OdSBsXClFZDS6w+gW97w8QpSwIbXi3Dm5qskF67ZNA
         brxIBVT6RsRsVWniQcAapkXGBRbVr7m9TXLiE5BqirQ1ZClWrnykTdWvOAr33gzd3Qev
         vw7j4aOn39vTlaEdu8+ONgKdVyAISotCj8NmJZc5/27lLaGXBza7bfpP9dzGgL1oE+GM
         xI5A/QDguNixbZTvyaer1wCBGxzlR8JoQQV/LwGzPcdTNw8+HVQyh8QeulZsdCQy0Ata
         FLPu0gBVq7FnR/C4h7tOh2jjK/CSbQALqrrHDYg0htmpV6pTTttjK9rT5vKMwkAYu+6J
         FMrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pG/BrenBw6hgCxl5VhkXR4NOktBVnqSpzLQKA/jc4WY=;
        b=T106WmRdapT9eiV8obufD20RvGQxGbYU9UrObPBsxxW1mHJQ6QIg2hb3+3gVHx3kH/
         kIkDYYn8jjIkHeS56ifyZ7YDGdchWVs8WC8Minpx9EN1HQmkys0XNjW+Ho7zdg2LF/cF
         2e6zVldhX49t+zLdDFQYX0FnZIZDtQ1YsghX9qqlSj+SgmmV1j1pTba7kLw15KdWjMwx
         QPQFu4MYwUTDLOofOY4bBGk9eZvmerBhM9gUg1SFGMZafbhNhl610ocYLaAZRsxlQ34/
         qg10Bqk65o3VWskJmsgsEux9yZj+KmjDHtz08I2hgKC2NfUpSPtTJrOTV46sXuDkXKeC
         hDfw==
X-Gm-Message-State: ACrzQf0PXKyEiY52f7aQMD3SUsM2Jw9PstO9CZ0KJW9unX+hk7L8LeSK
        cL6zdybrn9lMQ4QpMomOuEFl6roo0uLU2Q==
X-Google-Smtp-Source: AMsMyM77Hu+kQXVD2Znf2MADHP7hOBP37HY0GeoPra14lB6uMIeEzd8Wd3mftiTMar6hwpXIsz3A8w==
X-Received: by 2002:a17:902:e5c6:b0:186:c3b1:bae5 with SMTP id u6-20020a170902e5c600b00186c3b1bae5mr1108108plf.151.1666993857332;
        Fri, 28 Oct 2022 14:50:57 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id i126-20020a626d84000000b00561d79f1064sm3272544pfc.57.2022.10.28.14.50.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Oct 2022 14:50:56 -0700 (PDT)
Date:   Fri, 28 Oct 2022 21:50:53 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Aaron Lewis <aaronlewis@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, jmattson@google.com
Subject: Re: [PATCH] KVM: x86: Fix a stall when KVM_SET_MSRS is called on the
 pmu counters
Message-ID: <Y1xOvenzUxFIS0iz@google.com>
References: <20221028130035.1550068-1-aaronlewis@google.com>
 <Y1wCqAzJwvz4s8OR@google.com>
 <CAAAPnDEda-FBz+3suqtA868Szwp-YCoLEmK1c=UynibTWCU1hw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAAPnDEda-FBz+3suqtA868Szwp-YCoLEmK1c=UynibTWCU1hw@mail.gmail.com>
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

On Fri, Oct 28, 2022, Aaron Lewis wrote:
> On Fri, Oct 28, 2022 at 4:26 PM Sean Christopherson <seanjc@google.com> wrote:
> >
> > On Fri, Oct 28, 2022, Aaron Lewis wrote:
> > @@ -3778,16 +3775,13 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
> >
> >     case MSR_K7_PERFCTR0 ... MSR_K7_PERFCTR3:
> >     case MSR_P6_PERFCTR0 ... MSR_P6_PERFCTR1:
> > -        pr = true;
> > -        fallthrough;
> >     case MSR_K7_EVNTSEL0 ... MSR_K7_EVNTSEL3:
> >     case MSR_P6_EVNTSEL0 ... MSR_P6_EVNTSEL1:
> >         if (kvm_pmu_is_valid_msr(vcpu, msr))
> >             return kvm_pmu_set_msr(vcpu, msr_info);
> >
> > -        if (pr || data != 0)
> > -            vcpu_unimpl(vcpu, "disabled perfctr wrmsr: "
> > -                  "0x%x data 0x%llx\n", msr, data);
> > +        if (data)
> > +            kvm_pr_unimpl_wrmsr(vcpu, msr, data);
> 
> Any reason to keep the check for 'data' around?  Now that it's
> checking for 'report_ignored_msrs' maybe we don't need that check as
> well.  I'm not sure what the harm is in removing it, and with this
> change we are additionally restricting pmu counter == 0 from printing.

Checking 'dat' doesn't restrict counter 0, it skips printing if the guest (or host)
is writing '0', e.g. it would also skip the case you encountered where the host is
blindly "restoring" unused MSRs.

Or did I misunderstand your comment?
