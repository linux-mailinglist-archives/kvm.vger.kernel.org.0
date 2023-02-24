Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 223C16A2309
	for <lists+kvm@lfdr.de>; Fri, 24 Feb 2023 21:07:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229778AbjBXUH4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Feb 2023 15:07:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229802AbjBXUHx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Feb 2023 15:07:53 -0500
Received: from mail-io1-xd4a.google.com (mail-io1-xd4a.google.com [IPv6:2607:f8b0:4864:20::d4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD267B47D
        for <kvm@vger.kernel.org>; Fri, 24 Feb 2023 12:07:31 -0800 (PST)
Received: by mail-io1-xd4a.google.com with SMTP id i3-20020a0566022c8300b0073a6a9f8f45so58489iow.11
        for <kvm@vger.kernel.org>; Fri, 24 Feb 2023 12:07:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=b9eEgAqxwwT4oBExX9UxWqccj7ZXr1sZAWCiBgAFhOg=;
        b=iqgI5WzFSxMSY27jQbX6h/A7/1NbpKWYqj67NeQey9WRvdfy8LcaF9g7Ztkco4ORBR
         f5DJCdkG2NVVQPUeBftttAXkjkT/5h39/fppVpX5BovT39UKAJi54mPw6sa9s8RCxfu3
         i4m6G3HBZh/9Fg8VrElnnk/q668v6koXeArvYu3PDRdW2FHIBjynX4W4bz7K7TVKvj1R
         RRIx9ccSLl5TknS4xxZrxMamMKcGI3wGDD9cOOANW8x7ExtWLgHirQVWHsX2if5S68pu
         V8qaBkcmfs3+pI/+RAQtAQ5a7tErrFuOfhodyg7L8E3Qs6UPQIgvV2euXEhkCEqBnAhh
         bBsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=b9eEgAqxwwT4oBExX9UxWqccj7ZXr1sZAWCiBgAFhOg=;
        b=jF+CMQoXleSWPQ7lA1s2wCQ0hseZt7+ltb/oy9gtFYecQMAmrnxBCT6uiojT8bDaIJ
         OTaot2XqrFHwJ0MqFLnCemEiK9wxBcf22Ax758QGnDoDELrt0qOTgcBsMOq+w76t3wlS
         62qo2hvxdLC4JTqa3Qi06eQroBF40f8omiCH+CFFAiE0dQ/vizq6rvEBS08zEEEXr8iD
         v5zZ3H+v1Xx9ChZef7VdgmMl2mEadEobM7XqBo3WhuJiPlaONMjt6H0BamUFD6rA5B/k
         Oo4G7Fs58f1qEE4SdoJ42/JNOAH7qllbEqxtTHOlA+I1MiNMpdsHK3Zhd5pCsodSoliH
         0w3g==
X-Gm-Message-State: AO0yUKXR/4ESwM23y2ftdNCwucwKqEtsjqafWsNbcALqKlmxNISgiVYX
        AOCqQ24Fnj6ABNX7qzsyP4P1LeASQuXXIvHK3g==
X-Google-Smtp-Source: AK7set/EAaM8y0wwRhjkt0dNHV7aQnp40+jiSD+YRka4vFYDirCN0RN1NCz2qoO9U8PIUH0WXao1xULkaWnv7uKVkA==
X-Received: from coltonlewis-kvm.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:14ce])
 (user=coltonlewis job=sendgmr) by 2002:a02:a186:0:b0:3a7:e46f:7d30 with SMTP
 id n6-20020a02a186000000b003a7e46f7d30mr6586704jah.3.1677269251262; Fri, 24
 Feb 2023 12:07:31 -0800 (PST)
Date:   Fri, 24 Feb 2023 20:07:30 +0000
In-Reply-To: <20230216142123.2638675-1-maz@kernel.org> (message from Marc
 Zyngier on Thu, 16 Feb 2023 14:21:07 +0000)
Mime-Version: 1.0
Message-ID: <gsntlekm969p.fsf@coltonlewis-kvm.c.googlers.com>
Subject: Re: [PATCH 00/16] KVM: arm64: Rework timer offsetting for fun and profit
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

Hello Marc,

This patch is of special interest to me as I was working on my own
ECV/CNTPOFF implementation, although mine was more narrow and doesn't
address any of your other goals. As far as I can tell at the moment,
your patch can cover the uses of mine, so I will dedicate
myself to reviewing and testing yours. Please include me on any future
rerolls of this patch.

Marc Zyngier <maz@kernel.org> writes:

> This series aims at satisfying multiple goals:

> - allow a VMM to atomically restore a timer offset for a whole VM
>    instead of updating the offset each time a vcpu get its counter
>    written

> - allow a VMM to save/restore the physical timer context, something
>    that we cannot do at the moment due to the lack of offsetting

> - provide a framework that is suitable for NV support, where we get
>    both global and per timer, per vcpu offsetting


If I am understanding your changes correctly, you introduce some VM-wide
timers with no hardware backing and a new API to access them from
userspace. This is useful both because it makes the code simpler (no
need to manually keep registers in sync), and so CNT{V,P}OFF can be
appropriately virtualized with NV. Is that a fair summary of the
important bits?

> This has been moderately tested with nVHE, VHE and NV. I do not have
> access to CNTPOFF-aware HW, so the jury is still out on that one. Note
> that the NV patches in this series are here to give a perspective on
> how this gets used.

> I've updated the arch_timer selftest to allow offsets to be provided
> from the command line, but the arch_test is pretty flimsy and tends to
> fail with an error==EINTR, even without this series. Something to
> investigate.

I can help you with testing because I have access to CNTPOFF-aware
hardware and emulators. Is there anything you are especially interested
to try out?
