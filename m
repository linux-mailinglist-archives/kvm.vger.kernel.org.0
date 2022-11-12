Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 845EB6267ED
	for <lists+kvm@lfdr.de>; Sat, 12 Nov 2022 09:01:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234769AbiKLIBv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 12 Nov 2022 03:01:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230170AbiKLIBs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 12 Nov 2022 03:01:48 -0500
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 251A013DE2
        for <kvm@vger.kernel.org>; Sat, 12 Nov 2022 00:01:48 -0800 (PST)
Received: by mail-pg1-x530.google.com with SMTP id o13so6105172pgu.7
        for <kvm@vger.kernel.org>; Sat, 12 Nov 2022 00:01:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=j7VZmjwtxmbTDgJG6yNy/NKZz0sCcAw91UAS7XNqqYU=;
        b=bpxwH/fsUWb40bD9Q3Zy01qs7U9eWAv1qNXbpwt51L21rpaRtLIEo8HIrWFdyzP4yL
         /zfNHocVpNHojMyhwgBgHy2szKnLMNF+RPhb9+6X7Mmz1XkrbHeq26Xl+crefpHvPBTj
         VZUOK8XbJ9QmuEWAjz94L45bEGdyvvlB3TEcSpfgnZsYH2lZ+QDrbdn1Y98qdDvq4WQr
         EtbFfoSn9+SDw60SOPYvBtOeI7s2U8ZGPeC2io7bRxTQyUQ6sC57jNdMZlg71ZfjNhQX
         2N5YW0rhU+GzqFbSMwjsYC6AnR7719veX3hI6FTd+js+hw7ZsrZf4vYAG1+uJd18gLmN
         BNRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=j7VZmjwtxmbTDgJG6yNy/NKZz0sCcAw91UAS7XNqqYU=;
        b=Pms8H0vMhF/PvELmC6j73mTdNdQW77SJNaQUEOWtMVbbNJeyGRcaLojxMX2wWmywPc
         31HXpzv/6IigEJAkou4CUTddI9a6A2iU6Bym2zHEmMtFBMMgCu8H19CWbE8OkvwExJhh
         b+8PJdiU0rJXBwMQpOl2JdWujeAqJzd1qMDY3C/sjelXm2tvgRuvU286dYOVgqGucjbs
         7r7qZKsPF4xaL2v+xSfk/RE1cK6ScuORR8hFhSLsmaDoeHlJQWJ3qqhxVKMzPpIFAlzG
         /qFiEtEvos9MVvUnX849wonbRocvfgAx0jtUg81LvfHNKjLNeF+gB9eQGfcnsJGKIYWt
         gIyw==
X-Gm-Message-State: ANoB5pkH5pIr3vJGdyQNSvcdgAU8hjIsw7Z35ZRKWxhFY9tP693BT6IJ
        /j7/l5dN222JsO8Gx6lan14k+0UJ8dZZ/KbbaQEPjw==
X-Google-Smtp-Source: AA0mqf74mZ/Q5PIpOqoIn8jOkWvbTBKBd4IOdrQQX67B9+okXa8HRPAozoxqlNHz6mFBRo8PFEWGE7yhXHYJs+AwBLU=
X-Received: by 2002:a63:4a21:0:b0:46f:d9f:476 with SMTP id x33-20020a634a21000000b0046f0d9f0476mr4521743pga.468.1668240107535;
 Sat, 12 Nov 2022 00:01:47 -0800 (PST)
MIME-Version: 1.0
References: <20221028105402.2030192-1-maz@kernel.org> <20221028105402.2030192-4-maz@kernel.org>
In-Reply-To: <20221028105402.2030192-4-maz@kernel.org>
From:   Reiji Watanabe <reijiw@google.com>
Date:   Sat, 12 Nov 2022 00:01:31 -0800
Message-ID: <CAAeT=Fxs3ScU8oDtevsuG+7QH7Dyh8Gm0h+m+ibCmaFQ3LfL6w@mail.gmail.com>
Subject: Re: [PATCH v2 03/14] KVM: arm64: PMU: Always advertise the CHAIN event
To:     Marc Zyngier <maz@kernel.org>
Cc:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvmarm@lists.linux.dev, kvm@vger.kernel.org,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Ricardo Koller <ricarkol@google.com>
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

On Fri, Oct 28, 2022 at 3:54 AM Marc Zyngier <maz@kernel.org> wrote:
>
> Even when the underlying HW doesn't offer the CHAIN event
> (which happens with QEMU), we can always support it as we're
> in control of the counter overflow.
>
> Always advertise the event via PMCEID0_EL0.
>
> Signed-off-by: Marc Zyngier <maz@kernel.org>

Reviewed-by: Reiji Watanabe <reijiw@google.com>
