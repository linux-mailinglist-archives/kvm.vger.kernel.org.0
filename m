Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3458A67A7A5
	for <lists+kvm@lfdr.de>; Wed, 25 Jan 2023 01:26:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234640AbjAYA0g (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Jan 2023 19:26:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234686AbjAYA03 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Jan 2023 19:26:29 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97AE4521D9
        for <kvm@vger.kernel.org>; Tue, 24 Jan 2023 16:25:46 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id k10-20020a17090a590a00b0022ba875a1a4so336773pji.3
        for <kvm@vger.kernel.org>; Tue, 24 Jan 2023 16:25:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=oxcHY0on7JosLcQqzE69YAFY0niaSNM4oy2cN96Zcic=;
        b=cDmVnTy17UJx9/kHHCrZQRAeIq7mHo3j1gdK1h9s4iTLLlLv7BStg8Pr38oQYd1Acv
         1PUt4ox2u0lShJexs25aHHzaRhnN7MTkg48nYiyYwkC3gbi4SLsfgK2BgXtWKBxeec0D
         xI7ttR9HVQH8ma6FSaTRwF/w1U69wojE1xpcEGhFhd3TOxnMdwYl+Y4RPJwu6WYmii7C
         jIyWT2uSld7kUek/p+I4nnrUZFwRlAk26Mhnjmono4t8p1XSReWr32jfx3H4Uqz15tBx
         yfFiOtryw09CRCkWhQWXTWE0MX47XLTt2W2x+Dp7K8sXd7nUBSJpPaxuKP40dCylGVBh
         l85Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oxcHY0on7JosLcQqzE69YAFY0niaSNM4oy2cN96Zcic=;
        b=yiQwXG39Z1LdCk+9/zBnKRCulHc+lmQxtB+UC7bYafhhsRglcfApKzv4dtn3s78pKX
         ipxC1U1C9vJXcySdHOeiO0Dd5tmJJK+S0Nn6PXkBzyJpR5L1uM54w96NE+3U26d7M95p
         EOMmBbqEstEjuO18TBggck7nlrGdnMz/VNIpYO96IOCfqJH+c1szdMSVM5UY9cqwNonw
         Tmj6/aceyRO1hw408AqjsZb4LYmp0j7+3FjtrpYt3hgMYm3GCpdue/LCSzwA4tANhj70
         TM71wyBcjbwAkxnNMbks/LMAsY1WFYmI9aJpMQ3s0+qllI1pUD0seWC4ywNV++i9uPrP
         6zJQ==
X-Gm-Message-State: AO0yUKXd+KuMNBh2EpiY/55j8zMqQM1BNhylQH4chKhAYl5ldRKTxhAp
        o0KBrao17InhfT/xamRXR/h01sBlDClIwLwfgoQ=
X-Google-Smtp-Source: AK7set86Irt+sEr8zKbcmTKJeqWZxr3ju+/dOIpb0nZweRyBkZwgtwSlRGXdRvUQceD1fr3kByr2Fg==
X-Received: by 2002:a17:903:234f:b0:193:256d:8afe with SMTP id c15-20020a170903234f00b00193256d8afemr398622plh.2.1674606344594;
        Tue, 24 Jan 2023 16:25:44 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id m5-20020a170902768500b001947c617c45sm2229457pll.221.2023.01.24.16.25.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Jan 2023 16:25:44 -0800 (PST)
Date:   Wed, 25 Jan 2023 00:25:40 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Ben Gardon <bgardon@google.com>
Cc:     Yu Zhang <yu.c.zhang@linux.intel.com>, pbonzini@redhat.com,
        kvm@vger.kernel.org, David Matlack <dmatlack@google.com>
Subject: Re: [PATCH] KVM: MMU: Add wrapper to check whether MMU is in direct
 mode
Message-ID: <Y9B3BCrvbL5HoIXu@google.com>
References: <20221206073951.172450-1-yu.c.zhang@linux.intel.com>
 <Y8nr9SZAnUguf3qU@google.com>
 <CANgfPd9fLjk+H9aZfykcp31Xd-Z1Yzmd3eAC5PUGhd9za0hnfw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANgfPd9fLjk+H9aZfykcp31Xd-Z1Yzmd3eAC5PUGhd9za0hnfw@mail.gmail.com>
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

On Fri, Jan 20, 2023, Ben Gardon wrote:
> On Thu, Jan 19, 2023 at 5:18 PM Sean Christopherson <seanjc@google.com> wrote:
> >
> > +David and Ben
> >
> > On Tue, Dec 06, 2022, Yu Zhang wrote:
> > > Simplify the code by introducing a wrapper, mmu_is_direct(),
> > > instead of using vcpu->arch.mmu->root_role.direct everywhere.
> > >
> > > Meanwhile, use temporary variable 'direct', in routines such
> > > as kvm_mmu_load()/kvm_mmu_page_fault() etc. instead of checking
> > > vcpu->arch.mmu->root_role.direct repeatedly.
> >
> > I've looked at this patch at least four times and still can't decide whether or
> > not I like the helper.  On one had, it's shorter and easier to read.  On the other
> > hand, I don't love that mmu_is_nested() looks at a completely different MMU, which
> > is weird if not confusing.
> >
> > Anyone else have an opinion?
> 
> The slightly shorter line length is kinda nice, but I don't think it
> really makes the code any clearer because any reader is still going to
> have to do the mental acrobatics to remember what exactly "direct"
> means, and why it matters in the given context. If there were some
> more useful function names we could wrap that check in, that might be
> nice. I don't see a ton of value otherwise. I'm thinking of something
> like "mmu_shadows_guest_mappings()" because that actually explains why
> we, for example, need to sync child SPTEs.

Ugh, right, thanks to nonpaging mode, something like is_shadow_mmu() isn't correct
even if/when KVM drops support for 32-bit builds.

Yu,
Unless you feel strongly about this one, I'm inclined to leave things as-is.
