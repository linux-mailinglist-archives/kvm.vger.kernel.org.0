Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03FB9678D01
	for <lists+kvm@lfdr.de>; Tue, 24 Jan 2023 01:51:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232314AbjAXAve (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Jan 2023 19:51:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231932AbjAXAvc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Jan 2023 19:51:32 -0500
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC62933458
        for <kvm@vger.kernel.org>; Mon, 23 Jan 2023 16:51:29 -0800 (PST)
Received: by mail-ed1-x530.google.com with SMTP id v10so16629523edi.8
        for <kvm@vger.kernel.org>; Mon, 23 Jan 2023 16:51:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=M2kD3GwOu1cuqUDf6v9BDb+wpn8NSWwJtfH+fWMIGrs=;
        b=TEQYkWqdmsV7t1y8yvJ2IfOpQzMb6o/P7CXThq+2vLZEIqTjY9ANhiIt4ZN75UgF2C
         xGxPUvHzVvqWxS+vETbzDygQr2QpPAx1+6BNR7Fdz4HrOxvOuoX6PhKRHZ/vqseZiJjP
         fOwlq5NoNxAf/z6tGp42Gi5zejvAW8ehUZG6l+47liPkYH2KE3KVkrqJnvPPFLSzK8he
         ZOfJ70E8RJG0D5wfccS8HETnYX/gVUBkGhsypQmNi8tg2z+kAgCpfbs/dao1EpK5fGb0
         Vi80bBcrGSiAisd87Wf1r3zHql2bMJAnWynWect2boedk+Zaf8y7rdGRRsiShs+fwvqF
         xcEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=M2kD3GwOu1cuqUDf6v9BDb+wpn8NSWwJtfH+fWMIGrs=;
        b=1PM4DD31q04M4W+iPXK8wHvWkA8N/61984sc1TYCZ7q85p4JcErEQvnprU8a42wpMr
         n96CWXZd5cc2CJPsKxJtA83YYWX3ck3kg2hOYTKKu5qbdVcdLKuJY03CYskQHudxDl6l
         6cgek1e3jgHSEst/FaeRiUfghw7xGoDpfLO06qwLE6+04PzX02a2muAOzph1taLlyiKe
         LGEYS8LZj2IwWpVUGszNhWQnF8uur5x5QNIIS0SM6CwM9aCJTRGMmn7d8CkyWOIaCPHr
         SPkxE2IbrM+Hy5ZyrAGb1Y3qe++MlFhk13XBVptF3MhDtN4v3zrwbDuKkMXjpL7f6R7l
         5FZQ==
X-Gm-Message-State: AFqh2kr9MURLPsXGAXgWLiSd+rxCh4qcOCrir0NHzvUueYeB5qXWc+nG
        5VSuR60gck1TsUNUhwu9sxly+SyJ6qBYP6o7I/vHLg==
X-Google-Smtp-Source: AMrXdXuiR2zDQjQTwOKPYxYiv6nBQxYDOm6Uo5rrXeXJwtr1kC3DgQfxY5fX74WNUq+cFZTNBOgpsUR83oMPt3dcFxI=
X-Received: by 2002:a50:ee12:0:b0:499:7efc:1d78 with SMTP id
 g18-20020a50ee12000000b004997efc1d78mr2851639eds.81.1674521488275; Mon, 23
 Jan 2023 16:51:28 -0800 (PST)
MIME-Version: 1.0
References: <20230113035000.480021-1-ricarkol@google.com> <20230113035000.480021-2-ricarkol@google.com>
In-Reply-To: <20230113035000.480021-2-ricarkol@google.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Mon, 23 Jan 2023 16:51:16 -0800
Message-ID: <CANgfPd9gMoR=F3uKhDtjsUV0efuoNvCLV0o0WoJKm9zx_PaKsQ@mail.gmail.com>
Subject: Re: [PATCH 1/9] KVM: arm64: Add KVM_PGTABLE_WALK_REMOVED into ctx->flags
To:     Ricardo Koller <ricarkol@google.com>
Cc:     pbonzini@redhat.com, maz@kernel.org, oupton@google.com,
        yuzenghui@huawei.com, dmatlack@google.com, kvm@vger.kernel.org,
        kvmarm@lists.linux.dev, qperret@google.com,
        catalin.marinas@arm.com, andrew.jones@linux.dev, seanjc@google.com,
        alexandru.elisei@arm.com, suzuki.poulose@arm.com,
        eric.auger@redhat.com, gshan@redhat.com, reijiw@google.com,
        rananta@google.com, ricarkol@gmail.com
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

On Thu, Jan 12, 2023 at 7:50 PM Ricardo Koller <ricarkol@google.com> wrote:
>
> Add a flag to kvm_pgtable_visit_ctx, KVM_PGTABLE_WALK_REMOVED, to
> indicate that the walk is on a removed table not accesible to the HW
> page-table walker. Then use it to avoid doing break-before-make or
> performing CMOs (Cache Maintenance Operations) when mapping a removed

Nit: Should this say unmapping? Or are we actually going to use this
to map memory ?

> table. This is safe as these removed tables are not visible to the HW
> page-table walker. This will be used in a subsequent commit for
...
