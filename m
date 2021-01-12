Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF7362F3F61
	for <lists+kvm@lfdr.de>; Wed, 13 Jan 2021 01:46:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438320AbhALWS4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Jan 2021 17:18:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732872AbhALWSz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Jan 2021 17:18:55 -0500
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0071C0617A2
        for <kvm@vger.kernel.org>; Tue, 12 Jan 2021 14:18:14 -0800 (PST)
Received: by mail-pf1-x431.google.com with SMTP id h186so2288540pfe.0
        for <kvm@vger.kernel.org>; Tue, 12 Jan 2021 14:18:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=D94bTQz9Dscjb4392yuJLnozu8co+6TjlHWNTrMYHUs=;
        b=k2fC4CfRFE5cZ37SaYKA95nYdU+VpqUqDsjI5gAEa9XKBzDbJ1Z9d2qi0gbwvkGL4d
         eSZD5/+O8UbjZWTzVdOS/0NjZWx/5tC4zN7cc321WLZ0Y9jAP47bqBR2CsY3MS9u0ApS
         ior7i82v4r8gohZZMyAb42LLZw6tp3B11zMQVhL+cYYZ3BSdqopUuvb8XABFlF+jGRJU
         2A7O0jlAm1Zd0Fd1KPMzRtFUBH3Lp3aDKVy0QfSTsrFxd/L35bIyO/7n5YtKx5OHZ2iI
         jVTh4nXuh5oP2LEf+gp8ZxVqmzxsbT3CBsILk2/UM8THWUs50NCErnu/zs57rzPO1MhE
         O/QA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=D94bTQz9Dscjb4392yuJLnozu8co+6TjlHWNTrMYHUs=;
        b=sagNWLNR7/UvwKvEAik9NA2b0WANDXhr9Wh+ZD4wglm/MUpDCG7K64P7xyCqoc5vI5
         UFS7zaOkT/qyOea5lsd5mcAhwhkggqmI+S4LcJv/1HK2jjtMVSXN9kLQziZ/g+ez4Hus
         BhgvKOtMr7zKAMcA6SbWLssMmX9SVH51ENgsvqObztobFTTB8R5M5yD7RQcYdfOdp5ob
         rMAxz4qh9+DgwQFPazEmtse2rOnFYUDS7ostoEZFZlQZd/F8QYIYx9Qgk/60fwlX1apy
         AqASg+jqgqaQondVZiABnLK3DHsVf5gRu3gQcqVWm61jHQGMJRLPpjzNGIFaEo24BoKm
         apIw==
X-Gm-Message-State: AOAM533c1m8VHP4m5/eQ/6XIOvU4brQfLPZoWQVuAfm4VOva8lUsVIQh
        v60lb20oYIBL2kAHWNybZYrL2g==
X-Google-Smtp-Source: ABdhPJwWcpIo/snHBo4kb/9Uw+4uUANJIxOEc3Cus4Jg5b2/fhTbAYanYjbKe2gibQWUFHCx61E8+A==
X-Received: by 2002:a63:4082:: with SMTP id n124mr1200591pga.340.1610489894074;
        Tue, 12 Jan 2021 14:18:14 -0800 (PST)
Received: from google.com ([2620:15c:f:10:1ea0:b8ff:fe73:50f5])
        by smtp.gmail.com with ESMTPSA id 77sm122040pfv.16.2021.01.12.14.18.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Jan 2021 14:18:13 -0800 (PST)
Date:   Tue, 12 Jan 2021 14:18:06 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     Tom Lendacky <thomas.lendacky@amd.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Borislav Petkov <bp@suse.de>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 03/13] KVM: SVM: Move SEV module params/variables to sev.c
Message-ID: <X/4gHlZJvpem8SLd@google.com>
References: <20210109004714.1341275-1-seanjc@google.com>
 <20210109004714.1341275-4-seanjc@google.com>
 <87sg7792l3.fsf@vitty.brq.redhat.com>
 <672e86f7-86c7-0377-c544-fe52c8d7c1b9@amd.com>
 <87k0sj8l77.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87k0sj8l77.fsf@vitty.brq.redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jan 11, 2021, Vitaly Kuznetsov wrote:
> Tom Lendacky <thomas.lendacky@amd.com> writes:
> 
> > On 1/11/21 4:42 AM, Vitaly Kuznetsov wrote:
> >> Sean Christopherson <seanjc@google.com> writes:
> >> 
> >>> Unconditionally invoke sev_hardware_setup() when configuring SVM and
> >>> handle clearing the module params/variable 'sev' and 'sev_es' in
> >>> sev_hardware_setup().  This allows making said variables static within
> >>> sev.c and reduces the odds of a collision with guest code, e.g. the guest
> >>> side of things has already laid claim to 'sev_enabled'.
> >>>
> >>> Signed-off-by: Sean Christopherson <seanjc@google.com>
> >>> ---
> >>>   arch/x86/kvm/svm/sev.c | 11 +++++++++++
> >>>   arch/x86/kvm/svm/svm.c | 15 +--------------
> >>>   arch/x86/kvm/svm/svm.h |  2 --
> >>>   3 files changed, 12 insertions(+), 16 deletions(-)
> >>>
> >>> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> >>> index 0eeb6e1b803d..8ba93b8fa435 100644
> >>> --- a/arch/x86/kvm/svm/sev.c
> >>> +++ b/arch/x86/kvm/svm/sev.c
> >>> @@ -27,6 +27,14 @@
> >>>   
> >>>   #define __ex(x) __kvm_handle_fault_on_reboot(x)
> >>>   
> >>> +/* enable/disable SEV support */
> >>> +static int sev = IS_ENABLED(CONFIG_AMD_MEM_ENCRYPT_ACTIVE_BY_DEFAULT);
> >>> +module_param(sev, int, 0444);
> >>> +
> >>> +/* enable/disable SEV-ES support */
> >>> +static int sev_es = IS_ENABLED(CONFIG_AMD_MEM_ENCRYPT_ACTIVE_BY_DEFAULT);
> >>> +module_param(sev_es, int, 0444);
> >> 
> >> Two stupid questions (and not really related to your patch) for
> >> self-eduacation if I may:
> >> 
> >> 1) Why do we rely on CONFIG_AMD_MEM_ENCRYPT_ACTIVE_BY_DEFAULT (which
> >> sound like it control the guest side of things) to set defaults here?
> >
> > I thought it was a review comment, but I'm not able to find it now.
> >
> > Brijesh probably remembers better than me.
> >
> >> 
> >> 2) It appears to be possible to do 'modprobe kvm_amd sev=0 sev_es=1' and
> >> this looks like a bogus configuration, should we make an effort to
> >> validate the correctness upon module load?
> >
> > This will still result in an overall sev=0 sev_es=0. Is the question just 
> > about issuing a message based on the initial values specified?
> >
> 
> Yes, as one may expect the result will be that SEV-ES guests work and
> plain SEV don't.

KVM doesn't issue messages when it overrides other module params due to
disable requirements, e.g. ept=0 unrestricted_guest=1 is roughly equivalent.
Not that what KVM currently does is right, but at least it's consistent. :-)

And on the other hand, I think it's reasonable to expect that specifying only
sev=0 is sufficient to disable both SEV and SEV-ES, e.g. to turn them off when
they're enabled by default.
