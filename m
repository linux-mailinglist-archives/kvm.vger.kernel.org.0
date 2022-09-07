Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 514EC5AF90C
	for <lists+kvm@lfdr.de>; Wed,  7 Sep 2022 02:43:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229490AbiIGAnc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Sep 2022 20:43:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229588AbiIGAna (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Sep 2022 20:43:30 -0400
Received: from mail-ot1-x336.google.com (mail-ot1-x336.google.com [IPv6:2607:f8b0:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B194286C3F
        for <kvm@vger.kernel.org>; Tue,  6 Sep 2022 17:43:29 -0700 (PDT)
Received: by mail-ot1-x336.google.com with SMTP id 92-20020a9d0be5000000b0063946111607so9216035oth.10
        for <kvm@vger.kernel.org>; Tue, 06 Sep 2022 17:43:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date;
        bh=bkq6Yhj8AYRhTgRoRiQUsLLqj+xz/9dCULHkpvzYz5o=;
        b=Xihr1MgPb7HCYjxAFY7qexj3zLtYIeqjEwSWMzGXG7GTD8jHSL7lQrjG8ieitDGVQZ
         708ZLc0SLDQq8W96cIMoDqqSgdfNQ+cPvjUaosCJxpJmyLu6MPmhvaisss+jOFoCfTn/
         6Wd3swwlJh7bMErZCxOCNx+ePbv3UseCO4EhkK1UurKlvaj0Pcp/seFFfSf7hWuktjxH
         xzzqU5mmUvRqW/ProzYgh8KGPaEuxWdicclSrTROVQcOgotJpxUcbpBj0VDaQS5GkHp7
         Abn2Cpm4vlpwaNi76v7lIiNAJ9tX/HD9LphXrqWG2uhnRPexuH/+L8gTZuGgdeoUKiJS
         ZOcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date;
        bh=bkq6Yhj8AYRhTgRoRiQUsLLqj+xz/9dCULHkpvzYz5o=;
        b=r/9UytsqE0ADBhGdqVTUbdhj4i8bjCeH0chDCd7SqMc/hUjHehtUWjEFM9SkVaZOIq
         NzkdrViAHT9NW4QjMxZFsU1r7kLb6ygvozy8unXrLquQuCqkueBXWML5i6lYMx8bXnWA
         YIscdvCwk2IC/kMwAkmIknV+SH3eW+e2RaWFiNnlEGDpJ+JHyUm/bBrFwbrnBNvZ/CW0
         EKTH+05aaw2j+0oFLmcawIAzS0eoKyEYPAaSKCXRbtfv+rtpdif/PhJohaZAt6Egxn65
         jvGHGtiBKeHkSrVYZPBgSPf00EB0UclgERtEawTUkPlqU/2KYUb2pUzY6EOJm7o97lsX
         i5vw==
X-Gm-Message-State: ACgBeo24nxXb+WNU8M/99Zx0DPSf40pZZVbZWggClVDCyIWu6R4uf5Iq
        i3rg0ZfoiDsoq5RsUy8Z1mL73OGyVK88MWr/77oHqw==
X-Google-Smtp-Source: AA6agR4yJrJIEhi6GNF/eqfkctkeJB97Rh4Crw3qEzBXs06FNzj/opp+AE9Mue9YF1dx0zW9BfuHsHATr8P7BBMzCcs=
X-Received: by 2002:a9d:4d99:0:b0:639:1fe0:37c1 with SMTP id
 u25-20020a9d4d99000000b006391fe037c1mr463489otk.267.1662511408875; Tue, 06
 Sep 2022 17:43:28 -0700 (PDT)
MIME-Version: 1.0
References: <CALMp9eT685aGv-kn8Yb4Xq7u=33kE27U1GHJ=0pqaKn2AcO7og@mail.gmail.com>
 <Yxflw2NAghJM1rhE@gao-cwp>
In-Reply-To: <Yxflw2NAghJM1rhE@gao-cwp>
From:   Jim Mattson <jmattson@google.com>
Date:   Tue, 6 Sep 2022 17:43:17 -0700
Message-ID: <CALMp9eSy28fXSaMmRxmog=w+-DFZiMh1f1WHGykrLnK45hCMvg@mail.gmail.com>
Subject: Re: Intel's "virtualize IA32_SPEC_CTRL" VM-execution control
To:     Chao Gao <chao.gao@intel.com>
Cc:     chen.zhang@intel.com, kvm list <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
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

On Tue, Sep 6, 2022 at 5:29 PM Chao Gao <chao.gao@intel.com> wrote:
>
> On Tue, Sep 06, 2022 at 04:41:26PM -0700, Jim Mattson wrote:
> >This looks like a souped-up version of AMD's X86_FEATURE_V_SPEC_CTRL.
> >From https://www.intel.com/content/www/us/en/developer/articles/technica=
l/software-security-guidance/technical-documentation/branch-history-injecti=
on.html:
> >
> >When =E2=80=9Cvirtualize IA32_SPEC_CTRL=E2=80=9D VM-execution control is=
 enabled, the
> >processor supports virtualizing MSR writes and reads to
> >IA32_SPEC_CTRL. This VM-execution control is enabled when the tertiary
> >processor-based VM-execution control bit 7 is set and the tertiary
> >controls are enabled. The support for this VM-execution control is
> >enumerated by bit 7 of the IA32_VMX_PROCBASED_CTLS3 MSR (0x492).
> >
> >Is anyone working on kvm support for this yet? (Intel?)
>
> Chen is working on it. He has some patches already and is working on the
> testing and review with security experts. The plan is to post patches in
> ww40 or ww41. Do you have any questions/concerns about enabling
> "virtualize IA32_SPEC_CTRL" in KVM?

Not at all. I was just wondering if we needed to implement it.
