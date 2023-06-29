Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C344741CC0
	for <lists+kvm@lfdr.de>; Thu, 29 Jun 2023 02:07:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232047AbjF2AHi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Jun 2023 20:07:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232049AbjF2AHf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Jun 2023 20:07:35 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 462EBA3
        for <kvm@vger.kernel.org>; Wed, 28 Jun 2023 17:07:34 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-bb2a7308f21so77062276.2
        for <kvm@vger.kernel.org>; Wed, 28 Jun 2023 17:07:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1687997253; x=1690589253;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=y7BDMelFHS828Gj3Jm/ECh2KqRe+91Z0DpptCQV7DWE=;
        b=kUqAqDda2Svnwq/zSU//baQEjxc3NMFXdEatX2cUPPN68abtt+InYbI76hoyyurxfw
         BXRlUUJQdlDMGiZVjJ5TPc0ISCuLUdJeTVzdykj0YHrSe2u4pnVN66GgMk8/tyn3kCaE
         6wzjAV1oScnEzGF8kOHArYjK0c8Q/sMV+c0YDQ5IXd2j6ADhUcg8DuAFqpLIgPCLIy7y
         LCPCV/EWaOKi6i2nVPzzIMqakvvpdnyzX4ggQISzW1Q97S1W60/o7qh7NeblcFuYqXgu
         eTsXuzOAqYVUfGbA3Vb7rlEvi9cYe5ADlshzaz7zWhcGg5q9oy3yuubXwrITlyK9ugYs
         tzCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687997253; x=1690589253;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=y7BDMelFHS828Gj3Jm/ECh2KqRe+91Z0DpptCQV7DWE=;
        b=NJHA9+qdN2ouXywvUl4g7Q8GBGTihnjXmiMjs3PGV/uadjJHORNgLVpzHXgbGGzxl2
         Gj98GHQO30bpmzkXPPcO2RyMTB4jxcyJ93WH2IIjK9hv/KhAUhlpyrW4jyTUQP8TDJC2
         r/B1yMg8/5aKbgkkZF7xmdd1+AtkCNb3GE1YzQoTAd3xVPydtSGSF9Le8oeDpeje3aY4
         sdYsVrKhWSh5N6elBuudvJYmwryAkLkZ0ia13OESU7GBUSqeehfLC9rWU54O+XMjsiq6
         fiksQFe8ogyz+uFDZWjht8jX+KW2OZvUvqPTVp85oTzD7i22jPtMBKotlR3h16m9qgQX
         usOw==
X-Gm-Message-State: AC+VfDzo9oMYLAezFXQMrtw1tzTW6BhVkVcp5Ce6+QCpM1gk4zsa2NJO
        /v3U/dN8rO6FvkKtgLbNzzYcaFhqWeM=
X-Google-Smtp-Source: ACHHUZ4rTa2Gl9EiG5FsV5n/MmFToH0Y6Cew6nawSOxBMM6+9Q8g3vkCg/XV8+C1bVN12QctCBzyvXhdHbA=
X-Received: from yuzhao.bld.corp.google.com ([2620:15c:183:202:76f0:18c9:8d89:3977])
 (user=yuzhao job=sendgmr) by 2002:a25:11c4:0:b0:c2a:b486:1085 with SMTP id
 187-20020a2511c4000000b00c2ab4861085mr2517826ybr.10.1687997253510; Wed, 28
 Jun 2023 17:07:33 -0700 (PDT)
Date:   Wed, 28 Jun 2023 18:07:29 -0600
In-Reply-To: <CABgObfYLnhW0qrPvFnMW_B9xZzLF6Ysn2uL4w9B815fUNVKK5A@mail.gmail.com>
Message-Id: <20230629000729.1223067-1-yuzhao@google.com>
Mime-Version: 1.0
References: <CABgObfYLnhW0qrPvFnMW_B9xZzLF6Ysn2uL4w9B815fUNVKK5A@mail.gmail.com>
X-Mailer: git-send-email 2.41.0.255.g8b1d071c50-goog
Subject: Re: [PATCH] MIPS: KVM: Fix NULL pointer dereference
From:   Yu Zhao <yuzhao@google.com>
To:     pbonzini@redhat.com
Cc:     chenhuacai@kernel.org, chenhuacai@loongson.cn,
        jiaxun.yang@flygoat.com, kvm@vger.kernel.org,
        linux-mips@vger.kernel.org, stable@vger.kernel.org,
        tsbogend@alpha.franken.de
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 26, 2023 at 6:33 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On Mon, Jun 26, 2023 at 9:59 AM Huacai Chen <chenhuacai@loongson.cn> wrote:
> >
> > After commit 45c7e8af4a5e3f0bea4ac209 ("MIPS: Remove KVM_TE support") we
> > get a NULL pointer dereference when creating a KVM guest:
>
> To be honest, a bug that needed 2 years to be reproduced is probably a
> sign that KVM/MIPS has no users. Any objections to removing it
> altogether?

ACK:
1. It's still broken after this patch [1]. The most well-tested MIPS
   distros, i.e., Debian/OpenWrt, have CONFIG_KVM=n. (The latter doesn't
   even provide the QEMU package on MIPS.)
2. Burden on QEMU dev. There is no guarantee that QEMU would work with
   KVM even if we could fix the kernel -- it actually does not until
   v8.0 [1], which is by luck:

   commit a844873512400fae6bed9e87694dc96ff2f15f39
   Author: Paolo Bonzini <pbonzini@redhat.com>
   Date:   Sun Dec 18 01:06:45 2022 +0100
   
       mips: Remove support for trap and emulate KVM
       
       This support was limited to the Malta board, drop it.
       I do not have a machine that can run VZ KVM, so I am assuming
       that it works for -M malta as well.

   (The latest Debian stable only ships v7.2.)

[1] https://lore.kernel.org/r/ZI0R76Fx25Q2EThZ@google.com/
