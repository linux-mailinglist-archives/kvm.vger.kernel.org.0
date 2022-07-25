Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07BC7580273
	for <lists+kvm@lfdr.de>; Mon, 25 Jul 2022 18:08:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234778AbiGYQIb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Jul 2022 12:08:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233511AbiGYQI3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 Jul 2022 12:08:29 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8715C13DC4
        for <kvm@vger.kernel.org>; Mon, 25 Jul 2022 09:08:27 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id z1-20020a17090a170100b001f2e643b299so204349pjd.3
        for <kvm@vger.kernel.org>; Mon, 25 Jul 2022 09:08:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=FjmoqdU5kj6rAICx3+QzM5MmmkfRNlf/iMQ4fGtplDA=;
        b=qPSXGfwvhrycsBQOp8iY52tnh1KgXSyBQB+dY2Cc2tVNhSXPKkg6St7J8kQhqlxsEa
         03/RDkLPFIsTansQAXIAeanSealDnebMm5Rkdeor7AxexibjsXRGN73FxGe+80khHHPT
         v8xnWy3f4sCauZhKga5d0yRHZMfto0sAsNxbMkAfxHPvxIQ0QMx7qXI5Yd72cemfFpCD
         ub1xtP7DT0g4876OlkgQbiBkH+IA9KU4VYPyvaX+x4qSh+CKsdH1qu+6TICYYOcHbB97
         U52lm5UEl9xUZTAXBGfNfpUs+Njp6xwD/4d+nSIA1+bpzWLsFtNt7MCE6xDG67zmiVWT
         cQ2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=FjmoqdU5kj6rAICx3+QzM5MmmkfRNlf/iMQ4fGtplDA=;
        b=hZsX42Pk+1+hGEiyVczv53zh9P7bB6eHhNQPokOMXdAo0eEKeFFKvsAJNgcH1MalSe
         by9Qf3YWsoVCaR6Kjxf1IvVbtkwOkhjXpfKeQEsQ2mrsVkx9Cr8aagFU9fCqvF8i6xNs
         nsIuJ3oJGmP7tgCbEjnu/IHaxRvJ8iQ18R2XAMri4zp3OoSch+u5w/8gDeQ5mYBtBprz
         59X2GkYzV2dSE2KEfaS+UyJ8h9Cr07Ayjeja8PQBng4vvPOGwUiXhsKKGwFMpOxTbzQy
         4RI/JacVac/XubZqG1mSdcuVyUPJ6byJRm6oVvu6h/WIec9/fFsgxNe0pqws2rrGeAAy
         /5DQ==
X-Gm-Message-State: AJIora+76AJeAkU4JDIQB2X161iNEb+ThtD554ivBoQsmGUjlj7mD0jO
        cj3dCI5drigtXAR8JtQeh74IdQ==
X-Google-Smtp-Source: AGRyM1unzHQqb8zVBUKEs6rrq19O/McmbA2bTcyfP51716abdNtaluRuKhI7j88I4xjSdpuIYIqcpg==
X-Received: by 2002:a17:90b:4a12:b0:1ef:a8bb:b475 with SMTP id kk18-20020a17090b4a1200b001efa8bbb475mr15047889pjb.124.1658765306524;
        Mon, 25 Jul 2022 09:08:26 -0700 (PDT)
Received: from google.com (123.65.230.35.bc.googleusercontent.com. [35.230.65.123])
        by smtp.gmail.com with ESMTPSA id e7-20020a17090301c700b0016bf2dc1724sm9463154plh.247.2022.07.25.09.08.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Jul 2022 09:08:25 -0700 (PDT)
Date:   Mon, 25 Jul 2022 16:08:21 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     kvm@vger.kernel.org, Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Ingo Molnar <mingo@redhat.com>,
        David Airlie <airlied@linux.ie>,
        Thomas Gleixner <tglx@linutronix.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        intel-gfx@lists.freedesktop.org, Daniel Vetter <daniel@ffwll.ch>,
        Borislav Petkov <bp@alien8.de>, Joerg Roedel <joro@8bytes.org>,
        linux-kernel@vger.kernel.org, Jim Mattson <jmattson@google.com>,
        Zhi Wang <zhi.a.wang@intel.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        intel-gvt-dev@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: Re: [RFC PATCH v3 04/19] KVM: x86: mmu: allow to enable write
 tracking externally
Message-ID: <Yt6/9V0S9of7dueW@google.com>
References: <20220427200314.276673-1-mlevitsk@redhat.com>
 <20220427200314.276673-5-mlevitsk@redhat.com>
 <YoZyWOh4NPA0uN5J@google.com>
 <5ed0d0e5a88bbee2f95d794dbbeb1ad16789f319.camel@redhat.com>
 <c22a18631c2067871b9ed8a9246ad58fa1ab8947.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c22a18631c2067871b9ed8a9246ad58fa1ab8947.camel@redhat.com>
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

On Wed, Jul 20, 2022, Maxim Levitsky wrote:
> On Sun, 2022-05-22 at 13:22 +0300, Maxim Levitsky wrote:
> > On Thu, 2022-05-19 at 16:37 +0000, Sean Christopherson wrote:
> > > On Wed, Apr 27, 2022, Maxim Levitsky wrote:
> > > > @@ -5753,6 +5752,10 @@ int kvm_mmu_init_vm(struct kvm *kvm)
> Now for nested AVIC, this is what I would like to do:
>  
> - just like mmu, I prefer to register the write tracking notifier, when the
>   VM is created.
>
> - just like mmu, write tracking should only be enabled when nested AVIC is
>   actually used first time, so that write tracking is not always enabled when
>   you just boot a VM with nested avic supported, since the VM might not use
>   nested at all.
>  
> Thus I either need to use the __kvm_page_track_register_notifier too for AVIC
> (and thus need to export it) or I need to have a boolean
> (nested_avic_was_used_once) and register the write tracking notifier only
> when false and do it not on VM creation but on first attempt to use nested
> AVIC.
>  
> Do you think this is worth it? I mean there is some value of registering the
> notifier only when needed (this way it is not called for nothing) but it does
> complicate things a bit.

Compared to everything else that you're doing in the nested AVIC code, refcounting
the shared kvm_page_track_notifier_node object is a trivial amount of complexity.

And on that topic, do you have performance numbers to justify using a single
shared node?  E.g. if every table instance has its own notifier, then no additional
refcounting is needed.  It's not obvious that a shared node will provide better
performance, e.g. if there are only a handful of AVIC tables being shadowed, then
a linear walk of all nodes is likely fast enough, and doesn't bring the risk of
a write potentially being stalled due to having to acquire a VM-scoped mutex.

> I can also stash this boolean (like 'bool registered;') into the 'struct
> kvm_page_track_notifier_node',  and thus allow the
> kvm_page_track_register_notifier to be called more that once -  then I can
> also get rid of __kvm_page_track_register_notifier. 

No, allowing redundant registration without proper refcounting leads to pain,
e.g. X registers, Y registers, X unregisters, kaboom.
