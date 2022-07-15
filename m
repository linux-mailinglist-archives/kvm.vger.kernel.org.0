Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 29572575BF2
	for <lists+kvm@lfdr.de>; Fri, 15 Jul 2022 09:02:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229462AbiGOG7v (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Jul 2022 02:59:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231180AbiGOG7r (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Jul 2022 02:59:47 -0400
Received: from mail-vs1-xe32.google.com (mail-vs1-xe32.google.com [IPv6:2607:f8b0:4864:20::e32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 706461A042
        for <kvm@vger.kernel.org>; Thu, 14 Jul 2022 23:59:45 -0700 (PDT)
Received: by mail-vs1-xe32.google.com with SMTP id t127so3495596vsb.8
        for <kvm@vger.kernel.org>; Thu, 14 Jul 2022 23:59:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9v+qQ9/0tophHLrpQx//eLF1ttOOmYgqB9pEWD7iCw8=;
        b=F/CzcXUe47hIrpdFe66HlTftbGIk3QG1VLgQR0e/kqDeRjJZqyht9j/9IvttzcDOKc
         8SdPSN0Kd4DBRuyWwKxmq9PquMUBkjATg9mBiLQRchfOlNI/WkOOsA7wZ1Ba4LYS5eCS
         6Cd4holvVZXLFRIkLG83JbXSbd46nvhDcpcsDhFj3WNfErI/6BCkbytd9pje7gmudF3D
         aPE9yGHNWT+YZzJcKN+sscbCJOZoGDvO7S2QxUpF6lE5TwfmcSBT0vxBTv+8Imz5sK/d
         PlslhVNu0DtIVJVfx898W5RRIH66GjzNG0ftjH5zJ5sL5CkdfoY0TQGBe0aVGmuGVaGz
         wH0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9v+qQ9/0tophHLrpQx//eLF1ttOOmYgqB9pEWD7iCw8=;
        b=sx4XmKCqdXlxQBvHHb/J0ogOXA15Xc0vTRlUCypaWNxctjLWZxPBypZy2Atq0Zifnm
         z6R0Ab31/F/pxD7RUEJxubSvWj3msGNs0pMXNEOBPt4yBaTHzHBhB3DkHpOezgGzJFU6
         q5hCc+x2NcduwjBi+zb9IiLGC0iPfOwusjQePkz2AMKSRdfFvXnismhXeU6nrN6d9e5y
         A0JJ5i25peIHhxVGtQWT6QxJnX71MA3Uk34oOS5/CgVrZpZyHWO4z1ZspgeCoOXyd9ML
         YLFyg7DZ0W+YTMCRt0JosuxiHWvpXzHDHpuDB0DYMscw4sDk0xh+JqCosaXygrf2wy7v
         f4wQ==
X-Gm-Message-State: AJIora+RWZ1iRcpgsPhzt/V+GZNTlFK6hDhdJyBvFM/9P8S8Ae1cwxBU
        AwBSM0BQSuQWbqLDk838sUngXW6S+7t7Lll7PJvp4w==
X-Google-Smtp-Source: AGRyM1sr0ShmlCy9/t1KZMf7KxdwU27MRr25tDvj76kxV+HvQRAvDwCn4B8rEbmPyJX67PTEmVUXT/b7MtCYpd4he1o=
X-Received: by 2002:a67:5c41:0:b0:356:20ab:2f29 with SMTP id
 q62-20020a675c41000000b0035620ab2f29mr5284432vsb.63.1657868384547; Thu, 14
 Jul 2022 23:59:44 -0700 (PDT)
MIME-Version: 1.0
References: <20220714152024.1673368-1-maz@kernel.org> <20220714152024.1673368-5-maz@kernel.org>
In-Reply-To: <20220714152024.1673368-5-maz@kernel.org>
From:   Reiji Watanabe <reijiw@google.com>
Date:   Thu, 14 Jul 2022 23:59:28 -0700
Message-ID: <CAAeT=Fxqc7PN6K+T8P7LwZQSWMFivpyosPDaRnJtGQMJcHi8wg@mail.gmail.com>
Subject: Re: [PATCH v2 04/20] KVM: arm64: Rely on index_to_param() for size
 checks on userspace access
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Schspa Shi <schspa@gmail.com>, kernel-team@android.com
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

On Thu, Jul 14, 2022 at 8:20 AM Marc Zyngier <maz@kernel.org> wrote:
>
> index_to_param() already checks that we use 64bit accesses for all
> registers accessed from userspace.
>
> However, we have extra checks in other places, which is pretty
> confusing. Get rid on these checks.
>
> Signed-off-by: Marc Zyngier <maz@kernel.org>

Reviewed-by: Reiji Watanabe <reijiw@google.com>
