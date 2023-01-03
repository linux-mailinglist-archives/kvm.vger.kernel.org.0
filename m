Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C42765C9A1
	for <lists+kvm@lfdr.de>; Tue,  3 Jan 2023 23:25:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238486AbjACWZg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Jan 2023 17:25:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238884AbjACWZP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Jan 2023 17:25:15 -0500
Received: from mail-yb1-xb29.google.com (mail-yb1-xb29.google.com [IPv6:2607:f8b0:4864:20::b29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 498CC1A204
        for <kvm@vger.kernel.org>; Tue,  3 Jan 2023 14:22:50 -0800 (PST)
Received: by mail-yb1-xb29.google.com with SMTP id v126so34721430ybv.2
        for <kvm@vger.kernel.org>; Tue, 03 Jan 2023 14:22:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=lXp0j4GCOk5XOroIoxP2nQDe8lAMlFEZC0dCDiq7XBk=;
        b=dYnGkaP4RbPOM+0TTYgWWpcUxHSKxE07mLrY0dk6EmuddIKOE3YKA7G71vdHMZs3DD
         BsWTASBle2BGb6sD9gQDL9sxMBKf7EE2rSv57Encs1SYpPZLDwmZxhLy947jbNb1CRzD
         FSRsgD9883B5WZ4+926ycmCKY4G0bQHFoLNUQJRF+6VIqC/1/1FOOVTr28nlgoOVSGVZ
         JEEK3iESOoaIbXQdLgjvu3fuNgeADiRfuxD0iiyJwbqs+0VIqcdvXpqgKeOEOBU60t9k
         /4LhR2xxD7QifB1nDNBVlaEex+YuvnoU7CeijQv31w4zDh4vH+K4mCjiOZuO3G3lFu53
         A4PA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=lXp0j4GCOk5XOroIoxP2nQDe8lAMlFEZC0dCDiq7XBk=;
        b=EYqbmQNkOaRZHzk7LyOwmJgPHbD2ov7vPEnTJvAa0DKTqA7wcQbWRtwM4m3yHfVJSk
         yVa+Yw3AB7yeBwau3wUzeXDJAL/UpenoB1Hda+EOEtYcY5wKx9Yu6i3oVOMSMAQ724hl
         /rbnq+apzAqLpappURC1piExoYaFdrcEu3bDFXdrcDNbsQvCTdYkC7vH0GJi1+P1Gmmm
         rGi7BO5LoE+/wjEO8Dd6vIUgCO5IkQcGshSZF3u8YOF8F3t19ThMiKdbUT52WqTJJNzU
         PQeyzVh79BGI9Odi/3zLbELf1dtAOHziDxoNwk/bP/T17Jsqua8ZydDwuv7b4hEr7/SR
         jwDQ==
X-Gm-Message-State: AFqh2kr9oF28g1ajhzfbAW2AkWaiiS83YPoEI/WJlEC5DVkwrd5YSg3k
        AW6xU6o19MHCRTdQFbhS+VecZI5ASCX3PicoKGST0dP9S8atQw==
X-Google-Smtp-Source: AMrXdXtyd8r370S7Xirp2AdLezJXgdGS+yT2IAUz+An4MrtW2Yi4j+KsuothTxG89fEw8k73pT/CjUWbSjD7R4tm1nQ=
X-Received: by 2002:a25:4288:0:b0:762:7ce4:2288 with SMTP id
 p130-20020a254288000000b007627ce42288mr2960580yba.303.1672784542974; Tue, 03
 Jan 2023 14:22:22 -0800 (PST)
MIME-Version: 1.0
References: <20221213033030.83345-1-seanjc@google.com> <20221213033030.83345-6-seanjc@google.com>
 <Y6H2o2ADCALDA2oL@google.com> <Y6NRJTboZnjKbAL7@google.com>
 <Y63v0UnlI+wrrXfa@google.com> <49636b4c-10e1-8cec-efdf-e2bd4b832a9e@redhat.com>
In-Reply-To: <49636b4c-10e1-8cec-efdf-e2bd4b832a9e@redhat.com>
From:   David Matlack <dmatlack@google.com>
Date:   Tue, 3 Jan 2023 14:21:56 -0800
Message-ID: <CALzav=cUem-czTA9oc+oV+=iqmW0DVf_+mBbr2SpAp8xQsRY8Q@mail.gmail.com>
Subject: Re: [PATCH 5/5] KVM: x86/mmu: Move kvm_tdp_mmu_map()'s prolog and
 epilog to its caller
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Robert Hoo <robert.hu@linux.intel.com>,
        Greg Thelen <gthelen@google.com>,
        Ben Gardon <bgardon@google.com>,
        Mingwei Zhang <mizhang@google.com>
Content-Type: text/plain; charset="UTF-8"
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

On Thu, Dec 29, 2022 at 1:06 PM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 12/29/22 20:51, David Matlack wrote:
> > Your proposal (below) to split out the "lower half" of the page fault
> > handling routine works now because that's where all the divergence is.
> > But with the common MMU there's also going to be divergence in the fast
> > page fault handler. So I prefer to just keep the routines separate to
> > avoid thrashing down the road.
>
> Can you put the changes at the beginning of the common MMU series?

Can do. By "the changes" I assume you mean the yet-to-be-written
changes to split out a fast_page_fault() handler for the TDP MMU? Or
do you mean Sean's changes (this series)?

> Large parts of the whole common MMU refactoring can be merged piece by
> piece, so they can be taken as soon as they're ready.

Ack.
