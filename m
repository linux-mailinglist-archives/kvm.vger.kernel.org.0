Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D66A94EA492
	for <lists+kvm@lfdr.de>; Tue, 29 Mar 2022 03:26:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229618AbiC2BY7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Mar 2022 21:24:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229446AbiC2BY7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 28 Mar 2022 21:24:59 -0400
Received: from mail-lf1-x12b.google.com (mail-lf1-x12b.google.com [IPv6:2a00:1450:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3F346432
        for <kvm@vger.kernel.org>; Mon, 28 Mar 2022 18:23:16 -0700 (PDT)
Received: by mail-lf1-x12b.google.com with SMTP id z12so13952891lfu.10
        for <kvm@vger.kernel.org>; Mon, 28 Mar 2022 18:23:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=gG1dsFEHxVSzlE39a8P+3Vh86tpXJgIh+oI8BehHFLw=;
        b=k929aJ5mhdg5v+9goYJGuSlk3WjPP/llT/brdP27DSd7CR8P8CiiYrUHF/wlRp3Afl
         +P6GxMlleZs1o8dNOmQALMYo9a8DdSC6KOdbMbNdv5QwYr8dCzZQowumgZUMD5tzP/0L
         BSs7U4vCN6fpgxtfHyoeRRL+i2typA2QX/dXjZ9hILlj+UAiYLebxHVvB0ElgTbBG6YR
         DifReIXAYpAwRSSelwGtiauFYNrHveyOivEvg83un375GcqqD4aAU1QRqi4kgCVolZ73
         oDCw81CmbTwoMs6nkxtc0F7DZTj5gSg44Yn20Ere0yrdA8z4haO2ascF+TMql76FlM7o
         YKAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gG1dsFEHxVSzlE39a8P+3Vh86tpXJgIh+oI8BehHFLw=;
        b=YP1ud77WTK6fkaHwuxSSdOyxdtGUthEDlN5iM2NbeXaroCdMg6CRMrOQzj3bgZ65IB
         SZFt32VL5p75JfvQpldUo+j6u57lnxXTOZRrozeMhFLi+BWagf5zwsunbrPwnd7PnWGc
         qVdo7HVgwSM+cypI6HNfodEG1jWfe6Htxj+6fWGO1ihJAh0rVoZhDhVCj59fonwXSUZY
         1BjRHvw02X+i7if4trexBw1Em+L5QtXziuG2IkX/vsUCfMWhWet1b0uwmTpRfj09hhEa
         895nTYdSLdY+DuY5d/95zFXO/q3yTfq+bvfc6nS0TjYQrYR85bFRG/dBhDLo/Bo3yo52
         mshw==
X-Gm-Message-State: AOAM532jTMiw/86GYVxKyMQ+7OMrCrm5sb4YxL1r90psRUg/abRBJd+X
        CbNjA4ZqpZKn4kc07Nvaq+N3l2HKbCbJmu5TFD+ZGK7NF3GWWw==
X-Google-Smtp-Source: ABdhPJydvgE88BCqtewlj0lkm2CZ45JgfLYYW6+/A89FABAyuZV4FU5z3LIFWOqUDvmtMWwUnjP7PxxlQryZixl0GgI=
X-Received: by 2002:ac2:510f:0:b0:44a:5ccc:99fb with SMTP id
 q15-20020ac2510f000000b0044a5ccc99fbmr321023lfb.38.1648516994642; Mon, 28 Mar
 2022 18:23:14 -0700 (PDT)
MIME-Version: 1.0
References: <20220329011301.1166265-1-oupton@google.com>
In-Reply-To: <20220329011301.1166265-1-oupton@google.com>
From:   Oliver Upton <oupton@google.com>
Date:   Mon, 28 Mar 2022 18:23:03 -0700
Message-ID: <CAOQ_QsgH7s7gW6KTxKCFx25-oYHk+NXBHvWK7GfcPQ6ChxVEjg@mail.gmail.com>
Subject: Re: [PATCH 0/3] KVM: arm64: Limit feature register reads from AArch32
To:     kvmarm@lists.cs.columbia.edu
Cc:     kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <Alexandru.Elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-arm-kernel@lists.infradead.org,
        Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Reiji Watanabe <reijiw@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Mar 28, 2022 at 6:13 PM Oliver Upton <oupton@google.com> wrote:
>
> KVM/arm64 does not restrict the guest's view of the AArch32 feature
> registers when read from AArch32. HCR_EL2.TID3 is cleared for AArch32
> guests, meaning that register reads come straight from hardware. This is
> problematic as KVM relies on read_sanitised_ftr_reg() to expose a set of
> features consistent for a particular system.
>
> Appropriate handlers must first be put in place for CP10 and CP15 ID
> register accesses before setting TID3. Rather than exhaustively
> enumerating each of the encodings for CP10 and CP15 registers, take the
> lazy route and aim the register accesses at the AArch64 system register
> table.
>
> Patch 1 reroutes the CP15 registers into the AArch64 table, taking care
> to immediately RAZ undefined ranges of registers. This is done to avoid
> possibly conflicting with encodings for future AArch64 registers.
>
> Patch 2 installs an exit handler for the CP10 ID registers and also
> relies on the general AArch64 register handler to implement reads.
>
> Finally, patch 3 actually sets TID3 for AArch32 guests, providing
> known-safe values for feature register accesses.
>
> I'll leave it as an exercise for the reader to decide whether or not I'm
> being _too_ lazy here ;-)
>
> Series applies cleanly to kvmarm/fixes at commit:
>
>   8872d9b3e35a ("KVM: arm64: Drop unneeded minor version check from PSCI v1.x handler")
>
> Tested with AArch32 kvm-unit-tests and booting an AArch32 debian image
> on a Raspberry Pi 4. Nothing seems to have gone up in smoke yet...

That is to say, I booted an AArch32 debian image as a guest. The host
kernel was of course arm64.
