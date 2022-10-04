Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B03595F47B4
	for <lists+kvm@lfdr.de>; Tue,  4 Oct 2022 18:34:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230146AbiJDQe3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Oct 2022 12:34:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230136AbiJDQe1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Oct 2022 12:34:27 -0400
Received: from mail-yb1-xb2d.google.com (mail-yb1-xb2d.google.com [IPv6:2607:f8b0:4864:20::b2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E48E5D0D1
        for <kvm@vger.kernel.org>; Tue,  4 Oct 2022 09:34:26 -0700 (PDT)
Received: by mail-yb1-xb2d.google.com with SMTP id 207so14149909ybn.1
        for <kvm@vger.kernel.org>; Tue, 04 Oct 2022 09:34:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=EmPKt0lRs/QHthx/inO0C3sIobWn+R1WZttVyEUbjv4=;
        b=pbDoYb3k4LdDvni/cuvJYsuPnuOpxiKhxyBhCs2z5peIfGjb2bUwIfgZC3LgZ9prmp
         5v4A7nYbapemaTXk4N1L5z0FNnKhvEmHlL3G+WzWhSXKogBho9ol4drsmg6G402Qtl/+
         5aQPjOQt2XEy09ov2DLp8/5ykI/k2uHjIkBMH05R/FLgp5lq1oLRRqPL1wYZGSnrRWd+
         zqdXAXuEahNSOv2AX/f+lgilvvd95USMgAjiE1J6RQ/BF3PRnQnGIMARb9LW1AxOeyRa
         63f7nCnPS/qiXG+4xWG2oPyLuBFhEDwRkBQJeHc1jolXfxgdjDowDC72U0APAq4YMJ9H
         MPDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=EmPKt0lRs/QHthx/inO0C3sIobWn+R1WZttVyEUbjv4=;
        b=kpySau1yPIwdQRPRwdpoJSJVT1fJVkY+N+fPI/ZCdvw/VJj8uqAMNy4oa7diF7DxFB
         Vo/QbMo4EkTL2bnajJ+9Kt6/v+ot7ZW6gpvzoGRyT3TBKMtFwAUAh226ZgoWivJIMlio
         sWqEsjxZJkb3aW8SFl1NfDBB4b7TT9elyXca5Krm2d1obfxt6G/5ekxzpqLfqioEKoC+
         5OhnLKDRHYxTGpvDfwo1MuBO4dDd3pCmFh4CyYQG3eYoERJCwBkXHLfXQLY/PMkFBh6i
         g29uXyfVBK7OalFykTaku0CiXGvgzSE6Snqmk9qXIYzonM05jX7CiusNoWd87racqb4P
         PKwQ==
X-Gm-Message-State: ACrzQf2Ui48YUvXzKrVLrdrD3uwS4z2ZyBPcS64SAZbxFy0mgh48Soot
        AgCCfl/6dar1SNpK9oU61x9P2QJfdoiwOWPdlGtSqExp8aEVMg==
X-Google-Smtp-Source: AMsMyM50bLcOJmA7rgObdtIBJrytr0rdYsgxQ56eUJGhNpXQtBfj7gp+X7w7sJoTiTBbhoxSmUTHFbPlmBkPWL5Zg24=
X-Received: by 2002:a5b:443:0:b0:6bc:e3d1:8990 with SMTP id
 s3-20020a5b0443000000b006bce3d18990mr23179544ybp.191.1664901265770; Tue, 04
 Oct 2022 09:34:25 -0700 (PDT)
MIME-Version: 1.0
References: <20220929204708.2548375-1-dmatlack@google.com> <Yztw5p+Y5oyJElH2@google.com>
In-Reply-To: <Yztw5p+Y5oyJElH2@google.com>
From:   David Matlack <dmatlack@google.com>
Date:   Tue, 4 Oct 2022 09:33:58 -0700
Message-ID: <CALzav=foJLfym8uJ88gzaHDtAdn3ivFFr7mvQpm_4ePQVMGORg@mail.gmail.com>
Subject: Re: [PATCH 0/4] KVM: selftests: Fix and clean up emulator_error_test
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Colton Lewis <coltonlewis@google.com>,
        Peter Xu <peterx@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Aaron Lewis <aaronlewis@google.com>, kvm@vger.kernel.org
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

On Mon, Oct 3, 2022 at 4:31 PM Sean Christopherson <seanjc@google.com> wrote:
>
> On Thu, Sep 29, 2022, David Matlack wrote:
> > Miscellaneous fixes and cleanups to emulator_error_test. The reason I
> > started looking at this test is because it fails when TDP is disabled,
> > which pollutes my test results when I am testing a new series for
> > upstream.
>
> This series defeats the (not well documented) purpose of emulator_error_test.  The
> test exists specifically to verify that KVM emulates in response to EPT violations
> when "allow_smaller_maxphyaddr && guest.MAXPHYADDR < host.MAXPHADDR".

I thought that might have been the case before I sent this series, but
I could not (and still can't) find any evidence to support it. The
commit message and comment at the top of the test all indicate this is
a test for KVM_CAP_EXIT_ON_EMULATION_FAILURE. What did I miss?

Either way, I think we want both types of tests.  In v2 how about I split out:

 (1) exit_on_emulation_failure_test.c: Test that emulation failures
exit to userspace when the cap is enabled, i.e. what
emulator_error_test does by the end of this series.
 (2) smaller_maxphyaddr_emulation_test.c: Test the interaction of
allow_smaller_maxphyaddr and instruction emulation. i.e. what
emulator_error_does at the start of this series plus your suggestions.

The main benefit of splitting out (1) is to test
KVM_CAP_EXIT_ON_EMULATION_FAILURE independent of
allow_smaller_maxphyaddr, since allow_smaller_maxphyaddr is not
enabled by default.


>
> That said, the test could use some upgrades:
>
>   1. Verify that a well-emulated instruction takes #PF(RSVD)
>   2. Verify that FLDS takes #PF(RSVD) when EPT is disabled
