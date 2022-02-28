Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D2AF4C7786
	for <lists+kvm@lfdr.de>; Mon, 28 Feb 2022 19:22:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236172AbiB1SXG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Feb 2022 13:23:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237701AbiB1SWo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 28 Feb 2022 13:22:44 -0500
Received: from mail-io1-xd29.google.com (mail-io1-xd29.google.com [IPv6:2607:f8b0:4864:20::d29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 031AED4CB9
        for <kvm@vger.kernel.org>; Mon, 28 Feb 2022 10:00:50 -0800 (PST)
Received: by mail-io1-xd29.google.com with SMTP id r7so15644845iot.3
        for <kvm@vger.kernel.org>; Mon, 28 Feb 2022 10:00:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=OgxUPaION3iPee4snBS6bvecR8/8nJngrCwC4qpuntA=;
        b=Sg4atqi/CqW9DICAUyQeSWSJ3BjI5Fj0f4xexVC0AMhypGNyr3zkcr/nXvTyrVUGoK
         2Kvpqp9Bzb+HZULDKPXd68SD3fKLPMd09WfVFkOGPLUsfSITH9uPy7LC0X4NxLb2f+ya
         rp+D5ZIwk1l3CpFjA9FqKfYDDMGXPprNgD2RmJWdwhH1kYQMXdT/NaIMXGmei4gRub85
         ++gmRZ6AbCoi0u1aWN6TLD645QcrSjjPKCpRAwqYr84MwgLigrMTL2FFknvuTwtbOkI+
         VsoT4NWisDNeBDShdJM3ON6lG6RTOr25EWoXtG8Q3ZuRIehAh/BwQaosTXzx5X+JtRMe
         4UTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=OgxUPaION3iPee4snBS6bvecR8/8nJngrCwC4qpuntA=;
        b=zAVZmyVI8jwstiWxfppVTrE62nGO66z6SMF3B6+V5bYjnufwu/NlUFjGwzVJtQIP8o
         waj28APdjkaCc5KOIkWtL+mwdu/YvphLQNM8LgzFW2is2p8TV5+Zx6vVW9HMIFLOc8s4
         9FS5+JtvTCtzUWyeK+XkMTfqj3MljrZLPG8GzyeS6P/97AbgdUBNaoo1KkETyNTmTdTP
         oe5lu8Di7YVav5YC8NeZWkXK3dQKzm0GrvIg4CUkBRCpL4qwm7cV+3z85JP1aEJVVTji
         rQ6tnPBqFO5DBwQuNGWlUhu03jDn0i7uMm5NOUjnFuiNi64tm1GSA4yttSDceAgCOIDi
         8+uw==
X-Gm-Message-State: AOAM532PCeFCqycUtd+PgFzsy9IUdKEYNFgxDF5ZcZqZsSzcHq6p7El9
        5HmG4nRvuSkD/zI/suJ1s0HKzg==
X-Google-Smtp-Source: ABdhPJxj6pu/z/Y0wC6+dZscDiLl2jkLHTczZb2BQjMC9Mo7y1LD6LYR+WMxCDj2OpSBs/l98mqdgw==
X-Received: by 2002:a6b:7417:0:b0:640:a379:c950 with SMTP id s23-20020a6b7417000000b00640a379c950mr15813856iog.38.1646071246258;
        Mon, 28 Feb 2022 10:00:46 -0800 (PST)
Received: from google.com (194.225.68.34.bc.googleusercontent.com. [34.68.225.194])
        by smtp.gmail.com with ESMTPSA id v2-20020a92c802000000b002c1ed616004sm6738927iln.82.2022.02.28.10.00.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Feb 2022 10:00:45 -0800 (PST)
Date:   Mon, 28 Feb 2022 18:00:42 +0000
From:   Oliver Upton <oupton@google.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        David Dunn <daviddunn@google.com>
Subject: Re: [PATCH] KVM: x86: Introduce KVM_CAP_DISABLE_QUIRKS2
Message-ID: <Yh0NyuuzIymt9mgt@google.com>
References: <20220226002124.2747985-1-oupton@google.com>
 <Yhz5dRH/7gF45Zee@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yhz5dRH/7gF45Zee@google.com>
X-Spam-Status: No, score=-18.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Feb 28, 2022 at 04:33:57PM +0000, Sean Christopherson wrote:
> On Sat, Feb 26, 2022, Oliver Upton wrote:
> > KVM_CAP_DISABLE_QUIRKS is irrevocably broken. The capability does not
> > advertise the set of quirks which may be disabled to userspace, so it is
> > impossible to predict the behavior of KVM. Worse yet,
> > KVM_CAP_DISABLE_QUIRKS will tolerate any value for cap->args[0], meaning
> > it fails to reject attempts to set invalid quirk bits.
> 
> FWIW, we do have a way out without adding another capability.  The 'flags' field
> is enforced for all capabilities, we could use a bit there to add "v2" functionality.
> Userspace can assume KVM_QUIRK_ENFORCE_QUIRKS is allowed if the return from probing
> the capability is >1.
> 
> It's gross and forced, just an idea if we want to avoid yet another cap.

I had considered this before sending out v1, but was concerned if a
userspace didn't correctly handle a return value >1 from
KVM_CHECK_EXTENSION. Turns out, I can't even find any evidence of the
KVM_CAP_DISABLE_QUIRKS used by userspace. I spot checked QEMU, kvmtool,
and a couple of the rusty ones.

The only other thing that comes to mind is it's a bit gross for userspace
to do a graceful fallback if KVM_QUIRK_ENFORCE_QUIRKS isn't valid, since
most userspace would just error out on -EINVAL. At least with a new cap
userspace could follow a somewhat standardized way to discover if the
kernel supports enforced quirks.

[...]

> > +7.30 KVM_CAP_DISABLE_QUIRKS2
> > +----------------------------
> > +
> > +:Capability: KVM_CAP_DISABLE_QUIRKS2
> > +:Parameters: args[0] - set of KVM quirks to disable
> > +:Architectures: x86
> > +:Type: vm
> > +
> > +This capability, if enabled, will cause KVM to disable some behavior
> > +quirks.
> > +
> > +Calling KVM_CHECK_EXTENSION for this capability returns a bitmask of
> > +quirks that can be disabled in KVM.
> > +
> > +The argument to KVM_ENABLE_CAP for this capability is a bitmask of
> > +quirks to disable, and must be a subset of the bitmask returned by
> > +KVM_CHECK_EXTENSION.
> > +
> > +The valid bits in cap.args[0] are:
> > +
> > +=================================== ============================================
> > + KVM_X86_QUIRK_LINT0_ENABLED        By default, the reset value for the LVT
> 
> LINT0_REEANBLED.

Oops. Thanks!

--
Oliver
