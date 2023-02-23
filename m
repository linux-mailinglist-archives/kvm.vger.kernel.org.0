Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD8716A12D5
	for <lists+kvm@lfdr.de>; Thu, 23 Feb 2023 23:30:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229595AbjBWWan (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Feb 2023 17:30:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229477AbjBWWam (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Feb 2023 17:30:42 -0500
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89D192D179
        for <kvm@vger.kernel.org>; Thu, 23 Feb 2023 14:30:41 -0800 (PST)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-536bf649e70so149183407b3.0
        for <kvm@vger.kernel.org>; Thu, 23 Feb 2023 14:30:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=fptV0kqNvUTLM+Vzkruu3VOPADLoyUMzrHlmpF8NC5Y=;
        b=maCgn2uajGx+6agxEiDTq6eZoAw6bagko+iAJa+/boF6RdEsxlMmBwhrVnoqXaOQmp
         EnhcPHkQmb0ZxoJL+ghXdUH5yb3Ja7Uj8e2J19tszSr4+p3eTHyadsFYJbxjl9+iR8yL
         Hc3sRTDlDFmOtBI7B94ZUFKgxXuxJgGMWxpf4yrljxonTETxsO021dXIk6AiXNWjo/Bj
         dN9myl3pHmV2G8f2y+5x47WFST0hKbHKSk97Jy/w6y/TXGn3iYyQslbhbS4nd9at2jtI
         XjU3TXQ5ZvsHWOFMfflK9jV5M6te6Musf0cKUgShd4JcPbNlsrSU5KJHKEYMiosWPn/2
         A4MA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fptV0kqNvUTLM+Vzkruu3VOPADLoyUMzrHlmpF8NC5Y=;
        b=phO/qAMulkreU/pcOguxQTupTORZYAzMT27C5gZmSSqexbUBM1+olFHiTSQS4Mr1XE
         po5bkPlfmGMixqGFxCKvg+pGP5A8FwqO1N9YrjgNuAWK4c5w6wFLAWPCJzqqoJguho1w
         /PiR2FFWzh9/3G5Flhm6KgPAU39M9ZYxjYXATJqTiHYtIXtIUbr0wXQDSvANu7Na09C8
         tj8W6LPow6mCA5C2j5EX4xBaIpkxtElysk3W75oHKioaApGaqzC3hnHbyXBVn2NyoxWh
         iKl9vQvECyn9R3ao5W1wBW2Qz6XElEBqCJNjAqfsH5AQY44VaqeLwtGwOlPjNqXg4JhW
         rmeA==
X-Gm-Message-State: AO0yUKUEdIP+5q0DFDSnCuEYqAv783t3Czz4OxOdxk0EpzpF021vAndm
        DaGf0rjnMHu4kHm36eDmKDN6emGxHysDpiQE7A==
X-Google-Smtp-Source: AK7set9v7/P5rXgxUGhlG0bDl+uWJExu1xLg2msftTQtmKOpPjrQX1hAV6SXOMWxoYyDKOXZq+s/5wYdbxjcwENLKw==
X-Received: from coltonlewis-kvm.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:14ce])
 (user=coltonlewis job=sendgmr) by 2002:a25:9087:0:b0:8ea:3d09:b125 with SMTP
 id t7-20020a259087000000b008ea3d09b125mr2762939ybl.0.1677191440822; Thu, 23
 Feb 2023 14:30:40 -0800 (PST)
Date:   Thu, 23 Feb 2023 22:30:40 +0000
In-Reply-To: <20230216142123.2638675-5-maz@kernel.org> (message from Marc
 Zyngier on Thu, 16 Feb 2023 14:21:11 +0000)
Mime-Version: 1.0
Message-ID: <gsnt1qmg9fqn.fsf@coltonlewis-kvm.c.googlers.com>
Subject: Re: [PATCH 04/16] KVM: arm64: timers: Use a per-vcpu, per-timer
 accumulator for fractional ns
From:   Colton Lewis <coltonlewis@google.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvmarm@lists.linux.dev, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, james.morse@arm.com,
        suzuki.poulose@arm.com, oliver.upton@linux.dev,
        yuzenghui@huawei.com, ricarkol@google.com, sveith@amazon.de,
        dwmw2@infradead.org
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Marc Zyngier <maz@kernel.org> writes:

> Instead of accumulating the fractionnal ns value generated everytime
                               ^                              ^
nit: fractional
nit: every time
