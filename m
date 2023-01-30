Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A92346817DB
	for <lists+kvm@lfdr.de>; Mon, 30 Jan 2023 18:40:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236266AbjA3RkT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Jan 2023 12:40:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238116AbjA3RkM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 Jan 2023 12:40:12 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A78183D7
        for <kvm@vger.kernel.org>; Mon, 30 Jan 2023 09:40:10 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id e8-20020a17090a9a8800b0022c387f0f93so11196754pjp.3
        for <kvm@vger.kernel.org>; Mon, 30 Jan 2023 09:40:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=xV8DppwJAf9tyNq0/SZILKbSGVT5eHp+lhWdWpdE0Vk=;
        b=mwsV2U6E9NIQdJcV7qSqHab8lmPcC5Z0K5lAUoXsHYv2dQk0ZFHU3POun/qJsGT/WB
         9HI0P5uN2YUCbrJKL8BH+UY6+YW1tUoQcwXoEvaAGI0bmm/zh0eKHkCfQ75Xdd8h5giI
         e/VZCIQUVfzmlUtBeEoP+vOf5lQyWNpu3K8xG9v64ESTgKD9/vcZg/+nm1wPkUgY7pGB
         jNuSxxiQNnRF8876+H6ps23UMaKO4MWLbqfnFKfGEcmgDJaqs+IZmFVaqBXp1WjIJltS
         TEvOrSV2RwdRbefArY8l6xmVsSLOnJpKrmgFszxWuoxhLOysZs5WJFRiHHLADkusTVz6
         yNbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xV8DppwJAf9tyNq0/SZILKbSGVT5eHp+lhWdWpdE0Vk=;
        b=vB9Qa7ZOph3y8M/RGm00TGTTo+Q8l9bz6pYeu0DvPskDZkeMDLaDI4mjBX++Afh7DQ
         7AdXBmbd0aKwaIS+mLmCMm8LYCyPWuZf6S4oyqwxQhxKrGLzCbg8r2OWm5Se6lQ/6hn2
         Oj9yK2dwi3YRTVprlerGFevLtjEbpoYFKMIW+/t4WiANxPj63VrGNXCCnzcvM8fxus2P
         KmyDs+hgQDsXKSMbDLswz2YtAizlcMjJpOVaD4/zB58Emr8r6gK4RAxVylgPkSBJYmld
         qqu+2ERFCR3qvIgtlvunRdcQnu8/YTq2bYziUUPV7LYXbN2Sowfxxa+zWTHZqpVKGiK4
         u5OA==
X-Gm-Message-State: AO0yUKVJ9QePb/DjTLK28YWN9+lVoNGAunlUhPyYKSZJ8sg1YLVD2adp
        JiAp/58MO9OBV4DtnWdKUU4BoQ==
X-Google-Smtp-Source: AK7set/Fz1pK27zp9EA5Qozm1kbJ1bo3+FAAuIBSU6H65HIx7r+dP1VQwD6Ok2yxDLU++C0IjZyTkg==
X-Received: by 2002:a17:902:d70a:b0:193:256d:8afe with SMTP id w10-20020a170902d70a00b00193256d8afemr842607ply.2.1675100409274;
        Mon, 30 Jan 2023 09:40:09 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id bg6-20020a1709028e8600b00189a50d2a3esm8070156plb.241.2023.01.30.09.40.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Jan 2023 09:40:08 -0800 (PST)
Date:   Mon, 30 Jan 2023 17:40:05 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Like Xu <like.xu.linux@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH v3 1/3] KVM: x86/pmu: Disable guest PEBS on hybird cpu
 due to heterogeneity
Message-ID: <Y9gA9aZNxYAZGgPh@google.com>
References: <20221109082802.27543-1-likexu@tencent.com>
 <20221109082802.27543-2-likexu@tencent.com>
 <Y8nknyxfKl4p/0GY@google.com>
 <9b422d58-72ab-051f-e317-02b4d8e7211d@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9b422d58-72ab-051f-e317-02b4d8e7211d@gmail.com>
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

On Mon, Jan 30, 2023, Like Xu wrote:
> On 20/1/2023 8:47 am, Sean Christopherson wrote:
> > On Wed, Nov 09, 2022, Like Xu wrote:
> > > From: Like Xu <likexu@tencent.com>
> > > 
> > >  From vPMU enabling perspective, KVM does not have proper support for
> > > hybird x86 core. The reported perf_capabilities value (e.g. the format
> > > of pebs record) depends on the type of cpu the kvm-intel module is init.
> > > When a vcpu of one pebs format migrates to a vcpu of another pebs format,
> > > the incorrect parsing of pebs records by guest can make profiling data
> > > analysis extremely problematic.
> > > 
> > > The safe way to fix this is to disable this part of the support until the
> > > guest recognizes that it is running on the hybird cpu, which is appropriate
> > > at the moment given that x86 hybrid architectures are not heavily touted
> > > in the data center market.
> > > 
> > > Signed-off-by: Like Xu <likexu@tencent.com>
> > > ---
> > >   arch/x86/kvm/vmx/capabilities.h | 4 +++-
> > >   1 file changed, 3 insertions(+), 1 deletion(-)
> > > 
> > > diff --git a/arch/x86/kvm/vmx/capabilities.h b/arch/x86/kvm/vmx/capabilities.h
> > > index cd2ac9536c99..ea0498684048 100644
> > > --- a/arch/x86/kvm/vmx/capabilities.h
> > > +++ b/arch/x86/kvm/vmx/capabilities.h
> > > @@ -392,7 +392,9 @@ static inline bool vmx_pt_mode_is_host_guest(void)
> > >   static inline bool vmx_pebs_supported(void)
> > >   {
> > > -	return boot_cpu_has(X86_FEATURE_PEBS) && kvm_pmu_cap.pebs_ept;
> > > +	return boot_cpu_has(X86_FEATURE_PEBS) &&
> > > +	       !boot_cpu_has(X86_FEATURE_HYBRID_CPU) &&
> > > +	       kvm_pmu_cap.pebs_ept;
> > 
> > I assume the patch I just posted[*] to disable the vPMU entirely is sufficient, or
> 
> AFAI, some developers doing client-side virtualization on a hybrid cpu will
> specifically want vPMU,
> in which case it makes perfect sense for KVM to expose common pmu
> capabilities (not PEBS at the current) of big and little cores, such as the
> most basic performance counter.
> 
> > do we need this as well in order to hide X86_FEATURE_DS and X86_FEATURE_DTES64?
> 
> I think we still need this diff. Better to prioritize this minor feature a
> little bit for hungry users.

That wasn't my question.  My question was whether or not wholesale disabling vPMU
is sufficient to prevent issues with PEBS.  Unless we need this patch on top of
disabling the vPMU, my strong preference is to disable vPMU, or at the very least
make it off-by-default and require a explicit override.

I agree that there are users that want to enable vPMU for hybrid CPUs, but as
stated in the link below, that needs to be a dedicated enabling effort.  I don't
see any reason to exempt PEBS from that.  E.g. isn't PEBS usable if userspace pins
vCPUs to pCPUs and enumerates an accurate topology to the guest?

> > [*] https://lore.kernel.org/all/20230120004051.2043777-1-seanjc@google.com
