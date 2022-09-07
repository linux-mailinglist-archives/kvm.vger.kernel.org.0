Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9DD35AF9D3
	for <lists+kvm@lfdr.de>; Wed,  7 Sep 2022 04:27:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229774AbiIGC1D (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Sep 2022 22:27:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229576AbiIGC1C (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Sep 2022 22:27:02 -0400
Received: from mail-ua1-x931.google.com (mail-ua1-x931.google.com [IPv6:2607:f8b0:4864:20::931])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C5C980B5F
        for <kvm@vger.kernel.org>; Tue,  6 Sep 2022 19:27:01 -0700 (PDT)
Received: by mail-ua1-x931.google.com with SMTP id e3so5020635uax.4
        for <kvm@vger.kernel.org>; Tue, 06 Sep 2022 19:27:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=pwFmJDralQuPsmi85jLOaYYTf896GNyoxThIcLObtQo=;
        b=S8+67QypVVGymC9ftQWRJdOke7mKZuzJ7mL7uh7aQwMhTkXAEdk9XP41Xtc/TMPvZ2
         2lMCGni0hc6PcLRnNJGshXz5QTRCHY0LGATJ/zkPG/BvszgifXhkL2bqvXkQm1BjGy/n
         z11SvT+yVZVhdHwSO7WwieIIv4JgwBZKLzvm7nf3bxdwmuCgJDTPnI0pimU3VEgbBhID
         xEooM2SKmB1yR2MkNHAQn9mT10e/ZNfUs0Ssp3iwhMgRsLM3OgX829fUlyiQFN0/su+/
         UOojUS1V0RAJOFg2SIMKBeVzAA8syDcJTUlzcMBEfBMDEw1rQICNYgWYI0vTDUkQ53+d
         kKvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=pwFmJDralQuPsmi85jLOaYYTf896GNyoxThIcLObtQo=;
        b=rIfdAkC30MuumRjST0VMGuxW3z+PUHaOFlkajx6xbN/1qt2LHSwEOZ8TQgxWCylofg
         3HaPwpZc4n7Q53bzzXerumkAVutkxEWFg9lC1dlnuuT9U4nbEZTzcZfH/UXGBDEYNZ+2
         8K5AZyhyVZS1/igY0Gtuk2tu+/67ovT7xUGv8d5At7gZIioN61zMxA+i83ml5ZHOc7rS
         5A9Zlz+VEQxhAwg9Nybkw2Jk0NJ5yNIyVu0DE2ZzG+LgiAs1RQxsQd82UXpdYbSk+YKe
         OkUZ7ocEHwuQX0ZYCNZKc9IiKsGHCirgno6nHI8hd9onByY/oG52ZKzalzr17PrrhW8z
         jKnw==
X-Gm-Message-State: ACgBeo3poTJMChFWEDQBIkUvD1g6ODvlNJped3KcJYq7tNOG81SvOBCA
        woUXT0/jrq3/QQAY9smp9bcHwMYCPngznLfgbpkmsA==
X-Google-Smtp-Source: AA6agR4L/Ysf4UGfyY06Bl3A9WStVJxvIZauMf63xBjr99mNZgT82Ya7oDQb9CC3wQhnwu5zpxtEQTfvTq/gCnw1GMs=
X-Received: by 2002:ab0:13ed:0:b0:39a:2447:e4ae with SMTP id
 n42-20020ab013ed000000b0039a2447e4aemr462462uae.37.1662517620579; Tue, 06 Sep
 2022 19:27:00 -0700 (PDT)
MIME-Version: 1.0
References: <20220902154804.1939819-1-oliver.upton@linux.dev> <20220902154804.1939819-4-oliver.upton@linux.dev>
In-Reply-To: <20220902154804.1939819-4-oliver.upton@linux.dev>
From:   Reiji Watanabe <reijiw@google.com>
Date:   Tue, 6 Sep 2022 19:26:44 -0700
Message-ID: <CAAeT=Fz6mFGB5kT18Z3B2YXuCY41DdCOQOTJcdRzp-zgj=rOfQ@mail.gmail.com>
Subject: Re: [PATCH v2 3/7] KVM: arm64: Drop raz parameter from read_id_reg()
To:     Oliver Upton <oliver.upton@linux.dev>
Cc:     Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Sep 2, 2022 at 8:48 AM Oliver Upton <oliver.upton@linux.dev> wrote:
>
> There is no longer a need for caller-specified RAZ visibility. Hoist the
> call to sysreg_visible_as_raz() into read_id_reg() and drop the
> parameter.
>
> No functional change intended.
>
> Suggested-by: Reiji Watanabe <reijiw@google.com>
> Signed-off-by: Oliver Upton <oliver.upton@linux.dev>

Reviewed-by: Reiji Watanabe <reijiw@google.com>
