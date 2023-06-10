Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DEA8972A7EE
	for <lists+kvm@lfdr.de>; Sat, 10 Jun 2023 03:55:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232749AbjFJBzJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Jun 2023 21:55:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229818AbjFJBzI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Jun 2023 21:55:08 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82FD23A82;
        Fri,  9 Jun 2023 18:55:07 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id 98e67ed59e1d1-259ac20bdeaso1178368a91.1;
        Fri, 09 Jun 2023 18:55:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686362107; x=1688954107;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=h2wh/UrjanufpJz44BmiMwc9ysr757JWcCqw7JQZgaA=;
        b=feVNO1Thyo2sUhxcMcbaZOhg0FlmNNPyGVkgwtblF28mHhFoHHCjr8gGjA/vU8Xvv4
         DcLYRUKWOKJTS+LVzAZPdH/qkKygpbN6voS62JZQ0lNXcCupH6qPGyEf68bqQ3OPvyX0
         +0HJkywZQYsQIg9aJILMwKVaNDO6KGetTIEBXLNLoAcw+GQrpt4cOmAqfnKXAGgrid5m
         XYieoBUlGIqFPrRfTBAg5iHQCA4RotZRM+wn7tMI86F65NweMJN2iDNKqOD0AfAWcD2G
         FQ1qr34wgdH9PXCdP8dzUJc2fA1HB1tRq9QuY5AGcQkUWJ+cA72S5BXYrcCzu0mJtQ0z
         8PQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686362107; x=1688954107;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=h2wh/UrjanufpJz44BmiMwc9ysr757JWcCqw7JQZgaA=;
        b=Juw2nmQeww3VougyFkeZ+NpBJfJJ/q14gBXc76+Bkc9PkcmYGzWndWRHRW8DCAVOq6
         4PBFeBh0FXMU6Jscx/HamaHBrv5KZsuEMGuZWDHbMC5OsacCconFkV5inG+8DQ6+078I
         5yEhUb0ln7gw8vmSZf/AOB1XQZIk6TnbV9n+mYp/hCOuskuFSGk+3L5ed1D1iDf2xvlK
         615Uth5Zz86MNddpPabJkGMSBzDN6S8dVsuqhQ95uQMVYUV2rNk1NtxN741TJwLXav3o
         1x35K5RJ/TYYrrnKoDv77Jwv52K6yM+6omdQZxS/OYko4I4LDghU/44vsOQoIzQv72I2
         Sacg==
X-Gm-Message-State: AC+VfDzl5RcQeNrhPyzmQgM57oUGDnjA2ByBbNNogbE2858gBVpORXBG
        lRLEPMQynQjaYTIrR5ttQpHk/RWjov0CXD2+wIk=
X-Google-Smtp-Source: ACHHUZ7nvJVCagpU3QzMwxk4tI9YszwKv8pY+vsiwjdSjju24Nj4wuqO0v1/j7LJipdEqRbsTj6BvD4GjEtOlvRsm4g=
X-Received: by 2002:a17:90b:3508:b0:23f:81c0:eadd with SMTP id
 ls8-20020a17090b350800b0023f81c0eaddmr2724100pjb.47.1686362106985; Fri, 09
 Jun 2023 18:55:06 -0700 (PDT)
MIME-Version: 1.0
References: <20230605064848.12319-1-jpn@linux.vnet.ibm.com>
 <20230605064848.12319-3-jpn@linux.vnet.ibm.com> <CT6996Z3V83E.21I51JGIDHPOE@wheely>
In-Reply-To: <CT6996Z3V83E.21I51JGIDHPOE@wheely>
From:   Jordan Niethe <jniethe5@gmail.com>
Date:   Sat, 10 Jun 2023 11:54:55 +1000
Message-ID: <CACzsE9oNLp7eSDiNhTB_hWn1TSu9Obr2rNPgTyK7_fYGXvu5Fw@mail.gmail.com>
Subject: Re: [RFC PATCH v2 2/6] KVM: PPC: Add fpr getters and setters
To:     Nicholas Piggin <npiggin@gmail.com>
Cc:     Jordan Niethe <jpn@linux.vnet.ibm.com>,
        linuxppc-dev@lists.ozlabs.org, mikey@neuling.org,
        kvm@vger.kernel.org, kvm-ppc@vger.kernel.org, sbhat@linux.ibm.com,
        vaibhav@linux.ibm.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jun 7, 2023 at 5:56=E2=80=AFPM Nicholas Piggin <npiggin@gmail.com> =
wrote:
[snip]
>
> Is there a particular reason some reg sets are broken into their own
> patches? Looking at this hunk you think the VR one got missed, but it's
> in its own patch.
>
> Not really a big deal but I wouldn't mind them all in one patch. Or at
> least the FP/VR/VSR ine one since they're quite regular and similar.

There's not really a reason,

Originally I had things even more broken apart but then thought one
patch made
more sense. Part way through squashing the patches I had a change of
heart
and thought I'd see if people had a preference.

I'll just finish the squashing for the next series.

Thanks,
Jordan
>
> Thanks,
> Nick
>
