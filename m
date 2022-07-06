Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF1A3568EBB
	for <lists+kvm@lfdr.de>; Wed,  6 Jul 2022 18:12:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234324AbiGFQLw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Jul 2022 12:11:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234360AbiGFQLo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Jul 2022 12:11:44 -0400
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E22326573
        for <kvm@vger.kernel.org>; Wed,  6 Jul 2022 09:11:43 -0700 (PDT)
Received: by mail-wm1-x334.google.com with SMTP id l68so9109974wml.3
        for <kvm@vger.kernel.org>; Wed, 06 Jul 2022 09:11:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7PYGoC6Ce2Yz5AvB3HQu6vf0gE+Z0/gjn+ExJ8BDmUU=;
        b=FDFENRevnxTU+Y+NC7lK0wD++VywqyOp/hA3hQSbETzL2hvKK8jJ1J4MqBwEsFOXwX
         r8kQYF7KAuPlmlja7/Cide6mjp2msyPaTcuhBN1wrRhuWSCzDtcIL9mgQjZcX1oXvdOh
         bYV5u8MUITIKPwM6Vbky7o5jd1yz4O2kQw6NANIVkPEu0ms1+ojzCsUrDr6esTpS7i1I
         NWIc4NdYMYv3SkBp1xG4XYA19v/AEiyRm+Ug7E8RePQqB5b0gxyNkHS/9gF9cwBg24bu
         H//+dOX3XgWiLHm7PTHjCVzv5KiWpu0EJfQliTRNuQ3hcNVR/dQ9wwByoUcaFVgKQpw+
         LbyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7PYGoC6Ce2Yz5AvB3HQu6vf0gE+Z0/gjn+ExJ8BDmUU=;
        b=Y/2HDTG/wiJ8qghXp8yKpjApsEy3QnAB1G6kGrUtyBDCvr+3X71f0qDria2zZhh+tq
         WQ2RP9J5UQtM8gAGUcq5meYd8wpQrJSjY5t1sSdQWf4bl3rWrfaUbwTqhMq8WIDzDARC
         UQEqBu/6NlKP4A5XtDlovNOH/pkI4ElRmFsmy3aSpcMQqW7gR/dhtQEZy4/T5W5chNyb
         SIVbCEnygv1kUGdS2TNbX85Z+nPNvqEYKMvo8qsmOyZh88i0yhtmxpOlmVceUoSm/tKd
         mbKOQ0pBsuZPthsNiXc9W/pXB7C6sz/weW//sDHUqx0hkzyjJtVlVVRyWQT/kKshlLgc
         sIAQ==
X-Gm-Message-State: AJIora//rqPVFLG3HkzwF88/e1jtlz9bFbTHxaSkp4PA9R6RqySy/VfE
        iMWyvdyKMBdVxfDYC8gi2iAQoE9A7L4sm/37sn1Yqvp5Y4/WZA==
X-Google-Smtp-Source: AGRyM1s6stslSBqd9fWaTtu4pys/UHd7qwWBNiBcSehe8ZxsDfN0UFTa6SQPQA4kUDtOMNCn2+nsMQ58miGNxaayfRo=
X-Received: by 2002:a05:600c:35cf:b0:3a0:49c1:f991 with SMTP id
 r15-20020a05600c35cf00b003a049c1f991mr43000627wmq.95.1657123901677; Wed, 06
 Jul 2022 09:11:41 -0700 (PDT)
MIME-Version: 1.0
References: <20220606175248.1884041-1-aaronlewis@google.com>
 <20220606175248.1884041-2-aaronlewis@google.com> <CALMp9eT3U+kLJTJJ_QP66LQPTQywVTuxucx=7JU74Xb7=xeY0g@mail.gmail.com>
In-Reply-To: <CALMp9eT3U+kLJTJJ_QP66LQPTQywVTuxucx=7JU74Xb7=xeY0g@mail.gmail.com>
From:   Aaron Lewis <aaronlewis@google.com>
Date:   Wed, 6 Jul 2022 16:11:29 +0000
Message-ID: <CAAAPnDHFMdxpsP6TJywQWoMtOudYpc4Z3+pNq7OJA6223L0mcg@mail.gmail.com>
Subject: Re: [PATCH v2 1/4] kvm: x86/pmu: Introduce masked events to the pmu
 event filter
To:     Jim Mattson <jmattson@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, seanjc@google.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> > +In this mode each event in the events field will be encoded with mask, match,
> > +and invert values in addition to an eventsel.  These encoded events will be
> > +matched against the event the guest is attempting to program to determine
> > +whether the guest should have access to it.  When matching an encoded event
> > +with a guest event these steps are followed:
> > + 1. Match the encoded eventsel to the guest eventsel.
> > + 2. If that matches, match the mask and match values from the encoded event to
> > +    the guest's unit mask (ie: unit_mask & mask == match).
> > + 3. If that matches, the guest is allow to program the event if its an allow
> > +    list or the guest is not allow to program the event if its a deny list.
> > + 4. If the invert value is set in the encoded event, reverse the meaning of #3
> > +    (ie: deny if its an allow list, allow if it's a deny list).
>
> The invert flag introduces some ambiguity. What if a particular event
> matches two of the masked filter entries: one with an invert flag and
> one without?
>

That's a good point!  I think I can deal with that by validating the
events when they are being set to ensure that for a particular event
the invert flags are all set the same way and return EINVAL if they're
not.
