Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D466555496
	for <lists+kvm@lfdr.de>; Wed, 22 Jun 2022 21:34:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358629AbiFVTej (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Jun 2022 15:34:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358996AbiFVTeE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Jun 2022 15:34:04 -0400
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A9D13CA74
        for <kvm@vger.kernel.org>; Wed, 22 Jun 2022 12:33:45 -0700 (PDT)
Received: by mail-lf1-x134.google.com with SMTP id y32so29492557lfa.6
        for <kvm@vger.kernel.org>; Wed, 22 Jun 2022 12:33:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NFbRch3MP4oYfAdvYfvFh8xRiPwpBI5r6t1BeeKJjDI=;
        b=UzPfjg3Uhny7RcirHKXTpM6X1BLTfbOJLhkHD4gGRWY0a0tN5rFpv5odkr4cWEwqc9
         +BpnwLCdTfIKXBzH3Oqa/vnt5dxjVrC1sSX6pk94EZgY6RyhOwotmjRHUW5N2F8QBBKQ
         aHZRW5feO56dfBhra30Q3llLrK+qx0uQEiNGMLmCPxwaHfdIs9hzkre63BMLikRjbBGm
         8GARYSOusQ7rMBtubyguN+EQVaGXKSwVm9udIECZQ8Yuq2dmzv12lUKqlF8MQQU1NOPV
         9ARpkQMiexdqxfXbKQzuZphHMVhVN5OyQNSj16EpbExLMYi2j+4qRirHRTE9fv7WqEm/
         Tipw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NFbRch3MP4oYfAdvYfvFh8xRiPwpBI5r6t1BeeKJjDI=;
        b=tCROQzbPD8yVvSSsq5VPWoalL3nfRmmALPw63vthxWUA7I/XgQt89VI4S42ml03zAR
         BwyHil9qVOS9St0RmMF8n7nWRzbETpWzLUWsrIxDBfUs6b7IyGjj7893rzGFKumPAVpy
         RPjkTEwKG+ZpJsKaxoOumF1uAJAQLhX7JTFJYFv0fO4rHFA9PEAs7OtK6+OWhFHyIRtj
         WWnF/z11px/yK23QLU5/GU5DlAnac+Idft1vw+z8vP8JI9OybApCILu+fEGPz91ZKnJv
         /H8QczEJZ5CYy3aQ23IJholCZCN1yHR5ht4NqwqlUYdxF2nBOSlit8ubFFc9sBy1VWXO
         L9zg==
X-Gm-Message-State: AJIora84nk0e8DFMyz1IqUlGljPTLP39MvXXgs1ozK7MU+WkyefHLwtF
        fLMFfR/SU9pSc0mkZogJhrsulbG4lZdLiKbs+M8qXQ==
X-Google-Smtp-Source: AGRyM1t2HS4ZyWkAiJQg85nvcNXwFn3bkAAE5g1dd7le8l/22YRvukDaRru6XjTm1AhTsK/kCtarFzkU/1DaCx22dOc=
X-Received: by 2002:a19:6449:0:b0:47f:86b3:f87b with SMTP id
 b9-20020a196449000000b0047f86b3f87bmr3043737lfj.644.1655926423674; Wed, 22
 Jun 2022 12:33:43 -0700 (PDT)
MIME-Version: 1.0
References: <20220617195141.2866706-1-pgonda@google.com> <Yqz+CZlGCoQo7lMQ@google.com>
In-Reply-To: <Yqz+CZlGCoQo7lMQ@google.com>
From:   Peter Gonda <pgonda@google.com>
Date:   Wed, 22 Jun 2022 13:33:32 -0600
Message-ID: <CAMkAt6p6U6G0N0UP-Dnatr1cLHnaU1DY-1gxvmYhvxjckhbx4g@mail.gmail.com>
Subject: Re: [PATCH] KVM: SEV: Init target VMCBs in sev_migrate_from
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm list <kvm@vger.kernel.org>, Marc Orr <marcorr@google.com>,
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

> >
> > +void sev_init_vmcb(struct vcpu_svm *svm)
> > +{
> > +     svm->vmcb->control.nested_ctl |= SVM_NESTED_CTL_SEV_ENABLE;
> > +     clr_exception_intercept(svm, UD_VECTOR);
>
> I don't love separating SEV and SEV-ES VMCB initialization, especially since they're
> both doing RMW operations and not straight writes.  E.g. migration ends up reversing
> the order between the two relatively to init_vmcb().  That's just asking for a subtle
> bug to be introduced that affects only due to the ordering difference.
>
> What about using common top-level flows for SEV and SEV-ES so that the sequencing
> between SEV and SEV-ES is more rigid?  The resulting sev_migrate_from() is a little
> gross, but IMO it's worth having a fixed sequence, and the flip side to the ugliness
> it that it documents some of the differences between SEV and SEV-ES migration.

Thanks for the suggestion Sean! I like your suggestion here. I'll test
it out, clean it up and send it out as V2. I think the distinction
between SEV and SEV-ES migration was largely due to how I split up the
set of patches that enabled this feature.
