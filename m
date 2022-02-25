Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 873994C425D
	for <lists+kvm@lfdr.de>; Fri, 25 Feb 2022 11:33:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239549AbiBYKdl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Feb 2022 05:33:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239556AbiBYKdj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Feb 2022 05:33:39 -0500
Received: from mail-yb1-xb2d.google.com (mail-yb1-xb2d.google.com [IPv6:2607:f8b0:4864:20::b2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B67E61AA055
        for <kvm@vger.kernel.org>; Fri, 25 Feb 2022 02:33:07 -0800 (PST)
Received: by mail-yb1-xb2d.google.com with SMTP id p19so4936362ybc.6
        for <kvm@vger.kernel.org>; Fri, 25 Feb 2022 02:33:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8herOfVKtBtPhTsBTysdihp5QCceqjnQTgQe9hlXIF8=;
        b=Bx15dkHIXlvji8f2rgMP/p9TW5zupzGIWtmINUHqd4ZqlJjoxTqzT0pl+5btL2oUvc
         JOEz8IPZCoFYrHxvtklZdS60zlxBe4WM4LLxaCew9sg8a3j9KZQz8FoJXCwHKEg0CAoe
         NycFPFRlBTMcuoM5N75F4hS4bU9rcNck5z0qhlLNwgCLO2tMrwzmDuOyVfoqU1+6AADu
         76uneU4Br4Gsn8rGaf53zfbnnz9hbaEKqT8ogYwX6D6e8AvKGRwNF+e2xnkqTetrV2Xs
         eTxoggyAD5AoIXZEcGGjLcHsSZT2uw0LJ4N02VCKgTi+1mFj0PLGHf4PWdrsxXmZ5UXh
         IhFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8herOfVKtBtPhTsBTysdihp5QCceqjnQTgQe9hlXIF8=;
        b=HrmdD/yvmJAWS2q5teVpoC2NlCVaCa0YHneeZvj1qYE2bQiSF907XNf/bXTBH/7XkR
         DaLEUV6/kknRRv75bgb7mnxiVfBA5QVcyfWnQ9y97HJa0eLOPSX9qnlOZ6+7xGuydo2W
         sBYtzqgqry2GWvMnRsspys4UtsCeylWRI6M4ooYaAqtOWws90YILVeQxmFS7fetMJPvy
         08lMfYYQAA2BwG6FWuxisoHGIh+rR+7BccOAYUSntqy7464RvW9OCR1RXVltCQbabHXh
         PqxN6s3nBi7iZdkc3RDWmzjH7Z73g0q0aVSRBR/v7HVz/E1hV3EIzC0u5ymLtfmbie6F
         k6KQ==
X-Gm-Message-State: AOAM532PSXcO1xUHaiw1bMQp2Pw/+hOj/hCfr7gOWLGtMXPNijLIWgen
        VAYcWlBDf5mAiXj8f5iHEsrwaf7uXlR1L7E5ozEjDVAFS+I=
X-Google-Smtp-Source: ABdhPJxC8vgHKHUq6qYQHBsblqKq2rhXwWTHs9pD7uuJrDSWvkZwlaWh04jhTHrCGhW5GYYF+h4mgAhZGGYEpRNsvhQ=
X-Received: by 2002:a25:8084:0:b0:5fe:cadd:2532 with SMTP id
 n4-20020a258084000000b005fecadd2532mr6538033ybk.193.1645785186907; Fri, 25
 Feb 2022 02:33:06 -0800 (PST)
MIME-Version: 1.0
References: <20220213035753.34577-1-akihiko.odaki@gmail.com>
 <CAFEAcA9eXpxC7R_qcDsBh4C9Aur5417kTzAhs4c7p2YRCFQUKQ@mail.gmail.com> <9223d640-3f50-1258-1bdb-e3ca5d635981@gmail.com>
In-Reply-To: <9223d640-3f50-1258-1bdb-e3ca5d635981@gmail.com>
From:   Peter Maydell <peter.maydell@linaro.org>
Date:   Fri, 25 Feb 2022 10:32:55 +0000
Message-ID: <CAFEAcA9D6T5kb03_THBVyUuCM7e88Xp-QzscQHyseSXj=SAGUQ@mail.gmail.com>
Subject: Re: [PATCH v2] target/arm: Support PSCI 1.1 and SMCCC 1.0
To:     Akihiko Odaki <akihiko.odaki@gmail.com>
Cc:     qemu-devel@nongnu.org, qemu-arm@nongnu.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Alexander Graf <agraf@csgraf.de>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 25 Feb 2022 at 03:36, Akihiko Odaki <akihiko.odaki@gmail.com> wrote:
>
> On 2022/02/24 21:53, Peter Maydell wrote:
> > On Sun, 13 Feb 2022 at 03:58, Akihiko Odaki <akihiko.odaki@gmail.com> wrote:
> >>
> >> Support the latest PSCI on TCG and HVF. A 64-bit function called from
> >> AArch32 now returns NOT_SUPPORTED, which is necessary to adhere to SMC
> >> Calling Convention 1.0. It is still not compliant with SMCCC 1.3 since
> >> they do not implement mandatory functions.
> >>
> >> Signed-off-by: Akihiko Odaki <akihiko.odaki@gmail.com>
> >> ---
> >
> > Applied, thanks.
> >
> > Please update the changelog at https://wiki.qemu.org/ChangeLog/7.0
> > for any user-visible changes.
> >
> > (I noticed while reviewing this that we report KVM's PSCI via
> > the DTB as only 0.2 even if KVM's actually implementing better
> > than that; I'll write a patch to clean that up.)

> I don't have an account on https://wiki.qemu.org/ so can you create one?
> I'll update the changelog once I get access to the account.

Oops, I accidentally used my canned-email-reply for "applied a
pull request" when I meant to use "applied a patch to target-arm.next".
You don't need to update the changelog -- I'll do that when I
next send a pull request for the arm tree and it gets merged.

Sorry for the confusion.

-- PMM
