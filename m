Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 84CEE68331D
	for <lists+kvm@lfdr.de>; Tue, 31 Jan 2023 17:57:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231638AbjAaQ5l (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 Jan 2023 11:57:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231267AbjAaQ5j (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 31 Jan 2023 11:57:39 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B55882194B
        for <kvm@vger.kernel.org>; Tue, 31 Jan 2023 08:57:36 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id mi9so5610877pjb.4
        for <kvm@vger.kernel.org>; Tue, 31 Jan 2023 08:57:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=14imYuPslwfP5H8cnWfz8QxH/e2ZfUOvxpAJV9XqulA=;
        b=mbD8Ff7JFJvCngfid+7mhmM8jWXmseJodJRL3aN9D2ftSw6vHEbyNt9KP26vbi+2Z7
         IszTrfBKtBtmHXivkz4ELycCORgcvwqgKottCllJdlVOXI5pTdFeWvNAQcocGsbYVduI
         bxETTRLlZZlXCh4/AIsMbHrhMX543OpIRuPWM95gXNuTpJEi0E2AqQZH1sOTfVV0lvSL
         5lCcmeSJfPBRQDh7t+WEEsvKju1CdkljKvN5y7kEvzefYiIWaDox/L+qFfqujUGhh4wZ
         aPlXgWyiMi9HxrdPlp1OmybyPCefH+k5C7VDxt/pcn0sKNfBdEvDtbrUOGa+CQEFrBje
         DCDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=14imYuPslwfP5H8cnWfz8QxH/e2ZfUOvxpAJV9XqulA=;
        b=CsHh0G8dZq+zlsHv0vhc06+knuB7DKBdKI3qZqZqSUREwUzvTHJBM6hbgaXv5Yr9K8
         FQdlAKdwXKDR+qdeZa3cEVenV6FQAc3iCUVJu0o6R7kaQXyEwm7TcMkb578Vzo+zMYRE
         10ziUwKluCQf4gZDa4bKyMwH5N6tQZ20xu+Pzb18LteqzKU8hzXXzTz22jKixfvYaLTY
         crP1XqNKfbyYRVqNMmmGcys5wOpmzi8W39+YCGmYKDDnT9oQq0eRN+uq0vuay+6uU+i0
         sdiCStyJw5PsKcD7UKC3Ke/6wxOsytAWYL+WONy/ghbuBzphukW2nzY04kVlSzUkNmx8
         CCoA==
X-Gm-Message-State: AO0yUKVMBvV8m1Ore84diSUc+ltq30PUBY1jk48A/csjMc0rBlaAi5fc
        Wm/Wyxh5vlZN80zoiRuVGd8ElA==
X-Google-Smtp-Source: AK7set9ZZA9mhdh+khjNhjPdLlljrgw4U2FCbVFuxT+Hoydlk0ZOoVDEHS+GEK+E04XKLE3NRzczTg==
X-Received: by 2002:a17:902:e88b:b0:189:b910:c6d2 with SMTP id w11-20020a170902e88b00b00189b910c6d2mr4586plg.1.1675184256040;
        Tue, 31 Jan 2023 08:57:36 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id c15-20020a170902b68f00b0019678eb963fsm5268343pls.145.2023.01.31.08.57.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Jan 2023 08:57:35 -0800 (PST)
Date:   Tue, 31 Jan 2023 16:57:32 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Vipin Sharma <vipinsh@google.com>
Cc:     Ben Gardon <bgardon@google.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Peter Xu <peterx@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Ricardo Koller <ricarkol@google.com>
Subject: Re: [PATCH v4 0/2] selftests: KVM: Add a test for eager page
 splitting
Message-ID: <Y9lIfGtMEEsaw6cd@google.com>
References: <20230125182311.2022303-1-bgardon@google.com>
 <CAHVum0eKdcsZ-6L0ypqL1CBW+2quyj_dPiqw83b-XMShoRkvig@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHVum0eKdcsZ-6L0ypqL1CBW+2quyj_dPiqw83b-XMShoRkvig@mail.gmail.com>
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

On Thu, Jan 26, 2023, Vipin Sharma wrote:
> On Wed, Jan 25, 2023 at 10:23 AM Ben Gardon <bgardon@google.com> wrote:
> >
> > David Matlack recently added a feature known as eager page splitting
> > to x86 KVM. This feature improves vCPU performance during dirty
> > logging because the splitting operation is moved out of the page
> > fault path, avoiding EPT/NPT violations or allowing the vCPU threads
> > to resolve the violation in the fast path.
> >
> > While this feature is a great performance improvement, it does not
> > have adequate testing in KVM selftests. Add a test to provide coverage
> > of eager page splitting.
> >
> > Patch 1 is a quick refactor to be able to re-use some code from
> > dirty_log_perf_test.
> > Patch 2 adds the actual test.
> >
> > V1->V2:
> Links of previous versions of patches are helpful and avoid searching
> if one wants to read previous discussions.

+1

I also strongly prefer versioning to go from newest=>oldest instead of oldest=>newest,
that way reviewers can quickly see the delta for _this_ version.  It doesn't matter
too much when the delta is small, but oldest=>newest gets _really_ annoying the
longer the list gets.

> >         Run test in multiple modes, as suggested by David and Ricardo
> >         Cleanups from shameful copy-pasta, as suggested by David
> > V2->V3:
> >         Removed copyright notice from the top of
> >         dirty_log_page_splitting.c
> >         Adopted ASSERT_EQ for test assertions
> >         Now skipping testing with MANUAL_PROTECT if unsupported
> > V3->V4:
> >         Added the copyright notices back. Thanks Vipin for the right
> >         thing to do there.

Please do _something_ to differentiate line items.  I would also drop the tabs in
favor of a single space or two so that you don't end up wrapping so much.  E.g.
(choose your preferred flavor of list item identifiers)

V3->V4:
  - Added the copyright notices back. Thanks Vipin for the right thing to do
    there

V2->V3:
  - Removed copyright notice from the top of dirty_log_page_splitting.c
  - Adopted ASSERT_EQ for test assertions
  - Now skipping testing with MANUAL_PROTECT if unsupported
