Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B58C377C3E0
	for <lists+kvm@lfdr.de>; Tue, 15 Aug 2023 01:17:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233438AbjHNXRU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Aug 2023 19:17:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233470AbjHNXQ4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Aug 2023 19:16:56 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BDB8171F
        for <kvm@vger.kernel.org>; Mon, 14 Aug 2023 16:16:56 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-589e3ac6d76so32207517b3.1
        for <kvm@vger.kernel.org>; Mon, 14 Aug 2023 16:16:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692055015; x=1692659815;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=XJ2VqA/vSflBac203Z0ZgYzciS8CSN/YrZrCQZvgAqE=;
        b=OxYYoyUAQaeaCm0MRnDlT6YpDWZ0eDciFaHbssoRAoYyzjd2o0WDI1UOBCOxL+kMJc
         5YD0NK8r1uDf6e0Jatvt+d6P+BWzIhvUYoQQhLjByYnja3UBlbXrGoFe9hBNCSmd3Por
         77GbZptlqN3qID9Yi7OuuYNKro+YD6l9Q6jj3+sUYzoK08H9wS69cXzUBziAMKx3xld/
         w96wxOhnL73JzIXq2lGp1mV73XNcE7Ps2NUvuAohRziILKeBly43Y5qUc7dLaviqameq
         hE+kTcQyTkgYI/ntVGdkCqeR0EWDhGYDk0kgtw+nvGshr7JSpUCtOXj/qFAa5uoFZbVm
         YkSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692055015; x=1692659815;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XJ2VqA/vSflBac203Z0ZgYzciS8CSN/YrZrCQZvgAqE=;
        b=OMdqEK+IW4GRyJFczbKQuCvnroTe7/zHq2vmEyC8KhvNxgeVQFd2EjiEN/mnPFubO8
         IsggryLJlU5NAsH9hq1zwOB9+8NftyFb4iEX/tNvQJFC6qox4uW4Yxh3kScw482XTGA5
         CtmJ76BfZJJnL6kJ+rYDRs0i+Ll6iz+dNJQFJfMiKXZmLz8ENJBWKtWKURYuseDgoDkv
         7SUqUIvhM/n2SI/jHWO4RQCXaUeKmNgUhhefo8SVSk083VJlm49NXGlUYzfePpNnVbKB
         wf2TIGSG5lGrROFFYcotMu+Y5+GCJDHdMAZULk40CGtCY5cnj6UBQU9e8QUjHjI7DOmC
         Cj+A==
X-Gm-Message-State: AOJu0Yy0HsFZF00nY7q4zwZ/QxKsg/gWw+B9F2MErojtp3qrH41ey0ge
        CcWjrmnDkx/wl6AEA5o3RN9uvgc2ln4=
X-Google-Smtp-Source: AGHT+IGO0AL45xRymm0BjDJln3deMA/9LFqjImi7JInSUnl69k7Qer+RG4sudzofLCbCQa+Rdgz1TuaGB1A=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:690c:709:b0:57a:118a:f31 with SMTP id
 bs9-20020a05690c070900b0057a118a0f31mr180335ywb.7.1692055015309; Mon, 14 Aug
 2023 16:16:55 -0700 (PDT)
Date:   Mon, 14 Aug 2023 16:16:53 -0700
In-Reply-To: <20230811045127.3308641-1-rananta@google.com>
Mime-Version: 1.0
References: <20230811045127.3308641-1-rananta@google.com>
Message-ID: <ZNq15SZ+53umvOfx@google.com>
Subject: Re: [PATCH v9 00/14] KVM: arm64: Add support for FEAT_TLBIRANGE
From:   Sean Christopherson <seanjc@google.com>
To:     Raghavendra Rao Ananta <rananta@google.com>
Cc:     Oliver Upton <oliver.upton@linux.dev>,
        Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        Jing Zhang <jingzhangos@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Colton Lewis <coltonlewis@google.com>,
        David Matlack <dmatlack@google.com>,
        Fuad Tabba <tabba@google.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        linux-mips@vger.kernel.org, kvm-riscv@lists.infradead.org,
        linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
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

On Fri, Aug 11, 2023, Raghavendra Rao Ananta wrote:
> The series is based off of upstream v6.5-rc1.

Lies!  :-)

This is based off one of the kvmarm.git topic branches (I didn't bother to figure
out which one), not v6.5-rc1.

Please try to incorporate git format-patch's "--base" option into your workflow,
e.g. I do "git format-patch --base=HEAD~$nr" where $nr is the number of patches
I am posting.

It's not foolproof, e.g. my approach doesn't help if I have a local patch that
I'm not posting, but 99% of the time it Just Works and eliminates any ambuitity.

You can also do "--base=auto", but that only does the right thing if your series
has its upstream branch set to the base/tree that you want your patches applied
to (I use the upstream branch for a completely different purpose for my dev branches).
