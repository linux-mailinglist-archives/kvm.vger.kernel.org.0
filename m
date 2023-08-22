Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88CA5784534
	for <lists+kvm@lfdr.de>; Tue, 22 Aug 2023 17:14:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236428AbjHVPOz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Aug 2023 11:14:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235830AbjHVPOy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Aug 2023 11:14:54 -0400
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2B96CCB
        for <kvm@vger.kernel.org>; Tue, 22 Aug 2023 08:14:52 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id d2e1a72fcca58-68a3f3f1e56so2862950b3a.3
        for <kvm@vger.kernel.org>; Tue, 22 Aug 2023 08:14:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692717292; x=1693322092;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=x0CAdayxZnOXB3R9tzN1AXIAV0JYK7ZqYNSVBuP6VI8=;
        b=7DptgBWWnObVmVNjk9Nx1HA+g9gnkgqqdvZr2MsZmc6MKcjTKI2OT39xFA5c6blO05
         0gK7BCFQ9bmY28FklorSE+mEusyX/SLZDphUDhD8182xU5VzFeO41omBXdvro4fAUJuC
         pIQAH1Mf5nevP5/Nt5/lJlrmeWf/sXhcHMhs0DWP/tLBKWlcb4Cph4NDQrMFb8bsfL7P
         lMZkN2yVGmdYHovwSmltDyZS7cfKiWv0W4UW5gHp94uRBUvdm8ab0QmR6EbgGmtWx3in
         Skj1c6m4wYuE7wCr+3AbZVgFVo1W+E0LWzHEOtkAlyvHteX1/LBNJvwO6NGOF9onh5e5
         RPFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692717292; x=1693322092;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=x0CAdayxZnOXB3R9tzN1AXIAV0JYK7ZqYNSVBuP6VI8=;
        b=Kvb4+evhC+IZVJHosuRlOmaZ15zyk45HSd1VwMoVOYp4OOcyOpmqdnsAz7U31T4oU0
         aI/TYwF12cvTuSl+qofjvtPraYNwz7Fp0doxXiUOM5UKBcaMmlQk297DsaVkRn3e0KWr
         2jhnNCIbd6mOTJNRgMCC++a/26gBBoZjpTaKD/GyPI/L3xw1pxrVhMnYMLzVHyAKLe2f
         gM/J4UUbbMOPKTW/w28nuwCOBjONV0w8fqpZU6rQDGmPR0FgSNbkSXdh0pbl0e+mG21L
         XGLwhR2BPf651W0WIvRscSUNhPmmMmU/zUirTwWVGJ1GQk0E7JJwiVDdY3l6v5wjrJQE
         JOxQ==
X-Gm-Message-State: AOJu0YyQznj9ReOWGgGtaMxv2225Wu8hH4ei4DN/Frm4AN0J28lGT/Tx
        ZOvMVmA46HO/p0345Abb/e8rHHxQ/m8=
X-Google-Smtp-Source: AGHT+IFG2H8cBaihejNbg60NnlDi5pdRiLX0bqy0JZ5lYz+TR+GkN1aWr+gbSldUUzb0ffJzOfvYPgiLEvY=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:aa7:88ce:0:b0:688:ebc:6eaa with SMTP id
 k14-20020aa788ce000000b006880ebc6eaamr5772303pff.5.1692717292093; Tue, 22 Aug
 2023 08:14:52 -0700 (PDT)
Date:   Tue, 22 Aug 2023 08:14:50 -0700
In-Reply-To: <bf3af7eb-f4ce-b733-08d4-6ab7f106d6e6@amd.com>
Mime-Version: 1.0
References: <20230810234919.145474-1-seanjc@google.com> <bf3af7eb-f4ce-b733-08d4-6ab7f106d6e6@amd.com>
Message-ID: <ZOTQ6izCUfrBh2oj@google.com>
Subject: Re: [PATCH 0/2] KVM: SVM: Fix unexpected #UD on INT3 in SEV guests
From:   Sean Christopherson <seanjc@google.com>
To:     Tom Lendacky <thomas.lendacky@amd.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Wu Zongyo <wuzongyo@mail.ustc.edu.cn>
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 22, 2023, Tom Lendacky wrote:
> On 8/10/23 18:49, Sean Christopherson wrote:
> > Fix a bug where KVM injects a bogus #UD for SEV guests when trying to skip
> > an INT3 as part of re-injecting the associated #BP that got kinda sorta
> > intercepted due to a #NPF occuring while vectoring/delivering the #BP.
> > 
> > I haven't actually confirmed that patch 1 fixes the bug, as it's a
> > different change than what I originally proposed.  I'm 99% certain it will
> > work, but I definitely need verification that it fixes the problem
> > 
> > Patch 2 is a tangentially related cleanup to make NRIPS a requirement for
> > enabling SEV, e.g. so that we don't ever get "bug" reports of SEV guests
> > not working when NRIPS is disabled.
> > 
> > Sean Christopherson (2):
> >    KVM: SVM: Don't inject #UD if KVM attempts emulation of SEV guest w/o
> >      insn
> >    KVM: SVM: Require nrips support for SEV guests (and beyond)
> > 
> >   arch/x86/kvm/svm/sev.c |  2 +-
> >   arch/x86/kvm/svm/svm.c | 37 ++++++++++++++++++++-----------------
> >   arch/x86/kvm/svm/svm.h |  1 +
> >   3 files changed, 22 insertions(+), 18 deletions(-)
> 
> We ran some stress tests against a version of the kernel without this fix
> and we're able to reproduce the issue, but not reliably, after a few hours.
> With this patch, it has not reproduced after running for a week.
> 
> Not as reliable a scenario as the original reporter, but this looks like it
> resolves the issue.

Thanks Tom!  I'll apply this for v6.6, that'll give us plenty of time to change
course if necessary.
