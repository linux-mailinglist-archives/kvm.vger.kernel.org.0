Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4386F630C27
	for <lists+kvm@lfdr.de>; Sat, 19 Nov 2022 06:31:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229592AbiKSFba (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 19 Nov 2022 00:31:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbiKSFb3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 19 Nov 2022 00:31:29 -0500
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8E834F18F
        for <kvm@vger.kernel.org>; Fri, 18 Nov 2022 21:31:28 -0800 (PST)
Received: by mail-pf1-x433.google.com with SMTP id b29so6752585pfp.13
        for <kvm@vger.kernel.org>; Fri, 18 Nov 2022 21:31:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=zA4MvfCx2wJ6ZC0yAwP3Kt5ez44MPaUUZGSZKLr05qU=;
        b=OViBe7Prr+WNneb+sFV50YXvGDB4BUPrIn0sCBrBFXjV6NuqIO2ITUpTAlVzYbM7fO
         A2NsPkpnPIkVBi71AwoceBT1dirH64Fmm0AM4Nrsa+IICdwYwARgMzukzOL+fAt6Dtkm
         ksr8oomCuHB4tc4g3EtEa8lIMU6XqB00JEOmWX2+atzDS/GVF/qn2JDIiljMGhHhmOVT
         6y8QjZuX1sqbBa0vzK6yN1SMxvRYk+xaGlRfyihgQDBBDVBI+z6m4wtEBvla+Bw6Lmnw
         iNvg9CkwSxC/yrVNd4VW4qTS6S8pJoKg5vt9rUisCnSNnTyh/bah2l25GOT2XjCjt7yr
         1M5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zA4MvfCx2wJ6ZC0yAwP3Kt5ez44MPaUUZGSZKLr05qU=;
        b=KF3okDL1sy4AkY5CgZ7yJdV90+FTZtVfHH2OORAervsuwub+4DYFuD2PFvodFGOKxh
         67W1wmn5AV0AyhEksF+5Fj5Xjr7CQVqc0YiGUBTg9HV3mnyjU5AEiZKL2focnKn8mst7
         XxC6SzH+UyM8c5m98EWCqlhgbrWQEKSvXoEQlx60VG0cRLOLzrzor4g8Fnwboo8I3kDY
         aCpCP5wYsQGBgiLVW9QsjqUjDMaWN64o1uq1SLWveLXkAsYO6dQo/UEg73luzJ2V23sr
         vSZrKHIxmYICCPldTgOrjkfPngPaFhNEUX+ZTX2DvgET684BcfQvlW1CTX78okCKKEj0
         k7rg==
X-Gm-Message-State: ANoB5pkmqVuNAgvO0QiweuTY8UD5tL1LLTizYtb0qw4aEW+VnENo0Gki
        Yg4y5WljE+eK7jkj+WJorDqKajqPx2IfM5Z4tfVz8YGzSBFSOA==
X-Google-Smtp-Source: AA0mqf6QqOtcX601H4y3vkSngjFJKCDeIT0BRH0yTFy+3iR7DMokQILefhm0heQeNptOQNwem6K9h6J9RMChIkJjll8=
X-Received: by 2002:aa7:80d8:0:b0:56d:98e3:4df8 with SMTP id
 a24-20020aa780d8000000b0056d98e34df8mr10899836pfn.37.1668835888263; Fri, 18
 Nov 2022 21:31:28 -0800 (PST)
MIME-Version: 1.0
References: <20221113163832.3154370-1-maz@kernel.org> <20221113163832.3154370-12-maz@kernel.org>
In-Reply-To: <20221113163832.3154370-12-maz@kernel.org>
From:   Reiji Watanabe <reijiw@google.com>
Date:   Fri, 18 Nov 2022 21:31:12 -0800
Message-ID: <CAAeT=Fzn2znqPRTH6TE_NbgD+OF8oLcFX5uooZ3Svn-OgBa7Gw@mail.gmail.com>
Subject: Re: [PATCH v4 11/16] KVM: arm64: PMU: Allow ID_AA64DFR0_EL1.PMUver to
 be set from userspace
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

On Sun, Nov 13, 2022 at 8:46 AM Marc Zyngier <maz@kernel.org> wrote:
>
> Allow userspace to write ID_AA64DFR0_EL1, on the condition that only
> the PMUver field can be altered and be at most the one that was
> initially computed for the guest.
>
> Signed-off-by: Marc Zyngier <maz@kernel.org>

Reviewed-by: Reiji Watanabe <reijiw@google.com>
