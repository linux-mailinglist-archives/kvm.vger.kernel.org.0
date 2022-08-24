Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ACC9359F89F
	for <lists+kvm@lfdr.de>; Wed, 24 Aug 2022 13:31:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237061AbiHXLby (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Aug 2022 07:31:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235216AbiHXLbx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Aug 2022 07:31:53 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A77B37CB55
        for <kvm@vger.kernel.org>; Wed, 24 Aug 2022 04:31:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1661340711;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=NXZfj2s190ISAGXONt5w3kxpRbp3A0q+eb86yI+SwmU=;
        b=HjnR+uqbr7IVPf7UexJgdLQ2RvydkN+IU1C3x5joeVvxfZPwFSaFDIVpVth9tRh9+dtgZY
        LpWl8G8LttXxxzAQ4cPPlFcsjqGTF3ciOCOOuWTp2kGZyviOIGSfjdbN/YQZHvLhy4rEyh
        AcELfKvA2CvvRkTg7Sc7/sUMDPdw0u8=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-362-ybBmagGTNLCaSlzSvLkqYQ-1; Wed, 24 Aug 2022 07:31:50 -0400
X-MC-Unique: ybBmagGTNLCaSlzSvLkqYQ-1
Received: by mail-wm1-f71.google.com with SMTP id j22-20020a05600c485600b003a5e4420552so694610wmo.8
        for <kvm@vger.kernel.org>; Wed, 24 Aug 2022 04:31:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=NXZfj2s190ISAGXONt5w3kxpRbp3A0q+eb86yI+SwmU=;
        b=33zoowSfHoPqh/ajIXx927AtSaRLfAQkLADPxBpfu0qnEjlRay30p08l7MQe7qdstm
         9HJi8jMTZ5XcmgUNkK1l28g/vcpmVYOH6P5Wh+hQPIMR0gSc5GEqpVl9wfvjQoI05+/2
         PbTNnOVwrE6P/R7k9hj7PEoSSsYcMPDiCUlIcd2+lScnp7ku/K8tMMR33m5F5tb9/9r/
         4KQHIIvaoXuY7vT5FXwPJm/UJxnrLA8mZRq23pRjf+KTtWIbLacduXEq4eNHtT+ofEwj
         0sdhO1KrNiTh8cdtzmQhw9ZiJZdaQ1V1bR4oNNt0z05hTcOj1xFti+MneOXTVAx2l8Aw
         CM3A==
X-Gm-Message-State: ACgBeo2zZIogodbjwe2Wv2ktdWI0MhSfsCfiMZK0inx9VlnFbPlHzoUW
        bhp2EbdKmD9kFPhnaAfgEbG7G0+It5WJyrPi6WsqQpaZRlau7NrrOLRanBHGZcgYiMRTM55TWDc
        OFUum+aV/PPAJ
X-Received: by 2002:a5d:4649:0:b0:225:309d:1d51 with SMTP id j9-20020a5d4649000000b00225309d1d51mr16181963wrs.450.1661340709395;
        Wed, 24 Aug 2022 04:31:49 -0700 (PDT)
X-Google-Smtp-Source: AA6agR4i+1qd54vzbvs4QScz2m2JIdiVf8ThPgMMJ3+2r+1NSyen7peRW4L0istbQ+UTyFa3u9T9Ww==
X-Received: by 2002:a5d:4649:0:b0:225:309d:1d51 with SMTP id j9-20020a5d4649000000b00225309d1d51mr16181947wrs.450.1661340709129;
        Wed, 24 Aug 2022 04:31:49 -0700 (PDT)
Received: from work-vm (cpc109025-salf6-2-0-cust480.10-2.cable.virginm.net. [82.30.61.225])
        by smtp.gmail.com with ESMTPSA id bi19-20020a05600c3d9300b003a3170a7af9sm1945872wmb.4.2022.08.24.04.31.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Aug 2022 04:31:48 -0700 (PDT)
Date:   Wed, 24 Aug 2022 12:31:46 +0100
From:   "Dr. David Alan Gilbert" <dgilbert@redhat.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Leonardo Bras <leobras@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: Re: [PATCH 0/3] KVM: x86: Fix XSAVE related bugs
Message-ID: <YwYMInTCevZ/FYNl@work-vm>
References: <20220824033057.3576315-1-seanjc@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220824033057.3576315-1-seanjc@google.com>
User-Agent: Mutt/2.2.6 (2022-06-05)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

* Sean Christopherson (seanjc@google.com) wrote:
> Patch 2 (from Dave) is the headliner and fixes a bug where KVM clear the
> FP+SSE bits in user_xfeatures when XSAVE is hidden from the guest and thus
> prevent userspace from saving/restoring FP+SSE state on XSAVE host.  This
> most visibily manifests as a failed migration (KVM_GET_XSAVE succeeds on a
> non-XSAVE host and KVM_SET_XSAVE fails on an XSAVE host), but also causes
> KVM_GET_SAVE on XSAVE hosts to effectively corrupt guest FP+SSE state.
> 
> Patch 1 fixes a mostly theoretical bug, and is also a prerequisite for
> patch 2.
> 
> Patch 3 fixes a bug found by inspection when staring at all of this.  KVM
> fails to check CR4.OSXSAVE when emulating XSETBV (the interception case
> gets away without the check because the intercept happens after hardware
> checks CR4).

Thanks for pulling those together; the set of 3 passes my same (light) smoke test.

Dave
> 
> Dr. David Alan Gilbert (1):
>   KVM: x86: Always enable legacy FP/SSE in allowed user XFEATURES
> 
> Sean Christopherson (2):
>   KVM: x86: Reinstate kvm_vcpu_arch.guest_supported_xcr0
>   KVM: x86: Inject #UD on emulated XSETBV if XSAVES isn't enabled
> 
>  arch/x86/include/asm/kvm_host.h |  1 +
>  arch/x86/kvm/cpuid.c            | 11 ++++++++---
>  arch/x86/kvm/emulate.c          |  3 +++
>  arch/x86/kvm/x86.c              | 10 +++-------
>  4 files changed, 15 insertions(+), 10 deletions(-)
> 
> 
> base-commit: 372d07084593dc7a399bf9bee815711b1fb1bcf2
> -- 
> 2.37.1.595.g718a3a8f04-goog
> 
-- 
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

