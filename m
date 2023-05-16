Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4FF6A7056D8
	for <lists+kvm@lfdr.de>; Tue, 16 May 2023 21:11:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229680AbjEPTLB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 May 2023 15:11:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229558AbjEPTLA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 May 2023 15:11:00 -0400
Received: from mail-oa1-x35.google.com (mail-oa1-x35.google.com [IPv6:2001:4860:4864:20::35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE8154698
        for <kvm@vger.kernel.org>; Tue, 16 May 2023 12:10:55 -0700 (PDT)
Received: by mail-oa1-x35.google.com with SMTP id 586e51a60fabf-192cfb46e75so6881574fac.3
        for <kvm@vger.kernel.org>; Tue, 16 May 2023 12:10:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1684264255; x=1686856255;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Zqs58sW4gz7Qxr9p0LwrMP2HU2Kr50ptesa2SGlRRdM=;
        b=jCdBmbvw7U+fBINBBE4URxTbLtvJ6ZLridZpkCD0cw4IupP3ITcj6BqumhRT1C+0Ib
         3Z94kwLIZJRNEzkksmXrqi5PA/3+CB2Jkr+vLyYuO5m1U6hOfnQS4zRLyR12efrLVp18
         +gNfd7sGbKfJcGdt8eoCW9ChkIqXJxZ9Er/8wVaim1C0ZNXie+KIAuh89HGv1Gj/BpIz
         VLpnZ1mBDQDy/ivn92CfH3rACMGF+H0iehxnFoTyu94S11r4Oo+2/RdbbxuNowjhcQR4
         FGhOgrIhDcP0RPTa1Ao/T/caN7hC2Wo+gxoPnyou7bJaCKYb6PnmJbKJe3wGSqteJlyC
         oJIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684264255; x=1686856255;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Zqs58sW4gz7Qxr9p0LwrMP2HU2Kr50ptesa2SGlRRdM=;
        b=Gohl2C66cp5w6HM8G3qK55bB349egA7cIhS7U/tLaBJfKfIbU5btqCbR7II6M1d3DB
         d39gaLLT+Z8UkdxN/E0pjKrIbO8g1jhsfKm9m/HBJhr1CkpGPKj7EQ3qCpv/776asEH4
         CLBxLKd9L1taFvTAQpn30Ze1bsNRi/NHjxN6ieB1ZuCLHn78kkEHqg4Kv9tekaxdRn8t
         mI8Wl5Bphz2EipIzB+0OUtSufn5ZVjqauCmuNz2/ExJvyybhbBYj2bIJWlK4BNWNB8CQ
         wrTh30z20h3HYr2Kbp+vwModNVT6wKLipqL4lxhwVH77tvLQ2YT0BrYDRGM+/fC9qvva
         AzLQ==
X-Gm-Message-State: AC+VfDxwwdLcn/SIj23YWyNvkbnADUOQk+ScgQ/UWS5w0WXFHnr6Fzbd
        hDobKbHsiJ3ArAQuhNAtiL0sXUrjbTwEh6CJhYyl2A==
X-Google-Smtp-Source: ACHHUZ5fvh8MxPjnfDNG5zT16zq6o0S7SEkQrJADwI0Lll3Qpdk5+EUHbKRrOvA2p9KMQW+Il4S+yOiHRsozatq7BL0=
X-Received: by 2002:a05:6870:37c4:b0:195:65eb:57ba with SMTP id
 p4-20020a05687037c400b0019565eb57bamr15147760oai.11.1684264255002; Tue, 16
 May 2023 12:10:55 -0700 (PDT)
MIME-Version: 1.0
References: <20230503171618.2020461-1-jingzhangos@google.com>
 <20230503171618.2020461-6-jingzhangos@google.com> <87ilcsh8sc.fsf@redhat.com>
In-Reply-To: <87ilcsh8sc.fsf@redhat.com>
From:   Jing Zhang <jingzhangos@google.com>
Date:   Tue, 16 May 2023 12:10:44 -0700
Message-ID: <CAAdAUtj-kzk4utNYezKv-XE7GssvrHLZj04q8Oo_pwMACON2Rw@mail.gmail.com>
Subject: Re: [PATCH v8 5/6] KVM: arm64: Reuse fields of sys_reg_desc for idreg
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     KVM <kvm@vger.kernel.org>, KVMARM <kvmarm@lists.linux.dev>,
        ARMLinux <linux-arm-kernel@lists.infradead.org>,
        Marc Zyngier <maz@kernel.org>,
        Oliver Upton <oupton@google.com>,
        Will Deacon <will@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Fuad Tabba <tabba@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Raghavendra Rao Ananta <rananta@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
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

Hi Cornelia,


On Tue, May 16, 2023 at 3:26=E2=80=AFAM Cornelia Huck <cohuck@redhat.com> w=
rote:
>
> On Wed, May 03 2023, Jing Zhang <jingzhangos@google.com> wrote:
>
> > Since reset() and val are not used for idreg in sys_reg_desc, they woul=
d
> > be used with other purposes for idregs.
> > The callback reset() would be used to return KVM sanitised id register
> > values. The u64 val would be used as mask for writable fields in idregs=
.
> > Only bits with 1 in val are writable from userspace.
> >
> > Signed-off-by: Jing Zhang <jingzhangos@google.com>
> > ---
> >  arch/arm64/kvm/id_regs.c  | 44 +++++++++++++++++++----------
> >  arch/arm64/kvm/sys_regs.c | 59 +++++++++++++++++++++++++++------------
> >  arch/arm64/kvm/sys_regs.h | 10 ++++---
> >  3 files changed, 77 insertions(+), 36 deletions(-)
> >
>
> (...)
>
> > diff --git a/arch/arm64/kvm/sys_regs.h b/arch/arm64/kvm/sys_regs.h
> > index e88fd77309b2..21869319f6e1 100644
> > --- a/arch/arm64/kvm/sys_regs.h
> > +++ b/arch/arm64/kvm/sys_regs.h
> > @@ -65,12 +65,12 @@ struct sys_reg_desc {
> >                      const struct sys_reg_desc *);
> >
> >       /* Initialization for vcpu. */
>
> Maybe be a bit more verbose here?
>
> /* Initialization for vcpu. Return initialized value, or KVM sanitized
>    value for id registers. */
Sure. Thanks.
>
> > -     void (*reset)(struct kvm_vcpu *, const struct sys_reg_desc *);
> > +     u64 (*reset)(struct kvm_vcpu *, const struct sys_reg_desc *);
> >
> >       /* Index into sys_reg[], or 0 if we don't need to save it. */
> >       int reg;
> >
> > -     /* Value (usually reset value) */
> > +     /* Value (usually reset value), or write mask for idregs */
> >       u64 val;
> >
> >       /* Custom get/set_user functions, fallback to generic if NULL */
>
Jing
