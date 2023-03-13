Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92AA96B7BC1
	for <lists+kvm@lfdr.de>; Mon, 13 Mar 2023 16:19:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229829AbjCMPTC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Mar 2023 11:19:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229528AbjCMPTC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Mar 2023 11:19:02 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E4525A6FC
        for <kvm@vger.kernel.org>; Mon, 13 Mar 2023 08:18:57 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id cr10-20020a056a000f0a00b005cfec6c2354so6865997pfb.9
        for <kvm@vger.kernel.org>; Mon, 13 Mar 2023 08:18:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678720737;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=J9Xq5escaSYWRdwEHLAH6oMvH+8AblM7LMhxhLK/+R0=;
        b=ECU2onOte2LWgRcZ6hdpQJUQ545e8QYM/XcY7GVAWLhiWCLmjylBB4Lrbg9gPXs1Ly
         nyymNz8VgQwaIYdloRIqQFkY18RufYl0mPrAqfYFQTkZ1/lhJmPjcOUXTNTwEn56gupM
         AP/aLRyohdEkarN7z8U0kKmAMbtXatRxWA3ZViONpAZqXBqOJHXxHqQFK+l048IthItP
         ClzEB5dty74kqOXSVv7HoBUAnVozh8IkxDnN/1sOZSiAEgeg7hRiwB2MsepNbU/GdTxp
         FQwlKOIbv6RHdQXdmiC934rGjmvInxzxTVlwbQyDRnc0kxiIceRbwpY+0ZKXrD0WblOt
         nMag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678720737;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=J9Xq5escaSYWRdwEHLAH6oMvH+8AblM7LMhxhLK/+R0=;
        b=lpzuGfNFQsaepU43iqNxPatiMfsTvOLyfv5e6WhoTmc6bduMHQ10Fz1wyxnuMhMZHe
         FcVlp65bGRCPfhfWl1g43fzdkQPCupYuFG8QzR0zTIfjajzSzWzqwD6SLvE3fW89KwJk
         RnG50iRJ9W+n9rpXo3bnG/VyDZ23/0L97H4zJM3zE0lJYgFs7sR3t8TTtofyQ73d5QTH
         weNIcr4lrO7XfhofTttADsnLcR8ak8Krm5+qSgX3ZUa06sLBKc96YdptaklxS1Efk7we
         c4WDEm38NKiR0MvtOdRdsGWR8lrNlYhfgRhVIqcAlWI31J6SEJFSYSLwE7/dySznN2q/
         Yc4A==
X-Gm-Message-State: AO0yUKVDGvoZOfJUgZoqGmW3zj2K9RkbYxSCaG4C19cTK7uzmHC6gG3P
        kx+J/ssBAPF9ZXyMA7R0/vTespEPcP4=
X-Google-Smtp-Source: AK7set9BlNoLJIo5wX3TzGHjv6KddFr8nWGutCu67vJ9adzJb5qHZFLAwIMAXzJ2iWxeuSokv6/ju1J+ybs=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a62:1b50:0:b0:593:e110:9582 with SMTP id
 b77-20020a621b50000000b00593e1109582mr3599041pfb.2.1678720736984; Mon, 13 Mar
 2023 08:18:56 -0700 (PDT)
Date:   Mon, 13 Mar 2023 08:18:55 -0700
In-Reply-To: <878rg25hbq.wl-maz@kernel.org>
Mime-Version: 1.0
References: <20230307034555.39733-1-ricarkol@google.com> <20230307034555.39733-8-ricarkol@google.com>
 <878rg25hbq.wl-maz@kernel.org>
Message-ID: <ZA8+31vQA6vcQuK2@google.com>
Subject: Re: [PATCH v6 07/12] KVM: arm64: Export kvm_are_all_memslots_empty()
From:   Sean Christopherson <seanjc@google.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     Ricardo Koller <ricarkol@google.com>, pbonzini@redhat.com,
        oupton@google.com, yuzenghui@huawei.com, dmatlack@google.com,
        kvm@vger.kernel.org, kvmarm@lists.linux.dev, qperret@google.com,
        catalin.marinas@arm.com, andrew.jones@linux.dev,
        alexandru.elisei@arm.com, suzuki.poulose@arm.com,
        eric.auger@redhat.com, gshan@redhat.com, reijiw@google.com,
        rananta@google.com, bgardon@google.com, ricarkol@gmail.com,
        Shaoqin Huang <shahuang@redhat.com>
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Mar 12, 2023, Marc Zyngier wrote:
> On Tue, 07 Mar 2023 03:45:50 +0000,
> Ricardo Koller <ricarkol@google.com> wrote:
> > No functional change intended.
> 
> I wish people stopped adding this pointless sentence to commit
> messages. All changes have a functional change one way or another,
> unless you are only changing a comment.

The implied context is that there is no change in runtime functionality, which
does hold true for many changes.  I personally find the annotation helpful, both
for code review and when doing git archaeology.  If a changelog states that the
author doesn't/didn't intend a functional change, then _any_ change in (runtime)
functionality becomes a red flag, and for me, prompts a closer look regardless of
whether or not I have other concerns with the patch/commit.
