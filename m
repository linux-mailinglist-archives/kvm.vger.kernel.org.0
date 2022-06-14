Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE50A54A7C2
	for <lists+kvm@lfdr.de>; Tue, 14 Jun 2022 06:15:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235386AbiFNEPz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Jun 2022 00:15:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230137AbiFNEPw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Jun 2022 00:15:52 -0400
Received: from mail-oo1-xc2e.google.com (mail-oo1-xc2e.google.com [IPv6:2607:f8b0:4864:20::c2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2213A275EF
        for <kvm@vger.kernel.org>; Mon, 13 Jun 2022 21:15:51 -0700 (PDT)
Received: by mail-oo1-xc2e.google.com with SMTP id v5-20020a4ae045000000b0041b770b8a13so1551336oos.5
        for <kvm@vger.kernel.org>; Mon, 13 Jun 2022 21:15:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=c+Rp2RVEpu3MX7WeOUfPLY5BNmqBN8ySZmPahKyFmPk=;
        b=rwEWc6oeXP3pUzO9Q3sZp88gjVV6FWStAUQOC1b+N2itM3EgGqAcjQo4kdP9KcrnCp
         pqDV8WqpC6AApOglkZ9Sicp9anig7WyqXStHC6b2TFcw9GPvh3xS/MWlGwytIBDBiD8N
         8ZAIWeEXPPsT8yhbGlA8464ObjRwV/87RgaBtpynhwNZBLz/wpXJ3aVhI2w2wFtIaoCH
         BE55bc6IL4bUjBBiXT6kFZUdExMCHLUh7VsuOMTAjy+Gw28mk1WhwuN/11us7AYFtoaC
         y/4Y8sC90rlObTFXvlZjCa1yQwWKaUEl2DHhzkXBcS2X5mOUNtvLa1C9K7LSoam8idi7
         zaNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=c+Rp2RVEpu3MX7WeOUfPLY5BNmqBN8ySZmPahKyFmPk=;
        b=Hz7BMjT1BdnboUlsz5c0Cp7egq5Hq41a9Px0h4A137Kzf4YUd8MWiX5jQ8PADl9xlh
         0fArM6KdgFaE+117U9SNoOLMHWak6vzlR3Wl+YCkiVEvGcZ2yHK4hg5gCwZ9e+jfBz55
         pJ4hesMNfJ973ZTzGdAfnZGhY8KWosN8R2l7KBPjhqorMG548OdxOuZyjRu+uo1w7fVt
         OUiqHKfBnRI+pBUQfIz6dpWTppifL3K0yPu4j2eom5B8u6bPIz1+Qq6OX9dwRG96qJt7
         +jheixfNF8qHrG5Ygp9UyUKFe4PRyPs0fib5cJUPeoT/gq6iJ+5Tkykl5nIiQxAxzSr4
         eyGA==
X-Gm-Message-State: AOAM530fcuJD8P7weDXsGLH036l7QZlX8Q2/UpRyHZP2d+CDFi7JAjT8
        79ylWTBsVTI0jLryUD/AJeGNaMdbK4Q2in2Dl3wjGQ==
X-Google-Smtp-Source: ABdhPJypOZtefVLb22hKytzMlPi7WjxrWiezVIH5Yerm2RclFvxbaIinEfvYVAnXqJH/Nlpbh1vodkgn4diJAhYSnjE=
X-Received: by 2002:a4a:8c48:0:b0:41b:43c3:fa54 with SMTP id
 v8-20020a4a8c48000000b0041b43c3fa54mr1271721ooj.78.1655180149501; Mon, 13 Jun
 2022 21:15:49 -0700 (PDT)
MIME-Version: 1.0
References: <20220610092838.1205755-1-maz@kernel.org> <20220610092838.1205755-20-maz@kernel.org>
In-Reply-To: <20220610092838.1205755-20-maz@kernel.org>
From:   Reiji Watanabe <reijiw@google.com>
Date:   Mon, 13 Jun 2022 21:15:33 -0700
Message-ID: <CAAeT=FwuUsZSgV-tTBEf-V1vjjhvmFHSDzSMyVjWDQd+jdHf7A@mail.gmail.com>
Subject: Re: [PATCH v2 19/19] KVM: arm64: Move the handling of !FP outside of
 the fast path
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Oliver Upton <oupton@google.com>,
        Will Deacon <will@kernel.org>, Fuad Tabba <tabba@google.com>,
        Quentin Perret <qperret@google.com>,
        Mark Brown <broonie@kernel.org>, kernel-team@android.com
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

On Fri, Jun 10, 2022 at 2:35 AM Marc Zyngier <maz@kernel.org> wrote:
>
> We currently start by assuming that the host owns the FP unit
> at load time, then check again whether this is the case as
> we are about to run. Only at this point do we account for the
> fact that there is a (vanishingly small) chance that we're running
> on a system without a FPSIMD unit (yes, this is madness).
>
> We can actually move this FPSIMD check as early as load-time,
> and drop the check at run time.
>
> No intended change in behaviour.
>
> Suggested-by: Reiji Watanabe <reijiw@google.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>

For patches 9~19 in the series,
Reviewed-by: Reiji Watanabe <reijiw@google.com>

Thanks,
Reiji
