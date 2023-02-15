Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B2C26982EE
	for <lists+kvm@lfdr.de>; Wed, 15 Feb 2023 19:06:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229968AbjBOSGN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Feb 2023 13:06:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229538AbjBOSGL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Feb 2023 13:06:11 -0500
Received: from mail-vs1-xe31.google.com (mail-vs1-xe31.google.com [IPv6:2607:f8b0:4864:20::e31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1DB134F70
        for <kvm@vger.kernel.org>; Wed, 15 Feb 2023 10:06:07 -0800 (PST)
Received: by mail-vs1-xe31.google.com with SMTP id d66so20707063vsd.9
        for <kvm@vger.kernel.org>; Wed, 15 Feb 2023 10:06:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=14Wsnq1C5/e/lr4OHIbzbe/RW8U5P8QTch1ADuqyPNc=;
        b=hqydrB0uk3xrYuEWrr9bC2c28vBvdOrWuT4o2GQyjyKHHMRGVquMplEKn0VEa7IG3z
         zDPbKd6PNbA8+cMSjjZJ+XY/jm106WMeZVNzEP1rVcs4pGglU3JTT/NTzterzjXgwbZu
         e7pvbkYFHd0k6CT2PbycxRlNPY7/TcAODYosIg6cF3OaA/8PLnDtJDpAcnhD5aQTIzsg
         Qg3fsJ45d4GMQ1hKwksNnZ0KFwhmWHRQRRTuQn8W+RBtH6mHF9lgMKRiXGn2KEx/GMlQ
         QmiDcJyYqdxCQ4+RbsIxNsGKLpnkix1GXBZkVFemnFQD1RDwOo8POfG5Uq1MtnEB3X4K
         WNSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=14Wsnq1C5/e/lr4OHIbzbe/RW8U5P8QTch1ADuqyPNc=;
        b=EQ1mhcIxUSo3DQfurfOBzxcyVOmk2KXCOk0uM1QdJPrTdTvjYQ38dpjLM+GN4NS6R2
         a77UXKAdz5asDBzYL8ikRfjxWJh6WOZCWTlnIuFpraQWd1gKr7+onG4NUi9iy1WzT2Zy
         qkvwlgIXslbeQqPUwK2yw5GrTVAw0D2KcOr5KcsNlqH6upVxq9rU38af0ULiKHqIV+R8
         OJvAsiFyoLGf/Kkk6LUozXpQSmqZX3MwAP9I+FR5KFpl4OYb+wqobnMdQ1aJyb+7p3je
         2m8kol6NEoOFwwsoFP6WtK62b3ykdmL1agXd41V2/0LqoKHuwlJQKbw+zOJCoh99pFN8
         hrZw==
X-Gm-Message-State: AO0yUKU/B71G7f02f8SJ+PFuy1uV5WQHR20ZxvER1XHoOWIF172jsZJs
        iH8NCSlsKCAO8yFSHA1UMBM/ZlFaAPGEjyJ4vE9LEQ==
X-Google-Smtp-Source: AK7set/KlyJWZTFcc9c+ciNsp30/44ed0OYWwISa16TuXvviGl/4f1NDwiurFeZZA96nyqwnVTbAz2TX63KihceiHCU=
X-Received: by 2002:a05:6102:3b01:b0:412:6a3:2267 with SMTP id
 x1-20020a0561023b0100b0041206a32267mr719527vsu.5.1676484366683; Wed, 15 Feb
 2023 10:06:06 -0800 (PST)
MIME-Version: 1.0
References: <20230215011614.725983-1-amoorthy@google.com> <20230215011614.725983-2-amoorthy@google.com>
 <Y+yJU2pE4IyuIwOQ@linux.dev> <Y+0L/x2YgiEgm9bt@google.com>
In-Reply-To: <Y+0L/x2YgiEgm9bt@google.com>
From:   Anish Moorthy <amoorthy@google.com>
Date:   Wed, 15 Feb 2023 10:05:55 -0800
Message-ID: <CAF7b7mpSOqzrxqXgpSjD17SufaV-2ZnLL5+eR29jJL_j=1aFvA@mail.gmail.com>
Subject: Re: [PATCH 1/8] selftests/kvm: Fix bug in how demand_paging_test
 calculates paging rate
To:     Sean Christopherson <seanjc@google.com>
Cc:     Oliver Upton <oliver.upton@linux.dev>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Marc Zyngier <maz@kernel.org>,
        James Houghton <jthoughton@google.com>,
        Ben Gardon <bgardon@google.com>,
        David Matlack <dmatlack@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Axel Rasmussen <axelrasmussen@google.com>, kvm@vger.kernel.org,
        kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
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

On Wed, Feb 15, 2023 at 8:44 AM Sean Christopherson <seanjc@google.com> wrote:
>
> On Wed, Feb 15, 2023, Oliver Upton wrote:
> > Hi Anish,
> >
> > On Wed, Feb 15, 2023 at 01:16:07AM +0000, Anish Moorthy wrote:
> > > Currently we're dividing tv_nsec by 1E8, not 1E9.
> > >
> > > Reported-by: James Houghton <jthoughton@google.com>
> > > Signed-off-by: Anish Moorthy <amoorthy@google.com>
> > > ---
> > >  tools/testing/selftests/kvm/demand_paging_test.c | 2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > >
> > > diff --git a/tools/testing/selftests/kvm/demand_paging_test.c b/tools/testing/selftests/kvm/demand_paging_test.c
> > > index b0e1fc4de9e29..6809184ce2390 100644
> > > --- a/tools/testing/selftests/kvm/demand_paging_test.c
> > > +++ b/tools/testing/selftests/kvm/demand_paging_test.c
> > > @@ -194,7 +194,7 @@ static void run_test(enum vm_guest_mode mode, void *arg)
> > >             ts_diff.tv_sec, ts_diff.tv_nsec);
> > >     pr_info("Overall demand paging rate: %f pgs/sec\n",
> > >             memstress_args.vcpu_args[0].pages * nr_vcpus /
> > > -           ((double)ts_diff.tv_sec + (double)ts_diff.tv_nsec / 100000000.0));
> > > +           ((double)ts_diff.tv_sec + (double)ts_diff.tv_nsec / 1E9));
> >
> > Use NSEC_PER_SEC instead so the conversion taking place is immediately
> > obvious.
>
> And please post this separately, it's a fix that's independent of the rest of the
> series and can/should be applied sooner than later.

Will do, and thanks for the pointer to NSEC_PER_SEC Oliver.
