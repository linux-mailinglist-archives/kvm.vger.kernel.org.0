Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A17754C9A6E
	for <lists+kvm@lfdr.de>; Wed,  2 Mar 2022 02:32:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238908AbiCBBdB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Mar 2022 20:33:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238531AbiCBBc5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Mar 2022 20:32:57 -0500
Received: from mail-io1-xd2d.google.com (mail-io1-xd2d.google.com [IPv6:2607:f8b0:4864:20::d2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CE8939B86;
        Tue,  1 Mar 2022 17:32:15 -0800 (PST)
Received: by mail-io1-xd2d.google.com with SMTP id q8so235991iod.2;
        Tue, 01 Mar 2022 17:32:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ztWi/UNJL/XxaHXFhvfP5PfT1ItALyADT54uwPwC7eo=;
        b=PGM87wOxTmfpOaGHHAolyktHMBPxeSumtGmiieXiZGPf0I8OXt6ND6Uy7FuADWXAey
         oX0oJPzWALxW8eczzKkaZu3gWr63cywTmUh0b4nsqrnZFFKFVKZIECbrNx/Fi/yn6iAU
         XB0Oh/7ef9erOig7u/Em9rdMdUcCdoJ1NuE3WpkJc3FLGHutrmEOCkgGXj3KxoQpeDZb
         PwDz3JuJa/lNtkUQoLbLhQN2tF7dpL0u+kbs5zH0l9m3sjvsPtsDbBJ10KDLzQLo/2lm
         P9EPvASNt5QZlI/Yn3x+IjI/l2IG1ASU/s8PU+Us52vjeZ59slnxWxJ9Uh7b7jqVfVr4
         r+Xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ztWi/UNJL/XxaHXFhvfP5PfT1ItALyADT54uwPwC7eo=;
        b=MbQERa6TiO6oya3LL6EZRQZiGpOFv4jTN/LfciqJ8ypukPEfm+un91tG0PYwxxCQcG
         ozw1X72nathxNQBwR2R37NyDgEJfrFr1qsc4BVJFfaldv/LkJyjBOX+AAbEvGIKGAO4m
         IJmPdSM5F04QJz4aQAsoS4y9t8LSx8EMVW+hgGaMfd3MSpVZT9q7y2joqbyKqYjxiami
         PSJ1HTThwAzw/pP6BQelLbl99gt+i+KseURxBKUG3aPSLruDVG82PJ38zT2sNU6Fr4x7
         O7OcdRkj/X0OqmRCHWdRLqHfqJqWngzi3Nr8N/URrgIzY8IGhwIfBUOztN1P7kmEy92H
         UVwg==
X-Gm-Message-State: AOAM530yp7Df4YzIpG1Q873IeDW6Jr4ox2ThSeLfufXVN8PL+JBB8QNw
        14Vp9eym6Fx+pXFnx6VPVtdJM7OWWdtWFvYb0Is=
X-Google-Smtp-Source: ABdhPJwyXY3CX8OBAglFpo4/v3dN5UstC8l3gL09iftRxZ1bgsCXXoKgRduiqva7nZKtN792g+r5eFaXf4z/HSPq0Oc=
X-Received: by 2002:a02:a804:0:b0:30e:4778:559a with SMTP id
 f4-20020a02a804000000b0030e4778559amr22835066jaj.291.1646184735094; Tue, 01
 Mar 2022 17:32:15 -0800 (PST)
MIME-Version: 1.0
References: <20220301063756.16817-1-flyingpeng@tencent.com> <Yh5d7XBD9D4FhEe3@google.com>
In-Reply-To: <Yh5d7XBD9D4FhEe3@google.com>
From:   Hao Peng <flyingpenghao@gmail.com>
Date:   Wed, 2 Mar 2022 09:30:44 +0800
Message-ID: <CAPm50a+p2pSjExDwPmGpZ_aTuxs=x6RZ4-AAD19RDQx2o-=NCw@mail.gmail.com>
Subject: Re: [PATCH] kvm: x86: Improve virtual machine startup performance
To:     Sean Christopherson <seanjc@google.com>
Cc:     pbonzini@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 2, 2022 at 1:54 AM Sean Christopherson <seanjc@google.com> wrote:
>
> On Tue, Mar 01, 2022, Peng Hao wrote:
> >  From: Peng Hao <flyingpeng@tencent.com>
> >
> > vcpu 0 will repeatedly enter/exit the smm state during the startup
> > phase, and kvm_init_mmu will be called repeatedly during this process.
> > There are parts of the mmu initialization code that do not need to be
> > modified after the first initialization.
> >
> > Statistics on my server, vcpu0 when starting the virtual machine
> > Calling kvm_init_mmu more than 600 times (due to smm state switching).
> > The patch can save about 36 microseconds in total.
> >
> > Signed-off-by: Peng Hao <flyingpeng@tencent.com>
> > ---
> > @@ -5054,7 +5059,7 @@ void kvm_mmu_after_set_cpuid(struct kvm_vcpu *vcpu)
> >  void kvm_mmu_reset_context(struct kvm_vcpu *vcpu)
> >  {
> >       kvm_mmu_unload(vcpu);
> > -     kvm_init_mmu(vcpu);
> > +     kvm_init_mmu(vcpu, false);
>
> This is wrong, kvm_mmu_reset_context() is the "big hammer" and is expected to
> unconditionally get the MMU to a known good state.  E.g. failure to initialize
> means this code:
>
>         context->shadow_root_level = kvm_mmu_get_tdp_level(vcpu);
>
> will not update the shadow_root_level as expected in response to userspace changing
> guest.MAXPHYADDR in such a way that KVM enables/disables 5-level paging.
>
Thanks for pointing this out. However, other than shadow_root_level,
other fields of context will not
change during the entire operation, such as
page_fault/sync_page/direct_map and so on under
the condition of tdp_mmu.
Is this patch still viable after careful confirmation of the fields
that won't be modified?
thanks.
> The SMM transitions definitely need to be fixed, and we're slowly getting there,
> but sadly there's no quick fix.
