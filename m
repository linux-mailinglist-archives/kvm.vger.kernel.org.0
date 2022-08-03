Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D82B85891C8
	for <lists+kvm@lfdr.de>; Wed,  3 Aug 2022 19:51:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236829AbiHCRvk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Aug 2022 13:51:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231966AbiHCRvh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Aug 2022 13:51:37 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E5E23D594
        for <kvm@vger.kernel.org>; Wed,  3 Aug 2022 10:51:37 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id t2-20020a17090a4e4200b001f21572f3a4so2938846pjl.0
        for <kvm@vger.kernel.org>; Wed, 03 Aug 2022 10:51:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=4D8pS8ERyLJtCBiCTu4ctfzlqVz56jvHc/H6j2NigrA=;
        b=Z0fwwqlgUha4Y0G9rz55tuuuixBANbKNQyHR3jeT3z0QVS2uiIk9XZdG53qZ54P60v
         3wxlm+QboutDiOOrWOLxVfC+YNopTY2A29ys42kd/7rRAaJc+OuncnDnBwzg1fCD0V7B
         43ANZCPuD61AuIY7nuNLSqEaHvrrcANNRuREoZyPvr1ZBbzq2dOoUSLsCtyKLY78VcRZ
         W6JJttAgAM7/DtJD4eeUysnswkU8LHy2135NAJdWRECE46ki+GXrhdKShvr3KwS2ltIe
         7wYmVpegB3APS/HGDhDIzbea6k35puFS8Zng0O7XsvkLMjiB93UZGFzOaayBa1LkZps7
         AiRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=4D8pS8ERyLJtCBiCTu4ctfzlqVz56jvHc/H6j2NigrA=;
        b=gTSR2PjqZbtW3vD2vD2lSDCJbydhHFdjrZNgexvDuI3QWCmlRcgObOamNjZajwE3bl
         BNBArBrgUmUT+PZkciMM/4KOYoef83/YeZcqT/f77aJKS+IlcYY+bA5dvPU7CtXmdN06
         JE0018o188PCs9vsBBvu/k789Rnhf7yp2tYMH25ZCOOrZDSdJh+BNwZCNZ8lQbnPpf36
         FeuYvv+SSbCabKczCtAyWU57p1oJQBBTqZ1U9qzYdPuT+8hYVFxapv7YJzMd6soQJq2D
         UNOOn3H1U6CrC6boQmsOJWpZpgfYlZbRz28nA5drthaiLW0O2dIj9avoIcUpzIFD1HKs
         QEEQ==
X-Gm-Message-State: ACgBeo2YnEvPKKH0iDOt0GqtrlrDqVhstn3cjcSttC/1aK7zQ2Ql1wZW
        ISCPFABcTPreANKuo612alK6V8GM/RrnXvmAQ2qymg==
X-Google-Smtp-Source: AA6agR5nBdAsOBirgmfKdfCNuWrNWKn1Pogobu7DJGB6nDcTpqU9Kas2cF3iahp8zsZiPKZiNEQJamoz/gGtL+sZVh4=
X-Received: by 2002:a17:90b:224e:b0:1f4:ebed:16f6 with SMTP id
 hk14-20020a17090b224e00b001f4ebed16f6mr5954295pjb.17.1659549096461; Wed, 03
 Aug 2022 10:51:36 -0700 (PDT)
MIME-Version: 1.0
References: <20220802230718.1891356-1-mizhang@google.com> <20220802230718.1891356-2-mizhang@google.com>
 <b03adf94-5af2-ff5e-1dbb-6dd212790083@redhat.com>
In-Reply-To: <b03adf94-5af2-ff5e-1dbb-6dd212790083@redhat.com>
From:   Mingwei Zhang <mizhang@google.com>
Date:   Wed, 3 Aug 2022 10:51:25 -0700
Message-ID: <CAL715WLQa5yz7SWAfOBUzQigv2JG1Ao+rwbeSJ++rKccVoZeag@mail.gmail.com>
Subject: Re: [PATCH 1/5] KVM: x86: Get vmcs12 pages before checking pending interrupts
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Oliver Upton <oupton@google.com>
Content-Type: text/plain; charset="UTF-8"
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

On Wed, Aug 3, 2022 at 10:18 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 8/3/22 01:07, Mingwei Zhang wrote:
> > +     /*
> > +      * We must first get the vmcs12 pages before checking for interrupts
> > +      * that might unblock the guest if L1 is using virtual-interrupt
> > +      * delivery.
> > +      */
> > +     if (kvm_check_request(KVM_REQ_GET_NESTED_STATE_PAGES, vcpu)) {
> > +             /*
> > +              * If we have to ask user-space to post-copy a page,
> > +              * then we have to keep trying to get all of the
> > +              * VMCS12 pages until we succeed.
> > +              */
> > +             if (unlikely(!kvm_x86_ops.nested_ops->get_nested_state_pages(vcpu))) {
> > +                     kvm_make_request(KVM_REQ_GET_NESTED_STATE_PAGES, vcpu);
> > +                     return 0;
> > +             }
> > +     }
> > +
>
> I think request handling (except for KVM_REQ_EVENT) could be more
> generically moved from vcpu_enter_guest() to vcpu_run().

Yeah, sounds good to me. I can come up with an updated version. At
least, I will remove the repeat request here.

>
> Paolo
>
