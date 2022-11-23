Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 87E40635078
	for <lists+kvm@lfdr.de>; Wed, 23 Nov 2022 07:27:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236018AbiKWG1g (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Nov 2022 01:27:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235959AbiKWG1e (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Nov 2022 01:27:34 -0500
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B90F6A1A0
        for <kvm@vger.kernel.org>; Tue, 22 Nov 2022 22:27:33 -0800 (PST)
Received: by mail-pl1-x634.google.com with SMTP id y10so14594866plp.3
        for <kvm@vger.kernel.org>; Tue, 22 Nov 2022 22:27:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=tit1GoRDHXxGIzZdw8RHtC91q2gw44B8zNxKS7z02AA=;
        b=fqnDNTMFJXL6XBTeO+kRQJFWvP7cvAJx1e8OAUaq01/iImdfKXDQth+CsyTAS02ErY
         gOASCuAizTdmqPf5oolegW2ktzaQxnmm8fsEurNaP3n2A5eGDsVdiCQk7omLcW2Fsf2S
         d6eM1CdGhpj3oVBsg76UpeggwkYA2ZpHdbx9ZOht42+LjzbynTlqPC1AJu+Ys1YbvfuN
         9DPIqYCqPnVcmaFMZmdhqecrwmSt0sebO8Q/c8q2Dl8+K61eAoRUDjFLkI32HrMvP5V+
         8/u19Bqkt8t5bZcwoRi9HlB3NbnkFH9T5nDQlYaRQUwJenxVBBuN2WUHHZ/QPb2FQGOV
         QB3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=tit1GoRDHXxGIzZdw8RHtC91q2gw44B8zNxKS7z02AA=;
        b=26U+LYmZwIU8Y+MmkRLIHwfq+8yRFPT5F1/jyCKC/YMy0xl1POQNgOaKmkNfyRDqET
         /KC4bw7UwrdG7LUXrtYDlKYnSlqlAdhPosATe3odoC4dzDzESmQnBc35q9JpSf7tSAMO
         RylvjZO1xaTU5YYCJOEiLva+njxn4dy4R96UAATnMIdsn457R2HB0XOb+HzDRbV6LQ7k
         0Ia7JSV8a0Hz/K5cTBpGh3LuDOemCv5Z96vrcoCv4CS7lJ97XJ4w6X1YvciYZ+bz7JxU
         +wIvSK1PY3mqVBcQG/7iZyBUNAct9sbgu2y88WQCCWmdS0KXyRkrLUKBwju1Cul7mdlm
         xpyg==
X-Gm-Message-State: ANoB5pmFlgmrhHyMV+0LzFQDUeLT1WSaGdRKhGRmLqeYAD4jvTS8QSHI
        UTMpV2YdZ5NUFZqbeEQ8hh/MF1VUYI+WDOzSjmXO7g==
X-Google-Smtp-Source: AA0mqf5nlutVfDZV3mLPMpBH63zenw1aNZTS1OGEV25ZP+8iiz3jkhX4OVBoK3Ai4ysrDyk3GPfTAhlBrvQ5qYUgktI=
X-Received: by 2002:a17:902:9006:b0:172:d410:2a91 with SMTP id
 a6-20020a170902900600b00172d4102a91mr7622542plp.30.1669184853196; Tue, 22 Nov
 2022 22:27:33 -0800 (PST)
MIME-Version: 1.0
References: <20221113163832.3154370-1-maz@kernel.org> <20221113163832.3154370-16-maz@kernel.org>
In-Reply-To: <20221113163832.3154370-16-maz@kernel.org>
From:   Reiji Watanabe <reijiw@google.com>
Date:   Tue, 22 Nov 2022 22:27:16 -0800
Message-ID: <CAAeT=Fz-zYX4qLt-RKvO6P0D5Si9vxxpsbALH1LPbON8efyEeg@mail.gmail.com>
Subject: Re: [PATCH v4 15/16] KVM: arm64: PMU: Simplify vcpu computation on
 perf overflow notification
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
> The way we compute the target vcpu on getting an overflow is
> a bit odd, as we use the PMC array as an anchor for kvm_pmc_to_vcpu,
> while we could directly compute the correct address.
>
> Get rid of the intermediate step and directly compute the target
> vcpu.
>
> Signed-off-by: Marc Zyngier <maz@kernel.org>

Reviewed-by: Reiji Watanabe <reijiw@google.com>
