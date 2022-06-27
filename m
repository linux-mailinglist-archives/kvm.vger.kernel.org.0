Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE76155D19A
	for <lists+kvm@lfdr.de>; Tue, 28 Jun 2022 15:09:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240402AbiF0Sj6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Jun 2022 14:39:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240213AbiF0Sj4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Jun 2022 14:39:56 -0400
Received: from mail-lj1-x22e.google.com (mail-lj1-x22e.google.com [IPv6:2a00:1450:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F640B88
        for <kvm@vger.kernel.org>; Mon, 27 Jun 2022 11:39:55 -0700 (PDT)
Received: by mail-lj1-x22e.google.com with SMTP id o23so12011979ljg.13
        for <kvm@vger.kernel.org>; Mon, 27 Jun 2022 11:39:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=j4hbmbJoMUR/043f1gtsU9ggy7W36/KPjU+Af3Jvda8=;
        b=W2bp3N/nc6A9fd8TGl01wDh9lzy9wHDNwzOb6PTiyT5sHPZ9gZsWvNOfQM+oO2QLy6
         hn6cLw585q9YpYXzFr7ggc2fH86iRssYldTefymZoF3iUnFAgSvdGVCjX9WlaZ8im9q4
         6g6HM3bkfYLU9V7ObvqHMofQwZw4Jmsz8Xv/qWgl3KXxofKkdfsaKS/5x/303/PhHMEn
         UhvAdPSSo0YVDSgcCT9pjeyj8yay52Ham8/uSv14B1iA991nV1cdeUFb9e0SmtFRjFyg
         tN7V4WRIv4w6Qqqv8Em05r4ZKFGt6EiC6pPmL/IG4V61eL8MjRNAhkz8U2fXq0jp1cLS
         ULUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=j4hbmbJoMUR/043f1gtsU9ggy7W36/KPjU+Af3Jvda8=;
        b=y6pRHwWxEQvStRev4p985LDnBIqOAHh/UObbDzFiWVU82vhR/Gvgm77gGM+Yi7ge2D
         DSg9Omij4teDTojimTbsfJ6Aos4hmxhioqzzC0+rPUJwOBao25FlBnzD3J2soL5YI3jy
         NC+k+ye/Gxw5vf/6sg394qydw+eF7s3+ey49nX2xaxxxrE0j6C0yC5jsQbO9Lac84tuP
         RK/snDDcN+/gZ0+QL+3E9xQX8FKQ28Rlg5OY4RFzY6B2yYQWTmxgNAcoINUK1f/RmZFD
         7TZI1zk0bGs7qneM1gvw4jqBAjcJxDlawHhGrm5HOxEeJrwBssuKvStSYGewwuGcCuHX
         OGuA==
X-Gm-Message-State: AJIora8e8Cd1vO122hw/yW2nIm0IFWop7N2Gr8kce/UlzLCE+omq+A/0
        rAjeCg8YZPOKvSeCUkWjHETaQiIO+xvSCpUR1KbNtg==
X-Google-Smtp-Source: AGRyM1t2YlhNyy2b2oS22ZEa07490K1W8KWHnnHXnjPVpPlJppubAGVaXmqVB682qW55u19S3zFl1fTsyodE0sxBOaw=
X-Received: by 2002:a2e:2a43:0:b0:25a:84a9:921c with SMTP id
 q64-20020a2e2a43000000b0025a84a9921cmr7461767ljq.83.1656355193311; Mon, 27
 Jun 2022 11:39:53 -0700 (PDT)
MIME-Version: 1.0
References: <20220627161123.1386853-1-pgonda@google.com> <Yrnync27TAhgSRUq@google.com>
In-Reply-To: <Yrnync27TAhgSRUq@google.com>
From:   Peter Gonda <pgonda@google.com>
Date:   Mon, 27 Jun 2022 12:39:41 -0600
Message-ID: <CAMkAt6q9iTsJO=UY_6588Zqa_rUjr5c01H5NsCj-4FiuTGnncw@mail.gmail.com>
Subject: Re: [PATCH] KVM: SEV: Clear the pages pointer in sev_unpin_memory
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm list <kvm@vger.kernel.org>, Greg Thelen <gthelen@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 27, 2022 at 12:10 PM Sean Christopherson <seanjc@google.com> wrote:
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
>

No strong opinion here, I just thought since this is a helper that
takes a 'struct page **pages" we may as well clear this. While there
are no bugs caught now if someone were to introduce something wrong
this would make it more clear.

We could update sev_unpin_memory() to take a int *npages so it can be
cleared as well. Since kvm_enc_region describes a region with u64
instead of pointers that seemed "safer" give you'd have to cast them
to dereference.

Totally fine with the NACK of course. =]
