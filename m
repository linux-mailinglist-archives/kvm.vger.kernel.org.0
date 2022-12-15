Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ABA9764D48C
	for <lists+kvm@lfdr.de>; Thu, 15 Dec 2022 01:19:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230085AbiLOATg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Dec 2022 19:19:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229724AbiLOATD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Dec 2022 19:19:03 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5A5C2734
        for <kvm@vger.kernel.org>; Wed, 14 Dec 2022 16:18:38 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id e7-20020a17090a77c700b00216928a3917so1011384pjs.4
        for <kvm@vger.kernel.org>; Wed, 14 Dec 2022 16:18:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=VfaOSQ2xG8DIX0I09VkRkjUWo+7u1oLgyWYfkHD5CW8=;
        b=X4tD6tmgrNH2TDpX4AlIvBGdOre7Ry0pC56VGpdfGcJ9/gg+ixgN1gsHXAfGs9R1kf
         0D05tyqtriMul8D7dSCDnzbfcNoYes7aR/4pECmX1wY/7J5qbkEKSHmutnR+RsIlbxBr
         enDNJYveWpbRsvGxAd7jA2gwFIgt4iVf0175YjDl/fQJKaRtx/9akHM3ME6sm+Eeuabl
         UP1ulkUZ3s4JeocRnljEYaCcjol+OGKTKdJqvMzFVFM5LNMTptsWE54oV2auFokBV9J9
         qPbGaXykmPUAd5N0q9uytv8tqLWI8MD3OoF7rE5haY58FkOwt3izOrtjMHV5werBFq3U
         +ZbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VfaOSQ2xG8DIX0I09VkRkjUWo+7u1oLgyWYfkHD5CW8=;
        b=dDYFb4J4+1lMRx4Akb7ugbE7N9On1RgB1EDLnG2CBavjW1lUW6a13TwXk0G8PtF8B8
         8FPWwspKOPQACvrUucSPiu3et7k1iOQIqRaqEM22u0iVevol/jejkwyFHJ9HnSFQuWsB
         QJmGWQmpjrNs0HmV8ZQDs7Pjl5+GhOCuYXsJJO5Z6YTIMP6lhmbVS6HXjyZYgpTvQUE5
         kWCAJu1M/erDwY9VRzsbqC6l8Gy32XoOLzdrX9Zk8WTrUIn1cny58JViAzUULpGJHTH8
         w17PpGp3plQwmtviqmkMN2AwmZp96ifiYbiaSf4vd27vKZywsgEuIVl/X2OomcLOFx/w
         YbQg==
X-Gm-Message-State: AFqh2kqkuu1JxehT6AvFrNPo1vX4UvZ1RUeaTLpozNKKQZAJAa6dP6iL
        Y73bsp6HXN5uWEp9AwpFZjz5yw==
X-Google-Smtp-Source: AMrXdXvx85jzQ2afmsYxLe6wkJSEdrxw6nTkbbMvjTfzFD1Mr7W3BYDZKXD/JyfWQMRx1GHMIF7E1A==
X-Received: by 2002:a17:903:18e:b0:189:6624:58c0 with SMTP id z14-20020a170903018e00b00189662458c0mr792919plg.3.1671063518250;
        Wed, 14 Dec 2022 16:18:38 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id g1-20020a170902c38100b00187197c499asm2406961plg.164.2022.12.14.16.18.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Dec 2022 16:18:37 -0800 (PST)
Date:   Thu, 15 Dec 2022 00:18:33 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Yu Zhang <yu.c.zhang@linux.intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Aaron Lewis <aaronlewis@google.com>
Subject: Re: [PATCH v2 0/4] KVM: nVMX: Fix 2nd exec controls override goofs
Message-ID: <Y5pn2fYf5eHu8yCb@google.com>
References: <20221213062306.667649-1-seanjc@google.com>
 <20221214030037.4qz6v6fvfx6of32n@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221214030037.4qz6v6fvfx6of32n@linux.intel.com>
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

On Wed, Dec 14, 2022, Yu Zhang wrote:
> On Tue, Dec 13, 2022 at 06:23:02AM +0000, Sean Christopherson wrote:
> > Fix bugs in KVM's (mis)handling of secondary execution controls.
> > 
> > KVM overrides the secondary execution control VMX MSR during KVM_SET_CPUID.
> > Similar to the somewhat recent reverts
> > 
> >   8805875aa473 ("Revert "KVM: nVMX: Do not expose MPX VMX controls when guest MPX disabled"")
> >   9389d5774aca ("Revert "KVM: nVMX: Expose load IA32_PERF_GLOBAL_CTRL VM-{Entry,Exit} control"")
> > 
> > undo misguided KVM behavior where KVM overrides allowed-1 settings in the
> > secondary execution controls in response to changes to the guest's CPUID
> > model.  To avoid breaking userspace that doesn't take ownership of the
> > VMX MSRs, go hands off if and only if userpace sets the MSR in question.
> > 
> > Before fixing that, fix another bug it was hiding where the umwait/tpause
> > control was being exposed to L1 for nVMX only after KVM_SET_CPUID, and
> > harden KVM against similar bugs in the future.
> > 
> > v2: Fix the ENABLE_USR_WAIT_PAUSE bug too. [Aaron]
> > 
> > v1: https://lore.kernel.org/all/20221110005706.1064832-1-seanjc@google.com
> > 
> > Sean Christopherson (4):
> >   KVM: nVMX: Properly expose ENABLE_USR_WAIT_PAUSE control to L1
> >   KVM: nVMX: Don't stuff secondary execution control if it's not
> >     supported
> >   KVM: nVMX: Don't muck with allowed sec exec controls on CPUID changes
> >   KVM: selftests: Test KVM's handling of VMX's sec exec MSR on
> >     KVM_SET_CPUID
> 
> BTW, we may need another patch to remove the obsolete comments in
> nested_vmx_setup_ctls_msrs():

Ouch, indeed.  Want to send a proper patch?  Or provide your SoB and I'll write
a changelog?

The comment was added by commit 80154d77c922 ("KVM: VMX: cache secondary exec controls"),
but arguably the below is the appropriate Fixes, as it's the commit that fixed the
existing cases where KVM didn't enumerate supported-but-conditional controls.

Fixes: 6defc591846d ("KVM: nVMX: include conditional controls in /dev/kvm KVM_GET_MSRS")

> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index b6f4411b613e..42ceddcafd3e 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -6854,11 +6854,6 @@ void nested_vmx_setup_ctls_msrs(struct vmcs_config *vmcs_conf, u32 ept_caps)
>         msrs->procbased_ctls_low &=
>                 ~(CPU_BASED_CR3_LOAD_EXITING | CPU_BASED_CR3_STORE_EXITING);
> 
> -       /*
> -        * secondary cpu-based controls.  Do not include those that
> -        * depend on CPUID bits, they are added later by
> -        * vmx_vcpu_after_set_cpuid.
> -        */
>         msrs->secondary_ctls_low = 0;
> 
>         msrs->secondary_ctls_high = vmcs_conf->cpu_based_2nd_exec_ctrl;
> 
> B.R.
> Yu
