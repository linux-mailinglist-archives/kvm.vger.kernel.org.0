Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B72A2640986
	for <lists+kvm@lfdr.de>; Fri,  2 Dec 2022 16:44:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233660AbiLBPoN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Dec 2022 10:44:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232678AbiLBPoM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Dec 2022 10:44:12 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 397E6D5876
        for <kvm@vger.kernel.org>; Fri,  2 Dec 2022 07:44:10 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id q15so4238279pja.0
        for <kvm@vger.kernel.org>; Fri, 02 Dec 2022 07:44:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=uXUuqbYPWAo0e3SfziJ9q3Uvez640/WBQSFJuuCG+jA=;
        b=KjipsMnKbBOqlmR9iEYkjoW1t+nkBJuZnixDinUZqw7JWWIxWGcuL7cN3ZoaGkrjO/
         cEfYg48wEe4ZNPurP83hila+K8klWIcJ1bO+ATwT/5EnivKUTZHKHIPv1Jg0Rh3+Yp9S
         2M7wmP3U3PFF+1vwZvNAdgY3Hd4NwdT/Jyh2HRunQFk4Tqm6ZXGF0N99icZtSOI3NczZ
         qZSYmdQQclv1Hmh+57Y/a1+hsPl+WJi2j1fqq98S6UcYaktFoenD+71UAdIyAVHAreJt
         NIOyxjEQI1ialks3HJ5R/oZzmZR1nO9TousAOhXig05OiYg8YwTtvf+r0WXZHQ52/Bn6
         Smpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uXUuqbYPWAo0e3SfziJ9q3Uvez640/WBQSFJuuCG+jA=;
        b=ZENLv1Rv1VHSmxhbBx2oFA2mMSS77iOksFSbvLZbPp+jBM2KXidzwZrKKLRmV8FYH7
         qu/wpVxg3TjHNaB1KV5vl5u29Go8OLo7XetewF5u89U04fWJwBuiUP075pwXJaOes1fn
         z5LTezRLlwDtKKqqoYuxwsf4mCul4k/+SV4gqSEJiGTHNUxoSLKHrdWpOdLRI64cFidl
         vHdxhVpg3kWJD5vEDjXKKk4XiRLc0rHAZo8NxYjfdICsFc4Zd82vkm13OQPZc4IDPpJp
         WFKjSTQWD5lWZCZEu2QMHbV2zCP/Otgf4i5O/horOxxDxt7TaPiSlnuQJnrgo+FzqPtP
         LXiw==
X-Gm-Message-State: ANoB5pklSy/BLgfEEsDlKSGVwQ2pzs/8LGL01yXIao3wPHqQEWGu5LS1
        tTVIPv4ItMbacJSs9u2dvEnOpQ==
X-Google-Smtp-Source: AA0mqf6lG8zpsfXSEo+gd8HtX4QQl0A/muxZY7NjcwlZU/V3DYzO3fMLcI5A1qZ10aIlPO2rRm6mdw==
X-Received: by 2002:a17:902:ab5e:b0:189:56ab:ab69 with SMTP id ij30-20020a170902ab5e00b0018956abab69mr45367903plb.106.1669995849555;
        Fri, 02 Dec 2022 07:44:09 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id b10-20020a170902d88a00b001868981a18esm5754075plz.6.2022.12.02.07.44.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Dec 2022 07:44:07 -0800 (PST)
Date:   Fri, 2 Dec 2022 15:44:04 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        coverity-bot <keescook@chromium.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: x86: hyper-v: Fix 'using uninitialized value'
 Coverity warning
Message-ID: <Y4odRLlFRj17tUNE@google.com>
References: <20221202105856.434886-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221202105856.434886-1-vkuznets@redhat.com>
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

On Fri, Dec 02, 2022, Vitaly Kuznetsov wrote:
> In kvm_hv_flush_tlb(), 'data_offset' and 'consumed_xmm_halves' variables
> are used in a mutually exclusive way: in 'hc->fast' we count in 'XMM
> halves' and increase 'data_offset' otherwise. Coverity discovered, that in
> one case both variables are incremented unconditionally. This doesn't seem
> to cause any issues as the only user of 'data_offset'/'consumed_xmm_halves'
> data is kvm_hv_get_tlb_flush_entries() ->  kvm_hv_get_hc_data() which also
> takes into account 'hc->fast' but is still worth fixing.

If those calls aren't inlined, then 32-bit Hyper-V will be "consuming" uninitialized
data when pushing parameters onto the stack.  It won't cause real problems, but
checkers might complain.

What about shoving this metadata into "struct kvm_hv_hcall" as a union?  That'd
help convey that the two are mutually exclusive, would provide a place to document
said exclusion, and would yield a nice cleanup too by eliminating multiple params
from various functions.
