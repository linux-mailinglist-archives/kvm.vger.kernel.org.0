Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8FCE57117B
	for <lists+kvm@lfdr.de>; Tue, 12 Jul 2022 06:34:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231247AbiGLEe5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Jul 2022 00:34:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbiGLEe4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Jul 2022 00:34:56 -0400
Received: from mail-vs1-xe36.google.com (mail-vs1-xe36.google.com [IPv6:2607:f8b0:4864:20::e36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD0885FAE0
        for <kvm@vger.kernel.org>; Mon, 11 Jul 2022 21:34:54 -0700 (PDT)
Received: by mail-vs1-xe36.google.com with SMTP id j65so6766458vsc.3
        for <kvm@vger.kernel.org>; Mon, 11 Jul 2022 21:34:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2G5DDdHN65V5QCqoc0hJXGvC6ZBJU+ZGuB0i5a889f4=;
        b=gKNWeGGUaQbxlF/L3rMRsDc2PhkbPzfLIFYAaRskfX4H9ypCvtdaYj7/rKQhk/y48h
         I9lsunvlZ8+Lsu86JBzxKJe5GniCyQfdac1lq2hTuBzxAoTfRHSK175NJBKZgkCrvwyy
         /fqzEh4zeK8tI+doDU04fUKl72XtLDsWx5ynhU4LGDzbrFRmTg08uJpftEIy0LvmD7kI
         Mt65vAQGOiFmtOSbRMChgtjfNLKh3JwhWghlaiHIDe7oLuWsAWGMd7F6JfLWV5nPMZ7I
         0HV4q6xtkcGn760H6Yzh1D8/YeEliuC+WIcHceUIlzzqF+Qizo3ER3AZJgR61gErc0Dm
         HmLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2G5DDdHN65V5QCqoc0hJXGvC6ZBJU+ZGuB0i5a889f4=;
        b=IORGP4cWAnb2DJoS2+kMLxkuJHTdFg7FTryPcvwn7Vt+9nfJ9bQPIXDJM1pIPdE569
         Y94hSJwCsFULoejqO5/aLEbz86713g73fK4XcheFcSxjkTmgr5UeTSUhP73s7pKIo5Tq
         xDWdUGWNKkHNfeK23J2IFpBj2iUtZNr4Ib3cuTQp/3KcY9ACf0yscm6SBlCAwPRZhVRk
         oTO1eFGDzhtqvxTUTwZE1RnO+IozLQDEwmtUHOqPAxxpsPSZx99M0kBFSnhBb1mfOuiX
         dAgWwksdrEWkxPEkmRkD8batItBFbU5sMSjXa//TGuz3I6PHlI/sPdjpsvOsjOfQmytl
         NGMA==
X-Gm-Message-State: AJIora/6a/YyBKcubZyxGvD+MfoCfhUy9FwiDQxJAz+1c0XPLy7dLuT6
        mODZQRTM7we41XlNAA000YluzzqDpVB88DZRT2yxKQ==
X-Google-Smtp-Source: AGRyM1vFWfnJO1N1oFZN8adTtTYjnWcRgKILoGUSyraLENahV/H1J4Vhbb0NTk1cOJ+a1timJoWqAJKzx/qEXEuDLsY=
X-Received: by 2002:a05:6102:2126:b0:357:6663:a469 with SMTP id
 f6-20020a056102212600b003576663a469mr2533719vsg.58.1657600493938; Mon, 11 Jul
 2022 21:34:53 -0700 (PDT)
MIME-Version: 1.0
References: <20220706164304.1582687-1-maz@kernel.org> <20220706164304.1582687-7-maz@kernel.org>
In-Reply-To: <20220706164304.1582687-7-maz@kernel.org>
From:   Reiji Watanabe <reijiw@google.com>
Date:   Mon, 11 Jul 2022 21:34:38 -0700
Message-ID: <CAAeT=FyqHFciAqBtD4K1-HFW4nefBovRyLX6uv=31sGsGk5ufQ@mail.gmail.com>
Subject: Re: [PATCH 06/19] KVM: arm64: Get rid of reg_from/to_user()
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Schspa Shi <schspa@gmail.com>, kernel-team@android.com,
        Oliver Upton <oliver.upton@linux.dev>
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

On Wed, Jul 6, 2022 at 9:43 AM Marc Zyngier <maz@kernel.org> wrote:
>
> These helpers are only used by the invariant stuff now, and while
> they pretend to support non-64bit registers, this only serves as
> a way to scare the casual reviewer...
>
> Replace these helpers with our good friends get/put_user(), and
> don't look back.
>
> Signed-off-by: Marc Zyngier <maz@kernel.org>

Reviewed-by: Reiji Watanabe <reijiw@google.com>
