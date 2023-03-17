Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 972706BF0FD
	for <lists+kvm@lfdr.de>; Fri, 17 Mar 2023 19:47:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229798AbjCQSrb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Mar 2023 14:47:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229616AbjCQSr3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Mar 2023 14:47:29 -0400
Received: from mail-ua1-x933.google.com (mail-ua1-x933.google.com [IPv6:2607:f8b0:4864:20::933])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F4004C927F
        for <kvm@vger.kernel.org>; Fri, 17 Mar 2023 11:47:25 -0700 (PDT)
Received: by mail-ua1-x933.google.com with SMTP id x33so3965706uaf.12
        for <kvm@vger.kernel.org>; Fri, 17 Mar 2023 11:47:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679078845;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=V+Qmht/GxJ6JFAAlohGr3Nij8kDTEBI3rBBvyi6NDiM=;
        b=dzzLUy55WOMSH/m1iD/RSl5QH/2jc2XpMnkhU0PDNVCq5Ku06GX292BDqizWXpg9lE
         heH0TnmAvBiDRN2uhM0M1vMrTKzVNqIv9jsKUAr71Ryy3qQpoO1xyAQlSwbX2lQmB/7+
         Q6CoOCUwk8ngneiwNMo6Cu4tPrgPja7S+FYs8nNGCSoQ6fmyzBqvmEbtCOBAZwC4Kxtc
         aoJfUK+d46Ig7gvo4zSjye5uycndnFLJMGpZ2B7RBnK0LzPt2Bgik8r6aqskiiwpkW0G
         RBBZtP5TMZWakTgBRfz6aTBOYSGacW8uSn7yOggvzcbIlwV8/TmKC74SLAnLjfp+yz5C
         tMug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679078845;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=V+Qmht/GxJ6JFAAlohGr3Nij8kDTEBI3rBBvyi6NDiM=;
        b=QYl/zT1kkG/PRze2vqgECtx7B2che5ED6+o2HjNL7mfmcX4HzN6+XGNLBOwqfCsRhx
         aiWPM2BEQkodpUcwcrEgbW36+8R8ubWc/WFJcCDFe2sNg7FUib+0oz+7lt+rLIN2vJxr
         79P57T3nnQfF79fqEDCCAaLDIxwwin11AK4DXS0eV8cAkjaOBBOzmD35rkMVOINlQ89o
         Kowa4uAqjM0ddGzpEWbag66Qq/cOVDPf5KLnriP174+BlhwLNP2U3tlgkTEAclHa3KjB
         TB9kaSMxxyeoK/OAAEHNgE9NW9kBlGGtfo1YR7xWPaGOoLdIkVGwS1MILcA4A0gyYXMI
         OwXw==
X-Gm-Message-State: AO0yUKVCr+VvZXlnm+UAu2CjvUWKGmYLy7Nn24B9bTTe4LccT069Zumb
        yekbSY4szjKVmxPONctygTNbh9gn/adV/ycZb93a9w==
X-Google-Smtp-Source: AK7set8arpUSNgclIO10ass1x4j2DR/zlPhJgCvUb/cRyCR23P7THdXguFcDbSipZxasdZzsalbO8V7DVH8rnRAKu1k=
X-Received: by 2002:ab0:6cf1:0:b0:68a:702a:2494 with SMTP id
 l17-20020ab06cf1000000b0068a702a2494mr266702uai.0.1679078844905; Fri, 17 Mar
 2023 11:47:24 -0700 (PDT)
MIME-Version: 1.0
References: <20230315021738.1151386-1-amoorthy@google.com> <ZBSmz0JAgTrsF608@linux.dev>
 <ZBStyKk6H73/0z2r@google.com>
In-Reply-To: <ZBStyKk6H73/0z2r@google.com>
From:   David Matlack <dmatlack@google.com>
Date:   Fri, 17 Mar 2023 11:46:58 -0700
Message-ID: <CALzav=dBJyr373jnBF_-uLJfZMwHOsKSVSR2u4xr83etjp6Daw@mail.gmail.com>
Subject: Re: [WIP Patch v2 00/14] Avoiding slow get-user-pages via memory
 fault exit
To:     Sean Christopherson <seanjc@google.com>
Cc:     Oliver Upton <oliver.upton@linux.dev>,
        Anish Moorthy <amoorthy@google.com>, jthoughton@google.com,
        kvm@vger.kernel.org, maz@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
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

On Fri, Mar 17, 2023 at 11:13=E2=80=AFAM Sean Christopherson <seanjc@google=
.com> wrote:
>
> On Fri, Mar 17, 2023, Oliver Upton wrote:
> > On Wed, Mar 15, 2023 at 02:17:24AM +0000, Anish Moorthy wrote:
> > > Hi Sean, here's what I'm planing to send up as v2 of the scalable
> > > userfaultfd series.
> >
> > I don't see a ton of value in sending a targeted posting of a series to=
 the
> > list.

But isn't it already generating value as you were able to weigh in and
provide feedback on technical aspects that you would not have been
otherwise able to if Anish had just messaged Sean?

> > IOW, just CC all of the appropriate reviewers+maintainers. I promise,
> > we won't bite.

I disagree. While I think it's fine to reach out to someone off-list
to discuss a specific question, if you're going to message all
reviewers and maintainers, you should also CC the mailing list. That
allows more people to follow along and weigh in if necessary.

>
> +1.  And though I discourage off-list review, if something is really trul=
y not
> ready for public review, e.g. will do more harm than good by causing conf=
using,
> then just send the patches off-list.  Half measures like this will just m=
ake folks
> grumpy.

In this specific case, Anish very clearly laid out the reason for
sending the patches and asked very specific directed questions in the
cover letter and called it out as WIP. Yes "WIP" should have been
"RFC" but other than that should anything have been different?
