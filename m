Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8AB7D588C10
	for <lists+kvm@lfdr.de>; Wed,  3 Aug 2022 14:28:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237911AbiHCM2y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Aug 2022 08:28:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236240AbiHCM2x (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Aug 2022 08:28:53 -0400
Received: from mail-ot1-x330.google.com (mail-ot1-x330.google.com [IPv6:2607:f8b0:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCB5365D4
        for <kvm@vger.kernel.org>; Wed,  3 Aug 2022 05:28:52 -0700 (PDT)
Received: by mail-ot1-x330.google.com with SMTP id o16-20020a9d4110000000b0061cac66bd6dso12087428ote.11
        for <kvm@vger.kernel.org>; Wed, 03 Aug 2022 05:28:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=oAHe3Q0jeZIrmnFQEKyTDlh1oPefH12Bi1PTZ+op7+g=;
        b=QZCAmExTtZDbwUr4VHUz8GlqN+/+IQMs3G0ipKXmjHU/Z8oQqw7LLAweT/Yq3iyge6
         L314C0mF77xDdQuy03BCZD+pEFk7xB7bEtjQ0O+rsktn6HKnUZSEVeNgjKwdTK6IyRES
         aH0BuAbARRXWPrt4ZX3DjprpR9BUKxlud8dImXPl3rsv4MrJcqGv0C6qBqSKkM3rPQ/Y
         Rsf/Ds7AZU5rVqfsNmOLPVx0IePCu2bKqvaQyMCDzwLI9fpIZvU4YybmNY81wcthL47v
         DforSAUcgiAWtYeBXmlgrOni1a/5nXDZ1h/mZsZ8hu9yrVa+PLSxuUheJtLHSB1CDFRQ
         NFDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=oAHe3Q0jeZIrmnFQEKyTDlh1oPefH12Bi1PTZ+op7+g=;
        b=v0Uvif5j0rFPnKevFVhbUhFI3dd9k+GGJZRzCiXNaHD5uvJ6ARO6gfli00g+0BwLUi
         OBCk2rkzF2iuX6c86Bri1+QEHhzJSKVMTpgctEb53/eU8mv7TS7x5hRMe0rG4nJBm5t8
         p1rBStFxxZTXn/v0p7q9Pn3r4m829hPaDOyfkspDo96eC2u8uEkFI5P4lXv2gO0Udm7v
         ayLAFr3A/g0DBVuUP5yprt/HDqnSIKE14NU4CRU4Hms/vhUHDi4/L+QaM4NBfvFTNeX2
         lBS2tuIFgm3pmeqqTrG/HUUs2RvJNBhiXARAgaXhAAfluaMJyS+GQL9gkJRp9e3+xauh
         xX3A==
X-Gm-Message-State: AJIora9Be/6xvVSqNDW4uIJiikFL5+tuJyCMlErVd1ttIkFHcWGdTW/H
        97gZ6HlNOA18ACJPvm0CZlK/Qz0i7U9W3sn/vI2Msw==
X-Google-Smtp-Source: AGRyM1so57hSVzdxywS5qK89kciiG6m08X+sOIZBykbN2k6+y7tuJtR0gaAAK3P4UpV/knFTl51yHazNsSaNpaV2ZaM=
X-Received: by 2002:a9d:38e:0:b0:61c:7323:6202 with SMTP id
 f14-20020a9d038e000000b0061c73236202mr8748251otf.267.1659529732050; Wed, 03
 Aug 2022 05:28:52 -0700 (PDT)
MIME-Version: 1.0
References: <20220709011726.1006267-1-aaronlewis@google.com>
 <20220709011726.1006267-2-aaronlewis@google.com> <CALMp9eRxCyneOJqh+o=dibs7xCtUYr_ot6yju8Tm+pMo478gQw@mail.gmail.com>
In-Reply-To: <CALMp9eRxCyneOJqh+o=dibs7xCtUYr_ot6yju8Tm+pMo478gQw@mail.gmail.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Wed, 3 Aug 2022 05:28:40 -0700
Message-ID: <CALMp9eS+pj_z8cyVGmMneMccvyAM1ZqrTCfnK-p4HUbaOyCJ=A@mail.gmail.com>
Subject: Re: [PATCH v3 1/5] kvm: x86/pmu: Introduce masked events to the pmu
 event filter
To:     Aaron Lewis <aaronlewis@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, seanjc@google.com
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

On Tue, Aug 2, 2022 at 5:19 PM Jim Mattson <jmattson@google.com> wrote:
>
> On Fri, Jul 8, 2022 at 6:17 PM Aaron Lewis <aaronlewis@google.com> wrote:
> >
> > +#define KVM_PMU_EVENT_ENCODE_MASKED_EVENT(select, mask, match, invert) \
> > +               (((select) & 0xfful) | (((select) & 0xf00ul) << 24) | \
> > +               (((mask) & 0xfful) << 24) | \
> > +               (((match) & 0xfful) << 8) | \
> > +               (((invert) & 0x1ul) << 23))
>
> Please convert the masks and shifts to GENMASK_ULL().

Sorry. Ignore this suggestion. It makes no sense.
