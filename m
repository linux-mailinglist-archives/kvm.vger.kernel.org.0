Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 472AA574450
	for <lists+kvm@lfdr.de>; Thu, 14 Jul 2022 07:10:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234529AbiGNFKd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Jul 2022 01:10:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233914AbiGNFJ5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Jul 2022 01:09:57 -0400
Received: from mail-vk1-xa2e.google.com (mail-vk1-xa2e.google.com [IPv6:2607:f8b0:4864:20::a2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2145F316
        for <kvm@vger.kernel.org>; Wed, 13 Jul 2022 22:09:49 -0700 (PDT)
Received: by mail-vk1-xa2e.google.com with SMTP id s200so331234vkb.8
        for <kvm@vger.kernel.org>; Wed, 13 Jul 2022 22:09:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Fsrr+gGbZwzMH7jOD09M+zhp8VpQAXoxnBERZRz043w=;
        b=R9QMloUW97dlMzqvqBMdu5BzycJJfAIi9YfpP/b6Xrr8QjFxwTF/8HB0KqeOo6v04R
         w7HO9IK80OAqJ+Q5pPo0QMrSHC4DGIOVBmy3+0Xe4jV0O8pZ1X+7iFiA9gX7BF7zQ5og
         fGJPxiEhqa9woCVvbKKVbF9qbDBeRaHsXiwnwInY7TJUD3IYbal4L4sqLZOwfSKzV4JF
         g23WQ80aySnRAhT4tjwwPkHoX6eZagczZnI6qVJeHUnEFBqbi0gZl6ORyRwwxDvWkaBQ
         87NlW2Ct3I3zqnr1LTxpiTICcbGtS5MWazvYSqryx2v3PZL0fKH8qoBySFjHEMvtMODR
         +3+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Fsrr+gGbZwzMH7jOD09M+zhp8VpQAXoxnBERZRz043w=;
        b=KchPTnP2I99fDYvmz1atcFL7qkpHU7DREoeSvN0ITjikI5/00N54pPxYRGr0FPO+QR
         R0G2k61dKxL+qQfkB+PHxLS2MtY3ljhaQlaowwEVBGAgu2wDHWPJRbE0phMUkV5RTvm0
         LTZmv+xVuxCB6iL07GJlaO69abeT9mZgnRn0MibPvha+SSFK23MaFs+GYiS3CNrWQm0E
         D5vMsFl+Iz3c1C6LjzLXeMMWXpGvElUm4/I4k1o8gX5VH52NI8CB/q63GTRfSURxmZWJ
         nQQP5uT4JDXIyLzip/a5iFuqBAjG2SLZnS2PcYs2841bhN78L+YPXravqC1+aOPlFuGq
         r+fw==
X-Gm-Message-State: AJIora906j22Eqq5wYm0SKnJVrTcIJrnOVRV5hlWG7Q78voUFTznYVur
        6ZnJGcwWwCH6NXG86O88/o3azSDjQ4fwoBKLAsFZhQ==
X-Google-Smtp-Source: AGRyM1ujr+x3P8BbldksoSQM5WjDbOY9ekZm+G5kDa0z8Iat+dMt+QF297TxCTU1laSAmRRP9Z+DkyVxudLubmdxBfY=
X-Received: by 2002:a1f:4941:0:b0:373:fffa:730b with SMTP id
 w62-20020a1f4941000000b00373fffa730bmr2819925vka.7.1657775387870; Wed, 13 Jul
 2022 22:09:47 -0700 (PDT)
MIME-Version: 1.0
References: <20220706164304.1582687-1-maz@kernel.org> <20220706164304.1582687-15-maz@kernel.org>
In-Reply-To: <20220706164304.1582687-15-maz@kernel.org>
From:   Reiji Watanabe <reijiw@google.com>
Date:   Wed, 13 Jul 2022 22:09:32 -0700
Message-ID: <CAAeT=Fxar0wfaD-ye958qZy7=vON1R_zhef0RSPH_1VwO6gWPg@mail.gmail.com>
Subject: Re: [PATCH 14/19] KVM: arm64: vgic: Use {get, put}_user() instead of copy_{from.to}_user
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

On Wed, Jul 6, 2022 at 10:05 AM Marc Zyngier <maz@kernel.org> wrote:
>
> Tidy-up vgic_get_common_attr() and vgic_set_common_attr() to use
> {get,put}_user() instead of the more complex (and less type-safe)
> copy_{from,to}_user().
>
> Signed-off-by: Marc Zyngier <maz@kernel.org>

Reviewed-by: Reiji Watanabe <reijiw@google.com>
