Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 622B37ABC0E
	for <lists+kvm@lfdr.de>; Sat, 23 Sep 2023 01:00:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230203AbjIVXAc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Sep 2023 19:00:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230142AbjIVXAb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Sep 2023 19:00:31 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A15D019A
        for <kvm@vger.kernel.org>; Fri, 22 Sep 2023 16:00:25 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-59e8ebc0376so44093457b3.2
        for <kvm@vger.kernel.org>; Fri, 22 Sep 2023 16:00:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1695423625; x=1696028425; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=GE2XXcB9Z66Z/+jmtr3Nreygo5a18psEdddNC3jXP6Y=;
        b=xPMxAbEcBMGfshrovAJk3fnjGGGtpnCdd29BDX1YBo/dUj4xgQIanjgWB0cPILaQMU
         thTAhP3UWk2L+ndkbkxXXzwy1By4H6QaqDw19xK5ze6UgEk2uu5lZ9udl2Q0iD4DTY1x
         jV8bYHIUR3gkFelVhRtv7dZFsj3be8bf++/kozwTKFNWvKaLtehlCUkshOhnkzHnxKDx
         Kym6S+o+DFEwH5nGZ9xehdXT2+anAzjXJgm46qTtKm9ITCLUdzuE0nsmsXWarRQzq2Bd
         oIPMaNjfqt2D2tgl9ilRG1R0T5ttBSSOg5Hbbu+VG6yV9FSK9m8HOPybKumXYIWkQNly
         IoVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695423625; x=1696028425;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=GE2XXcB9Z66Z/+jmtr3Nreygo5a18psEdddNC3jXP6Y=;
        b=GBMAgJfMk7WPkwJzN7islLSn1vVYdabxWrWFvMDiIB2MRze1orfhdox20tpcDicrTk
         hxQ1cu/XIcekoHgsTir7vB+ja1td/ENy/eHM4SD6KcMrknd2Bcgd/Eb7PW0h7scSKLoC
         Kfv4fHt4eicPxFqaU2EOSvBwJ0iBcEAH+8JKeUZGz21a8KFgRvi2L9okcy2nJaIKt4hH
         AGrM4SUY+YnbpuR4KsBQ0tbJKt6AVOwJKvl+MP3i08GKzzeaCAahX90fGwl77ZJWnmCu
         Mtr8njqosWNFms4DETL62aW3Pds0+zLNIeqNsWc7X3k1yRfm0lzLxADunhfPP8dOXXUu
         pv1Q==
X-Gm-Message-State: AOJu0Yy0d+EpHJP1/A2Jo6+kjilM1CVOwTJpX2tMVSLe1Ar3bpqs9cgq
        V837lyDfomAKJmYqnwFDz0xNfczd6hY=
X-Google-Smtp-Source: AGHT+IG2ZVlmsIIglpXuyb4CgEnWQeWJGH+b3kmXiZVTDWBfzw2cJO69TjNv1VyjQiXXkd3aiJHhtKFhM4U=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:b285:0:b0:59b:d33b:5de0 with SMTP id
 q127-20020a81b285000000b0059bd33b5de0mr15233ywh.1.1695423624871; Fri, 22 Sep
 2023 16:00:24 -0700 (PDT)
Date:   Fri, 22 Sep 2023 16:00:23 -0700
In-Reply-To: <CAL715WLuqxN5JvcrZ7vcFpmTwuAi_EqKERtvj9BLoT9QVM0Ekw@mail.gmail.com>
Mime-Version: 1.0
References: <20230901185646.2823254-1-jmattson@google.com> <ZQ3hD+zBCkZxZclS@google.com>
 <CALMp9eRQKUy7+AXWepsuJ=KguVMTTcgimeEjd3zMnEP-3LEDKg@mail.gmail.com>
 <ZQ3pQfu6Zw3MMvKx@google.com> <CAL715WKguAT_K_eUTxk8XEQ5rQ=e5WhEFdwOx8VpkpTHJWgRFw@mail.gmail.com>
 <ZQ36bxFOZM0s5+uk@google.com> <CAL715WL8KN1fceDhKxCfeGjbctx=vz2pAbw607pFYP6bw9N0_w@mail.gmail.com>
 <ZQ4BvCsFjLmnSxhd@google.com> <CAL715WLuqxN5JvcrZ7vcFpmTwuAi_EqKERtvj9BLoT9QVM0Ekw@mail.gmail.com>
Message-ID: <ZQ4ch3GqM7WH34qv@google.com>
Subject: Re: [PATCH 1/2] KVM: x86: Synthesize at most one PMI per VM-exit
From:   Sean Christopherson <seanjc@google.com>
To:     Mingwei Zhang <mizhang@google.com>
Cc:     Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Like Xu <likexu@tencent.com>, Roman Kagan <rkagan@amazon.de>,
        Kan Liang <kan.liang@intel.com>,
        Dapeng1 Mi <dapeng1.mi@intel.com>
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Sep 22, 2023, Mingwei Zhang wrote:
> So yes, they could be put together and they could be put separately.
> But I don't see why they _cannot_ be together or cause confusion.

Because they don't need to be put together.  Roman's patch kinda sorta overlaps
with the prev_counter mess, but Jim's fixes are entirely orthogonal.

If one person initially posted such a series with everything together I probably
wouldn't care *too* much, but combining patches and/or series that aren't tightly
coupled or dependent in some way usually does more harm than good.  E.g. if a
maintainer has complaints against only one or two patches in series of unrelated
patches, then grabbing the "good" patches is unnecessarily difficult.  It's not
truly hard on the maintainer's end, but little bits of avoidable friction in the
process adds up across hundreds and thousands of patches.

FWIW, my plan is to apply Roman's patch pretty much as-is, grab v2 from Jim, and
post my cleanups as a separate series on top (maybe two series, really haven't
thought about it yet).  The only reason I have them all in a single branch is
because there are code conflicts and I know I will apply the patches from Roman
and Jim first, i.e. I didn't want to develop on a base that I knew would become
stale.

> So, I would like to put them together in the same context with a cover letter
> fully describing the details.

I certainly won't object to a thorough bug report/analysis, but I'd prefer that
Jim's series be posted separately (though I don't care if it's you or Jim that
posts it).
