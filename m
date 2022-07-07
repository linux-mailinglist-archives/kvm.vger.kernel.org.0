Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F106569915
	for <lists+kvm@lfdr.de>; Thu,  7 Jul 2022 06:24:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234748AbiGGEYi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Jul 2022 00:24:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231676AbiGGEYg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Jul 2022 00:24:36 -0400
Received: from mail-vs1-xe31.google.com (mail-vs1-xe31.google.com [IPv6:2607:f8b0:4864:20::e31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C526B2FFE1
        for <kvm@vger.kernel.org>; Wed,  6 Jul 2022 21:24:35 -0700 (PDT)
Received: by mail-vs1-xe31.google.com with SMTP id j1so17063544vsj.12
        for <kvm@vger.kernel.org>; Wed, 06 Jul 2022 21:24:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=P5zAW3N5J57Ljdte2To+3ZiUYAaiHtJmcrsOoDQ8EzE=;
        b=Pa2ATAe+73A0Q+/FoTio8/f1LsRzXiZenNRY9StpKZGLP7J4+tSHUfcxioqp3BHqZQ
         YJC2lx0bPthD8VVq16HO5F01zGxsDxPUFVHzSsOefuyRMI3VUARdrXzlTgrC0a7Uo5Rb
         gpdowRjUjtVZgTUZWTgLuxQWoocZ+ehST5cxJz/lQsD1ZSMkRm6aPi+Veyru+724PHcZ
         IOJOueuPuFYGCkKPbaGGxPmEMNUKkZuhLJRpexpLzRIVCKTxLBuzqqYRtL9QOIeeEQHv
         qcUQGj84e/FxKezNH6UcCqDaqq1xbuuoY6hVz7tfYmIRDGGRW2ta2pTVHxgu9yajmtGD
         iP3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=P5zAW3N5J57Ljdte2To+3ZiUYAaiHtJmcrsOoDQ8EzE=;
        b=cKrAbN/M3bI6lYB3xXboXhmT8u2eHOCBUwFEkq92+0QoASGQfImLQHej5VVtic7BaB
         Q6p8Svs916mcWtWXovWcpSJU8bM9ig94o/z2ySOCok4KsahbLyf7iWR+9hz9U5bkO77r
         Zq9DhoHyXKUxyTLPNFXNDi4Q7+l7ybnPf7BY47UfiGPrM4Y1mgo3g4ezYuomsrymaBHE
         1vOS20zIYG5PXH/rES5AFZPKneAuUUpdyb7/QyMokOaL6uJvJOQeczavjzRuXRGhTSUS
         A+aZOwckZlq05gHTQuQ/udgcXYSnkGVTMk9D5b/z7aZUa8XDppZ8jahgSVNM8tHkyzKx
         eOcQ==
X-Gm-Message-State: AJIora+HxBgqqrFJnIPcLs01MqeCQmpr4FH1+3uyGR7rWDiMwyDA+Lwi
        vSv8zCtSygld1gru62DfJmMwK911xK3egRrCsCCsFw==
X-Google-Smtp-Source: AGRyM1u+6cJnnmplQZFZti4im80gj+0WDEfv/JlcAJPgVrQyz5iGHDZGkTpKJG9Bc9yqtFJP346GgkIbfbWLptG2UbI=
X-Received: by 2002:a05:6102:cc6:b0:356:3c5c:beb5 with SMTP id
 g6-20020a0561020cc600b003563c5cbeb5mr24856988vst.80.1657167874863; Wed, 06
 Jul 2022 21:24:34 -0700 (PDT)
MIME-Version: 1.0
References: <20220706164304.1582687-1-maz@kernel.org> <20220706164304.1582687-3-maz@kernel.org>
In-Reply-To: <20220706164304.1582687-3-maz@kernel.org>
From:   Reiji Watanabe <reijiw@google.com>
Date:   Wed, 6 Jul 2022 21:24:19 -0700
Message-ID: <CAAeT=Fw5XZ9BX-0Gv61L7Aw44PPhUoZJ5gkzKJhsky+FC=ODbg@mail.gmail.com>
Subject: Re: [PATCH 02/19] KVM: arm64: Reorder handling of invariant sysregs
 from userspace
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
> In order to allow some further refactor of the sysreg helpers,
> move the handling of invariant sysreg to occur before we handle
> all the other ones.
>
> Signed-off-by: Marc Zyngier <maz@kernel.org>

Reviewed-by: Reiji Watanabe <reijiw@google.com>

Thanks,
Reiji
