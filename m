Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42DE05A14CB
	for <lists+kvm@lfdr.de>; Thu, 25 Aug 2022 16:48:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241991AbiHYOsY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Aug 2022 10:48:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230523AbiHYOsW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Aug 2022 10:48:22 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00E47B284A
        for <kvm@vger.kernel.org>; Thu, 25 Aug 2022 07:48:21 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id e19so19369495pju.1
        for <kvm@vger.kernel.org>; Thu, 25 Aug 2022 07:48:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=XhiNCwi9NsEE0klB/Frw1f9K4Tggxrv/evox76z5/lA=;
        b=Dk9BK3G2hp4B1mG3JrsyvIgozIrvDhchEJX2lWY83WQtxUHM75nKo75++9UH9Nutml
         i9lh0qLQ+Gx7TkY00Nq8JvYMBkRMF8cLRAwcp/aLkdhZa1i1C7xHoRSbVtw/BBUDjdeW
         AMgAZrEaUsmks8CsOM10B5mHYcFPN9VcoMLQEbTvsBH88sbBO+D3to8FaFoCWkm6ePUd
         /WkP7F9NhJj9yRx4yoEbeEwIEKwopAaqATHdZXrlHit0i/Ke/OvEziViHr2MbfiqHwf4
         nQTyrCO5wnRwKUhJhtMJKvmACRjAnTxJDu7btkUi5sKsinHah4u62/V4hubP0hGpVAvp
         RXXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=XhiNCwi9NsEE0klB/Frw1f9K4Tggxrv/evox76z5/lA=;
        b=nKDbQ0a4UydEeBgem9UJjwP6uGXBxddBMHwVKnGzPgXMEVezps+eqSIdWGdwxSz8dK
         DRh3KjwVjNJiS/yXnjylD4Oee0YODVDe6kW0Xx1AXXBkX1754UT2WMPjH15b8T46rtja
         MApg/mYnDx8SNSETRL3PohThz0MXRkI0tiKwOs9gY6U+9DXCTxB4qFl/cdcz9RocpdZs
         bnCblLwqpD9ae7oBmJWuVSoPZBS9jghqYpTUGYpc5e9zx79gtSy/qnkLl66EultueieN
         P2QicN1w9ksNncvMeqDvj59BJ5tbnBLuj9+Jyosn42s0zkb3/hJ6vo46c2RpgJprD6sF
         Dw5w==
X-Gm-Message-State: ACgBeo3tBv8AI+vk6irddMwBDt7EuyXzr7qs9LOhItP5I3QT+PFvjkYB
        rdJbm1QTHZGvm/sHzJRp7brrNez058GPaA==
X-Google-Smtp-Source: AA6agR56cI041M0Luwh1e1/atXZZ79uzzIa6z52lXqomngBz7jfRd4an2zqzqBNnyk/0/ZdXYaHvTQ==
X-Received: by 2002:a17:902:6bc9:b0:173:f3f:4a8c with SMTP id m9-20020a1709026bc900b001730f3f4a8cmr4144155plt.96.1661438901388;
        Thu, 25 Aug 2022 07:48:21 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id w16-20020a170902e89000b0016f196209c9sm11175028plg.123.2022.08.25.07.48.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Aug 2022 07:48:20 -0700 (PDT)
Date:   Thu, 25 Aug 2022 14:48:17 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org
Subject: Re: [RFC PATCH v6 06/36] KVM: nVMX: Treat eVMCS as enabled for guest
 iff Hyper-V is also enabled
Message-ID: <YweLsYpBI1MzRUqx@google.com>
References: <20220824030138.3524159-1-seanjc@google.com>
 <20220824030138.3524159-7-seanjc@google.com>
 <87r114wrn2.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87r114wrn2.fsf@redhat.com>
X-Spam-Status: No, score=-14.5 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,FSL_HELO_FAKE,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 25, 2022, Vitaly Kuznetsov wrote:
> Sean Christopherson <seanjc@google.com> writes:
> > diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
> > index 24d58c2ffaa3..35c7e6aef301 100644
> > --- a/arch/x86/kvm/vmx/vmx.h
> > +++ b/arch/x86/kvm/vmx/vmx.h
> > @@ -626,4 +626,14 @@ static inline bool vmx_can_use_ipiv(struct kvm_vcpu *vcpu)
> >  	return  lapic_in_kernel(vcpu) && enable_ipiv;
> >  }
> >  
> > +static inline bool guest_cpuid_has_evmcs(struct kvm_vcpu *vcpu)
> > +{
> > +	/*
> > +	 * eVMCS is exposed to the guest if Hyper-V is enabled in CPUID and
> > +	 * eVMCS has been explicitly enabled by userspace.
> > +	 */
> > +	return vcpu->arch.hyperv_enabled &&
> > +	       to_vmx(vcpu)->nested.enlightened_vmcs_enabled;
> 
> I don't quite like 'guest_cpuid_has_evmcs' name as it makes me think
> we're checking if eVMCS was exposed in guest CPUID but in fact we don't
> do that.

This does (indirectly) check guest CPUID.  hyperv_enabled is a direct reflection
of whether or not CPUID.HYPERV_CPUID_INTERFACE.EAX == HYPERV_CPUID_SIGNATURE_EAX.

> eVMCS can be enabled on a vCPU even if it is not exposed in
> CPUID (and we should probably keep that to not mandate setting CPUID
> before enabling eVMCS).

My intent with this helper is that it should be used only when the guest is
attempting to utilize eVMCS.  All host-initiated usage, e.g. KVM_SET_NESTED_STATE,
check enlightened_vmcs_enabled directly.

> What about e.g. vcpu_has_evmcs_enabled() instead?

I went with the guest_cpuid_has...() to align with the generic guest_cpuid_has()
so that it would somewhat clear that the helper should only be used when enforcing
guest behavior.

> On a related not, any reason to put this to vmx/vmx.h and not
> vmx/evmcs.h?

Can't dereference vcpu_vmx :-(

vmx.h includes evmcs.h by way of vmx_ops.h, and that ordering can't change because
the VMREAD/VMWRITE helpers need to get at the eVMCS stuff.
