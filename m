Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A5F8635014
	for <lists+kvm@lfdr.de>; Wed, 23 Nov 2022 07:09:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235297AbiKWGIw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Nov 2022 01:08:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235991AbiKWGIe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Nov 2022 01:08:34 -0500
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A05B5CD0D
        for <kvm@vger.kernel.org>; Tue, 22 Nov 2022 22:08:09 -0800 (PST)
Received: by mail-pl1-x635.google.com with SMTP id d20so15728627plr.10
        for <kvm@vger.kernel.org>; Tue, 22 Nov 2022 22:08:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=h5tlKNi35V94k0QmV2ysH94Zb5ALfgaBlCa6CRxYIVw=;
        b=eEdddm6ebarYt7g7uJhWOnpgtypJcRMCmOrwuMaNVAA0C5aBaCucbUGx0fVJIOPlSW
         hNU/iCZT3w1eHA9yNvRVrKP4s/WGB5nWkZ5SNaTLoDMrZdetIXV7DUlzXgQ0ZI6O6D+6
         turNtaZkl1rWGQ25PWMZCrZdZetW0KQ5nSknO98LM/koczRsx+sr997Z6Y/nWEVSjfkg
         qVEcHzGhPUx8KY4y+poF1Ed4OUzls/fCfaCQ+ku5rLVm7nWR2Fvu/iFVPShBI//SIcTM
         EYWYxB+VjSWM0PzjWaZYoES2vXUzhfLJe96SE6tNaWrzXSI35zv+R9NxKDwCNWfzNNlH
         YRoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=h5tlKNi35V94k0QmV2ysH94Zb5ALfgaBlCa6CRxYIVw=;
        b=1ctMMmv4rfX8Ad77w0BJ8fcyQGTIoZBI5e9x0IicRJDTvyI7shX6j/oNsvxs4riOPY
         YkjGAu+G9Y8LgNSc2Qp0LnpVa681dnKBNeIcFjqeyztMDUPr3LvAc17Wb19JPPduCSdY
         9cf2wL/lOAN7OP8Llm6smsleFfXcIA2JmROasNSt9JXOhxHx1cULOSCPGKqwTkyih4d2
         EzqJeOHLj7qAdmbnQGAI3WOfTSsN04cM+xv3WuHa1bnvuCsaaqK5UVA0o4x1jRFkbE3h
         pRz4PdDOalA18kN3UIfwlGgpKir4mU+psTrXWdPjz2cBzzgWIYfTA+1UJM1iXaQLBFOj
         KOJA==
X-Gm-Message-State: ANoB5pk8eg0TDtAk1pih1U7F7axMCqtfJOoCbb882KHTEImhj9A09GRj
        OyANNm9A2ti1NRLwqnOHH1iRVjcJQ7FVYRtkJ93/5Q==
X-Google-Smtp-Source: AA0mqf5lImrYjSG2qG8wHkOxPafuxpqJyZLTwqEDiwfRe0ptbYcQ09on7ZiYFobULDz+0AHmQt42G9VURGZZHsd0DAk=
X-Received: by 2002:a17:90a:e2c5:b0:214:1648:687d with SMTP id
 fr5-20020a17090ae2c500b002141648687dmr35554546pjb.78.1669183688483; Tue, 22
 Nov 2022 22:08:08 -0800 (PST)
MIME-Version: 1.0
References: <20221113163832.3154370-1-maz@kernel.org> <20221113163832.3154370-15-maz@kernel.org>
In-Reply-To: <20221113163832.3154370-15-maz@kernel.org>
From:   Reiji Watanabe <reijiw@google.com>
Date:   Tue, 22 Nov 2022 22:07:52 -0800
Message-ID: <CAAeT=FwKuB2mAhWaeDSVQnHyDnQrLnNAuZ+Z3=KoFZe5imiwXQ@mail.gmail.com>
Subject: Re: [PATCH v4 14/16] KVM: arm64: PMU: Allow PMUv3p5 to be exposed to
 the guest
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
> Now that the infrastructure is in place, bump the PMU support up
> to PMUv3p5.
>
> Signed-off-by: Marc Zyngier <maz@kernel.org>

Reviewed-by: Reiji Watanabe <reijiw@google.com>
