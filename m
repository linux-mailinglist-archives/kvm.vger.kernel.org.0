Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47BD756C7A0
	for <lists+kvm@lfdr.de>; Sat,  9 Jul 2022 09:00:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229598AbiGIG76 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 9 Jul 2022 02:59:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229481AbiGIG76 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 9 Jul 2022 02:59:58 -0400
Received: from mail-vs1-xe29.google.com (mail-vs1-xe29.google.com [IPv6:2607:f8b0:4864:20::e29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77A2A774AF
        for <kvm@vger.kernel.org>; Fri,  8 Jul 2022 23:59:57 -0700 (PDT)
Received: by mail-vs1-xe29.google.com with SMTP id 189so584483vsh.2
        for <kvm@vger.kernel.org>; Fri, 08 Jul 2022 23:59:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=HaPegW27H93Qf4TuxECcq/yCoVA6MfE/QOnVJszZDqA=;
        b=Lkv82oUqjvx4Bsq9AtLaUds17K8rvpLSqlVTwzEriO+7DAVVH66sFzMkvAUGaWd/kU
         gwVuwFKFD88nJ5O4pZoIxtg1lhPUARBkvmy+v0uiswS2j0T/Xs1cWWFlB/Xwm9gKbMF1
         9LdwLGg3eYo0Og81xf32dTXWkZtwvExnAmDmqBZAVLlzXmIR00QcirlEByuOKO4S7OBa
         fNGpR3C8b/A4BfNfDeki405qB7XJhjS746SRczj0m3Vl7i7QR3RAbN26P+vjxsUqvm0d
         /UNbQQIYkbDS/RPA40vb+LVvrsrFohjok+eDSgXFmCXuc2ODIyYBBNzjCrPQ6GtJfIXk
         WTsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HaPegW27H93Qf4TuxECcq/yCoVA6MfE/QOnVJszZDqA=;
        b=IhOXDGNRbXC5NT9ztxdm+AxrBoMepsDOo6oKBIYuphN4mGLQ+Aq2fj2eWjoHOeJ7D+
         T1ap75IklsAcIabiQAdbrJ64cX+qDKLi9HrTCICc1yLFyd2LU9uznPVgzPU7o3rkY04d
         O920uWTFwe9NIM/WzrDHh2GPlPXRCYhoWprt/j9o7FwTFphMfQgm25HpofPvRxTiPB7Y
         LWREDVm/qjddPihJUwVcyQwQnD9tXYTflqC2p0qKuDi6Oy1XWu3amAPi14nnmuqnvORX
         k6DOgrjK7Z9e159KqvF3+ECQ/0aR1V1kcBio91hSLR4/pSlsR5uhLp176mVnWXqvcrNU
         mRFw==
X-Gm-Message-State: AJIora+nvp7TFm57tIJ/BRuiBrBkXOkb37wROLVtBuGTAYVtSKok5ZiN
        vej1PNC9pyNcYyyWdHrfVUwk1ohl5gaJix/d4l0flA==
X-Google-Smtp-Source: AGRyM1siUKjCQ234FL+iWMyc7JxnpRG4THdhKQrLHWHdu6Z5JHZJxU9jxDzxB/Hqk+PLOrefUUydrBpwTKwsKgw61xs=
X-Received: by 2002:a05:6102:cc6:b0:356:3c5c:beb5 with SMTP id
 g6-20020a0561020cc600b003563c5cbeb5mr3066937vst.80.1657349996519; Fri, 08 Jul
 2022 23:59:56 -0700 (PDT)
MIME-Version: 1.0
References: <20220706164304.1582687-1-maz@kernel.org> <20220706164304.1582687-4-maz@kernel.org>
In-Reply-To: <20220706164304.1582687-4-maz@kernel.org>
From:   Reiji Watanabe <reijiw@google.com>
Date:   Fri, 8 Jul 2022 23:59:40 -0700
Message-ID: <CAAeT=Fx0Xr7cGxO64vMUH0uKg1upeOZ3Tvu-1av7ro_+AbTi+g@mail.gmail.com>
Subject: Re: [PATCH 03/19] KVM: arm64: Introduce generic get_user/set_user
 helpers for system registers
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Schspa Shi <schspa@gmail.com>, kernel-team@android.com,
        Oliver Upton <oliver.upton@linux.dev>
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

On Wed, Jul 6, 2022 at 9:43 AM Marc Zyngier <maz@kernel.org> wrote:
>
> The userspace access to the system registers is done using helpers
> that hardcode the table that is looked up. extract some generic
> helpers from this, moving the handling of hidden sysregs into
> the core code.
>
> Signed-off-by: Marc Zyngier <maz@kernel.org>

Reviewed-by: Reiji Watanabe <reijiw@google.com>
