Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2BFC62D3A7
	for <lists+kvm@lfdr.de>; Thu, 17 Nov 2022 07:55:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233750AbiKQGzS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Nov 2022 01:55:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbiKQGzO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Nov 2022 01:55:14 -0500
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 390FB5B58B
        for <kvm@vger.kernel.org>; Wed, 16 Nov 2022 22:55:14 -0800 (PST)
Received: by mail-pj1-x102b.google.com with SMTP id h14so840737pjv.4
        for <kvm@vger.kernel.org>; Wed, 16 Nov 2022 22:55:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=ufxDvLSDDXikRLOuIVMfp9fSGQBpXIXeB0N0kqgYhWg=;
        b=lphVdcKLOqU6XMwwXsfp8UJjZ4YvVzwfNjrrS86/KM1DX9fQBnL9coNdVkwnhcnLkG
         I5uOhio65rpvnLXU+BRJHDcfpgVCrFguCCt2lVJM1g6Wb8NAtiLNMkSk3nEmNv1rPTy2
         MU+rAcLgLmhgtAZZfgHxJr1KR2TrUcfcED5pQXGemidQyCw+xq5x6eeBVi+WaTCpGObx
         77wtjfJGwJyVA4j1IeVYatXkLQDzd8PcsSn5YQgKKufdMpjZAkXWU0BsQ9MfckX8xK13
         LaObeh6PpoONhM/H4C8YXVGlaiA0ZeRy4WFH7ecWAQJpJNExtwg+0gBNT9SJAp+JJh13
         Ewkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ufxDvLSDDXikRLOuIVMfp9fSGQBpXIXeB0N0kqgYhWg=;
        b=Bw1mWPSEolryvFP3EzScM1D3Uu5zpnGZUALu6AQBN6B3YzHJPjfes6+IskUhiyAzzJ
         Tjyt3qXCVw9VkWbQYNCoNUhTGFcw01CvEyvIJ7ljpQ1vQ/gVJbYgKWnCzNofzyRcwfqC
         i6tN1QLSSud5wZ+GZ58dt3+8bmwMVA3lEDF6k/+pzU6vhfxSBtCHDWrq5bkPQOKui3dA
         T5gVoPBK+f+6Qml9u9Q0X1ub5t5SzAYEZCU3Fv513mS6rbaaRGgv+5ud/VtTpTqI9ib9
         eC3WHA+TODsVNMqz9lgr6RkfLKmbPeLGQKepS6wnacAwPe+GPehtHD4q1NN5zosE8TxE
         4N/w==
X-Gm-Message-State: ANoB5plYegWbYt2P4Uvk17Wl0/5lFNxc41TP+HK+HnYNlfClkZOCPGf+
        zWTohOeo+Kwq7RnokdyP9iDF9XZv1lAJazmYzf/RyQ==
X-Google-Smtp-Source: AA0mqf7tSFrAZEMwmVmmUbqLCEc3pBNl7lqKOL+eWOL+gkt0uZHRyU+pxKg569MjVOU21bkykdSb6tDYkG3Bmcz6qvc=
X-Received: by 2002:a17:90a:bd11:b0:206:64cd:4797 with SMTP id
 y17-20020a17090abd1100b0020664cd4797mr1454425pjr.103.1668668113644; Wed, 16
 Nov 2022 22:55:13 -0800 (PST)
MIME-Version: 1.0
References: <20221113163832.3154370-1-maz@kernel.org> <20221113163832.3154370-7-maz@kernel.org>
In-Reply-To: <20221113163832.3154370-7-maz@kernel.org>
From:   Reiji Watanabe <reijiw@google.com>
Date:   Wed, 16 Nov 2022 22:54:57 -0800
Message-ID: <CAAeT=FzPpotx-g1e_cqZx79DOgxuJEgKo4zudC_0b_Qd3Cz5FQ@mail.gmail.com>
Subject: Re: [PATCH v4 06/16] KVM: arm64: PMU: Only narrow counters that are
 not 64bit wide
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

On Sun, Nov 13, 2022 at 8:38 AM Marc Zyngier <maz@kernel.org> wrote:
>
> The current PMU emulation sometimes narrows counters to 32bit
> if the counter isn't the cycle counter. As this is going to
> change with PMUv3p5 where the counters are all 64bit, fix
> the couple of cases where this happens unconditionally.
>
> Signed-off-by: Marc Zyngier <maz@kernel.org>

Reviewed-by: Reiji Watanabe <reijiw@google.com>
