Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BCC586BF6B1
	for <lists+kvm@lfdr.de>; Sat, 18 Mar 2023 00:52:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230025AbjCQXwP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Mar 2023 19:52:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229560AbjCQXwN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Mar 2023 19:52:13 -0400
Received: from mail-yb1-xb2c.google.com (mail-yb1-xb2c.google.com [IPv6:2607:f8b0:4864:20::b2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 515C76C68A
        for <kvm@vger.kernel.org>; Fri, 17 Mar 2023 16:52:02 -0700 (PDT)
Received: by mail-yb1-xb2c.google.com with SMTP id e194so7444947ybf.1
        for <kvm@vger.kernel.org>; Fri, 17 Mar 2023 16:52:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679097121;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eQMD/29uw8RUz0fNzK2trwLryR+NGIrIQSt625LLiR4=;
        b=TS6enXcAOm38L7QvT+K/jT3x16hmeT+y+4kagaEDckdmpRvnOeAsbBSaoxSgJNrMG9
         hSDoMP05VscGo4LbTYECC5AxoNaVqnnTnHAs/iWsoKurGamEavoev9wvQFzc5ajoajeu
         DYLeXS21zZR/OdOOW6HSDWhDHkm0jkfxTu0QoA9CnKv9CUV4sjRRndhJhVmkIO1l+wiO
         zZFvqMqBj5ylb0eGeV9fiDugpe8fq+UHlDR1JCe/RfaO4Rm5ay4W9VOz4jkfVIkbHLVr
         BGzYpR9cO24ehDUEE1+X4CiHtCVUjxXxZNeZLMWIFUHSXrcjpQHtzE7T714PnT4ICFBm
         QduA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679097121;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=eQMD/29uw8RUz0fNzK2trwLryR+NGIrIQSt625LLiR4=;
        b=pxqrHiTFLMN953jFdMchfeIVIqUty9Y1+T+oqL4epBRVHbv8MB4jvP96B43IbGUhbo
         NHUKxbMmgYuihY4DzJUlKsVf5fiqSmbHLfOi9/+FlmvF/8yycwCBeUaVz73lQy3A7BcR
         7ID5XsAwc+SQNo3AF0QwKzvzkwG5jd9TgSHRih8cqwC+QJshTuXqMjoChFT1OL7y4T5Q
         9KQETWwrmA9MH6GKdSUEDHG4j2Neoun+2QODcOTwGDDMLR8S7WSNT0JL1MI3LGi8u+je
         kTrs4jYqs8XF86iCr6WkJ3cLQzixk0gKrt5MMG9WHA/9X+u25DXPv8mGfConKEjd12jA
         e04g==
X-Gm-Message-State: AO0yUKUBOSrosXgr9MLceaj7C2qzpG2KqfvYlQMKaCz1+kuqBhBu4h1d
        UTuD9x41Q+ojod3WraxaWAiijR5BB8NcsCLGyOvyGw==
X-Google-Smtp-Source: AK7set/6K0VHPQzMrr66R5AXYXA3YJNzCDyiJiEWzDsvRDdmZ6ptCgflUF6JxqibsYXvfUTKehd9lDdnM5vVfI53kFo=
X-Received: by 2002:a5b:181:0:b0:acd:7374:f15b with SMTP id
 r1-20020a5b0181000000b00acd7374f15bmr187259ybl.13.1679097121136; Fri, 17 Mar
 2023 16:52:01 -0700 (PDT)
MIME-Version: 1.0
References: <20230211014626.3659152-1-vipinsh@google.com> <ZBTwX5790zwl5721@google.com>
In-Reply-To: <ZBTwX5790zwl5721@google.com>
From:   Vipin Sharma <vipinsh@google.com>
Date:   Fri, 17 Mar 2023 16:51:25 -0700
Message-ID: <CAHVum0fw2RXfqLNMbAFHbwh1P-O0JjnDCUTco9zt18mBi4Pk-Q@mail.gmail.com>
Subject: Re: [Patch v3 0/7] Optimize clear dirty log
To:     Sean Christopherson <seanjc@google.com>
Cc:     pbonzini@redhat.com, bgardon@google.com, dmatlack@google.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
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

On Fri, Mar 17, 2023 at 3:57=E2=80=AFPM Sean Christopherson <seanjc@google.=
com> wrote:
>
> On Fri, Feb 10, 2023, Vipin Sharma wrote:
> > This patch series has optimized control flow of clearing dirty log and
> > improved its performance by ~40% (2% more than v2).
> >
> > It also got rid of many variants of the handle_changed_spte family of
> > functions and converged logic to one handle_changed_spte() function. It
> > also remove tdp_mmu_set_spte_no_[acc_track|dirty_log] and various
> > booleans for controlling them.
> >
> > v3:
> > - Tried to do better job at writing commit messages.
>
> LOL, that's the spirit!
>
> Did a cursory glance, looks good.  I'll do a more thorough pass next week=
 and get
> it queued up if all goes well.  No need for a v4 at this point, I'll fixu=
p David's
> various nits when applying.  I'll also add a link in patch 2 to the discu=
ssion

Yeah, he is too demanding! :p

> about why we determined that bypassing __tdp_mmu_set_spte() is safe; that=
's critical
> information that isn't captured in the changelog.

Thanks!
