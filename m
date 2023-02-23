Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 97E206A12D2
	for <lists+kvm@lfdr.de>; Thu, 23 Feb 2023 23:29:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229589AbjBWW3d (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Feb 2023 17:29:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbjBWW3c (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Feb 2023 17:29:32 -0500
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72BFB17CD1
        for <kvm@vger.kernel.org>; Thu, 23 Feb 2023 14:29:31 -0800 (PST)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-53700262a47so109333717b3.4
        for <kvm@vger.kernel.org>; Thu, 23 Feb 2023 14:29:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=b9eEgAqxwwT4oBExX9UxWqccj7ZXr1sZAWCiBgAFhOg=;
        b=jFLVngoi/Pj7Xk/eCMq8tP4XJF8j3XFIqui52VpZPJAx8/hzuaONFGRRlzWa63/fl2
         SI0zjjKiFIWT+aprJz02CYJUfUx98g+UHDfC3TX6FeRrVNpx+gWh0hoj6KpylXckrr1y
         mhgYsE7Ml2cAyM19Koccmums5UiRkyLacJtP7LIYLhSdhQ+SP8DzK4ojMk1tNUDxqrej
         lHtSqE9qBy/5aWUEMn6SWBHVDHtxWYr/kS48QW/qokIF0v57KN64O2gMahbQRqZS0Do2
         aLFvN2ReyBaxCQnkp5QjUOftRkEe38BLAKCyX0OEee59d7wYuuO4dmogDSO5Opz9qfIE
         FBoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=b9eEgAqxwwT4oBExX9UxWqccj7ZXr1sZAWCiBgAFhOg=;
        b=j0HmWG+MU7ZCKC/DnSp5kn6na6lx7Oh/x0ESXDiavOIC+O1Ue2a1hKNlvGmvHg+TdX
         hcVe12LJU1rStM/kaSQjvHHPTErTMxfh/mp8uPpITJJezh3GlRcYPFhWx7DY7sMcmyMb
         OeBPrt4Ro9y8dLAl7gWiLfUJSv2s1/u7qx8gGkvxaNzA6FqX9irx8WWJBdUcUnv26XMM
         x2j9B2wQw0b6veQvZJgTPNC9r+oP7sYsBbi+x357zJgA87ZfVN/BWtshIFj2eGXoBJWb
         ywgGzq3oojOuaf5s+pqpkiOH/Tuy6Yk711o3ikwe95SX6es3ca0+e9gB3v3YXgWpKZij
         C/bQ==
X-Gm-Message-State: AO0yUKVvkiWD0F7s4XNsU90jESiirVE9A1zIj2qvjOuBAR67Nw4lo1n8
        UVg47l85aEpEhoPtmJg2eIPsVBUNFRag015GaA==
X-Google-Smtp-Source: AK7set9GbtJblkfY1G9F3ZARNAI1ilgRjyI3NMnBus6IJ5uQtMRl+4SsjQVspoqe81g0EBTPNyvyx8p3Qeo9QafF2g==
X-Received: from coltonlewis-kvm.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:14ce])
 (user=coltonlewis job=sendgmr) by 2002:a05:6902:1183:b0:a27:3ecc:ffe7 with
 SMTP id m3-20020a056902118300b00a273eccffe7mr2945020ybu.3.1677191370715; Thu,
 23 Feb 2023 14:29:30 -0800 (PST)
Date:   Thu, 23 Feb 2023 22:29:29 +0000
In-Reply-To: <20230216142123.2638675-1-maz@kernel.org> (message from Marc
 Zyngier on Thu, 16 Feb 2023 14:21:07 +0000)
Mime-Version: 1.0
Message-ID: <gsnt4jrc9fsm.fsf@coltonlewis-kvm.c.googlers.com>
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
