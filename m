Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 96D9D66857F
	for <lists+kvm@lfdr.de>; Thu, 12 Jan 2023 22:34:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240163AbjALVem (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Jan 2023 16:34:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231997AbjALVeE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Jan 2023 16:34:04 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4F1025F8
        for <kvm@vger.kernel.org>; Thu, 12 Jan 2023 13:21:12 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id z9-20020a17090a468900b00226b6e7aeeaso22375474pjf.1
        for <kvm@vger.kernel.org>; Thu, 12 Jan 2023 13:21:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=KCyQHh14g9b5AQNK4wIKnAtou2aERX/cRBM682l3Mfk=;
        b=JFRBbBLKbc5/Xl2JSIwz1c0i1rg5BbX6PkFgPVc8PF2VYFlgLPxTQHYH5xvYfdSVLC
         MFkdTV9tznc6fDcSW4x8hpKkab+1Id2XWOJcAuYr/kWrYnPXuABhO+6+IGVcFPS6kHTG
         bhxaXGr+TQsAM68lZe7Dwk/9VCq60tTRvaQSsfq3gh/Kirct2kI3qgxxPd2NbkjBvezS
         xUIkU4Z67NGeBIARluN6adt116sphG2ZKjzmFXPw/8l4bjiAAHXwvPXM1c8sbDOxJ+R5
         6RPywcZ0TNlasxPWpoCkIQAp6dMIUsFUbnyTwDFrlJQgFUNIUsjvrczh3EippBufJm26
         5teQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KCyQHh14g9b5AQNK4wIKnAtou2aERX/cRBM682l3Mfk=;
        b=4FdnrhcgYMB6Ks1pGM1hq7x+9TQ8G9hVRD1yjI3+aO4Hl7XgUw0R9jfqHZCwCnxw5j
         tKVyxXeg0aCBzOVqek4LAxH3TdyJ39oVk8jozRhp2tjyeHPQkEJvzK7maqfM3vSbfR70
         +qXCDmrGwglOp8t6mh/tATAclQSC0+ZZArZVl/sDzaMaC+fZck0gp+lPi+aktpMR7b0d
         6h7JYrI2LZ+BizWpfekoe7tkF8eU+GcOC97lNTTfqxyhKKn0aXsoLQlypADsb2qXDjrQ
         u8n9vYJbar56vGdNwtb0iqy7ruQIMDapC3ANOhhHnbggPJEgbFfXruVOz5KaMKuzPinD
         88bg==
X-Gm-Message-State: AFqh2koB29gbRqNZVAF52RYGuuLmf1mwLAy/65+vuu60hppkcub7TADH
        d5ntJalmaIn4dWN/ZLcCtmOY3Q==
X-Google-Smtp-Source: AMrXdXuakG848CkY1fXgHZSThK25PUnH9LJBOR1WMdDYXr4TtL9o1kRGFKGZGDJ4EsEZoVDkS9C7Mw==
X-Received: by 2002:a17:90a:cf05:b0:227:2065:78ed with SMTP id h5-20020a17090acf0500b00227206578edmr7803134pju.29.1673558472239;
        Thu, 12 Jan 2023 13:21:12 -0800 (PST)
Received: from google.com (33.5.83.34.bc.googleusercontent.com. [34.83.5.33])
        by smtp.gmail.com with ESMTPSA id b11-20020a17090a5a0b00b0022704cc03ebsm8461913pjd.41.2023.01.12.13.21.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Jan 2023 13:21:11 -0800 (PST)
Date:   Thu, 12 Jan 2023 21:21:08 +0000
From:   Mingwei Zhang <mizhang@google.com>
To:     "Chang S. Bae" <chang.seok.bae@intel.com>
Cc:     Aaron Lewis <aaronlewis@google.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "jmattson@google.com" <jmattson@google.com>,
        Thomas Gleixner <tglx@linutronix.de>, "bp@suse.de" <bp@suse.de>
Subject: Re: [PATCH v2 1/6] KVM: x86: Clear all supported MPX xfeatures if
 they are not all set
Message-ID: <Y8B5xIVChfatMio0@google.com>
References: <20221230162442.3781098-1-aaronlewis@google.com>
 <20221230162442.3781098-2-aaronlewis@google.com>
 <Y7R36wsXn3JqwfEv@google.com>
 <CAAAPnDHff-2XFdAgKdfTQnG_a4TCVqWN9wxEhUtiOfiOVMuRWA@mail.gmail.com>
 <c87904cb-ce6d-1cf4-5b58-4d588660e20f@intel.com>
 <Y8BPs2269itL+WQe@google.com>
 <a1308e46-c319-fb73-1fde-eb3b071c10e8@intel.com>
 <Y8Bcr9VBA/VLjAwd@google.com>
 <6f22cb44-1a29-cb41-51e3-cbe532686c54@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6f22cb44-1a29-cb41-51e3-cbe532686c54@intel.com>
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

On Thu, Jan 12, 2023, Chang S. Bae wrote:
> On 1/12/2023 11:17 AM, Mingwei Zhang wrote:
> > 
> > But the permitted_xcr0 and supported_xcr0 seems never used
> > directly as the parameter of XSETBV, but only for size calculation.
> 
> Yeah, I saw that too, and tried to improve it [1]. Maybe this is not a big
> deal in KVM.
> 
> > One more question: I am very confused by the implementation of
> > xstate_get_guest_group_perm(). It seems fetching the xfeatures from the
> > host process (&current->group_leader->thread.fpu). Is this intentional?
> > Does that mean in order to enable AMX in the guest we have to enable it
> > on the host process first?
> 
> Yes, it was designed that QEMU requests permissions via arch_prctl() before
> creating vCPU threads [2][3]. Granted, this feature capability will be
> advertised to the guest. Then, it will *enable* the feature, right?
> 
> Thanks,
> Chang
> 
> [1]
> https://lore.kernel.org/kvm/20220823231402.7839-2-chang.seok.bae@intel.com/
> [2] https://lore.kernel.org/lkml/87wnmf66m5.ffs@tglx/
> [3] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=980fe2fddcff
> 

Thanks for the clarification. Yeah, that was out of my expectation since
I assumed AMX enabling in the guest should be orthogonal to the enabling
in the host. But since AMX requires dynamic size of fp_state, host
awareness of larger fp_state is highly intended.

The only comment I would have is that it seems not following the least
privilege principle as host process (QEMU) may not have the motivation
to do any matrix multiplication. But this is a minor one.

Since this enabling once per-process, I am wondering when after
invocation of arch_prctl(2), all of the host threads will have a larger
fp_state? If so, that might be a sizeable overhead since host userspace
may have lots of threads doing various of other things, i.e., they may
not be vCPU threads.
