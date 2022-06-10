Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EDB0B545C21
	for <lists+kvm@lfdr.de>; Fri, 10 Jun 2022 08:13:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244158AbiFJGNm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Jun 2022 02:13:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244150AbiFJGNj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Jun 2022 02:13:39 -0400
Received: from mail-oi1-x22a.google.com (mail-oi1-x22a.google.com [IPv6:2607:f8b0:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6742122AE51
        for <kvm@vger.kernel.org>; Thu,  9 Jun 2022 23:13:38 -0700 (PDT)
Received: by mail-oi1-x22a.google.com with SMTP id w16so24629853oie.5
        for <kvm@vger.kernel.org>; Thu, 09 Jun 2022 23:13:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=gpIjTUIy/sYUCUxAj7KpvSMIco0OqPienYjZRuLvs/M=;
        b=VAfU23ocUGTYC2vy6DVxgSaoiUC2MRx7bj2MyyD6z+lrcKLSm719EmdaWBW7dwDBjF
         5mXbB0fh8uPL4ElnsiDw9xOWC7VIQVSmO0IH7CWA7XJb2Te5NrGiNDvqu87pyJBsDCQI
         +CD0jwICLt8uwtntWgx5e/SXA2AvuqNzMHiz3wvYU3AjFpXUGzrdZDAOTpYHFXsnINHR
         qn2hL9eQfopRDxHYzzRzaNUdxChfJMb5ZmdByP+PMOlRsXHM+PQmdsRVDqR/YgHipTI6
         9+u/0+xd3C8k0gpB7b6qEfuEdcMc423hszvyJmk5S8l4dRzDlpC0ctZR7wd4/u8holCl
         wevg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gpIjTUIy/sYUCUxAj7KpvSMIco0OqPienYjZRuLvs/M=;
        b=Pllw1N2l5hoLr6zMlI6r0p3K/fMNs87jRqTwAE3W82h2GJdMkOGAoBxvretUzDSl62
         WqP3Ke5K07yAKQybeoi9Sb7Dwl9S9eK/uXqMrPj4t2w+1slgWTQqTjv5/rxjGweefNBo
         amFYHen1dc5hPYRBdR0BI32MuG2ukuUR8MzZNMqQASOlyNPiQRBcT4Z86zHrENNxH5TV
         cGXsYvjo8HbAeCI3HgdgUkS5I5+MgUh8fIUBRwBG7WLTNojPQHsj9yqYZVQJKLbv6r1z
         5gb7OjYHzVVxiTax7N2wZml6Hypx/ecXLN/FE5iL7xFeePNAQJe/3ep9LVQ5U5bQW6Bs
         3JZQ==
X-Gm-Message-State: AOAM531MS03aXaZdkQKYiUiusDG6BPOQ+qL0ppDzLS7n+ahX74+YRHKt
        4HHHGC1YHE7CSxcddD6bMZ4pzkuCeEx2UOZLo8vwmQ==
X-Google-Smtp-Source: ABdhPJxvHBDy+GsUTZeTF2opWbpTgXcsvwdl4BgLSzULzLgn7eCarwu0mJbV3IEMC7FZ98AK5iwyyqEDRasTsWl7QHI=
X-Received: by 2002:a05:6808:144d:b0:32b:7fbc:943d with SMTP id
 x13-20020a056808144d00b0032b7fbc943dmr3713078oiv.107.1654841617628; Thu, 09
 Jun 2022 23:13:37 -0700 (PDT)
MIME-Version: 1.0
References: <20220528113829.1043361-1-maz@kernel.org> <20220528113829.1043361-9-maz@kernel.org>
In-Reply-To: <20220528113829.1043361-9-maz@kernel.org>
From:   Reiji Watanabe <reijiw@google.com>
Date:   Thu, 9 Jun 2022 23:13:21 -0700
Message-ID: <CAAeT=FyfKbubGTFpssRq1KoAs=Fxu2jZjFSbYCm85X9Zk-ZWbA@mail.gmail.com>
Subject: Re: [PATCH 08/18] KVM: arm64: Move vcpu PC/Exception flags to the
 input flag set
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        kernel-team@android.com, Will Deacon <will@kernel.org>,
        Mark Brown <broonie@kernel.org>
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

On Sat, May 28, 2022 at 4:38 AM Marc Zyngier <maz@kernel.org> wrote:
>
> The PC update flags (which also deal with exception injection)
> is one of the most complicated use of the flag we have. Make it
> more fool prof by:
>
> - moving it over to the new accessors and assign it to the
>   input flag set
>
> - turn the combination of generic ELx flags with another flag
>   indicating the target EL itself into an explicit set of
>   flags for each EL and vector combination
>
> This is otherwise a pretty straightformward conversion.
>
> Signed-off-by: Marc Zyngier <maz@kernel.org>

Reviewed-by: Reiji Watanabe <reijiw@google.com>
