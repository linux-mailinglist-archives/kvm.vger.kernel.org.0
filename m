Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 68B83654635
	for <lists+kvm@lfdr.de>; Thu, 22 Dec 2022 19:54:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235508AbiLVSyi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Dec 2022 13:54:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235527AbiLVSyO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Dec 2022 13:54:14 -0500
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFAE7248E4
        for <kvm@vger.kernel.org>; Thu, 22 Dec 2022 10:53:40 -0800 (PST)
Received: by mail-pl1-x631.google.com with SMTP id d15so2841337pls.6
        for <kvm@vger.kernel.org>; Thu, 22 Dec 2022 10:53:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=8tmSHmVLFcVI0ebBLIl7VATcCoahqOOR/Yv5nGo74Y0=;
        b=Q4u1Ae+Do7gfeNZkVaZDf5fcQNf3qLvMrV8g4qRjferzm9XvemDsyk0MJ95mlVuV5e
         1fzercFpSZmQwOXnVqHgmo+Syv5VZlYyr8A1Fid/MGPOoV40cZpHhUAdMGvnSza1qwV4
         yMbzPIVz6pWu6+YWBgHq0QSUOhkHH1B/dOJIUB65jvllQpT3U4vc+t0kuXGpUUc+96S5
         ceH5rVz9SU0tVlzq2h3NwqKyCTZYt1n6wR8p0XelsXyzmgX6I68u88Y5GYmPW6LNnHt0
         mjwBPGUTyl/ZttWmfWdyyl2z+cXgljM/qmXFhqLgEbnvK7w/ivPd/p5m+WdGyOJyVZ3v
         Hrnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8tmSHmVLFcVI0ebBLIl7VATcCoahqOOR/Yv5nGo74Y0=;
        b=GE4Co3s/XXA45hx0TV1pkhg+bei5BZ+MHn1mE5KJxEotG/n+jc9AVlVn8P6bvYjDL6
         S1Mw6Xixk9+DrqVQr/sa0u6gtpAb8MxKe2aF54E3rw2oNEXtGUPmZ8YcEFdvFaZm4xd5
         dHYV0E5QgZJ70Kn0DCQIMAoyZM6f1bJeDFQDFlx9+pGTC6YmyjZX+yQnte5JbOOnwE5Y
         n2BjdzbD5Q3WjD1QhKcNPKLvOOsdSU9FKKvKON6bw7XUq8mCtGyJtdLXqJKOZ28tCcIC
         lEtQJShBgjeHDpwvTBBoSuB5B/zXQGHXAgMxHIP/ejmkee+flsYUWwjNs0ecrtqLKQ8C
         qAnQ==
X-Gm-Message-State: AFqh2kpuHASYsord1VW2Iu53rOdQTlKoQBtEgdDqP/CXZaz6zZ/CZC5n
        bkKAnwuUiThrI8iN5jWFDzwIDw==
X-Google-Smtp-Source: AMrXdXvGEInfZjDiUbeSkYkxJpmDuBiOUtYTgxeYMeuGENBc1z8vUvCpMmsSRkE4l7olMKctgVG6Fg==
X-Received: by 2002:a05:6a20:5488:b0:a3:d7b0:aeef with SMTP id i8-20020a056a20548800b000a3d7b0aeefmr1418013pzk.0.1671735220326;
        Thu, 22 Dec 2022 10:53:40 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id hc7-20020a17090b318700b00210c84b8ae5sm929267pjb.35.2022.12.22.10.53.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Dec 2022 10:53:39 -0800 (PST)
Date:   Thu, 22 Dec 2022 18:53:35 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     David Woodhouse <dwmw2@infradead.org>
Cc:     Yu Zhang <yu.c.zhang@linux.intel.com>, kvm@vger.kernel.org,
        pbonzini@redhat.com, maz@kernel.org, james.morse@arm.com,
        alexandru.elisei@arm.com, suzuki.poulose@arm.com,
        oliver.upton@linux.dev, catalin.marinas@arm.com, will@kernel.org,
        paul@xen.org
Subject: Re: [PATCH v4 1/2] KVM: MMU: Introduce 'INVALID_GFN' and use it for
 GFN values
Message-ID: <Y6Snr42pMGvIO+9d@google.com>
References: <20221216085928.1671901-1-yu.c.zhang@linux.intel.com>
 <20221216085928.1671901-2-yu.c.zhang@linux.intel.com>
 <Y5yeKucYYfYOMXqp@google.com>
 <89a8f726e6fb1a91097ef18d6e837aff31a675f3.camel@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <89a8f726e6fb1a91097ef18d6e837aff31a675f3.camel@infradead.org>
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

On Tue, Dec 20, 2022, David Woodhouse wrote:
> On Fri, 2022-12-16 at 16:34 +0000, Sean Christopherson wrote:
> > On Fri, Dec 16, 2022, Yu Zhang wrote:
> > > Currently, KVM xen and its shared info selftest code uses
> > > 'GPA_INVALID' for GFN values, but actually it is more accurate
> > > to use the name 'INVALID_GFN'. So just add a new definition
> > > and use it.
> > > 
> > > No functional changes intended.
> > > 
> > > Suggested-by: David Woodhouse <dwmw2@infradead.org>
> > > Signed-off-by: Yu Zhang <yu.c.zhang@linux.intel.com>
> > > ---
> > >  arch/x86/kvm/xen.c                                   | 4 ++--
> > >  include/linux/kvm_types.h                            | 1 +
> > >  tools/testing/selftests/kvm/x86_64/xen_shinfo_test.c | 4 ++--
> > >  3 files changed, 5 insertions(+), 4 deletions(-)
> > > 
> > > diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
> > > index d7af40240248..6908a74ab303 100644
> > > --- a/arch/x86/kvm/xen.c
> > > +++ b/arch/x86/kvm/xen.c
> > > @@ -41,7 +41,7 @@ static int kvm_xen_shared_info_init(struct kvm *kvm, gfn_t gfn)
> > >         int ret = 0;
> > >         int idx = srcu_read_lock(&kvm->srcu);
> > >  
> > > -       if (gfn == GPA_INVALID) {
> > > +       if (gfn == INVALID_GFN) {
> > 
> > Grrr!  This magic value is ABI, as "gfn == -1" yields different behavior than a
> > random, garbage gfn.
> >                                                                                 
> > So, sadly, we can't simply introduce INVALID_GFN here, and instead need to do
> > something like:
> > 
> 
> Well... you can still use INVALID_GFN as long as its value remains the
> same ((uint64_t)-1).
> 
> But yes, the KVM API differs here from Xen because Xen only allows a
> guest to *set* these (and later they invented SHUTDOWN_soft_reset).
> While KVM lets the userspace VMM handle soft reset, and needs to allow
> them to be *unset*. And since zero is a valid GPA/GFN, -1 is a
> reasonable value for 'INVALID'.

Oh, yeah, I'm not arguing against using '-1', just calling out that there is
special meaning given to '-1' and so it needs to be formalized so that KVM doesn't
accidentally break userspace.

> But I do think that detail escaped the documentation and the uapi headers, so
> your suggestion below is a good one, although strictly we need a GPA one too.

Ah, right, for struct kvm_xen_vcpu_attr.
