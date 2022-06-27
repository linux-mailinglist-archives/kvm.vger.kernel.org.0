Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2CFFD55DBF6
	for <lists+kvm@lfdr.de>; Tue, 28 Jun 2022 15:25:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240747AbiF0U6L (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Jun 2022 16:58:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240650AbiF0U6E (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Jun 2022 16:58:04 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0848A16582
        for <kvm@vger.kernel.org>; Mon, 27 Jun 2022 13:58:00 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id g10-20020a17090a708a00b001ea8aadd42bso10630796pjk.0
        for <kvm@vger.kernel.org>; Mon, 27 Jun 2022 13:58:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=adMAWDqE9XsjKAybHVZCJMjitDWcVJbYgUcZRIR8kZM=;
        b=IhjZyX1kpPfVbaRXMX6O2DUl1E29zWnsmW8TdwKFdiCdMrS9lryLzUkp+Z4IsKSYCV
         UPSo2Ky4iZlqCSDqj15OwuvYjxS5dudFNLGVn0qos9S1h0UZLWyc9HKUhme3BMOHQGYt
         8kTgPGOgHPW7OiffilgZPkvCKCbxPDEFvdj6TIzFNajCm1DMbOXd1cZZI2wZrCU8RvoL
         odiw71jjk3HTrOeg5gYSwbC1BD2wa/61NWA4PC1rP44Skfnpqp6I8w+4xFwAk5xnxwER
         ZMJUGVc5fsObVT/oQscvxvks+tbpTHJh3iXSdRPSXdvs5R/o909zGRIOuMcL02CeWsz8
         9mTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=adMAWDqE9XsjKAybHVZCJMjitDWcVJbYgUcZRIR8kZM=;
        b=l7Sd7k8O4GiNREmA+5ndlf38a5/CQdC2BViBgHo4cEdZBhPPoe1WcN+TjSn237Kp9B
         hS1t/jzQu8IZJv/FHJ95wFSJzQuaBkqWzWkM8SQ2UaLIl6iJOljJe0uwR145GuMuy3uk
         HTBPcjz1SpeQwuNBFvyihnW5Vy/zl2E1Q1LoOCzFlcX+CrGG8g1bjbYGfpHaRGOqrDj6
         Tshpq/S/0wZqiO6DQ3AqkgwCd/yMi1auZvNu9S0UqY7W1CAg3Cxf0MzNSgxMrJmLiQ7h
         jkqLeL3Ie2D9B4L6S5IHTjK7B1QZsiFHjaR2AeTDndkjq78iCG10lV8RHi8bKLmkvYrs
         rHRg==
X-Gm-Message-State: AJIora+pbjTvvgRgZdtbKvpqs/LdIpy9a7jhfEL9wutu6aRBVpcuKkuX
        rIllVpvhZMa+z+sDA9Dx1O5LSec53TB4kChnHFCvMrXzbo0=
X-Google-Smtp-Source: AGRyM1vsi9I/iHkofZJSd+JvWcYEJXAo0EHK8vTZDryp/NkqE1Nja1RSidybLFzaWCLFag058s/S2XjJBy92xC0+cbo=
X-Received: by 2002:a17:90b:2245:b0:1ed:fef:5656 with SMTP id
 hk5-20020a17090b224500b001ed0fef5656mr17433525pjb.100.1656363479320; Mon, 27
 Jun 2022 13:57:59 -0700 (PDT)
MIME-Version: 1.0
References: <20220627161123.1386853-1-pgonda@google.com> <Yrnync27TAhgSRUq@google.com>
In-Reply-To: <Yrnync27TAhgSRUq@google.com>
From:   Mingwei Zhang <mizhang@google.com>
Date:   Mon, 27 Jun 2022 13:57:48 -0700
Message-ID: <CAL715WKEUYRFf2n9Gjx_n7oD1gRUVG1t73CNrS416YDWyKtV1A@mail.gmail.com>
Subject: Re: [PATCH] KVM: SEV: Clear the pages pointer in sev_unpin_memory
To:     Sean Christopherson <seanjc@google.com>
Cc:     Peter Gonda <pgonda@google.com>, kvm <kvm@vger.kernel.org>,
        Greg Thelen <gthelen@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 27, 2022 at 1:37 PM Sean Christopherson <seanjc@google.com> wrote:
>
> On Mon, Jun 27, 2022, Peter Gonda wrote:
> > Clear to the @pages array pointer in sev_unpin_memory to avoid leaving a
> > dangling pointer to invalid memory.
> >
> > Signed-off-by: Peter Gonda <pgonda@google.com>
> > Cc: Greg Thelen <gthelen@google.com>
> > Cc: Paolo Bonzini <pbonzini@redhat.com>
> > Cc: Sean Christopherson <seanjc@google.com>
> > Cc: Tom Lendacky <thomas.lendacky@amd.com>
> > Cc: kvm@vger.kernel.org
> > Cc: linux-kernel@vger.kernel.org
> > ---
> >  arch/x86/kvm/svm/sev.c | 1 +
> >  1 file changed, 1 insertion(+)
> >
> > diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> > index 309bcdb2f929..485ad86c01c6 100644
> > --- a/arch/x86/kvm/svm/sev.c
> > +++ b/arch/x86/kvm/svm/sev.c
> > @@ -452,6 +452,7 @@ static void sev_unpin_memory(struct kvm *kvm, struct page **pages,
> >       unpin_user_pages(pages, npages);
> >       kvfree(pages);
> >       sev->pages_locked -= npages;
> > +     *pages = NULL;
>
> Would this have helped detect a real bug?  I generally like cleaning up, but this
> leaves things in a somewhat inconsistent state, e.g. when unpinning a kvm_enc_region,
> pages will be NULL but npages will be non-zero.  It's somewhat moot because the
> region is immediately freed in that case, but that begs the question of what real
> benefit this provides.  sev_dbg_crypt() is the only flow where there's much danger
> of a use-after-free.

+1

We could send thousands of patches like this. But I think none of them
would be directly helpful. Sometimes, things could be even worse,
i.e., imagine when those NULL pointers got deferenced, they become
BUG_ON(true).

If there are bugs related with those pointers, better to fix those bugs instead.

Thanks.
-Mingwei
