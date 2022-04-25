Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7563250E642
	for <lists+kvm@lfdr.de>; Mon, 25 Apr 2022 18:54:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243652AbiDYQ4j (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Apr 2022 12:56:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232388AbiDYQ4i (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 Apr 2022 12:56:38 -0400
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A478E34672
        for <kvm@vger.kernel.org>; Mon, 25 Apr 2022 09:53:33 -0700 (PDT)
Received: by mail-lf1-x136.google.com with SMTP id x33so27289261lfu.1
        for <kvm@vger.kernel.org>; Mon, 25 Apr 2022 09:53:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=lFX89zd3C09/F/da+MWhhY/H7yp7bOfk0UUh8vYzbDA=;
        b=h3X062wr4reZNOSNqsPwBEA4pU1JtqQic1Pt+nu09PtSC3yZTlVycPw8uy6r2U/cF3
         RRUFxFfVe7Jw0whY9XTZ+PNcOBDgNu0LT/Dd/Fkr59rQHxDXX28IurmgMb9NK5E6bM2r
         4uodDhWSaI1ssO5e4Bv8EeF/h9u4Z7cy/cvXq8UyrSmpRQYo46OQxVynhXXIltvGjeCS
         Y2m78X7EQh24TvV73BrOpLWttDP1CB2UAVxi9/B65zAJqNNgV42vaKgYZrFwG3XlXvnM
         TbQSoyIOlip1PQAiSbwvhS3y/EigIi49W6S131QZWG4gKw3x0EPShexhX9hnOb3fJ2q8
         UxAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=lFX89zd3C09/F/da+MWhhY/H7yp7bOfk0UUh8vYzbDA=;
        b=v2r3j/4Z80vsDOelk4BURVTYy6j0nLZm0aJ9WGisDYcfRaiR64DqnIl/wInvHVpQ2G
         IUlJoWQQC/otMrQKvrr0cs6i/cNFcYauzHbflztHU9NBCE4O+5lukYjwuCX5+ipnkclN
         iwKKMYKI/Mr6dYO01sIh4l5SisMUOaXac+4z/nsFMxWyeo8QO3uDJJqVMgZipyDTBvj0
         fc3ObQm3J5QADFLNgbkDhGMPSUa3ha93SuzU1G+FTzKgtLJRpIKuzbIytT0vF2CpJwUK
         mN8bQKbz3uNOJTEWcfvpjV34pJ6Zl4Wm/xo5MYNXlf74LTMKJyZQaj9wMr8oVWRtPR1M
         eOIA==
X-Gm-Message-State: AOAM532Cf/nfpFiwpVvleiSogqmdOhNuf2F5ndwml75i8fOA/ioeuCOy
        gp2pju2tXdiDC/LaSKEIHyNvvanF2Iowv7qPNx1BMQ==
X-Google-Smtp-Source: ABdhPJxm0hhBPf1OejlR39+65w6wi69xjDsU+RXUC7QhOXAMerhUh52wj0ODeBwvmUu+3x+HKLKmoPD+gqYXCSdbxjU=
X-Received: by 2002:a05:6512:131b:b0:44b:75d:e3d0 with SMTP id
 x27-20020a056512131b00b0044b075de3d0mr13469528lfu.685.1650905611670; Mon, 25
 Apr 2022 09:53:31 -0700 (PDT)
MIME-Version: 1.0
References: <20220415215901.1737897-1-oupton@google.com> <20220415215901.1737897-7-oupton@google.com>
 <Yma6fEoRstvmu6sd@google.com>
In-Reply-To: <Yma6fEoRstvmu6sd@google.com>
From:   Oliver Upton <oupton@google.com>
Date:   Mon, 25 Apr 2022 09:53:20 -0700
Message-ID: <CAOQ_QshYttK+e9PQdp+vZo2w7NN8oGVAQm8LC+DBP5gs+5fLwA@mail.gmail.com>
Subject: Re: [RFC PATCH 06/17] KVM: arm64: Implement break-before-make
 sequence for parallel walks
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-arm-kernel@lists.infradead.org,
        Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Ben Gardon <bgardon@google.com>,
        David Matlack <dmatlack@google.com>
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

On Mon, Apr 25, 2022 at 8:13 AM Sean Christopherson <seanjc@google.com> wrote:
>
> On Fri, Apr 15, 2022, Oliver Upton wrote:
> > The ARM architecture requires that software use the 'break-before-make'
> > sequence whenever memory is being remapped.
>
> What does "remapped" mean here?  Changing the pfn?  Promoting/demoting to/from a
> huge page?

Both, but in the case of this series it is mostly concerned with
promotion/demotion. I'll make this language a bit more precise next
time around.

--
Thanks,
Oliver
