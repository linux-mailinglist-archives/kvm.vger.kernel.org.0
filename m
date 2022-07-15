Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5938E575C21
	for <lists+kvm@lfdr.de>; Fri, 15 Jul 2022 09:13:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232120AbiGOHJl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Jul 2022 03:09:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231718AbiGOHJT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Jul 2022 03:09:19 -0400
Received: from mail-vs1-xe32.google.com (mail-vs1-xe32.google.com [IPv6:2607:f8b0:4864:20::e32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9768B78DD3
        for <kvm@vger.kernel.org>; Fri, 15 Jul 2022 00:08:21 -0700 (PDT)
Received: by mail-vs1-xe32.google.com with SMTP id k2so3509153vsc.5
        for <kvm@vger.kernel.org>; Fri, 15 Jul 2022 00:08:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=SKk4fe199tCOLmeDZfxcQNbddbUVsyVisM9qRwohock=;
        b=r0pw304zOECYCgUHXTN6ao3Z1B6PkME/SytPQMFVHrlaV0z+/BfsnZHYXcJQi0Bj/G
         N4HfVKbuXpxgPPtABJBrrqdooOu6fvBwtgd2oinBP7NJPSpWxYuWsobTWRYGJXMdpMiE
         8dNAtOii6zmmC93BWSONKym+icl6pMBvCh6XxyErAUnOtVhRG6dPEfGXnZII7r3//yox
         dGB4EjXOykrabNDbI6JJNUmdSNboTiWss+1w9Ilj231RuRGvyIuYPSVrm5rTAT8ZdoJA
         sjQxaSF8qKnqDJQihhR++EMaCXWJfSHXVpaBXa25toQ+QTLzA8TR8ZorE0yS1r2lcum5
         zSeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=SKk4fe199tCOLmeDZfxcQNbddbUVsyVisM9qRwohock=;
        b=c8mJ2yqTIdW0VeL/ciwD4f+mjzIj6MBk3f8QlalG7Juq1HnIgBSI4Ajd7SPxHQuP7b
         QALY1ZosxIwVUmQf3+w/rJKSZJVqlH6NYukuav6Ymq/V/8pXcbLY9MV7S27AR0qq9Fzw
         bWkb64KYe8KF01nl9XsrtwRNDmwXpB7NPGYu2q/MWaZTLTKIlVWk38NyufvoRNydDlEc
         7VUyRh6QHuDra9xRQQY+kCCCVnkHka4vaBF0DbzduSfE66R3520HbUiqNSC/rOjpi5u2
         cktUm3lgSgRlwymG5gOZ7l7bhVIyHJDfIk99ALnS7Ic0npIQVU501/BC6UEctOsEFdEQ
         Xr8g==
X-Gm-Message-State: AJIora9GR7l+hgdXw+owTpYep1LnJBxEaCZaMhAzrCEY7K1HLNJc0Sm/
        lNT75mlVcmURpy/hxaUnrlVwd53qDGFWYDCIgzdxnA==
X-Google-Smtp-Source: AGRyM1v0EdTtR37dp0R9PYh4/X5Sg5iaWnvVnHvmKNDDpJsX9lLRQ3N0otxNm8E4tbZlaACWVfJeWABJ4mCl5j6GmqU=
X-Received: by 2002:a67:b24c:0:b0:356:c997:1cf0 with SMTP id
 s12-20020a67b24c000000b00356c9971cf0mr4858211vsh.9.1657868900660; Fri, 15 Jul
 2022 00:08:20 -0700 (PDT)
MIME-Version: 1.0
References: <20220714152024.1673368-1-maz@kernel.org> <20220714152024.1673368-9-maz@kernel.org>
In-Reply-To: <20220714152024.1673368-9-maz@kernel.org>
From:   Reiji Watanabe <reijiw@google.com>
Date:   Fri, 15 Jul 2022 00:08:04 -0700
Message-ID: <CAAeT=FyENQ2GqoFi9e80nWQrPpcoBfN_9x0ZMhf6uH8b0NYXZw@mail.gmail.com>
Subject: Re: [PATCH v2 08/20] KVM: arm64: vgic-v3: Push user access into vgic_v3_cpu_sysregs_uaccess()
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Schspa Shi <schspa@gmail.com>, kernel-team@android.com
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

On Thu, Jul 14, 2022 at 8:20 AM Marc Zyngier <maz@kernel.org> wrote:
>
> In order to start making the vgic sysreg access from userspace
> similar to all the other sysregs, push the userspace memory
> access one level down into vgic_v3_cpu_sysregs_uaccess().
>
> The next step will be to rely on the sysreg infrastructure
> to perform this task.
>
> Signed-off-by: Marc Zyngier <maz@kernel.org>

Reviewed-by: Reiji Watanabe <reijiw@google.com>

Thank you for addressing the comments!
Reiji
