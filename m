Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 107994C2E95
	for <lists+kvm@lfdr.de>; Thu, 24 Feb 2022 15:43:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235587AbiBXOmh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Feb 2022 09:42:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234594AbiBXOmg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Feb 2022 09:42:36 -0500
Received: from mail-yw1-x1136.google.com (mail-yw1-x1136.google.com [IPv6:2607:f8b0:4864:20::1136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 588763B285
        for <kvm@vger.kernel.org>; Thu, 24 Feb 2022 06:42:06 -0800 (PST)
Received: by mail-yw1-x1136.google.com with SMTP id 00721157ae682-2d6923bca1aso27271427b3.9
        for <kvm@vger.kernel.org>; Thu, 24 Feb 2022 06:42:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=sKeXaQKZcYhfHAETWvUqal4j+oBFrfcvS+Bi018smAk=;
        b=i8b3IEuY8xnQiotcb9r3BPS1DzgwwQq+MkfZUJ2zmc9sMqE2nrONKHQKOK97rONLMD
         qSUByr10cFvuEE5nG6tRQUnG3zy66iAh6czS2B+3ij1NfpakoGfQ7UtoIC54PO94RgTi
         Vl6HoPCDEd4qFVEc2D8RFfRFehEDGy+8iYg7nujWLPm/rvp+wikNCJxeXLyEdu1plEg7
         12S0XQeI3dTHm7ctppiRVdL93mrVGmP/D4VcdYzL3wehoyVLeagOyVCJ2e40cT5SJTo2
         2Igei6IdUT+nI9gCKPQ+xtVfr86W1R6rW8bqRvbOYWor6wIDojYRC4tmhSc6BF0+KZW3
         SJZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=sKeXaQKZcYhfHAETWvUqal4j+oBFrfcvS+Bi018smAk=;
        b=lwsu3p2ThE27AKCQGE4PFiGAwrg3tV9rL5qTXerGa11pUFdjanV6/X4li7Zk0gFgSW
         BHU0036nYVyHlEn2RJhgHxSzqLX8vFIvitJ5hVLM84G/xfcbVD81oDD0iqjCV4xxqlRk
         ULtk3SW3t2c6s0M4U6X8Be833cEMGA7CTpnIuuH2cIbSnvrN0g6LynXeXsHDfr23U52u
         SweVULLmoX132uinwUD9oOhEHekQzlzBI1zVxgFbxelqUaNTa/HKXHnfI4VoJcvTykoA
         wuRF0dttTN+mF1Vvv7YkHcMPLWBgMnvBOaXYWHRGRyhbet+s8Gy+/RHEMsjfhXggE43f
         JtkA==
X-Gm-Message-State: AOAM532Vo9V/TofoW518dNYDGFSoy1RiCE6cx+RA7g63Q1h2RAJZMyZr
        xPce0BGGyNp1ZbG3mGjZhTP4SnLXEfmihQsCJDdWGA==
X-Google-Smtp-Source: ABdhPJzqE71rIb+CyINGR57iuxvzTzdiC7SlSaK0MuwvHQtjStkcp+IZ9oiEEhIc6h+HbjPjN5iezWBZlCkxcOeYnoY=
X-Received: by 2002:a81:a748:0:b0:2d6:1f8b:23a9 with SMTP id
 e69-20020a81a748000000b002d61f8b23a9mr2678540ywh.329.1645713725623; Thu, 24
 Feb 2022 06:42:05 -0800 (PST)
MIME-Version: 1.0
References: <20220224143716.14576-1-akihiko.odaki@gmail.com>
In-Reply-To: <20220224143716.14576-1-akihiko.odaki@gmail.com>
From:   Peter Maydell <peter.maydell@linaro.org>
Date:   Thu, 24 Feb 2022 14:41:54 +0000
Message-ID: <CAFEAcA8JgMFhHGd91A=EzVNNgUZu-8YEKi_cdOnwnitrtH=3Dw@mail.gmail.com>
Subject: Re: [PATCH v2] target/arm: Support PSCI 1.1 and SMCCC 1.0
To:     Akihiko Odaki <akihiko.odaki@gmail.com>
Cc:     qemu-devel@nongnu.org, qemu-arm@nongnu.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Alexander Graf <agraf@csgraf.de>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 24 Feb 2022 at 14:37, Akihiko Odaki <akihiko.odaki@gmail.com> wrote:
>
> Support the latest PSCI on TCG and HVF. A 64-bit function called from
> AArch32 now returns NOT_SUPPORTED, which is necessary to adhere to SMC
> Calling Convention 1.0. It is still not compliant with SMCCC 1.3 since
> they do not implement mandatory functions.
>
> Signed-off-by: Akihiko Odaki <akihiko.odaki@gmail.com>

You didn't need to repost this; I've already queued it.

thanks
-- PMM
